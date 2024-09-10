local settings = {}

function settings.keypressed(key)
   if key == 'escape' then
       gameState = 'menu'
   end 
end

function settings.draw()
    love.graphics.setColor(217, 217, 217)
    love.graphics.print('Paramètre', 100, 100)
    love.graphics.print('Touches', 100, 200)
    love.graphics.print('Echap : Retour au menu', 100, 250)
    love.graphics.print('Espace / flèche droite : Générer une nouvelle génération', 100, 300)
    love.graphics.print('Entrée / retour arrière : Effacer la grille', 100, 350)
    love.graphics.print('G : Activer/désactiver la génération automatique', 100, 400)
    love.graphics.print('R : Remplir la grille aléatoirement', 100, 450)
end

return settings