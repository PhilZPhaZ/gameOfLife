local grid = require 'grid'

clearing_confirmation = {}
local yesNomenu = {'Oui', 'Non'}
local selectedMenu = 1

function clearing_confirmation.keypressed(key)
    if key == 'right' then
        selectedMenu = selectedMenu + 1
        if selectedMenu > #yesNomenu then
            selectedMenu = 1
        end
    elseif key == 'left' then
        selectedMenu = selectedMenu - 1
        if selectedMenu < 1 then
            selectedMenu = #yesNomenu
        end
    elseif key == 'return' then
        if selectedMenu == 1 then
            grid.clear()
            gameState = 'game'
        elseif selectedMenu == 2 then
            gameState = 'game'
            selectedMenu = 1
        end
    elseif key == 'escape' then
        gameState = 'game'
    end
end

function clearing_confirmation.draw()
    grid.draw(true)

    local rectangleWidth = 300
    local rectangleHeight = 90

    local mh = (love.graphics.getWidth() - rectangleWidth) / 2
    local mv = (love.graphics.getHeight() - rectangleHeight) / 2

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', mh, mv, rectangleWidth, rectangleHeight)

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))

    local eraseConfirmationText = 'Effacer ?'
    local eraseConfirmationTextWidth = love.graphics.getFont():getWidth(eraseConfirmationText)
    love.graphics.print(eraseConfirmationText, mh + (rectangleWidth - eraseConfirmationTextWidth) / 2, mv + 5)

    local yesMargin = 50
    local noText = 'Non'
    local noTextWidth = love.graphics.getFont():getWidth(noText)
    local yesText = 'Oui'
    local yesTextWidth = love.graphics.getFont():getWidth(yesText)
    local yesPlusMarginSize = yesTextWidth + yesMargin

    local differenceBetweenWidthAndNoTextWidth = rectangleWidth - noTextWidth
    local differenceBetweenWidthAndNoTextWidthMargin = differenceBetweenWidthAndNoTextWidth - 2 * yesMargin


    for i, text in ipairs(yesNomenu) do
        if i == selectedMenu then
            local textWidth = love.graphics.getFont():getWidth(text)
            local textHeight = love.graphics.getFont():getHeight(text)
            love.graphics.setColor(255, 255, 255)
            love.graphics.rectangle('fill', mh + yesMargin + (i - 1) * differenceBetweenWidthAndNoTextWidthMargin, mv + 50, textWidth, textHeight)
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(217, 217, 217)
        end
        local textWidth = love.graphics.getFont():getWidth(text)
        -- horizontal not vertical
        love.graphics.print(text, mh + yesMargin + (i - 1) * differenceBetweenWidthAndNoTextWidthMargin, mv + 50)
        -- draw a rectangle around the text which is selected
            
    end

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))
end

return clearing_confirmation