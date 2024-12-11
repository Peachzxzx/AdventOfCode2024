local stonelist = {}
for line in io.lines("input.txt") do
    for number in string.gmatch(line, "%d+") do
        stonelist[#stonelist + 1] = number
    end
end

local memo = {}
local function dynamic(stone, round)
    if round == 0 then
        return 1
    end
    if memo[stone] == nil then
        memo[stone] = {}
    end
    if memo[stone][round] == nil then
        local length = #stone
        if tonumber(stone) == 0 then
            memo[stone][round] = dynamic("1", round - 1)
        elseif length % 2 == 0 then
            memo[stone][round] = dynamic(tostring(tonumber(string.sub(stone, 1, length / 2))), round - 1)
                + dynamic(tostring(tonumber(string.sub(stone, length / 2 + 1, length))), round - 1)
        else
            memo[stone][round] = dynamic(tostring(tonumber(stone) * 2024), round - 1)
        end
    end
    return memo[stone][round]
end

local sum = 0
for _, stone in ipairs(stonelist) do
    sum = sum + dynamic(stone, 75)
end

print(string.format("%.f", sum))
