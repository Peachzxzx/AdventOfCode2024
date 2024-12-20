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

local priorityqueue
do
    ---@class priorityqueue: queue
    priorityqueue = {
        ---@return nil
        insertLast = function(self, item, compFunc)
            compFunc = compFunc or function(a, b)
                return a < b
            end
            local temp = item
            for i = self.first, self.last - 1 do
                if compFunc(item, self[i]) then
                    temp = self[i]
                    self[i] = item
                    item = temp
                end
            end
            self[self.last] = temp
            self.last = self.last + 1
        end
    }
    ---@return priorityqueue
    priorityqueue.create = function()
        ---@type priorityqueue
        return setmetatable(queue:create(), {
            __index = priorityqueue
        })
    end

    ---@type priorityqueue
    priorityqueue = setmetatable(priorityqueue, {
        __index = queue,
        __call = priorityqueue.create
    })
end

local map = {}
local seen = {}
local sx, sy = 1, 1
local ex, ey = 1, 1
local row, col = 1, 1
for line in io.lines("input.txt") do
    local maprow = {}
    local seenrow = {}
    col = 1
    for c in string.gmatch(line, ".") do
        maprow[col] = c
        seenrow[col] = false
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
    seen[row] = seenrow
    row = row + 1
end

local dir4 = { { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }
local unpack = unpack or table.unpack
local function bfs(x, y)
    local q = priorityqueue:create()
    q:insertLast({ x, y, 0 })
    while q:size() > 0 do
        local px, py, pc = unpack(q:popHead())
        if 0 < px and px < row and 0 < py and py < col then
            if seen[px][py] or map[px][py] == "#" then
                goto continue
            end
            seen[px][py] = true

            if px == ex and py == ey then
                return pc
            end

            for _, d in ipairs(dir4) do
                local dx, dy = unpack(d)
                q:insertLast({ px + dx, py + dy, pc + 1 }, function(a, b)
                    return a[3] < b[3]
                end)
            end
        end
        ::continue::
    end
end

local function reset()
    for _, seenrow in ipairs(seen) do
        for columnindex, _ in ipairs(seenrow) do
            seenrow[columnindex] = false
        end
    end
end

local count = 0
local nocheatdistance = bfs(sx, sy)
for _, rowmap in ipairs(map) do
    for columnindex, c in ipairs(rowmap) do
        if c == "#" then
            reset()
            rowmap[columnindex] = "."
            if nocheatdistance - bfs(sx, sy) >= 100 then
                count = count + 1
            end
            rowmap[columnindex] = "#"
        end
    end
end
print(count)
