local newblock = function(id, size)
    return { id = id, empty = false, size = size }
end
local emptyblock = function(size)
    return { empty = true, size = size }
end

local diskmap = {}
local mode = true
local count = 0
for line in io.lines("input.txt") do
    for number in string.gmatch(line, ".") do
        local size = tonumber(number)
        for i = size, 1, -1 do
            if mode then
                diskmap[#diskmap + 1] = newblock(count, size)
            else
                diskmap[#diskmap + 1] = emptyblock(i)
            end
        end
        mode = mode ~= true
        if mode then
            count = count + 1
        end
    end
end

for id = count, 0, -1 do
    local leftpointer = 1
    local rightpointer = #diskmap

    repeat
        while leftpointer < rightpointer do
            if diskmap[rightpointer].empty or diskmap[rightpointer].id ~= id then
                rightpointer = rightpointer - 1
            else
                break
            end
        end
        local needsize = diskmap[rightpointer].size
        while leftpointer < rightpointer do
            if diskmap[leftpointer].empty and diskmap[leftpointer].size >= needsize then
                break
            end
            leftpointer = leftpointer + 1
        end
        if leftpointer < rightpointer then
            repeat
                diskmap[leftpointer] = diskmap[rightpointer]
                diskmap[rightpointer] = emptyblock(1)
                leftpointer = leftpointer + 1
                rightpointer = rightpointer - 1
                needsize = needsize - 1
            until needsize == 0 or leftpointer >= rightpointer
            leftpointer = 1
        end
    until leftpointer >= rightpointer
end

local ans = 0
for index, value in ipairs(diskmap) do
    if not value.empty then
        ans = ans + (index - 1) * value.id
    end
end
print(ans)
