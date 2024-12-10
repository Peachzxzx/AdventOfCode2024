local antenna = {}
local row = 1
local col = 1
for line in io.lines("input.txt") do
    col = 1
    for c in string.gmatch(line, ".") do
        if c ~= "." then
            if antenna[c] == nil then
                antenna[c] = {}
            end
            antenna[c][#antenna[c] + 1] = { row, col }
        end
        col = col + 1
    end
    row = row + 1
end
row = row - 1
col = col - 1

local antinode = {}
local unpack = unpack or table.unpack
for _, locations in pairs(antenna) do
    for index1, location1 in ipairs(locations) do
        local x1, y1 = unpack(location1)
        for index2, location2 in ipairs(locations) do
            if index1 == index2 then
                goto continue
            end
            local x2, y2 = unpack(location2)
            local dx, dy = x2 - x1, y2 - y1
            local nx, ny = x2 + dx, y2 + dy
            if 1 <= nx and nx <= row and 1 <= ny and ny <= col then
                if antinode[nx] == nil then
                    antinode[nx] = {}
                end
                antinode[nx][ny] = true
            end
            ::continue::
        end
    end
end

local count = 0
for _, locations in pairs(antinode) do
    for _, _ in pairs(locations) do
        count = count + 1
    end
end

print(count)
