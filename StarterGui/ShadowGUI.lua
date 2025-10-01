--[[
    SHADOW GUI
    Localização: StarterGui/ShadowGUI.lua
    
    Interface do sistema de sombras com:
    - Lista de sombras capturadas
    - Detalhes da sombra selecionada
    - Sistema de evolução
    - Invocação e dispensa
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI das sombras
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShadowGUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal das sombras
local shadowFrame = Instance.new("Frame")
shadowFrame.Name = "ShadowFrame"
shadowFrame.Size = UDim2.new(0, 1000, 0, 750)
shadowFrame.Position = UDim2.new(0.5, -500, 0.5, -375)
shadowFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
shadowFrame.BorderSizePixel = 0
shadowFrame.Parent = screenGui

-- Borda do frame
local shadowBorder = Instance.new("Frame")
shadowBorder.Name = "ShadowBorder"
shadowBorder.Size = UDim2.new(1, 4, 1, 4)
shadowBorder.Position = UDim2.new(0, -2, 0, -2)
shadowBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
shadowBorder.BorderSizePixel = 0
shadowBorder.Parent = shadowFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = shadowFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "👻 SISTEMA DE SOMBRAS"
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

-- Frame principal (lado esquerdo - lista)
local listFrame = Instance.new("Frame")
listFrame.Name = "ListFrame"
listFrame.Size = UDim2.new(0, 400, 1, -60)
listFrame.Position = UDim2.new(0, 0, 0, 60)
listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
listFrame.BorderSizePixel = 0
listFrame.Parent = shadowFrame

-- Título da lista
local listTitle = Instance.new("TextLabel")
listTitle.Name = "ListTitle"
listTitle.Size = UDim2.new(1, 0, 0, 40)
listTitle.Position = UDim2.new(0, 0, 0, 0)
listTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
listTitle.BorderSizePixel = 0
listTitle.Text = "📋 SOMBRAS CAPTURADAS"
listTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
listTitle.TextScaled = true
listTitle.Font = Enum.Font.SourceSansBold
listTitle.Parent = listFrame

-- Lista de sombras
local shadowList = Instance.new("ScrollingFrame")
shadowList.Name = "ShadowList"
shadowList.Size = UDim2.new(1, -10, 1, -50)
shadowList.Position = UDim2.new(0, 5, 0, 45)
shadowList.BackgroundTransparency = 1
shadowList.BorderSizePixel = 0
shadowList.ScrollBarThickness = 10
shadowList.CanvasSize = UDim2.new(0, 0, 0, 0)
shadowList.Parent = listFrame

-- Layout da lista
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = shadowList

-- Frame de detalhes (lado direito)
local detailsFrame = Instance.new("Frame")
detailsFrame.Name = "DetailsFrame"
detailsFrame.Size = UDim2.new(0, 580, 1, -60)
detailsFrame.Position = UDim2.new(0, 410, 0, 60)
detailsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
detailsFrame.BorderSizePixel = 0
detailsFrame.Parent = shadowFrame

-- Título dos detalhes
local detailsTitle = Instance.new("TextLabel")
detailsTitle.Name = "DetailsTitle"
detailsTitle.Size = UDim2.new(1, 0, 0, 40)
detailsTitle.Position = UDim2.new(0, 0, 0, 0)
detailsTitle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
detailsTitle.BorderSizePixel = 0
detailsTitle.Text = "🔍 DETALHES DA SOMBRA"
detailsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
detailsTitle.TextScaled = true
detailsTitle.Font = Enum.Font.SourceSansBold
detailsTitle.Parent = detailsFrame

-- Conteúdo dos detalhes
local detailsContent = Instance.new("ScrollingFrame")
detailsContent.Name = "DetailsContent"
detailsContent.Size = UDim2.new(1, -10, 1, -50)
detailsContent.Position = UDim2.new(0, 5, 0, 45)
detailsContent.BackgroundTransparency = 1
detailsContent.BorderSizePixel = 0
detailsContent.ScrollBarThickness = 10
detailsContent.CanvasSize = UDim2.new(0, 0, 0, 0)
detailsContent.Parent = detailsFrame

-- Função para criar item da lista de sombras
local function createShadowListItem(shadowName, rank, level, isActive)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = shadowName
    itemFrame.Size = UDim2.new(1, 0, 0, 80)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = shadowList
    
    -- Borda baseada no rank
    local rankColors = {
        F = Color3.fromRGB(128, 128, 128),
        E = Color3.fromRGB(255, 255, 255),
        D = Color3.fromRGB(0, 255, 0),
        C = Color3.fromRGB(0, 0, 255),
        B = Color3.fromRGB(128, 0, 255),
        A = Color3.fromRGB(255, 165, 0),
        S = Color3.fromRGB(255, 0, 0),
        SS = Color3.fromRGB(255, 215, 0),
        GM = Color3.fromRGB(255, 0, 255)
    }
    
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = rankColors[rank] or Color3.fromRGB(128, 128, 128)
    border.BorderSizePixel = 0
    border.Parent = itemFrame
    
    -- Ícone da sombra
    local shadowIcon = Instance.new("ImageLabel")
    shadowIcon.Name = "ShadowIcon"
    shadowIcon.Size = UDim2.new(0, 60, 0, 60)
    shadowIcon.Position = UDim2.new(0, 10, 0.5, -30)
    shadowIcon.BackgroundTransparency = 1
    shadowIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadowIcon.Parent = itemFrame
    
    -- Nome da sombra
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -80, 0, 25)
    nameLabel.Position = UDim2.new(0, 80, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = shadowName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    -- Rank e nível
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(0, 100, 0, 20)
    rankLabel.Position = UDim2.new(0, 80, 0, 30)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "Rank: " .. rank .. " | Nível: " .. level
    rankLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.SourceSans
    rankLabel.TextXAlignment = Enum.TextXAlignment.Left
    rankLabel.Parent = itemFrame
    
    -- Status ativo
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(0, 100, 0, 20)
    statusLabel.Position = UDim2.new(0, 80, 0, 50)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = isActive and "🟢 ATIVA" or "⚫ INATIVA"
    statusLabel.TextColor3 = isActive and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(128, 128, 128)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.SourceSansBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = itemFrame
    
    -- Efeito hover
    itemFrame.MouseEnter:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        tween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween:Play()
    end)
    
    -- Selecionar sombra
    itemFrame.MouseButton1Click:Connect(function()
        showShadowDetails(shadowName, rank, level, isActive)
    end)
    
    return itemFrame
end

-- Função para mostrar detalhes da sombra
local function showShadowDetails(shadowName, rank, level, isActive)
    -- Limpar conteúdo anterior
    for _, child in ipairs(detailsContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Frame de informações básicas
    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoFrame"
    infoFrame.Size = UDim2.new(1, 0, 0, 200)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = detailsContent
    
    -- Nome da sombra
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = shadowName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = infoFrame
    
    -- Rank
    local rankLabel = Instance.new("TextLabel")
    rankLabel.Name = "RankLabel"
    rankLabel.Size = UDim2.new(0.5, 0, 0, 30)
    rankLabel.Position = UDim2.new(0, 0, 0, 40)
    rankLabel.BackgroundTransparency = 1
    rankLabel.Text = "Rank: " .. rank
    rankLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    rankLabel.TextScaled = true
    rankLabel.Font = Enum.Font.SourceSansBold
    rankLabel.TextXAlignment = Enum.TextXAlignment.Left
    rankLabel.Parent = infoFrame
    
    -- Nível
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(0.5, 0, 0, 30)
    levelLabel.Position = UDim2.new(0.5, 0, 0, 40)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Nível: " .. level
    levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.SourceSansBold
    levelLabel.TextXAlignment = Enum.TextXAlignment.Left
    levelLabel.Parent = infoFrame
    
    -- Atributos
    local attributesFrame = Instance.new("Frame")
    attributesFrame.Name = "AttributesFrame"
    attributesFrame.Size = UDim2.new(1, 0, 0, 120)
    attributesFrame.Position = UDim2.new(0, 0, 0, 80)
    attributesFrame.BackgroundTransparency = 1
    attributesFrame.Parent = infoFrame
    
    -- Vida
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Name = "HealthLabel"
    healthLabel.Size = UDim2.new(1, 0, 0, 25)
    healthLabel.Position = UDim2.new(0, 0, 0, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.Text = "❤️ Vida: 1000/1000"
    healthLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    healthLabel.TextScaled = true
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.TextXAlignment = Enum.TextXAlignment.Left
    healthLabel.Parent = attributesFrame
    
    -- Dano
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Name = "DamageLabel"
    damageLabel.Size = UDim2.new(1, 0, 0, 25)
    damageLabel.Position = UDim2.new(0, 0, 0, 25)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "⚔️ Dano: 250"
    damageLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    damageLabel.TextScaled = true
    damageLabel.Font = Enum.Font.SourceSans
    damageLabel.TextXAlignment = Enum.TextXAlignment.Left
    damageLabel.Parent = attributesFrame
    
    -- Velocidade
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 0, 0, 50)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "💨 Velocidade: 16"
    speedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = attributesFrame
    
    -- Raridade
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(1, 0, 0, 25)
    rarityLabel.Position = UDim2.new(0, 0, 0, 75)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "⭐ Raridade: 0.4"
    rarityLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rarityLabel.TextScaled = true
    rarityLabel.Font = Enum.Font.SourceSans
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = attributesFrame
    
    -- Frame de ações
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Name = "ActionsFrame"
    actionsFrame.Size = UDim2.new(1, 0, 0, 100)
    actionsFrame.Position = UDim2.new(0, 0, 0, 210)
    actionsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    actionsFrame.BorderSizePixel = 0
    actionsFrame.Parent = detailsContent
    
    -- Botão de invocar
    local summonButton = Instance.new("TextButton")
    summonButton.Name = "SummonButton"
    summonButton.Size = UDim2.new(0, 120, 0, 40)
    summonButton.Position = UDim2.new(0, 10, 0, 10)
    summonButton.BackgroundColor3 = isActive and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(0, 150, 255)
    summonButton.BorderSizePixel = 0
    summonButton.Text = isActive and "Dispensar" or "Invocar"
    summonButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    summonButton.TextScaled = true
    summonButton.Font = Enum.Font.SourceSansBold
    summonButton.Parent = actionsFrame
    
    -- Botão de evoluir
    local evolveButton = Instance.new("TextButton")
    evolveButton.Name = "EvolveButton"
    evolveButton.Size = UDim2.new(0, 120, 0, 40)
    evolveButton.Position = UDim2.new(0, 140, 0, 10)
    evolveButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    evolveButton.BorderSizePixel = 0
    evolveButton.Text = "Evoluir"
    evolveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    evolveButton.TextScaled = true
    evolveButton.Font = Enum.Font.SourceSansBold
    evolveButton.Parent = actionsFrame
    
    -- Botão de melhorar
    local upgradeButton = Instance.new("TextButton")
    upgradeButton.Name = "UpgradeButton"
    upgradeButton.Size = UDim2.new(0, 120, 0, 40)
    upgradeButton.Position = UDim2.new(0, 270, 0, 10)
    upgradeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    upgradeButton.BorderSizePixel = 0
    upgradeButton.Text = "Melhorar"
    upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upgradeButton.TextScaled = true
    upgradeButton.Font = Enum.Font.SourceSansBold
    upgradeButton.Parent = actionsFrame
    
    -- Conectar eventos dos botões
    summonButton.MouseButton1Click:Connect(function()
        if isActive then
            _G.showNotification("Dispensando sombra...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
        else
            _G.showNotification("Invocando sombra...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
        end
    end)
    
    evolveButton.MouseButton1Click:Connect(function()
        _G.showNotification("Evoluindo sombra...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    upgradeButton.MouseButton1Click:Connect(function()
        _G.showNotification("Melhorando sombra...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    -- Atualizar tamanho do canvas
    detailsContent.CanvasSize = UDim2.new(0, 0, 0, 320)
end

-- Adicionar sombras de exemplo
createShadowListItem("Shadow Wolf", "F", 5, false)
createShadowListItem("Shadow Bear", "E", 8, false)
createShadowListItem("Shadow Tiger", "D", 12, true)
createShadowListItem("Shadow Dragon", "A", 25, false)
createShadowListItem("Shadow Phoenix", "S", 35, false)

-- Atualizar tamanho do canvas da lista
shadowList.CanvasSize = UDim2.new(0, 0, 0, 5 * 85)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Função para abrir/fechar GUI das sombras
local function toggleShadowGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleShadowGUI = toggleShadowGUI

print("✅ ShadowGUI carregada com sucesso!")