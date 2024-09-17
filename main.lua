--[[
    Projet: Game of Life
    Auteur: philzphaz
    Date de création: 2024
    Description: Conway Game of Life
    Version: 0.2.0

    note: - need to work on optimisation because it's not bad but it could be better
]]

-- load modules
local game = require 'game'
local menu = require 'menu'
local saveLoad = require 'save_load'
local setting = require 'settings'
local musicSetting = require 'setting.music'
local help = require 'help'
local resolution = require 'setting.resolution'
local clearing_confirmation = require 'clearing_confirmation'
local grid = require 'grid'

-- globals variable
gameState = 'game'
menus = {'Charger', 'Sauvegarder', 'Paramètre', 'Retour', 'Quitter'}
selectedFile = 1
selectedMenu = 1
width = 1080
height = 720
isGenerating = false
isGeneratingLastGeneration = false

-- GRID
GRID = {}
cellSize = 20
translate = false
gridX, gridY = 0, 0

-- music setting
isPlaying = true
soundVolume = 1

function love.load()
    -- Configuration de la fenêtre
    love.window.setMode(width, height, {resizable = true, minwidth = 1080, minheight = 720})
    love.window.setTitle("Game of Life")
    love.keyboard.setKeyRepeat(true)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    love.graphics.setFont(love.graphics.newFont('assets/fonts/8bitoperator.ttf', 40))

    -- music
    source = love.audio.newSource('assets/audio/pixel_dream_in_motion.mp3', 'stream')

    -- load the game
    game.load()
end

function love.update(dt)
    if gameState == 'game' then
        game.update(dt)
    elseif gameState == 'menu' then
        menu.update(dt)
    elseif gameState == 'selectLoad' then
        saveLoad.update(dt)
    elseif gameState == 'selectSave' then
        saveLoad.update(dt)
    elseif gameState == 'setting' then
        setting.update(dt)
    elseif gameState == 'musicSetting' then
        musicSetting.update(dt)
    elseif gameState == 'help' then
        help.update(dt)
    elseif gameState == 'resolution' then
        resolution.update(dt)
    end

    if isPlaying then
        if not source:isPlaying() then
            source:play()
        end
    else
        source:stop()
    end
end

function love.keypressed(key)
    if gameState == 'game' then
        game.keypressed(key)
    elseif gameState == 'menu' then
        menu.keypressed(key)
    elseif gameState == 'selectLoad' then
        saveLoad.loadKeypressed(key)
    elseif gameState == 'selectSave' then
        saveLoad.saveKeypressed(key)
    elseif gameState == 'setting' then
        setting.keypressed(key)
    elseif gameState == 'clearing_confirmation' then
        clearing_confirmation.keypressed(key)
    elseif gameState == 'musicSetting' then
        musicSetting.keypressed(key)
    elseif gameState == 'help' then
        help.keypressed(key)
    elseif gameState == 'resolution' then
        resolution.keypressed(key)
    end
end

function love.draw()
    if gameState == 'game' then
        game.draw()
    elseif gameState == 'menu' then
        menu.draw(selectedMenu, menus)
    elseif gameState == 'selectLoad' then
        saveLoad.drawLoadMenu()
    elseif gameState == 'selectSave' then
        saveLoad.drawSaveMenu()
    elseif gameState == 'setting' then
        setting.draw()
    elseif gameState == 'clearing_confirmation' then
        clearing_confirmation.draw()
    elseif gameState == 'musicSetting' then
        musicSetting.draw()
    elseif gameState == 'help' then
        help.draw()
    elseif gameState == 'resolution' then
        resolution.draw()
    end
end

function love.mousepressed(x, y, button)
    if gameState == 'game' then
        grid.mousepressed(x, y, button)
    end
end

function love.mousereleased(x, y, button)
    if gameState == 'game' then
        grid.mousereleased(x, y, button)
    end
end

function love.wheelmoved(x, y)
    if gameState == 'game' then
        grid.wheelmoved(x, y)
    end
end

function love.mousemoved(x, y, dx, dy)
    if gameState == 'game' then
        grid.mousemoved(x, y, dx, dy)
    end
end

function love.exit()
    source:stop()
end
