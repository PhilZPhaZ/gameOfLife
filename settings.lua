local settings = {}

function settings.keypressed(key)
   if key == 'escape' then
       gameState = 'menu'
   end
end

function settings.draw()
    love.graphics.setColor(217, 217, 217)
    love.graphics.print('Paramètre', 100, 100)

    love.graphics.print('Largeur : ' .. width, 100, 200)
    love.graphics.print('Hauteur : ' .. height, 100, 250)
end

return settings