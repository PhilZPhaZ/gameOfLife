local cells = require 'grid'

local saveLoad = {}
local saveName = ""
local files
local initialTextXCoord = 100
local dxXTextCord
local time = 0

startIndex = 1

function saveLoad.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end
end

function saveLoad.loadKeypressed(key)
    if key == 'escape' then
        gameState = 'menu'
    elseif key == 'up' then
        selectedFile = selectedFile - 1
        if selectedFile < 1 then
            selectedFile = #files
        end
    elseif key == 'down' then
        selectedFile = selectedFile + 1
        if selectedFile > #files then
            selectedFile = 1
        end
    elseif key == 'return' then
        -- load the selected file
        cells.loadFromFile(files[selectedFile])
        gameState = 'game'
    end
end

function saveLoad.saveKeypressed(key)
    if key == 'escape' then
        gameState = 'menu'
    elseif key == 'backspace' then
        saveName = saveName:sub(1, -2)
    elseif key == 'return' then
        -- save the current state of the grid in a file
        cells.saveToFile(saveName)
        saveName = ""
        gameState = 'menu'
    elseif (key ~= 'lshift') and (key ~= 'lctrl') and (key ~= 'lgui') then
        saveName = saveName .. key
    end
end

function saveLoad.drawLoadMenu()
    love.filesystem.remove('saves/.DS_Store')

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.print('Sélectionner le fichier', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    files = love.filesystem.getDirectoryItems('saves')
    if #files == 0 then
        love.graphics.print('Pas de sauvegarde', 100, 200)
    end

    -- fucking bad scroll bar but it work
    -- it's a fucking bad implementation
    scrollBarSize = 150 + #files * 50
    if scrollBarSize > height then
        filesShowed = {}

        maxPossibleShowedFiles = math.floor((height - 150) / 50) - 1
        endIndex = maxPossibleShowedFiles

        if selectedFile > maxPossibleShowedFiles then
            endIndex = selectedFile
        end

        startIndex = endIndex - maxPossibleShowedFiles + 1

        for i = startIndex, endIndex do
            table.insert(filesShowed, files[i])
        end
    else
        filesShowed = files
    end
    -- should work everytime
    -- if not, will not work and cause visual bugs
    for i, file in ipairs(filesShowed) do
        if (i + startIndex - 1) == selectedFile then
            love.graphics.setColor(0, 0, 0)
            dxXTextCord = initialTextXCoord + 20
        else
            love.graphics.setColor(217, 217, 217)
            dxXTextCord = initialTextXCoord
        end

        local offset = math.sin(time + i) * 3
        love.graphics.print(file, dxXTextCord + offset, 150 + i * 50)
    end

    -- create a scroll bar (graphics this time :D)
    -- another bad code but it work
    local scrollBarHeight = 200
    local bottomMargin = 10
    local thresholdSize = math.floor((height - scrollBarHeight - bottomMargin) / #files)
    scrollBarHeight = thresholdSize * #files

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 60, (height - scrollBarHeight - bottomMargin), 20, scrollBarHeight)

    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('fill', 60, (height - scrollBarHeight - bottomMargin) + (selectedFile - 1) * thresholdSize, 20, thresholdSize)
end

function saveLoad.drawSaveMenu()
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.print('Sauvegarde', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    love.graphics.print('Entrer le nom de la sauvegarde', 100, 180)
    love.graphics.print(saveName, 100, 250)

    -- print the underscore alternately to make the cursor blink
    if time % 1 > 0.5 then
        love.graphics.print('_', 100 + love.graphics.getFont():getWidth(saveName), 250)
    end
end

return saveLoad
