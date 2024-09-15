local grid = require 'grid'
local clr = require 'clearing_confirmation'

local game = {}
local source

function game.load(width, height)

end

function game.update(dt)
    if isGenerating then
        grid.nextGeneration()
    end
    if isGeneratingLastGeneration then

    end

    grid.handleInput()
end

function game.keypressed(key)
    if key == 'space' or key == 'right' then
        grid.nextGeneration()
    elseif key == 'return' or key == 'backspace' then
        gameState = 'clearing_confirmation'
    elseif key == 'escape' then
        gameState = 'menu'
    elseif key == 'h' then
        gameState = 'help'
    elseif key == 'g' then
        isGenerating = not isGenerating
    elseif key == 'l' then
        isGeneratingLastGeneration = not isGeneratingLastGeneration
    elseif key == 'r' then
        grid.random()
    elseif key == 'f' then
        grid.fill()
    end
end

function game.draw()
    grid.draw(true)
end

return game
