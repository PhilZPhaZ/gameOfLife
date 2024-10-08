local grid = require 'grid'

local game = {}

function game.load()
    grid.init()
end

function game.update(dt)
    if isGenerating then
        grid.nextGeneration()
    end
    if isGeneratingLastGeneration then
        -- grid.previousGeneration()
    end

    grid.update(dt)
    grid.handleInput()
end

function game.keypressed(key)
    if key == 'space' or key == 'right' then
        grid.nextGeneration()
    elseif key == 'left' then
        -- grid.previousGeneration()
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
    elseif key == 'p' then
        isPasting = not isPasting
    elseif key == 'w' then
        grid.rotateSelect()
    elseif key == 'x' then
        grid.flipSelection()
    end
end

function game.draw()
    grid.draw(true)
end

return game
