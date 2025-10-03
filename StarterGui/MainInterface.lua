--[[
    MAIN INTERFACE - Interface Principal
    Framework completo e funcional para Arise Crossover
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🎮 Criando interface principal...")

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainInterface"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

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

-- Botões de acesso rápido (centro)
local buttonFrame = Instance.new("Frame")
buttonFrame.Name = "ButtonFrame"
buttonFrame.Size = UDim2.new(0, 500, 1, 0)
buttonFrame.Position = UDim2.new(0.5, -250, 0, 0)
buttonFrame.BackgroundTransparency = 1
buttonFrame.Parent = statusBar

-- Botão de inventário
local inventoryButton = Instance.new("TextButton")
inventoryButton.Name = "InventoryButton"
inventoryButton.Size = UDim2.new(0, 80, 0, 50)
inventoryButton.Position = UDim2.new(0, 0, 0.5, -25)
inventoryButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inventoryButton.BorderSizePixel = 0
inventoryButton.Text = "📦\nInventário"
inventoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inventoryButton.TextScaled = true
inventoryButton.Font = Enum.Font.SourceSansBold
inventoryButton.Parent = buttonFrame

-- Botão de sombras
local shadowButton = Instance.new("TextButton")
shadowButton.Name = "ShadowButton"
shadowButton.Size = UDim2.new(0, 80, 0, 50)
shadowButton.Position = UDim2.new(0, 90, 0.5, -25)
shadowButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shadowButton.BorderSizePixel = 0
shadowButton.Text = "👻\nSombras"
shadowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shadowButton.TextScaled = true
shadowButton.Font = Enum.Font.SourceSansBold
shadowButton.Parent = buttonFrame

-- Botão de armas
local weaponButton = Instance.new("TextButton")
weaponButton.Name = "WeaponButton"
weaponButton.Size = UDim2.new(0, 80, 0, 50)
weaponButton.Position = UDim2.new(0, 180, 0.5, -25)
weaponButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
weaponButton.BorderSizePixel = 0
weaponButton.Text = "⚔️\nArmas"
weaponButton.TextColor3 = Color3.fromRGB(255, 255, 255)
weaponButton.TextScaled = true
weaponButton.Font = Enum.Font.SourceSansBold
weaponButton.Parent = buttonFrame

-- Botão de relíquias
local relicButton = Instance.new("TextButton")
relicButton.Name = "RelicButton"
relicButton.Size = UDim2.new(0, 80, 0, 50)
relicButton.Position = UDim2.new(0, 270, 0.5, -25)
relicButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
relicButton.BorderSizePixel = 0
relicButton.Text = "💎\nRelíquias"
relicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
relicButton.TextScaled = true
relicButton.Font = Enum.Font.SourceSansBold
relicButton.Parent = buttonFrame

-- Botão de ranking
local rankingButton = Instance.new("TextButton")
rankingButton.Name = "RankingButton"
rankingButton.Size = UDim2.new(0, 80, 0, 50)
rankingButton.Position = UDim2.new(0, 360, 0.5, -25)
rankingButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rankingButton.BorderSizePixel = 0
rankingButton.Text = "🏆\nRanking"
rankingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rankingButton.TextScaled = true
rankingButton.Font = Enum.Font.SourceSansBold
rankingButton.Parent = buttonFrame

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

-- Função para atualizar interface
local function updateInterface()
    -- Aguardar dados do servidor
    wait(1)
    
    -- Simular dados (em um jogo real, estes viriam do servidor)
    local level = 1
    local xp = 0
    local maxXP = 100
    local cash = 1000
    local diamonds = 10
    
    -- Atualizar labels
    levelLabel.Text = "Nível: " .. level
    xpLabel.Text = "XP: " .. xp .. "/" .. maxXP
    cashLabel.Text = "💰 Cash: " .. cash
    diamondsLabel.Text = "💎 Diamantes: " .. diamonds
    
    -- Atualizar barra de XP
    local xpPercentage = xp / maxXP
    xpBar.Size = UDim2.new(xpPercentage, 0, 1, 0)
end

-- Efeitos hover dos botões
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor})
        tween:Play()
    end)
end

-- Aplicar efeitos hover
addHoverEffect(inventoryButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(shadowButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(weaponButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(relicButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))
addHoverEffect(rankingButton, Color3.fromRGB(50, 50, 50), Color3.fromRGB(70, 70, 70))

-- Conectar eventos dos botões
inventoryButton.MouseButton1Click:Connect(function()
    showNotification("📦 Abrindo inventário...", 2)
end)

shadowButton.MouseButton1Click:Connect(function()
    showNotification("👻 Abrindo sistema de sombras...", 2)
end)

weaponButton.MouseButton1Click:Connect(function()
    showNotification("⚔️ Abrindo sistema de armas...", 2)
end)

relicButton.MouseButton1Click:Connect(function()
    showNotification("💎 Abrindo sistema de relíquias...", 2)
end)

rankingButton.MouseButton1Click:Connect(function()
    showNotification("🏆 Abrindo ranking...", 2)
end)

-- Atalhos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I then
        showNotification("⌨️ Atalho: Inventário (I)", 2)
    elseif input.KeyCode == Enum.KeyCode.S then
        showNotification("⌨️ Atalho: Sombras (S)", 2)
    elseif input.KeyCode == Enum.KeyCode.W then
        showNotification("⌨️ Atalho: Armas (W)", 2)
    elseif input.KeyCode == Enum.KeyCode.R then
        showNotification("⌨️ Atalho: Relíquias (R)", 2)
    elseif input.KeyCode == Enum.KeyCode.L then
        showNotification("⌨️ Atalho: Ranking (L)", 2)
    elseif input.KeyCode == Enum.KeyCode.F1 then
        showNotification("❓ Ajuda: Use as teclas I, S, W, R, L", 3)
    end
end)

-- Conectar eventos do servidor
local function connectServerEvents()
    local eventsFolder = ReplicatedStorage:WaitForChild("Events")
    if eventsFolder then
        local playerDataEvent = eventsFolder:WaitForChild("PlayerDataUpdated")
        if playerDataEvent then
            playerDataEvent.OnClientEvent:Connect(function(dataType, value, extra)
                if dataType == "Notification" then
                    showNotification(value, extra or 3)
                elseif dataType == "Level" then
                    levelLabel.Text = "Nível: " .. value
                elseif dataType == "XP" then
                    xpLabel.Text = "XP: " .. value .. "/" .. (extra or 100)
                elseif dataType == "Cash" then
                    cashLabel.Text = "💰 Cash: " .. value
                elseif dataType == "Diamonds" then
                    diamondsLabel.Text = "💎 Diamantes: " .. value
                end
            end)
        end
    end
end

-- Inicializar
spawn(function()
    wait(1)
    updateInterface()
    connectServerEvents()
    showNotification("🎮 Bem-vindo ao Arise Crossover!", 5)
end)

print("✅ MainInterface criada com sucesso!")