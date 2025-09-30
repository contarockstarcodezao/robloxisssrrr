--[[
    COMBAT MANAGER
    Localização: ServerScriptService/Combat/CombatManager.lua
    
    Este script gerencia o sistema de combate:
    - Ataques do jogador
    - Dano e status
    - Cooldowns e animações
    - Integração com sombras
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Importar dados e eventos
local WeaponData = require(ReplicatedStorage.Data.WeaponData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local CombatManager = {}

-- Dados dos jogadores
local playerData = {}

-- Inicializar dados do jogador
function CombatManager.InitializePlayer(player)
    if not playerData[player] then
        playerData[player] = {
            equippedWeapon = nil,
            lastAttackTime = 0,
            attackCooldown = 1.0,
            health = 100,
            maxHealth = 100,
            mana = 100,
            maxMana = 100,
            isAlive = true
        }
    end
end

-- Equipar arma
function CombatManager.EquipWeapon(player, weaponName)
    CombatManager.InitializePlayer(player)
    
    local data = playerData[player]
    local weapon = WeaponData.WEAPONS[weaponName]
    
    if not weapon then
        return false, "Arma não encontrada"
    end
    
    data.equippedWeapon = weapon
    data.attackCooldown = 1.0 / weapon.attackSpeed
    
    -- Notificar cliente
    RemoteEvents.Weapon.WeaponEquipped:FireClient(player, weapon)
    
    return true, "Arma equipada com sucesso!"
end

-- Atacar inimigo
function CombatManager.PlayerAttack(player, target, attackType)
    CombatManager.InitializePlayer(player)
    
    local data = playerData[player]
    
    if not data.isAlive then
        return false, "Jogador está morto"
    end
    
    if not data.equippedWeapon then
        return false, "Nenhuma arma equipada"
    end
    
    -- Verificar cooldown
    if tick() - data.lastAttackTime < data.attackCooldown then
        return false, "Ataque em cooldown"
    end
    
    -- Verificar se o alvo é válido
    if not target or not target:FindFirstChild("Humanoid") then
        return false, "Alvo inválido"
    end
    
    -- Calcular dano
    local damage = CombatManager.CalculateDamage(data.equippedWeapon, player, target)
    
    -- Aplicar dano
    local humanoid = target.Humanoid
    humanoid.Health = humanoid.Health - damage
    
    -- Efeitos especiais da arma
    CombatManager.ApplyWeaponEffects(data.equippedWeapon, target, player)
    
    -- Atualizar cooldown
    data.lastAttackTime = tick()
    
    -- Efeitos visuais
    CombatManager.CreateAttackEffect(target.HumanoidRootPart.Position, data.equippedWeapon.type)
    
    -- Notificar cliente
    RemoteEvents.Combat.DealDamage:FireClient(player, target, damage)
    
    return true, "Ataque realizado!"
end

-- Calcular dano
function CombatManager.CalculateDamage(weapon, attacker, target)
    local baseDamage = weapon.baseDamage
    
    -- Aplicar multiplicador de raridade
    local rarity = WeaponData.RARITIES[weapon.rarity]
    baseDamage = baseDamage * rarity.multiplier
    
    -- Calcular crítico
    local criticalChance = 0.1 -- 10% base
    local criticalMultiplier = 2.0
    
    -- Aplicar efeitos especiais de crítico
    for _, effect in ipairs(weapon.specialEffects) do
        if effect == "Critical Hit" then
            criticalChance = criticalChance + 0.25
        end
    end
    
    if math.random() < criticalChance then
        baseDamage = baseDamage * criticalMultiplier
        CombatManager.CreateCriticalEffect(target.HumanoidRootPart.Position)
    end
    
    return math.floor(baseDamage)
end

-- Aplicar efeitos especiais da arma
function CombatManager.ApplyWeaponEffects(weapon, target, attacker)
    for _, effectName in ipairs(weapon.specialEffects) do
        local effect = WeaponData.SPECIAL_EFFECTS[effectName]
        if effect then
            effect.effect(weapon, target)
        end
    end
end

-- Criar efeito de ataque
function CombatManager.CreateAttackEffect(position, weaponType)
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 3
    effect.BlastPressure = 0
    effect.Parent = workspace
    
    -- Efeitos específicos por tipo de arma
    if weaponType == WeaponData.TYPES.SWORD then
        -- Efeito de espada
        local particles = Instance.new("Fire")
        particles.Parent = workspace
        particles.Size = 1
        particles.Heat = 2
        particles.Position = position
        
        Debris:AddItem(particles, 0.5)
    elseif weaponType == WeaponData.TYPES.FIST then
        -- Efeito de soco
        local explosion = Instance.new("Explosion")
        explosion.Position = position
        explosion.BlastRadius = 5
        explosion.BlastPressure = 500
        explosion.Parent = workspace
    end
end

-- Criar efeito de crítico
function CombatManager.CreateCriticalEffect(position)
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 8
    effect.BlastPressure = 0
    effect.Parent = workspace
    
    -- Partículas de crítico
    local particles = Instance.new("Fire")
    particles.Parent = workspace
    particles.Size = 3
    particles.Heat = 5
    particles.Position = position
    
    Debris:AddItem(particles, 1)
end

-- Receber dano
function CombatManager.TakeDamage(player, damage, source)
    CombatManager.InitializePlayer(player)
    
    local data = playerData[player]
    
    if not data.isAlive then
        return false
    end
    
    data.health = data.health - damage
    
    -- Verificar se morreu
    if data.health <= 0 then
        data.health = 0
        data.isAlive = false
        CombatManager.HandlePlayerDeath(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Combat.TakeDamage:FireClient(player, damage, source)
    
    return true
end

-- Lidar com morte do jogador
function CombatManager.HandlePlayerDeath(player)
    local data = playerData[player]
    
    -- Dispensar sombra ativa
    -- TODO: Integrar com ShadowManager
    
    -- Respawn após 5 segundos
    wait(5)
    CombatManager.RespawnPlayer(player)
end

-- Respawn do jogador
function CombatManager.RespawnPlayer(player)
    local data = playerData[player]
    
    data.health = data.maxHealth
    data.mana = data.maxMana
    data.isAlive = true
    
    -- Respawn do personagem
    if player.Character then
        player.Character:BreakJoints()
    end
    
    -- Notificar cliente
    RemoteEvents.Combat.UpdateHealth:FireClient(player, data.health, data.maxHealth)
end

-- Obter dados do jogador
function CombatManager.GetPlayerData(player)
    CombatManager.InitializePlayer(player)
    return playerData[player]
end

-- Conectar eventos
local function onPlayerAdded(player)
    CombatManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerData[player] = nil
end

-- Conectar eventos de ataque
RemoteEvents.Combat.PlayerAttack.OnServerEvent:Connect(function(player, target, attackType)
    local success, message = CombatManager.PlayerAttack(player, target, attackType)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de equipamento
RemoteEvents.Weapon.EquipWeapon.OnServerEvent:Connect(function(player, weaponName)
    local success, message = CombatManager.EquipWeapon(player, weaponName)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return CombatManager