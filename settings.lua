local settings = {}

local settingsMenu = {'Musique', 'Fullscreen', 'Resolution', 'Retour'}
local selectedMenu = 1
local time = 0
local initialTextXCoord = 100
local dxXTextCord
local musicSetting = false

function settings.keypressed(key)
    if key == 'escape' then
        gameState = 'menu'
    elseif key == 'up' then
        selectedMenu = selectedMenu - 1
        if selectedMenu < 1 then
            selectedMenu = #settingsMenu
        end
    elseif key == 'down' then
        selectedMenu = selectedMenu + 1
        if selectedMenu > #settingsMenu then
            selectedMenu = 1
        end
    elseif key == 'return' then
        if selectedMenu == 1 then
            gameState = 'musicSetting'
        elseif selectedMenu == 2 then
            love.window.setFullscreen(not love.window.getFullscreen())
        elseif selectedMenu == 3 then
            
        elseif selectedMenu == 4 then
            gameState = 'menu'
        end
    end
end

function settings.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end
end

function settings.draw()
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Paramètre', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    for i, menu in ipairs(settingsMenu) do
        if i == selectedMenu then
            love.graphics.setColor(0, 0, 0)
            dxXTextCord = initialTextXCoord + 20
        else
            love.graphics.setColor(1, 1, 1)
            dxXTextCord = initialTextXCoord
        end

        local offset = math.sin(time + i) * 3
        love.graphics.print(menu, dxXTextCord + offset, (150 + 50 * i))
    end
end

return settings