---@class queuefactory
local queuefactory = {
    ---@class queue
    ---@field size integer
    class = {
        ---@param self queue
        ---@param value any
        push = function(self, value)
            self.size = self.size + 1
            self[self.size] = value
        end,
        ---@param self queue
        ---@return any?
        pop = function(self)
            local size = self.size
            if size <= 0 then
                return nil
            else
                size = self[size]
                self.size = self.size - 1
                return size
            end
        end
    },
    ---@param self queuefactory
    ---@return queue
    new = function(self)
        return setmetatable({ size = 0 }, self.meta)
    end
}
queuefactory.meta = { __index = queuefactory.class }

---@class coordinatefactory
local coordinatefactory = {
    ---@param self coordinatefactory
    ---@param x number
    ---@param y number
    ---@return coordinate
    new = function(self, x, y)
        return setmetatable({ x = x, y = y }, self.index)
    end,
    ---@class coordinate
    ---@field x number
    ---@field y number
    class = {}
}
coordinatefactory.index = {
    __index = coordinatefactory.class,
    ---@param self coordinate
    ---@param position coordinate
    ---@return coordinate
    __add = function(self, position)
        return coordinatefactory:new(self.x + position.x, self.y + position.y)
    end
}

local map = {}
local seen = {}
---@type coordinate[]
local startposition = {}
local row, col = 1, 1
for line in io.lines("input.txt") do
    col = 1
    map[row] = {}
    seen[row] = {}
    for c in string.gmatch(line, ".") do
        if c == '.' then
            c = '-1'
        end
        map[row][col] = tonumber(c)
        seen[row][col] = false
        if c == '0' then
            startposition[#startposition + 1] = coordinatefactory:new(row, col)
        end
        col = col + 1
    end
    row = row + 1
end
row = row - 1
col = col - 1

local function resetmap()
    for i = 1, row do
        for j = 1, col do
            seen[i][j] = false
        end
    end
end

---@param position coordinate
---@return integer
local function bfs(position)
    local count = 0
    local queue = queuefactory:new()
    queue:push(position)
    while queue.size > 0 do
        ---@type coordinate
        local pos = queue:pop()
        seen[pos.x][pos.y] = true
        if map[pos.x][pos.y] == 9 then
            count = count + 1
        else
            for _, dir in ipairs { coordinatefactory:new(-1, 0), coordinatefactory:new(0, 1), coordinatefactory:new(1, 0), coordinatefactory:new(0, -1) } do
                ---@type coordinate
                local newpos = pos + dir
                if 1 <= newpos.x and newpos.x <= row and 1 <= newpos.y and newpos.y <= col then
                    if not seen[newpos.x][newpos.y] and map[newpos.x][newpos.y] - map[pos.x][pos.y] == 1 then
                        queue:push(newpos)
                    end
                end
            end
        end
    end
    return count
end

local sum = 0
for _, position in ipairs(startposition) do
    resetmap()
    sum = sum + bfs(position)
end
print(sum)
