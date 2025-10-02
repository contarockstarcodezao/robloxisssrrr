--[[
    MainServer.lua
    Script principal do servidor - Inicializa todos os sistemas
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== Iniciando Shadow Hunter Server ===")

-- Aguarda criação de RemoteEvents
local RemoteEventsModule = require(ReplicatedStorage.Events.RemoteEvents)
wait(0.5)

-- Inicializa sistemas core
local DataManager = require(ServerScriptService.Core.DataManager)
local RankSystem = require(ServerScriptService.Core.RankSystem)
local MissionSystem = require(ServerScriptService.Core.MissionSystem)

-- Inicializa DataManager primeiro
DataManager:Init()
wait(0.2)

-- Inicializa RankSystem
RankSystem:Init(DataManager)
wait(0.2)

-- Inicializa sistemas de combate
local NPCManager = require(ServerScriptService.Combat.NPCManager)
local CombatSystem = require(ServerScriptService.Combat.CombatSystem)
local ShadowSystem = require(ServerScriptService.Combat.ShadowSystem)

NPCManager:Init()
wait(0.2)

-- Inicializa MissionSystem
MissionSystem:Init(DataManager, RankSystem)
wait(0.2)

-- Inicializa CombatSystem
CombatSystem:Init(DataManager, NPCManager, RankSystem, MissionSystem)
wait(0.2)

-- Inicializa ShadowSystem
ShadowSystem:Init(DataManager, MissionSystem)
wait(0.2)

-- Inicializa ZoneManager
local ZoneManager = require(ServerScriptService.Zones.ZoneManager)
ZoneManager:Init(NPCManager, RankSystem)

print("=== Shadow Hunter Server Inicializado com Sucesso! ===")

-- Mensagem de boas-vindas
game.Players.PlayerAdded:Connect(function(player)
    wait(2)
    local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
    RemoteEvents.ShowNotification:FireClient(
        player,
        "🎮 Bem-vindo ao Shadow Hunter! 🎮",
        "Derrote NPCs, capture sombras e torne-se o mais forte!",
        Color3.fromRGB(255, 215, 0)
    )
end)
