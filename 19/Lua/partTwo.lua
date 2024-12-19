local towels = {}
local lines = io.lines("input.txt")
for towel in string.gmatch(lines(), "([^,%s]+)") do
    towels[towel] = true
end
lines()

local memo = {}
local function solve(left)
    if left == "" then
        return 1
    elseif memo[left] then
        return memo[left]
    end

    local count = 0
    for towel, _ in pairs(towels) do
        if towel == string.sub(left, 1, #towel) then
            count = count + solve(string.sub(left, 1 + #towel))
        end
    end

    memo[left] = count
    return count
end

local count = 0
for line in lines do
    count = count + solve(line)
end

print(string.format("%.f", count))
