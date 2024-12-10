local newblock = function(id)
    return { id = id, empty = false }
end
local emptyblock = { empty = true }

local diskmap = {}
local mode = true
local count = 0
for line in io.lines("input.txt") do
    for number in string.gmatch(line, ".") do
        local size = tonumber(number)
        for i = size, 1, -1 do
            if mode then
                diskmap[#diskmap + 1] = newblock(count)
            else
                diskmap[#diskmap + 1] = emptyblock
            end
        end
        mode = mode ~= true
        if mode then
            count = count + 1
        end
    end
end

local leftpointer = 1
local rightpointer = #diskmap

repeat
    while leftpointer < rightpointer do
        if diskmap[rightpointer].empty then
            rightpointer = rightpointer - 1
        else
            break
        end
    end
    while leftpointer < rightpointer do
        if diskmap[leftpointer].empty then
            break
        end
        leftpointer = leftpointer + 1
    end
    if leftpointer < rightpointer then
        diskmap[leftpointer] = diskmap[rightpointer]
        diskmap[rightpointer] = emptyblock
    end
until leftpointer >= rightpointer

local ans = 0
for index, value in ipairs(diskmap) do
    if value.empty then
        break
    else
        ans = ans + (index - 1) * value.id
    end
end
print(ans)
