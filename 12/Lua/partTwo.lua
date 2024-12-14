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
local dir4diag = { { 1, 1 }, { -1, 1 }, { -1, -1 }, { 1, -1 } }
local function calculate(sr, sc)
    local flower = map[sr][sc]
    local queue = { { sr, sc } }
    local perimeter = 0
    local area = 0
    local corner = 0
    while #queue > 0 do
        local px, py = unpack(queue[1])
        table.remove(queue, 1)
        if seen[px] == nil or seen[px][py] or map[px] == nil or map[px][py] ~= flower then
            goto continue
        end
        seen[px][py] = true
        area = area + 1
        for i = 1, 4 do
            local dx, dy = unpack(dir4[i])
            local nx, ny = px + dx, py + dy

            if map[nx] == nil or map[px][py] ~= map[nx][ny] then
                perimeter = perimeter + 1
            end

            local rightindex = (i % 4) + 1
            local topx, topy = nx, ny
            dx, dy = unpack(dir4diag[i])
            local diagx, diagy = px + dx, py + dy
            dx, dy = unpack(dir4[rightindex])
            local rightx, righty = px + dx, py + dy
            if (map[topx] ~= nil and map[topx][topy] == flower) and
                (map[diagx] == nil or map[diagx][diagy] ~= flower) and
                (map[rightx] ~= nil and map[rightx][righty] == flower)
            then
                --  case 1
                --  OO?
                --  OOO
                --  OOO
                corner = corner + 1
            elseif (map[topx] == nil or map[topx][topy] ~= flower) and
                (map[rightx] == nil or map[rightx][righty] ~= flower)
            then
                -- case 2
                -- O?O
                -- OO?
                -- OOO
                corner = corner + 1
            end

            queue[#queue + 1] = { nx, ny }
        end
        ::continue::
    end
    return area, perimeter, corner
end

local sum = 0
for r = 1, row do
    for c = 1, col do
        if not seen[r][c] then
            local area, _, corner = calculate(r, c)
            sum = sum + area * corner
        end
    end
end
print(sum)
