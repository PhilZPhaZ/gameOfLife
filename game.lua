local grid = require 'grid'

local game = {}

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
    grid.draw()
end

return game
