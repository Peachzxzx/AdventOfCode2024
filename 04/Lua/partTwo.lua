local count = 0
local map = {}
local index = 1
local dir = {
    { { -1, -1 }, { 0, 0 }, { 1, 1 } },   -- NW -> SE
    { { 1, 1 },   { 0, 0 }, { -1, -1 } }, -- SE -> NW
    { { -1, 1 },  { 0, 0 }, { 1, -1 } },  -- NE -> SW
    { { 1, -1 },  { 0, 0 }, { -1, 1 } },  -- SW -> NE
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
        local subcount = 0
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
            if str == "MAS" then
                subcount = subcount + 1
            end
            if subcount > 1 then
                count = count + 1
                break
            end
            ::continue::
        end
    end
end
print(count)
