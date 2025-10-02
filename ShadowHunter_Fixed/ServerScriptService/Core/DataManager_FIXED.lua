--[[
    DataManager.lua - VERSÃO CORRIGIDA
    Sistema de gerenciamento de dados 100% compatível com todos os sistemas
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_V1")

local DataManager = {}
DataManager.PlayerData = {}

-- ========================================
-- ESTRUTURA PADRÃO DE DADOS (COMPATÍVEL COM TODOS OS SISTEMAS)
-- ========================================

local function GetDefaultData()
    return {
        -- Stats básicos
        Level = 1,
        XP = 0,
        Rank = "F",
        
        -- Moedas
        Cash = 100,
        Diamonds = 10,
        
        -- Stats de combate e sombras
        Stats = {
            -- Player
            PlayerSpeed = 0,
            PlayerDamage = 0,
            PlayerHealth = 0,
            PlayerDefense = 0,
            
            -- Shadow
            ShadowSpeed = 0,
            ShadowDamage = 0,
            ShadowRange = 0,
        },
        
        -- Inventários
        Shadows = {}, -- {ID, Name, Rank, Damage, Health, etc}
        Weapons = {},
        EquippedShadows = {}, -- Máximo 3
        
        -- Missões
        CurrentMissions = {},
        CompletedMissions = {},
        
        -- Estatísticas (COMPATÍVEL COM COMBATSYSTEM E MISSIONSYSTEM)
        Statistics = {
            NPCsKilled = 0,
            ShadowsCaptured = 0,
            ShadowsDestroyed = 0,
            DamageDealt = 0,
            TotalPlayTime = 0,
            BossesKilled = 0,
            Deaths = 0,
        },
        
        -- Configurações
        Settings = {
            MusicVolume = 0.5,
            SFXVolume = 0.7,
            ShowDamageNumbers = true
        },
        
        -- Timestamp
        LastLogin = os.time(),
        CreatedAt = os.time(),
    }
end

-- ========================================
-- LOAD/SAVE
-- ========================================

function DataManager:LoadPlayerData(player)
    print("[DataManager] Carregando dados para:", player.Name)
    
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    if success then
        if data then
            print("[DataManager] ✅ Dados carregados:", player.Name)
            self.PlayerData[player.UserId] = data
            data.LastLogin = os.time()
        else
            print("[DataManager] 📝 Novos dados criados:", player.Name)
            self.PlayerData[player.UserId] = GetDefaultData()
        end
    else
        warn("[DataManager] ❌ Erro ao carregar. Usando dados padrão:", player.Name)
        self.PlayerData[player.UserId] = GetDefaultData()
    end
    
    return self.PlayerData[player.UserId]
end

function DataManager:SavePlayerData(player)
    local playerData = self.PlayerData[player.UserId]
    if not playerData then 
        warn("[DataManager] ❌ Nenhum dado para salvar:", player.Name)
        return false 
    end
    
    local success = pcall(function()
        PlayerDataStore:SetAsync(player.UserId, playerData)
    end)
    
    if success then
        print("[DataManager] ✅ Dados salvos:", player.Name)
        return true
    else
        warn("[DataManager] ❌ Erro ao salvar:", player.Name)
        return false
    end
end

-- ========================================
-- GETTERS
-- ========================================

function DataManager:GetPlayerData(player)
    if not player or not player.UserId then
        warn("[DataManager] Player inválido em GetPlayerData")
        return nil
    end
    return self.PlayerData[player.UserId]
end

-- ========================================
-- XP E LEVEL
-- ========================================

function DataManager:AddXP(player, amount)
    local data = self:GetPlayerData(player)
    if not data then 
        warn("[DataManager] Dados não encontrados para AddXP:", player.Name)
        return 
    end
    
    data.XP = data.XP + amount
    print(string.format("[DataManager] %s ganhou %d XP (Total: %d)", player.Name, amount, data.XP))
    
    -- Verifica level up
    local requiredXP = self:GetRequiredXP(data.Level)
    local leveledUp = false
    
    while data.XP >= requiredXP do
        data.XP = data.XP - requiredXP
        data.Level = data.Level + 1
        leveledUp = true
        
        print(string.format("[DataManager] 🎉 %s subiu para Level %d!", player.Name, data.Level))
        
        -- Atualiza rank baseado no level
        local RankData = require(ReplicatedStorage.Modules.RankData)
        local newRank = RankData:GetRankByLevel(data.Level)
        if newRank.Name ~= data.Rank then
            data.Rank = newRank.Name
            print(string.format("[DataManager] ⭐ %s alcançou Rank %s!", player.Name, newRank.Name))
        end
        
        requiredXP = self:GetRequiredXP(data.Level)
    end
    
    if leveledUp then
        self:UpdateClient(player)
    end
end

function DataManager:GetRequiredXP(level)
    return math.floor(100 * (level ^ 1.5))
end

-- ========================================
-- MOEDAS
-- ========================================

function DataManager:AddCash(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    data.Cash = data.Cash + amount
    print(string.format("[DataManager] %s ganhou %d Cash", player.Name, amount))
    self:UpdateClient(player)
end

function DataManager:AddDiamonds(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    data.Diamonds = data.Diamonds + amount
    print(string.format("[DataManager] %s ganhou %d Diamonds", player.Name, amount))
    self:UpdateClient(player)
end

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

-- ========================================
-- SOMBRAS
-- ========================================

function DataManager:AddShadow(player, shadowData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    table.insert(data.Shadows, shadowData)
    data.Statistics.ShadowsCaptured = data.Statistics.ShadowsCaptured + 1
    
    print(string.format("[DataManager] %s capturou sombra: %s (Rank %s)", 
        player.Name, shadowData.Name, shadowData.Rank))
    
    self:UpdateClient(player)
    return true
end

function DataManager:EquipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false, "Dados não encontrados" end
    
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
    print(string.format("[DataManager] %s equipou sombra: %s", player.Name, shadow.Name))
    self:UpdateClient(player)
    return true
end

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

-- ========================================
-- ESTATÍSTICAS
-- ========================================

function DataManager:IncrementStatistic(player, statName, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Statistics then return false end
    
    if data.Statistics[statName] ~= nil then
        data.Statistics[statName] = data.Statistics[statName] + (amount or 1)
        return true
    else
        warn(string.format("[DataManager] Estatística não existe: %s", statName))
        return false
    end
end

-- ========================================
-- ATUALIZAÇÃO DO CLIENTE
-- ========================================

function DataManager:UpdateClient(player)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    -- Procura RemoteEvents
    local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if not RemoteEvents then
        warn("[DataManager] RemoteEvents folder não encontrado!")
        return
    end
    
    local DataUpdated = RemoteEvents:FindFirstChild("DataUpdated")
    if DataUpdated then
        DataUpdated:FireClient(player, data)
    end
end

-- ========================================
-- AUTO-SAVE
-- ========================================

function DataManager:StartAutoSave()
    spawn(function()
        while true do
            wait(300) -- 5 minutos
            local count = 0
            for _, player in ipairs(Players:GetPlayers()) do
                if self:SavePlayerData(player) then
                    count = count + 1
                end
            end
            print(string.format("[DataManager] 💾 Auto-save: %d jogadores", count))
        end
    end)
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

function DataManager:Init()
    print("[DataManager] 🚀 Inicializando...")
    
    -- Player Added
    Players.PlayerAdded:Connect(function(player)
        local data = self:LoadPlayerData(player)
        
        -- Envia dados iniciais para o cliente
        wait(1) -- Aguarda cliente carregar
        
        local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
        if RemoteEvents then
            local DataLoaded = RemoteEvents:FindFirstChild("DataLoaded")
            if DataLoaded then
                DataLoaded:FireClient(player, data)
            end
        end
    end)
    
    -- Player Removing
    Players.PlayerRemoving:Connect(function(player)
        self:SavePlayerData(player)
        self.PlayerData[player.UserId] = nil
    end)
    
    -- Game Closing
    game:BindToClose(function()
        print("[DataManager] 🛑 Salvando todos os jogadores...")
        for _, player in ipairs(Players:GetPlayers()) do
            self:SavePlayerData(player)
        end
        wait(2)
    end)
    
    -- Auto-save
    self:StartAutoSave()
    
    -- Setup Remote Functions
    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
    local RemoteFunctions = ReplicatedStorage:WaitForChild("RemoteFunctions", 5)
    
    if RemoteFunctions then
        local GetPlayerData = RemoteFunctions:FindFirstChild("GetPlayerData")
        if GetPlayerData then
            GetPlayerData.OnServerInvoke = function(player)
                return self:GetPlayerData(player)
            end
        end
        
        local GetShadows = RemoteFunctions:FindFirstChild("GetShadows")
        if GetShadows then
            GetShadows.OnServerInvoke = function(player)
                local data = self:GetPlayerData(player)
                return data and data.Shadows or {}
            end
        end
        
        local GetEquippedShadows = RemoteFunctions:FindFirstChild("GetEquippedShadows")
        if GetEquippedShadows then
            GetEquippedShadows.OnServerInvoke = function(player)
                return self:GetEquippedShadows(player)
            end
        end
    end
    
    print("[DataManager] ✅ Inicializado com sucesso!")
end

return DataManager
