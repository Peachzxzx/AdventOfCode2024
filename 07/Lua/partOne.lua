local function revaluate(numberlist, want, now)
    if #numberlist == 0 then
        return want == now
    end

    local num = numberlist[1]
    table.remove(numberlist, 1)
    if revaluate(numberlist, want, now + num)
        or revaluate(numberlist, want, now * num)
    then
        return true
    end

    table.insert(numberlist, 1, num)
end

local sum = 0
for line in io.lines("input.txt") do
    local want, first, rest = line:match("(%d+): (%d+) (.+)")
    want = tonumber(want)
    first = tonumber(first)
    local numberlist = {}
    for number in string.gmatch(rest, "(%d+)") do
        numberlist[#numberlist + 1] = tonumber(number)
    end
    if revaluate(numberlist, want, first) then
        sum = sum + want
    end
end
print(sum)
