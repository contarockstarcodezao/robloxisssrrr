--[[
    NPCManager.lua - VERSÃO CORRIGIDA
    Gerencia NPCs com callbacks para CombatSystem
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NPCData = require(ReplicatedStorage.Modules.NPCData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local NPCManager = {}
NPCManager.ActiveNPCs = {} -- {NPC Instance -> Data}
NPCManager.NPCHealths = {} -- {NPC Instance -> Current Health}
NPCManager.OnNPCDeathCallback = nil -- ⭐ CALLBACK PARA COMBATSYSTEM

-- ========================================
-- CRIAÇÃO DE NPC
-- ========================================

function NPCManager:CreateNPCModel(npcData)
    local model = Instance.new("Model")
    model.Name = npcData.Name
    
    -- Corpo principal
    local torso = Instance.new("Part")
    torso.Name = "HumanoidRootPart"
    torso.Size = Vector3.new(2, 3, 1)
    torso.Color = npcData.ModelColor
    torso.Anchored = false
    torso.CanCollide = true
    torso.Parent = model
    
    -- Cabeça
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1.5, 1.5, 1.5)
    head.Color = npcData.ModelColor
    head.Parent = model
    
    -- Weld
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = torso
    weld.Part1 = head
    weld.Parent = torso
    
    head.Position = torso.Position + Vector3.new(0, 2.25, 0)
    
    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = npcData.Health
    humanoid.Health = npcData.Health
    humanoid.WalkSpeed = 0
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.Parent = model
    
    -- Billboard com nome e rank
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "NameDisplay"
    billboardGui.Size = UDim2.new(0, 200, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = npcData.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 16
    nameLabel.Parent = billboardGui
    
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Size = UDim2.new(1, 0, 0.5, 0)
    rankLabel.Position = UDim2.new(0, 0, 0.5, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "[Rank " .. npcData.Rank .. "]"
    local RankData = require(ReplicatedStorage.Modules.RankData)
    rankLabel.TextColor3 = RankData:GetRankByName(npcData.Rank).Color
    rankLabel.TextStrokeTransparency = 0.5
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.TextSize = 14
    rankLabel.Parent = billboardGui
    
    model.PrimaryPart = torso
    
    return model
end

-- ========================================
-- BARRA DE VIDA
-- ========================================

function NPCManager:CreateHealthBar(npc, npcData)
    local head = npc:FindFirstChild("Head")
    if not head then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "HealthBar"
    billboardGui.Size = UDim2.new(0, 200, 0, 20)
    billboardGui.StudsOffset = Vector3.new(0, 4, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    background.BorderSizePixel = 2
    background.BorderColor3 = Color3.new(0, 0, 0)
    background.Parent = billboardGui
    
    local healthBar = Instance.new("Frame")
    healthBar.Name = "Bar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = background
    
    local healthText = Instance.new("TextLabel")
    healthText.Name = "HealthText"
    healthText.Size = UDim2.new(1, 0, 1, 0)
    healthText.BackgroundTransparency = 1
    healthText.Text = npcData.Health .. "/" .. npcData.Health
    healthText.TextColor3 = Color3.new(1, 1, 1)
    healthText.TextStrokeTransparency = 0.5
    healthText.Font = Enum.Font.GothamBold
    healthText.TextSize = 12
    healthText.Parent = background
end

function NPCManager:UpdateHealthBar(npc, currentHealth, maxHealth)
    local head = npc:FindFirstChild("Head")
    if not head then return end
    
    local healthBarGui = head:FindFirstChild("HealthBar")
    if not healthBarGui then return end
    
    local background = healthBarGui:FindFirstChild("Frame")
    if not background then return end
    
    local bar = background:FindFirstChild("Bar")
    local text = background:FindFirstChild("HealthText")
    
    if bar then
        local percentage = math.max(0, currentHealth / maxHealth)
        bar.Size = UDim2.new(percentage, 0, 1, 0)
        
        if percentage > 0.5 then
            bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif percentage > 0.25 then
            bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        else
            bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
    
    if text then
        text.Text = math.floor(currentHealth) .. "/" .. maxHealth
    end
end

-- ========================================
-- SPAWN NPC
-- ========================================

function NPCManager:SpawnNPC(npcName, position, zone)
    local npcData = NPCData:GetNPCByName(npcName)
    if not npcData then
        warn("[NPCManager] ❌ NPC não encontrado:", npcName)
        return nil
    end
    
    local npcModel = self:CreateNPCModel(npcData)
    npcModel:SetPrimaryPartCFrame(CFrame.new(position))
    
    local npcsFolder = workspace:FindFirstChild("NPCs") or workspace
    npcModel.Parent = npcsFolder
    
    self:CreateHealthBar(npcModel, npcData)
    
    -- Registra NPC
    self.ActiveNPCs[npcModel] = {
        Data = npcData,
        Zone = zone,
        SpawnTime = tick()
    }
    self.NPCHealths[npcModel] = npcData.Health
    
    -- Setup comportamento
    self:SetupNPCBehavior(npcModel, npcData)
    
    print(string.format("[NPCManager] ✅ Spawnou %s em %s", npcName, zone or "Unknown"))
    
    return npcModel
end

-- ========================================
-- COMPORTAMENTO DO NPC
-- ========================================

function NPCManager:SetupNPCBehavior(npc, npcData)
    local humanoid = npc:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Quando NPC morre
    humanoid.Died:Connect(function()
        print(string.format("[NPCManager] 💀 %s morreu", npc.Name))
        self:OnNPCDeath(npc, npcData)
    end)
end

-- ========================================
-- NPC MORTE
-- ========================================

function NPCManager:OnNPCDeath(npc, npcData)
    -- ⭐ CHAMA CALLBACK DO COMBATSYSTEM
    if self.OnNPCDeathCallback then
        print("[NPCManager] ⚡ Acionando callback de morte")
        self.OnNPCDeathCallback(npc, npcData)
    else
        warn("[NPCManager] ⚠️ Callback de morte não configurado!")
    end
    
    -- Cria prompt de captura
    self:CreateCapturePrompt(npc, npcData)
end

-- ========================================
-- PROMPT DE CAPTURA
-- ========================================

function NPCManager:CreateCapturePrompt(npc, npcData)
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local promptPart = Instance.new("Part")
    promptPart.Name = "CapturePrompt"
    promptPart.Size = Vector3.new(4, 1, 4)
    promptPart.Transparency = 0.7
    promptPart.Color = Color3.fromRGB(100, 0, 200)
    promptPart.Material = Enum.Material.Neon
    promptPart.Anchored = true
    promptPart.CanCollide = false
    promptPart.Position = rootPart.Position
    promptPart.Parent = workspace
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 300, 0, 100)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = promptPart
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.3
    frame.Parent = billboardGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "[E] to Arise"
    textLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 18
    textLabel.Parent = frame
    
    local textLabel2 = Instance.new("TextLabel")
    textLabel2.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel2.Position = UDim2.new(0, 0, 0.5, 0)
    textLabel2.BackgroundTransparency = 1
    textLabel2.Text = "[F] to Destroy"
    textLabel2.TextColor3 = Color3.fromRGB(255, 150, 150)
    textLabel2.TextStrokeTransparency = 0.5
    textLabel2.Font = Enum.Font.GothamBold
    textLabel2.TextSize = 18
    textLabel2.Parent = frame
    
    -- Armazena dados
    promptPart:SetAttribute("NPCName", npcData.Name)
    promptPart:SetAttribute("NPCRank", npcData.Rank)
    
    print(string.format("[NPCManager] 📋 Criou prompt para %s", npcData.Name))
    
    -- Remove após 30 segundos
    game:GetService("Debris"):AddItem(promptPart, 30)
    game:GetService("Debris"):AddItem(npc, 31)
end

-- ========================================
-- DANO NO NPC
-- ========================================

function NPCManager:DamageNPC(npc, damage, attacker)
    if not self.ActiveNPCs[npc] then 
        warn("[NPCManager] NPC não encontrado em ActiveNPCs")
        return false 
    end
    
    local currentHealth = self.NPCHealths[npc]
    if not currentHealth then 
        warn("[NPCManager] Vida do NPC não encontrada")
        return false 
    end
    
    local npcData = self.ActiveNPCs[npc].Data
    
    -- Aplica dano com defesa
    local actualDamage = math.max(1, damage - npcData.Defense)
    currentHealth = currentHealth - actualDamage
    self.NPCHealths[npc] = currentHealth
    
    print(string.format("[NPCManager] %s causou %d de dano em %s (HP: %d)", 
        attacker and attacker.Name or "Unknown", actualDamage, npc.Name, currentHealth))
    
    -- Atualiza barra de vida
    self:UpdateHealthBar(npc, currentHealth, npcData.Health)
    
    -- Mostra número de dano
    self:ShowDamageNumber(npc, actualDamage)
    
    -- Verifica se morreu
    if currentHealth <= 0 then
        local humanoid = npc:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
        end
        
        -- ⭐ ARMAZENA O KILLER ANTES DE LIMPAR
        self.ActiveNPCs[npc].Killer = attacker
        
        -- Não limpa aqui - será limpo após callback
    end
    
    return true
end

-- ========================================
-- NÚMERO DE DANO
-- ========================================

function NPCManager:ShowDamageNumber(npc, damage)
    local head = npc:FindFirstChild("Head")
    if not head then return end
    
    local damageLabel = Instance.new("Part")
    damageLabel.Size = Vector3.new(0.1, 0.1, 0.1)
    damageLabel.Transparency = 1
    damageLabel.CanCollide = false
    damageLabel.Anchored = true
    damageLabel.Position = head.Position + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
    damageLabel.Parent = workspace
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = damageLabel
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "-" .. math.floor(damage)
    textLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 24
    textLabel.Parent = billboardGui
    
    -- Anima
    spawn(function()
        for i = 1, 20 do
            damageLabel.Position = damageLabel.Position + Vector3.new(0, 0.1, 0)
            textLabel.TextTransparency = i / 20
            wait(0.05)
        end
        damageLabel:Destroy()
    end)
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

function NPCManager:Init()
    -- Cria pasta para NPCs
    if not workspace:FindFirstChild("NPCs") then
        local npcsFolder = Instance.new("Folder")
        npcsFolder.Name = "NPCs"
        npcsFolder.Parent = workspace
    end
    
    print("[NPCManager] ✅ Inicializado")
end

return NPCManager
