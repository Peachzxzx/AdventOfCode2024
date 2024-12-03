local sum = 0
for line in io.lines("input.txt") do
    for number1, number2 in line:gmatch("mul%((%d+),(%d+)%)") do
        number1 = tonumber(number1)
        number2 = tonumber(number2)

        sum = sum + (number1 * number2)
    end
end
print(sum)
