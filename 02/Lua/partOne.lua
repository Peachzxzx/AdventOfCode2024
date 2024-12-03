local count = 0
for line in io.lines("input.txt") do
    local prev = nil
    local sign = nil
    for number in line:gmatch("(%d+)") do
        number = tonumber(number)
        if prev ~= nil then
            local different = number - prev
            local distance = math.abs(different)
            if distance < 1 or distance > 3 then
                goto continue
            end
            if sign == nil then
                sign = different > 0
            elseif sign ~= (different > 0) then
                goto continue
            end
        end
        prev = number
    end
    count = count + 1
    ::continue::
end
print(count)
