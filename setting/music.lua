local musicSetting = {}

local soundVolume = 1
local musicSettingMenu = {
    'Desactiver la musique',
    'Changer la musique',
    'Volume : ' .. (soundVolume * 100) .. '%',
    'Retour'}
local time = 0
local selectedMenuMusic = 1
local initialTextXCoord = 100
local dxXTextCord
local soundVolumeChanging = 0.1

function musicSetting.keypressed(key)
    if key == 'escape' then
        gameState = 'setting'
    elseif key == 'up' then
        selectedMenuMusic = selectedMenuMusic - 1
        if selectedMenuMusic < 1 then
            selectedMenuMusic = #musicSettingMenu
        end
    elseif key == 'down' then
        selectedMenuMusic = selectedMenuMusic + 1
        if selectedMenuMusic > #musicSettingMenu then
            selectedMenuMusic = 1
        end
    elseif key == 'return' then
        if selectedMenuMusic == 1 then
            isPlaying = not isPlaying
            musicSettingMenu[1] = isPlaying and 'Desactiver la musique' or 'Activer la musique'
        elseif selectedMenuMusic == 2 then
            -- stop the current music
            source[musicIndex]:stop()

            musicIndex = musicIndex + 1
            if musicIndex > #source then
                musicIndex = 1
            end
            source[musicIndex]:play()
        elseif selectedMenuMusic == 3 then
            if soundVolume == 0 then
                soundVolume = 1
            else
                soundVolume = soundVolume - soundVolumeChanging

                if soundVolume < soundVolumeChanging then
                    soundVolume = 0
                end
            end

            musicSettingMenu[2] = 'Volume : ' .. (soundVolume * 100) .. '%'
            source[musicIndex]:setVolume(soundVolume)
        elseif selectedMenuMusic == 3 then
            gameState = 'setting'
        end
    elseif key == 'right' and selectedMenuMusic == 3 then
        soundVolume = soundVolume + soundVolumeChanging
        if soundVolume > 1 then
            soundVolume = 1
        end
        musicSettingMenu[2] = 'Volume : ' .. (soundVolume * 100) .. '%'
        source[musicIndex]:setVolume(soundVolume)
    elseif key == 'left' and selectedMenuMusic == 3 then
        soundVolume = soundVolume - soundVolumeChanging
        if soundVolume < soundVolumeChanging then
            soundVolume = 0
        end
        musicSettingMenu[2] = 'Volume : ' .. (soundVolume * 100) .. '%'
        source[musicIndex]:setVolume(soundVolume)
    end
end

function musicSetting.update(dt)
    time = time + dt
    if time > 6.28 then
        time = 0
    end

    if selectedMenuMusic == 2 then
        isChangingVolume = true
    else
        isChangingVolume = false
    end
end

function musicSetting.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 60))
    love.graphics.print('Musique', 100, 100)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    for i, menu in ipairs(musicSettingMenu) do
        if i == selectedMenuMusic then
            love.graphics.setColor(0, 0, 0)
            dxXTextCord = initialTextXCoord + 20
        else
            love.graphics.setColor(217, 217, 217)
            dxXTextCord = initialTextXCoord
        end

        local offset = math.sin(time + i) * 3
        love.graphics.print(menu, dxXTextCord + offset, (150 + 50 * i))
    end
end

return musicSetting