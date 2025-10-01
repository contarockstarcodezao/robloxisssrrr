--[[
    RANKING GUI
    Localização: StarterGui/RankingGUI.lua
    
    Interface do sistema de ranking com:
    - Leaderboard global e semanal
    - Estatísticas dos jogadores
    - Filtros por categoria
    - Sistema de busca
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI do ranking
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RankingGUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal do ranking
local rankingFrame = Instance.new("Frame")
rankingFrame.Name = "RankingFrame"
rankingFrame.Size = UDim2.new(0, 900, 0, 700)
rankingFrame.Position = UDim2.new(0.5, -450, 0.5, -350)
rankingFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
rankingFrame.BorderSizePixel = 0
rankingFrame.Parent = screenGui

-- Borda do frame
local rankingBorder = Instance.new("Frame")
rankingBorder.Name = "RankingBorder"
rankingBorder.Size = UDim2.new(1, 4, 1, 4)
rankingBorder.Position = UDim2.new(0, -2, 0, -2)
rankingBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
rankingBorder.BorderSizePixel = 0
rankingBorder.Parent = rankingFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = rankingFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🏆 RANKING E LEADERBOARD"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame

-- Botão de fechar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 50, 0, 50)
closeButton.Position = UDim2.new(1, -55, 0.5, -25)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Parent = titleFrame

-- Frame de controles
local controlsFrame = Instance.new("Frame")
controlsFrame.Name = "ControlsFrame"
controlsFrame.Size = UDim2.new(1, 0, 0, 50)
controlsFrame.Position = UDim2.new(0, 0, 0, 60)
controlsFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
controlsFrame.BorderSizePixel = 0
controlsFrame.Parent = rankingFrame

-- Botão de ranking global
local globalButton = Instance.new("TextButton")
globalButton.Name = "GlobalButton"
globalButton.Size = UDim2.new(0, 120, 0, 40)
globalButton.Position = UDim2.new(0, 10, 0.5, -20)
globalButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
globalButton.BorderSizePixel = 0
globalButton.Text = "🌍 Global"
globalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
globalButton.TextScaled = true
globalButton.Font = Enum.Font.SourceSansBold
globalButton.Parent = controlsFrame

-- Botão de ranking semanal
local weeklyButton = Instance.new("TextButton")
weeklyButton.Name = "WeeklyButton"
weeklyButton.Size = UDim2.new(0, 120, 0, 40)
weeklyButton.Position = UDim2.new(0, 140, 0.5, -20)
weeklyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
weeklyButton.BorderSizePixel = 0
weeklyButton.Text = "📅 Semanal"
weeklyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
weeklyButton.TextScaled = true
weeklyButton.Font = Enum.Font.SourceSansBold
weeklyButton.Parent = controlsFrame

-- Botão de ranking por nível
local levelButton = Instance.new("TextButton")
levelButton.Name = "LevelButton"
levelButton.Size = UDim2.new(0, 120, 0, 40)
levelButton.Position = UDim2.new(0, 270, 0.5, -20)
levelButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
levelButton.BorderSizePixel = 0
levelButton.Text = "📈 Nível"
levelButton.TextColor3 = Color3.fromRGB(255, 255, 255)
levelButton.TextScaled = true
levelButton.Font = Enum.Font.SourceSansBold
levelButton.Parent = controlsFrame

-- Botão de ranking por poder
local powerButton = Instance.new("TextButton")
powerButton.Name = "PowerButton"
powerButton.Size = UDim2.new(0, 120, 0, 40)
powerButton.Position = UDim2.new(0, 400, 0.5, -20)
powerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
powerButton.BorderSizePixel = 0
powerButton.Text = "⚡ Poder"
powerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
powerButton.TextScaled = true
powerButton.Font = Enum.Font.SourceSansBold
powerButton.Parent = controlsFrame

-- Botão de atualizar
local refreshButton = Instance.new("TextButton")
refreshButton.Name = "RefreshButton"
refreshButton.Size = UDim2.new(0, 100, 0, 40)
refreshButton.Position = UDim2.new(1, -110, 0.5, -20)
refreshButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
refreshButton.BorderSizePixel = 0
refreshButton.Text = "🔄 Atualizar"
refreshButton.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshButton.TextScaled = true
refreshButton.Font = Enum.Font.SourceSansBold
refreshButton.Parent = controlsFrame

-- Frame de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = rankingFrame

-- Lista de ranking
local rankingList = Instance.new("ScrollingFrame")
rankingList.Name = "RankingList"
rankingList.Size = UDim2.new(1, 0, 1, 0)
rankingList.Position = UDim2.new(0, 0, 0, 0)
rankingList.BackgroundTransparency = 1
rankingList.BorderSizePixel = 0
rankingList.ScrollBarThickness = 10
rankingList.CanvasSize = UDim2.new(0, 0, 0, 0)
rankingList.Parent = contentFrame

-- Layout da lista
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = rankingList

-- Função para criar item do ranking
local function createRankingItem(rank, playerName, level, power, cash, diamonds, dungeons, raids)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = "RankingItem_" .. rank
    itemFrame.Size = UDim2.new(1, 0, 0, 60)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = rankingList
    
    -- Cores baseadas na posição
    local rankColors = {
        [1] = Color3.fromRGB(255, 215, 0), -- Ouro
        [2] = Color3.fromRGB(192, 192, 192), -- Prata
        [3] = Color3.fromRGB(205, 127, 50) -- Bronze
    }
    
    local borderColor = rankColors[rank] or Color3.fromRGB(0, 150, 255)
    
    -- Borda
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = borderColor
    border.BorderSizePixel = 0
    border.Parent = itemFrame
    
    -- Posição
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(0, 60, 1, 0)
    rankLabel.Position = UDim2.new(0, 0, 0, 0)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "#" .. rank
    rankLabel.TextColor3 = borderColor
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.Parent = itemFrame
    
    -- Avatar do jogador
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Name = "AvatarFrame"
    avatarFrame.Size = UDim2.new(0, 50, 0, 50)
    avatarFrame.Position = UDim2.new(0, 70, 0.5, -25)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.Parent = itemFrame
    
    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Name = "AvatarImage"
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.Position = UDim2.new(0, 0, 0, 0)
    avatarImage.BackgroundTransparency = 1
    avatarImage.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    avatarImage.Parent = avatarFrame
    
    -- Nome do jogador
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0, 150, 0, 25)
    nameLabel.Position = UDim2.new(0, 130, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    -- Nível
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(0, 80, 0, 20)
    levelLabel.Position = UDim2.new(0, 130, 0, 30)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Nível: " .. level
    levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.SourceSans
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = itemFrame
    
    -- Poder
    local powerLabel = Instance.new("TextLabel")
    powerLabel.Name = "PowerLabel"
    powerLabel.Size = UDim2.new(0, 100, 0, 20)
    powerLabel.Position = UDim2.new(0, 220, 0, 5)
    powerLabel.BackgroundTransparency = 1
    powerLabel.Text = "Poder: " .. power
    powerLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    powerLabel.TextScaled = true
    powerLabel.Font = Enum.Font.SourceSansBold
    powerLabel.TextXAlignment = Enum.TextXAlignment.Left
    powerLabel.Parent = itemFrame
    
    -- Cash
    local cashLabel = Instance.new("TextLabel")
    cashLabel.Name = "CashLabel"
    cashLabel.Size = UDim2.new(0, 100, 0, 20)
    cashLabel.Position = UDim2.new(0, 220, 0, 25)
    cashLabel.BackgroundTransparency = 1
    cashLabel.Text = "Cash: " .. cash
    cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    cashLabel.TextScaled = true
    cashLabel.Font = Enum.Font.SourceSans
    cashLabel.TextXAlignment = Enum.TextXAlignment.Left
    cashLabel.Parent = itemFrame
    
    -- Diamantes
    local diamondsLabel = Instance.new("TextLabel")
    diamondsLabel.Name = "DiamondsLabel"
    diamondsLabel.Size = UDim2.new(0, 100, 0, 20)
    diamondsLabel.Position = UDim2.new(0, 220, 0, 45)
    diamondsLabel.BackgroundTransparency = 1
    diamondsLabel.Text = "Diamantes: " .. diamonds
    diamondsLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
    diamondsLabel.TextScaled = true
    diamondsLabel.Font = Enum.Font.SourceSans
    diamondsLabel.TextXAlignment = Enum.TextXAlignment.Left
    diamondsLabel.Parent = itemFrame
    
    -- Dungeons
    local dungeonsLabel = Instance.new("TextLabel")
    dungeonsLabel.Name = "DungeonsLabel"
    dungeonsLabel.Size = UDim2.new(0, 100, 0, 20)
    dungeonsLabel.Position = UDim2.new(0, 330, 0, 5)
    dungeonsLabel.BackgroundTransparency = 1
    dungeonsLabel.Text = "Dungeons: " .. dungeons
    dungeonsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    dungeonsLabel.TextScaled = true
    dungeonsLabel.Font = Enum.Font.SourceSans
    dungeonsLabel.TextXAlignment = Enum.TextXAlignment.Left
    dungeonsLabel.Parent = itemFrame
    
    -- Raids
    local raidsLabel = Instance.new("TextLabel")
    raidsLabel.Name = "RaidsLabel"
    raidsLabel.Size = UDim2.new(0, 100, 0, 20)
    raidsLabel.Position = UDim2.new(0, 330, 0, 25)
    raidsLabel.BackgroundTransparency = 1
    raidsLabel.Text = "Raids: " .. raids
    raidsLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    raidsLabel.TextScaled = true
    raidsLabel.Font = Enum.Font.SourceSans
    raidsLabel.TextXAlignment = Enum.TextXAlignment.Left
    raidsLabel.Parent = itemFrame
    
    -- Efeito hover
    itemFrame.MouseEnter:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        tween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween:Play()
    end)
    
    return itemFrame
end

-- Função para alternar tipo de ranking
local function switchRankingType(activeButton)
    local buttons = {globalButton, weeklyButton, levelButton, powerButton}
    
    for _, button in ipairs(buttons) do
        if button == activeButton then
            button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end
    
    -- Limpar lista
    for _, child in ipairs(rankingList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Adicionar itens baseados no tipo
    if activeButton == globalButton then
        -- Ranking global
        createRankingItem(1, "Player1", 50, 15000, 50000, 100, 25, 10)
        createRankingItem(2, "Player2", 45, 12000, 40000, 80, 20, 8)
        createRankingItem(3, "Player3", 40, 10000, 35000, 70, 18, 7)
        createRankingItem(4, "Player4", 35, 8000, 30000, 60, 15, 5)
        createRankingItem(5, "Player5", 30, 6000, 25000, 50, 12, 4)
    elseif activeButton == weeklyButton then
        -- Ranking semanal
        createRankingItem(1, "Player1", 50, 15000, 50000, 100, 5, 2)
        createRankingItem(2, "Player2", 45, 12000, 40000, 80, 4, 2)
        createRankingItem(3, "Player3", 40, 10000, 35000, 70, 3, 1)
        createRankingItem(4, "Player4", 35, 8000, 30000, 60, 3, 1)
        createRankingItem(5, "Player5", 30, 6000, 25000, 50, 2, 1)
    elseif activeButton == levelButton then
        -- Ranking por nível
        createRankingItem(1, "Player1", 50, 15000, 50000, 100, 25, 10)
        createRankingItem(2, "Player2", 45, 12000, 40000, 80, 20, 8)
        createRankingItem(3, "Player3", 40, 10000, 35000, 70, 18, 7)
        createRankingItem(4, "Player4", 35, 8000, 30000, 60, 15, 5)
        createRankingItem(5, "Player5", 30, 6000, 25000, 50, 12, 4)
    elseif activeButton == powerButton then
        -- Ranking por poder
        createRankingItem(1, "Player1", 50, 15000, 50000, 100, 25, 10)
        createRankingItem(2, "Player2", 45, 12000, 40000, 80, 20, 8)
        createRankingItem(3, "Player3", 40, 10000, 35000, 70, 18, 7)
        createRankingItem(4, "Player4", 35, 8000, 30000, 60, 15, 5)
        createRankingItem(5, "Player5", 30, 6000, 25000, 50, 12, 4)
    end
    
    -- Atualizar tamanho do canvas
    rankingList.CanvasSize = UDim2.new(0, 0, 0, 5 * 65)
end

-- Conectar eventos dos botões
globalButton.MouseButton1Click:Connect(function()
    switchRankingType(globalButton)
end)

weeklyButton.MouseButton1Click:Connect(function()
    switchRankingType(weeklyButton)
end)

levelButton.MouseButton1Click:Connect(function()
    switchRankingType(levelButton)
end)

powerButton.MouseButton1Click:Connect(function()
    switchRankingType(powerButton)
end)

refreshButton.MouseButton1Click:Connect(function()
    _G.showNotification("Atualizando ranking...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Inicializar com ranking global
switchRankingType(globalButton)

-- Função para abrir/fechar GUI do ranking
local function toggleRankingGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleRankingGUI = toggleRankingGUI

print("✅ RankingGUI carregada com sucesso!")