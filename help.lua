local help = {}

local helpingList = {
    'h: Afficher l\'aide',
    'g: Générer la grille',
    'l: Générer la dernière génération',
    'r: Remplir la grille aléatoirement',
    'f: Remplir la grille',
    'espace: Générer la prochaine génération',
    'return: Effacer la grille',
    'escape: Retourner au menu',
    'Clic gauche: Déplacer la grille',
    'Molette: Zoomer/Dézoomer',
    'Clic gauche: Remplir la cellule',
    'Clic droit: Effacer la cellule'
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
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Aide', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 20))

    for i, menu in ipairs(helpingList) do
        love.graphics.print(menu, 100, (180 + 30 * i))
    end

    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))
end

return help