-- Charger les différents modules
local game = require 'game'
local menu = require 'menu'
local saveLoad = require 'save_load'

-- Variables globales
gameState = 'game'
menus = {'Charger', 'Sauvegarder', 'Quitter'}
selectedMenu = 1
selectedFile = 1
width = 1080
height = 720

function love.load()
    -- Configuration de la fenêtre
    love.window.setMode(width, height)
    love.window.setTitle("Game of Life")
    love.keyboard.setKeyRepeat(true)
    love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
    love.graphics.setFont(love.graphics.newFont(40))

    -- Charger les cellules du jeu
    game.load(width, height)
end

function love.update(dt)
    if gameState == 'game' then
        game.update(dt)
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
    end
end
