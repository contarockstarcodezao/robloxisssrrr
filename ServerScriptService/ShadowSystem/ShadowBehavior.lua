--[[
    SHADOW BEHAVIOR SCRIPT
    Localização: ServerScriptService/ShadowSystem/ShadowBehavior.lua
    
    Este script controla o comportamento das sombras invocadas:
    - Seguir o jogador
    - Atacar inimigos automaticamente
    - Usar habilidades
    - Gerenciar cooldowns
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Importar dados
local ShadowData = require(ReplicatedStorage.Data.ShadowData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local ShadowBehavior = {}

-- Dados da sombra
local shadow = script.Parent
local shadowBody = shadow:FindFirstChild("ShadowBody")
local owner = nil
local shadowData = nil
local lastAttackTime = 0
local attackCooldown = 2 -- Cooldown base entre ataques

-- Inicializar sombra
function ShadowBehavior.Initialize(ownerPlayer, data)
    owner = ownerPlayer
    shadowData = data
    
    if not shadowBody then
        warn("ShadowBody não encontrado!")
        return
    end
    
    -- Configurar propriedades físicas
    shadowBody.CanCollide = false
    shadowBody.Anchored = false
    
    -- Adicionar BodyVelocity para movimento
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 0, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = shadowBody
    
    -- Adicionar BodyPosition para posicionamento
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyPosition.Position = shadowBody.Position
    bodyPosition.Parent = shadowBody
    
    -- Iniciar loop de comportamento
    ShadowBehavior.StartBehaviorLoop()
end

-- Loop principal de comportamento
function ShadowBehavior.StartBehaviorLoop()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not owner or not owner.Character or not owner.Character:FindFirstChild("HumanoidRootPart") then
            connection:Disconnect()
            return
        end
        
        -- Seguir o jogador
        ShadowBehavior.FollowOwner()
        
        -- Procurar e atacar inimigos
        ShadowBehavior.FindAndAttackEnemies()
    end)
end

-- Fazer a sombra seguir o jogador
function ShadowBehavior.FollowOwner()
    if not owner.Character or not owner.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local ownerPosition = owner.Character.HumanoidRootPart.Position
    local shadowPosition = shadowBody.Position
    local distance = (ownerPosition - shadowPosition).Magnitude
    
    -- Manter distância do jogador
    local followDistance = 8
    if distance > followDistance then
        local direction = (ownerPosition - shadowPosition).Unit
        local targetPosition = ownerPosition - (direction * 5) -- 5 unidades atrás do jogador
        
        local bodyPosition = shadowBody:FindFirstChild("BodyPosition")
        if bodyPosition then
            bodyPosition.Position = targetPosition
        end
    end
end

-- Procurar e atacar inimigos
function ShadowBehavior.FindAndAttackEnemies()
    if tick() - lastAttackTime < attackCooldown then
        return
    end
    
    local shadowPosition = shadowBody.Position
    local attackRange = 15
    
    -- Procurar inimigos próximos
    local nearestEnemy = nil
    local nearestDistance = math.huge
    
    for _, npc in ipairs(workspace:GetChildren()) do
        if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
            -- Verificar se é um inimigo (não é o jogador)
            if npc ~= owner.Character then
                local distance = (npc.HumanoidRootPart.Position - shadowPosition).Magnitude
                if distance <= attackRange and distance < nearestDistance then
                    nearestEnemy = npc
                    nearestDistance = distance
                end
            end
        end
    end
    
    -- Atacar inimigo mais próximo
    if nearestEnemy then
        ShadowBehavior.AttackEnemy(nearestEnemy)
        lastAttackTime = tick()
    end
end

-- Atacar inimigo
function ShadowBehavior.AttackEnemy(enemy)
    if not enemy:FindFirstChild("Humanoid") then
        return
    end
    
    local humanoid = enemy.Humanoid
    local shadowPosition = shadowBody.Position
    local enemyPosition = enemy.HumanoidRootPart.Position
    
    -- Calcular dano
    local damage = shadowData.damage
    if shadowData.rank then
        local rankMultiplier = ShadowData.RANKS[shadowData.rank].multiplier
        damage = damage * rankMultiplier
    end
    
    -- Aplicar dano
    humanoid.Health = humanoid.Health - damage
    
    -- Efeitos visuais
    ShadowBehavior.CreateAttackEffect(enemyPosition)
    
    -- Usar habilidade ativa se disponível
    if shadowData.abilities and shadowData.abilities.active then
        ShadowBehavior.UseActiveAbility(enemy)
    end
    
    -- Notificar servidor sobre o ataque
    RemoteEvents.Combat.ShadowAttack:FireServer(enemy, damage)
end

-- Usar habilidade ativa
function ShadowBehavior.UseActiveAbility(target)
    if not shadowData.abilities or not shadowData.abilities.active then
        return
    end
    
    local abilityName = shadowData.abilities.active
    local ability = ShadowData.ABILITIES[abilityName]
    
    if ability and ability.type == "active" then
        -- Verificar cooldown da habilidade
        if not shadowData.lastAbilityTime then
            shadowData.lastAbilityTime = 0
        end
        
        if tick() - shadowData.lastAbilityTime >= ability.cooldown then
            -- Usar habilidade
            ability.effect(shadowData, target)
            shadowData.lastAbilityTime = tick()
            
            -- Efeitos visuais da habilidade
            ShadowBehavior.CreateAbilityEffect(target.HumanoidRootPart.Position, abilityName)
        end
    end
end

-- Criar efeito de ataque
function ShadowBehavior.CreateAttackEffect(position)
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 5
    effect.BlastPressure = 0
    effect.Parent = workspace
    
    -- Partículas de ataque
    local particles = Instance.new("Fire")
    particles.Parent = shadowBody
    particles.Size = 2
    particles.Heat = 5
    
    Debris:AddItem(particles, 1)
end

-- Criar efeito de habilidade
function ShadowBehavior.CreateAbilityEffect(position, abilityName)
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 10
    effect.BlastPressure = 0
    effect.Parent = workspace
    
    -- Efeitos específicos por habilidade
    if abilityName == "Dragon Breath" then
        local fire = Instance.new("Fire")
        fire.Parent = workspace
        fire.Size = 5
        fire.Heat = 10
        fire.Parent = workspace
        
        Debris:AddItem(fire, 3)
    elseif abilityName == "Phoenix Flames" then
        local explosion = Instance.new("Explosion")
        explosion.Position = position
        explosion.BlastRadius = 20
        explosion.BlastPressure = 1000
        explosion.Parent = workspace
    end
end

-- Limpar sombra quando dispensada
function ShadowBehavior.Cleanup()
    if shadowBody then
        shadowBody:Destroy()
    end
end

-- Conectar eventos de limpeza
shadow.AncestryChanged:Connect(function()
    if not shadow.Parent then
        ShadowBehavior.Cleanup()
    end
end)

return ShadowBehavior