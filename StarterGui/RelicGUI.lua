--[[
    RELIC GUI
    Localização: StarterGui/RelicGUI.lua
    
    Interface do sistema de relíquias com:
    - Lista de relíquias disponíveis
    - Detalhes da relíquia selecionada
    - Sistema de fusão
    - Equipamento em slots
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI das relíquias
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RelicGUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal das relíquias
local relicFrame = Instance.new("Frame")
relicFrame.Name = "RelicFrame"
relicFrame.Size = UDim2.new(0, 1000, 0, 750)
relicFrame.Position = UDim2.new(0.5, -500, 0.5, -375)
relicFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
relicFrame.BorderSizePixel = 0
relicFrame.Parent = screenGui

-- Borda do frame
local relicBorder = Instance.new("Frame")
relicBorder.Name = "RelicBorder"
relicBorder.Size = UDim2.new(1, 4, 1, 4)
relicBorder.Position = UDim2.new(0, -2, 0, -2)
relicBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
relicBorder.BorderSizePixel = 0
relicBorder.Parent = relicFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = relicFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "💎 SISTEMA DE RELÍQUIAS"
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

-- Frame de abas
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.Position = UDim2.new(0, 0, 0, 60)
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = relicFrame

-- Aba de relíquias
local relicTab = Instance.new("TextButton")
relicTab.Name = "RelicTab"
relicTab.Size = UDim2.new(0, 120, 1, 0)
relicTab.Position = UDim2.new(0, 0, 0, 0)
relicTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
relicTab.BorderSizePixel = 0
relicTab.Text = "💎 RELÍQUIAS"
relicTab.TextColor3 = Color3.fromRGB(255, 255, 255)
relicTab.TextScaled = true
relicTab.Font = Enum.Font.SourceSansBold
relicTab.Parent = tabFrame

-- Aba de fusão
local fusionTab = Instance.new("TextButton")
fusionTab.Name = "FusionTab"
fusionTab.Size = UDim2.new(0, 120, 1, 0)
fusionTab.Position = UDim2.new(0, 120, 0, 0)
fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fusionTab.BorderSizePixel = 0
fusionTab.Text = "🔗 FUSÃO"
fusionTab.TextColor3 = Color3.fromRGB(255, 255, 255)
fusionTab.TextScaled = true
fusionTab.Font = Enum.Font.SourceSansBold
fusionTab.Parent = tabFrame

-- Aba de equipamento
local equipTab = Instance.new("TextButton")
equipTab.Name = "EquipTab"
equipTab.Size = UDim2.new(0, 120, 1, 0)
equipTab.Position = UDim2.new(0, 240, 0, 0)
equipTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
equipTab.BorderSizePixel = 0
equipTab.Text = "⚔️ EQUIPAR"
equipTab.TextColor3 = Color3.fromRGB(255, 255, 255)
equipTab.TextScaled = true
equipTab.Font = Enum.Font.SourceSansBold
equipTab.Parent = tabFrame

-- Frame de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = relicFrame

-- Lista de relíquias
local relicList = Instance.new("ScrollingFrame")
relicList.Name = "RelicList"
relicList.Size = UDim2.new(0, 400, 1, 0)
relicList.Position = UDim2.new(0, 0, 0, 0)
relicList.BackgroundTransparency = 1
relicList.BorderSizePixel = 0
relicList.ScrollBarThickness = 10
relicList.CanvasSize = UDim2.new(0, 0, 0, 0)
relicList.Parent = contentFrame

-- Layout da lista
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = relicList

-- Frame de detalhes
local detailsFrame = Instance.new("Frame")
detailsFrame.Name = "DetailsFrame"
detailsFrame.Size = UDim2.new(0, 560, 1, 0)
detailsFrame.Position = UDim2.new(0, 410, 0, 0)
detailsFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
detailsFrame.BorderSizePixel = 0
detailsFrame.Parent = contentFrame

-- Título dos detalhes
local detailsTitle = Instance.new("TextLabel")
detailsTitle.Name = "DetailsTitle"
detailsTitle.Size = UDim2.new(1, 0, 0, 40)
detailsTitle.Position = UDim2.new(0, 0, 0, 0)
detailsTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
detailsTitle.BorderSizePixel = 0
detailsTitle.Text = "🔍 DETALHES DA RELÍQUIA"
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

-- Função para criar item da lista de relíquias
local function createRelicListItem(relicName, relicType, rarity, effect, value, description)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = relicName
    itemFrame.Size = UDim2.new(1, 0, 0, 80)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = relicList
    
    -- Cores baseadas na raridade
    local rarityColors = {
        Common = Color3.fromRGB(128, 128, 128),
        Rare = Color3.fromRGB(0, 255, 0),
        Epic = Color3.fromRGB(128, 0, 255),
        Legendary = Color3.fromRGB(255, 215, 0)
    }
    
    local borderColor = rarityColors[rarity] or Color3.fromRGB(128, 128, 128)
    
    -- Borda
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = borderColor
    border.BorderSizePixel = 0
    border.Parent = itemFrame
    
    -- Ícone da relíquia
    local relicIcon = Instance.new("ImageLabel")
    relicIcon.Name = "RelicIcon"
    relicIcon.Size = UDim2.new(0, 60, 0, 60)
    relicIcon.Position = UDim2.new(0, 10, 0.5, -30)
    relicIcon.BackgroundTransparency = 1
    relicIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    relicIcon.Parent = itemFrame
    
    -- Nome da relíquia
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -80, 0, 25)
    nameLabel.Position = UDim2.new(0, 80, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = relicName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    -- Tipo e raridade
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(0, 150, 0, 20)
    typeLabel.Position = UDim2.new(0, 80, 0, 30)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = relicType .. " | " .. rarity
    typeLabel.TextColor3 = borderColor
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.SourceSans
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = itemFrame
    
    -- Efeito
    local effectLabel = Instance.new("TextLabel")
    effectLabel.Name = "EffectLabel"
    effectLabel.Size = UDim2.new(1, -80, 0, 20)
    effectLabel.Position = UDim2.new(0, 80, 0, 50)
    effectLabel.BackgroundTransparency = 1
    effectLabel.Text = effect .. ": +" .. value .. "%"
    effectLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    effectLabel.TextScaled = true
    effectLabel.Font = Enum.Font.SourceSans
    effectLabel.TextXAlignment = Enum.TextXAlignment.Left
    effectLabel.Parent = itemFrame
    
    -- Efeito hover
    itemFrame.MouseEnter:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        tween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween:Play()
    end)
    
    -- Selecionar relíquia
    itemFrame.MouseButton1Click:Connect(function()
        showRelicDetails(relicName, relicType, rarity, effect, value, description)
    end)
    
    return itemFrame
end

-- Função para mostrar detalhes da relíquia
local function showRelicDetails(relicName, relicType, rarity, effect, value, description)
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
    infoFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = detailsContent
    
    -- Nome da relíquia
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = relicName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.Parent = infoFrame
    
    -- Tipo
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(0.5, 0, 0, 30)
    typeLabel.Position = UDim2.new(0, 0, 0, 40)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = "Tipo: " .. relicType
    typeLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.SourceSansBold
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = infoFrame
    
    -- Raridade
    local rarityLabel = Instance.new("TextLabel")
    rarityLabel.Name = "RarityLabel"
    rarityLabel.Size = UDim2.new(0.5, 0, 0, 30)
    rarityLabel.Position = UDim2.new(0.5, 0, 0, 40)
    rarityLabel.BackgroundTransparency = 1
    rarityLabel.Text = "Raridade: " .. rarity
    rarityLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rarityLabel.TextScaled = true
    rarityLabel.Font = Enum.Font.SourceSansBold
    rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
    rarityLabel.Parent = infoFrame
    
    -- Efeito
    local effectLabel = Instance.new("TextLabel")
    effectLabel.Name = "EffectLabel"
    effectLabel.Size = UDim2.new(1, 0, 0, 30)
    effectLabel.Position = UDim2.new(0, 0, 0, 70)
    effectLabel.BackgroundTransparency = 1
    effectLabel.Text = "Efeito: " .. effect
    effectLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    effectLabel.TextScaled = true
    effectLabel.Font = Enum.Font.SourceSansBold
    effectLabel.TextXAlignment = Enum.TextXAlignment.Left
    effectLabel.Parent = infoFrame
    
    -- Valor
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "ValueLabel"
    valueLabel.Size = UDim2.new(1, 0, 0, 30)
    valueLabel.Position = UDim2.new(0, 0, 0, 100)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = "Valor: +" .. value .. "%"
    valueLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.SourceSansBold
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Parent = infoFrame
    
    -- Descrição
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "DescriptionLabel"
    descriptionLabel.Size = UDim2.new(1, 0, 0, 60)
    descriptionLabel.Position = UDim2.new(0, 0, 0, 130)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = "Descrição: " .. description
    descriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descriptionLabel.TextScaled = true
    descriptionLabel.Font = Enum.Font.SourceSans
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    descriptionLabel.Parent = infoFrame
    
    -- Frame de ações
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Name = "ActionsFrame"
    actionsFrame.Size = UDim2.new(1, 0, 0, 100)
    actionsFrame.Position = UDim2.new(0, 0, 0, 210)
    actionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    actionsFrame.BorderSizePixel = 0
    actionsFrame.Parent = detailsContent
    
    -- Botão de equipar
    local equipButton = Instance.new("TextButton")
    equipButton.Name = "EquipButton"
    equipButton.Size = UDim2.new(0, 120, 0, 40)
    equipButton.Position = UDim2.new(0, 10, 0, 10)
    equipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    equipButton.BorderSizePixel = 0
    equipButton.Text = "Equipar"
    equipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    equipButton.TextScaled = true
    equipButton.Font = Enum.Font.SourceSansBold
    equipButton.Parent = actionsFrame
    
    -- Botão de fundir
    local fuseButton = Instance.new("TextButton")
    fuseButton.Name = "FuseButton"
    fuseButton.Size = UDim2.new(0, 120, 0, 40)
    fuseButton.Position = UDim2.new(0, 140, 0, 10)
    fuseButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    fuseButton.BorderSizePixel = 0
    fuseButton.Text = "Fundir"
    fuseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    fuseButton.TextScaled = true
    fuseButton.Font = Enum.Font.SourceSansBold
    fuseButton.Parent = actionsFrame
    
    -- Botão de vender
    local sellButton = Instance.new("TextButton")
    sellButton.Name = "SellButton"
    sellButton.Size = UDim2.new(0, 120, 0, 40)
    sellButton.Position = UDim2.new(0, 270, 0, 10)
    sellButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    sellButton.BorderSizePixel = 0
    sellButton.Text = "Vender"
    sellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellButton.TextScaled = true
    sellButton.Font = Enum.Font.SourceSansBold
    sellButton.Parent = actionsFrame
    
    -- Conectar eventos dos botões
    equipButton.MouseButton1Click:Connect(function()
        _G.showNotification("Equipando relíquia...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    fuseButton.MouseButton1Click:Connect(function()
        _G.showNotification("Fundindo relíquia...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    sellButton.MouseButton1Click:Connect(function()
        _G.showNotification("Vendendo relíquia...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    -- Atualizar tamanho do canvas
    detailsContent.CanvasSize = UDim2.new(0, 0, 0, 320)
end

-- Adicionar relíquias de exemplo
createRelicListItem("Power Stone", "Damage", "Common", "damage_boost", 10, "Aumenta o dano em 10%")
createRelicListItem("Warrior's Gem", "Damage", "Rare", "damage_boost", 25, "Aumenta o dano em 25%")
createRelicListItem("Dragon's Heart", "Damage", "Epic", "damage_boost", 50, "Aumenta o dano em 50%")
createRelicListItem("God's Wrath", "Damage", "Legendary", "damage_boost", 100, "Aumenta o dano em 100%")
createRelicListItem("Wind Crystal", "Speed", "Common", "speed_boost", 15, "Aumenta a velocidade em 15%")
createRelicListItem("Lightning Core", "Speed", "Rare", "speed_boost", 30, "Aumenta a velocidade em 30%")
createRelicListItem("Storm Essence", "Speed", "Epic", "speed_boost", 60, "Aumenta a velocidade em 60%")
createRelicListItem("Time Shard", "Speed", "Legendary", "speed_boost", 100, "Aumenta a velocidade em 100%")
createRelicListItem("Health Orb", "Health", "Common", "health_boost", 20, "Aumenta a vida em 20%")
createRelicListItem("Vitality Stone", "Health", "Rare", "health_boost", 40, "Aumenta a vida em 40%")
createRelicListItem("Life Crystal", "Health", "Epic", "health_boost", 80, "Aumenta a vida em 80%")
createRelicListItem("Immortality Core", "Health", "Legendary", "health_boost", 150, "Aumenta a vida em 150%")

-- Atualizar tamanho do canvas da lista
relicList.CanvasSize = UDim2.new(0, 0, 0, 12 * 85)

-- Conectar eventos das abas
relicTab.MouseButton1Click:Connect(function()
    -- Ativar aba de relíquias
    relicTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    equipTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

fusionTab.MouseButton1Click:Connect(function()
    -- Ativar aba de fusão
    relicTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fusionTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    equipTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    _G.showNotification("Abrindo fusão de relíquias...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

equipTab.MouseButton1Click:Connect(function()
    -- Ativar aba de equipamento
    relicTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    equipTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    _G.showNotification("Abrindo equipamento de relíquias...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Função para abrir/fechar GUI das relíquias
local function toggleRelicGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleRelicGUI = toggleRelicGUI

print("✅ RelicGUI carregada com sucesso!")