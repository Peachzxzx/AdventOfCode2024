local col, row = 101, 103
local sec = 100
local cold = (col + 1) / 2 - 1
local rowd = (row + 1) / 2 - 1
local function negmod(a, b)
    return ((a % b) + b) % b
end

local q = { 0, 0, 0, 0 }
for line in io.lines("input.txt") do
    local py, px, vy, vx = string.match(line, "p=(-?%d+),(-?%d+) v=(-?%d+),(-?%d+)")
    local ny, nx = negmod(py + vy * sec, col), negmod(px + vx * sec, row)

    if 0 <= ny and ny < cold then
        if 0 <= nx and nx < rowd then
            q[1] = q[1] + 1
        elseif nx > rowd and nx < row then
            q[3] = q[3] + 1
        end
    elseif ny > cold and ny < col then
        if 0 <= nx and nx < rowd then
            q[2] = q[2] + 1
        elseif nx > rowd and nx < row then
            q[4] = q[4] + 1
        end
    end
end

print(q[1] * q[2] * q[3] * q[4])
