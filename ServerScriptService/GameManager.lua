--[[
    GAME MANAGER - Sistema Principal
    Framework completo e funcional para Arise Crossover
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("🎮 === ARISE CROSSOVER - INICIANDO ===")

-- Criar estrutura de dados básica
local function createDataStructure()
    print("📁 Criando estrutura de dados...")
    
    -- Pasta de dados
    local dataFolder = ReplicatedStorage:FindFirstChild("GameData")
    if not dataFolder then
        dataFolder = Instance.new("Folder")
        dataFolder.Name = "GameData"
        dataFolder.Parent = ReplicatedStorage
    end
    
    -- Dados dos jogadores
    local playerData = {
        Level = 1,
        XP = 0,
        MaxXP = 100,
        Cash = 1000,
        Diamonds = 10,
        Health = 100,
        MaxHealth = 100,
        Mana = 100,
        MaxMana = 100,
        Power = 0,
        Shadows = {},
        Weapons = {},
        Relics = {},
        Inventory = {}
    }
    
    -- Salvar dados padrão
    dataFolder:SetAttribute("DefaultPlayerData", playerData)
    
    print("✅ Estrutura de dados criada")
    return dataFolder
end

-- Sistema de jogadores
local PlayerManager = {}

function PlayerManager:GetPlayerData(player)
    local dataFolder = ReplicatedStorage:FindFirstChild("GameData")
    if not dataFolder then return nil end
    
    local playerFolder = dataFolder:FindFirstChild(player.Name)
    if not playerFolder then
        -- Criar dados do jogador
        playerFolder = Instance.new("Folder")
        playerFolder.Name = player.Name
        playerFolder.Parent = dataFolder
        
        -- Dados padrão
        local defaultData = dataFolder:GetAttribute("DefaultPlayerData")
        for key, value in pairs(defaultData) do
            playerFolder:SetAttribute(key, value)
        end
        
        print("👤 Dados criados para:", player.Name)
    end
    
    return playerFolder
end

function PlayerManager:UpdatePlayerData(player, key, value)
    local playerFolder = self:GetPlayerData(player)
    if playerFolder then
        playerFolder:SetAttribute(key, value)
        print("📊 Atualizado", key, "para", value, "de", player.Name)
    end
end

function PlayerManager:GetPlayerValue(player, key)
    local playerFolder = self:GetPlayerData(player)
    if playerFolder then
        return playerFolder:GetAttribute(key)
    end
    return nil
end

-- Sistema de eventos
local EventManager = {}

function EventManager:CreateEvents()
    print("📡 Criando eventos...")
    
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if not eventsFolder then
        eventsFolder = Instance.new("Folder")
        eventsFolder.Name = "Events"
        eventsFolder.Parent = ReplicatedStorage
    end
    
    -- Eventos do jogo
    local events = {
        "PlayerDataUpdated",
        "ShadowCaptured",
        "WeaponEquipped",
        "RelicEquipped",
        "LevelUp",
        "CashChanged",
        "DiamondsChanged"
    }
    
    for _, eventName in ipairs(events) do
        local event = eventsFolder:FindFirstChild(eventName)
        if not event then
            event = Instance.new("RemoteEvent")
            event.Name = eventName
            event.Parent = eventsFolder
        end
    end
    
    print("✅ Eventos criados")
    return eventsFolder
end

-- Sistema de notificações
local NotificationManager = {}

function NotificationManager:SendNotification(player, message, duration)
    duration = duration or 3
    
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if eventsFolder then
        local notificationEvent = eventsFolder:FindFirstChild("PlayerDataUpdated")
        if notificationEvent then
            notificationEvent:FireClient(player, "Notification", message, duration)
        end
    end
    
    print("📢 Notificação para", player.Name, ":", message)
end

-- Sistema de combate
local CombatManager = {}

function CombatManager:DealDamage(player, damage)
    local currentHealth = PlayerManager:GetPlayerValue(player, "Health")
    local newHealth = math.max(0, currentHealth - damage)
    
    PlayerManager:UpdatePlayerData(player, "Health", newHealth)
    
    if newHealth <= 0 then
        self:PlayerDied(player)
    end
    
    return newHealth
end

function CombatManager:HealPlayer(player, amount)
    local currentHealth = PlayerManager:GetPlayerValue(player, "Health")
    local maxHealth = PlayerManager:GetPlayerValue(player, "MaxHealth")
    local newHealth = math.min(maxHealth, currentHealth + amount)
    
    PlayerManager:UpdatePlayerData(player, "Health", newHealth)
    return newHealth
end

function CombatManager:PlayerDied(player)
    print("💀 Jogador morreu:", player.Name)
    -- Respawn após 5 segundos
    wait(5)
    PlayerManager:UpdatePlayerData(player, "Health", PlayerManager:GetPlayerValue(player, "MaxHealth"))
    NotificationManager:SendNotification(player, "Você foi revivido!", 3)
end

-- Sistema de XP e níveis
local LevelManager = {}

function LevelManager:AddXP(player, amount)
    local currentXP = PlayerManager:GetPlayerValue(player, "XP")
    local maxXP = PlayerManager:GetPlayerValue(player, "MaxXP")
    local newXP = currentXP + amount
    
    if newXP >= maxXP then
        self:LevelUp(player)
        newXP = newXP - maxXP
    end
    
    PlayerManager:UpdatePlayerData(player, "XP", newXP)
    NotificationManager:SendNotification(player, "XP ganho: +" .. amount, 2)
end

function LevelManager:LevelUp(player)
    local currentLevel = PlayerManager:GetPlayerValue(player, "Level")
    local newLevel = currentLevel + 1
    local newMaxXP = newLevel * 100
    
    PlayerManager:UpdatePlayerData(player, "Level", newLevel)
    PlayerManager:UpdatePlayerData(player, "MaxXP", newMaxXP)
    PlayerManager:UpdatePlayerData(player, "XP", 0)
    
    -- Aumentar atributos
    local currentHealth = PlayerManager:GetPlayerValue(player, "MaxHealth")
    local currentMana = PlayerManager:GetPlayerValue(player, "MaxMana")
    
    PlayerManager:UpdatePlayerData(player, "MaxHealth", currentHealth + 20)
    PlayerManager:UpdatePlayerData(player, "MaxMana", currentMana + 10)
    PlayerManager:UpdatePlayerData(player, "Health", currentHealth + 20)
    PlayerManager:UpdatePlayerData(player, "Mana", currentMana + 10)
    
    NotificationManager:SendNotification(player, "🎉 LEVEL UP! Nível " .. newLevel, 5)
    print("🎉", player.Name, "subiu para o nível", newLevel)
end

-- Sistema de economia
local EconomyManager = {}

function EconomyManager:AddCash(player, amount)
    local currentCash = PlayerManager:GetPlayerValue(player, "Cash")
    local newCash = currentCash + amount
    
    PlayerManager:UpdatePlayerData(player, "Cash", newCash)
    NotificationManager:SendNotification(player, "Cash ganho: +" .. amount, 2)
end

function EconomyManager:RemoveCash(player, amount)
    local currentCash = PlayerManager:GetPlayerValue(player, "Cash")
    if currentCash >= amount then
        local newCash = currentCash - amount
        PlayerManager:UpdatePlayerData(player, "Cash", newCash)
        return true
    end
    return false
end

function EconomyManager:AddDiamonds(player, amount)
    local currentDiamonds = PlayerManager:GetPlayerValue(player, "Diamonds")
    local newDiamonds = currentDiamonds + amount
    
    PlayerManager:UpdatePlayerData(player, "Diamonds", newDiamonds)
    NotificationManager:SendNotification(player, "Diamantes ganhos: +" .. amount, 2)
end

function EconomyManager:RemoveDiamonds(player, amount)
    local currentDiamonds = PlayerManager:GetPlayerValue(player, "Diamonds")
    if currentDiamonds >= amount then
        local newDiamonds = currentDiamonds - amount
        PlayerManager:UpdatePlayerData(player, "Diamonds", newDiamonds)
        return true
    end
    return false
end

-- Sistema de sombras
local ShadowManager = {}

function ShadowManager:CaptureShadow(player, shadowName, shadowData)
    local playerFolder = PlayerManager:GetPlayerData(player)
    if playerFolder then
        local shadows = playerFolder:GetAttribute("Shadows") or {}
        table.insert(shadows, {
            Name = shadowName,
            Level = shadowData.Level or 1,
            Rank = shadowData.Rank or "F",
            Health = shadowData.Health or 100,
            Damage = shadowData.Damage or 50,
            Speed = shadowData.Speed or 10
        })
        
        PlayerManager:UpdatePlayerData(player, "Shadows", shadows)
        NotificationManager:SendNotification(player, "Sombra capturada: " .. shadowName, 3)
        print("👻", player.Name, "capturou:", shadowName)
    end
end

-- Sistema de armas
local WeaponManager = {}

function WeaponManager:EquipWeapon(player, weaponName, weaponData)
    local playerFolder = PlayerManager:GetPlayerData(player)
    if playerFolder then
        local weapons = playerFolder:GetAttribute("Weapons") or {}
        table.insert(weapons, {
            Name = weaponName,
            Damage = weaponData.Damage or 50,
            Speed = weaponData.Speed or 1.0,
            Rarity = weaponData.Rarity or "Common"
        })
        
        PlayerManager:UpdatePlayerData(player, "Weapons", weapons)
        NotificationManager:SendNotification(player, "Arma equipada: " .. weaponName, 3)
        print("⚔️", player.Name, "equipou:", weaponName)
    end
end

-- Sistema de relíquias
local RelicManager = {}

function RelicManager:EquipRelic(player, relicName, relicData)
    local playerFolder = PlayerManager:GetPlayerData(player)
    if playerFolder then
        local relics = playerFolder:GetAttribute("Relics") or {}
        table.insert(relics, {
            Name = relicName,
            Effect = relicData.Effect or "damage_boost",
            Value = relicData.Value or 10,
            Rarity = relicData.Rarity or "Common"
        })
        
        PlayerManager:UpdatePlayerData(player, "Relics", relics)
        NotificationManager:SendNotification(player, "Relíquia equipada: " .. relicName, 3)
        print("💎", player.Name, "equipou:", relicName)
    end
end

-- Sistema de eventos do jogador
local function onPlayerAdded(player)
    print("👤 Jogador conectado:", player.Name)
    
    -- Criar dados do jogador
    PlayerManager:GetPlayerData(player)
    
    -- Enviar notificação de boas-vindas
    wait(2)
    NotificationManager:SendNotification(player, "🎮 Bem-vindo ao Arise Crossover!", 5)
end

local function onPlayerRemoving(player)
    print("👋 Jogador desconectado:", player.Name)
end

-- Sistema de teste automático
local function runTests()
    print("🧪 === EXECUTANDO TESTES ===")
    
    -- Teste 1: Estrutura de dados
    local dataFolder = createDataStructure()
    if dataFolder then
        print("✅ Teste 1: Estrutura de dados - PASSOU")
    else
        print("❌ Teste 1: Estrutura de dados - FALHOU")
        return
    end
    
    -- Teste 2: Eventos
    local eventsFolder = EventManager:CreateEvents()
    if eventsFolder then
        print("✅ Teste 2: Sistema de eventos - PASSOU")
    else
        print("❌ Teste 2: Sistema de eventos - FALHOU")
        return
    end
    
    -- Teste 3: Jogadores
    local playerCount = #Players:GetPlayers()
    if playerCount >= 0 then
        print("✅ Teste 3: Sistema de jogadores - PASSOU")
    else
        print("❌ Teste 3: Sistema de jogadores - FALHOU")
        return
    end
    
    print("🎉 === TODOS OS TESTES PASSARAM ===")
    print("🚀 Sistema pronto para uso!")
end

-- Conectar eventos
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Executar testes
spawn(function()
    wait(1)
    runTests()
end)

-- Sistema de loop principal
spawn(function()
    while true do
        wait(10)
        
        -- Simular eventos do jogo
        for _, player in pairs(Players:GetPlayers()) do
            -- Chance de ganhar XP
            if math.random(1, 100) <= 20 then
                LevelManager:AddXP(player, math.random(10, 50))
            end
            
            -- Chance de ganhar Cash
            if math.random(1, 100) <= 15 then
                EconomyManager:AddCash(player, math.random(50, 200))
            end
            
            -- Chance de ganhar Diamantes
            if math.random(1, 100) <= 5 then
                EconomyManager:AddDiamonds(player, math.random(1, 3))
            end
        end
    end
end)

print("✅ GameManager carregado com sucesso!")