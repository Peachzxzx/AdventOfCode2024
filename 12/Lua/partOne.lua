local map = {}
local seen = {}
local row, col = 1, 1
for line in io.lines("input.txt") do
    map[row] = {}
    seen[row] = {}
    col = 1
    for c in string.gmatch(line, ".") do
        map[row][col] = c
        seen[row][col] = false
        col = col + 1
    end
    row = row + 1
end
row = row - 1
col = col - 1

local dir4 = { { 1, 0 }, { 0, 1 }, { -1, 0 }, { 0, -1 } }
local function calculate(sr, sc)
    local flower = map[sr][sc]
    local queue = { { sr, sc } }
    local perimeter = 0
    local area = 0
    while #queue > 0 do
        local px, py = unpack(queue[1])
        table.remove(queue, 1)
        if seen[px] == nil or seen[px][py] or map[px] == nil or map[px][py] ~= flower then
            goto continue
        end
        seen[px][py] = true
        area = area + 1
        for _, dir in ipairs(dir4) do
            local dx, dy = unpack(dir)
            local nx, ny = px + dx, py + dy

            if map[nx] == nil or map[px][py] ~= map[nx][ny] then
                perimeter = perimeter + 1
            end

            queue[#queue + 1] = { nx, ny }
        end
        ::continue::
    end
    return area, perimeter
end

local sum = 0
for r = 1, row do
    for c = 1, col do
        if not seen[r][c] then
            local area, perimeter = calculate(r, c)
            sum = sum + area * perimeter
        end
    end
end
print(sum)
