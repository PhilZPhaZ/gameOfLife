local grid = {}

local cellSize = 20
local cellXNumber, cellYNumber
local cells = {}
local gridSave = {}
local gridSaveIndex = 1

function grid.init(width, height)
    cellXNumber = math.floor(width / cellSize)
    cellYNumber = math.floor(height / cellSize)
    
    for x = 1, cellXNumber do
        cells[x] = {}
        for y = 1, cellYNumber do
            cells[x][y] = false
        end
    end
end

function grid.random()
    for x = 1, cellXNumber do
        for y = 1, cellYNumber do
            cells[x][y] = math.random() < 0.5
        end
    end
end

function grid.handleInput()
    local selectedX = math.floor(love.mouse.getX() / cellSize) + 1
    local selectedY = math.floor(love.mouse.getY() / cellSize) + 1

    if love.keyboard.isDown('lctrl') then

    else
        if love.mouse.isDown(1) then
            cells[selectedX][selectedY] = true
        elseif love.mouse.isDown(2) then
            cells[selectedX][selectedY] = false
        end
    end
end

function grid.nextGeneration()
    local nextCells = {}
    for x = 1, cellXNumber do
        nextCells[x] = {}
        for y = 1, cellYNumber do
            local count = 0
            for dx = -1, 1 do
                for dy = -1, 1 do
                    if dx ~= 0 or dy ~= 0 then
                        local nx = x + dx
                        local ny = y + dy
                        if nx >= 1 and nx <= #cells and ny >= 1 and ny <= #cells[1] then
                            if cells[nx][ny] then
                                count = count + 1
                            end
                        end
                    end
                end
            end

            if cells[x][y] then
                nextCells[x][y] = count == 2 or count == 3
            else
                nextCells[x][y] = count == 3
            end
        end
    end
    gridSave[gridSaveIndex] = cells
    gridSaveIndex = gridSaveIndex + 1

    cells = nextCells
end

function grid.lastGeneration()
    if gridSaveIndex > 1 then
        gridSaveIndex = gridSaveIndex - 1
        cells = gridSave[gridSaveIndex]
    end
end

function grid.clear()
    for x = 1, cellXNumber do
        for y = 1, cellYNumber do
            cells[x][y] = false
        end
    end
    gridSave = {}
    gridSaveIndex = 1
end

function grid.draw()
    for x = 1, cellXNumber do
        for y = 1, cellYNumber do
            if cells[x][y] then
                love.graphics.setColor(0, 0, 0)
            else
                love.graphics.setColor(217, 217, 217)
            end
            love.graphics.rectangle("fill", (x - 1) * cellSize, (y - 1) * cellSize, cellSize - 1, cellSize - 1)
        end
    end

    -- Shitty code but i dont care it work
    -- print the rectangle for the menu
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 10, 10, 170, 30)
    love.graphics.rectangle('fill', 10, 40, 109, 30)
    love.graphics.rectangle('fill', 10, 70, 235, 30)

    -- print the text for the menu
    love.graphics.setColor(217, 217, 217)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))
    love.graphics.print('Echap : Menu', 10, 10)
    love.graphics.print('FPS : ' .. love.timer.getFPS(), 10, 40)
    love.graphics.print('Génération : ' .. gridSaveIndex - 1, 10, 70)

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))
end

function grid.save(name)
    -- save in the save folder without using love
    -- why without love ?
    -- i dont know but it may be easier and more reliable with io
    -- idk about that because i'm a noob lol
    local file = io.open('saves/' .. name .. '.txt', 'w')
    for y = 1, cellYNumber do
        for x = 1, cellXNumber do
            if cells[x][y] then
                file:write('1')
            else
                file:write('0')
            end
        end
        file:write('\n')
    end
    file:close()
end

function grid.load(name)
    -- load from the save folder without using love
    -- becaus it's not possible to use love in this file
    -- i dont know why
    local file = io.open('saves/' .. name, 'r')
    for y = 1, cellYNumber do
        local line = file:read()
        for x = 1, cellXNumber do
            cells[x][y] = line:sub(x, x) == '1'
        end
    end
    file:close()
end

return grid
