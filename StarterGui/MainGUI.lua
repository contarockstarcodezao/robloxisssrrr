--[[
    MAIN GUI
    Localização: StarterGui/MainGUI.lua
    
    Interface principal do jogo com:
    - Barra de status do jogador
    - Botões de acesso rápido
    - Informações de moedas
    - Sistema de notificações
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGUI"
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

-- Gradiente da barra de status
local statusGradient = Instance.new("UIGradient")
statusGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
statusGradient.Rotation = 90
statusGradient.Parent = statusBar

-- Borda inferior da barra
local statusBorder = Instance.new("Frame")
statusBorder.Name = "StatusBorder"
statusBorder.Size = UDim2.new(1, 0, 0, 2)
statusBorder.Position = UDim2.new(0, 0, 1, -2)
statusBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
statusBorder.BorderSizePixel = 0
statusBorder.Parent = statusBar

-- Informações do jogador (lado esquerdo)
local playerInfoFrame = Instance.new("Frame")
playerInfoFrame.Name = "PlayerInfoFrame"
playerInfoFrame.Size = UDim2.new(0, 300, 1, 0)
playerInfoFrame.Position = UDim2.new(0, 10, 0, 0)
playerInfoFrame.BackgroundTransparency = 1
playerInfoFrame.Parent = statusBar

-- Avatar do jogador
local avatarFrame = Instance.new("Frame")
avatarFrame.Name = "AvatarFrame"
avatarFrame.Size = UDim2.new(0, 60, 0, 60)
avatarFrame.Position = UDim2.new(0, 0, 0.5, -30)
avatarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
avatarFrame.BorderSizePixel = 0
avatarFrame.Parent = playerInfoFrame

-- Borda do avatar
local avatarBorder = Instance.new("Frame")
avatarBorder.Name = "AvatarBorder"
avatarBorder.Size = UDim2.new(1, 4, 1, 4)
avatarBorder.Position = UDim2.new(0, -2, 0, -2)
avatarBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
avatarBorder.BorderSizePixel = 0
avatarBorder.Parent = avatarFrame

-- Imagem do avatar (placeholder)
local avatarImage = Instance.new("ImageLabel")
avatarImage.Name = "AvatarImage"
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.Position = UDim2.new(0, 0, 0, 0)
avatarImage.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
avatarImage.BorderSizePixel = 0
avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
avatarImage.Parent = avatarFrame

-- Informações do jogador
local playerDetailsFrame = Instance.new("Frame")
playerDetailsFrame.Name = "PlayerDetailsFrame"
playerDetailsFrame.Size = UDim2.new(1, -70, 1, 0)
playerDetailsFrame.Position = UDim2.new(0, 70, 0, 0)
playerDetailsFrame.BackgroundTransparency = 1
playerDetailsFrame.Parent = playerInfoFrame

-- Nome do jogador
local playerNameLabel = Instance.new("TextLabel")
playerNameLabel.Name = "PlayerNameLabel"
playerNameLabel.Size = UDim2.new(1, 0, 0, 25)
playerNameLabel.Position = UDim2.new(0, 0, 0, 5)
playerNameLabel.BackgroundTransparency = 1
playerNameLabel.Text = player.Name
playerNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
playerNameLabel.TextScaled = true
playerNameLabel.Font = Enum.Font.SourceSansBold
playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
playerNameLabel.Parent = playerDetailsFrame

-- Nível do jogador
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(0.5, 0, 0, 20)
levelLabel.Position = UDim2.new(0, 0, 0, 30)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Nível: 1"
levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
levelLabel.TextScaled = true
levelLabel.Font = Enum.Font.SourceSans
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = playerDetailsFrame

-- XP do jogador
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
xpLabel.Parent = playerDetailsFrame

-- Barra de XP
local xpBarFrame = Instance.new("Frame")
xpBarFrame.Name = "XPBarFrame"
xpBarFrame.Size = UDim2.new(1, 0, 0, 8)
xpBarFrame.Position = UDim2.new(0, 0, 0, 55)
xpBarFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
xpBarFrame.BorderSizePixel = 0
xpBarFrame.Parent = playerDetailsFrame

local xpBar = Instance.new("Frame")
xpBar.Name = "XPBar"
xpBar.Size = UDim2.new(0, 0, 1, 0)
xpBar.Position = UDim2.new(0, 0, 0, 0)
xpBar.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
xpBar.BorderSizePixel = 0
xpBar.Parent = xpBarFrame

-- Moedas (lado direito)
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

local cashIcon = Instance.new("ImageLabel")
cashIcon.Name = "CashIcon"
cashIcon.Size = UDim2.new(0, 30, 0, 30)
cashIcon.Position = UDim2.new(0, 5, 0.5, -15)
cashIcon.BackgroundTransparency = 1
cashIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
cashIcon.Parent = cashFrame

local cashLabel = Instance.new("TextLabel")
cashLabel.Name = "CashLabel"
cashLabel.Size = UDim2.new(1, -40, 1, 0)
cashLabel.Position = UDim2.new(0, 40, 0, 0)
cashLabel.BackgroundTransparency = 1
cashLabel.Text = "1,000"
cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cashLabel.TextScaled = true
cashLabel.Font = Enum.Font.SourceSansBold
cashLabel.TextXAlignment = Enum.TextXAlignment.Left
cashLabel.Parent = cashFrame

-- Diamantes
local diamondsFrame = Instance.new("Frame")
diamondsFrame.Name = "DiamondsFrame"
diamondsFrame.Size = UDim2.new(1, 0, 0, 35)
diamondsFrame.Position = UDim2.new(0, 0, 0, 40)
diamondsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
diamondsFrame.BorderSizePixel = 0
diamondsFrame.Parent = currencyFrame

local diamondsIcon = Instance.new("ImageLabel")
diamondsIcon.Name = "DiamondsIcon"
diamondsIcon.Size = UDim2.new(0, 30, 0, 30)
diamondsIcon.Position = UDim2.new(0, 5, 0.5, -15)
diamondsIcon.BackgroundTransparency = 1
diamondsIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
diamondsIcon.Parent = diamondsFrame

local diamondsLabel = Instance.new("TextLabel")
diamondsLabel.Name = "DiamondsLabel"
diamondsLabel.Size = UDim2.new(1, -40, 1, 0)
diamondsLabel.Position = UDim2.new(0, 40, 0, 0)
diamondsLabel.BackgroundTransparency = 1
diamondsLabel.Text = "10"
diamondsLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
diamondsLabel.TextScaled = true
diamondsLabel.Font = Enum.Font.SourceSansBold
diamondsLabel.TextXAlignment = Enum.TextXAlignment.Left
diamondsLabel.Parent = diamondsFrame

-- Botões de acesso rápido (centro)
local quickAccessFrame = Instance.new("Frame")
quickAccessFrame.Name = "QuickAccessFrame"
quickAccessFrame.Size = UDim2.new(0, 500, 1, 0)
quickAccessFrame.Position = UDim2.new(0.5, -250, 0, 0)
quickAccessFrame.BackgroundTransparency = 1
quickAccessFrame.Parent = statusBar

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
inventoryButton.Parent = quickAccessFrame

-- Efeito hover do botão
inventoryButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(inventoryButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    tween:Play()
end)

inventoryButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(inventoryButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    tween:Play()
end)

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
shadowButton.Parent = quickAccessFrame

-- Efeito hover do botão
shadowButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(shadowButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    tween:Play()
end)

shadowButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(shadowButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    tween:Play()
end)

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
weaponButton.Parent = quickAccessFrame

-- Efeito hover do botão
weaponButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(weaponButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    tween:Play()
end)

weaponButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(weaponButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    tween:Play()
end)

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
relicButton.Parent = quickAccessFrame

-- Efeito hover do botão
relicButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(relicButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    tween:Play()
end)

relicButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(relicButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    tween:Play()
end)

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
rankingButton.Parent = quickAccessFrame

-- Efeito hover do botão
rankingButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(rankingButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 70)})
    tween:Play()
end)

rankingButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(rankingButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)})
    tween:Play()
end)

-- Sistema de notificações
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 400, 0, 60)
notificationFrame.Position = UDim2.new(1, -420, 0, 100)
notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
notificationFrame.Parent = mainFrame

-- Borda da notificação
local notificationBorder = Instance.new("Frame")
notificationBorder.Name = "NotificationBorder"
notificationBorder.Size = UDim2.new(1, 4, 1, 4)
notificationBorder.Position = UDim2.new(0, -2, 0, -2)
notificationBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notificationBorder.BorderSizePixel = 0
notificationBorder.Parent = notificationFrame

-- Texto da notificação
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

-- Ícone da notificação
local notificationIcon = Instance.new("ImageLabel")
notificationIcon.Name = "NotificationIcon"
notificationIcon.Size = UDim2.new(0, 40, 0, 40)
notificationIcon.Position = UDim2.new(1, -50, 0.5, -20)
notificationIcon.BackgroundTransparency = 1
notificationIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
notificationIcon.Parent = notificationFrame

-- Função para mostrar notificação
local function showNotification(text, icon, duration)
    duration = duration or 3
    
    notificationText.Text = text
    notificationIcon.Image = icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
    notificationFrame.Visible = true
    
    -- Animação de entrada
    notificationFrame.Position = UDim2.new(1, -420, 0, 100)
    local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -420, 0, 100)
    })
    tween:Play()
    
    -- Auto-fechar após duração
    wait(duration)
    
    -- Animação de saída
    local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, 0, 0, 100)
    })
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notificationFrame.Visible = false
    end)
end

-- Conectar eventos dos botões
inventoryButton.MouseButton1Click:Connect(function()
    showNotification("Abrindo inventário...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

shadowButton.MouseButton1Click:Connect(function()
    showNotification("Abrindo sistema de sombras...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

weaponButton.MouseButton1Click:Connect(function()
    showNotification("Abrindo sistema de armas...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

relicButton.MouseButton1Click:Connect(function()
    showNotification("Abrindo sistema de relíquias...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

rankingButton.MouseButton1Click:Connect(function()
    showNotification("Abrindo ranking...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

-- Exportar função de notificação
_G.showNotification = showNotification

print("✅ MainGUI carregada com sucesso!")