local map = {}
local row, col = 1, 1
local sx, sy = 1, 1
local ex, ey = 1, 1
for line in io.lines("input.txt") do
    local columns = {}
    col = 1
    for c in string.gmatch(line, ".") do
        if c == "S" then
            sx = tonumber(row)
            sy = tonumber(col)
            c = "."
        elseif c == "E" then
            ex = tonumber(row)
            ey = tonumber(col)
            c = "."
        end
        columns[col] = c

        col = col + 1
    end
    map[row] = columns
    row = row + 1
end
row = row - 1
col = col - 1

local dir4 = { { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }
local vertexes = { { sx, sy }, { ex, ey } }
local adj = { {}, {} }
for r = 2, row - 1 do
    for c = 2, col - 1 do
        if map[r][c] == "#" then
            goto nextloop
        end

        for dir1 = 1, 3 do
            local dr, dc = unpack(dir4[dir1])
            if map[r + dr][c + dc] == '.' then
                for dir2 = dir1 + 1, 4 do
                    if dir1 == (dir2 + 2 - 1) % 4 + 1 then
                        goto continue
                    end
                    local drr, dcc = unpack(dir4[dir2])
                    if map[r + drr][c + dcc] == "." then
                        vertexes[#vertexes + 1] = { r, c }
                        adj[#adj + 1] = {}
                        goto nextloop
                    end
                    ::continue::
                end
            end
        end
        ::nextloop::
    end
end

for mainvectexindex, v in ipairs(vertexes) do
    local r, c = unpack(v)
    for dir, d in ipairs(dir4) do
        local dr, dc = unpack(d)
        local nr, nc = r + dr, c + dc
        local weight = 1
        while map[nr][nc] ~= '#' do
            for vertexindex, vv in ipairs(vertexes) do
                if nr == vv[1] and nc == vv[2] then
                    adj[mainvectexindex][dir] = { vertexindex, weight }
                    goto continue
                end
            end
            weight = weight + 1
            nr = nr + dr
            nc = nc + dc
        end
        ::continue::
    end
end


local sortedList = {
    create = function(self)
        self = setmetatable({
            first = 1,
            last = 1
        }, self)
        return self
    end,
    size = function(self)
        return self.last - self.first
    end,
    insertLast = function(self, item, compFunc)
        compFunc = compFunc or function(a, b)
            return a < b
        end
        local temp = item
        for i = self.first, self.last - 1 do
            if compFunc(item, self[i]) then
                temp = self[i]
                self[i] = item
                item = temp
            end
        end
        self[self.last] = temp
        self.last = self.last + 1
    end,
    popHead = function(self)
        local x = self[self.first]
        self.first = self.first + 1
        return x
    end
}
sortedList.__index = sortedList
local res = math.huge
local function bfs(startvertex, startdir, initialscore)
    local queue = sortedList:create()
    queue:insertLast({ startvertex, startdir, initialscore, {} })
    local com = function(a, b)
        return a[3] < b[3]
    end
    local visited = {}
    while queue:size() > 0 do
        local vertexindex, dir, score = unpack(queue:popHead())
        if vertexindex == 2 then
            res = math.min(score, res)
            goto continue
        end
        if visited[vertexindex] == nil then
            visited[vertexindex] = {}
        elseif visited[vertexindex][dir] then
            goto continue
        end
        visited[vertexindex][dir] = true
        for adjdir, adjnode in pairs(adj[vertexindex]) do
            if adjdir ~= ((dir + 2 - 1) % 4) + 1 then
                local newscore = score + adjnode[2]
                if adjdir ~= dir then
                    newscore = newscore + 1000
                end
                queue:insertLast({ adjnode[1], adjdir, newscore }, com)
            end
        end

        ::continue::
    end
end

bfs(1, 1, 1000)

print(res)
