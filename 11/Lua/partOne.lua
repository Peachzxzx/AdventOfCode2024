local stonelist = {}
for line in io.lines("input.txt") do
    for number in string.gmatch(line, "%d+") do
        stonelist[#stonelist + 1] = number
    end
end

for i = 1, 25 do
    local newstonelist = {}
    for _, stone in ipairs(stonelist) do
        local length = #stone
        if tonumber(stone) == 0 then
            newstonelist[#newstonelist + 1] = "1"
        elseif length % 2 == 0 then
            newstonelist[#newstonelist + 1] = tostring(tonumber(string.sub(stone, 1, length / 2)))
            newstonelist[#newstonelist + 1] = tostring(tonumber(string.sub(stone, length / 2 + 1, length)))
        else
            newstonelist[#newstonelist + 1] = tostring(tonumber(stone) * 2024)
        end
    end
    stonelist = newstonelist
end

print(#stonelist)
