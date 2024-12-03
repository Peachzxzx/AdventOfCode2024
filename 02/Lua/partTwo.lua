local count = 0
for line in io.lines("input.txt") do
    local t = {}
    for number in line:gmatch("(%d+)") do
        number = tonumber(number)
        t[#t + 1] = number
    end
    for i = 1, #t do
        local prev = nil
        local sign = nil
        for index, number in ipairs(t) do
            if index == i then
                goto continue
            end
            if prev ~= nil then
                local different = number - prev
                local distance = math.abs(different)
                if distance < 1 or distance > 3 then
                    goto exit
                end
                if sign == nil then
                    sign = different > 0
                elseif sign ~= (different > 0) then
                    goto exit
                end
            end
            prev = number
            ::continue::
        end
        do
            count = count + 1
            break
        end
        ::exit::
    end
end
print(count)
