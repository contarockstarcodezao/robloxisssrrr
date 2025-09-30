--[[
    LEVEL MANAGER
    Localização: ServerScriptService/LevelSystem/LevelManager.lua
    
    Este script gerencia o sistema de XP e níveis:
    - Ganho de XP
    - Progressão de níveis
    - Desbloqueio de habilidades
    - Aumento de atributos
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar eventos
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local LevelManager = {}

-- Configurações de XP
local XP_CONFIG = {
    baseXP = 100, -- XP base para o nível 1
    xpMultiplier = 1.2, -- Multiplicador por nível
    maxLevel = 100, -- Nível máximo
    xpPerKill = 50, -- XP por kill
    xpPerDungeon = 500, -- XP por dungeon
    xpPerRaid = 1000 -- XP por raid
}

-- Dados dos jogadores
local playerData = {}

-- Inicializar dados do jogador
function LevelManager.InitializePlayer(player)
    if not playerData[player] then
        playerData[player] = {
            level = 1,
            experience = 0,
            totalXP = 0,
            skillPoints = 0,
            attributes = {
                strength = 10,
                agility = 10,
                intelligence = 10,
                vitality = 10
            },
            unlockedAbilities = {},
            maxHealth = 100,
            maxMana = 100
        }
    end
end

-- Ganhar XP
function LevelManager.GainXP(player, amount, source)
    LevelManager.InitializePlayer(player)
    
    local data = playerData[player]
    data.experience = data.experience + amount
    data.totalXP = data.totalXP + amount
    
    -- Verificar se subiu de nível
    local requiredXP = LevelManager.GetRequiredXP(data.level)
    if data.experience >= requiredXP then
        LevelManager.LevelUp(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Level.UpdateXP:FireClient(player, data.experience, requiredXP)
    
    return true
end

-- Subir de nível
function LevelManager.LevelUp(player)
    local data = playerData[player]
    data.level = data.level + 1
    data.experience = data.experience - LevelManager.GetRequiredXP(data.level - 1)
    data.skillPoints = data.skillPoints + 1
    
    -- Aumentar atributos base
    LevelManager.IncreaseBaseAttributes(player)
    
    -- Desbloquear habilidades
    LevelManager.UnlockAbilities(player)
    
    -- Notificar cliente
    RemoteEvents.Level.LevelUp:FireClient(player, data.level)
    RemoteEvents.Level.UpdateLevel:FireClient(player, data.level)
    
    -- Verificar se pode subir mais níveis
    local requiredXP = LevelManager.GetRequiredXP(data.level)
    if data.experience >= requiredXP then
        LevelManager.LevelUp(player)
    end
end

-- Obter XP necessário para o nível
function LevelManager.GetRequiredXP(level)
    if level <= 1 then
        return XP_CONFIG.baseXP
    end
    
    return math.floor(XP_CONFIG.baseXP * (XP_CONFIG.xpMultiplier ^ (level - 1)))
end

-- Aumentar atributos base
function LevelManager.IncreaseBaseAttributes(player)
    local data = playerData[player]
    
    -- Aumentar atributos
    data.attributes.strength = data.attributes.strength + 2
    data.attributes.agility = data.attributes.agility + 2
    data.attributes.intelligence = data.attributes.intelligence + 2
    data.attributes.vitality = data.attributes.vitality + 2
    
    -- Aumentar vida e mana baseados em vitalidade
    data.maxHealth = 100 + (data.attributes.vitality * 5)
    data.maxMana = 100 + (data.attributes.intelligence * 3)
    
    -- Aplicar bônus de nível
    data.maxHealth = data.maxHealth + (data.level * 10)
    data.maxMana = data.maxMana + (data.level * 5)
end

-- Desbloquear habilidades
function LevelManager.UnlockAbilities(player)
    local data = playerData[player]
    local level = data.level
    
    -- Habilidades por nível
    if level >= 5 and not data.unlockedAbilities["Double Strike"] then
        data.unlockedAbilities["Double Strike"] = true
        LevelManager.UnlockAbility(player, "Double Strike")
    end
    
    if level >= 10 and not data.unlockedAbilities["Power Attack"] then
        data.unlockedAbilities["Power Attack"] = true
        LevelManager.UnlockAbility(player, "Power Attack")
    end
    
    if level >= 15 and not data.unlockedAbilities["Shadow Mastery"] then
        data.unlockedAbilities["Shadow Mastery"] = true
        LevelManager.UnlockAbility(player, "Shadow Mastery")
    end
    
    if level >= 20 and not data.unlockedAbilities["Berserker Rage"] then
        data.unlockedAbilities["Berserker Rage"] = true
        LevelManager.UnlockAbility(player, "Berserker Rage")
    end
    
    if level >= 25 and not data.unlockedAbilities["Shadow Fusion"] then
        data.unlockedAbilities["Shadow Fusion"] = true
        LevelManager.UnlockAbility(player, "Shadow Fusion")
    end
    
    if level >= 30 and not data.unlockedAbilities["Ultimate Strike"] then
        data.unlockedAbilities["Ultimate Strike"] = true
        LevelManager.UnlockAbility(player, "Ultimate Strike")
    end
end

-- Desbloquear habilidade específica
function LevelManager.UnlockAbility(player, abilityName)
    -- TODO: Implementar desbloqueio de habilidades
    -- Por enquanto, apenas notificar o cliente
    RemoteEvents.Level.AbilityUnlocked:FireClient(player, abilityName)
end

-- Usar ponto de habilidade
function LevelManager.UseSkillPoint(player, attribute)
    local data = playerData[player]
    
    if data.skillPoints <= 0 then
        return false, "Sem pontos de habilidade disponíveis"
    end
    
    if not data.attributes[attribute] then
        return false, "Atributo inválido"
    end
    
    data.attributes[attribute] = data.attributes[attribute] + 1
    data.skillPoints = data.skillPoints - 1
    
    -- Recalcular vida e mana se necessário
    if attribute == "vitality" then
        data.maxHealth = 100 + (data.attributes.vitality * 5) + (data.level * 10)
    elseif attribute == "intelligence" then
        data.maxMana = 100 + (data.attributes.intelligence * 3) + (data.level * 5)
    end
    
    -- Notificar cliente
    RemoteEvents.Level.AttributeUpdated:FireClient(player, attribute, data.attributes[attribute])
    
    return true, "Atributo aumentado com sucesso!"
end

-- Obter dados do jogador
function LevelManager.GetPlayerData(player)
    LevelManager.InitializePlayer(player)
    return playerData[player]
end

-- Obter ranking do jogador
function LevelManager.GetPlayerRank(player)
    local data = playerData[player]
    if not data then
        return 0
    end
    
    -- Calcular poder total baseado em nível e atributos
    local power = data.level * 100
    power = power + (data.attributes.strength * 10)
    power = power + (data.attributes.agility * 10)
    power = power + (data.attributes.intelligence * 10)
    power = power + (data.attributes.vitality * 10)
    
    return power
end

-- Obter leaderboard
function LevelManager.GetLeaderboard()
    local leaderboard = {}
    
    for player, data in pairs(playerData) do
        if player and player.Parent then
            local power = LevelManager.GetPlayerRank(player)
            table.insert(leaderboard, {
                player = player,
                level = data.level,
                power = power,
                totalXP = data.totalXP
            })
        end
    end
    
    -- Ordenar por poder
    table.sort(leaderboard, function(a, b)
        return a.power > b.power
    end)
    
    return leaderboard
end

-- Conectar eventos
local function onPlayerAdded(player)
    LevelManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerData[player] = nil
end

-- Conectar eventos de XP
RemoteEvents.Level.GainXP.OnServerEvent:Connect(function(player, amount, source)
    LevelManager.GainXP(player, amount, source)
end)

-- Conectar eventos de pontos de habilidade
RemoteEvents.Level.UseSkillPoint.OnServerEvent:Connect(function(player, attribute)
    local success, message = LevelManager.UseSkillPoint(player, attribute)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return LevelManager