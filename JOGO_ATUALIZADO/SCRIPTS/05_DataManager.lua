--[[
    DataManager.lua - CORRIGIDO
    Cole em: ServerScriptService/Core/DataManager (Script)
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_V1")

local DataManager = {}
DataManager.PlayerData = {}

local function GetDefaultData()
    return {
        Level = 1, XP = 0, Rank = "F", Cash = 100, Diamonds = 10,
        Stats = {PlayerSpeed = 0, PlayerDamage = 0, PlayerHealth = 0, PlayerDefense = 0, ShadowSpeed = 0, ShadowDamage = 0, ShadowRange = 0},
        Shadows = {}, Weapons = {}, EquippedShadows = {}, CurrentMissions = {}, CompletedMissions = {},
        Statistics = {NPCsKilled = 0, ShadowsCaptured = 0, ShadowsDestroyed = 0, DamageDealt = 0, TotalPlayTime = 0},
        Settings = {MusicVolume = 0.5, SFXVolume = 0.7, ShowDamageNumbers = true},
        LastLogin = os.time(), CreatedAt = os.time()
    }
end

function DataManager:LoadPlayerData(player)
    local success, data = pcall(function() return PlayerDataStore:GetAsync(player.UserId) end)
    if success and data then
        self.PlayerData[player.UserId] = data
        data.LastLogin = os.time()
    else
        self.PlayerData[player.UserId] = GetDefaultData()
    end
    return self.PlayerData[player.UserId]
end

function DataManager:SavePlayerData(player)
    local playerData = self.PlayerData[player.UserId]
    if not playerData then return false end
    local success = pcall(function() PlayerDataStore:SetAsync(player.UserId, playerData) end)
    return success
end

function DataManager:GetPlayerData(player)
    return self.PlayerData[player.UserId]
end

function DataManager:AddXP(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    data.XP = data.XP + amount
    local requiredXP = math.floor(100 * (data.Level ^ 1.5))
    while data.XP >= requiredXP do
        data.XP = data.XP - requiredXP
        data.Level = data.Level + 1
        local RankData = require(ReplicatedStorage.Modules.RankData)
        local newRank = RankData:GetRankByLevel(data.Level)
        if newRank.Name ~= data.Rank then data.Rank = newRank.Name end
        requiredXP = math.floor(100 * (data.Level ^ 1.5))
    end
    self:UpdateClient(player)
end

function DataManager:AddCash(player, amount)
    local data = self:GetPlayerData(player)
    if data then data.Cash = data.Cash + amount; self:UpdateClient(player) end
end

function DataManager:AddDiamonds(player, amount)
    local data = self:GetPlayerData(player)
    if data then data.Diamonds = data.Diamonds + amount; self:UpdateClient(player) end
end

function DataManager:AddShadow(player, shadowData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    table.insert(data.Shadows, shadowData)
    data.Statistics.ShadowsCaptured = data.Statistics.ShadowsCaptured + 1
    self:UpdateClient(player)
    return true
end

function DataManager:EquipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    if #data.EquippedShadows >= 3 then return false end
    table.insert(data.EquippedShadows, shadowID)
    self:UpdateClient(player)
    return true
end

function DataManager:UnequipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    for i, id in ipairs(data.EquippedShadows) do
        if id == shadowID then table.remove(data.EquippedShadows, i); self:UpdateClient(player); return true end
    end
    return false
end

function DataManager:GetEquippedShadows(player)
    local data = self:GetPlayerData(player)
    if not data then return {} end
    local equipped = {}
    for _, shadowID in ipairs(data.EquippedShadows) do
        for _, shadow in ipairs(data.Shadows) do
            if shadow.ID == shadowID then table.insert(equipped, shadow); break end
        end
    end
    return equipped
end

function DataManager:IncrementStatistic(player, statName, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Statistics then return false end
    if data.Statistics[statName] ~= nil then
        data.Statistics[statName] = data.Statistics[statName] + (amount or 1)
        return true
    end
    return false
end

function DataManager:UpdateClient(player)
    local data = self:GetPlayerData(player)
    if not data then return end
    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if remoteEvents then
        local dataUpdated = remoteEvents:FindFirstChild("DataUpdated")
        if dataUpdated then dataUpdated:FireClient(player, data) end
    end
end

function DataManager:StartAutoSave()
    spawn(function()
        while true do
            wait(300)
            for _, player in ipairs(Players:GetPlayers()) do
                self:SavePlayerData(player)
            end
        end
    end)
end

function DataManager:Init()
    Players.PlayerAdded:Connect(function(player)
        local data = self:LoadPlayerData(player)
        wait(1)
        local re = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if re then
            local dl = re:FindFirstChild("DataLoaded")
            if dl then dl:FireClient(player, data) end
        end
    end)
    Players.PlayerRemoving:Connect(function(player)
        self:SavePlayerData(player)
        self.PlayerData[player.UserId] = nil
    end)
    game:BindToClose(function()
        for _, player in ipairs(Players:GetPlayers()) do
            self:SavePlayerData(player)
        end
        wait(2)
    end)
    self:StartAutoSave()
    print("[DataManager] ✅ Inicializado")
end

return DataManager
