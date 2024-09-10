local cells = require 'grid'

local saveLoad = {}
local saveName = ""
local files

startIndex = 1

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
        cells.load(files[selectedFile])
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
        cells.save(saveName)
        saveName = ""
        gameState = 'menu'
    elseif key ~= 'lshift' then
        saveName = saveName .. key
    end
end

function saveLoad.drawLoadMenu()
    love.graphics.setColor(217, 217, 217)
    love.graphics.print('Sélectionner le fichier à ouvrir', 100, 100)
    files = love.filesystem.getDirectoryItems('saves')
    if #files == 0 then
        love.graphics.print('No files found', 100, 150)
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
            love.graphics.setColor(217, 217, 217)
        else
            love.graphics.setColor(0, 0, 0)
        end
        love.graphics.print(file, 100, 150 + i * 50)
    end
end

function saveLoad.drawSaveMenu()
    love.graphics.print('Menu de sauvegarde', 100, 100)
    love.graphics.print('Entrer le nom de la sauvegarde', 100, 150)
    love.graphics.print(saveName .. '.txt', 100, 200)
end

return saveLoad
