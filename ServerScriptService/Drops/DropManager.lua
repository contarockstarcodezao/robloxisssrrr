--[[
    DROP MANAGER
    Localização: ServerScriptService/Drops/DropManager.lua
    
    Este script gerencia o sistema de drops:
    - Geração de drops ao matar NPCs
    - Coleta automática e manual
    - Sistema de raridade visual
    - Integração com inventário
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local TweenService = game:GetService("TweenService")

-- Importar dados e eventos
local ShadowData = require(ReplicatedStorage.Data.ShadowData)
local WeaponData = require(ReplicatedStorage.Data.WeaponData)
local RelicData = require(ReplicatedStorage.Data.RelicData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local DropManager = {}

-- Tipos de drops
local DROP_TYPES = {
    CASH = "Cash",
    DIAMONDS = "Diamonds",
    FRAGMENTS = "Fragments",
    SHADOW = "Shadow",
    WEAPON = "Weapon",
    RELIC = "Relic",
    POTION = "Potion"
}

-- Raridades dos drops
local DROP_RARITIES = {
    COMMON = {name = "Common", color = Color3.fromRGB(128, 128, 128), chance = 0.6},
    RARE = {name = "Rare", color = Color3.fromRGB(0, 255, 0), chance = 0.25},
    EPIC = {name = "Epic", color = Color3.fromRGB(128, 0, 255), chance = 0.12},
    LEGENDARY = {name = "Legendary", color = Color3.fromRGB(255, 215, 0), chance = 0.03}
}

-- Dados dos drops
local DROP_DATA = {
    [DROP_TYPES.CASH] = {
        amounts = {10, 25, 50, 100, 250, 500, 1000},
        weights = {0.3, 0.25, 0.2, 0.15, 0.08, 0.015, 0.005}
    },
    [DROP_TYPES.DIAMONDS] = {
        amounts = {1, 2, 5, 10, 25, 50},
        weights = {0.4, 0.3, 0.2, 0.08, 0.015, 0.005}
    },
    [DROP_TYPES.FRAGMENTS] = {
        amounts = {5, 10, 25, 50, 100, 250},
        weights = {0.35, 0.3, 0.2, 0.1, 0.04, 0.01}
    },
    [DROP_TYPES.SHADOW] = {
        shadows = {"Shadow Wolf", "Shadow Bear", "Shadow Tiger", "Shadow Dragon", "Shadow Phoenix"},
        weights = {0.4, 0.3, 0.2, 0.08, 0.02}
    },
    [DROP_TYPES.WEAPON] = {
        weapons = {"Iron Sword", "Steel Sword", "Dragon Blade", "Excalibur", "Iron Fist", "Steel Gauntlets", "Thunder Fists", "God's Fist"},
        weights = {0.3, 0.25, 0.2, 0.1, 0.08, 0.05, 0.015, 0.005}
    },
    [DROP_TYPES.RELIC] = {
        relics = {"Power Stone", "Warrior's Gem", "Dragon's Heart", "God's Wrath", "Wind Crystal", "Lightning Core", "Storm Essence", "Time Shard"},
        weights = {0.25, 0.2, 0.15, 0.1, 0.15, 0.1, 0.04, 0.01}
    },
    [DROP_TYPES.POTION] = {
        potions = {"Health Potion", "Mana Potion", "Speed Potion", "Strength Potion"},
        weights = {0.4, 0.3, 0.2, 0.1}
    }
}

-- Gerar drop
function DropManager.GenerateDrop(enemy, killer)
    local dropType = DropManager.SelectDropType()
    local rarity = DropManager.SelectRarity()
    local dropData = DropManager.CreateDropData(dropType, rarity)
    
    if dropData then
        DropManager.CreateDropModel(enemy.HumanoidRootPart.Position, dropData)
        return dropData
    end
    
    return nil
end

-- Selecionar tipo de drop
function DropManager.SelectDropType()
    local random = math.random()
    
    if random < 0.4 then
        return DROP_TYPES.CASH
    elseif random < 0.6 then
        return DROP_TYPES.FRAGMENTS
    elseif random < 0.75 then
        return DROP_TYPES.SHADOW
    elseif random < 0.85 then
        return DROP_TYPES.WEAPON
    elseif random < 0.95 then
        return DROP_TYPES.RELIC
    else
        return DROP_TYPES.DIAMONDS
    end
end

-- Selecionar raridade
function DropManager.SelectRarity()
    local random = math.random()
    
    if random < DROP_RARITIES.COMMON.chance then
        return "COMMON"
    elseif random < DROP_RARITIES.COMMON.chance + DROP_RARITIES.RARE.chance then
        return "RARE"
    elseif random < DROP_RARITIES.COMMON.chance + DROP_RARITIES.RARE.chance + DROP_RARITIES.EPIC.chance then
        return "EPIC"
    else
        return "LEGENDARY"
    end
end

-- Criar dados do drop
function DropManager.CreateDropData(dropType, rarity)
    local data = DROP_DATA[dropType]
    if not data then
        return nil
    end
    
    local dropData = {
        type = dropType,
        rarity = rarity,
        amount = 1,
        value = 0,
        item = nil,
        id = tick() -- ID único
    }
    
    if dropType == DROP_TYPES.CASH then
        dropData.amount = DropManager.SelectWeightedValue(data.amounts, data.weights)
        dropData.value = dropData.amount
    elseif dropType == DROP_TYPES.DIAMONDS then
        dropData.amount = DropManager.SelectWeightedValue(data.amounts, data.weights)
        dropData.value = dropData.amount
    elseif dropType == DROP_TYPES.FRAGMENTS then
        dropData.amount = DropManager.SelectWeightedValue(data.amounts, data.weights)
        dropData.value = dropData.amount
    elseif dropType == DROP_TYPES.SHADOW then
        dropData.item = DropManager.SelectWeightedValue(data.shadows, data.weights)
    elseif dropType == DROP_TYPES.WEAPON then
        dropData.item = DropManager.SelectWeightedValue(data.weapons, data.weights)
    elseif dropType == DROP_TYPES.RELIC then
        dropData.item = DropManager.SelectWeightedValue(data.relics, data.weights)
    elseif dropType == DROP_TYPES.POTION then
        dropData.item = DropManager.SelectWeightedValue(data.potions, data.weights)
    end
    
    return dropData
end

-- Selecionar valor ponderado
function DropManager.SelectWeightedValue(values, weights)
    local totalWeight = 0
    for _, weight in ipairs(weights) do
        totalWeight = totalWeight + weight
    end
    
    local random = math.random() * totalWeight
    local currentWeight = 0
    
    for i, weight in ipairs(weights) do
        currentWeight = currentWeight + weight
        if random <= currentWeight then
            return values[i]
        end
    end
    
    return values[#values] -- Fallback
end

-- Criar modelo do drop
function DropManager.CreateDropModel(position, dropData)
    local model = Instance.new("Model")
    model.Name = "Drop_" .. dropData.id
    model.Parent = workspace
    
    -- Criar parte principal
    local part = Instance.new("Part")
    part.Name = "DropPart"
    part.Size = Vector3.new(2, 2, 2)
    part.Material = Enum.Material.Neon
    part.Color = DROP_RARITIES[dropData.rarity].color
    part.Position = position + Vector3.new(0, 2, 0)
    part.CanCollide = false
    part.Parent = model
    
    -- Adicionar BodyVelocity para flutuação
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 4000, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = part
    
    -- Adicionar BodyPosition para posicionamento
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.Position = part.Position
    bodyPosition.Parent = part
    
    -- Efeito de flutuação
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not part.Parent then
            connection:Disconnect()
            return
        end
        
        local time = tick()
        local offset = math.sin(time * 2) * 0.5
        bodyPosition.Position = position + Vector3.new(0, 2 + offset, 0)
    end)
    
    -- Adicionar partículas
    local particles = Instance.new("Fire")
    particles.Parent = part
    particles.Size = 1
    particles.Heat = 2
    
    -- Adicionar script de coleta
    local collectScript = Instance.new("Script")
    collectScript.Name = "DropCollectScript"
    collectScript.Parent = model
    
    -- Adicionar script de coleta (será implementado separadamente)
    
    -- Auto-destruir após 30 segundos
    Debris:AddItem(model, 30)
    
    return model
end

-- Coletar drop
function DropManager.CollectDrop(player, dropModel)
    local dropPart = dropModel:FindFirstChild("DropPart")
    if not dropPart then
        return false
    end
    
    -- Obter dados do drop
    local dropData = DropManager.GetDropData(dropModel)
    if not dropData then
        return false
    end
    
    -- Processar coleta baseada no tipo
    local success = false
    
    if dropData.type == DROP_TYPES.CASH then
        success = DropManager.CollectCash(player, dropData.value)
    elseif dropData.type == DROP_TYPES.DIAMONDS then
        success = DropManager.CollectDiamonds(player, dropData.value)
    elseif dropData.type == DROP_TYPES.FRAGMENTS then
        success = DropManager.CollectFragments(player, dropData.value)
    elseif dropData.type == DROP_TYPES.SHADOW then
        success = DropManager.CollectShadow(player, dropData.item)
    elseif dropData.type == DROP_TYPES.WEAPON then
        success = DropManager.CollectWeapon(player, dropData.item)
    elseif dropData.type == DROP_TYPES.RELIC then
        success = DropManager.CollectRelic(player, dropData.item)
    elseif dropData.type == DROP_TYPES.POTION then
        success = DropManager.CollectPotion(player, dropData.item)
    end
    
    if success then
        -- Efeito de coleta
        DropManager.CreateCollectEffect(dropPart.Position)
        
        -- Remover drop
        dropModel:Destroy()
        
        -- Notificar cliente
        RemoteEvents.Drop.DropCollected:FireClient(player, dropData)
        
        return true
    end
    
    return false
end

-- Obter dados do drop
function DropManager.GetDropData(dropModel)
    -- TODO: Implementar armazenamento de dados do drop
    -- Por enquanto, retornar dados básicos
    return {
        type = "Cash",
        rarity = "COMMON",
        amount = 10,
        value = 10
    }
end

-- Coletar cash
function DropManager.CollectCash(player, amount)
    -- TODO: Integrar com sistema de economia
    RemoteEvents.Economy.AddCash:FireServer(player, amount)
    return true
end

-- Coletar diamantes
function DropManager.CollectDiamonds(player, amount)
    -- TODO: Integrar com sistema de economia
    RemoteEvents.Economy.AddDiamonds:FireServer(player, amount)
    return true
end

-- Coletar fragmentos
function DropManager.CollectFragments(player, amount)
    -- TODO: Integrar com sistema de inventário
    return true
end

-- Coletar sombra
function DropManager.CollectShadow(player, shadowName)
    -- TODO: Integrar com sistema de sombras
    RemoteEvents.Shadow.CaptureShadow:FireServer(player, shadowName, 1)
    return true
end

-- Coletar arma
function DropManager.CollectWeapon(player, weaponName)
    -- TODO: Integrar com sistema de inventário
    return true
end

-- Coletar relíquia
function DropManager.CollectRelic(player, relicName)
    -- TODO: Integrar com sistema de inventário
    return true
end

-- Coletar poção
function DropManager.CollectPotion(player, potionName)
    -- TODO: Integrar com sistema de inventário
    return true
end

-- Criar efeito de coleta
function DropManager.CreateCollectEffect(position)
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 5
    effect.BlastPressure = 0
    effect.Parent = workspace
    
    -- Partículas de coleta
    local particles = Instance.new("Fire")
    particles.Parent = workspace
    particles.Size = 2
    particles.Heat = 3
    particles.Position = position
    
    Debris:AddItem(particles, 1)
end

-- Conectar eventos
RemoteEvents.Drop.CollectDrop.OnServerEvent:Connect(function(player, dropModel)
    local success = DropManager.CollectDrop(player, dropModel)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de geração
RemoteEvents.Drop.GenerateDrop.OnServerEvent:Connect(function(player, enemy)
    local dropData = DropManager.GenerateDrop(enemy, player)
    if dropData then
        RemoteEvents.Drop.DropGenerated:FireClient(player, dropData)
    end
end)

return DropManager