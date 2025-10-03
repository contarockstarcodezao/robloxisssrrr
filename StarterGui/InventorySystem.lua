--[[
    INVENTORY SYSTEM - Sistema de Inventário
    Framework completo e funcional para Arise Crossover
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("📦 Criando sistema de inventário...")

-- Criar GUI do inventário
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "InventorySystem"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal
local inventoryFrame = Instance.new("Frame")
inventoryFrame.Name = "InventoryFrame"
inventoryFrame.Size = UDim2.new(0, 800, 0, 600)
inventoryFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
inventoryFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
inventoryFrame.BorderSizePixel = 0
inventoryFrame.Parent = screenGui

-- Borda
local border = Instance.new("Frame")
border.Name = "Border"
border.Size = UDim2.new(1, 4, 1, 4)
border.Position = UDim2.new(0, -2, 0, -2)
border.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
border.BorderSizePixel = 0
border.Parent = inventoryFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = inventoryFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "📦 INVENTÁRIO"
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
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.Position = UDim2.new(0, 0, 0, 50)
tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabFrame.BorderSizePixel = 0
tabFrame.Parent = inventoryFrame

-- Aba de armas
local weaponTab = Instance.new("TextButton")
weaponTab.Name = "WeaponTab"
weaponTab.Size = UDim2.new(0, 100, 1, 0)
weaponTab.Position = UDim2.new(0, 0, 0, 0)
weaponTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
weaponTab.BorderSizePixel = 0
weaponTab.Text = "⚔️ ARMAS"
weaponTab.TextColor3 = Color3.fromRGB(255, 255, 255)
weaponTab.TextScaled = true
weaponTab.Font = Enum.Font.SourceSansBold
weaponTab.Parent = tabFrame

-- Aba de sombras
local shadowTab = Instance.new("TextButton")
shadowTab.Name = "ShadowTab"
shadowTab.Size = UDim2.new(0, 100, 1, 0)
shadowTab.Position = UDim2.new(0, 100, 0, 0)
shadowTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shadowTab.BorderSizePixel = 0
shadowTab.Text = "👻 SOMBRAS"
shadowTab.TextColor3 = Color3.fromRGB(255, 255, 255)
shadowTab.TextScaled = true
shadowTab.Font = Enum.Font.SourceSansBold
shadowTab.Parent = tabFrame

-- Aba de relíquias
local relicTab = Instance.new("TextButton")
relicTab.Name = "RelicTab"
relicTab.Size = UDim2.new(0, 100, 1, 0)
relicTab.Position = UDim2.new(0, 200, 0, 0)
relicTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
relicTab.BorderSizePixel = 0
relicTab.Text = "💎 RELÍQUIAS"
relicTab.TextColor3 = Color3.fromRGB(255, 255, 255)
relicTab.TextScaled = true
relicTab.Font = Enum.Font.SourceSansBold
relicTab.Parent = tabFrame

-- Aba de poções
local potionTab = Instance.new("TextButton")
potionTab.Name = "PotionTab"
potionTab.Size = UDim2.new(0, 100, 1, 0)
potionTab.Position = UDim2.new(0, 300, 0, 0)
potionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
potionTab.BorderSizePixel = 0
potionTab.Text = "🧪 POÇÕES"
potionTab.TextColor3 = Color3.fromRGB(255, 255, 255)
potionTab.TextScaled = true
potionTab.Font = Enum.Font.SourceSansBold
potionTab.Parent = tabFrame

-- Aba de fragmentos
local fragmentTab = Instance.new("TextButton")
fragmentTab.Name = "FragmentTab"
fragmentTab.Size = UDim2.new(0, 100, 1, 0)
fragmentTab.Position = UDim2.new(0, 400, 0, 0)
fragmentTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fragmentTab.BorderSizePixel = 0
fragmentTab.Text = "💎 FRAGMENTOS"
fragmentTab.TextColor3 = Color3.fromRGB(255, 255, 255)
fragmentTab.TextScaled = true
fragmentTab.Font = Enum.Font.SourceSansBold
fragmentTab.Parent = tabFrame

-- Frame de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 90)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = inventoryFrame

-- Grid de itens
local itemGrid = Instance.new("ScrollingFrame")
itemGrid.Name = "ItemGrid"
itemGrid.Size = UDim2.new(1, 0, 1, 0)
itemGrid.Position = UDim2.new(0, 0, 0, 0)
itemGrid.BackgroundTransparency = 1
itemGrid.BorderSizePixel = 0
itemGrid.ScrollBarThickness = 10
itemGrid.CanvasSize = UDim2.new(0, 0, 0, 0)
itemGrid.Parent = contentFrame

-- Layout do grid
local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellSize = UDim2.new(0, 100, 0, 100)
gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Top
gridLayout.Parent = itemGrid

-- Função para criar item do inventário
local function createInventoryItem(itemName, itemType, quantity, rarity)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = itemName
    itemFrame.Size = UDim2.new(0, 100, 0, 100)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = itemGrid
    
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
    
    -- Ícone do item
    local itemIcon = Instance.new("ImageLabel")
    itemIcon.Name = "ItemIcon"
    itemIcon.Size = UDim2.new(0, 60, 0, 60)
    itemIcon.Position = UDim2.new(0.5, -30, 0.5, -30)
    itemIcon.BackgroundTransparency = 1
    itemIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    itemIcon.Parent = itemFrame
    
    -- Nome do item
    local itemNameLabel = Instance.new("TextLabel")
    itemNameLabel.Name = "ItemNameLabel"
    itemNameLabel.Size = UDim2.new(1, -4, 0, 20)
    itemNameLabel.Position = UDim2.new(0, 2, 0, 2)
    itemNameLabel.BackgroundTransparency = 1
    itemNameLabel.Text = itemName
    itemNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    itemNameLabel.TextScaled = true
    itemNameLabel.Font = Enum.Font.SourceSansBold
    itemNameLabel.Parent = itemFrame
    
    -- Quantidade
    local quantityLabel = Instance.new("TextLabel")
    quantityLabel.Name = "QuantityLabel"
    quantityLabel.Size = UDim2.new(0, 30, 0, 20)
    quantityLabel.Position = UDim2.new(1, -32, 1, -22)
    quantityLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    quantityLabel.BorderSizePixel = 0
    quantityLabel.Text = tostring(quantity)
    quantityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    quantityLabel.TextScaled = true
    quantityLabel.Font = Enum.Font.SourceSansBold
    quantityLabel.Parent = itemFrame
    
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

-- Função para alternar aba
local function switchTab(activeTab)
    local tabs = {weaponTab, shadowTab, relicTab, potionTab, fragmentTab}
    
    for _, tab in ipairs(tabs) do
        if tab == activeTab then
            tab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        else
            tab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end
    
    -- Limpar grid
    for _, child in ipairs(itemGrid:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Adicionar itens baseados na aba
    if activeTab == weaponTab then
        createInventoryItem("Iron Sword", "Weapon", 1, "Common")
        createInventoryItem("Steel Sword", "Weapon", 1, "Rare")
        createInventoryItem("Dragon Blade", "Weapon", 1, "Epic")
    elseif activeTab == shadowTab then
        createInventoryItem("Shadow Wolf", "Shadow", 2, "Common")
        createInventoryItem("Shadow Bear", "Shadow", 1, "Rare")
        createInventoryItem("Shadow Tiger", "Shadow", 1, "Epic")
    elseif activeTab == relicTab then
        createInventoryItem("Power Stone", "Relic", 3, "Common")
        createInventoryItem("Warrior's Gem", "Relic", 1, "Rare")
    elseif activeTab == potionTab then
        createInventoryItem("Health Potion", "Potion", 5, "Common")
        createInventoryItem("Mana Potion", "Potion", 3, "Common")
    elseif activeTab == fragmentTab then
        createInventoryItem("Shadow Fragment", "Fragment", 25, "Common")
        createInventoryItem("Weapon Fragment", "Fragment", 15, "Rare")
    end
    
    -- Atualizar tamanho do canvas
    local itemCount = 0
    for _, child in ipairs(itemGrid:GetChildren()) do
        if child:IsA("Frame") then
            itemCount = itemCount + 1
        end
    end
    
    local rows = math.ceil(itemCount / 7)
    itemGrid.CanvasSize = UDim2.new(0, 0, 0, rows * 105)
end

-- Conectar eventos das abas
weaponTab.MouseButton1Click:Connect(function()
    switchTab(weaponTab)
end)

shadowTab.MouseButton1Click:Connect(function()
    switchTab(shadowTab)
end)

relicTab.MouseButton1Click:Connect(function()
    switchTab(relicTab)
end)

potionTab.MouseButton1Click:Connect(function()
    switchTab(potionTab)
end)

fragmentTab.MouseButton1Click:Connect(function()
    switchTab(fragmentTab)
end)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Efeito hover do botão de fechar
closeButton.MouseEnter:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 100, 100)})
    tween:Play()
end)

closeButton.MouseLeave:Connect(function()
    local tween = TweenService:Create(closeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)})
    tween:Play()
end)

-- Inicializar com aba de armas
switchTab(weaponTab)

-- Função para abrir/fechar inventário
local function toggleInventory()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleInventory = toggleInventory

print("✅ InventorySystem criado com sucesso!")