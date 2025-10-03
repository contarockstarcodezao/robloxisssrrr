--[[
    DATA MANAGER - Sistema de Salvamento de Dados Persistente
    Sistema completo de salvamento e carregamento de dados
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

print("💾 === DATA MANAGER INICIADO ===")

-- Configurações do DataStore
local DATASTORE_NAME = "AnimeFightersData"
local SAVE_INTERVAL = 300 -- 5 minutos
local MAX_RETRIES = 3

-- Criar pasta de eventos
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not eventsFolder then
    eventsFolder = Instance.new("Folder")
    eventsFolder.Name = "Events"
    eventsFolder.Parent = ReplicatedStorage
end

-- Criar eventos de dados
local dataLoadedEvent = eventsFolder:FindFirstChild("DataLoaded")
if not dataLoadedEvent then
    dataLoadedEvent = Instance.new("RemoteEvent")
    dataLoadedEvent.Name = "DataLoaded"
    dataLoadedEvent.Parent = eventsFolder
end

local dataUpdatedEvent = eventsFolder:FindFirstChild("DataUpdated")
if not dataUpdatedEvent then
    dataUpdatedEvent = Instance.new("RemoteEvent")
    dataUpdatedEvent.Name = "DataUpdated"
    dataUpdatedEvent.Parent = eventsFolder
end

-- Criar RemoteFunctions
local getPlayerDataFunction = eventsFolder:FindFirstChild("GetPlayerData")
if not getPlayerDataFunction then
    getPlayerDataFunction = Instance.new("RemoteFunction")
    getPlayerDataFunction.Name = "GetPlayerData"
    getPlayerDataFunction.Parent = eventsFolder
end

local getShadowsFunction = eventsFolder:FindFirstChild("GetShadows")
if not getShadowsFunction then
    getShadowsFunction = Instance.new("RemoteFunction")
    getShadowsFunction.Name = "GetShadows"
    getShadowsFunction.Parent = eventsFolder
end

local getEquippedShadowsFunction = eventsFolder:FindFirstChild("GetEquippedShadows")
if not getEquippedShadowsFunction then
    getEquippedShadowsFunction = Instance.new("RemoteFunction")
    getEquippedShadowsFunction.Name = "GetEquippedShadows"
    getEquippedShadowsFunction.Parent = eventsFolder
end

-- DataStore
local playerDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)

-- Dados padrão do jogador
local defaultPlayerData = {
    Level = 1,
    XP = 0,
    MaxXP = 100,
    Rank = "F",
    Cash = 1000,
    Diamonds = 10,
    Health = 100,
    MaxHealth = 100,
    Mana = 100,
    MaxMana = 100,
    Power = 0,
    Shadows = {},
    EquippedShadows = {},
    Weapons = {},
    Relics = {},
    Inventory = {},
    Statistics = {
        NPCsDefeated = 0,
        ShadowsCaptured = 0,
        PlayTime = 0,
        TotalDamage = 0,
        HighestLevel = 1
    },
    Settings = {
        Volume = 1.0,
        DisplayMode = "Full",
        Accessibility = {
            ColorBlind = false,
            HighContrast = false,
            LargeText = false
        }
    },
    LastSave = 0,
    Version = "1.0.0"
}

-- Cache de dados dos jogadores
local playerDataCache = {}

-- Sistema de salvamento
local DataManager = {}

-- Função para validar dados
function DataManager:ValidateData(data)
    if not data then return false end
    
    -- Verificar campos obrigatórios
    local requiredFields = {"Level", "XP", "Cash", "Diamonds", "Shadows", "Statistics"}
    for _, field in ipairs(requiredFields) do
        if data[field] == nil then
            print("⚠️ Campo obrigatório ausente:", field)
            return false
        end
    end
    
    -- Validar tipos de dados
    if type(data.Level) ~= "number" or data.Level < 1 then
        print("⚠️ Nível inválido:", data.Level)
        return false
    end
    
    if type(data.Cash) ~= "number" or data.Cash < 0 then
        print("⚠️ Cash inválido:", data.Cash)
        return false
    end
    
    if type(data.Diamonds) ~= "number" or data.Diamonds < 0 then
        print("⚠️ Diamantes inválidos:", data.Diamonds)
        return false
    end
    
    return true
end

-- Função para carregar dados do jogador
function DataManager:LoadPlayerData(player)
    local success, data = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        -- Validar dados carregados
        if self:ValidateData(data) then
            print("✅ Dados carregados para:", player.Name)
            return data
        else
            print("⚠️ Dados inválidos para:", player.Name, "usando dados padrão")
            return self:GetDefaultData()
        end
    else
        print("⚠️ Erro ao carregar dados para:", player.Name, "usando dados padrão")
        return self:GetDefaultData()
    end
end

-- Função para obter dados padrão
function DataManager:GetDefaultData()
    local data = {}
    for key, value in pairs(defaultPlayerData) do
        if type(value) == "table" then
            data[key] = {}
            for k, v in pairs(value) do
                data[key][k] = v
            end
        else
            data[key] = value
        end
    end
    return data
end

-- Função para salvar dados do jogador
function DataManager:SavePlayerData(player, data)
    if not data then
        print("⚠️ Nenhum dado para salvar para:", player.Name)
        return false
    end
    
    -- Validar dados antes de salvar
    if not self:ValidateData(data) then
        print("⚠️ Dados inválidos para:", player.Name)
        return false
    end
    
    -- Adicionar timestamp
    data.LastSave = os.time()
    
    local success, errorMessage = pcall(function()
        playerDataStore:SetAsync(player.UserId, data)
    end)
    
    if success then
        print("✅ Dados salvos para:", player.Name)
        return true
    else
        print("❌ Erro ao salvar dados para:", player.Name, "Erro:", errorMessage)
        return false
    end
end

-- Função para atualizar dados do jogador
function DataManager:UpdatePlayerData(player, key, value)
    if not playerDataCache[player] then
        print("⚠️ Jogador não encontrado no cache:", player.Name)
        return false
    end
    
    local data = playerDataCache[player]
    data[key] = value
    
    -- Disparar evento de atualização
    dataUpdatedEvent:FireClient(player, key, value)
    
    print("📊 Dados atualizados para:", player.Name, key, "=", value)
    return true
end

-- Função para obter dados do jogador
function DataManager:GetPlayerData(player, key)
    if not playerDataCache[player] then
        print("⚠️ Jogador não encontrado no cache:", player.Name)
        return nil
    end
    
    local data = playerDataCache[player]
    if key then
        return data[key]
    else
        return data
    end
end

-- Função para adicionar sombra
function DataManager:AddShadow(player, shadowData)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    local shadowId = os.time() .. "_" .. math.random(1000, 9999)
    
    local shadow = {
        Id = shadowId,
        Name = shadowData.Name,
        Level = shadowData.Level or 1,
        Rank = shadowData.Rank or "F",
        Health = shadowData.Health or 100,
        MaxHealth = shadowData.MaxHealth or 100,
        Damage = shadowData.Damage or 50,
        Speed = shadowData.Speed or 10,
        Rarity = shadowData.Rarity or "Common",
        Abilities = shadowData.Abilities or {},
        Experience = 0,
        MaxExperience = 100,
        CapturedAt = os.time()
    }
    
    table.insert(data.Shadows, shadow)
    data.Statistics.ShadowsCaptured = data.Statistics.ShadowsCaptured + 1
    
    -- Disparar evento
    dataUpdatedEvent:FireClient(player, "Shadows", data.Shadows)
    
    print("👻 Sombra adicionada para:", player.Name, shadow.Name)
    return true
end

-- Função para equipar sombra
function DataManager:EquipShadow(player, shadowId)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    local shadow = nil
    
    -- Encontrar sombra
    for _, s in ipairs(data.Shadows) do
        if s.Id == shadowId then
            shadow = s
            break
        end
    end
    
    if not shadow then
        print("⚠️ Sombra não encontrada:", shadowId)
        return false
    end
    
    -- Verificar se já está equipada
    for _, equippedId in ipairs(data.EquippedShadows) do
        if equippedId == shadowId then
            print("⚠️ Sombra já equipada:", shadow.Name)
            return false
        end
    end
    
    -- Verificar limite de sombras equipadas
    if #data.EquippedShadows >= 3 then
        print("⚠️ Limite de sombras equipadas atingido")
        return false
    end
    
    -- Equipar sombra
    table.insert(data.EquippedShadows, shadowId)
    
    -- Disparar evento
    dataUpdatedEvent:FireClient(player, "EquippedShadows", data.EquippedShadows)
    
    print("⚔️ Sombra equipada:", shadow.Name, "para", player.Name)
    return true
end

-- Função para desequipar sombra
function DataManager:UnequipShadow(player, shadowId)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    
    -- Encontrar e remover sombra equipada
    for i, equippedId in ipairs(data.EquippedShadows) do
        if equippedId == shadowId then
            table.remove(data.EquippedShadows, i)
            
            -- Disparar evento
            dataUpdatedEvent:FireClient(player, "EquippedShadows", data.EquippedShadows)
            
            print("👻 Sombra desequipada:", shadowId, "para", player.Name)
            return true
        end
    end
    
    print("⚠️ Sombra não encontrada nas equipadas:", shadowId)
    return false
end

-- Função para adicionar XP
function DataManager:AddXP(player, amount)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    data.XP = data.XP + amount
    
    -- Verificar level up
    while data.XP >= data.MaxXP do
        data.XP = data.XP - data.MaxXP
        data.Level = data.Level + 1
        data.MaxXP = data.Level * 100
        
        -- Aumentar atributos
        data.MaxHealth = data.MaxHealth + 20
        data.MaxMana = data.MaxMana + 10
        data.Health = data.MaxHealth
        data.Mana = data.MaxMana
        
        -- Atualizar estatísticas
        if data.Level > data.Statistics.HighestLevel then
            data.Statistics.HighestLevel = data.Level
        end
        
        print("🎉 Level up! Nível", data.Level, "para", player.Name)
    end
    
    -- Disparar evento
    dataUpdatedEvent:FireClient(player, "XP", data.XP)
    dataUpdatedEvent:FireClient(player, "Level", data.Level)
    
    return true
end

-- Função para adicionar Cash
function DataManager:AddCash(player, amount)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    data.Cash = data.Cash + amount
    
    -- Disparar evento
    dataUpdatedEvent:FireClient(player, "Cash", data.Cash)
    
    print("💰 Cash adicionado:", amount, "para", player.Name)
    return true
end

-- Função para adicionar Diamantes
function DataManager:AddDiamonds(player, amount)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    data.Diamonds = data.Diamonds + amount
    
    -- Disparar evento
    dataUpdatedEvent:FireClient(player, "Diamonds", data.Diamonds)
    
    print("💎 Diamantes adicionados:", amount, "para", player.Name)
    return true
end

-- Função para atualizar estatísticas
function DataManager:UpdateStatistics(player, statName, value)
    if not playerDataCache[player] then return false end
    
    local data = playerDataCache[player]
    if data.Statistics[statName] then
        data.Statistics[statName] = data.Statistics[statName] + value
        print("📊 Estatística atualizada:", statName, "=", data.Statistics[statName])
        return true
    end
    
    return false
end

-- Sistema de salvamento automático
local function autoSave()
    while true do
        wait(SAVE_INTERVAL)
        
        for player, data in pairs(playerDataCache) do
            if player.Parent then -- Verificar se jogador ainda está no jogo
                DataManager:SavePlayerData(player, data)
            end
        end
    end
end

-- Sistema de backup
local function createBackup()
    while true do
        wait(3600) -- Backup a cada hora
        
        for player, data in pairs(playerDataCache) do
            if player.Parent then
                -- Criar backup com timestamp
                local backupData = {}
                for key, value in pairs(data) do
                    backupData[key] = value
                end
                backupData.BackupTime = os.time()
                
                -- Salvar backup
                local success = DataManager:SavePlayerData(player, backupData)
                if success then
                    print("💾 Backup criado para:", player.Name)
                end
            end
        end
    end
end

-- Conectar eventos do jogador
local function onPlayerAdded(player)
    print("👤 Jogador conectado:", player.Name)
    
    -- Carregar dados
    local data = DataManager:LoadPlayerData(player)
    playerDataCache[player] = data
    
    -- Disparar evento de dados carregados
    dataLoadedEvent:FireClient(player, data)
    
    print("✅ Dados carregados para:", player.Name)
end

local function onPlayerRemoving(player)
    print("👋 Jogador desconectado:", player.Name)
    
    -- Salvar dados antes de sair
    if playerDataCache[player] then
        DataManager:SavePlayerData(player, playerDataCache[player])
        playerDataCache[player] = nil
    end
    
    print("💾 Dados salvos para:", player.Name)
end

-- Conectar RemoteFunctions
getPlayerDataFunction.OnServerInvoke = function(player, key)
    return DataManager:GetPlayerData(player, key)
end

getShadowsFunction.OnServerInvoke = function(player)
    return DataManager:GetPlayerData(player, "Shadows")
end

getEquippedShadowsFunction.OnServerInvoke = function(player)
    return DataManager:GetPlayerData(player, "EquippedShadows")
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar sistemas
spawn(autoSave)
spawn(createBackup)

print("✅ DataManager carregado com sucesso!")