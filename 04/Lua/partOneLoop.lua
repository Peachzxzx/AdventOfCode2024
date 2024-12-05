local count = 0
local map = {}
local index = 1

for line in io.lines("input.txt") do
    map[index] = {}
    for i = 1, #line do
        map[index][#map[index] + 1] = string.sub(line, i, i)
    end
    index = index + 1
end

for i = 1, #map do
    for j = 1, #map[i] do
        for _, d in ipairs {
            { -1, 0 },  -- N
            { -1, 1 },  -- NE
            { 0,  1 },  -- E
            { 1,  1 },  -- SE
            { 1,  0 },  -- S
            { 1,  -1 }, -- SW
            { 0,  -1 }, -- W
            { -1, -1 }  -- NW
        } do
            local x, y = d[1], d[2]
            local str = ""
            for k = 0, 3 do
                local row = map[i + x * k]
                if row == nil then
                    goto continue
                end
                local char = map[i + x * k][j + y * k]
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
