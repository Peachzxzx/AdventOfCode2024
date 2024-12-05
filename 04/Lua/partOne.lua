local count = 0
local map = {}
local index = 1
local dir = {
    { { 0, 0 }, { -1, 0 },  { -2, 0 },  { -3, 0 } },  -- N
    { { 0, 0 }, { -1, 1 },  { -2, 2 },  { -3, 3 } },  -- NE
    { { 0, 0 }, { 0, 1 },   { 0, 2 },   { 0, 3 } },   -- E
    { { 0, 0 }, { 1, 1 },   { 2, 2 },   { 3, 3 } },   -- SE
    { { 0, 0 }, { 1, 0 },   { 2, 0 },   { 3, 0 } },   -- S
    { { 0, 0 }, { 1, -1 },  { 2, -2 },  { 3, -3 } },  -- SW
    { { 0, 0 }, { 0, -1 },  { 0, -2 },  { 0, -3 } },  -- W
    { { 0, 0 }, { -1, -1 }, { -2, -2 }, { -3, -3 } }, -- NW
}

for line in io.lines("input.txt") do
    map[index] = {}
    for i = 1, #line do
        map[index][#map[index] + 1] = string.sub(line, i, i)
    end
    index = index + 1
end

for i = 1, #map do
    for j = 1, #map[i] do
        for _, v in ipairs(dir) do
            local str = ""
            for _, d in ipairs(v) do
                local x, y = d[1], d[2]
                local row = map[i + x]
                if row == nil then
                    goto continue
                end
                local char = map[i + x][j + y]
                if char == nil or char == '.' then
                    goto continue
                end
                str = str .. char
            end
            if str == "XMAS" then
                count = count + 1
            end
            ::continue::
        end
    end
end
print(count)
