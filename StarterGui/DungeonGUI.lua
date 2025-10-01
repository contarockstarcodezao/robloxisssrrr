--[[
    DUNGEON GUI
    Localização: StarterGui/DungeonGUI.lua
    
    Interface do sistema de dungeons com:
    - Lista de dungeons disponíveis
    - Detalhes da dungeon selecionada
    - Sistema de raids
    - Matchmaking
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Criar GUI das dungeons
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DungeonGUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = false
screenGui.Parent = playerGui

-- Frame principal das dungeons
local dungeonFrame = Instance.new("Frame")
dungeonFrame.Name = "DungeonFrame"
dungeonFrame.Size = UDim2.new(0, 1000, 0, 750)
dungeonFrame.Position = UDim2.new(0.5, -500, 0.5, -375)
dungeonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dungeonFrame.BorderSizePixel = 0
dungeonFrame.Parent = screenGui

-- Borda do frame
local dungeonBorder = Instance.new("Frame")
dungeonBorder.Name = "DungeonBorder"
dungeonBorder.Size = UDim2.new(1, 4, 1, 4)
dungeonBorder.Position = UDim2.new(0, -2, 0, -2)
dungeonBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
dungeonBorder.BorderSizePixel = 0
dungeonBorder.Parent = dungeonFrame

-- Título
local titleFrame = Instance.new("Frame")
titleFrame.Name = "TitleFrame"
titleFrame.Size = UDim2.new(1, 0, 0, 60)
titleFrame.Position = UDim2.new(0, 0, 0, 0)
titleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleFrame.BorderSizePixel = 0
titleFrame.Parent = dungeonFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🏰 DUNGEONS E RAIDS"
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
tabFrame.Parent = dungeonFrame

-- Aba de dungeons
local dungeonTab = Instance.new("TextButton")
dungeonTab.Name = "DungeonTab"
dungeonTab.Size = UDim2.new(0, 120, 1, 0)
dungeonTab.Position = UDim2.new(0, 0, 0, 0)
dungeonTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dungeonTab.BorderSizePixel = 0
dungeonTab.Text = "🏰 DUNGEONS"
dungeonTab.TextColor3 = Color3.fromRGB(255, 255, 255)
dungeonTab.TextScaled = true
dungeonTab.Font = Enum.Font.SourceSansBold
dungeonTab.Parent = tabFrame

-- Aba de raids
local raidTab = Instance.new("TextButton")
raidTab.Name = "RaidTab"
raidTab.Size = UDim2.new(0, 120, 1, 0)
raidTab.Position = UDim2.new(0, 120, 0, 0)
raidTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
raidTab.BorderSizePixel = 0
raidTab.Text = "⚔️ RAIDS"
raidTab.TextColor3 = Color3.fromRGB(255, 255, 255)
raidTab.TextScaled = true
raidTab.Font = Enum.Font.SourceSansBold
raidTab.Parent = tabFrame

-- Aba de matchmaking
local matchmakingTab = Instance.new("TextButton")
matchmakingTab.Name = "MatchmakingTab"
matchmakingTab.Size = UDim2.new(0, 120, 1, 0)
matchmakingTab.Position = UDim2.new(0, 240, 0, 0)
matchmakingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
matchmakingTab.BorderSizePixel = 0
matchmakingTab.Text = "🔍 MATCHMAKING"
matchmakingTab.TextColor3 = Color3.fromRGB(255, 255, 255)
matchmakingTab.TextScaled = true
matchmakingTab.Font = Enum.Font.SourceSansBold
matchmakingTab.Parent = tabFrame

-- Frame de conteúdo
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -20, 1, -120)
contentFrame.Position = UDim2.new(0, 10, 0, 110)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = dungeonFrame

-- Lista de dungeons
local dungeonList = Instance.new("ScrollingFrame")
dungeonList.Name = "DungeonList"
dungeonList.Size = UDim2.new(0, 400, 1, 0)
dungeonList.Position = UDim2.new(0, 0, 0, 0)
dungeonList.BackgroundTransparency = 1
dungeonList.BorderSizePixel = 0
dungeonList.ScrollBarThickness = 10
dungeonList.CanvasSize = UDim2.new(0, 0, 0, 0)
dungeonList.Parent = contentFrame

-- Layout da lista
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = dungeonList

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
detailsTitle.Text = "🔍 DETALHES DA DUNGEON"
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

-- Função para criar item da lista de dungeons
local function createDungeonListItem(dungeonName, dungeonType, level, difficulty, timeLimit, rewards)
    local itemFrame = Instance.new("Frame")
    itemFrame.Name = dungeonName
    itemFrame.Size = UDim2.new(1, 0, 0, 100)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    itemFrame.BorderSizePixel = 0
    itemFrame.Parent = dungeonList
    
    -- Cores baseadas na dificuldade
    local difficultyColors = {
        Easy = Color3.fromRGB(0, 255, 0),
        Normal = Color3.fromRGB(255, 255, 0),
        Hard = Color3.fromRGB(255, 150, 0),
        Expert = Color3.fromRGB(255, 0, 0),
        Master = Color3.fromRGB(128, 0, 255)
    }
    
    local borderColor = difficultyColors[difficulty] or Color3.fromRGB(128, 128, 128)
    
    -- Borda
    local border = Instance.new("Frame")
    border.Name = "Border"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundColor3 = borderColor
    border.BorderSizePixel = 0
    border.Parent = itemFrame
    
    -- Ícone da dungeon
    local dungeonIcon = Instance.new("ImageLabel")
    dungeonIcon.Name = "DungeonIcon"
    dungeonIcon.Size = UDim2.new(0, 80, 0, 80)
    dungeonIcon.Position = UDim2.new(0, 10, 0.5, -40)
    dungeonIcon.BackgroundTransparency = 1
    dungeonIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    dungeonIcon.Parent = itemFrame
    
    -- Nome da dungeon
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, -100, 0, 25)
    nameLabel.Position = UDim2.new(0, 100, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = dungeonName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = itemFrame
    
    -- Tipo e nível
    local typeLabel = Instance.new("TextLabel")
    typeLabel.Name = "TypeLabel"
    typeLabel.Size = UDim2.new(0, 150, 0, 20)
    typeLabel.Position = UDim2.new(0, 100, 0, 30)
    typeLabel.BackgroundTransparency = 1
    typeLabel.Text = dungeonType .. " | Nível: " .. level
    typeLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.SourceSans
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = itemFrame
    
    -- Dificuldade
    local difficultyLabel = Instance.new("TextLabel")
    difficultyLabel.Name = "DifficultyLabel"
    difficultyLabel.Size = UDim2.new(0, 100, 0, 20)
    difficultyLabel.Position = UDim2.new(0, 100, 0, 50)
    difficultyLabel.BackgroundTransparency = 1
    difficultyLabel.Text = "Dificuldade: " .. difficulty
    difficultyLabel.TextColor3 = borderColor
    difficultyLabel.TextScaled = true
    difficultyLabel.Font = Enum.Font.SourceSansBold
    difficultyLabel.TextXAlignment = Enum.TextXAlignment.Left
    difficultyLabel.Parent = itemFrame
    
    -- Tempo limite
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(0, 100, 0, 20)
    timeLabel.Position = UDim2.new(0, 210, 0, 50)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Tempo: " .. timeLimit .. "min"
    timeLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.SourceSans
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = itemFrame
    
    -- Recompensas
    local rewardsLabel = Instance.new("TextLabel")
    rewardsLabel.Name = "RewardsLabel"
    rewardsLabel.Size = UDim2.new(1, -100, 0, 20)
    rewardsLabel.Position = UDim2.new(0, 100, 0, 70)
    rewardsLabel.BackgroundTransparency = 1
    rewardsLabel.Text = "Recompensas: " .. rewards
    rewardsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rewardsLabel.TextScaled = true
    rewardsLabel.Font = Enum.Font.SourceSans
    rewardsLabel.TextXAlignment = Enum.TextXAlignment.Left
    rewardsLabel.Parent = itemFrame
    
    -- Efeito hover
    itemFrame.MouseEnter:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)})
        tween:Play()
    end)
    
    itemFrame.MouseLeave:Connect(function()
        local tween = TweenService:Create(itemFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)})
        tween:Play()
    end)
    
    -- Selecionar dungeon
    itemFrame.MouseButton1Click:Connect(function()
        showDungeonDetails(dungeonName, dungeonType, level, difficulty, timeLimit, rewards)
    end)
    
    return itemFrame
end

-- Função para mostrar detalhes da dungeon
local function showDungeonDetails(dungeonName, dungeonType, level, difficulty, timeLimit, rewards)
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
    
    -- Nome da dungeon
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 40)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = dungeonName
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
    typeLabel.Text = "Tipo: " .. dungeonType
    typeLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
    typeLabel.TextScaled = true
    typeLabel.Font = Enum.Font.SourceSansBold
    typeLabel.TextXAlignment = Enum.TextXAlignment.Left
    typeLabel.Parent = infoFrame
    
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
    
    -- Dificuldade
    local difficultyLabel = Instance.new("TextLabel")
    difficultyLabel.Name = "DifficultyLabel"
    difficultyLabel.Size = UDim2.new(0.5, 0, 0, 30)
    difficultyLabel.Position = UDim2.new(0, 0, 0, 70)
    difficultyLabel.BackgroundTransparency = 1
    difficultyLabel.Text = "Dificuldade: " .. difficulty
    difficultyLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    difficultyLabel.TextScaled = true
    difficultyLabel.Font = Enum.Font.SourceSansBold
    difficultyLabel.TextXAlignment = Enum.TextXAlignment.Left
    difficultyLabel.Parent = infoFrame
    
    -- Tempo limite
    local timeLabel = Instance.new("TextLabel")
    timeLabel.Name = "TimeLabel"
    timeLabel.Size = UDim2.new(0.5, 0, 0, 30)
    timeLabel.Position = UDim2.new(0.5, 0, 0, 70)
    timeLabel.BackgroundTransparency = 1
    timeLabel.Text = "Tempo: " .. timeLimit .. "min"
    timeLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
    timeLabel.TextScaled = true
    timeLabel.Font = Enum.Font.SourceSansBold
    timeLabel.TextXAlignment = Enum.TextXAlignment.Left
    timeLabel.Parent = infoFrame
    
    -- Recompensas
    local rewardsLabel = Instance.new("TextLabel")
    rewardsLabel.Name = "RewardsLabel"
    rewardsLabel.Size = UDim2.new(1, 0, 0, 60)
    rewardsLabel.Position = UDim2.new(0, 0, 0, 100)
    rewardsLabel.BackgroundTransparency = 1
    rewardsLabel.Text = "Recompensas: " .. rewards
    rewardsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rewardsLabel.TextScaled = true
    rewardsLabel.Font = Enum.Font.SourceSans
    rewardsLabel.TextXAlignment = Enum.TextXAlignment.Left
    rewardsLabel.TextYAlignment = Enum.TextYAlignment.Top
    rewardsLabel.Parent = infoFrame
    
    -- Frame de ações
    local actionsFrame = Instance.new("Frame")
    actionsFrame.Name = "ActionsFrame"
    actionsFrame.Size = UDim2.new(1, 0, 0, 100)
    actionsFrame.Position = UDim2.new(0, 0, 0, 210)
    actionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    actionsFrame.BorderSizePixel = 0
    actionsFrame.Parent = detailsContent
    
    -- Botão de entrar
    local enterButton = Instance.new("TextButton")
    enterButton.Name = "EnterButton"
    enterButton.Size = UDim2.new(0, 120, 0, 40)
    enterButton.Position = UDim2.new(0, 10, 0, 10)
    enterButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    enterButton.BorderSizePixel = 0
    enterButton.Text = "Entrar"
    enterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    enterButton.TextScaled = true
    enterButton.Font = Enum.Font.SourceSansBold
    enterButton.Parent = actionsFrame
    
    -- Botão de criar grupo
    local createGroupButton = Instance.new("TextButton")
    createGroupButton.Name = "CreateGroupButton"
    createGroupButton.Size = UDim2.new(0, 120, 0, 40)
    createGroupButton.Position = UDim2.new(0, 140, 0, 10)
    createGroupButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    createGroupButton.BorderSizePixel = 0
    createGroupButton.Text = "Criar Grupo"
    createGroupButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    createGroupButton.TextScaled = true
    createGroupButton.Font = Enum.Font.SourceSansBold
    createGroupButton.Parent = actionsFrame
    
    -- Botão de matchmaking
    local matchmakingButton = Instance.new("TextButton")
    matchmakingButton.Name = "MatchmakingButton"
    matchmakingButton.Size = UDim2.new(0, 120, 0, 40)
    matchmakingButton.Position = UDim2.new(0, 270, 0, 10)
    matchmakingButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
    matchmakingButton.BorderSizePixel = 0
    matchmakingButton.Text = "Matchmaking"
    matchmakingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    matchmakingButton.TextScaled = true
    matchmakingButton.Font = Enum.Font.SourceSansBold
    matchmakingButton.Parent = actionsFrame
    
    -- Conectar eventos dos botões
    enterButton.MouseButton1Click:Connect(function()
        _G.showNotification("Entrando na dungeon...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    createGroupButton.MouseButton1Click:Connect(function()
        _G.showNotification("Criando grupo...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    matchmakingButton.MouseButton1Click:Connect(function()
        _G.showNotification("Procurando grupo...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
    end)
    
    -- Atualizar tamanho do canvas
    detailsContent.CanvasSize = UDim2.new(0, 0, 0, 320)
end

-- Adicionar dungeons de exemplo
createDungeonListItem("Forest Dungeon", "Solo", 1, "Easy", 5, "Cash, XP, Iron Sword")
createDungeonListItem("Cave Dungeon", "Solo", 5, "Normal", 10, "Cash, XP, Steel Sword")
createDungeonListItem("Volcano Dungeon", "Party", 10, "Hard", 15, "Cash, XP, Dragon Blade")
createDungeonListItem("Shadow Realm", "Raid", 20, "Expert", 30, "Cash, XP, Excalibur, Diamonds")
createDungeonListItem("Abyss Dungeon", "Raid", 30, "Master", 45, "Cash, XP, Legendary Items, Diamonds")

-- Atualizar tamanho do canvas da lista
dungeonList.CanvasSize = UDim2.new(0, 0, 0, 5 * 105)

-- Conectar eventos das abas
dungeonTab.MouseButton1Click:Connect(function()
    -- Ativar aba de dungeons
    dungeonTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    raidTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    matchmakingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

raidTab.MouseButton1Click:Connect(function()
    -- Ativar aba de raids
    dungeonTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    raidTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    matchmakingTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    
    _G.showNotification("Abrindo raids...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

matchmakingTab.MouseButton1Click:Connect(function()
    -- Ativar aba de matchmaking
    dungeonTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    raidTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    matchmakingTab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    _G.showNotification("Abrindo matchmaking...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 2)
end)

-- Conectar evento de fechar
closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Função para abrir/fechar GUI das dungeons
local function toggleDungeonGUI()
    screenGui.Enabled = not screenGui.Enabled
end

-- Exportar função
_G.toggleDungeonGUI = toggleDungeonGUI

print("✅ DungeonGUI carregada com sucesso!")