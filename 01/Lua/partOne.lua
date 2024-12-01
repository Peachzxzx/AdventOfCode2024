local leftList = {}
local rightList = {}
local sum = 0

for line in io.lines("input.txt") do
    for leftNumber, rightNumber in line:gmatch("(%d+)%s+(%d+)") do
        leftList[#leftList + 1] = tonumber(leftNumber)
        rightList[#rightList + 1] = tonumber(rightNumber)
    end
end

table.sort(leftList)
table.sort(rightList)

for i = 1, #leftList do
    sum = sum + math.abs(leftList[i] - rightList[i])
end

print(sum)
