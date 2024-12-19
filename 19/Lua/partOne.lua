local towels = {}
local lines = io.lines("input.txt")
for towel in string.gmatch(lines(), "([^,%s]+)") do
    towels[towel] = true
end
lines()

local function solve(left)
    if left == "" then
        return true
    end

    for towel, _ in pairs(towels) do
        if towel == string.sub(left, 1, #towel) then
            if solve(string.sub(left, 1 + #towel)) then
                return true
            end
        end
    end

    return false
end

local count = 0
for line in lines do
    if solve(line) then
        count = count + 1
    end
end

print(count)
