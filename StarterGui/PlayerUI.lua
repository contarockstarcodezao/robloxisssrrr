-- StarterGui/PlayerUI (LocalScript)
-- Interface completa do jogador com todas as informações

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Módulos
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)

-- Dados do jogador (cache local)
local playerData = nil

-- UI References
local mainUI = nil
local menuOpen = false

-- ============================
-- REQUISITAR DADOS DO SERVIDOR
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
-- CRIAR UI PRINCIPAL
-- ============================

local function CreateMainUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PlayerUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = playerGui
	
	-- ========== HUD PRINCIPAL (sempre visível) ==========
	CreateHUD(screenGui)
	
	-- ========== MENU PRINCIPAL (toggle com TAB) ==========
	CreateMainMenu(screenGui)
	
	return screenGui
end

-- ============================
-- HUD PRINCIPAL
-- ============================

function CreateHUD(parent)
	local hudFrame = Instance.new("Frame")
	hudFrame.Name = "HUD"
	hudFrame.Size = UDim2.new(1, 0, 1, 0)
	hudFrame.BackgroundTransparency = 1
	hudFrame.Parent = parent
	
	-- ===== PAINEL DE STATUS (canto superior esquerdo) =====
	local statusPanel = Instance.new("Frame")
	statusPanel.Name = "StatusPanel"
	statusPanel.Size = UDim2.new(0, 280, 0, 140)
	statusPanel.Position = UDim2.new(0, 20, 0, 20)
	statusPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	statusPanel.BorderSizePixel = 0
	statusPanel.Parent = hudFrame
	
	local statusCorner = Instance.new("UICorner")
	statusCorner.CornerRadius = UDim.new(0, 12)
	statusCorner.Parent = statusPanel
	
	-- Level e Nome
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "NameLabel"
	nameLabel.Size = UDim2.new(1, -20, 0, 30)
	nameLabel.Position = UDim2.new(0, 10, 0, 10)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name .. " | Nível 1"
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextSize = 18
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = statusPanel
	
	-- Barra de XP
	local xpBarBG = Instance.new("Frame")
	xpBarBG.Name = "XPBarBG"
	xpBarBG.Size = UDim2.new(1, -20, 0, 25)
	xpBarBG.Position = UDim2.new(0, 10, 0, 45)
	xpBarBG.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	xpBarBG.BorderSizePixel = 0
	xpBarBG.Parent = statusPanel
	
	local xpBarCorner = Instance.new("UICorner")
	xpBarCorner.CornerRadius = UDim.new(0, 8)
	xpBarCorner.Parent = xpBarBG
	
	local xpBarFill = Instance.new("Frame")
	xpBarFill.Name = "XPBarFill"
	xpBarFill.Size = UDim2.new(0, 0, 1, 0)
	xpBarFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
	xpBarFill.BorderSizePixel = 0
	xpBarFill.Parent = xpBarBG
	
	local xpBarFillCorner = Instance.new("UICorner")
	xpBarFillCorner.CornerRadius = UDim.new(0, 8)
	xpBarFillCorner.Parent = xpBarFill
	
	local xpLabel = Instance.new("TextLabel")
	xpLabel.Name = "XPLabel"
	xpLabel.Size = UDim2.new(1, 0, 1, 0)
	xpLabel.BackgroundTransparency = 1
	xpLabel.Text = "0 / 100 XP"
	xpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	xpLabel.TextSize = 14
	xpLabel.Font = Enum.Font.GothamSemibold
	xpLabel.ZIndex = 2
	xpLabel.Parent = xpBarBG
	
	-- Moedas
	local cashLabel = Instance.new("TextLabel")
	cashLabel.Name = "CashLabel"
	cashLabel.Size = UDim2.new(0.48, 0, 0, 30)
	cashLabel.Position = UDim2.new(0, 10, 0, 80)
	cashLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	cashLabel.BorderSizePixel = 0
	cashLabel.Text = "💰 0"
	cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	cashLabel.TextSize = 16
	cashLabel.Font = Enum.Font.GothamBold
	cashLabel.Parent = statusPanel
	
	local cashCorner = Instance.new("UICorner")
	cashCorner.CornerRadius = UDim.new(0, 8)
	cashCorner.Parent = cashLabel
	
	-- Diamantes
	local diamondsLabel = Instance.new("TextLabel")
	diamondsLabel.Name = "DiamondsLabel"
	diamondsLabel.Size = UDim2.new(0.48, 0, 0, 30)
	diamondsLabel.Position = UDim2.new(0.52, 0, 0, 80)
	diamondsLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	diamondsLabel.BorderSizePixel = 0
	diamondsLabel.Text = "💎 0"
	diamondsLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
	diamondsLabel.TextSize = 16
	diamondsLabel.Font = Enum.Font.GothamBold
	diamondsLabel.Parent = statusPanel
	
	local diamondsCorner = Instance.new("UICorner")
	diamondsCorner.CornerRadius = UDim.new(0, 8)
	diamondsCorner.Parent = diamondsLabel
	
	-- Tempo Jogado (canto superior direito)
	local playTimeLabel = Instance.new("TextLabel")
	playTimeLabel.Name = "PlayTimeLabel"
	playTimeLabel.Size = UDim2.new(0, 180, 0, 40)
	playTimeLabel.Position = UDim2.new(1, -200, 0, 20)
	playTimeLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	playTimeLabel.BorderSizePixel = 0
	playTimeLabel.Text = "⏰ 00:00:00"
	playTimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	playTimeLabel.TextSize = 18
	playTimeLabel.Font = Enum.Font.GothamBold
	playTimeLabel.Parent = hudFrame
	
	local playTimeCorner = Instance.new("UICorner")
	playTimeCorner.CornerRadius = UDim.new(0, 12)
	playTimeCorner.Parent = playTimeLabel
	
	-- ===== PAINEL DE COMBATE (lado esquerdo, centro) =====
	local combatPanel = Instance.new("Frame")
	combatPanel.Name = "CombatPanel"
	combatPanel.Size = UDim2.new(0, 220, 0, 140)
	combatPanel.Position = UDim2.new(0, 20, 0.5, -70)
	combatPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	combatPanel.BorderSizePixel = 0
	combatPanel.Parent = hudFrame
	
	local combatCorner = Instance.new("UICorner")
	combatCorner.CornerRadius = UDim.new(0, 12)
	combatCorner.Parent = combatPanel
	
	local combatTitle = Instance.new("TextLabel")
	combatTitle.Name = "Title"
	combatTitle.Size = UDim2.new(1, 0, 0, 30)
	combatTitle.BackgroundTransparency = 1
	combatTitle.Text = "⚔️ COMBATE"
	combatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	combatTitle.TextSize = 16
	combatTitle.Font = Enum.Font.GothamBold
	combatTitle.Parent = combatPanel
	
	-- Botões de estilo
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "Buttons"
	buttonContainer.Size = UDim2.new(1, -20, 1, -40)
	buttonContainer.Position = UDim2.new(0, 10, 0, 35)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = combatPanel
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.Parent = buttonContainer
	
	CreateCombatButtons(buttonContainer)
	
	-- Instrução (parte inferior)
	local instructionLabel = Instance.new("TextLabel")
	instructionLabel.Name = "Instruction"
	instructionLabel.Size = UDim2.new(0, 350, 0, 50)
	instructionLabel.Position = UDim2.new(0.5, -175, 1, -70)
	instructionLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	instructionLabel.BackgroundTransparency = 0.5
	instructionLabel.BorderSizePixel = 0
	instructionLabel.Text = "Clique para atacar | TAB para abrir menu\n1 e 2 para trocar de arma"
	instructionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	instructionLabel.TextSize = 14
	instructionLabel.Font = Enum.Font.Gotham
	instructionLabel.TextWrapped = true
	instructionLabel.Parent = hudFrame
	
	local instructionCorner = Instance.new("UICorner")
	instructionCorner.CornerRadius = UDim.new(0, 10)
	instructionCorner.Parent = instructionLabel
	
	-- Esconder instrução após 15 segundos
	task.delay(15, function()
		TweenService:Create(instructionLabel, TweenInfo.new(0.5), {
			BackgroundTransparency = 1,
			TextTransparency = 1
		}):Play()
	end)
	
	-- Atualizar HUD periodicamente
	task.spawn(function()
		while true do
			task.wait(1)
			UpdateHUD(statusPanel, playTimeLabel)
		end
	end)
end

-- ============================
-- BOTÕES DE COMBATE
-- ============================

function CreateCombatButtons(parent)
	local currentStyle = "Fist"
	local buttons = {}
	
	for styleName, styleConfig in pairs(GameConfig.Combat.AttackStyles) do
		local button = Instance.new("TextButton")
		button.Name = styleName
		button.Size = UDim2.new(1, 0, 0, 42)
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
		button.BorderSizePixel = 0
		button.Text = styleConfig.Name
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextSize = 16
		button.Font = Enum.Font.GothamSemibold
		button.AutoButtonColor = false
		button.Parent = parent
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button
		
		local damageLabel = Instance.new("TextLabel")
		damageLabel.Size = UDim2.new(0, 80, 1, 0)
		damageLabel.Position = UDim2.new(1, -85, 0, 0)
		damageLabel.BackgroundTransparency = 1
		damageLabel.Text = styleConfig.Damage .. " ⚔️"
		damageLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		damageLabel.TextSize = 14
		damageLabel.Font = Enum.Font.GothamBold
		damageLabel.Parent = button
		
		buttons[styleName] = button
		
		-- Evento de clique
		button.MouseButton1Click:Connect(function()
			currentStyle = styleName
			UpdateCombatButtons(buttons, currentStyle)
			
			if _G.ChangeAttackStyle then
				_G.ChangeAttackStyle(styleName)
			end
		end)
		
		-- Hover effect
		button.MouseEnter:Connect(function()
			if styleName ~= currentStyle then
				button.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
			end
		end)
		
		button.MouseLeave:Connect(function()
			UpdateCombatButtons(buttons, currentStyle)
		end)
	end
	
	UpdateCombatButtons(buttons, currentStyle)
end

function UpdateCombatButtons(buttons, currentStyle)
	for styleName, button in pairs(buttons) do
		if styleName == currentStyle then
			button.BackgroundColor3 = Color3.fromRGB(80, 180, 120)
			button.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
			button.TextColor3 = Color3.fromRGB(200, 200, 200)
		end
	end
end

-- ============================
-- ATUALIZAR HUD
-- ============================

function UpdateHUD(statusPanel, playTimeLabel)
	if not playerData then return end
	
	-- Atualizar level e nome
	local nameLabel = statusPanel:FindFirstChild("NameLabel")
	if nameLabel then
		nameLabel.Text = player.Name .. " | Nível " .. playerData.Level
	end
	
	-- Atualizar barra de XP
	local xpBarBG = statusPanel:FindFirstChild("XPBarBG")
	if xpBarBG then
		local xpBarFill = xpBarBG:FindFirstChild("XPBarFill")
		local xpLabel = xpBarBG:FindFirstChild("XPLabel")
		
		local xpRequired = UtilityFunctions:CalculateXPRequired(
			playerData.Level,
			GameConfig.Experience.BaseXPRequired,
			GameConfig.Experience.XPScaling
		)
		
		local progress = UtilityFunctions:CalculateProgress(playerData.XP, xpRequired) / 100
		
		if xpBarFill then
			TweenService:Create(xpBarFill, TweenInfo.new(0.3), {
				Size = UDim2.new(progress, 0, 1, 0)
			}):Play()
		end
		
		if xpLabel then
			xpLabel.Text = UtilityFunctions:FormatNumber(playerData.XP, true) .. 
				" / " .. UtilityFunctions:FormatNumber(xpRequired, true) .. " XP"
		end
	end
	
	-- Atualizar moedas
	local cashLabel = statusPanel:FindFirstChild("CashLabel")
	if cashLabel then
		cashLabel.Text = "💰 " .. UtilityFunctions:FormatNumber(playerData.Cash, true)
	end
	
	-- Atualizar diamantes
	local diamondsLabel = statusPanel:FindFirstChild("DiamondsLabel")
	if diamondsLabel then
		diamondsLabel.Text = "💎 " .. UtilityFunctions:FormatNumber(playerData.Diamonds, true)
	end
	
	-- Atualizar tempo jogado
	if playTimeLabel then
		playTimeLabel.Text = "⏰ " .. UtilityFunctions:FormatTime(playerData.PlayTime or 0)
	end
end

-- ============================
-- MENU PRINCIPAL (continua no próximo arquivo devido ao tamanho)
-- ============================

function CreateMainMenu(parent)
	-- Menu será criado em MenuUI.lua separadamente
	-- Este arquivo já está ficando grande
end

-- ============================
-- SISTEMA DE NOTIFICAÇÕES
-- ============================

local function CreateNotification(message, color, icon)
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 300, 0, 60)
	notif.Position = UDim2.new(0.5, -150, 0, -70)
	notif.BackgroundColor3 = color or Color3.fromRGB(50, 50, 50)
	notif.BorderSizePixel = 0
	notif.Parent = mainUI
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = notif
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = (icon or "📢") .. " " .. message
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextSize = 16
	label.Font = Enum.Font.GothamBold
	label.TextWrapped = true
	label.Parent = notif
	
	-- Animar entrada
	notif:TweenPosition(UDim2.new(0.5, -150, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Bounce, 0.5, true)
	
	-- Remover após 3 segundos
	task.delay(3, function()
		TweenService:Create(notif, TweenInfo.new(0.5), {
			Position = UDim2.new(0.5, -150, 0, -70),
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.5)
		notif:Destroy()
	end)
end

-- ============================
-- EVENTOS DO SERVIDOR
-- ============================

RemoteEvents.DataUpdate.OnClientEvent:Connect(function(key, value)
	if key == "FullData" then
		playerData = value
	elseif playerData then
		playerData[key] = value
	end
end)

RemoteEvents.AchievementUnlocked.OnClientEvent:Connect(function(achievement)
	CreateNotification(
		achievement.Name .. " desbloqueado!",
		Color3.fromRGB(255, 215, 0),
		achievement.Icon
	)
end)

RemoteEvents.AttackFeedback.OnClientEvent:Connect(function(feedbackType, data)
	if feedbackType == "level_up" then
		CreateNotification(
			"Level Up! Nível " .. data,
			Color3.fromRGB(100, 200, 255),
			"⭐"
		)
	elseif feedbackType == "shadow_captured" then
		CreateNotification(
			"Sombra Capturada: " .. data.Name,
			Color3.fromRGB(150, 100, 255),
			"🧞‍♂️"
		)
	end
end)

-- ============================
-- INICIALIZAÇÃO
-- ============================

-- Aguardar dados do servidor
local attempts = 0
while not RequestPlayerData() and attempts < 10 do
	attempts = attempts + 1
	task.wait(1)
end

if playerData then
	mainUI = CreateMainUI()
	print("✅ UI do Jogador inicializada!")
else
	warn("❌ Falha ao carregar dados do jogador")
end
