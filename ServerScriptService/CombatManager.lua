--[[
    COMBAT MANAGER - Sistema de Combate Dinâmico
    Sistema completo de combate para Anime Fighters Simulator
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

print("⚔️ === COMBAT MANAGER INICIADO ===")

-- Criar pasta de eventos
local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not eventsFolder then
    eventsFolder = Instance.new("Folder")
    eventsFolder.Name = "Events"
    eventsFolder.Parent = ReplicatedStorage
end

-- Criar eventos de combate
local attackEvent = eventsFolder:FindFirstChild("AttackNPC")
if not attackEvent then
    attackEvent = Instance.new("RemoteEvent")
    attackEvent.Name = "AttackNPC"
    attackEvent.Parent = eventsFolder
end

local npcDiedEvent = eventsFolder:FindFirstChild("NPCDied")
if not npcDiedEvent then
    npcDiedEvent = Instance.new("RemoteEvent")
    npcDiedEvent.Name = "NPCDied"
    npcDiedEvent.Parent = eventsFolder
end

local updateHUDEvent = eventsFolder:FindFirstChild("UpdateHUD")
if not updateHUDEvent then
    updateHUDEvent = Instance.new("RemoteEvent")
    updateHUDEvent.Name = "UpdateHUD"
    updateHUDEvent.Parent = eventsFolder
end

-- Sistema de NPCs
local NPCManager = {}

-- Dados dos NPCs
local npcData = {
    ["Shadow Wolf"] = {
        Health = 500,
        MaxHealth = 500,
        Damage = 50,
        Speed = 16,
        Range = 10,
        Level = 5,
        Rank = "F",
        Drops = {
            Cash = {min = 50, max = 100},
            XP = {min = 25, max = 50},
            ShadowChance = 0.1
        }
    },
    ["Shadow Bear"] = {
        Health = 1000,
        MaxHealth = 1000,
        Damage = 80,
        Speed = 12,
        Range = 8,
        Level = 10,
        Rank = "E",
        Drops = {
            Cash = {min = 100, max = 200},
            XP = {min = 50, max = 100},
            ShadowChance = 0.15
        }
    },
    ["Shadow Tiger"] = {
        Health = 2000,
        MaxHealth = 2000,
        Damage = 120,
        Speed = 20,
        Range = 12,
        Level = 20,
        Rank = "D",
        Drops = {
            Cash = {min = 200, max = 400},
            XP = {min = 100, max = 200},
            ShadowChance = 0.2
        }
    }
}

-- NPCs ativos no mundo
local activeNPCs = {}

-- Sistema de combate
local CombatManager = {}

-- Função para criar NPC
function NPCManager:CreateNPC(npcName, position)
    local npcData = npcData[npcName]
    if not npcData then return nil end
    
    -- Criar modelo do NPC
    local npc = Instance.new("Model")
    npc.Name = npcName
    npc.Parent = workspace
    
    -- Part principal
    local part = Instance.new("Part")
    part.Name = "HumanoidRootPart"
    part.Size = Vector3.new(4, 6, 2)
    part.Position = position
    part.Material = Enum.Material.Neon
    part.BrickColor = BrickColor.new("Bright blue")
    part.Shape = Enum.PartType.Block
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = npc
    
    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = npcData.MaxHealth
    humanoid.Health = npcData.Health
    humanoid.WalkSpeed = npcData.Speed
    humanoid.Parent = npc
    
    -- Configurar NPC
    npc:SetPrimaryPartCFrame(CFrame.new(position))
    
    -- Adicionar à lista de NPCs ativos
    activeNPCs[npc] = {
        Data = npcData,
        LastAttack = 0,
        Attackers = {}
    }
    
    -- Criar barra de vida
    self:CreateHealthBar(npc)
    
    print("👾 NPC criado:", npcName, "em", position)
    return npc
end

-- Função para criar barra de vida
function NPCManager:CreateHealthBar(npc)
    local gui = Instance.new("BillboardGui")
    gui.Name = "HealthBar"
    gui.Size = UDim2.new(0, 100, 0, 20)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = npc
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = frame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = npc.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = gui
    
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Size = UDim2.new(1, 0, 0.5, 0)
    levelLabel.Position = UDim2.new(0, 0, 0.5, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Nível " .. (activeNPCs[npc].Data.Level or 1)
    levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.SourceSans
    levelLabel.Parent = gui
end

-- Função para atualizar barra de vida
function NPCManager:UpdateHealthBar(npc, health, maxHealth)
    local gui = npc:FindFirstChild("HealthBar")
    if gui then
        local healthBar = gui:FindFirstChild("HealthBar")
        if healthBar then
            local percentage = health / maxHealth
            healthBar.Size = UDim2.new(percentage, 0, 1, 0)
            
            -- Mudar cor baseada na vida
            if percentage > 0.6 then
                healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            elseif percentage > 0.3 then
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
            else
                healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end

-- Função para processar ataque
function CombatManager:ProcessAttack(player, npc, damage)
    if not activeNPCs[npc] then return end
    
    local npcInfo = activeNPCs[npc]
    local humanoid = npc:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Aplicar dano
    local newHealth = math.max(0, humanoid.Health - damage)
    humanoid.Health = newHealth
    
    -- Atualizar barra de vida
    NPCManager:UpdateHealthBar(npc, newHealth, npcInfo.Data.MaxHealth)
    
    -- Criar efeito de dano
    self:CreateDamageEffect(npc, damage)
    
    -- Verificar se NPC morreu
    if newHealth <= 0 then
        self:HandleNPCDefeat(player, npc)
    end
    
    print("💥", player.Name, "causou", damage, "de dano em", npc.Name)
end

-- Função para criar efeito de dano
function CombatManager:CreateDamageEffect(npc, damage)
    -- Criar explosão
    local explosion = Instance.new("Explosion")
    explosion.Position = npc.PrimaryPart.Position
    explosion.BlastRadius = 0
    explosion.BlastPressure = 0
    explosion.Parent = workspace
    
    -- Criar partículas
    local attachment = Instance.new("Attachment")
    attachment.Parent = npc.PrimaryPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/fire_main.dds"
    particles.Lifetime = NumberRange.new(0.5, 1.0)
    particles.Rate = 100
    particles.SpreadAngle = Vector2.new(45, 45)
    particles.Speed = NumberRange.new(5, 15)
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
    
    -- Limpar partículas
    Debris:AddItem(particles, 2)
    Debris:AddItem(attachment, 2)
    
    -- Criar texto de dano
    local damageGui = Instance.new("BillboardGui")
    damageGui.Size = UDim2.new(0, 100, 0, 50)
    damageGui.StudsOffset = Vector3.new(0, 2, 0)
    damageGui.Parent = npc
    
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Size = UDim2.new(1, 0, 1, 0)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "-" .. damage
    damageLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    damageLabel.TextScaled = true
    damageLabel.Font = Enum.Font.SourceSansBold
    damageLabel.Parent = damageGui
    
    -- Animação do texto
    local tween = TweenService:Create(damageLabel, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0, 0, 0, -50),
        TextTransparency = 1
    })
    tween:Play()
    
    -- Limpar GUI
    Debris:AddItem(damageGui, 1)
end

-- Função para lidar com derrota do NPC
function CombatManager:HandleNPCDefeat(player, npc)
    local npcInfo = activeNPCs[npc]
    if not npcInfo then return end
    
    -- Remover da lista de NPCs ativos
    activeNPCs[npc] = nil
    
    -- Criar efeito de morte
    self:CreateDeathEffect(npc)
    
    -- Processar drops
    self:ProcessDrops(player, npc, npcInfo.Data.Drops)
    
    -- Disparar evento de morte
    npcDiedEvent:FireAllClients(npc.Name, npc.PrimaryPart.Position)
    
    -- Remover NPC
    Debris:AddItem(npc, 2)
    
    print("💀 NPC derrotado:", npc.Name, "por", player.Name)
end

-- Função para criar efeito de morte
function CombatManager:CreateDeathEffect(npc)
    -- Explosão maior
    local explosion = Instance.new("Explosion")
    explosion.Position = npc.PrimaryPart.Position
    explosion.BlastRadius = 10
    explosion.BlastPressure = 0
    explosion.Parent = workspace
    
    -- Partículas de morte
    local attachment = Instance.new("Attachment")
    attachment.Parent = npc.PrimaryPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
    particles.Lifetime = NumberRange.new(1.0, 2.0)
    particles.Rate = 200
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.Speed = NumberRange.new(10, 25)
    particles.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
    
    -- Limpar partículas
    Debris:AddItem(particles, 3)
    Debris:AddItem(attachment, 3)
end

-- Função para processar drops
function CombatManager:ProcessDrops(player, npc, drops)
    -- Dar Cash
    if drops.Cash then
        local cashAmount = math.random(drops.Cash.min, drops.Cash.max)
        -- Aqui você conectaria com o sistema de dados
        print("💰 Cash ganho:", cashAmount)
    end
    
    -- Dar XP
    if drops.XP then
        local xpAmount = math.random(drops.XP.min, drops.XP.max)
        -- Aqui você conectaria com o sistema de dados
        print("⭐ XP ganho:", xpAmount)
    end
    
    -- Chance de capturar sombra
    if drops.ShadowChance and math.random() < drops.ShadowChance then
        -- Aqui você conectaria com o sistema de sombras
        print("👻 Sombra capturada:", npc.Name)
    end
end

-- Função para calcular dano
function CombatManager:CalculateDamage(player, npc)
    -- Dano base do jogador
    local baseDamage = 50
    
    -- Modificadores baseados no nível
    local playerLevel = 1 -- Aqui você pegaria do sistema de dados
    local npcLevel = activeNPCs[npc].Data.Level
    
    -- Cálculo de dano
    local damage = baseDamage * (1 + (playerLevel - npcLevel) * 0.1)
    
    -- Adicionar variação aleatória
    damage = damage * (0.8 + math.random() * 0.4)
    
    return math.floor(damage)
end

-- Conectar evento de ataque
attackEvent.OnServerEvent:Connect(function(player, npc)
    if not npc or not npc.Parent then return end
    
    -- Verificar se NPC está ativo
    if not activeNPCs[npc] then return end
    
    -- Calcular dano
    local damage = CombatManager:CalculateDamage(player, npc)
    
    -- Processar ataque
    CombatManager:ProcessAttack(player, npc, damage)
    
    -- Atualizar HUD
    updateHUDEvent:FireClient(player, "Combat", {
        Target = npc.Name,
        Damage = damage,
        Health = npc:FindFirstChild("Humanoid").Health
    })
end)

-- Sistema de spawn de NPCs
local function spawnNPCs()
    local spawnPoints = {
        Vector3.new(0, 5, 0),
        Vector3.new(20, 5, 0),
        Vector3.new(-20, 5, 0),
        Vector3.new(0, 5, 20),
        Vector3.new(0, 5, -20)
    }
    
    local npcNames = {"Shadow Wolf", "Shadow Bear", "Shadow Tiger"}
    
    for _, position in ipairs(spawnPoints) do
        local npcName = npcNames[math.random(1, #npcNames)]
        NPCManager:CreateNPC(npcName, position)
    end
end

-- Sistema de respawn
local function respawnNPCs()
    while true do
        wait(30) -- Respawn a cada 30 segundos
        
        -- Limpar NPCs mortos
        for npc, _ in pairs(activeNPCs) do
            if not npc.Parent then
                activeNPCs[npc] = nil
            end
        end
        
        -- Spawnar novos NPCs se necessário
        local npcCount = 0
        for _ in pairs(activeNPCs) do
            npcCount = npcCount + 1
        end
        
        if npcCount < 3 then
            spawnNPCs()
        end
    end
end

-- Inicializar sistema
spawn(function()
    wait(2)
    spawnNPCs()
    respawnNPCs()
end)

print("✅ CombatManager carregado com sucesso!")