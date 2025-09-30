--[[
    SHADOW MANAGER
    Localização: ServerScriptService/ShadowSystem/ShadowManager.lua
    
    Este script gerencia o sistema de sombras no servidor:
    - Captura de sombras
    - Invocação e dispensa
    - Evolução de sombras
    - Gerenciamento de inventário
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar dados e eventos
local ShadowData = require(ReplicatedStorage.Data.ShadowData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local ShadowManager = {}

-- Dados dos jogadores
local playerData = {}

-- Inicializar dados do jogador
function ShadowManager.InitializePlayer(player)
    if not playerData[player] then
        playerData[player] = {
            shadows = {}, -- Inventário de sombras
            activeShadow = nil, -- Sombra ativa
            shadowInventory = {
                maxSlots = 20,
                usedSlots = 0
            }
        }
    end
end

-- Capturar sombra
function ShadowManager.CaptureShadow(player, enemyName, enemyLevel)
    ShadowManager.InitializePlayer(player)
    
    local data = playerData[player]
    local shadowData = ShadowData.SHADOWS[enemyName]
    
    if not shadowData then
        return false, "Sombra não encontrada"
    end
    
    -- Verificar se há espaço no inventário
    if data.shadowInventory.usedSlots >= data.shadowInventory.maxSlots then
        return false, "Inventário cheio"
    end
    
    -- Calcular chance de captura baseada na raridade
    local captureChance = shadowData.rarity * 100
    local random = math.random(1, 100)
    
    if random <= captureChance then
        -- Criar nova sombra
        local newShadow = {
            id = #data.shadows + 1,
            name = enemyName,
            rank = shadowData.rank,
            level = enemyLevel or 1,
            experience = 0,
            health = shadowData.baseHealth,
            damage = shadowData.baseDamage,
            speed = shadowData.baseSpeed,
            abilities = shadowData.abilities,
            isActive = false,
            capturedAt = tick()
        }
        
        -- Adicionar ao inventário
        table.insert(data.shadows, newShadow)
        data.shadowInventory.usedSlots = data.shadowInventory.usedSlots + 1
        
        -- Notificar cliente
        RemoteEvents.Shadow.ShadowCaptured:FireClient(player, newShadow)
        
        return true, "Sombra capturada com sucesso!"
    else
        return false, "Falha na captura"
    end
end

-- Invocar sombra
function ShadowManager.SummonShadow(player, shadowId)
    ShadowManager.InitializePlayer(player)
    
    local data = playerData[player]
    local shadow = nil
    
    -- Encontrar sombra pelo ID
    for i, s in ipairs(data.shadows) do
        if s.id == shadowId then
            shadow = s
            break
        end
    end
    
    if not shadow then
        return false, "Sombra não encontrada"
    end
    
    -- Dispensar sombra ativa atual
    if data.activeShadow then
        ShadowManager.DismissShadow(player)
    end
    
    -- Ativar nova sombra
    shadow.isActive = true
    data.activeShadow = shadow
    
    -- Criar modelo da sombra no mundo
    local shadowModel = ShadowManager.CreateShadowModel(player, shadow)
    if shadowModel then
        shadow.model = shadowModel
    end
    
    -- Notificar cliente
    RemoteEvents.Shadow.ShadowSummoned:FireClient(player, shadow)
    
    return true, "Sombra invocada com sucesso!"
end

-- Dispensar sombra
function ShadowManager.DismissShadow(player)
    ShadowManager.InitializePlayer(player)
    
    local data = playerData[player]
    
    if data.activeShadow then
        data.activeShadow.isActive = false
        
        -- Remover modelo do mundo
        if data.activeShadow.model then
            data.activeShadow.model:Destroy()
            data.activeShadow.model = nil
        end
        
        data.activeShadow = nil
        
        -- Notificar cliente
        RemoteEvents.Shadow.DismissShadow:FireClient(player)
        
        return true, "Sombra dispensada"
    end
    
    return false, "Nenhuma sombra ativa"
end

-- Evoluir sombra
function ShadowManager.EvolveShadow(player, shadowId, evolutionCost)
    ShadowManager.InitializePlayer(player)
    
    local data = playerData[player]
    local shadow = nil
    
    -- Encontrar sombra pelo ID
    for i, s in ipairs(data.shadows) do
        if s.id == shadowId then
            shadow = s
            break
        end
    end
    
    if not shadow then
        return false, "Sombra não encontrada"
    end
    
    -- Verificar requisitos de evolução
    local evolutionReq = ShadowData.EVOLUTION.evolutionRequirements[shadow.rank]
    if not evolutionReq then
        return false, "Sombra já está no rank máximo"
    end
    
    if shadow.level < evolutionReq.level then
        return false, "Nível insuficiente para evolução"
    end
    
    -- Verificar recursos
    -- TODO: Implementar verificação de recursos (cash, diamantes, fragmentos)
    
    -- Evoluir sombra
    shadow.rank = evolutionReq.rank
    shadow.level = 1 -- Resetar nível após evolução
    shadow.experience = 0
    
    -- Aumentar atributos base
    local rankMultiplier = ShadowData.RANKS[shadow.rank].multiplier
    shadow.health = shadow.health * rankMultiplier
    shadow.damage = shadow.damage * rankMultiplier
    shadow.speed = shadow.speed * rankMultiplier
    
    -- Notificar cliente
    RemoteEvents.Shadow.ShadowEvolved:FireClient(player, shadow)
    
    return true, "Sombra evoluída com sucesso!"
end

-- Criar modelo da sombra no mundo
function ShadowManager.CreateShadowModel(player, shadow)
    local shadowData = ShadowData.SHADOWS[shadow.name]
    if not shadowData then
        return nil
    end
    
    -- Criar modelo básico
    local model = Instance.new("Model")
    model.Name = shadow.name
    model.Parent = workspace
    
    -- Criar parte principal
    local part = Instance.new("Part")
    part.Name = "ShadowBody"
    part.Size = Vector3.new(4, 4, 4)
    part.Material = Enum.Material.Neon
    part.Color = ShadowData.RANKS[shadow.rank].color
    part.Parent = model
    
    -- Posicionar próximo ao jogador
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        part.Position = character.HumanoidRootPart.Position + Vector3.new(5, 0, 0)
    end
    
    -- Criar script de comportamento
    local behaviorScript = Instance.new("Script")
    behaviorScript.Name = "ShadowBehavior"
    behaviorScript.Parent = model
    
    -- Adicionar script de comportamento (será implementado separadamente)
    
    return model
end

-- Obter inventário de sombras
function ShadowManager.GetShadowInventory(player)
    ShadowManager.InitializePlayer(player)
    return playerData[player].shadows
end

-- Obter sombra ativa
function ShadowManager.GetActiveShadow(player)
    ShadowManager.InitializePlayer(player)
    return playerData[player].activeShadow
end

-- Conectar eventos
local function onPlayerAdded(player)
    ShadowManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    -- Dispensar sombra ativa
    if playerData[player] and playerData[player].activeShadow then
        ShadowManager.DismissShadow(player)
    end
    
    -- Limpar dados
    playerData[player] = nil
end

-- Conectar eventos de captura
RemoteEvents.Shadow.CaptureShadow.OnServerEvent:Connect(function(player, enemyName, enemyLevel)
    local success, message = ShadowManager.CaptureShadow(player, enemyName, enemyLevel)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de invocação
RemoteEvents.Shadow.SummonShadow.OnServerEvent:Connect(function(player, shadowId)
    local success, message = ShadowManager.SummonShadow(player, shadowId)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de dispensa
RemoteEvents.Shadow.DismissShadow.OnServerEvent:Connect(function(player)
    ShadowManager.DismissShadow(player)
end)

-- Conectar eventos de evolução
RemoteEvents.Shadow.EvolveShadow.OnServerEvent:Connect(function(player, shadowId, evolutionCost)
    local success, message = ShadowManager.EvolveShadow(player, shadowId, evolutionCost)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return ShadowManager