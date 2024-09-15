local menu = {}

local initialTextXCoord = 100
local dxXTextCord
local time = 0

function menu.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end
end

function menu.init()

end

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
            gameState = 'setting'
        elseif selectedMenu == 4 then
            love.event.quit()
        end
    end
end

function menu.draw(selectedMenu, menus)
    menus = menus or {'Charger', 'Sauvegarder', 'Paramètre', 'Quitter'}

    love.graphics.setColor(0, 0, 0)
    for i, menu in ipairs(menus) do
        if i == selectedMenu then
            love.graphics.setColor(0, 0, 0)
            dxXTextCord = initialTextXCoord + 20
        else
            love.graphics.setColor(217, 217, 217)
            dxXTextCord = initialTextXCoord
        end

        -- maybe there are not other implementation idk
        local offset = math.sin(time + i) * 3
        love.graphics.print(menu, dxXTextCord + offset, (100 + 50 * i))
    end
end

return menu
