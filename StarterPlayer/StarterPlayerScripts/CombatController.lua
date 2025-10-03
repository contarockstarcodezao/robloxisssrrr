--[[
    COMBAT CONTROLLER - Controlador de Combate Cliente
    Sistema de detecção de clique e efeitos visuais
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

print("🎮 === COMBAT CONTROLLER INICIADO ===")

-- Aguardar eventos
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local attackEvent = eventsFolder:WaitForChild("AttackNPC")
local npcDiedEvent = eventsFolder:WaitForChild("NPCDied")
local updateHUDEvent = eventsFolder:WaitForChild("UpdateHUD")

-- Sistema de combate cliente
local CombatController = {}

-- Função para detectar clique em NPC
local function onMouseClick()
    local target = mouse.Target
    if not target then return end
    
    local npc = target.Parent
    if not npc then return end
    
    -- Verificar se é um NPC
    local humanoid = npc:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    -- Verificar se tem dados de NPC
    local npcData = npc:GetAttribute("IsNPC")
    if not npcData then return end
    
    -- Enviar evento de ataque
    attackEvent:FireServer(npc)
    
    -- Criar efeito de clique
    CombatController:CreateClickEffect(target.Position)
    
    print("🎯 Atacando NPC:", npc.Name)
end

-- Função para criar efeito de clique
function CombatController:CreateClickEffect(position)
    -- Criar partícula de clique
    local attachment = Instance.new("Attachment")
    attachment.Parent = workspace.Terrain
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/fire_main.dds"
    particles.Lifetime = NumberRange.new(0.5, 1.0)
    particles.Rate = 50
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.Speed = NumberRange.new(5, 10)
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0))
    
    -- Posicionar attachment
    attachment.WorldPosition = position
    
    -- Limpar partículas
    game:GetService("Debris"):AddItem(particles, 1)
    game:GetService("Debris"):AddItem(attachment, 1)
end

-- Função para criar efeito de morte
function CombatController:CreateDeathEffect(npcName, position)
    -- Criar explosão visual
    local explosion = Instance.new("Explosion")
    explosion.Position = position
    explosion.BlastRadius = 0
    explosion.BlastPressure = 0
    explosion.Parent = workspace
    
    -- Criar partículas de morte
    local attachment = Instance.new("Attachment")
    attachment.Parent = workspace.Terrain
    
    local particles = Instance.new("ParticleEmitter")
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/smoke_main.dds"
    particles.Lifetime = NumberRange.new(1.0, 2.0)
    particles.Rate = 100
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.Speed = NumberRange.new(10, 20)
    particles.Color = ColorSequence.new(Color3.fromRGB(100, 100, 100))
    
    -- Posicionar attachment
    attachment.WorldPosition = position
    
    -- Limpar partículas
    game:GetService("Debris"):AddItem(particles, 3)
    game:GetService("Debris"):AddItem(attachment, 3)
    
    print("💀 NPC morreu:", npcName)
end

-- Função para atualizar HUD
function CombatController:UpdateHUD(dataType, data)
    if dataType == "Combat" then
        print("📊 HUD atualizado:", data.Target, "Dano:", data.Damage, "Vida:", data.Health)
        
        -- Aqui você atualizaria a interface do jogador
        -- Por exemplo, mostrar dano causado, vida restante do NPC, etc.
    end
end

-- Função para criar cursor personalizado
function CombatController:CreateCustomCursor()
    local cursorGui = Instance.new("ScreenGui")
    cursorGui.Name = "CursorGui"
    cursorGui.ResetOnSpawn = false
    cursorGui.Parent = player.PlayerGui
    
    local cursorFrame = Instance.new("Frame")
    cursorFrame.Name = "CursorFrame"
    cursorFrame.Size = UDim2.new(0, 20, 0, 20)
    cursorFrame.Position = UDim2.new(0, 0, 0, 0)
    cursorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    cursorFrame.BorderSizePixel = 0
    cursorFrame.Parent = cursorGui
    
    -- Criar círculo
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = cursorFrame
    
    -- Animação do cursor
    local tween = TweenService:Create(cursorFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.new(0, 25, 0, 25)
    })
    tween:Play()
    
    -- Atualizar posição do cursor
    local connection
    connection = mouse.Move:Connect(function()
        cursorFrame.Position = UDim2.new(0, mouse.X - 10, 0, mouse.Y - 10)
    end)
    
    -- Limpar conexão quando o jogador sair
    player.AncestryChanged:Connect(function()
        connection:Disconnect()
    end)
end

-- Função para criar sistema de mira
function CombatController:CreateAimSystem()
    local aimGui = Instance.new("ScreenGui")
    aimGui.Name = "AimGui"
    aimGui.ResetOnSpawn = false
    aimGui.Parent = player.PlayerGui
    
    local aimFrame = Instance.new("Frame")
    aimFrame.Name = "AimFrame"
    aimFrame.Size = UDim2.new(0, 100, 0, 100)
    aimFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
    aimFrame.BackgroundTransparency = 1
    aimFrame.Parent = aimGui
    
    -- Círculo de mira
    local aimCircle = Instance.new("Frame")
    aimCircle.Name = "AimCircle"
    aimCircle.Size = UDim2.new(1, 0, 1, 0)
    aimCircle.BackgroundTransparency = 1
    aimCircle.Parent = aimFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0.5, 0)
    corner.Parent = aimCircle
    
    -- Borda da mira
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.Parent = aimCircle
    
    local borderCorner = Instance.new("UICorner")
    borderCorner.CornerRadius = UDim.new(0.5, 0)
    borderCorner.Parent = border
    
    -- Linha da mira
    local aimLine = Instance.new("Frame")
    aimLine.Name = "AimLine"
    aimLine.Size = UDim2.new(0, 2, 1, 0)
    aimLine.Position = UDim2.new(0.5, -1, 0, 0)
    aimLine.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    aimLine.BorderSizePixel = 0
    aimLine.Parent = aimFrame
    
    local aimLine2 = Instance.new("Frame")
    aimLine2.Name = "AimLine2"
    aimLine2.Size = UDim2.new(1, 0, 0, 2)
    aimLine2.Position = UDim2.new(0, 0, 0.5, -1)
    aimLine2.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    aimLine2.BorderSizePixel = 0
    aimLine2.Parent = aimFrame
    
    -- Animação da mira
    local tween = TweenService:Create(aimCircle, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
        Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.1, 0, 0.1, 0)
    })
    tween:Play()
end

-- Função para criar sistema de sombras
function CombatController:CreateShadowSystem()
    local shadowGui = Instance.new("ScreenGui")
    shadowGui.Name = "ShadowGui"
    shadowGui.ResetOnSpawn = false
    shadowGui.Parent = player.PlayerGui
    
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "ShadowFrame"
    shadowFrame.Size = UDim2.new(0, 200, 0, 100)
    shadowFrame.Position = UDim2.new(0, 10, 1, -110)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    shadowFrame.BorderSizePixel = 0
    shadowFrame.Parent = shadowGui
    
    -- Borda
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    border.BorderSizePixel = 0
    border.Parent = shadowFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "👻 SOMBRAS ATIVAS"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = shadowFrame
    
    -- Lista de sombras
    local shadowList = Instance.new("ScrollingFrame")
    shadowList.Name = "ShadowList"
    shadowList.Size = UDim2.new(1, -10, 1, -40)
    shadowList.Position = UDim2.new(0, 5, 0, 35)
    shadowList.BackgroundTransparency = 1
    shadowList.BorderSizePixel = 0
    shadowList.ScrollBarThickness = 5
    shadowList.CanvasSize = UDim2.new(0, 0, 0, 0)
    shadowList.Parent = shadowFrame
    
    -- Layout da lista
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 2)
    listLayout.Parent = shadowList
    
    -- Função para adicionar sombra
    local function addShadow(shadowName, shadowLevel)
        local shadowItem = Instance.new("Frame")
        shadowItem.Name = shadowName
        shadowItem.Size = UDim2.new(1, 0, 0, 25)
        shadowItem.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        shadowItem.BorderSizePixel = 0
        shadowItem.Parent = shadowList
        
        local shadowLabel = Instance.new("TextLabel")
        shadowLabel.Name = "ShadowLabel"
        shadowLabel.Size = UDim2.new(1, 0, 1, 0)
        shadowLabel.BackgroundTransparency = 1
        shadowLabel.Text = shadowName .. " (Nível " .. shadowLevel .. ")"
        shadowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        shadowLabel.TextScaled = true
        shadowLabel.Font = Enum.Font.SourceSans
        shadowLabel.TextXAlignment = Enum.TextXAlignment.Left
        shadowLabel.Parent = shadowItem
        
        -- Atualizar tamanho do canvas
        shadowList.CanvasSize = UDim2.new(0, 0, 0, #shadowList:GetChildren() * 27)
    end
    
    -- Adicionar sombras de exemplo
    addShadow("Shadow Wolf", 5)
    addShadow("Shadow Bear", 8)
    addShadow("Shadow Tiger", 12)
end

-- Conectar eventos
mouse.Button1Down:Connect(onMouseClick)
npcDiedEvent.OnClientEvent:Connect(CombatController.CreateDeathEffect)
updateHUDEvent.OnClientEvent:Connect(CombatController.UpdateHUD)

-- Inicializar sistemas
spawn(function()
    wait(1)
    CombatController:CreateCustomCursor()
    CombatController:CreateAimSystem()
    CombatController:CreateShadowSystem()
end)

print("✅ CombatController carregado com sucesso!")