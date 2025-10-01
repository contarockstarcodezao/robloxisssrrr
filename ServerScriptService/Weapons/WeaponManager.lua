--[[
    WEAPON MANAGER
    Localização: ServerScriptService/Weapons/WeaponManager.lua
    
    Este script gerencia o sistema de armas e forja:
    - Equipamento de armas
    - Sistema de forja e melhorias
    - Fusão de armas
    - Integração com combate
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar dados e eventos
local WeaponData = require(ReplicatedStorage.Data.WeaponData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local WeaponManager = {}

-- Dados dos jogadores
local playerWeapons = {}

-- Inicializar dados do jogador
function WeaponManager.InitializePlayer(player)
    if not playerWeapons[player] then
        playerWeapons[player] = {
            equippedWeapon = nil,
            weapons = {},
            forgeLevel = 1,
            forgeExperience = 0
        }
    end
end

-- Equipar arma
function WeaponManager.EquipWeapon(player, weaponName)
    WeaponManager.InitializePlayer(player)
    
    local data = playerWeapons[player]
    local weaponData = WeaponData.WEAPONS[weaponName]
    
    if not weaponData then
        return false, "Arma não encontrada"
    end
    
    -- Verificar se o jogador possui a arma
    if not data.weapons[weaponName] or data.weapons[weaponName] <= 0 then
        return false, "Arma não encontrada no inventário"
    end
    
    -- Equipar arma
    data.equippedWeapon = weaponName
    
    -- Notificar cliente
    RemoteEvents.Weapon.WeaponEquipped:FireClient(player, weaponName)
    
    return true, "Arma equipada com sucesso!"
end

-- Desequipar arma
function WeaponManager.UnequipWeapon(player)
    WeaponManager.InitializePlayer(player)
    
    local data = playerWeapons[player]
    data.equippedWeapon = nil
    
    -- Notificar cliente
    RemoteEvents.Weapon.UnequipWeapon:FireClient(player)
    
    return true, "Arma desequipada"
end

-- Forjar arma
function WeaponManager.ForgeWeapon(player, weaponName, materials)
    WeaponManager.InitializePlayer(player)
    
    local data = playerWeapons[player]
    local weaponData = WeaponData.WEAPONS[weaponName]
    
    if not weaponData then
        return false, "Arma não encontrada"
    end
    
    -- Verificar materiais
    if not WeaponManager.HasMaterials(player, materials) then
        return false, "Materiais insuficientes"
    end
    
    -- Remover materiais
    WeaponManager.RemoveMaterials(player, materials)
    
    -- Adicionar arma ao inventário
    if data.weapons[weaponName] then
        data.weapons[weaponName] = data.weapons[weaponName] + 1
    else
        data.weapons[weaponName] = 1
    end
    
    -- Ganhar experiência de forja
    data.forgeExperience = data.forgeExperience + 100
    if data.forgeExperience >= WeaponManager.GetRequiredForgeXP(data.forgeLevel) then
        WeaponManager.LevelUpForge(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Weapon.WeaponForged:FireClient(player, weaponName)
    
    return true, "Arma forjada com sucesso!"
end

-- Fusão de armas
function WeaponManager.FuseWeapons(player, weapon1, weapon2, resultWeapon)
    WeaponManager.InitializePlayer(player)
    
    local data = playerWeapons[player]
    
    -- Verificar se possui as armas
    if not data.weapons[weapon1] or data.weapons[weapon1] <= 0 then
        return false, "Primeira arma não encontrada"
    end
    
    if not data.weapons[weapon2] or data.weapons[weapon2] <= 0 then
        return false, "Segunda arma não encontrada"
    end
    
    -- Verificar se o resultado é válido
    if not WeaponData.WEAPONS[resultWeapon] then
        return false, "Arma resultante inválida"
    end
    
    -- Remover armas originais
    data.weapons[weapon1] = data.weapons[weapon1] - 1
    data.weapons[weapon2] = data.weapons[weapon2] - 1
    
    -- Adicionar arma resultante
    if data.weapons[resultWeapon] then
        data.weapons[resultWeapon] = data.weapons[resultWeapon] + 1
    else
        data.weapons[resultWeapon] = 1
    end
    
    -- Ganhar experiência de forja
    data.forgeExperience = data.forgeExperience + 200
    if data.forgeExperience >= WeaponManager.GetRequiredForgeXP(data.forgeLevel) then
        WeaponManager.LevelUpForge(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Weapon.WeaponsFused:FireClient(player, weapon1, weapon2, resultWeapon)
    
    return true, "Armas fundidas com sucesso!"
end

-- Melhorar arma
function WeaponManager.UpgradeWeapon(player, weaponName, upgradeLevel)
    WeaponManager.InitializePlayer(player)
    
    local data = playerWeapons[player]
    local weaponData = WeaponData.WEAPONS[weaponName]
    
    if not weaponData then
        return false, "Arma não encontrada"
    end
    
    -- Verificar se possui a arma
    if not data.weapons[weaponName] or data.weapons[weaponName] <= 0 then
        return false, "Arma não encontrada no inventário"
    end
    
    -- Calcular custo da melhoria
    local upgradeCost = WeaponManager.CalculateUpgradeCost(weaponName, upgradeLevel)
    
    -- Verificar recursos
    if not WeaponManager.HasResources(player, upgradeCost) then
        return false, "Recursos insuficientes"
    end
    
    -- Remover recursos
    WeaponManager.RemoveResources(player, upgradeCost)
    
    -- Aplicar melhoria
    local upgradedWeapon = WeaponManager.ApplyUpgrade(weaponName, upgradeLevel)
    
    -- Adicionar arma melhorada
    if data.weapons[upgradedWeapon] then
        data.weapons[upgradedWeapon] = data.weapons[upgradedWeapon] + 1
    else
        data.weapons[upgradedWeapon] = 1
    end
    
    -- Remover arma original
    data.weapons[weaponName] = data.weapons[weaponName] - 1
    
    -- Ganhar experiência de forja
    data.forgeExperience = data.forgeExperience + 150
    if data.forgeExperience >= WeaponManager.GetRequiredForgeXP(data.forgeLevel) then
        WeaponManager.LevelUpForge(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Weapon.WeaponUpgraded:FireClient(player, weaponName, upgradedWeapon)
    
    return true, "Arma melhorada com sucesso!"
end

-- Verificar materiais
function WeaponManager.HasMaterials(player, materials)
    -- TODO: Implementar verificação de materiais
    -- Por enquanto, sempre retornar true
    return true
end

-- Remover materiais
function WeaponManager.RemoveMaterials(player, materials)
    -- TODO: Implementar remoção de materiais
    -- Por enquanto, não fazer nada
end

-- Verificar recursos
function WeaponManager.HasResources(player, cost)
    -- TODO: Implementar verificação de recursos
    -- Por enquanto, sempre retornar true
    return true
end

-- Remover recursos
function WeaponManager.RemoveResources(player, cost)
    -- TODO: Implementar remoção de recursos
    -- Por enquanto, não fazer nada
end

-- Calcular custo da melhoria
function WeaponManager.CalculateUpgradeCost(weaponName, upgradeLevel)
    local baseCost = WeaponData.FORGING.upgradeCost
    local multiplier = 1 + (upgradeLevel * 0.5)
    
    return {
        cash = baseCost.cash * multiplier,
        diamonds = baseCost.diamonds * multiplier,
        fragments = baseCost.fragments * multiplier
    }
end

-- Aplicar melhoria
function WeaponManager.ApplyUpgrade(weaponName, upgradeLevel)
    -- TODO: Implementar aplicação de melhoria
    -- Por enquanto, retornar o nome original
    return weaponName
end

-- Subir nível da forja
function WeaponManager.LevelUpForge(player)
    local data = playerWeapons[player]
    data.forgeLevel = data.forgeLevel + 1
    data.forgeExperience = 0
    
    -- Notificar cliente
    RemoteEvents.Weapon.ForgeLevelUp:FireClient(player, data.forgeLevel)
end

-- Obter XP necessário para a forja
function WeaponManager.GetRequiredForgeXP(level)
    return level * 1000
end

-- Obter dados do jogador
function WeaponManager.GetPlayerData(player)
    WeaponManager.InitializePlayer(player)
    return playerWeapons[player]
end

-- Obter arma equipada
function WeaponManager.GetEquippedWeapon(player)
    local data = playerWeapons[player]
    if data and data.equippedWeapon then
        return data.equippedWeapon
    end
    return nil
end

-- Obter estatísticas da arma
function WeaponManager.GetWeaponStats(player, weaponName)
    local weaponData = WeaponData.WEAPONS[weaponName]
    if not weaponData then
        return nil
    end
    
    local stats = {
        name = weaponName,
        type = weaponData.type,
        rarity = weaponData.rarity,
        baseDamage = weaponData.baseDamage,
        attackSpeed = weaponData.attackSpeed,
        range = weaponData.range,
        specialEffects = weaponData.specialEffects,
        description = weaponData.description
    }
    
    return stats
end

-- Obter lista de armas do jogador
function WeaponManager.GetPlayerWeapons(player)
    local data = playerWeapons[player]
    if not data then
        return {}
    end
    
    local weapons = {}
    for weaponName, quantity in pairs(data.weapons) do
        if quantity > 0 then
            table.insert(weapons, {
                name = weaponName,
                quantity = quantity,
                stats = WeaponManager.GetWeaponStats(player, weaponName)
            })
        end
    end
    
    return weapons
end

-- Conectar eventos
local function onPlayerAdded(player)
    WeaponManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerWeapons[player] = nil
end

-- Conectar eventos de armas
RemoteEvents.Weapon.EquipWeapon.OnServerEvent:Connect(function(player, weaponName)
    local success, message = WeaponManager.EquipWeapon(player, weaponName)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Weapon.UnequipWeapon.OnServerEvent:Connect(function(player)
    local success, message = WeaponManager.UnequipWeapon(player)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Weapon.ForgeWeapon.OnServerEvent:Connect(function(player, weaponName, materials)
    local success, message = WeaponManager.ForgeWeapon(player, weaponName, materials)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Weapon.FuseWeapons.OnServerEvent:Connect(function(player, weapon1, weapon2, resultWeapon)
    local success, message = WeaponManager.FuseWeapons(player, weapon1, weapon2, resultWeapon)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return WeaponManager