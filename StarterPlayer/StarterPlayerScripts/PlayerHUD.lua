--[[
    PLAYER HUD - Interface do Jogador
    Sistema completo de HUD com dados em tempo real
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

print("🎮 === PLAYER HUD INICIADO ===")

-- Aguardar eventos
local eventsFolder = ReplicatedStorage:WaitForChild("Events")
local dataLoadedEvent = eventsFolder:WaitForChild("DataLoaded")
local dataUpdatedEvent = eventsFolder:WaitForChild("DataUpdated")
local getPlayerDataFunction = eventsFolder:WaitForChild("GetPlayerData")
local getShadowsFunction = eventsFolder:WaitForChild("GetShadows")
local getEquippedShadowsFunction = eventsFolder:WaitForChild("GetEquippedShadows")

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

-- Barra de status superior
local statusBar = Instance.new("Frame")
statusBar.Name = "StatusBar"
statusBar.Size = UDim2.new(1, 0, 0, 80)
statusBar.Position = UDim2.new(0, 0, 0, 0)
statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusBar.BorderSizePixel = 0
statusBar.Parent = mainFrame

-- Gradiente da barra
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Rotation = 90
gradient.Parent = statusBar

-- Borda inferior
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 0, 0, 2)
border.Position = UDim2.new(0, 0, 1, -2)
border.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
border.BorderSizePixel = 0
border.Parent = statusBar

-- Informações do jogador (esquerda)
local playerInfo = Instance.new("Frame")
playerInfo.Name = "PlayerInfo"
playerInfo.Size = UDim2.new(0, 300, 1, 0)
playerInfo.Position = UDim2.new(0, 10, 0, 0)
playerInfo.BackgroundTransparency = 1
playerInfo.Parent = statusBar

-- Avatar
local avatar = Instance.new("Frame")
avatar.Name = "Avatar"
avatar.Size = UDim2.new(0, 60, 0, 60)
avatar.Position = UDim2.new(0, 0, 0.5, -30)
avatar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
avatar.BorderSizePixel = 0
avatar.Parent = playerInfo

-- Borda do avatar
local avatarBorder = Instance.new("Frame")
avatarBorder.Name = "AvatarBorder"
avatarBorder.Size = UDim2.new(1, 4, 1, 4)
avatarBorder.Position = UDim2.new(0, -2, 0, -2)
avatarBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
avatarBorder.BorderSizePixel = 0
avatarBorder.Parent = avatar

-- Nome do jogador
local playerName = Instance.new("TextLabel")
playerName.Name = "PlayerName"
playerName.Size = UDim2.new(1, -70, 0, 25)
playerName.Position = UDim2.new(0, 70, 0, 5)
playerName.BackgroundTransparency = 1
playerName.Text = player.Name
playerName.TextColor3 = Color3.fromRGB(255, 255, 255)
playerName.TextScaled = true
playerName.Font = Enum.Font.SourceSansBold
playerName.TextXAlignment = Enum.TextXAlignment.Left
playerName.Parent = playerInfo

-- Nível
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(0.5, 0, 0, 20)
levelLabel.Position = UDim2.new(0, 70, 0, 30)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Nível: 1"
levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.SourceSans
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = playerInfo

-- XP
local xpLabel = Instance.new("TextLabel")
xpLabel.Name = "XPLabel"
xpLabel.Size = UDim2.new(0.5, 0, 0, 20)
xpLabel.Position = UDim2.new(0.5, 0, 0, 30)
xpLabel.BackgroundTransparency = 1
xpLabel.Text = "XP: 0/100"
xpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
xpLabel.TextScaled = true
xpLabel.Font = Enum.Font.SourceSans
xpLabel.TextXAlignment = Enum.TextXAlignment.Left
xpLabel.Parent = playerInfo

-- Barra de XP
local xpBarFrame = Instance.new("Frame")
xpBarFrame.Name = "XPBarFrame"
xpBarFrame.Size = UDim2.new(1, -70, 0, 8)
xpBarFrame.Position = UDim2.new(0, 70, 0, 55)
xpBarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
xpBarFrame.BorderSizePixel = 0
xpBarFrame.Parent = playerInfo

local xpBar = Instance.new("Frame")
xpBar.Name = "XPBar"
xpBar.Size = UDim2.new(0, 0, 1, 0)
xpBar.Position = UDim2.new(0, 0, 0, 0)
xpBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
xpBar.BorderSizePixel = 0
xpBar.Parent = xpBarFrame

-- Moedas (direita)
local currencyFrame = Instance.new("Frame")
currencyFrame.Name = "CurrencyFrame"
currencyFrame.Size = UDim2.new(0, 200, 1, 0)
currencyFrame.Position = UDim2.new(1, -210, 0, 0)
currencyFrame.BackgroundTransparency = 1
currencyFrame.Parent = statusBar

-- Cash
local cashFrame = Instance.new("Frame")
cashFrame.Name = "CashFrame"
cashFrame.Size = UDim2.new(1, 0, 0, 35)
cashFrame.Position = UDim2.new(0, 0, 0, 5)
cashFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cashFrame.BorderSizePixel = 0
cashFrame.Parent = currencyFrame

local cashLabel = Instance.new("TextLabel")
cashLabel.Name = "CashLabel"
cashLabel.Size = UDim2.new(1, 0, 1, 0)
cashLabel.Position = UDim2.new(0, 0, 0, 0)
cashLabel.BackgroundTransparency = 1
cashLabel.Text = "💰 Cash: 1,000"
cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cashLabel.TextScaled = true
cashLabel.Font = Enum.Font.SourceSansBold
cashLabel.Parent = cashFrame

-- Diamantes
local diamondsFrame = Instance.new("Frame")
diamondsFrame.Name = "DiamondsFrame"
diamondsFrame.Size = UDim2.new(1, 0, 0, 35)
diamondsFrame.Position = UDim2.new(0, 0, 0, 40)
diamondsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
diamondsFrame.BorderSizePixel = 0
diamondsFrame.Parent = currencyFrame

local diamondsLabel = Instance.new("TextLabel")
diamondsLabel.Name = "DiamondsLabel"
diamondsLabel.Size = UDim2.new(1, 0, 1, 0)
diamondsLabel.Position = UDim2.new(0, 0, 0, 0)
diamondsLabel.BackgroundTransparency = 1
diamondsLabel.Text = "💎 Diamantes: 10"
diamondsLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
diamondsLabel.TextScaled = true
diamondsLabel.Font = Enum.Font.SourceSansBold
diamondsLabel.Parent = diamondsFrame

-- Sistema de sombras (inferior esquerdo)
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "ShadowFrame"
shadowFrame.Size = UDim2.new(0, 300, 0, 120)
shadowFrame.Position = UDim2.new(0, 10, 1, -130)
shadowFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
shadowFrame.BorderSizePixel = 0
shadowFrame.Parent = mainFrame

-- Borda do frame de sombras
local shadowBorder = Instance.new("Frame")
shadowBorder.Name = "ShadowBorder"
shadowBorder.Size = UDim2.new(1, 4, 1, 4)
shadowBorder.Position = UDim2.new(0, -2, 0, -2)
shadowBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
shadowBorder.BorderSizePixel = 0
shadowBorder.Parent = shadowFrame

-- Título das sombras
local shadowTitle = Instance.new("TextLabel")
shadowTitle.Name = "ShadowTitle"
shadowTitle.Size = UDim2.new(1, 0, 0, 30)
shadowTitle.Position = UDim2.new(0, 0, 0, 0)
shadowTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
shadowTitle.BorderSizePixel = 0
shadowTitle.Text = "👻 SOMBRAS EQUIPADAS"
shadowTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
shadowTitle.TextScaled = true
shadowTitle.Font = Enum.Font.SourceSansBold
shadowTitle.Parent = shadowFrame

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

-- Layout da lista de sombras
local shadowLayout = Instance.new("UIListLayout")
shadowLayout.SortOrder = Enum.SortOrder.LayoutOrder
shadowLayout.Padding = UDim.new(0, 2)
shadowLayout.Parent = shadowList

-- Sistema de notificações
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 400, 0, 60)
notificationFrame.Position = UDim2.new(1, -420, 0, 100)
notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
notificationFrame.Parent = mainFrame

local notificationBorder = Instance.new("Frame")
notificationBorder.Name = "NotificationBorder"
notificationBorder.Size = UDim2.new(1, 4, 1, 4)
notificationBorder.Position = UDim2.new(0, -2, 0, -2)
notificationBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notificationBorder.BorderSizePixel = 0
notificationBorder.Parent = notificationFrame

local notificationText = Instance.new("TextLabel")
notificationText.Name = "NotificationText"
notificationText.Size = UDim2.new(1, -20, 1, 0)
notificationText.Position = UDim2.new(0, 10, 0, 0)
notificationText.BackgroundTransparency = 1
notificationText.Text = "Notificação de teste"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.TextScaled = true
notificationText.Font = Enum.Font.SourceSansBold
notificationText.TextXAlignment = Enum.TextXAlignment.Left
notificationText.Parent = notificationFrame

-- Função para mostrar notificação
local function showNotification(text, duration)
    duration = duration or 3
    
    notificationText.Text = text
    notificationFrame.Visible = true
    
    -- Animação de entrada
    notificationFrame.Position = UDim2.new(1, -420, 0, 100)
    local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -420, 0, 100)
    })
    tween:Play()
    
    -- Auto-fechar
    spawn(function()
        wait(duration)
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, 0, 100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notificationFrame.Visible = false
        end)
    end)
end

-- Função para atualizar HUD
local function updateHUD(data)
    if not data then return end
    
    -- Atualizar informações básicas
    levelLabel.Text = "Nível: " .. (data.Level or 1)
    xpLabel.Text = "XP: " .. (data.XP or 0) .. "/" .. (data.MaxXP or 100)
    cashLabel.Text = "💰 Cash: " .. (data.Cash or 0)
    diamondsLabel.Text = "💎 Diamantes: " .. (data.Diamonds or 0)
    
    -- Atualizar barra de XP
    local xpPercentage = (data.XP or 0) / (data.MaxXP or 100)
    xpBar.Size = UDim2.new(xpPercentage, 0, 1, 0)
    
    -- Atualizar sombras equipadas
    updateEquippedShadows(data.EquippedShadows or {})
    
    print("📊 HUD atualizado para:", player.Name)
end

-- Função para atualizar sombras equipadas
local function updateEquippedShadows(equippedShadows)
    -- Limpar lista atual
    for _, child in ipairs(shadowList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Adicionar sombras equipadas
    for _, shadowId in ipairs(equippedShadows) do
        local shadowItem = Instance.new("Frame")
        shadowItem.Name = "ShadowItem_" .. shadowId
        shadowItem.Size = UDim2.new(1, 0, 0, 25)
        shadowItem.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        shadowItem.BorderSizePixel = 0
        shadowItem.Parent = shadowList
        
        local shadowLabel = Instance.new("TextLabel")
        shadowLabel.Name = "ShadowLabel"
        shadowLabel.Size = UDim2.new(1, 0, 1, 0)
        shadowLabel.BackgroundTransparency = 1
        shadowLabel.Text = "Sombra ID: " .. shadowId
        shadowLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        shadowLabel.TextScaled = true
        shadowLabel.Font = Enum.Font.SourceSans
        shadowLabel.TextXAlignment = Enum.TextXAlignment.Left
        shadowLabel.Parent = shadowItem
    end
    
    -- Atualizar tamanho do canvas
    shadowList.CanvasSize = UDim2.new(0, 0, 0, #equippedShadows * 27)
end

-- Função para atualizar dados específicos
local function updateData(key, value)
    if key == "Level" then
        levelLabel.Text = "Nível: " .. value
    elseif key == "XP" then
        xpLabel.Text = "XP: " .. value .. "/" .. (getPlayerDataFunction:InvokeServer("MaxXP") or 100)
        local xpPercentage = value / (getPlayerDataFunction:InvokeServer("MaxXP") or 100)
        xpBar.Size = UDim2.new(xpPercentage, 0, 1, 0)
    elseif key == "Cash" then
        cashLabel.Text = "💰 Cash: " .. value
    elseif key == "Diamonds" then
        diamondsLabel.Text = "💎 Diamantes: " .. value
    elseif key == "EquippedShadows" then
        updateEquippedShadows(value)
    end
end

-- Conectar eventos
dataLoadedEvent.OnClientEvent:Connect(function(data)
    updateHUD(data)
    showNotification("🎮 Dados carregados com sucesso!", 3)
end)

dataUpdatedEvent.OnClientEvent:Connect(function(key, value)
    updateData(key, value)
end)

-- Sistema de atalhos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I then
        showNotification("📦 Inventário em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.S then
        showNotification("👻 Sistema de sombras em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.W then
        showNotification("⚔️ Sistema de armas em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.R then
        showNotification("💎 Sistema de relíquias em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.D then
        showNotification("🏰 Sistema de dungeons em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.L then
        showNotification("🏆 Sistema de ranking em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.F1 then
        showNotification("❓ Ajuda: Use as teclas I, S, W, R, D, L", 5)
    end
end)

-- Mostrar notificação de boas-vindas
spawn(function()
    wait(2)
    showNotification("🎮 Bem-vindo ao Anime Fighters Simulator!", 5)
end)

print("✅ PlayerHUD carregado com sucesso!")