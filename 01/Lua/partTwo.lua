local leftList = {}
local rightList = {}
local sum = 0

for line in io.lines("input.txt") do
    for leftNumber, rightNumber in line:gmatch("(%d+)%s+(%d+)") do
        leftNumber = tonumber(leftNumber)
        rightNumber = tonumber(rightNumber)
        leftList[leftNumber] = leftList[leftNumber] and leftList[leftNumber] + 1 or 1
        rightList[rightNumber] = rightList[rightNumber] and rightList[rightNumber] + 1 or 1
    end
end

for key, value in pairs(leftList) do
    sum = sum + (key * value * (rightList[key] and rightList[key] or 0))
end

print(sum)
