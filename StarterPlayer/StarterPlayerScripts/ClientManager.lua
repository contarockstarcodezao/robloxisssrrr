--[[
    CLIENT MANAGER
    Localização: StarterPlayer/StarterPlayerScripts/ClientManager.lua
    
    Este script gerencia o cliente principal:
    - Inicialização de interfaces
    - Conexão com eventos
    - Gerenciamento de estado
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Importar eventos
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local ClientManager = {}

-- Estado do cliente
local clientState = {
    isInitialized = false,
    currentInterface = nil,
    playerData = {},
    uiElements = {}
}

-- Inicializar cliente
function ClientManager.Initialize()
    if clientState.isInitialized then
        return
    end
    
    print("Inicializando cliente...")
    
    -- Criar interfaces principais
    ClientManager.CreateMainUI()
    ClientManager.CreateCombatUI()
    ClientManager.CreateInventoryUI()
    ClientManager.CreateShadowUI()
    ClientManager.CreateWeaponUI()
    ClientManager.CreateRelicUI()
    ClientManager.CreateDungeonUI()
    ClientManager.CreateRankingUI()
    
    -- Conectar eventos
    ClientManager.ConnectEvents()
    
    -- Inicializar sistemas
    ClientManager.InitializeSystems()
    
    clientState.isInitialized = true
    print("Cliente inicializado com sucesso!")
end

-- Criar interface principal
function ClientManager.CreateMainUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MainUI"
    screenGui.Parent = playerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui
    
    -- Barra de status
    local statusBar = Instance.new("Frame")
    statusBar.Name = "StatusBar"
    statusBar.Size = UDim2.new(1, 0, 0, 60)
    statusBar.Position = UDim2.new(0, 0, 0, 0)
    statusBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    statusBar.BorderSizePixel = 0
    statusBar.Parent = mainFrame
    
    -- Informações do jogador
    local playerInfo = Instance.new("Frame")
    playerInfo.Name = "PlayerInfo"
    playerInfo.Size = UDim2.new(0, 200, 1, 0)
    playerInfo.Position = UDim2.new(0, 10, 0, 0)
    playerInfo.BackgroundTransparency = 1
    playerInfo.Parent = statusBar
    
    -- Nível do jogador
    local levelLabel = Instance.new("TextLabel")
    levelLabel.Name = "LevelLabel"
    levelLabel.Size = UDim2.new(1, 0, 0.5, 0)
    levelLabel.Position = UDim2.new(0, 0, 0, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Nível: 1"
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.TextScaled = true
    levelLabel.Font = Enum.Font.SourceSansBold
    levelLabel.Parent = playerInfo
    
    -- XP do jogador
    local xpLabel = Instance.new("TextLabel")
    xpLabel.Name = "XPLabel"
    xpLabel.Size = UDim2.new(1, 0, 0.5, 0)
    xpLabel.Position = UDim2.new(0, 0, 0.5, 0)
    xpLabel.BackgroundTransparency = 1
    xpLabel.Text = "XP: 0/100"
    xpLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    xpLabel.TextScaled = true
    xpLabel.Font = Enum.Font.SourceSans
    xpLabel.Parent = playerInfo
    
    -- Moedas
    local currencyFrame = Instance.new("Frame")
    currencyFrame.Name = "CurrencyFrame"
    currencyFrame.Size = UDim2.new(0, 200, 1, 0)
    currencyFrame.Position = UDim2.new(1, -210, 0, 0)
    currencyFrame.BackgroundTransparency = 1
    currencyFrame.Parent = statusBar
    
    -- Cash
    local cashLabel = Instance.new("TextLabel")
    cashLabel.Name = "CashLabel"
    cashLabel.Size = UDim2.new(1, 0, 0.5, 0)
    cashLabel.Position = UDim2.new(0, 0, 0, 0)
    cashLabel.BackgroundTransparency = 1
    cashLabel.Text = "Cash: 1000"
    cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    cashLabel.TextScaled = true
    cashLabel.Font = Enum.Font.SourceSansBold
    cashLabel.Parent = currencyFrame
    
    -- Diamantes
    local diamondsLabel = Instance.new("TextLabel")
    diamondsLabel.Name = "DiamondsLabel"
    diamondsLabel.Size = UDim2.new(1, 0, 0.5, 0)
    diamondsLabel.Position = UDim2.new(0, 0, 0.5, 0)
    diamondsLabel.BackgroundTransparency = 1
    diamondsLabel.Text = "Diamantes: 10"
    diamondsLabel.TextColor3 = Color3.fromRGB(0, 191, 255)
    diamondsLabel.TextScaled = true
    diamondsLabel.Font = Enum.Font.SourceSansBold
    diamondsLabel.Parent = currencyFrame
    
    -- Botões de interface
    local buttonFrame = Instance.new("Frame")
    buttonFrame.Name = "ButtonFrame"
    buttonFrame.Size = UDim2.new(0, 400, 1, 0)
    buttonFrame.Position = UDim2.new(0.5, -200, 0, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = statusBar
    
    -- Botão de inventário
    local inventoryButton = Instance.new("TextButton")
    inventoryButton.Name = "InventoryButton"
    inventoryButton.Size = UDim2.new(0, 80, 0, 40)
    inventoryButton.Position = UDim2.new(0, 0, 0.5, -20)
    inventoryButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    inventoryButton.BorderSizePixel = 0
    inventoryButton.Text = "Inventário"
    inventoryButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    inventoryButton.TextScaled = true
    inventoryButton.Font = Enum.Font.SourceSansBold
    inventoryButton.Parent = buttonFrame
    
    -- Botão de sombras
    local shadowButton = Instance.new("TextButton")
    shadowButton.Name = "ShadowButton"
    shadowButton.Size = UDim2.new(0, 80, 0, 40)
    shadowButton.Position = UDim2.new(0, 90, 0.5, -20)
    shadowButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    shadowButton.BorderSizePixel = 0
    shadowButton.Text = "Sombras"
    shadowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    shadowButton.TextScaled = true
    shadowButton.Font = Enum.Font.SourceSansBold
    shadowButton.Parent = buttonFrame
    
    -- Botão de armas
    local weaponButton = Instance.new("TextButton")
    weaponButton.Name = "WeaponButton"
    weaponButton.Size = UDim2.new(0, 80, 0, 40)
    weaponButton.Position = UDim2.new(0, 180, 0.5, -20)
    weaponButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    weaponButton.BorderSizePixel = 0
    weaponButton.Text = "Armas"
    weaponButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    weaponButton.TextScaled = true
    weaponButton.Font = Enum.Font.SourceSansBold
    weaponButton.Parent = buttonFrame
    
    -- Botão de relíquias
    local relicButton = Instance.new("TextButton")
    relicButton.Name = "RelicButton"
    relicButton.Size = UDim2.new(0, 80, 0, 40)
    relicButton.Position = UDim2.new(0, 270, 0.5, -20)
    relicButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    relicButton.BorderSizePixel = 0
    relicButton.Text = "Relíquias"
    relicButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    relicButton.TextScaled = true
    relicButton.Font = Enum.Font.SourceSansBold
    relicButton.Parent = buttonFrame
    
    -- Botão de ranking
    local rankingButton = Instance.new("TextButton")
    rankingButton.Name = "RankingButton"
    rankingButton.Size = UDim2.new(0, 80, 0, 40)
    rankingButton.Position = UDim2.new(0, 360, 0.5, -20)
    rankingButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    rankingButton.BorderSizePixel = 0
    rankingButton.Text = "Ranking"
    rankingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    rankingButton.TextScaled = true
    rankingButton.Font = Enum.Font.SourceSansBold
    rankingButton.Parent = buttonFrame
    
    clientState.uiElements.mainUI = screenGui
end

-- Criar interface de combate
function ClientManager.CreateCombatUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CombatUI"
    screenGui.Parent = playerGui
    
    -- Frame de combate
    local combatFrame = Instance.new("Frame")
    combatFrame.Name = "CombatFrame"
    combatFrame.Size = UDim2.new(0, 200, 0, 100)
    combatFrame.Position = UDim2.new(1, -210, 1, -110)
    combatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    combatFrame.BorderSizePixel = 0
    combatFrame.Parent = screenGui
    
    -- Barra de vida
    local healthBar = Instance.new("Frame")
    healthBar.Name = "HealthBar"
    healthBar.Size = UDim2.new(1, -10, 0, 20)
    healthBar.Position = UDim2.new(0, 5, 0, 5)
    healthBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthBar.BorderSizePixel = 0
    healthBar.Parent = combatFrame
    
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.Position = UDim2.new(0, 0, 0, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBar
    
    -- Barra de mana
    local manaBar = Instance.new("Frame")
    manaBar.Name = "ManaBar"
    manaBar.Size = UDim2.new(1, -10, 0, 20)
    manaBar.Position = UDim2.new(0, 5, 0, 30)
    manaBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    manaBar.BorderSizePixel = 0
    manaBar.Parent = combatFrame
    
    local manaFill = Instance.new("Frame")
    manaFill.Name = "ManaFill"
    manaFill.Size = UDim2.new(1, 0, 1, 0)
    manaFill.Position = UDim2.new(0, 0, 0, 0)
    manaFill.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    manaFill.BorderSizePixel = 0
    manaFill.Parent = manaBar
    
    -- Botão de ataque
    local attackButton = Instance.new("TextButton")
    attackButton.Name = "AttackButton"
    attackButton.Size = UDim2.new(0, 80, 0, 40)
    attackButton.Position = UDim2.new(0, 5, 0, 55)
    attackButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    attackButton.BorderSizePixel = 0
    attackButton.Text = "Atacar"
    attackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    attackButton.TextScaled = true
    attackButton.Font = Enum.Font.SourceSansBold
    attackButton.Parent = combatFrame
    
    -- Botão de habilidade
    local skillButton = Instance.new("TextButton")
    skillButton.Name = "SkillButton"
    skillButton.Size = UDim2.new(0, 80, 0, 40)
    skillButton.Position = UDim2.new(0, 95, 0, 55)
    skillButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
    skillButton.BorderSizePixel = 0
    skillButton.Text = "Habilidade"
    skillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    skillButton.TextScaled = true
    skillButton.Font = Enum.Font.SourceSansBold
    skillButton.Parent = combatFrame
    
    clientState.uiElements.combatUI = screenGui
end

-- Criar interface de inventário
function ClientManager.CreateInventoryUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "InventoryUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal do inventário
    local inventoryFrame = Instance.new("Frame")
    inventoryFrame.Name = "InventoryFrame"
    inventoryFrame.Size = UDim2.new(0, 800, 0, 600)
    inventoryFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    inventoryFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    inventoryFrame.BorderSizePixel = 0
    inventoryFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Inventário"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = inventoryFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = inventoryFrame
    
    -- Abas
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0, 0, 0, 50)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = inventoryFrame
    
    -- Aba de armas
    local weaponTab = Instance.new("TextButton")
    weaponTab.Name = "WeaponTab"
    weaponTab.Size = UDim2.new(0, 100, 1, 0)
    weaponTab.Position = UDim2.new(0, 0, 0, 0)
    weaponTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    weaponTab.BorderSizePixel = 0
    weaponTab.Text = "Armas"
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
    shadowTab.Text = "Sombras"
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
    relicTab.Text = "Relíquias"
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
    relicTab.BorderSizePixel = 0
    potionTab.Text = "Poções"
    potionTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    potionTab.TextScaled = true
    potionTab.Font = Enum.Font.SourceSansBold
    potionTab.Parent = tabFrame
    
    -- Conteúdo do inventário
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
    itemGrid.Parent = contentFrame
    
    clientState.uiElements.inventoryUI = screenGui
end

-- Criar interface de sombras
function ClientManager.CreateShadowUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShadowUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal das sombras
    local shadowFrame = Instance.new("Frame")
    shadowFrame.Name = "ShadowFrame"
    shadowFrame.Size = UDim2.new(0, 900, 0, 700)
    shadowFrame.Position = UDim2.new(0.5, -450, 0.5, -350)
    shadowFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    shadowFrame.BorderSizePixel = 0
    shadowFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Sistema de Sombras"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = shadowFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = shadowFrame
    
    -- Lista de sombras
    local shadowList = Instance.new("ScrollingFrame")
    shadowList.Name = "ShadowList"
    shadowList.Size = UDim2.new(0.5, -10, 1, -60)
    shadowList.Position = UDim2.new(0, 10, 0, 60)
    shadowList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    shadowList.BorderSizePixel = 0
    shadowList.ScrollBarThickness = 10
    shadowList.Parent = shadowFrame
    
    -- Detalhes da sombra
    local shadowDetails = Instance.new("Frame")
    shadowDetails.Name = "ShadowDetails"
    shadowDetails.Size = UDim2.new(0.5, -10, 1, -60)
    shadowDetails.Position = UDim2.new(0.5, 0, 0, 60)
    shadowDetails.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    shadowDetails.BorderSizePixel = 0
    shadowDetails.Parent = shadowFrame
    
    clientState.uiElements.shadowUI = screenGui
end

-- Criar interface de armas
function ClientManager.CreateWeaponUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WeaponUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal das armas
    local weaponFrame = Instance.new("Frame")
    weaponFrame.Name = "WeaponFrame"
    weaponFrame.Size = UDim2.new(0, 800, 0, 600)
    weaponFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    weaponFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    weaponFrame.BorderSizePixel = 0
    weaponFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Sistema de Armas"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = weaponFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = weaponFrame
    
    clientState.uiElements.weaponUI = screenGui
end

-- Criar interface de relíquias
function ClientManager.CreateRelicUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RelicUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal das relíquias
    local relicFrame = Instance.new("Frame")
    relicFrame.Name = "RelicFrame"
    relicFrame.Size = UDim2.new(0, 800, 0, 600)
    relicFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    relicFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    relicFrame.BorderSizePixel = 0
    relicFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Sistema de Relíquias"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = relicFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = relicFrame
    
    clientState.uiElements.relicUI = screenGui
end

-- Criar interface de dungeons
function ClientManager.CreateDungeonUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DungeonUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal das dungeons
    local dungeonFrame = Instance.new("Frame")
    dungeonFrame.Name = "DungeonFrame"
    dungeonFrame.Size = UDim2.new(0, 800, 0, 600)
    dungeonFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    dungeonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    dungeonFrame.BorderSizePixel = 0
    dungeonFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Dungeons e Raids"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = dungeonFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = dungeonFrame
    
    clientState.uiElements.dungeonUI = screenGui
end

-- Criar interface de ranking
function ClientManager.CreateRankingUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RankingUI"
    screenGui.Parent = playerGui
    screenGui.Enabled = false
    
    -- Frame principal do ranking
    local rankingFrame = Instance.new("Frame")
    rankingFrame.Name = "RankingFrame"
    rankingFrame.Size = UDim2.new(0, 800, 0, 600)
    rankingFrame.Position = UDim2.new(0.5, -400, 0.5, -300)
    rankingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    rankingFrame.BorderSizePixel = 0
    rankingFrame.Parent = screenGui
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    titleLabel.BorderSizePixel = 0
    titleLabel.Text = "Ranking e Leaderboard"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    titleLabel.Parent = rankingFrame
    
    -- Botão de fechar
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.Parent = rankingFrame
    
    clientState.uiElements.rankingUI = screenGui
end

-- Conectar eventos
function ClientManager.ConnectEvents()
    -- Conectar eventos de interface
    local mainUI = clientState.uiElements.mainUI
    if mainUI then
        local inventoryButton = mainUI.MainUI.StatusBar.ButtonFrame.InventoryButton
        local shadowButton = mainUI.MainUI.StatusBar.ButtonFrame.ShadowButton
        local weaponButton = mainUI.MainUI.StatusBar.ButtonFrame.WeaponButton
        local relicButton = mainUI.MainUI.StatusBar.ButtonFrame.RelicButton
        local rankingButton = mainUI.MainUI.StatusBar.ButtonFrame.RankingButton
        
        inventoryButton.MouseButton1Click:Connect(function()
            ClientManager.ToggleInterface("inventory")
        end)
        
        shadowButton.MouseButton1Click:Connect(function()
            ClientManager.ToggleInterface("shadow")
        end)
        
        weaponButton.MouseButton1Click:Connect(function()
            ClientManager.ToggleInterface("weapon")
        end)
        
        relicButton.MouseButton1Click:Connect(function()
            ClientManager.ToggleInterface("relic")
        end)
        
        rankingButton.MouseButton1Click:Connect(function()
            ClientManager.ToggleInterface("ranking")
        end)
    end
    
    -- Conectar eventos de fechamento
    for name, ui in pairs(clientState.uiElements) do
        if ui:FindFirstChild("CloseButton") then
            ui.CloseButton.MouseButton1Click:Connect(function()
                ClientManager.CloseInterface(name)
            end)
        end
    end
end

-- Inicializar sistemas
function ClientManager.InitializeSystems()
    -- TODO: Inicializar sistemas específicos
    print("Sistemas inicializados!")
end

-- Alternar interface
function ClientManager.ToggleInterface(interfaceName)
    local ui = clientState.uiElements[interfaceName .. "UI"]
    if ui then
        if ui.Enabled then
            ClientManager.CloseInterface(interfaceName)
        else
            ClientManager.OpenInterface(interfaceName)
        end
    end
end

-- Abrir interface
function ClientManager.OpenInterface(interfaceName)
    local ui = clientState.uiElements[interfaceName .. "UI"]
    if ui then
        ui.Enabled = true
        clientState.currentInterface = interfaceName
    end
end

-- Fechar interface
function ClientManager.CloseInterface(interfaceName)
    local ui = clientState.uiElements[interfaceName .. "UI"]
    if ui then
        ui.Enabled = false
        if clientState.currentInterface == interfaceName then
            clientState.currentInterface = nil
        end
    end
end

-- Inicializar quando o script carregar
ClientManager.Initialize()

return ClientManager