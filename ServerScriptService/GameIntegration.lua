--[[
    GAME INTEGRATION - Integração dos Sistemas
    Conecta combate, dados e progressão
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

print("🔗 === GAME INTEGRATION INICIADO ===")

-- Aguardar sistemas
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local attackEvent = eventsFolder:WaitForChild("AttackNPC")
local npcDiedEvent = eventsFolder:WaitForChild("NPCDied")
local updateHUDEvent = eventsFolder:WaitForChild("UpdateHUD")

-- Sistema de integração
local GameIntegration = {}

-- Função para processar derrota de NPC
function GameIntegration:ProcessNPCDefeat(player, npcName, npcLevel, npcRank)
    print("🎯 Processando derrota de NPC:", npcName, "por", player.Name)
    
    -- Calcular recompensas baseadas no NPC
    local rewards = self:CalculateRewards(npcLevel, npcRank)
    
    -- Dar XP
    if rewards.XP > 0 then
        -- Aqui você conectaria com o DataManager
        print("⭐ XP ganho:", rewards.XP)
        -- DataManager:AddXP(player, rewards.XP)
    end
    
    -- Dar Cash
    if rewards.Cash > 0 then
        print("💰 Cash ganho:", rewards.Cash)
        -- DataManager:AddCash(player, rewards.Cash)
    end
    
    -- Dar Diamantes
    if rewards.Diamonds > 0 then
        print("💎 Diamantes ganhos:", rewards.Diamonds)
        -- DataManager:AddDiamonds(player, rewards.Diamonds)
    end
    
    -- Chance de capturar sombra
    if rewards.ShadowChance and math.random() < rewards.ShadowChance then
        self:ProcessShadowCapture(player, npcName, npcLevel, npcRank)
    end
    
    -- Atualizar estatísticas
    -- DataManager:UpdateStatistics(player, "NPCsDefeated", 1)
    
    print("✅ Recompensas processadas para:", player.Name)
end

-- Função para calcular recompensas
function GameIntegration:CalculateRewards(npcLevel, npcRank)
    local rewards = {
        XP = 0,
        Cash = 0,
        Diamonds = 0,
        ShadowChance = 0
    }
    
    -- Calcular XP baseado no nível
    rewards.XP = npcLevel * 10 + math.random(1, 20)
    
    -- Calcular Cash baseado no nível e rank
    local cashMultiplier = 1
    if npcRank == "E" then cashMultiplier = 1.5
    elseif npcRank == "D" then cashMultiplier = 2
    elseif npcRank == "C" then cashMultiplier = 3
    elseif npcRank == "B" then cashMultiplier = 4
    elseif npcRank == "A" then cashMultiplier = 5
    elseif npcRank == "S" then cashMultiplier = 6
    elseif npcRank == "SS" then cashMultiplier = 8
    elseif npcRank == "GM" then cashMultiplier = 10
    end
    
    rewards.Cash = math.floor(npcLevel * 5 * cashMultiplier + math.random(1, 50))
    
    -- Chance de diamantes baseada no rank
    if npcRank == "A" or npcRank == "S" or npcRank == "SS" or npcRank == "GM" then
        if math.random() < 0.1 then
            rewards.Diamonds = math.random(1, 3)
        end
    end
    
    -- Chance de capturar sombra baseada no rank
    if npcRank == "F" then rewards.ShadowChance = 0.1
    elseif npcRank == "E" then rewards.ShadowChance = 0.15
    elseif npcRank == "D" then rewards.ShadowChance = 0.2
    elseif npcRank == "C" then rewards.ShadowChance = 0.25
    elseif npcRank == "B" then rewards.ShadowChance = 0.3
    elseif npcRank == "A" then rewards.ShadowChance = 0.35
    elseif npcRank == "S" then rewards.ShadowChance = 0.4
    elseif npcRank == "SS" then rewards.ShadowChance = 0.45
    elseif npcRank == "GM" then rewards.ShadowChance = 0.5
    end
    
    return rewards
end

-- Função para processar captura de sombra
function GameIntegration:ProcessShadowCapture(player, npcName, npcLevel, npcRank)
    print("👻 Processando captura de sombra:", npcName)
    
    -- Dados da sombra
    local shadowData = {
        Name = npcName,
        Level = npcLevel,
        Rank = npcRank,
        Health = 100 + (npcLevel * 10),
        MaxHealth = 100 + (npcLevel * 10),
        Damage = 50 + (npcLevel * 5),
        Speed = 10 + (npcLevel * 2),
        Rarity = self:GetRarityFromRank(npcRank),
        Abilities = self:GenerateAbilities(npcRank),
        Experience = 0,
        MaxExperience = 100,
        CapturedAt = os.time()
    }
    
    -- Aqui você conectaria com o DataManager
    -- DataManager:AddShadow(player, shadowData)
    
    print("✅ Sombra capturada:", npcName, "para", player.Name)
end

-- Função para obter raridade baseada no rank
function GameIntegration:GetRarityFromRank(rank)
    if rank == "F" or rank == "E" then return "Common"
    elseif rank == "D" or rank == "C" then return "Rare"
    elseif rank == "B" or rank == "A" then return "Epic"
    elseif rank == "S" or rank == "SS" then return "Legendary"
    elseif rank == "GM" then return "Mythic"
    else return "Common"
    end
end

-- Função para gerar habilidades
function GameIntegration:GenerateAbilities(rank)
    local abilities = {}
    
    -- Habilidades baseadas no rank
    if rank == "F" or rank == "E" then
        abilities = {"Basic Attack", "Defend"}
    elseif rank == "D" or rank == "C" then
        abilities = {"Basic Attack", "Defend", "Quick Strike"}
    elseif rank == "B" or rank == "A" then
        abilities = {"Basic Attack", "Defend", "Quick Strike", "Power Strike"}
    elseif rank == "S" or rank == "SS" then
        abilities = {"Basic Attack", "Defend", "Quick Strike", "Power Strike", "Special Attack"}
    elseif rank == "GM" then
        abilities = {"Basic Attack", "Defend", "Quick Strike", "Power Strike", "Special Attack", "Ultimate Attack"}
    end
    
    return abilities
end

-- Função para processar sombras equipadas
function GameIntegration:ProcessEquippedShadows(player)
    -- Aqui você obteria as sombras equipadas do DataManager
    -- local equippedShadows = DataManager:GetPlayerData(player, "EquippedShadows")
    
    -- Simular sombras equipadas
    local equippedShadows = {"Shadow Wolf", "Shadow Bear", "Shadow Tiger"}
    
    print("👻 Sombras equipadas para", player.Name, ":", table.concat(equippedShadows, ", "))
    
    return equippedShadows
end

-- Função para calcular dano total
function GameIntegration:CalculateTotalDamage(player)
    -- Aqui você obteria os dados do jogador e sombras
    local baseDamage = 50
    local playerLevel = 1 -- DataManager:GetPlayerData(player, "Level")
    local equippedShadows = self:ProcessEquippedShadows(player)
    
    -- Calcular dano das sombras
    local shadowDamage = 0
    for _, shadowName in ipairs(equippedShadows) do
        shadowDamage = shadowDamage + 25 -- Dano base da sombra
    end
    
    -- Dano total
    local totalDamage = baseDamage + (playerLevel * 10) + shadowDamage
    
    print("⚔️ Dano total calculado para", player.Name, ":", totalDamage)
    
    return totalDamage
end

-- Função para processar level up
function GameIntegration:ProcessLevelUp(player, newLevel)
    print("🎉 Level up processado para", player.Name, "nível", newLevel)
    
    -- Recompensas por level up
    local rewards = {
        Cash = newLevel * 100,
        Diamonds = math.floor(newLevel / 5),
        Health = 20,
        Mana = 10
    }
    
    -- Aplicar recompensas
    -- DataManager:AddCash(player, rewards.Cash)
    -- DataManager:AddDiamonds(player, rewards.Diamonds)
    
    print("🎁 Recompensas de level up:", rewards.Cash, "Cash,", rewards.Diamonds, "Diamantes")
end

-- Função para processar progressão
function GameIntegration:ProcessProgression(player, xpGained)
    print("📈 Processando progressão para", player.Name, "XP ganho:", xpGained)
    
    -- Aqui você conectaria com o sistema de XP
    -- local currentXP = DataManager:GetPlayerData(player, "XP")
    -- local maxXP = DataManager:GetPlayerData(player, "MaxXP")
    -- local currentLevel = DataManager:GetPlayerData(player, "Level")
    
    -- Simular progressão
    local currentXP = 50
    local maxXP = 100
    local currentLevel = 1
    
    -- Verificar level up
    if currentXP + xpGained >= maxXP then
        local newLevel = currentLevel + 1
        self:ProcessLevelUp(player, newLevel)
    end
    
    print("✅ Progressão processada para", player.Name)
end

-- Sistema de loop principal
local function gameLoop()
    while true do
        wait(1)
        
        -- Processar sombras equipadas para todos os jogadores
        for _, player in pairs(Players:GetPlayers()) do
            if player.Parent then
                GameIntegration:ProcessEquippedShadows(player)
            end
        end
    end
end

-- Conectar eventos
npcDiedEvent.OnServerEvent:Connect(function(npcName, npcLevel, npcRank, player)
    GameIntegration:ProcessNPCDefeat(player, npcName, npcLevel, npcRank)
end)

-- Inicializar sistema
spawn(gameLoop)

print("✅ GameIntegration carregado com sucesso!")