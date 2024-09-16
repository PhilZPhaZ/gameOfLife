local resolution = {}
-- resolution menu greater than 1080x720
local resolutionMenu = {
    '1080x720',
    '1280x720',
    '1366x768',
    '1600x900',
    '1920x1080',
    '2560x1440',
    '3840x2160',
    'Retour'
}
local time = 0
local initialTextXCoord = 100
local selectedResolutionMenu = 1

function resolution.load()

end

function resolution.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end
end

function resolution.keypressed(key)
    if key == 'escape' then
        gameState = 'setting'
    elseif key == 'up' then
        selectedResolutionMenu = selectedResolutionMenu - 1
        if selectedResolutionMenu < 1 then
            selectedResolutionMenu = #resolutionMenu
        end
    elseif key == 'down' then
        selectedResolutionMenu = selectedResolutionMenu + 1
        if selectedResolutionMenu > #resolutionMenu then
            selectedResolutionMenu = 1
        end
    elseif key == 'return' then
        if selectedResolutionMenu == 1 then
            love.window.setMode(1080, 720)
        elseif selectedResolutionMenu == 2 then
            love.window.setMode(1280, 720)
        elseif selectedResolutionMenu == 3 then
            love.window.setMode(1366, 768)
        elseif selectedResolutionMenu == 4 then
            love.window.setMode(1600, 900)
        elseif selectedResolutionMenu == 5 then
            love.window.setMode(1920, 1080)
        elseif selectedResolutionMenu == 6 then
            love.window.setMode(2560, 1440)
        elseif selectedResolutionMenu == 7 then
            love.window.setMode(3840, 2160)
        elseif selectedResolutionMenu == 8 then
            gameState = 'setting'
        end
    end
end

function resolution.draw()
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.setColor(1, 1, 1)
    love.graphics.print('Résolution', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    for i, menu in ipairs(resolutionMenu) do
        if i == selectedResolutionMenu then
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

return resolution