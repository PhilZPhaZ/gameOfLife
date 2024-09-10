--[[
    Projet: Game of Life
    Auteur: philzphaz
    Date de création: 2024
    Description: Conway Game of Life
    Version: 1.0

    note: - really bad code but it work
          - will add more functionnalies laters
]]

-- load modules
local game = require 'game'
local menu = require 'menu'
local saveLoad = require 'save_load'
local setting = require 'settings'

-- globals variable
gameState = 'game'
menus = {'Charger', 'Sauvegarder', 'Paramètre', 'Quitter'}
selectedMenu = 1
selectedFile = 1
width = 1080
height = 720
isGenerating = false

-- global variable - grid save
gridSave = {}
gridSaveIndex = 1

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
    elseif gameState == 'setting' then
        setting.keypressed(key)
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
    end
end
