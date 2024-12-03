local sum = 0
for line in io.lines("input.txt") do
    local isEnable = true
    while #line > 3 do
        if string.find(line, "^do%(%)") then
            isEnable = true
        elseif string.find(line, "^don't%(%)") then
            isEnable = false
        elseif isEnable and string.find(line, "^mul%((%d+),(%d+)%)") then
            local number1, number2 = string.match(line, "^mul%((%d+),(%d+)%)")
            number1 = tonumber(number1)
            number2 = tonumber(number2)
            
            sum = sum + (number1 * number2)
        end
        line = string.sub(line, 2)
    end
end
print(sum)
