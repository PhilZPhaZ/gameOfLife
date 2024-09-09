local menu = {}

function menu.keypressed(key)
    if key == 'escape' then
        gameState = 'game'
    elseif key == 'up' then
        selectedMenu = selectedMenu - 1
        if selectedMenu < 1 then
            selectedMenu = #menus
        end
    elseif key == 'down' then
        selectedMenu = selectedMenu + 1
        if selectedMenu > #menus then
            selectedMenu = 1
        end
    elseif key == 'return' then
        if selectedMenu == 1 then
            gameState = 'selectLoad'
        elseif selectedMenu == 2 then
            gameState = 'selectSave'
        elseif selectedMenu == 3 then
            love.event.quit()
        end
    end
end

function menu.draw(selectedMenu, menus)
    love.graphics.setColor(0, 0, 0)
    for i, menu in ipairs(menus) do
        if i == selectedMenu then
            love.graphics.setColor(0, 0, 0)
        else
            love.graphics.setColor(217, 217, 217)
        end
        love.graphics.print(menu, 100, 100 + 50 * i)
    end
end

return menu
