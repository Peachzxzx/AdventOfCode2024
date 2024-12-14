local machines = {}
local state = 1
local machine = { a = nil, b = nil, c = nil }
local x, y = 0, 0
for line in io.lines("input.txt") do
    if state == 4 then
        state = 1
    else
        x, y = string.match(line, "(%d+), Y[+=](%d+)$")
        x, y = tonumber(x), tonumber(y)
        if state == 1 then
            machine.a = { x = x, y = y }
        elseif state == 2 then
            machine.b = { x = x, y = y }
        elseif state == 3 then
            machine.c = { x = x + 10000000000000, y = y + 10000000000000 }
            machines[#machines + 1] = machine
            machine = { a = nil, b = nil, c = nil }
        end
        state = state + 1
    end
end

local function solve(a, b, target)
    local A = (target.x * b.y - target.y * b.x) / (a.x * b.y - a.y * b.x)
    local B = (target.x * a.y - target.y * a.x) / (b.x * a.y - b.y * a.x)
    return A, B
end

local sum = 0
for _, value in ipairs(machines) do
    local a, b = solve(value.a, value.b, value.c)
    if a == math.floor(a) and b == math.floor(b) then
        sum = sum + a * 3 + b
    end
end
print(sum)
