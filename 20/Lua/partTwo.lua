local queue
do
    ---@class queue
    queue = {
        ---@return integer
        size = function(self)
            return self.last - self.first
        end,
        ---@return nil
        insertLast = function(self, item)
            self[self.last] = item
            self.last = self.last + 1
        end,
        ---@return any?
        popHead = function(self)
            local x = self[self.first]
            if self.first ~= self.last then
                self.first = self.first + 1
            end
            return x
        end,
        ---@return boolean
        isempty = function(self)
            return self:size() == 0
        end

    }
    ---@return queue
    queue.create = function()
        return setmetatable({
            first = 0,
            last = 0
        }, {
            __index = queue
        })
    end

    queue = setmetatable(queue, {
        __call = queue.create
    })
end

local map = {}
local distance = {}
local sx, sy = 1, 1
local ex, ey = 1, 1
local row, col = 1, 1
for line in io.lines("input.txt") do
    local maprow = {}
    local distancerow = {}
    col = 1
    for c in string.gmatch(line, ".") do
        maprow[col] = c
        distancerow[col] = math.huge
        if c == "S" then
            sx = row
            sy = col
        elseif c == "E" then
            ex = row
            ey = col
        end
        col = col + 1
    end
    map[row] = maprow
    distance[row] = distancerow
    row = row + 1
end

local dir4 = { { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }
local unpack = unpack or table.unpack
local function bfs(x, y)
    local q = queue:create()
    q:insertLast({ x, y, 0 })
    while q:size() > 0 do
        local px, py, pc = unpack(q:popHead())
        if 0 < px and px < row and 0 < py and py < col then
            if distance[px][py] < pc or map[px][py] == "#" then
                goto continue
            end
            distance[px][py] = pc

            if px == ex and py == ey then
                return pc
            end

            for _, d in ipairs(dir4) do
                local dx, dy = unpack(d)
                q:insertLast({ px + dx, py + dy, pc + 1 })
            end
        end
        ::continue::
    end
end

local count = 0
local cheatdistance = 20
local savedistance = 100
local q = queue:create()
q:insertLast({ sx, sy, 0 })
bfs(sx, sy)
while q:size() > 0 do
    local px, py, pd = unpack(q:popHead())
    if distance[px][py] ~= pd then
        goto continue
    end
    if 0 < px and px < row and 0 < py and py < col and distance[px][py] == pd then
        for dx = -cheatdistance, cheatdistance do
            for dy = -cheatdistance, cheatdistance do
                local md = math.abs(dx) + math.abs(dy)
                if (dx == 0 and dy == 0) or md > cheatdistance then
                    goto continue
                end

                local tx = px + dx
                local ty = py + dy
                if 0 < tx and tx < row and 0 < ty and ty < col then
                    if distance[tx][ty] ~= math.huge and savedistance <= distance[tx][ty] - pd - md then
                        count = count + 1
                    end
                end
                ::continue::
            end
        end
    end

    for _, d in ipairs(dir4) do
        local dx, dy = unpack(d)
        q:insertLast({ px + dx, py + dy, pd + 1 })
    end
    ::continue::
end
print(count)
