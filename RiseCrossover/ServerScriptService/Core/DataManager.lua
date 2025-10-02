--[[
    DataManager.lua
    Sistema completo de gerenciamento de dados para Rise Crossover
    
    Funcionalidades:
    - Save/Load com DataStore
    - Auto-save periódico
    - Backup de dados
    - Cache em sessão
    - Tratamento robusto de erros
    - Sistema de retry
    - Migração de dados
    - Validação de dados
]]

local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local DataManager = {}

-- ========================================
-- CONFIGURAÇÕES
-- ========================================

local CONFIG = {
    DataStoreName = "PlayerData_V2", -- Versão do DataStore
    BackupStoreName = "PlayerBackup_V2",
    AutoSaveInterval = 180, -- Auto-save a cada 3 minutos (180 segundos)
    MaxRetries = 3, -- Tentativas de retry
    RetryDelay = 1, -- Delay entre retries (segundos)
    UseBackup = true, -- Usar sistema de backup
    DebugMode = false, -- Modo debug (prints extras)
}

-- ========================================
-- DATASTORES
-- ========================================

local PlayerDataStore
local BackupDataStore

-- Inicializa DataStores com proteção
local function InitializeDataStores()
    local success, err = pcall(function()
        PlayerDataStore = DataStoreService:GetDataStore(CONFIG.DataStoreName)
        if CONFIG.UseBackup then
            BackupDataStore = DataStoreService:GetDataStore(CONFIG.BackupStoreName)
        end
    end)
    
    if not success then
        warn("[DataManager] Erro ao inicializar DataStores:", err)
        warn("[DataManager] O jogo funcionará sem persistência de dados!")
    end
    
    return success
end

-- ========================================
-- DADOS PADRÃO
-- ========================================

local function GetDefaultData()
    return {
        -- Informações básicas
        Version = 2, -- Versão dos dados (para migração)
        CreatedAt = os.time(),
        LastLogin = os.time(),
        PlayTime = 0,
        
        -- Progressão
        XP = 0,
        Level = 1,
        Rank = "F", -- F, E, D, C, B, A, S, SS, SSS, GM
        StatusPoints = 0,
        
        -- Stats do jogador
        Stats = {
            -- Stats de jogador
            PlayerSpeed = 0,
            PlayerDamage = 0,
            PlayerHealth = 0,
            PlayerDefense = 0,
            
            -- Stats de sombra
            ShadowSpeed = 0,
            ShadowDamage = 0,
            ShadowRange = 0,
            ShadowCapacity = 3, -- Máximo de sombras equipadas
        },
        
        -- Inventários
        Shadows = {}, -- {ID, Name, Rank, Level, Stats, EquipSlot}
        Weapons = {}, -- {ID, Name, Type, Damage, Special}
        Relics = {}, -- {ID, Name, Rarity, Effect}
        Items = {}, -- Itens consumíveis
        
        -- Economia
        Currency = {
            Gold = 100, -- Moeda principal
            Gems = 10, -- Moeda premium
            Crystals = 0, -- Moeda especial
        },
        
        -- Equipamento
        Equipped = {
            Weapon = nil, -- ID da arma equipada
            Shadows = {}, -- IDs das sombras equipadas (max 3)
            Relics = {}, -- IDs das relíquias equipadas
        },
        
        -- Social
        Guild = nil, -- ID da guilda
        Friends = {},
        PartyID = nil,
        
        -- Missões e conquistas
        Missions = {
            Active = {}, -- Missões ativas
            Completed = {}, -- IDs de missões completadas
            Daily = {}, -- Missões diárias
        },
        Achievements = {}, -- IDs de conquistas desbloqueadas
        Titles = {}, -- Títulos desbloqueados
        EquippedTitle = nil,
        
        -- Estatísticas
        Statistics = {
            NPCsKilled = 0,
            BossesDefeated = 0,
            ShadowsCaptured = 0,
            DungeonsCompleted = 0,
            PvPWins = 0,
            PvPLosses = 0,
            DamageDealt = 0,
            DamageTaken = 0,
            Deaths = 0,
        },
        
        -- Configurações
        Settings = {
            MusicVolume = 0.5,
            SFXVolume = 0.7,
            ShowDamageNumbers = true,
            AutoEquipShadows = false,
            ChatEnabled = true,
        },
        
        -- Outros
        Banned = false,
        BanReason = nil,
        DailyRewardClaimed = 0, -- Timestamp do último claim
        LoginStreak = 0,
    }
end

-- ========================================
-- VALIDAÇÃO DE DADOS
-- ========================================

-- Valida e sanitiza dados carregados
local function ValidateData(data)
    if not data or type(data) ~= "table" then
        return false, "Dados inválidos ou corrompidos"
    end
    
    -- Verifica campos essenciais
    local requiredFields = {"Version", "Level", "XP", "Stats", "Shadows", "Currency"}
    for _, field in ipairs(requiredFields) do
        if data[field] == nil then
            return false, "Campo obrigatório ausente: " .. field
        end
    end
    
    -- Valida tipos
    if type(data.Level) ~= "number" or data.Level < 1 then
        data.Level = 1
    end
    
    if type(data.XP) ~= "number" or data.XP < 0 then
        data.XP = 0
    end
    
    if type(data.Stats) ~= "table" then
        data.Stats = GetDefaultData().Stats
    end
    
    if type(data.Currency) ~= "table" then
        data.Currency = GetDefaultData().Currency
    end
    
    return true, "Dados válidos"
end

-- Mescla dados padrão com dados carregados (para adicionar novos campos)
local function MergeWithDefaults(data)
    local defaultData = GetDefaultData()
    
    local function deepMerge(default, loaded)
        local result = {}
        
        -- Copia valores do default
        for key, defaultValue in pairs(default) do
            if loaded[key] ~= nil then
                if type(defaultValue) == "table" and type(loaded[key]) == "table" then
                    result[key] = deepMerge(defaultValue, loaded[key])
                else
                    result[key] = loaded[key]
                end
            else
                result[key] = defaultValue
            end
        end
        
        -- Adiciona valores extras do loaded que não estão no default
        for key, value in pairs(loaded) do
            if result[key] == nil then
                result[key] = value
            end
        end
        
        return result
    end
    
    return deepMerge(defaultData, data)
end

-- ========================================
-- MIGRAÇÃO DE DADOS
-- ========================================

-- Migra dados de versões antigas
local function MigrateData(data)
    local currentVersion = 2
    local dataVersion = data.Version or 1
    
    if dataVersion < currentVersion then
        if CONFIG.DebugMode then
            print("[DataManager] Migrando dados da versão", dataVersion, "para", currentVersion)
        end
        
        -- Migração v1 -> v2
        if dataVersion < 2 then
            -- Converte Currency de number para table
            if type(data.Currency) == "number" then
                local oldCurrency = data.Currency
                data.Currency = {
                    Gold = oldCurrency,
                    Gems = 0,
                    Crystals = 0,
                }
            end
            
            -- Adiciona novos campos de Stats
            if data.Stats then
                data.Stats.PlayerHealth = data.Stats.PlayerHealth or 0
                data.Stats.PlayerDefense = data.Stats.PlayerDefense or 0
                data.Stats.ShadowCapacity = data.Stats.ShadowCapacity or 3
            end
            
            -- Adiciona Equipped se não existir
            if not data.Equipped then
                data.Equipped = GetDefaultData().Equipped
            end
        end
        
        data.Version = currentVersion
    end
    
    return data
end

-- ========================================
-- LOAD/SAVE COM RETRY
-- ========================================

-- Carrega dados com retry
local function LoadDataWithRetry(userId)
    for attempt = 1, CONFIG.MaxRetries do
        local success, result = pcall(function()
            return PlayerDataStore:GetAsync(userId)
        end)
        
        if success then
            return true, result
        else
            warn(string.format("[DataManager] Tentativa %d/%d falhou ao carregar dados: %s", 
                attempt, CONFIG.MaxRetries, tostring(result)))
            
            if attempt < CONFIG.MaxRetries then
                wait(CONFIG.RetryDelay * attempt) -- Backoff exponencial
            end
        end
    end
    
    return false, nil
end

-- Salva dados com retry
local function SaveDataWithRetry(userId, data)
    for attempt = 1, CONFIG.MaxRetries do
        local success, err = pcall(function()
            PlayerDataStore:SetAsync(userId, data)
        end)
        
        if success then
            return true
        else
            warn(string.format("[DataManager] Tentativa %d/%d falhou ao salvar dados: %s", 
                attempt, CONFIG.MaxRetries, tostring(err)))
            
            if attempt < CONFIG.MaxRetries then
                wait(CONFIG.RetryDelay * attempt)
            end
        end
    end
    
    return false
end

-- ========================================
-- BACKUP SYSTEM
-- ========================================

-- Cria backup dos dados
local function CreateBackup(userId, data)
    if not CONFIG.UseBackup or not BackupDataStore then
        return false
    end
    
    local success, err = pcall(function()
        local backupData = {
            Timestamp = os.time(),
            Data = data,
        }
        BackupDataStore:SetAsync(userId, backupData)
    end)
    
    if not success then
        warn("[DataManager] Erro ao criar backup:", err)
    end
    
    return success
end

-- Restaura dados do backup
local function RestoreFromBackup(userId)
    if not CONFIG.UseBackup or not BackupDataStore then
        return nil
    end
    
    local success, backupData = pcall(function()
        return BackupDataStore:GetAsync(userId)
    end)
    
    if success and backupData and backupData.Data then
        print("[DataManager] Dados restaurados do backup para UserId:", userId)
        return backupData.Data
    end
    
    return nil
end

-- ========================================
-- SESSION DATA
-- ========================================

DataManager.SessionData = {} -- {UserId -> PlayerData}
DataManager.DataLoaded = {} -- {UserId -> boolean}

-- ========================================
-- FUNÇÕES PRINCIPAIS
-- ========================================

-- Carrega dados do jogador
function DataManager:LoadPlayerData(player)
    local userId = player.UserId
    
    if CONFIG.DebugMode then
        print("[DataManager] Carregando dados para:", player.Name)
    end
    
    -- Tenta carregar do DataStore
    local success, loadedData = LoadDataWithRetry(userId)
    local data
    
    if success and loadedData then
        -- Valida dados
        local valid, message = ValidateData(loadedData)
        
        if valid then
            -- Migra dados se necessário
            data = MigrateData(loadedData)
            -- Mescla com defaults (adiciona novos campos)
            data = MergeWithDefaults(data)
            
            if CONFIG.DebugMode then
                print("[DataManager] Dados carregados com sucesso para:", player.Name)
            end
        else
            warn("[DataManager] Dados inválidos:", message)
            -- Tenta restaurar do backup
            data = RestoreFromBackup(userId)
            
            if not data then
                warn("[DataManager] Usando dados padrão para:", player.Name)
                data = GetDefaultData()
            end
        end
    else
        -- Primeira vez ou erro crítico
        data = GetDefaultData()
        print("[DataManager] Novos dados criados para:", player.Name)
    end
    
    -- Atualiza informações de sessão
    data.LastLogin = os.time()
    
    -- Verifica daily reward
    local lastClaim = data.DailyRewardClaimed or 0
    local timeSinceLastClaim = os.time() - lastClaim
    
    if timeSinceLastClaim >= 86400 then -- 24 horas
        if timeSinceLastClaim < 172800 then -- Menos de 48 horas (mantém streak)
            data.LoginStreak = (data.LoginStreak or 0) + 1
        else
            data.LoginStreak = 1 -- Reset streak
        end
    end
    
    -- Armazena em sessão
    self.SessionData[userId] = data
    self.DataLoaded[userId] = true
    
    -- Cria leaderstats
    self:CreateLeaderstats(player, data)
    
    return data
end

-- Salva dados do jogador
function DataManager:SavePlayerData(player)
    local userId = player.UserId
    local data = self.SessionData[userId]
    
    if not data then
        warn("[DataManager] Nenhum dado em sessão para salvar:", player.Name)
        return false
    end
    
    if CONFIG.DebugMode then
        print("[DataManager] Salvando dados para:", player.Name)
    end
    
    -- Atualiza tempo de jogo
    local sessionTime = os.time() - (data.LastLogin or os.time())
    data.PlayTime = (data.PlayTime or 0) + sessionTime
    
    -- Salva no DataStore
    local success = SaveDataWithRetry(userId, data)
    
    if success then
        -- Cria backup
        CreateBackup(userId, data)
        
        if CONFIG.DebugMode then
            print("[DataManager] Dados salvos com sucesso para:", player.Name)
        end
    else
        warn("[DataManager] FALHA CRÍTICA ao salvar dados de:", player.Name)
    end
    
    return success
end

-- Cria leaderstats
function DataManager:CreateLeaderstats(player, data)
    -- Remove leaderstats antigos
    local oldLeaderstats = player:FindFirstChild("leaderstats")
    if oldLeaderstats then
        oldLeaderstats:Destroy()
    end
    
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    -- Level
    local levelValue = Instance.new("IntValue")
    levelValue.Name = "Level"
    levelValue.Value = data.Level
    levelValue.Parent = leaderstats
    
    -- Rank
    local rankValue = Instance.new("StringValue")
    rankValue.Name = "Rank"
    rankValue.Value = data.Rank or "F"
    rankValue.Parent = leaderstats
    
    -- Gold
    local goldValue = Instance.new("IntValue")
    goldValue.Name = "Gold"
    goldValue.Value = data.Currency.Gold or 0
    goldValue.Parent = leaderstats
end

-- Atualiza leaderstats
function DataManager:UpdateLeaderstats(player)
    local data = self:GetPlayerData(player)
    if not data then return end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then return end
    
    local levelValue = leaderstats:FindFirstChild("Level")
    if levelValue then
        levelValue.Value = data.Level
    end
    
    local rankValue = leaderstats:FindFirstChild("Rank")
    if rankValue then
        rankValue.Value = data.Rank or "F"
    end
    
    local goldValue = leaderstats:FindFirstChild("Gold")
    if goldValue then
        goldValue.Value = data.Currency.Gold or 0
    end
end

-- ========================================
-- GETTERS E SETTERS
-- ========================================

-- Obtém dados do jogador
function DataManager:GetPlayerData(player)
    return self.SessionData[player.UserId]
end

-- Verifica se dados foram carregados
function DataManager:IsDataLoaded(player)
    return self.DataLoaded[player.UserId] == true
end

-- ========================================
-- FUNÇÕES DE MODIFICAÇÃO
-- ========================================

-- Adiciona XP
function DataManager:AddXP(player, amount)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    data.XP = data.XP + amount
    
    -- Verifica level up
    local requiredXP = self:GetRequiredXP(data.Level)
    while data.XP >= requiredXP do
        data.XP = data.XP - requiredXP
        data.Level = data.Level + 1
        data.StatusPoints = data.StatusPoints + 5 -- 5 pontos por level
        
        requiredXP = self:GetRequiredXP(data.Level)
        
        -- Notifica level up (você pode criar um evento remoto aqui)
        print(player.Name, "subiu para o nível", data.Level)
    end
    
    self:UpdateLeaderstats(player)
    return true
end

-- Calcula XP necessário
function DataManager:GetRequiredXP(level)
    return math.floor(100 * (level ^ 1.5))
end

-- Atualiza stat
function DataManager:UpdateStat(player, statName, value)
    local data = self:GetPlayerData(player)
    if not data or not data.Stats then return false end
    
    if data.Stats[statName] ~= nil then
        data.Stats[statName] = value
        return true
    end
    
    return false
end

-- Incrementa stat
function DataManager:IncrementStat(player, statName, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Stats then return false end
    
    if data.Stats[statName] ~= nil then
        data.Stats[statName] = data.Stats[statName] + amount
        return true
    end
    
    return false
end

-- Adiciona moeda
function DataManager:AddCurrency(player, currencyType, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Currency then return false end
    
    if data.Currency[currencyType] ~= nil then
        data.Currency[currencyType] = data.Currency[currencyType] + amount
        self:UpdateLeaderstats(player)
        return true
    end
    
    return false
end

-- Remove moeda
function DataManager:RemoveCurrency(player, currencyType, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Currency then return false end
    
    if data.Currency[currencyType] ~= nil then
        if data.Currency[currencyType] >= amount then
            data.Currency[currencyType] = data.Currency[currencyType] - amount
            self:UpdateLeaderstats(player)
            return true
        end
    end
    
    return false
end

-- Adiciona sombra
function DataManager:AddShadow(player, shadowData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    -- Adiciona ID único
    shadowData.ID = HttpService:GenerateGUID(false)
    shadowData.AcquiredAt = os.time()
    
    table.insert(data.Shadows, shadowData)
    
    -- Atualiza estatística
    data.Statistics.ShadowsCaptured = data.Statistics.ShadowsCaptured + 1
    
    return true, shadowData.ID
end

-- Remove sombra
function DataManager:RemoveShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    for i, shadow in ipairs(data.Shadows) do
        if shadow.ID == shadowID then
            table.remove(data.Shadows, i)
            
            -- Remove do equipamento se estiver equipada
            for j, equippedID in ipairs(data.Equipped.Shadows) do
                if equippedID == shadowID then
                    table.remove(data.Equipped.Shadows, j)
                    break
                end
            end
            
            return true
        end
    end
    
    return false
end

-- Equipa sombra
function DataManager:EquipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false, "Dados não encontrados" end
    
    -- Verifica se a sombra existe
    local shadowExists = false
    for _, shadow in ipairs(data.Shadows) do
        if shadow.ID == shadowID then
            shadowExists = true
            break
        end
    end
    
    if not shadowExists then
        return false, "Sombra não encontrada"
    end
    
    -- Verifica se já está equipada
    for _, equippedID in ipairs(data.Equipped.Shadows) do
        if equippedID == shadowID then
            return false, "Sombra já equipada"
        end
    end
    
    -- Verifica limite
    local maxCapacity = data.Stats.ShadowCapacity or 3
    if #data.Equipped.Shadows >= maxCapacity then
        return false, "Limite de sombras equipadas atingido"
    end
    
    table.insert(data.Equipped.Shadows, shadowID)
    return true
end

-- Desequipa sombra
function DataManager:UnequipShadow(player, shadowID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    for i, equippedID in ipairs(data.Equipped.Shadows) do
        if equippedID == shadowID then
            table.remove(data.Equipped.Shadows, i)
            return true
        end
    end
    
    return false
end

-- Adiciona arma
function DataManager:AddWeapon(player, weaponData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    weaponData.ID = HttpService:GenerateGUID(false)
    weaponData.AcquiredAt = os.time()
    
    table.insert(data.Weapons, weaponData)
    return true, weaponData.ID
end

-- Equipa arma
function DataManager:EquipWeapon(player, weaponID)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    -- Verifica se a arma existe
    local weaponExists = false
    for _, weapon in ipairs(data.Weapons) do
        if weapon.ID == weaponID then
            weaponExists = true
            break
        end
    end
    
    if not weaponExists then
        return false, "Arma não encontrada"
    end
    
    data.Equipped.Weapon = weaponID
    return true
end

-- Adiciona relíquia
function DataManager:AddRelic(player, relicData)
    local data = self:GetPlayerData(player)
    if not data then return false end
    
    relicData.ID = HttpService:GenerateGUID(false)
    relicData.AcquiredAt = os.time()
    
    table.insert(data.Relics, relicData)
    return true, relicData.ID
end

-- Atualiza estatística
function DataManager:IncrementStatistic(player, statName, amount)
    local data = self:GetPlayerData(player)
    if not data or not data.Statistics then return false end
    
    if data.Statistics[statName] ~= nil then
        data.Statistics[statName] = data.Statistics[statName] + (amount or 1)
        return true
    end
    
    return false
end

-- ========================================
-- AUTO-SAVE SYSTEM
-- ========================================

function DataManager:StartAutoSave()
    spawn(function()
        while true do
            wait(CONFIG.AutoSaveInterval)
            
            local count = 0
            for _, player in ipairs(Players:GetPlayers()) do
                if self:IsDataLoaded(player) then
                    self:SavePlayerData(player)
                    count = count + 1
                end
            end
            
            if count > 0 and CONFIG.DebugMode then
                print(string.format("[DataManager] Auto-save: %d jogadores salvos", count))
            end
        end
    end)
end

-- ========================================
-- INICIALIZAÇÃO E EVENTOS
-- ========================================

function DataManager:Init()
    print("[DataManager] Inicializando...")
    
    -- Inicializa DataStores
    local success = InitializeDataStores()
    if not success then
        warn("[DataManager] ATENÇÃO: Sistema funcionará sem persistência!")
    end
    
    -- Player Added
    Players.PlayerAdded:Connect(function(player)
        self:LoadPlayerData(player)
    end)
    
    -- Player Removing
    Players.PlayerRemoving:Connect(function(player)
        if self:IsDataLoaded(player) then
            self:SavePlayerData(player)
        end
        
        -- Limpa sessão
        self.SessionData[player.UserId] = nil
        self.DataLoaded[player.UserId] = nil
    end)
    
    -- Bind to Close (salva todos antes de fechar)
    game:BindToClose(function()
        print("[DataManager] Salvando todos os jogadores antes de fechar...")
        
        for _, player in ipairs(Players:GetPlayers()) do
            if self:IsDataLoaded(player) then
                self:SavePlayerData(player)
            end
        end
        
        wait(3) -- Aguarda saves completarem
        print("[DataManager] Todos os dados salvos!")
    end)
    
    -- Inicia auto-save
    self:StartAutoSave()
    
    print("[DataManager] ✅ Inicializado com sucesso!")
end

return DataManager
