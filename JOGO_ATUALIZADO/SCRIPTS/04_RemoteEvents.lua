--[[
    RemoteEvents.lua
    Cole em: ReplicatedStorage/Events/RemoteEvents (ModuleScript)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = {}

RemoteEvents.AttackNPC = ReplicatedStorage.RemoteEvents:WaitForChild("AttackNPC")
RemoteEvents.NPCDied = ReplicatedStorage.RemoteEvents:WaitForChild("NPCDied")
RemoteEvents.CaptureShadow = ReplicatedStorage.RemoteEvents:WaitForChild("CaptureShadow")
RemoteEvents.DestroyShadow = ReplicatedStorage.RemoteEvents:WaitForChild("DestroyShadow")
RemoteEvents.EquipShadow = ReplicatedStorage.RemoteEvents:WaitForChild("EquipShadow")
RemoteEvents.UnequipShadow = ReplicatedStorage.RemoteEvents:WaitForChild("UnequipShadow")
RemoteEvents.UpdateHUD = ReplicatedStorage.RemoteEvents:WaitForChild("UpdateHUD")
RemoteEvents.DataLoaded = ReplicatedStorage.RemoteEvents:WaitForChild("DataLoaded")
RemoteEvents.DataUpdated = ReplicatedStorage.RemoteEvents:WaitForChild("DataUpdated")
RemoteEvents.ShowNotification = ReplicatedStorage.RemoteEvents:WaitForChild("ShowNotification")
RemoteEvents.MissionCompleted = ReplicatedStorage.RemoteEvents:WaitForChild("MissionCompleted")

RemoteEvents.GetPlayerData = ReplicatedStorage.RemoteFunctions:WaitForChild("GetPlayerData")
RemoteEvents.GetShadows = ReplicatedStorage.RemoteFunctions:WaitForChild("GetShadows")
RemoteEvents.GetEquippedShadows = ReplicatedStorage.RemoteFunctions:WaitForChild("GetEquippedShadows")
RemoteEvents.GetMissions = ReplicatedStorage.RemoteFunctions:WaitForChild("GetMissions")

return RemoteEvents
