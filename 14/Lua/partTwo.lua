local col, row = 101, 103
local function negmod(a, b)
    return ((a % b) + b) % b
end

local robots = {}
for line in io.lines("input.txt") do
    local py, px, vy, vx = string.match(line, "p=(-?%d+),(-?%d+) v=(-?%d+),(-?%d+)")
    robots[#robots + 1] = { p = { x = px, y = py }, v = { x = vx, y = vy } }
end

local map = {}
for i = 1, row do
    map[i] = {}
end

local function resetmap()
    for i = 1, row do
        for j = 1, col do
            map[i][j] = " "
        end
    end
end

local function updatemap()
    resetmap()
    for _, robot in ipairs(robots) do
        map[robot.p.x + 1][robot.p.y + 1] = "*"
    end
end

local file = io.open("map.txt", "w")
local function printmap()
    for i = 1, row do
        for j = 1, col do
            file:write(map[i][j])
        end
        file:write("\n")
    end
end

for i = 1, 10000 do
    for _, robot in ipairs(robots) do
        robot.p.x = negmod(robot.p.x + robot.v.x, row)
        robot.p.y = negmod(robot.p.y + robot.v.y, col)
    end
    updatemap()
    printmap()
    file:write(i .. "   ---------------------------------------------\n")
end
file:close()
--- find "**********" in text file and get the i value for the answer
