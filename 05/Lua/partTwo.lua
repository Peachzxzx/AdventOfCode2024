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

local function sort(t)
    if #t == 1 then
        return t
    end
    for i = 1, #t do
        local main = t[i]
        for j = 1, #t do
            if i ~= j then
                if
                    (linkedList[main] and linkedList[main][t[j]] ~= true)
                    or (linkedList[t[j]] and linkedList[t[j]][main] == true)
                then
                    goto continue
                end
            end
        end
        do
            local temppage = {}
            for j = 1, #t do
                if i ~= j then
                    temppage[#temppage + 1] = t[j]
                end
            end
            local newpage = sort(temppage)
            if newpage == nil then
                goto continue
            end
            table.insert(newpage, t[i])
            return newpage
        end
        ::continue::
    end
    return nil
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
            goto continue
        end
        page = sort(page)
        if page ~= nil then
            sum = sum + tonumber(page[(#page + 1) / 2])
        end
    end
    ::continue::
end

print(sum)
