local map = {}
local index = 1
local sx, sy
for line in io.lines("input.txt") do
    map[index] = {}
    for i = 1, #line do
        local c = string.sub(line, i, i)
        map[index][#map[index] + 1] = c
        if c == "^" then
            sx = index
            sy = #map[index]
        end
    end
    index = index + 1
end

local pass = {}
for i = 1, #map do
    pass[i] = {}
    for j = 1, #map[1] do
        pass[i][j] = false
    end
end

local px = sx
local py = sy
local dir = 'N'
local function changeDir()
    if dir == 'N' then
        dir = 'E'
    elseif dir == 'E' then
        dir = 'S'
    elseif dir == 'S' then
        dir = 'W'
    elseif dir == 'W' then
        dir = 'N'
    end
end

local vector = { N = { -1, 0 }, E = { 0, 1 }, S = { 1, 0 }, W = { 0, -1 } }
local unpack = unpack or table.unpack
local dx, dy = unpack(vector[dir])
repeat
    pass[px][py] = true
    if map[px + dx] ~= nil and map[px + dx][py + dy] == '#' then
        changeDir()
        dx, dy = unpack(vector[dir])
    else
        px = px + dx
        py = py + dy
    end
until px > #map or px < 1 or py > #map[1] or py < 1

local count = 0
for i = 1, #pass do
    for j = 1, #pass[1] do
        if pass[i][j] then
            count = count + 1
        end
    end
end
print(count)
