--[[
    NPCManager.lua
    Gerencia spawn, comportamento e vida dos NPCs
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local NPCData = require(ReplicatedStorage.Modules.NPCData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local NPCManager = {}
NPCManager.ActiveNPCs = {} -- {NPC Instance -> Data}
NPCManager.NPCHealths = {} -- {NPC Instance -> Current Health}

-- Cria modelo base de NPC
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
    
    -- Weld cabeça ao corpo
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = torso
    weld.Part1 = head
    weld.Parent = torso
    
    head.Position = torso.Position + Vector3.new(0, 2.25, 0)
    
    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = npcData.Health
    humanoid.Health = npcData.Health
    humanoid.WalkSpeed = 0 -- NPCs ficam parados
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
    rankLabel.TextColor3 = require(ReplicatedStorage.Modules.RankData):GetRankByName(npcData.Rank).Color
    rankLabel.TextStrokeTransparency = 0.5
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.TextSize = 14
    rankLabel.Parent = billboardGui
    
    model.PrimaryPart = torso
    
    return model
end

-- Cria barra de vida
function NPCManager:CreateHealthBar(npc, npcData)
    local head = npc:FindFirstChild("Head")
    if not head then return end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "HealthBar"
    billboardGui.Size = UDim2.new(0, 200, 0, 20)
    billboardGui.StudsOffset = Vector3.new(0, 4, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = head
    
    -- Background
    local background = Instance.new("Frame")
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    background.BorderSizePixel = 2
    background.BorderColor3 = Color3.new(0, 0, 0)
    background.Parent = billboardGui
    
    -- Health bar
    local healthBar = Instance.new("Frame")
    healthBar.Name = "Bar"
    healthBar.Size = UDim2.new(1, 0, 1, 0)
    healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = background
    
    -- Health text
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

-- Atualiza barra de vida
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
        
        -- Muda cor baseado na vida
        if percentage > 0.5 then
            bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Verde
        elseif percentage > 0.25 then
            bar.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- Amarelo
        else
            bar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Vermelho
        end
    end
    
    if text then
        text.Text = math.floor(currentHealth) .. "/" .. maxHealth
    end
end

-- Spawna NPC em uma posição
function NPCManager:SpawnNPC(npcName, position, zone)
    local npcData = NPCData:GetNPCByName(npcName)
    if not npcData then
        warn("[NPCManager] NPC não encontrado:", npcName)
        return nil
    end
    
    local npcModel = self:CreateNPCModel(npcData)
    npcModel:SetPrimaryPartCFrame(CFrame.new(position))
    npcModel.Parent = workspace:FindFirstChild("NPCs") or workspace
    
    -- Cria barra de vida
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
    
    return npcModel
end

-- Configura comportamento do NPC
function NPCManager:SetupNPCBehavior(npc, npcData)
    local humanoid = npc:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Quando NPC morre
    humanoid.Died:Connect(function()
        self:OnNPCDeath(npc, npcData)
    end)
    
    -- NPC fica parado, mas pode rotacionar para o atacante
    -- (Implementação básica - pode ser expandida)
end

-- Quando NPC morre
function NPCManager:OnNPCDeath(npc, npcData)
    -- Notifica que NPC morreu
    RemoteEvents.NPCDied:FireAllClients(npc, npcData)
    
    -- Cria prompt de captura de sombra
    self:CreateCapturePrompt(npc, npcData)
end

-- Cria prompt de captura/destruição
function NPCManager:CreateCapturePrompt(npc, npcData)
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    -- Cria objeto de prompt
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
    
    -- Billboard com instruções
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
    
    -- Remove após 30 segundos
    game:GetService("Debris"):AddItem(promptPart, 30)
    game:GetService("Debris"):AddItem(npc, 31)
end

-- Aplica dano ao NPC
function NPCManager:DamageNPC(npc, damage, attacker)
    if not self.ActiveNPCs[npc] then return false end
    
    local currentHealth = self.NPCHealths[npc]
    if not currentHealth then return false end
    
    local npcData = self.ActiveNPCs[npc].Data
    
    -- Aplica dano com defesa
    local actualDamage = math.max(1, damage - npcData.Defense)
    currentHealth = currentHealth - actualDamage
    self.NPCHealths[npc] = currentHealth
    
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
        
        -- Limpa registros
        self.ActiveNPCs[npc] = nil
        self.NPCHealths[npc] = nil
    end
    
    return true
end

-- Mostra número de dano
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
    
    -- Anima para cima
    spawn(function()
        for i = 1, 20 do
            damageLabel.Position = damageLabel.Position + Vector3.new(0, 0.1, 0)
            textLabel.TextTransparency = i / 20
            wait(0.05)
        end
        damageLabel:Destroy()
    end)
end

-- Spawna NPCs em uma zona
function NPCManager:SpawnNPCsInZone(zoneName, spawnPoints, npcList)
    for i, spawnPoint in ipairs(spawnPoints) do
        local npcData = npcList[math.random(1, #npcList)]
        if npcData then
            self:SpawnNPC(npcData.Name, spawnPoint, zoneName)
        end
    end
end

-- Inicialização
function NPCManager:Init()
    -- Cria pasta para NPCs
    if not workspace:FindFirstChild("NPCs") then
        local npcsFolder = Instance.new("Folder")
        npcsFolder.Name = "NPCs"
        npcsFolder.Parent = workspace
    end
    
    print("[NPCManager] Inicializado com sucesso!")
end

return NPCManager
