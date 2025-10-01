--[[
    WEAPON GUI
    Localização: StarterGui/WeaponGUI.lua
    
    Interface do sistema de armas com:
    - Lista de armas disponíveis
    - Detalhes da arma selecionada
    - Sistema de forja e melhoria
    - Fusão de armas
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI das armas
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WeaponGUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal das armas
local weaponFrame = Instance.new("Frame")
weaponFrame.Name = "WeaponFrame"
weaponFrame.Size = UDim2.new(0, 1000, 0, 750)
weaponFrame.Position = UDim2.new(0.5, -500, 0.5, -375)
weaponFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
weaponFrame.BorderSizePixel = 0
weaponFrame.Parent = screenGui

-- Borda do frame
local weaponBorder = Instance.new("Frame")
weaponBorder.Name = "WeaponBorder"
weaponBorder.Size = UDim2.new(1, 4, 1, 4)
weaponBorder.Position = UDim2.new(0, -2, 0, -2)
weaponBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
weaponBorder.BorderSizePixel = 0
weaponBorder.Parent = weaponFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = weaponFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚔️ SISTEMA DE ARMAS"
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
tabFrame.Parent = weaponFrame

-- Aba de armas
local weaponTab = Instance.new("TextButton")
weaponTab.Name = "WeaponTab"
weaponTab.Size = UDim2.new(0, 120, 1, 0)
weaponTab.Position = UDim2.new(0, 0, 0, 0)
weaponTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
weaponTab.BorderSizePixel = 0
weaponTab.Text = "⚔️ ARMAS"
weaponTab.TextColor3 = Color3.fromRGB(255, 255, 255)
weaponTab.TextScaled = true
weaponTab.Font = Enum.Font.SourceSansBold
weaponTab.Parent = tabFrame

-- Aba de forja
local forgeTab = Instance.new("TextButton")
forgeTab.Name = "ForgeTab"
forgeTab.Size = UDim2.new(0, 120, 1, 0)
forgeTab.Position = UDim2.new(0, 120, 0, 0)
forgeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
forgeTab.BorderSizePixel = 0
forgeTab.Text = "🔥 FORJA"
forgeTab.TextColor3 = Color3.fromRGB(255, 255, 255)
forgeTab.TextScaled = true
forgeTab.Font = Enum.Font.SourceSansBold
forgeTab.Parent = tabFrame

-- Aba de fusão
local fusionTab = Instance.new("TextButton")
fusionTab.Name = "FusionTab"
fusionTab.Size = UDim2.new(0, 120, 1, 0)
fusionTab.Position = UDim2.new(0, 240, 0, 0)
fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fusionTab.BorderSizePixel = 0
fusionTab.Text = "🔗 FUSÃO"
fusionTab.TextColor3 = Color3.fromRGB(255, 255, 255)
fusionTab.TextScaled = true
fusionTab.Font = Enum.Font.SourceSansBold
fusionTab.Parent = tabFrame

-- Aba de melhorias
local upgradeTab = Instance.new("TextButton")
upgradeTab.Name = "UpgradeTab"
upgradeTab.Size = UDim2.new(0, 120, 1, 0)
upgradeTab.Position = UDim2.new(0, 360, 0, 0)
upgradeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
upgradeTab.BorderSizePixel = 0
upgradeTab.Text = "⬆️ MELHORIAS"
upgradeTab.TextColor3 = Color3.fromRGB(255, 255, 255)
upgradeTab.TextScaled = true
upgradeTab.Font = Enum.Font.SourceSansBold
upgradeTab.Parent = tabFrame

-- Frame de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = weaponFrame

-- Lista de armas
local weaponList = Instance.new("ScrollingFrame")
weaponList.Name = "WeaponList"
weaponList.Size = UDim2.new(0, 400, 1, 0)
weaponList.Position = UDim2.new(0, 0, 0, 0)
weaponList.BackgroundTransparency = 1
weaponList.BorderSizePixel = 0
weaponList.ScrollBarThickness = 10
weaponList.CanvasSize = UDim2.new(0, 0, 0, 0)
weaponList.Parent = contentFrame

-- Layout da lista
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = weaponList

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
detailsTitle.Text = "🔍 DETALHES DA ARMA"
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

-- Função para criar item da lista de armas
local function createWeaponListItem(weaponName, weaponType, rarity, damage, attackSpeed, range, specialEffects)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = weaponName
    itemFrame.Size = UDim2.new(1, 0, 0, 80)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = weaponList
    
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
    
    -- Ícone da arma
    local weaponIcon = Instance.new("ImageLabel")
    weaponIcon.Name = "WeaponIcon"
    weaponIcon.Size = UDim2.new(0, 60, 0, 60)
    weaponIcon.Position = UDim2.new(0, 10, 0.5, -30)
    weaponIcon.BackgroundTransparency = 1
    weaponIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    weaponIcon.Parent = itemFrame
    
    -- Nome da arma
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -80, 0, 25)
    nameLabel.Position = UDim2.new(0, 80, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = weaponName
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
    typeLabel.Text = weaponType .. " | " .. rarity
    typeLabel.TextColor3 = borderColor
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.SourceSans
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = itemFrame
    
    -- Dano
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Name = "DamageLabel"
    damageLabel.Size = UDim2.new(0, 100, 0, 20)
    damageLabel.Position = UDim2.new(0, 80, 0, 50)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "Dano: " .. damage
    damageLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    damageLabel.TextScaled = true
    damageLabel.Font = Enum.Font.SourceSans
    damageLabel.TextXAlignment = Enum.TextXAlignment.Left
    damageLabel.Parent = itemFrame
    
    -- Velocidade de ataque
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 100, 0, 20)
    speedLabel.Position = UDim2.new(0, 190, 0, 50)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Vel: " .. attackSpeed
    speedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = itemFrame
    
    -- Efeito hover
    itemFrame.MouseEnter:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        tween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween:Play()
    end)
    
    -- Selecionar arma
    itemFrame.MouseButton1Click:Connect(function()
        showWeaponDetails(weaponName, weaponType, rarity, damage, attackSpeed, range, specialEffects)
    end)
    
    return itemFrame
end

-- Função para mostrar detalhes da arma
local function showWeaponDetails(weaponName, weaponType, rarity, damage, attackSpeed, range, specialEffects)
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
    
    -- Nome da arma
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = weaponName
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
    typeLabel.Text = "Tipo: " .. weaponType
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
    
    -- Atributos
    local attributesFrame = Instance.new("Frame")
    attributesFrame.Name = "AttributesFrame"
    attributesFrame.Size = UDim2.new(1, 0, 0, 120)
    attributesFrame.Position = UDim2.new(0, 0, 0, 80)
    attributesFrame.BackgroundTransparency = 1
    attributesFrame.Parent = infoFrame
    
    -- Dano
    local damageLabel = Instance.new("TextLabel")
    damageLabel.Name = "DamageLabel"
    damageLabel.Size = UDim2.new(1, 0, 0, 25)
    damageLabel.Position = UDim2.new(0, 0, 0, 0)
    damageLabel.BackgroundTransparency = 1
    damageLabel.Text = "⚔️ Dano: " .. damage
    damageLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    damageLabel.TextScaled = true
    damageLabel.Font = Enum.Font.SourceSans
    damageLabel.TextXAlignment = Enum.TextXAlignment.Left
    damageLabel.Parent = attributesFrame
    
    -- Velocidade de ataque
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 25)
    speedLabel.Position = UDim2.new(0, 0, 0, 25)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "💨 Velocidade: " .. attackSpeed
    speedLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.SourceSans
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = attributesFrame
    
    -- Alcance
    local rangeLabel = Instance.new("TextLabel")
    rangeLabel.Name = "RangeLabel"
    rangeLabel.Size = UDim2.new(1, 0, 0, 25)
    rangeLabel.Position = UDim2.new(0, 0, 0, 50)
    rangeLabel.BackgroundTransparency = 1
    rangeLabel.Text = "📏 Alcance: " .. range
    rangeLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    rangeLabel.TextScaled = true
    rangeLabel.Font = Enum.Font.SourceSans
    rangeLabel.TextXAlignment = Enum.TextXAlignment.Left
    rangeLabel.Parent = attributesFrame
    
    -- Efeitos especiais
    local effectsLabel = Instance.new("TextLabel")
    effectsLabel.Name = "EffectsLabel"
    effectsLabel.Size = UDim2.new(1, 0, 0, 25)
    effectsLabel.Position = UDim2.new(0, 0, 0, 75)
    effectsLabel.BackgroundTransparency = 1
    effectsLabel.Text = "✨ Efeitos: " .. table.concat(specialEffects, ", ")
    effectsLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
    effectsLabel.TextScaled = true
    effectsLabel.Font = Enum.Font.SourceSans
    effectsLabel.TextXAlignment = Enum.TextXAlignment.Left
    effectsLabel.Parent = attributesFrame
    
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
    
    -- Botão de melhorar
    local upgradeButton = Instance.new("TextButton")
    upgradeButton.Name = "UpgradeButton"
    upgradeButton.Size = UDim2.new(0, 120, 0, 40)
    upgradeButton.Position = UDim2.new(0, 140, 0, 10)
    upgradeButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    upgradeButton.BorderSizePixel = 0
    upgradeButton.Text = "Melhorar"
    upgradeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upgradeButton.TextScaled = true
    upgradeButton.Font = Enum.Font.SourceSansBold
    upgradeButton.Parent = actionsFrame
    
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
        _G.showNotification("Equipando arma...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    upgradeButton.MouseButton1Click:Connect(function()
        _G.showNotification("Melhorando arma...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    sellButton.MouseButton1Click:Connect(function()
        _G.showNotification("Vendendo arma...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    -- Atualizar tamanho do canvas
    detailsContent.CanvasSize = UDim2.new(0, 0, 0, 320)
end

-- Adicionar armas de exemplo
createWeaponListItem("Iron Sword", "Sword", "Common", 50, 1.0, 8, {"Sharp Edge"})
createWeaponListItem("Steel Sword", "Sword", "Rare", 80, 1.2, 10, {"Sharp Edge", "Critical Hit"})
createWeaponListItem("Dragon Blade", "Sword", "Epic", 150, 1.5, 12, {"Fire Damage", "Critical Hit", "Area Damage"})
createWeaponListItem("Excalibur", "Sword", "Legendary", 300, 2.0, 15, {"Holy Light", "Area Damage", "Life Steal"})
createWeaponListItem("Iron Fist", "Fist", "Common", 40, 1.5, 6, {"Knockback"})
createWeaponListItem("Steel Gauntlets", "Fist", "Rare", 70, 1.8, 7, {"Knockback", "Critical Hit"})
createWeaponListItem("Thunder Fists", "Fist", "Epic", 120, 2.2, 8, {"Lightning Damage", "Chain Lightning"})
createWeaponListItem("God's Fist", "Fist", "Legendary", 250, 2.5, 10, {"Divine Strike", "Shockwave", "Stun"})

-- Atualizar tamanho do canvas da lista
weaponList.CanvasSize = UDim2.new(0, 0, 0, 8 * 85)

-- Conectar eventos das abas
weaponTab.MouseButton1Click:Connect(function()
    -- Ativar aba de armas
    weaponTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    forgeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    upgradeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

forgeTab.MouseButton1Click:Connect(function()
    -- Ativar aba de forja
    weaponTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    forgeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    upgradeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    _G.showNotification("Abrindo forja...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

fusionTab.MouseButton1Click:Connect(function()
    -- Ativar aba de fusão
    weaponTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    forgeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fusionTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    upgradeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    _G.showNotification("Abrindo fusão...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

upgradeTab.MouseButton1Click:Connect(function()
    -- Ativar aba de melhorias
    weaponTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    forgeTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    fusionTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    upgradeTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    _G.showNotification("Abrindo melhorias...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Função para abrir/fechar GUI das armas
local function toggleWeaponGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleWeaponGUI = toggleWeaponGUI

print("✅ WeaponGUI carregada com sucesso!")