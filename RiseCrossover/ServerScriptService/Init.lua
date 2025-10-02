--[[
    Init.lua
    Script de inicialização do servidor
    Coloque este script em ServerScriptService
]]

local ServerScriptService = game:GetService("ServerScriptService")

print("=== Iniciando Rise Crossover ===")

-- Carrega DataManager
local DataManager = require(ServerScriptService.Core.DataManager)

-- Inicializa
DataManager:Init()

print("=== Rise Crossover inicializado! ===")

-- Exporta para outros scripts acessarem
_G.DataManager = DataManager

return DataManager
