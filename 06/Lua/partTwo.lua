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

local function changeDir(dir)
    if dir == 'N' then
        return 'E'
    elseif dir == 'E' then
        return 'S'
    elseif dir == 'S' then
        return 'W'
    elseif dir == 'W' then
        return 'N'
    end
end

local vector = { N = { -1, 0 }, E = { 0, 1 }, S = { 1, 0 }, W = { 0, -1 } }
local unpack = unpack or table.unpack
local function getpath(px, py)
    local dir = 'N'
    local dx, dy = unpack(vector[dir])
    return coroutine.wrap(function()
        repeat
            if map[px + dx] ~= nil and map[px + dx][py + dy] == '#' then
                dir = changeDir(dir)
                dx, dy = unpack(vector[dir])
            else
                px = px + dx
                py = py + dy
            end
            coroutine.yield(px, py, dir)
        until px > #map or px < 1 or py > #map[1] or py < 1
    end)
end

local stack = {}
for px, py, pdir in getpath(sx, sy) do
    stack[#stack + 1] = { px, py, pdir }
end
stack[#stack] = nil

local count = 0
repeat
    local rx, ry = unpack(stack[#stack])
    stack[#stack] = nil
    if pass[rx][ry] == false then
        local old = map[rx][ry]
        map[rx][ry] = '#'
        local slowiter = getpath(sx, sy)
        local fastiter = getpath(sx, sy)
        while true do
            local slx, sly, sldir = slowiter()
            if slx == nil then
                break
            end
            local fx, fy, fdir = fastiter()
            if fx == nil then
                break
            end
            fx, fy, fdir = fastiter()
            if fx == nil then
                break
            end
            if slx == fx and sly == fy and sldir == fdir then
                count = count + 1
                break
            end
        end
        pass[rx][ry] = true
        map[rx][ry] = old
    end
until #stack == 0

print(count)
