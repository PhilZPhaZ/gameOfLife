local grid = {}
local cellSize = 20
local gridX, gridY = 0, 0
local gridSave = {}
local gridSaveIndex = 1
local zoomFactor = 1.1
local helpMenu = true

-- rectangle size
local textMenuSize
local textHelpSize
local textFPSSize
local textGenerationNumberSize
local textMousePositionSize
local maxTextSize = 0

-- rectangle for the selection
local selectionRectangle = false
local startXRectangle, startYRectangle = 0, 0
local endXRectangle, endYRectangle = 0, 0
local selection = {}

function grid.init()

end

function grid.update(dt)
    -- rectangle for menu
    textMenuSize = love.graphics.getFont():getWidth('Echap : Menu')

    -- rectangle for help
    textHelpSize = love.graphics.getFont():getWidth('Aide : h')

    -- rectangle for fps
    textFPSSize = love.graphics.getFont():getWidth('FPS : ' .. love.timer.getFPS())

    -- size of the text generation
    textGenerationNumberSize = love.graphics.getFont():getWidth('Génération : ' .. gridSaveIndex - 1)

    -- size of the text of the current mouse position on the cell
    textMousePositionSize = love.graphics.getFont():getWidth('Position : ' .. math.floor((love.mouse.getX() - gridX) / cellSize) .. ' ' .. math.floor((love.mouse.getY() - gridY) / cellSize))

    -- get the max size of the text
    maxTextSize = math.max((textMenuSize / 2), (textHelpSize / 2), (textFPSSize / 2), (textGenerationNumberSize / 2), (textMousePositionSize / 2))
end

function grid.save()
    if next(GRID) == nil then
        gridSave[gridSaveIndex] = {}
    else
        gridSave[gridSaveIndex] = {}
        for x, elem in next, GRID do
            for y, cell in next, elem do
                table.insert(gridSave[gridSaveIndex], {x, y, cell})
            end
        end
    end
end

function grid.load()
    GRID = {}
    for _, elem in next, gridSave[gridSaveIndex] do
        if not GRID[elem[1]] then
            GRID[elem[1]] = {}
        end
        GRID[elem[1]][elem[2]] = elem[3]
    end
end

function grid.handleInput()
    if love.mouse.isDown(1) and not love.keyboard.isDown('lctrl') and not love.keyboard.isDown('lshift') then
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
    -- save the current grid
    grid.removeFalseCell()
    grid.save()
    gridSaveIndex = gridSaveIndex + 1

    -- send the grid to the thread
    threadChannel:push(GRID)

    -- get the result from the thread
    GRID = resultChannel:demand()

    grid.removeFalseCell()
end

function grid.previousGeneration()
    if gridSaveIndex > 1 then
        gridSaveIndex = gridSaveIndex - 1
        grid.load()
    end
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

function grid.mousepressed(x, y, button)
    if (button == 1 and love.keyboard.isDown('lctrl')) or button == 3 then -- Bouton gauche de la souris
        translate = true
    end
end

function grid.mousereleased(x, y, button)
    if button == 1 or button == 3 then
        translate = false
    end
end

function grid.wheelmoved(x, y)
    grid.proccesWheelMoved(x, y)
end

function grid.proccesWheelMoved(x, y)
    if y ~= 0 then
        -- Obtenir la position de la souris
        local mouseX, mouseY = love.mouse.getPosition()

        -- Calculer le facteur de zoom
        local zoom = (y > 0) and zoomFactor or (1 / zoomFactor)

        -- Ajuster les coordonnées de la grille
        gridX = mouseX - (mouseX - gridX) * zoom
        gridY = mouseY - (mouseY - gridY) * zoom

        -- Appliquer le zoom
        cellSize = cellSize * zoom
    end
end

function grid.mousemoved(x, y, dx, dy)
    if translate then
        gridX = gridX + dx
        gridY = gridY + dy
    end

    if x >= 7 and x <= 7 + maxTextSize + 6 and y >= 10 and y <= 160 then
        helpMenu = false
    else
        helpMenu = true
    end
end

function grid.draw(withInfos)
    -- Calculer les limites de la grille visible
    local startX = math.floor(-gridX / cellSize)
    local startY = math.floor(-gridY / cellSize)
    local endX = math.ceil((love.graphics.getWidth() - gridX) / cellSize)
    local endY = math.ceil((love.graphics.getHeight() - gridY) / cellSize)

    -- Dessiner les cellules
    if cellSize > 3 then
        for x = startX, endX do
            for y = startY, endY do
                if GRID[x] and GRID[x][y] then
                    love.graphics.setColor(0, 0, 0)
                else
                    love.graphics.setColor(217, 217, 217) -- Gris par défaut si la cellule n'a pas de couleur définie
                end
                love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, cellSize - 1, cellSize - 1)

                -- draw a line with a different color every 16 cells
                if x % 10 == 0 then
                    love.graphics.setColor(0.35, 0.35, 0.35)
                    love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, 1, cellSize)
                end
                if y % 10 == 0 then
                    love.graphics.setColor(0.35, 0.35, 0.35)
                    love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, cellSize, 1)
                end
            end
        end
    else
        for x = startX, endX do
            for y = startY, endY do
                if GRID[x] and GRID[x][y] then
                    love.graphics.setColor(0, 0, 0)
                else
                    love.graphics.setColor(217, 217, 217) -- Gris par défaut si la cellule n'a pas de couleur définie
                end
                love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, cellSize, cellSize)
            end
        end
    end

    if withInfos and helpMenu then
        grid.drawHelpMenu()
    end
end

function grid.drawHelpMenu()
    -- print a big rectangle for the menu
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 7, 10, maxTextSize + 6, 150)

    -- print the text for the menu
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))
    love.graphics.print('Echap : Menu', 10, 10)

    -- print the text for the help
    love.graphics.print('Aide : h', 10, 40)

    -- print the text for the fps
    love.graphics.print('FPS : ' .. love.timer.getFPS(), 10, 70)

    -- print the text for the generation
    love.graphics.print('Génération : ' .. gridSaveIndex - 1, 10, 100)

    -- print the text for the current mouse position on the cell
    love.graphics.print('Position : ' .. math.floor((love.mouse.getX() - gridX) / cellSize) .. ',' .. math.floor((love.mouse.getY() - gridY) / cellSize), 10, 130)

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
    gridSave = {}
    gridSaveIndex = 1
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