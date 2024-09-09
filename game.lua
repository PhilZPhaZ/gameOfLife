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
    grid.handleInput()
end

function game.keypressed(key)
    if key == 'space' then
        grid.nextGeneration()
    elseif key == 'return' or key == 'backspace' then
        grid.clear()
    elseif key == 'escape' then
        gameState = 'menu'
    elseif key == 'g' then
        isGenerating = not isGenerating
    elseif key == 'r' then
        grid.random()
    end
end

function game.draw()
    grid.draw()
end

return game
