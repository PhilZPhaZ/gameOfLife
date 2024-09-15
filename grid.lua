local grid = {}
local cellSize = 20
local cellXNumber, cellYNumber
local cells = {}
local gridX, gridY = 0, 0
local gridSave = {}
local gridSaveIndex = 1

function grid.init(width, height)

end

function grid.wheelmoved(x, y)
    if cellSize + y > 2 then
        cellSize = cellSize + y
    end
end

function grid.handleInput()
    if love.mouse.isDown(1) and not love.keyboard.isDown('lctrl') then
        -- Calculer la cellule cliquée
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        local cellX = math.floor((x - gridX) / cellSize)
        local cellY = math.floor((y - gridY) / cellSize)

        -- Changer la couleur de la cellule cliquée
        if not GRID[cellX] then
            GRID[cellX] = {}
        end

        GRID[cellX][cellY] = true
    elseif love.mouse.isDown(2) then
        -- Calculer la cellule cliquée
        local x = love.mouse.getX()
        local y = love.mouse.getY()

        local cellX = math.floor((x - gridX) / cellSize)
        local cellY = math.floor((y - gridY) / cellSize)

        -- Changer la couleur de la cellule cliquée
        if not GRID[cellX] then
            GRID[cellX] = {}
        end
            
        GRID[cellX][cellY] = false
    end
end

function grid.nextGeneration()
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

    -- remove all false cell in grid
    grid.removeFalseCell()
end

function grid.removeFalseCell()
    for x, elem in next, GRID do
        for y, cell in next, elem do
            if not cell then
                GRID[x][y] = nil
            end
        end
        if next(GRID[x]) == nil then
            GRID[x] = nil
        end
    end
end

function love.mousepressed(x, y, button)
    if gameState == 'game' then
        if button == 1 and love.keyboard.isDown('lctrl') then -- Bouton gauche de la souris
            translate = true
        end
    end
end

function love.mousereleased(x, y, button)
    if gameState == 'game' then
        if button == 1 then
            translate = false
        end
    end
end

function love.wheelmoved(x, y)
    if gameState == 'game' then
        grid.wheelmoved(x, y)
    end
end

function love.mousemoved(x, y, dx, dy)
    if gameState == 'game' then
        if translate then
            gridX = gridX + dx
            gridY = gridY + dy
        end
    end
end

function grid.draw()
    -- Calculer les limites de la grille visible
    local startX = math.floor(-gridX / cellSize)
    local startY = math.floor(-gridY / cellSize)
    local endX = math.ceil((love.graphics.getWidth() - gridX) / cellSize)
    local endY = math.ceil((love.graphics.getHeight() - gridY) / cellSize)

    -- Dessiner les cellules
    for x = startX, endX do
        for y = startY, endY do
            if GRID[x] and GRID[x][y] then
                love.graphics.setColor(0, 0, 0)
            else
                love.graphics.setColor(217, 217, 217) -- Gris par défaut si la cellule n'a pas de couleur définie
            end
            love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, cellSize - 1, cellSize - 1)
        end
    end


    love.graphics.setColor(0, 0, 0)
    -- rectangle for menu
    local textMenuSize = love.graphics.getFont():getWidth('Echap : Menu')
    love.graphics.rectangle('fill', 10, 10, (textMenuSize / 2) + 3, 30)

    -- rectangle for help
    local textHelpSize = love.graphics.getFont():getWidth('Aide : h')
    love.graphics.rectangle('fill', 10, 40, (textHelpSize / 2) + 3, 30)

    -- rectangle for fps
    local textFPSSize = love.graphics.getFont():getWidth('FPS : ' .. love.timer.getFPS())
    love.graphics.rectangle('fill', 10, 70, (textFPSSize / 2) + 3, 30)

    -- size of the text generation
    local textGenerationNumberSize = love.graphics.getFont():getWidth('Génération : ' .. gridSaveIndex)
    love.graphics.rectangle('fill', 10, 100, (textGenerationNumberSize / 2) + 3, 30)

    -- print the text for the menu
    love.graphics.setColor(217, 217, 217)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))
    love.graphics.print('Echap : Menu', 10, 10)

    -- print the text for the help
    love.graphics.print('Aide : h', 10, 40)

    -- print the text for the fps
    love.graphics.print('FPS : ' .. love.timer.getFPS(), 10, 70)

    -- print the text for the generation
    love.graphics.print('Génération : ' .. gridSaveIndex, 10, 100)

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))
end

function grid.random()
    -- for all the visible cell
    for x = math.floor(-gridX / cellSize), math.ceil((love.graphics.getWidth() - gridX) / cellSize) do
        for y = math.floor(-gridY / cellSize), math.ceil((love.graphics.getHeight() - gridY) / cellSize) do
            if not GRID[x] then
                GRID[x] = {}
            end
            if math.random(0, 1) == 1 then
                GRID[x][y] = true
            else
                GRID[x][y] = nil
            end
        end
    end
end

function grid.clear()
    GRID = {}
end

function grid.saveToFile(saveName)
    grid.removeFalseCell()

    local saveData = {}
    for x, elem in next, GRID do
        for y, cell in next, elem do
            table.insert(saveData, x .. ';' .. y .. ';' .. tostring(cell))
        end
    end

    love.filesystem.createDirectory('saves')
    love.filesystem.write('saves/' .. saveName, table.concat(saveData, '\n'))
end

function grid.loadFromFile(saveName)
    grid.clear()

    local saveData = love.filesystem.read('saves/' .. saveName)

    for line in saveData:gmatch('[^\n]+') do
        local x, y, cell = line:match('(%d+);(%d+);(%a+)')
        if not GRID[tonumber(x)] then
            GRID[tonumber(x)] = {}
        end
        GRID[tonumber(x)][tonumber(y)] = cell == 'true'
    end

    grid.removeFalseCell()
end

function grid.fill()
    for x = math.floor(-gridX / cellSize), math.ceil((love.graphics.getWidth() - gridX) / cellSize) do
        for y = math.floor(-gridY / cellSize), math.ceil((love.graphics.getHeight() - gridY) / cellSize) do
            if not GRID[x] then
                GRID[x] = {}
            end
            GRID[x][y] = true
        end
    end
end

return grid