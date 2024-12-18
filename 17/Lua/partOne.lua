local program = {}
local pointer = 0
local count = 0
local register = { A = 0, B = 0, C = 0 }
local operand = setmetatable(
    {},
    {
        __index = function(t, k)
            if k == 4 then
                return register.A
            elseif k == 5 then
                return register.B
            elseif k == 6 then
                return register.C
            else
                return k
            end
        end
    })
local display = {}
local function dv(num)
    return math.floor(register.A / (2 ^ num))
end
local instruction = {
    [0] = function(literal)
        local combo = operand[literal]
        register.A = dv(combo)
    end,
    [1] = function(literal)
        register.B = bit.bxor(register.B, literal)
    end,
    [2] = function(literal)
        local combo = operand[literal]
        register.B = combo % 8
    end,
    [3] = function(literal)
        if register.A ~= 0 then
            pointer = literal
            return true
        end
    end,
    [4] = function(literal)
        register.B = bit.bxor(register.B, register.C)
    end,
    [5] = function(literal)
        local combo = operand[literal]
        display[#display + 1] = combo % 8
    end,
    [6] = function(literal)
        local combo = operand[literal]
        register.B = dv(combo)
    end,
    [7] = function(literal)
        local combo = operand[literal]
        register.C = dv(combo)
    end
}
local readline = io.lines("input.txt")
register.A = tonumber(readline():match("(-?%d+)"))
register.B = tonumber(readline():match("(-?%d+)"))
register.C = tonumber(readline():match("(-?%d+)"))
readline()
for num in readline():gmatch("(%d+)") do
    program[count] = tonumber(num)
    count = count + 1
end
readline()

while pointer < count do
    local opcode, literal = program[pointer], program[pointer + 1]
    if not instruction[opcode](literal) then
        pointer = pointer + 2
    end
end
print(table.concat(display, ","))
