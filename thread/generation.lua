local threadChannel = love.thread.getChannel("gridInfo")
local resultChannel = love.thread.getChannel("gridResult")

local running = true

while running do
    local message = threadChannel:pop()

    if message then
        if message == 'stop' then
            running = false
        else
            GRID = message

            local cellToCheckWithAlgorithm = {}
            for x, elem in next, GRID do
                for y, cell in next, elem do
                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            local nx, ny = x + dx, y + dy
                            if not cellToCheckWithAlgorithm[nx] then
                                cellToCheckWithAlgorithm[nx] = {}
                            end
                            if cellToCheckWithAlgorithm[nx][ny] == nil then
                                cellToCheckWithAlgorithm[nx][ny] = GRID[nx] and GRID[nx][ny] or false
                            end
                        end
                    end
                end
            end

            for x, elem in next, cellToCheckWithAlgorithm do
                for y, cell in next, elem do
                    local count = 0
                    for dx = -1, 1 do
                        for dy = -1, 1 do
                            if cellToCheckWithAlgorithm[x + dx] and cellToCheckWithAlgorithm[x + dx][y + dy] then
                                count = count + 1
                            end
                        end
                    end

                    if cellToCheckWithAlgorithm[x][y] then
                        count = count - 1
                    end

                    if count == 3 then
                        if not GRID[x] then
                            GRID[x] = {}
                        end
                        GRID[x][y] = true
                    elseif count < 2 or count > 3 then
                        if not GRID[x] then
                            GRID[x] = {}
                        end
                        GRID[x][y] = false
                    end
                end
            end
        end

        resultChannel:push(GRID)
    end
end