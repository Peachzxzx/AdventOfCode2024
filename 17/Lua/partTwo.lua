local program = {}

local count = 0
local register = { A = 0, B = 0, C = 0 }
local readline = io.lines("input.txt")
--- add 0ULL because LuaJIT bit module treat lua number as 32 bit number 
register.A = 0ULL + tonumber(readline():match("(-?%d+)"))
register.B = 0ULL + tonumber(readline():match("(-?%d+)"))
register.C = 0ULL + tonumber(readline():match("(-?%d+)"))
readline()
for num in readline():gmatch("(%d+)") do
    program[count] = tonumber(num)
    count = count + 1
end
readline()

local function solve(ax, programpointer)
    if programpointer == -1 then
        return ax
    end

    for i = 0, 7 do
        local a = bit.bor(bit.lshift(ax, 3), i)
        local b = register.B
        local c = register.C
        local operand = setmetatable(
            {},
            {
                __index = function(t, k)
                    if k == 4 then
                        return a
                    elseif k == 5 then
                        return b
                    elseif k == 6 then
                        return c
                    else
                        return k
                    end
                end
            })
        local function dv(num)
            return bit.rshift(a, num)
        end
        for pointer = 0, count - 3, 2 do
            local opcode, literal = program[pointer], program[pointer + 1]
            local combo = operand[literal]

            if opcode == 0 then
            elseif opcode == 1 then
                b = bit.bxor(b, literal)
            elseif opcode == 2 then
                b = bit.band(combo, 0b111)
            elseif opcode == 3 then
            elseif opcode == 4 then
                b = bit.bxor(b, c)
            elseif opcode == 5 then
                if program[programpointer] == bit.band(combo, 7ULL) then
                    local result = solve(a, programpointer - 1)
                    if result then
                        return result
                    end
                end
            elseif opcode == 6 then
                b = dv(combo)
            elseif opcode == 7 then
                c = dv(combo)
            end
        end
    end
end

print(string.format("%u", solve(0ULL, count - 1)))
