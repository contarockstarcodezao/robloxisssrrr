--[[
    RemoteEvents.lua
    Cria todos os eventos remotos necessários para comunicação cliente-servidor
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cria pasta para eventos se não existir
local eventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not eventsFolder then
    eventsFolder = Instance.new("Folder")
    eventsFolder.Name = "RemoteEvents"
    eventsFolder.Parent = ReplicatedStorage
end

-- Cria pasta para funções remotas
local functionsFolder = ReplicatedStorage:FindFirstChild("RemoteFunctions")
if not functionsFolder then
    functionsFolder = Instance.new("Folder")
    functionsFolder.Name = "RemoteFunctions"
    functionsFolder.Parent = ReplicatedStorage
end

local RemoteEvents = {}

-- Função para criar RemoteEvent
local function CreateRemoteEvent(name)
    local event = eventsFolder:FindFirstChild(name)
    if not event then
        event = Instance.new("RemoteEvent")
        event.Name = name
        event.Parent = eventsFolder
    end
    return event
end

-- Função para criar RemoteFunction
local function CreateRemoteFunction(name)
    local func = functionsFolder:FindFirstChild(name)
    if not func then
        func = Instance.new("RemoteFunction")
        func.Name = name
        func.Parent = functionsFolder
    end
    return func
end

-- Eventos de Combate
RemoteEvents.DealDamage = CreateRemoteEvent("DealDamage")
RemoteEvents.NPCDied = CreateRemoteEvent("NPCDied")
RemoteEvents.AttackNPC = CreateRemoteEvent("AttackNPC")

-- Eventos de Sombras
RemoteEvents.CaptureShadow = CreateRemoteEvent("CaptureShadow")
RemoteEvents.DestroyShadow = CreateRemoteEvent("DestroyShadow")
RemoteEvents.EquipShadow = CreateRemoteEvent("EquipShadow")
RemoteEvents.UnequipShadow = CreateRemoteEvent("UnequipShadow")
RemoteEvents.ShadowAttack = CreateRemoteEvent("ShadowAttack")

-- Eventos de UI
RemoteEvents.UpdateHUD = CreateRemoteEvent("UpdateHUD")
RemoteEvents.OpenInventory = CreateRemoteEvent("OpenInventory")
RemoteEvents.CloseInventory = CreateRemoteEvent("CloseInventory")
RemoteEvents.UpdateScoreboard = CreateRemoteEvent("UpdateScoreboard")
RemoteEvents.ShowNotification = CreateRemoteEvent("ShowNotification")

-- Eventos de Dados
RemoteEvents.DataLoaded = CreateRemoteEvent("DataLoaded")
RemoteEvents.DataUpdated = CreateRemoteEvent("DataUpdated")

-- Eventos de Missões
RemoteEvents.MissionCompleted = CreateRemoteEvent("MissionCompleted")
RemoteEvents.MissionProgress = CreateRemoteEvent("MissionProgress")
RemoteEvents.ClaimMissionReward = CreateRemoteEvent("ClaimMissionReward")

-- Eventos de Zona
RemoteEvents.TeleportToZone = CreateRemoteEvent("TeleportToZone")
RemoteEvents.ZoneEntered = CreateRemoteEvent("ZoneEntered")

-- Funções Remotas
RemoteEvents.GetPlayerData = CreateRemoteFunction("GetPlayerData")
RemoteEvents.GetShadows = CreateRemoteFunction("GetShadows")
RemoteEvents.GetEquippedShadows = CreateRemoteFunction("GetEquippedShadows")
RemoteEvents.GetMissions = CreateRemoteFunction("GetMissions")
RemoteEvents.GetScoreboardData = CreateRemoteFunction("GetScoreboardData")

return RemoteEvents
