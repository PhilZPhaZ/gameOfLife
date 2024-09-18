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
                            if not cellToCheckWithAlgorithm[x + dx] then
                                cellToCheckWithAlgorithm[x + dx] = {}
                            end

                            if cellToCheckWithAlgorithm[x + dx] and cellToCheckWithAlgorithm[x + dx][y + dy] then
                                cellToCheckWithAlgorithm[x + dx][y + dy] = true
                            elseif GRID[x + dx] and GRID[x + dx][y + dy] then
                                cellToCheckWithAlgorithm[x + dx][y + dy] = GRID[x + dx][y + dy]
                            else
                                cellToCheckWithAlgorithm[x + dx][y + dy] = false
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