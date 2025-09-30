--[[
    RELIC MANAGER
    Localização: ServerScriptService/Relics/RelicManager.lua
    
    Este script gerencia o sistema de relíquias:
    - Equipamento de relíquias
    - Sistema de fusão
    - Aplicação de bônus
    - Integração com outros sistemas
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar dados e eventos
local RelicData = require(ReplicatedStorage.Data.RelicData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local RelicManager = {}

-- Dados dos jogadores
local playerRelics = {}

-- Inicializar dados do jogador
function RelicManager.InitializePlayer(player)
    if not playerRelics[player] then
        playerRelics[player] = {
            equippedRelics = {
                damage = nil,
                speed = nil,
                health = nil,
                critical = nil,
                capture = nil,
                experience = nil
            },
            relics = {},
            fusionLevel = 1,
            fusionExperience = 0
        }
    end
end

-- Equipar relíquia
function RelicManager.EquipRelic(player, relicName, slot)
    RelicManager.InitializePlayer(player)
    
    local data = playerRelics[player]
    local relicData = RelicData.RELICS[relicName]
    
    if not relicData then
        return false, "Relíquia não encontrada"
    end
    
    -- Verificar se o jogador possui a relíquia
    if not data.relics[relicName] or data.relics[relicName] <= 0 then
        return false, "Relíquia não encontrada no inventário"
    end
    
    -- Verificar se o slot é válido
    if not data.equippedRelics[slot] then
        return false, "Slot inválido"
    end
    
    -- Verificar se o tipo da relíquia corresponde ao slot
    if relicData.type ~= slot then
        return false, "Tipo de relíquia incompatível com o slot"
    end
    
    -- Desequipar relíquia atual do slot
    if data.equippedRelics[slot] then
        RelicManager.UnequipRelic(player, slot)
    end
    
    -- Equipar nova relíquia
    data.equippedRelics[slot] = relicName
    
    -- Aplicar bônus da relíquia
    RelicManager.ApplyRelicBonus(player, relicName, slot)
    
    -- Notificar cliente
    RemoteEvents.Relic.RelicEquipped:FireClient(player, relicName, slot)
    
    return true, "Relíquia equipada com sucesso!"
end

-- Desequipar relíquia
function RelicManager.UnequipRelic(player, slot)
    RelicManager.InitializePlayer(player)
    
    local data = playerRelics[player]
    
    if not data.equippedRelics[slot] then
        return false, "Nenhuma relíquia equipada neste slot"
    end
    
    local relicName = data.equippedRelics[slot]
    
    -- Remover bônus da relíquia
    RelicManager.RemoveRelicBonus(player, relicName, slot)
    
    -- Desequipar relíquia
    data.equippedRelics[slot] = nil
    
    -- Notificar cliente
    RemoteEvents.Relic.RelicUnequipped:FireClient(player, slot)
    
    return true, "Relíquia desequipada"
end

-- Fundir relíquias
function RelicManager.FuseRelics(player, relic1, relic2, resultRelic)
    RelicManager.InitializePlayer(player)
    
    local data = playerRelics[player]
    
    -- Verificar se possui as relíquias
    if not data.relics[relic1] or data.relics[relic1] <= 0 then
        return false, "Primeira relíquia não encontrada"
    end
    
    if not data.relics[relic2] or data.relics[relic2] <= 0 then
        return false, "Segunda relíquia não encontrada"
    end
    
    -- Verificar se o resultado é válido
    if not RelicData.RELICS[resultRelic] then
        return false, "Relíquia resultante inválida"
    end
    
    -- Verificar requisitos de fusão
    local fusionReq = RelicData.FUSION.fusionRequirements
    local relic1Data = RelicData.RELICS[relic1]
    local relic2Data = RelicData.RELICS[relic2]
    
    if not fusionReq[relic1Data.rarity] then
        return false, "Raridade não pode ser fundida"
    end
    
    if fusionReq[relic1Data.rarity].result ~= RelicData.RELICS[resultRelic].rarity then
        return false, "Resultado da fusão inválido"
    end
    
    -- Verificar custo da fusão
    local fusionCost = RelicData.FUSION.fusionCost
    if not RelicManager.HasResources(player, fusionCost) then
        return false, "Recursos insuficientes para fusão"
    end
    
    -- Remover recursos
    RelicManager.RemoveResources(player, fusionCost)
    
    -- Remover relíquias originais
    data.relics[relic1] = data.relics[relic1] - 1
    data.relics[relic2] = data.relics[relic2] - 1
    
    -- Adicionar relíquia resultante
    if data.relics[resultRelic] then
        data.relics[resultRelic] = data.relics[resultRelic] + 1
    else
        data.relics[resultRelic] = 1
    end
    
    -- Ganhar experiência de fusão
    data.fusionExperience = data.fusionExperience + 100
    if data.fusionExperience >= RelicManager.GetRequiredFusionXP(data.fusionLevel) then
        RelicManager.LevelUpFusion(player)
    end
    
    -- Notificar cliente
    RemoteEvents.Relic.RelicsFused:FireClient(player, relic1, relic2, resultRelic)
    
    return true, "Relíquias fundidas com sucesso!"
end

-- Aplicar bônus da relíquia
function RelicManager.ApplyRelicBonus(player, relicName, slot)
    local relicData = RelicData.RELICS[relicName]
    if not relicData then
        return
    end
    
    -- TODO: Implementar aplicação de bônus
    -- Por enquanto, apenas registrar
    print("Aplicando bônus da relíquia:", relicName, "no slot:", slot)
end

-- Remover bônus da relíquia
function RelicManager.RemoveRelicBonus(player, relicName, slot)
    local relicData = RelicData.RELICS[relicName]
    if not relicData then
        return
    end
    
    -- TODO: Implementar remoção de bônus
    -- Por enquanto, apenas registrar
    print("Removendo bônus da relíquia:", relicName, "do slot:", slot)
end

-- Verificar recursos
function RelicManager.HasResources(player, cost)
    -- TODO: Implementar verificação de recursos
    -- Por enquanto, sempre retornar true
    return true
end

-- Remover recursos
function RelicManager.RemoveResources(player, cost)
    -- TODO: Implementar remoção de recursos
    -- Por enquanto, não fazer nada
end

-- Subir nível da fusão
function RelicManager.LevelUpFusion(player)
    local data = playerRelics[player]
    data.fusionLevel = data.fusionLevel + 1
    data.fusionExperience = 0
    
    -- Notificar cliente
    RemoteEvents.Relic.FusionLevelUp:FireClient(player, data.fusionLevel)
end

-- Obter XP necessário para a fusão
function RelicManager.GetRequiredFusionXP(level)
    return level * 500
end

-- Obter dados do jogador
function RelicManager.GetPlayerData(player)
    RelicManager.InitializePlayer(player)
    return playerRelics[player]
end

-- Obter relíquias equipadas
function RelicManager.GetEquippedRelics(player)
    local data = playerRelics[player]
    if not data then
        return {}
    end
    
    return data.equippedRelics
end

-- Obter estatísticas da relíquia
function RelicManager.GetRelicStats(player, relicName)
    local relicData = RelicData.RELICS[relicName]
    if not relicData then
        return nil
    end
    
    local stats = {
        name = relicName,
        type = relicData.type,
        rarity = relicData.rarity,
        effect = relicData.effect,
        value = relicData.value,
        description = relicData.description,
        icon = relicData.icon
    }
    
    return stats
end

-- Obter lista de relíquias do jogador
function RelicManager.GetPlayerRelics(player)
    local data = playerRelics[player]
    if not data then
        return {}
    end
    
    local relics = {}
    for relicName, quantity in pairs(data.relics) do
        if quantity > 0 then
            table.insert(relics, {
                name = relicName,
                quantity = quantity,
                stats = RelicManager.GetRelicStats(player, relicName)
            })
        end
    end
    
    return relics
end

-- Obter bônus total do jogador
function RelicManager.GetTotalBonus(player)
    local data = playerRelics[player]
    if not data then
        return {}
    end
    
    local bonuses = {
        damage = 0,
        speed = 0,
        health = 0,
        critical = 0,
        capture = 0,
        experience = 0
    }
    
    for slot, relicName in pairs(data.equippedRelics) do
        if relicName then
            local relicData = RelicData.RELICS[relicName]
            if relicData then
                bonuses[slot] = bonuses[slot] + relicData.value
            end
        end
    end
    
    return bonuses
end

-- Obter relíquias por tipo
function RelicManager.GetRelicsByType(player, type)
    local data = playerRelics[player]
    if not data then
        return {}
    end
    
    local relics = {}
    for relicName, quantity in pairs(data.relics) do
        if quantity > 0 then
            local relicData = RelicData.RELICS[relicName]
            if relicData and relicData.type == type then
                table.insert(relics, {
                    name = relicName,
                    quantity = quantity,
                    stats = RelicManager.GetRelicStats(player, relicName)
                })
            end
        end
    end
    
    return relics
end

-- Obter relíquias por raridade
function RelicManager.GetRelicsByRarity(player, rarity)
    local data = playerRelics[player]
    if not data then
        return {}
    end
    
    local relics = {}
    for relicName, quantity in pairs(data.relics) do
        if quantity > 0 then
            local relicData = RelicData.RELICS[relicName]
            if relicData and relicData.rarity == rarity then
                table.insert(relics, {
                    name = relicName,
                    quantity = quantity,
                    stats = RelicManager.GetRelicStats(player, relicName)
                })
            end
        end
    end
    
    return relics
end

-- Conectar eventos
local function onPlayerAdded(player)
    RelicManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerRelics[player] = nil
end

-- Conectar eventos de relíquias
RemoteEvents.Relic.EquipRelic.OnServerEvent:Connect(function(player, relicName, slot)
    local success, message = RelicManager.EquipRelic(player, relicName, slot)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Relic.UnequipRelic.OnServerEvent:Connect(function(player, slot)
    local success, message = RelicManager.UnequipRelic(player, slot)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Relic.FuseRelics.OnServerEvent:Connect(function(player, relic1, relic2, resultRelic)
    local success, message = RelicManager.FuseRelics(player, relic1, relic2, resultRelic)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return RelicManager