local sum = 0
local linkedList = {}

local function addlist(val, next)
    if linkedList[val] == nil then
        linkedList[val] = {}
    end
    linkedList[val][next] = true
end

local function correct(page)
    for i = 1, #page - 1 do
        for j = i + 1, #page do
            if
                (linkedList[page[j]] and linkedList[page[j]][page[i]] == true)
                or (linkedList[page[i]] and linkedList[page[i]][page[j]] ~= true)
            then
                return false
            end
        end
    end
    return true
end

local state = 0
for line in io.lines("input.txt") do
    if line == "" then
        state = 1
        goto continue
    end

    if state == 0 then
        local a, b = line:match("(%d+)|(%d+)")
        addlist(tonumber(a), tonumber(b))
    else
        local page = {}
        for pageorder in line:gmatch("(%d+)") do
            page[#page + 1] = tonumber(pageorder)
        end
        if correct(page) then
            sum = sum + tonumber(page[(#page + 1) / 2])
        end
    end
    ::continue::
end

print(sum)
