local grid = require 'grid'

local help = {}
local textStartYCoord = 100

local helpingList = {
    'h: Afficher l\'aide',
    'g: Généreration automatique',
    'l: Générer la dernière génération',
    'r: Remplir la grille aléatoirement',
    'f: Remplir la grille',
    'espace/droite: Générer la prochaine génération',
    'gauche: Générer la génération précédente',
    'return: Effacer la grille',
    'escape: Retourner au jeu',
    'Clic gauche+ctrl/clic molette: Déplacer la grille',
    'Molette: Zoomer/Dézoomer',
    'Clic gauche: Remplir la cellule',
    'Clic droit: Effacer la cellule',
    'Clic droit+shift: Copier la selection',
    'p: Coller la selection',
}
local time = 0

function help.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end
end

function help.keypressed(key)
    if key == 'escape' then
        gameState = 'game'
    elseif key == 'h' then
        gameState = 'game'
    end
end

function help.draw()
    grid.draw(false)

    -- find the starting point of the text with the middle of the longest text
    local longestText = 0
    for i, menu in ipairs(helpingList) do
        if love.graphics.getFont():getWidth(menu) > longestText then
            longestText = love.graphics.getFont():getWidth(menu)
        end
    end
    local textXCoord = (love.graphics.getWidth() - (longestText / 2)) / 2

    -- draw a rectangle around the text
    love.graphics.setColor(0, 0, 0)
    local textHelpHeight = love.graphics.getFont():getHeight('Aide')
    local rectangleHeight = 190 - textHelpHeight + 30 * #helpingList

    -- get the y coordinate of the rectangle to center it
    local rectangleYCoord = (love.graphics.getHeight() - rectangleHeight) / 2

    love.graphics.rectangle('fill', textXCoord - 10, rectangleYCoord, (longestText / 2) + 20, rectangleHeight)

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Aide', textXCoord, rectangleYCoord)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))

    for i, menu in ipairs(helpingList) do
        love.graphics.print(menu, textXCoord, (rectangleYCoord + 80 + 30 * i))
    end

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))
end

return help