local map = {}
local row, col = 1, 1
local state = 1
local instruction = {}
local sx, sy = 1, 1
local seen = {}
local expandmap = { ['@'] = { '@', '.' }, ['#'] = { '#', '#' }, ['O'] = { '[', ']' }, ['.'] = { '.', '.' } }

for line in io.lines("input.txt") do
    if line == "" then
        state = 2
    elseif state == 1 then
        col = 1
        map[row] = {}
        seen[row] = {}
        for c in string.gmatch(line, ".") do
            if c == "@" then
                sx = row
                sy = col
            end
            for _, value in ipairs(expandmap[c]) do
                map[row][col] = value
                seen[row][col] = false
                col = col + 1
            end
        end
        row = row + 1
    else
        for c in string.gmatch(line, ".") do
            instruction[#instruction + 1] = c
        end
    end
end
row = row - 1
col = col - 1

local unpack = unpack or table.unpack
local dir4 = { ["^"] = { -1, 0 }, [">"] = { 0, 1 }, ["v"] = { 1, 0 }, ["<"] = { 0, -1 } }
local movequeue = {}
local function move(px, py, dx, dy)
    local c = map[px][py]
    if c == "#" then
        return false
    elseif c == "." then
        return true
    end
    if seen[px][py] then
        return true
    end
    seen[px][py] = true
    local nx = px + dx
    local ny = py + dy
    local ismoved = move(nx, ny, dx, dy)
    if dx ~= 0 then
        if c == "[" then
            ismoved = ismoved and move(px, py + 1, dx, dy)
        elseif c == "]" then
            ismoved = ismoved and move(px, py - 1, dx, dy)
        end
    end
    if ismoved then
        movequeue[#movequeue + 1] = { px, py }
    end
    return ismoved
end

local function getrock()
    return coroutine.wrap(function()
        for i = 1, row do
            for j = 1, col do
                if map[i][j] == "[" then
                    coroutine.yield(i, j)
                end
            end
        end
    end)
end

local function resetmap()
    for _, c in ipairs(seen) do
        for j, _ in ipairs(c) do
            c[j] = false
        end
    end
end

for _, ins in ipairs(instruction) do
    local dx, dy = unpack(dir4[ins])
    if move(sx, sy, dx, dy) then
        sx = sx + dx
        sy = sy + dy
        while #movequeue > 0 do
            local x, y = unpack(table.remove(movequeue, 1))
            map[x + dx][y + dy] = map[x][y]
            map[x][y] = "."
        end
    else
        movequeue = {}
    end
    resetmap()
end

local sum = 0
for x, y in getrock() do
    sum = sum + 100 * (x - 1) + (y - 1)
end
print(sum)
