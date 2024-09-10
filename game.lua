local grid = require 'grid'

local game = {}
local gridX, gridY = 0, 0

function game.load(width, height)
    -- Initialisation de la grille et des cellules
    grid.init(width, height)
end

function game.update(dt)
    if isGenerating then
        grid.nextGeneration()
    end
    if isGeneratingLastGeneration then
        grid.lastGeneration()
    end
    grid.handleInput()
end

function love.mousepressed(x, y, button)
    if button == 1 and love.keyboard.isDown('lctrl') then
        translate = true
    end
end

function love.mousereleased(x, y, button)
    if button == 1 then
        translate = false
        gridX, gridY = 0, 0
    end
end

function love.mousemoved(x, y, dx, dy)
    if translate then
        gridX = gridX + dx
        gridY = gridY + dy
    end
end

function game.keypressed(key)
    if key == 'space' or key == 'right' then
        grid.nextGeneration()
    elseif key == 'left' then
        grid.lastGeneration()
    elseif key == 'return' or key == 'backspace' then
        grid.clear()
    elseif key == 'escape' then
        gameState = 'menu'
    elseif key == 'g' then
        isGenerating = not isGenerating
    elseif key == 'l' then
        isGeneratingLastGeneration = not isGeneratingLastGeneration
    elseif key == 'r' then
        grid.random()
    end
end

function game.draw()
    if translate then
        love.graphics.translate(gridX, gridY)
    end
    grid.draw()
end

return game
