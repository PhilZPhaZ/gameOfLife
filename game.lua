local grid = require 'grid'
local clr = require 'clearing_confirmation'

local game = {}


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
    elseif key == 'g' then
        isGenerating = not isGenerating
    elseif key == 'l' then
        isGeneratingLastGeneration = not isGeneratingLastGeneration
    elseif key == 'r' then
        grid.random()
    end
end

--[[
will have to completely rework this function and the game's core
]]
function game.draw()
    grid.draw()
end

return game
