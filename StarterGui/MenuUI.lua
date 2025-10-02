-- StarterGui/MenuUI (LocalScript)
-- Menu detalhado com estatísticas, conquistas, inventário

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Módulos
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local RelicData = require(ReplicatedStorage.Modules.RelicData)

-- Dados do jogador
local playerData = nil

-- Estado do menu
local menuOpen = false
local currentTab = "Stats"

-- ============================
-- REQUISITAR DADOS
-- ============================

local function RequestPlayerData()
	local success, data = pcall(function()
		return RemoteEvents.RequestData:InvokeServer()
	end)
	
	if success and data then
		playerData = data
		return true
	end
	return false
end

-- ============================
-- CRIAR MENU PRINCIPAL
-- ============================

local function CreateMenu()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "MenuUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- Container principal (escondido por padrão)
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 900, 0, 600)
	mainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = screenGui
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 15)
	mainCorner.Parent = mainFrame
	
	-- Header
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 60)
	header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	header.BorderSizePixel = 0
	header.Parent = mainFrame
	
	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 15)
	headerCorner.Parent = header
	
	local headerTitle = Instance.new("TextLabel")
	headerTitle.Size = UDim2.new(1, -120, 1, 0)
	headerTitle.Position = UDim2.new(0, 20, 0, 0)
	headerTitle.BackgroundTransparency = 1
	headerTitle.Text = "📊 PERFIL DO JOGADOR"
	headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	headerTitle.TextSize = 24
	headerTitle.Font = Enum.Font.GothamBold
	headerTitle.TextXAlignment = Enum.TextXAlignment.Left
	headerTitle.Parent = header
	
	-- Botão fechar
	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 50, 0, 40)
	closeButton.Position = UDim2.new(1, -60, 0, 10)
	closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	closeButton.BorderSizePixel = 0
	closeButton.Text = "✕"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.TextSize = 20
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Parent = header
	
	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 10)
	closeCorner.Parent = closeButton
	
	closeButton.MouseButton1Click:Connect(function()
		ToggleMenu(mainFrame)
	end)
	
	-- Navegação (Tabs)
	local tabsFrame = Instance.new("Frame")
	tabsFrame.Name = "Tabs"
	tabsFrame.Size = UDim2.new(0, 200, 1, -70)
	tabsFrame.Position = UDim2.new(0, 10, 0, 65)
	tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	tabsFrame.BorderSizePixel = 0
	tabsFrame.Parent = mainFrame
	
	local tabsCorner = Instance.new("UICorner")
	tabsCorner.CornerRadius = UDim.new(0, 12)
	tabsCorner.Parent = tabsFrame
	
	-- Conteúdo
	local contentFrame = Instance.new("Frame")
	contentFrame.Name = "Content"
	contentFrame.Size = UDim2.new(1, -230, 1, -70)
	contentFrame.Position = UDim2.new(0, 220, 0, 65)
	contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	contentFrame.BorderSizePixel = 0
	contentFrame.Parent = mainFrame
	
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 12)
	contentCorner.Parent = contentFrame
	
	-- Criar tabs
	CreateTabs(tabsFrame, contentFrame)
	
	return mainFrame
end

-- ============================
-- CRIAR TABS DE NAVEGAÇÃO
-- ============================

function CreateTabs(tabsFrame, contentFrame)
	local tabs = {
		{Name = "Stats", Icon = "📊", Label = "Estatísticas"},
		{Name = "Achievements", Icon = "🏆", Label = "Conquistas"},
		{Name = "Inventory", Icon = "🎒", Label = "Inventário"},
		{Name = "Shadows", Icon = "🧞‍♂️", Label = "Sombras"},
	}
	
	local tabButtons = {}
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.Parent = tabsFrame
	
	for i, tab in ipairs(tabs) do
		local button = Instance.new("TextButton")
		button.Name = tab.Name
		button.Size = UDim2.new(1, -10, 0, 50)
		button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		button.BorderSizePixel = 0
		button.Text = tab.Icon .. " " .. tab.Label
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextSize = 16
		button.Font = Enum.Font.GothamSemibold
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.AutoButtonColor = false
		button.Parent = tabsFrame
		
		-- Padding interno
		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 15)
		padding.Parent = button
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = button
		
		tabButtons[tab.Name] = button
		
		button.MouseButton1Click:Connect(function()
			currentTab = tab.Name
			UpdateTabSelection(tabButtons, contentFrame)
		end)
		
		button.MouseEnter:Connect(function()
			if currentTab ~= tab.Name then
				button.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
			end
		end)
		
		button.MouseLeave:Connect(function()
			UpdateTabSelection(tabButtons, contentFrame)
		end)
	end
	
	UpdateTabSelection(tabButtons, contentFrame)
end

function UpdateTabSelection(tabButtons, contentFrame)
	for tabName, button in pairs(tabButtons) do
		if tabName == currentTab then
			button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
			button.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end
	
	-- Atualizar conteúdo
	UpdateContent(contentFrame)
end

-- ============================
-- ATUALIZAR CONTEÚDO
-- ============================

function UpdateContent(contentFrame)
	-- Limpar conteúdo anterior
	for _, child in ipairs(contentFrame:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	
	if not playerData then return end
	
	if currentTab == "Stats" then
		CreateStatsContent(contentFrame)
	elseif currentTab == "Achievements" then
		CreateAchievementsContent(contentFrame)
	elseif currentTab == "Inventory" then
		CreateInventoryContent(contentFrame)
	elseif currentTab == "Shadows" then
		CreateShadowsContent(contentFrame)
	end
end

-- ============================
-- CONTEÚDO: ESTATÍSTICAS
-- ============================

function CreateStatsContent(parent)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -20)
	scrollFrame.Position = UDim2.new(0, 10, 0, 10)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.Parent = parent
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = scrollFrame
	
	-- Título
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "📊 SUAS ESTATÍSTICAS"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = scrollFrame
	
	-- Stats
	local stats = {
		{Label = "⚔️ Inimigos Derrotados", Value = playerData.Stats.TotalKills},
		{Label = "💀 Chefes Derrotados", Value = playerData.Stats.BossKills},
		{Label = "🧞‍♂️ Sombras Capturadas", Value = playerData.Stats.ShadowsCaptured},
		{Label = "🏰 Dungeons Completas", Value = playerData.Stats.DungeonsCompleted},
		{Label = "⚡ Raids Completas", Value = playerData.Stats.RaidsCompleted},
		{Label = "🏆 Vitórias em Raids", Value = playerData.Stats.RaidWins},
		{Label = "💥 Dano Causado", Value = UtilityFunctions:FormatNumber(playerData.Stats.DamageDealt, true)},
		{Label = "💔 Dano Recebido", Value = UtilityFunctions:FormatNumber(playerData.Stats.DamageTaken, true)},
		{Label = "☠️ Mortes", Value = playerData.Stats.DeathCount},
		{Label = "⏰ Tempo Jogado", Value = UtilityFunctions:FormatTime(playerData.PlayTime)},
	}
	
	for _, stat in ipairs(stats) do
		local statFrame = Instance.new("Frame")
		statFrame.Size = UDim2.new(1, 0, 0, 50)
		statFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
		statFrame.BorderSizePixel = 0
		statFrame.Parent = scrollFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = statFrame
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.6, 0, 1, 0)
		label.Position = UDim2.new(0, 15, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = stat.Label
		label.TextColor3 = Color3.fromRGB(220, 220, 220)
		label.TextSize = 16
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = statFrame
		
		local value = Instance.new("TextLabel")
		value.Size = UDim2.new(0.4, -15, 1, 0)
		value.Position = UDim2.new(0.6, 0, 0, 0)
		value.BackgroundTransparency = 1
		value.Text = tostring(stat.Value)
		value.TextColor3 = Color3.fromRGB(100, 200, 255)
		value.TextSize = 18
		value.Font = Enum.Font.GothamBold
		value.TextXAlignment = Enum.TextXAlignment.Right
		value.Parent = statFrame
	end
	
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- ============================
-- CONTEÚDO: CONQUISTAS
-- ============================

function CreateAchievementsContent(parent)
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -20, 1, -20)
	scrollFrame.Position = UDim2.new(0, 10, 0, 10)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 8
	scrollFrame.Parent = parent
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = scrollFrame
	
	-- Título
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundTransparency = 1
	title.Text = "🏆 CONQUISTAS (" .. #playerData.Achievements .. "/" .. #GameConfig.Achievements .. ")"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 22
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = scrollFrame
	
	-- Listar conquistas
	for _, achievement in ipairs(GameConfig.Achievements) do
		local unlocked = table.find(playerData.Achievements, achievement.ID) ~= nil
		
		local achFrame = Instance.new("Frame")
		achFrame.Size = UDim2.new(1, 0, 0, 80)
		achFrame.BackgroundColor3 = unlocked and Color3.fromRGB(40, 80, 40) or Color3.fromRGB(35, 35, 40)
		achFrame.BorderSizePixel = 0
		achFrame.Parent = scrollFrame
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = achFrame
		
		-- Ícone
		local icon = Instance.new("TextLabel")
		icon.Size = UDim2.new(0, 60, 0, 60)
		icon.Position = UDim2.new(0, 10, 0, 10)
		icon.BackgroundTransparency = 1
		icon.Text = achievement.Icon
		icon.TextSize = 32
		icon.Parent = achFrame
		
		-- Nome
		local name = Instance.new("TextLabel")
		name.Size = UDim2.new(1, -80, 0, 30)
		name.Position = UDim2.new(0, 75, 0, 10)
		name.BackgroundTransparency = 1
		name.Text = achievement.Name .. (unlocked and " ✓" or " 🔒")
		name.TextColor3 = unlocked and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(150, 150, 150)
		name.TextSize = 16
		name.Font = Enum.Font.GothamBold
		name.TextXAlignment = Enum.TextXAlignment.Left
		name.Parent = achFrame
		
		-- Descrição
		local desc = Instance.new("TextLabel")
		desc.Size = UDim2.new(1, -80, 0, 40)
		desc.Position = UDim2.new(0, 75, 0, 35)
		desc.BackgroundTransparency = 1
		desc.Text = achievement.Description
		desc.TextColor3 = Color3.fromRGB(200, 200, 200)
		desc.TextSize = 13
		desc.Font = Enum.Font.Gotham
		desc.TextXAlignment = Enum.TextXAlignment.Left
		desc.TextWrapped = true
		desc.Parent = achFrame
	end
	
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end

-- ============================
-- CONTEÚDO: INVENTÁRIO
-- ============================

function CreateInventoryContent(parent)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "🎒 INVENTÁRIO (Em breve)"
	title.TextColor3 = Color3.fromRGB(200, 200, 200)
	title.TextSize = 20
	title.Font = Enum.Font.GothamBold
	title.Parent = parent
end

-- ============================
-- CONTEÚDO: SOMBRAS
-- ============================

function CreateShadowsContent(parent)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundTransparency = 1
	title.Text = "🧞‍♂️ SOMBRAS (" .. #playerData.Shadows .. "/" .. playerData.ShadowSlots .. ")"
	title.TextColor3 = Color3.fromRGB(200, 200, 200)
	title.TextSize = 20
	title.Font = Enum.Font.GothamBold
	title.Parent = parent
end

-- ============================
-- TOGGLE MENU
-- ============================

function ToggleMenu(mainFrame)
	menuOpen = not menuOpen
	mainFrame.Visible = menuOpen
	
	if menuOpen then
		RequestPlayerData()
		UpdateContent(mainFrame.Content)
	end
end

-- ============================
-- INPUT (TAB para abrir)
-- ============================

local menuFrame = CreateMenu()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Tab then
		ToggleMenu(menuFrame)
	end
end)

-- Atualizar dados do servidor
RemoteEvents.DataUpdate.OnClientEvent:Connect(function(key, value)
	if key == "FullData" then
		playerData = value
	elseif playerData then
		playerData[key] = value
	end
end)

-- Inicialização
RequestPlayerData()

print("✅ Menu UI inicializado!")
