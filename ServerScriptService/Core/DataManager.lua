--[[
    DataManager.lua
    Gerencia todos os dados dos jogadores (save/load)
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_V1")
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local RankData = require(ReplicatedStorage.Modules.RankData)

local DataManager = {}
DataManager.PlayerData = {}

-- Estrutura padrão dos dados do jogador
local function GetDefaultData()
    return {
        -- Stats básicos
        Level = 1,
        XP = 0,
        Rank = "F",
        
        -- Moedas
        Cash = 100,
        Diamonds = 10,
        
        -- Inventários
        Shadows = {}, -- {ID, Name, Rank, Damage, Health, etc}
        Weapons = {}, -- Sistema expansível
        EquippedShadows = {}, -- Máximo 3
        
        -- Missões
        CurrentMissions = {},
        CompletedMissions = {},
        
        -- Estatísticas
        Stats = {
            NPCsKilled = 0,
            ShadowsCaptured = 0,
            ShadowsDestroyed = 0,
            DamageDealt = 0,
            TotalPlayTime = 0
        },
        
        -- Configurações
        Settings = {
            MusicVolume = 0.5,
            SFXVolume = 0.7,
            ShowDamageNumbers = true
        },
        
        -- Timestamp
        LastLogin = os.time(),
        CreatedAt = os.time()
    }
end

-- Carrega dados do jogador
function DataManager:LoadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    if success then
        if data then
            print("[DataManager] Dados carregados para:", player.Name)
            self.PlayerData[player.UserId] = data
            data.LastLogin = os.time()
        else
            print("[DataManager] Novos dados criados para:", player.Name)
            self.PlayerData[player.UserId] = GetDefaultData()
        end
    else
        warn("[DataManager] Erro ao carregar dados de:", player.Name)
        self.PlayerData[player.UserId] = GetDefaultData()
    end
    
    -- Envia dados para o cliente
    local playerData = self.PlayerData[player.UserId]
    RemoteEvents.DataLoaded:FireClient(player, playerData)
    
    return self.PlayerData[player.UserId]
end

-- Salva dados do jogador
function DataManager:SavePlayerData(player)
    local playerData = self.PlayerData[player.UserId]
    if not playerData then return false end
    
    local success = pcall(function()
        PlayerDataStore:SetAsync(player.UserId, playerData)
    end)
    
    if success then
        print("[DataManager] Dados salvos para:", player.Name)
        return true
    else
        warn("[DataManager] Erro ao salvar dados de:", player.Name)
        return false
    end
end

-- Obtém dados do jogador
function DataManager:GetPlayerData(player)
    return self.PlayerData[player.UserId]
end

-- Adiciona XP ao jogador
function DataManager:AddXP(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    data.XP = data.XP + amount
    
    -- Verifica level up
    local requiredXP = self:GetRequiredXP(data.Level)
    while data.XP >= requiredXP do
        data.XP = data.XP - requiredXP
        data.Level = data.Level + 1
        
        -- Atualiza rank baseado no level
        local newRank = RankData:GetRankByLevel(data.Level)
        if newRank.Name ~= data.Rank then
            data.Rank = newRank.Name
            RemoteEvents.ShowNotification:FireClient(
                player, 
                "Rank Up!", 
                "Você alcançou o Rank " .. newRank.Name .. "!",
                newRank.Color
            )
        end
        
        RemoteEvents.ShowNotification:FireClient(
            player, 
            "Level Up!", 
            "Você alcançou o Level " .. data.Level .. "!",
            Color3.fromRGB(255, 215, 0)
        )
        
        requiredXP = self:GetRequiredXP(data.Level)
    end
    
    self:UpdateClient(player)
end

-- Calcula XP necessário para próximo level
function DataManager:GetRequiredXP(level)
    return math.floor(100 * (level ^ 1.5))
end

-- Adiciona Cash
function DataManager:AddCash(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    data.Cash = data.Cash + amount
    self:UpdateClient(player)
end

-- Adiciona Diamantes
function DataManager:AddDiamonds(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    data.Diamonds = data.Diamonds + amount
    self:UpdateClient(player)
end

-- Remove Cash
function DataManager:RemoveCash(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    if data.Cash >= amount then
        data.Cash = data.Cash - amount
        self:UpdateClient(player)
        return true
    end
    return false
end

-- Remove Diamantes
function DataManager:RemoveDiamonds(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    if data.Diamonds >= amount then
        data.Diamonds = data.Diamonds - amount
        self:UpdateClient(player)
        return true
    end
    return false
end

-- Adiciona sombra ao inventário
function DataManager:AddShadow(player, shadowData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    table.insert(data.Shadows, shadowData)
    data.Stats.ShadowsCaptured = data.Stats.ShadowsCaptured + 1
    
    self:UpdateClient(player)
    return true
end

-- Equipa sombra
function DataManager:EquipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    -- Máximo 3 sombras equipadas
    if #data.EquippedShadows >= 3 then
        return false, "Máximo de 3 sombras equipadas"
    end
    
    -- Verifica se a sombra existe
    local shadow = nil
    for _, s in ipairs(data.Shadows) do
        if s.ID == shadowID then
            shadow = s
            break
        end
    end
    
    if not shadow then
        return false, "Sombra não encontrada"
    end
    
    -- Verifica se já está equipada
    for _, id in ipairs(data.EquippedShadows) do
        if id == shadowID then
            return false, "Sombra já equipada"
        end
    end
    
    table.insert(data.EquippedShadows, shadowID)
    self:UpdateClient(player)
    return true
end

-- Desequipa sombra
function DataManager:UnequipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    for i, id in ipairs(data.EquippedShadows) do
        if id == shadowID then
            table.remove(data.EquippedShadows, i)
            self:UpdateClient(player)
            return true
        end
    end
    
    return false
end

-- Obtém sombras equipadas
function DataManager:GetEquippedShadows(player)
    local data = self:GetPlayerData(player)
    if not data then return {} end
    
    local equipped = {}
    for _, shadowID in ipairs(data.EquippedShadows) do
        for _, shadow in ipairs(data.Shadows) do
            if shadow.ID == shadowID then
                table.insert(equipped, shadow)
                break
            end
        end
    end
    
    return equipped
end

-- Atualiza cliente com novos dados
function DataManager:UpdateClient(player)
    local data = self:GetPlayerData(player)
    if data then
        RemoteEvents.DataUpdated:FireClient(player, data)
    end
end

-- Auto-save a cada 5 minutos
function DataManager:StartAutoSave()
    spawn(function()
        while true do
            wait(300) -- 5 minutos
            for _, player in ipairs(Players:GetPlayers()) do
                self:SavePlayerData(player)
            end
        end
    end)
end

-- Inicialização
function DataManager:Init()
    -- Carrega dados quando jogador entra
    Players.PlayerAdded:Connect(function(player)
        self:LoadPlayerData(player)
    end)
    
    -- Salva dados quando jogador sai
    Players.PlayerRemoving:Connect(function(player)
        self:SavePlayerData(player)
        self.PlayerData[player.UserId] = nil
    end)
    
    -- Auto-save
    self:StartAutoSave()
    
    -- Setup Remote Functions
    RemoteEvents.GetPlayerData.OnServerInvoke = function(player)
        return self:GetPlayerData(player)
    end
    
    RemoteEvents.GetShadows.OnServerInvoke = function(player)
        local data = self:GetPlayerData(player)
        return data and data.Shadows or {}
    end
    
    RemoteEvents.GetEquippedShadows.OnServerInvoke = function(player)
        return self:GetEquippedShadows(player)
    end
    
    print("[DataManager] Inicializado com sucesso!")
end

return DataManager
