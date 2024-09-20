local grid = {}
local cellSize = 20
local gridX, gridY = 0, 0
local gridSave = {}
local gridSaveIndex = 1
local zoomFactor = 1.1
local helpMenu = true
local x, y
local cellX, cellY

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

-- other variables
local x_fill, y_fill
local x_random, y_random
local x_load, y_load
local x_save, y_save

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
        x = love.mouse.getX()
        y = love.mouse.getY()

        cellX = math.floor((x - gridX) / cellSize)
        cellY = math.floor((y - gridY) / cellSize)

        -- Changer la couleur de la cellule cliquée
        if not GRID[cellX] then
            GRID[cellX] = {}
        end

        GRID[cellX][cellY] = true
    elseif love.mouse.isDown(2) then
        -- Calculer la cellule cliquée
        x = love.mouse.getX()
        y = love.mouse.getY()

        cellX = math.floor((x - gridX) / cellSize)
        cellY = math.floor((y - gridY) / cellSize)

        -- Changer la couleur de la cellule cliquée
        if GRID[cellX] then
            GRID[cellX][cellY] = nil
            if next(GRID[cellX]) == nil then
                GRID[cellX] = nil
            end
        end
    end
end

function grid.nextGeneration()
    gridSaveIndex = gridSaveIndex + 1

    -- send the grid to the thread
    threadChannel:push(GRID)

    -- get the result from the thread
    GRID = resultChannel:demand()

    grid.removeFalseCell()
end

function grid.previousGeneration()
    if gridSaveIndex > 1 then
        GRID[gridSaveIndex] = nil
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
    elseif button == 1 and love.keyboard.isDown('lshift') then
        startXRectangle, startYRectangle = x, y
        endXRectangle, endYRectangle = x, y

        selectionRectangle = true
    elseif button == 1 and isPasting then
        -- paste the selection in the grid
        local xMouse, yMouse = love.mouse.getPosition()
        x = math.floor((xMouse - gridX) / cellSize)
        y = math.floor((yMouse - gridY) / cellSize)

        for xSelection, elem in next, selection do
            for ySelection, cell in next, elem do
                if not GRID[x + xSelection] then
                    GRID[x + xSelection] = {}
                end
                GRID[x + xSelection][y + ySelection] = cell
            end
        end
    elseif button == 2 and isPasting then
        isPasting = false
        numberOfRotation = 0
    end
end

function grid.mousereleased(x, y, button)
    if button == 1 or button == 3 then
        translate = false
        if selectionRectangle then
            selectionRectangle = false

            grid.saveSelectecSave()
        end
    end
end

function grid.saveSelectecSave()
    -- get the selection but the coords are relative to the mouse position and the center of the selection
    x = math.floor((startXRectangle - gridX) / cellSize)
    y = math.floor((startYRectangle - gridY) / cellSize)
    local endX = math.floor((endXRectangle - gridX) / cellSize)
    local endY = math.floor((endYRectangle - gridY) / cellSize)

    -- get the middle of the selection
    local middleX = math.floor((endX + x) / 2)
    local middleY = math.floor((endY + y) / 2)

    -- get the selection
    selection = {}
    for i = x, endX do
        for j = y, endY do
            if GRID[i] and GRID[i][j] then
                if not selection[i - middleX] then
                    selection[i - middleX] = {}
                end
                selection[i - middleX][j - middleY] = true
            else
                if not selection[i - middleX] then
                    selection[i - middleX] = {}
                end
                selection[i - middleX][j - middleY] = false
            end
        end
    end
end

function grid.rotateSelect()
    -- rotate the selection
    -- shitty code but it works
    local newSelection = {}
    for x, elem in next, selection do
        for y, cell in next, elem do
            if not newSelection[y] then
                newSelection[y] = {}
            end
            newSelection[y][-x] = cell
        end
    end

    selection = newSelection
end

function grid.flipSelection()
    -- flip the selection
    -- shitty code but it works
    local newSelection = {}
    for x, elem in next, selection do
        for y, cell in next, elem do
            if not newSelection[-x] then
                newSelection[-x] = {}
            end
            newSelection[-x][y] = cell
        end
    end

    selection = newSelection
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

    -- selection rectangle
    if selectionRectangle then
        endXRectangle, endYRectangle = x, y
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
                    love.graphics.setColor(1, 1, 1) -- Gris par défaut si la cellule n'a pas de couleur définie
                end
                love.graphics.rectangle("fill", x * cellSize + gridX, y * cellSize + gridY, cellSize, cellSize)
            end
        end
    end

    if withInfos and helpMenu then
        grid.drawHelpMenu()
    end

    if selectionRectangle then
        grid.drawSelectionRectangle()
    end

    if isPasting then
        grid.drawPaste()
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

function grid.drawSelectionRectangle()
    love.graphics.setLineWidth(2)
    love.graphics.setColor(0, 0, 0.7)
    love.graphics.rectangle('line', startXRectangle, startYRectangle, endXRectangle - startXRectangle, endYRectangle - startYRectangle)
    love.graphics.setLineWidth(1)
end

function grid.drawPaste()

    -- draw the selection depending on the mouse position
    local xMouse, yMouse = love.mouse.getPosition()
    x = math.floor((xMouse - gridX) / cellSize)
    y = math.floor((yMouse - gridY) / cellSize)

    -- print the selection on the grid where the mouse is
    for xSelection, elem in next, selection do
        for ySelection, cell in next, elem do
            if cell then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle('fill', (x + xSelection) * cellSize + gridX, (y + ySelection) * cellSize + gridY, cellSize - 1, cellSize - 1)
            end
        end
    end
end

function grid.random()
    -- for all the visible cell
    for x_random = math.floor(-gridX / cellSize), math.ceil((love.graphics.getWidth() - gridX) / cellSize) do
        for y_random = math.floor(-gridY / cellSize), math.ceil((love.graphics.getHeight() - gridY) / cellSize) do
            if not GRID[x_random] then
                GRID[x_random] = {}
            end
            if math.random(0, 1) == 1 then
                GRID[x_random][y_random] = true
            else
                GRID[x_random][y_random] = nil
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
    for x_save, elem in next, GRID do
        for y_save, cell in next, elem do
            table.insert(saveData, x_save .. ';' .. y_save .. ';' .. tostring(cell))
        end
    end

    love.filesystem.createDirectory('saves')
    love.filesystem.write('saves/' .. saveName, table.concat(saveData, '\n'))
end

function grid.loadFromFile(saveName)
    local saveData = love.filesystem.read('saves/' .. saveName)

    for line in saveData:gmatch('[^\n]+') do
        local x_load, y_load, cell = line:match('(%d+);(%d+);(%a+)')
        if not GRID[tonumber(x_load)] then
            GRID[tonumber(x_load)] = {}
        end
        GRID[tonumber(x_load)][tonumber(y_load)] = cell == 'true'
    end

    grid.removeFalseCell()
end

function grid.fill()
    for x_fill = math.floor(-gridX / cellSize), math.ceil((love.graphics.getWidth() - gridX) / cellSize) do
        for y_fill = math.floor(-gridY / cellSize), math.ceil((love.graphics.getHeight() - gridY) / cellSize) do
            if not GRID[x_fill] then
                GRID[x_fill] = {}
            end
            GRID[x_fill][y_fill] = true
        end
    end
end

return grid