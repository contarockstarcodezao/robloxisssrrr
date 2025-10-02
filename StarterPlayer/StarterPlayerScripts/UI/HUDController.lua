--[[
    HUDController.lua
    Controla o HUD principal do jogador
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local RankData = require(ReplicatedStorage.Modules.RankData)

local HUDController = {}
HUDController.PlayerData = nil

-- Cria HUD principal
function HUDController:CreateHUD()
    -- Remove HUD antigo
    local oldHUD = player.PlayerGui:FindFirstChild("MainHUD")
    if oldHUD then
        oldHUD:Destroy()
    end
    
    -- Cria ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainHUD"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    -- Frame principal (canto superior esquerdo)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 200)
    mainFrame.Position = UDim2.new(0, 20, 0, 20)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Arredonda cantos
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    -- Avatar do jogador (placeholder)
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "Avatar"
    avatarFrame.Size = UDim2.new(0, 80, 0, 80)
    avatarFrame.Position = UDim2.new(0, 15, 0, 15)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    avatarFrame.Parent = mainFrame
    
    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 10)
    avatarCorner.Parent = avatarFrame
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(0, 240, 0, 30)
    nameLabel.Position = UDim2.new(0, 105, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 20
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = mainFrame
    
    -- Rank do jogador
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "Rank"
    rankLabel.Size = UDim2.new(0, 240, 0, 25)
    rankLabel.Position = UDim2.new(0, 105, 0, 45)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "Rank: F"
    rankLabel.TextColor3 = RankData:GetRankByName("F").Color
    rankLabel.TextStrokeTransparency = 0.5
    rankLabel.Font = Enum.Font.GothamBold
    rankLabel.TextSize = 18
    rankLabel.TextXAlignment = Enum.TextXAlignment.Left
    rankLabel.Parent = mainFrame
    
    -- Level
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "Level"
    levelLabel.Size = UDim2.new(0, 240, 0, 25)
    levelLabel.Position = UDim2.new(0, 105, 0, 70)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level: 1"
    levelLabel.TextColor3 = Color3.new(1, 1, 1)
    levelLabel.TextStrokeTransparency = 0.5
    levelLabel.Font = Enum.Font.Gotham
    levelLabel.TextSize = 16
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = mainFrame
    
    -- Barra de XP
    local xpBarBg = Instance.new("Frame")
    xpBarBg.Name = "XPBarBg"
    xpBarBg.Size = UDim2.new(0, 320, 0, 20)
    xpBarBg.Position = UDim2.new(0, 15, 0, 110)
    xpBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    xpBarBg.BorderSizePixel = 0
    xpBarBg.Parent = mainFrame
    
    local xpBarCorner = Instance.new("UICorner")
    xpBarCorner.CornerRadius = UDim.new(0, 10)
    xpBarCorner.Parent = xpBarBg
    
    local xpBar = Instance.new("Frame")
    xpBar.Name = "XPBar"
    xpBar.Size = UDim2.new(0, 0, 1, 0)
    xpBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    xpBar.BorderSizePixel = 0
    xpBar.Parent = xpBarBg
    
    local xpBarCorner2 = Instance.new("UICorner")
    xpBarCorner2.CornerRadius = UDim.new(0, 10)
    xpBarCorner2.Parent = xpBar
    
    local xpLabel = Instance.new("TextLabel")
    xpLabel.Name = "XPLabel"
    xpLabel.Size = UDim2.new(1, 0, 1, 0)
    xpLabel.BackgroundTransparency = 1
    xpLabel.Text = "0 / 100 XP"
    xpLabel.TextColor3 = Color3.new(1, 1, 1)
    xpLabel.TextStrokeTransparency = 0.5
    xpLabel.Font = Enum.Font.GothamBold
    xpLabel.TextSize = 14
    xpLabel.Parent = xpBarBg
    
    -- Cash
    local cashFrame = Instance.new("Frame")
    cashFrame.Name = "CashFrame"
    cashFrame.Size = UDim2.new(0, 150, 0, 30)
    cashFrame.Position = UDim2.new(0, 15, 0, 145)
    cashFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    cashFrame.BackgroundTransparency = 0.7
    cashFrame.BorderSizePixel = 0
    cashFrame.Parent = mainFrame
    
    local cashCorner = Instance.new("UICorner")
    cashCorner.CornerRadius = UDim.new(0, 8)
    cashCorner.Parent = cashFrame
    
    local cashLabel = Instance.new("TextLabel")
    cashLabel.Name = "Cash"
    cashLabel.Size = UDim2.new(1, 0, 1, 0)
    cashLabel.BackgroundTransparency = 1
    cashLabel.Text = "💰 100"
    cashLabel.TextColor3 = Color3.new(1, 1, 1)
    cashLabel.TextStrokeTransparency = 0.5
    cashLabel.Font = Enum.Font.GothamBold
    cashLabel.TextSize = 16
    cashLabel.Parent = cashFrame
    
    -- Diamantes
    local diamondFrame = Instance.new("Frame")
    diamondFrame.Name = "DiamondFrame"
    diamondFrame.Size = UDim2.new(0, 150, 0, 30)
    diamondFrame.Position = UDim2.new(0, 185, 0, 145)
    diamondFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    diamondFrame.BackgroundTransparency = 0.7
    diamondFrame.BorderSizePixel = 0
    diamondFrame.Parent = mainFrame
    
    local diamondCorner = Instance.new("UICorner")
    diamondCorner.CornerRadius = UDim.new(0, 8)
    diamondCorner.Parent = diamondFrame
    
    local diamondLabel = Instance.new("TextLabel")
    diamondLabel.Name = "Diamonds"
    diamondLabel.Size = UDim2.new(1, 0, 1, 0)
    diamondLabel.BackgroundTransparency = 1
    diamondLabel.Text = "💎 10"
    diamondLabel.TextColor3 = Color3.new(1, 1, 1)
    diamondLabel.TextStrokeTransparency = 0.5
    diamondLabel.Font = Enum.Font.GothamBold
    diamondLabel.TextSize = 16
    diamondLabel.Parent = diamondFrame
    
    -- Botão de inventário
    local invButton = Instance.new("TextButton")
    invButton.Name = "InventoryButton"
    invButton.Size = UDim2.new(0, 100, 0, 40)
    invButton.Position = UDim2.new(1, -120, 0, 20)
    invButton.BackgroundColor3 = Color3.fromRGB(100, 50, 150)
    invButton.Text = "📦 Inventário"
    invButton.TextColor3 = Color3.new(1, 1, 1)
    invButton.Font = Enum.Font.GothamBold
    invButton.TextSize = 14
    invButton.Parent = screenGui
    
    local invCorner = Instance.new("UICorner")
    invCorner.CornerRadius = UDim.new(0, 10)
    invCorner.Parent = invButton
    
    invButton.MouseButton1Click:Connect(function()
        self:ToggleInventory()
    end)
    
    return screenGui
end

-- Atualiza HUD com dados do jogador
function HUDController:UpdateHUD(data)
    self.PlayerData = data
    
    local hud = player.PlayerGui:FindFirstChild("MainHUD")
    if not hud then return end
    
    local mainFrame = hud:FindFirstChild("MainFrame")
    if not mainFrame then return end
    
    -- Atualiza rank
    local rankLabel = mainFrame:FindFirstChild("Rank")
    if rankLabel then
        rankLabel.Text = "Rank: " .. data.Rank
        rankLabel.TextColor3 = RankData:GetRankByName(data.Rank).Color
    end
    
    -- Atualiza level
    local levelLabel = mainFrame:FindFirstChild("Level")
    if levelLabel then
        levelLabel.Text = "Level: " .. data.Level
    end
    
    -- Atualiza XP
    local xpBarBg = mainFrame:FindFirstChild("XPBarBg")
    if xpBarBg then
        local xpBar = xpBarBg:FindFirstChild("XPBar")
        local xpLabel = xpBarBg:FindFirstChild("XPLabel")
        
        local DataManager = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("DataManager") or script)
        local requiredXP = math.floor(100 * (data.Level ^ 1.5))
        local percentage = math.min(1, data.XP / requiredXP)
        
        if xpBar then
            xpBar:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
        
        if xpLabel then
            xpLabel.Text = data.XP .. " / " .. requiredXP .. " XP"
        end
    end
    
    -- Atualiza cash
    local cashFrame = mainFrame:FindFirstChild("CashFrame")
    if cashFrame then
        local cashLabel = cashFrame:FindFirstChild("Cash")
        if cashLabel then
            cashLabel.Text = "💰 " .. data.Cash
        end
    end
    
    -- Atualiza diamantes
    local diamondFrame = mainFrame:FindFirstChild("DiamondFrame")
    if diamondFrame then
        local diamondLabel = diamondFrame:FindFirstChild("Diamonds")
        if diamondLabel then
            diamondLabel.Text = "💎 " .. data.Diamonds
        end
    end
end

-- Toggle inventário
function HUDController:ToggleInventory()
    RemoteEvents.OpenInventory:FireServer()
end

-- Mostra notificação
function HUDController:ShowNotification(title, message, color)
    local screenGui = player.PlayerGui:FindFirstChild("MainHUD")
    if not screenGui then return end
    
    -- Cria frame de notificação
    local notifFrame = Instance.new("Frame")
    notifFrame.Name = "Notification"
    notifFrame.Size = UDim2.new(0, 400, 0, 100)
    notifFrame.Position = UDim2.new(0.5, -200, 0, -120)
    notifFrame.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
    notifFrame.BackgroundTransparency = 0.2
    notifFrame.BorderSizePixel = 0
    notifFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = notifFrame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
    titleLabel.Position = UDim2.new(0, 0, 0.1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextStrokeTransparency = 0.5
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 22
    titleLabel.Parent = notifFrame
    
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 0.4, 0)
    messageLabel.Position = UDim2.new(0, 10, 0.5, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.new(1, 1, 1)
    messageLabel.TextStrokeTransparency = 0.5
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextSize = 16
    messageLabel.TextWrapped = true
    messageLabel.Parent = notifFrame
    
    -- Anima entrada
    notifFrame:TweenPosition(
        UDim2.new(0.5, -200, 0, 20),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.5,
        true
    )
    
    -- Remove após 4 segundos
    wait(4)
    notifFrame:TweenPosition(
        UDim2.new(0.5, -200, 0, -120),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Back,
        0.3,
        true,
        function()
            notifFrame:Destroy()
        end
    )
end

-- Inicialização
function HUDController:Init()
    self:CreateHUD()
    
    -- Escuta atualizações de dados
    RemoteEvents.DataLoaded.OnClientEvent:Connect(function(data)
        self:UpdateHUD(data)
    end)
    
    RemoteEvents.DataUpdated.OnClientEvent:Connect(function(data)
        self:UpdateHUD(data)
    end)
    
    RemoteEvents.ShowNotification.OnClientEvent:Connect(function(title, message, color)
        self:ShowNotification(title, message, color)
    end)
    
    print("[HUDController] Inicializado")
end

HUDController:Init()

return HUDController
