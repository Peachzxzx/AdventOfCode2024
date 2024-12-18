local sortedList = {
    create = function(self)
        self = setmetatable({
            first = 1,
            last = 1
        }, self)
        return self
    end,
    size = function(self)
        return self.last - self.first
    end,
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
    end,
    popHead = function(self)
        local x = self[self.first]
        self.first = self.first + 1
        return x
    end
}
sortedList.__index = sortedList
local row, col = 71, 71
local map = {}
local seen = {}
for i = 1, row do
    map[i] = {}
    seen[i] = {}
    for j = 1, col do
        map[i][j] = "."
        seen[i][j] = false
    end
end
local cqueue = sortedList:create()
cqueue.insertLast = function(self, item)
    self[self.last] = item
    self.last = self.last + 1
end
for line in io.lines("input.txt") do
    local y, x = string.match(line, "(%d+),(%d+)")
    x = tonumber(x)
    y = tonumber(y)
    cqueue:insertLast({ x + 1, y + 1 })
end

local function resetseen()
    for _, v in ipairs(seen) do
        for j, _ in ipairs(v) do
            v[j] = false
        end
    end
end

local function bfs(sx, sy)
    local queue = sortedList:create()
    queue:insertLast({ sx, sy, 0 })
    local dir4 = { { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }
    while queue:size() > 0 do
        local x, y, cost = unpack(queue:popHead())
        if x < 1 or x > row or y < 1 or y > col or seen[x][y] or map[x][y] == "#" then
            goto continue
        end
        if x == row and y == col then
            return cost
        end
        seen[x][y] = true
        for _, d in ipairs(dir4) do
            local dx, dy = unpack(d)

            queue:insertLast({ x + dx, y + dy, cost + 1 }, function(a, b)
                return a[3] < b[3]
            end)
        end

        ::continue::
    end
    return math.huge
end

while cqueue:size() > 0 do
    local x, y = unpack(cqueue:popHead())
    resetseen()
    map[x][y] = '#'
    if bfs(1, 1) == math.huge then
        print((y - 1) .. "," .. (x - 1))
        break
    end
end
