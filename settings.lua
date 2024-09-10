local settings = {}

function settings.keypressed(key)
   if key == 'escape' then
       gameState = 'menu'
   end 
end

function settings.draw()
    love.graphics.setColor(217, 217, 217)
    love.graphics.print('Paramètre', 100, 100)
    love.graphics.print('Pas encore implémenté', 100, 200)
end

return settings