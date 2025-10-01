-- StarterGui/CombatUI (LocalScript)
-- Interface para alternar entre estilos de combate e mostrar recompensas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Módulos
local CombatConfig = require(ReplicatedStorage:WaitForChild("CombatConfig"))
local CombatRemotes = require(ReplicatedStorage:WaitForChild("CombatRemotes"))

-- ============================
-- CRIAÇÃO DA UI
-- ============================

local function CreateUI()
	-- Container principal
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "CombatUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui
	
	-- ========== PAINEL DE ESTILOS ==========
	local stylesFrame = Instance.new("Frame")
	stylesFrame.Name = "StylesFrame"
	stylesFrame.Size = UDim2.new(0, 220, 0, 120)
	stylesFrame.Position = UDim2.new(0, 20, 0.5, -60)
	stylesFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	stylesFrame.BorderSizePixel = 0
	stylesFrame.Parent = screenGui
	
	-- Arredonda cantos
	local stylesCorner = Instance.new("UICorner")
	stylesCorner.CornerRadius = UDim.new(0, 12)
	stylesCorner.Parent = stylesFrame
	
	-- Título
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "ESTILO DE COMBATE"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = stylesFrame
	
	-- Layout para botões
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "ButtonContainer"
	buttonContainer.Size = UDim2.new(1, -20, 1, -40)
	buttonContainer.Position = UDim2.new(0, 10, 0, 35)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = stylesFrame
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Parent = buttonContainer
	
	-- ========== BOTÕES DE ESTILO ==========
	local currentStyle = "Punch"
	local styleButtons = {}
	
	local function CreateStyleButton(styleName, styleConfig)
		local button = Instance.new("TextButton")
		button.Name = styleName .. "Button"
		button.Size = UDim2.new(1, 0, 0, 32)
		button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		button.BorderSizePixel = 0
		button.Text = styleConfig.Name
		button.TextColor3 = Color3.fromRGB(200, 200, 200)
		button.TextSize = 16
		button.Font = Enum.Font.GothamSemibold
		button.AutoButtonColor = false
		button.Parent = buttonContainer
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button
		
		-- Adiciona info de dano
		local damageLabel = Instance.new("TextLabel")
		damageLabel.Name = "Damage"
		damageLabel.Size = UDim2.new(0, 60, 1, 0)
		damageLabel.Position = UDim2.new(1, -65, 0, 0)
		damageLabel.BackgroundTransparency = 1
		damageLabel.Text = styleConfig.Damage .. " DMG"
		damageLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
		damageLabel.TextSize = 12
		damageLabel.Font = Enum.Font.Gotham
		damageLabel.Parent = button
		
		styleButtons[styleName] = button
		
		return button
	end
	
	local function UpdateButtonStyles()
		for styleName, button in pairs(styleButtons) do
			if styleName == currentStyle then
				button.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
				button.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
				button.TextColor3 = Color3.fromRGB(200, 200, 200)
			end
		end
	end
	
	-- Cria botões para cada estilo
	for styleName, styleConfig in pairs(CombatConfig.AttackStyles) do
		local button = CreateStyleButton(styleName, styleConfig)
		
		button.MouseButton1Click:Connect(function()
			currentStyle = styleName
			UpdateButtonStyles()
			
			-- Altera o estilo no script de combate
			if _G.ChangeAttackStyle then
				_G.ChangeAttackStyle(styleName)
			end
		end)
		
		-- Efeito hover
		button.MouseEnter:Connect(function()
			if styleName ~= currentStyle then
				button.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
			end
		end)
		
		button.MouseLeave:Connect(function()
			UpdateButtonStyles()
		end)
	end
	
	UpdateButtonStyles()
	
	-- ========== PAINEL DE RECOMPENSAS ==========
	local rewardsFrame = Instance.new("Frame")
	rewardsFrame.Name = "RewardsFrame"
	rewardsFrame.Size = UDim2.new(0, 220, 0, 80)
	rewardsFrame.Position = UDim2.new(1, -240, 0, 20)
	rewardsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	rewardsFrame.BorderSizePixel = 0
	rewardsFrame.Parent = screenGui
	
	local rewardsCorner = Instance.new("UICorner")
	rewardsCorner.CornerRadius = UDim.new(0, 12)
	rewardsCorner.Parent = rewardsFrame
	
	-- XP Label
	local xpLabel = Instance.new("TextLabel")
	xpLabel.Name = "XPLabel"
	xpLabel.Size = UDim2.new(1, -20, 0, 30)
	xpLabel.Position = UDim2.new(0, 10, 0, 10)
	xpLabel.BackgroundTransparency = 1
	xpLabel.Text = "⭐ XP: 0"
	xpLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	xpLabel.TextSize = 18
	xpLabel.Font = Enum.Font.GothamBold
	xpLabel.TextXAlignment = Enum.TextXAlignment.Left
	xpLabel.Parent = rewardsFrame
	
	-- Coins Label
	local coinsLabel = Instance.new("TextLabel")
	coinsLabel.Name = "CoinsLabel"
	coinsLabel.Size = UDim2.new(1, -20, 0, 30)
	coinsLabel.Position = UDim2.new(0, 10, 0, 40)
	coinsLabel.BackgroundTransparency = 1
	coinsLabel.Text = "💰 Moedas: 0"
	coinsLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
	coinsLabel.TextSize = 18
	coinsLabel.Font = Enum.Font.GothamBold
	coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
	coinsLabel.Parent = rewardsFrame
	
	return screenGui, xpLabel, coinsLabel
end

-- ============================
-- ATUALIZAÇÃO DE RECOMPENSAS
-- ============================

local screenGui, xpLabel, coinsLabel = CreateUI()

local function AnimateNumber(label, newValue, prefix, color)
	-- Efeito de animação simples
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Text = prefix .. newValue
	
	task.spawn(function()
		for i = 1, 5 do
			label.TextSize = 18 + (i % 2 == 0 and 2 or 0)
			task.wait(0.05)
		end
		label.TextSize = 18
		label.TextColor3 = color
	end)
end

CombatRemotes.RewardUpdate.OnClientEvent:Connect(function(xp, coins)
	AnimateNumber(xpLabel, xp, "⭐ XP: ", Color3.fromRGB(255, 215, 0))
	AnimateNumber(coinsLabel, coins, "💰 Moedas: ", Color3.fromRGB(100, 255, 100))
end)

-- ============================
-- INSTRUÇÕES
-- ============================

local instructionsLabel = Instance.new("TextLabel")
instructionsLabel.Name = "Instructions"
instructionsLabel.Size = UDim2.new(0, 300, 0, 60)
instructionsLabel.Position = UDim2.new(0.5, -150, 1, -80)
instructionsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
instructionsLabel.BackgroundTransparency = 0.3
instructionsLabel.BorderSizePixel = 0
instructionsLabel.Text = "Clique com o botão esquerdo para atacar\nTeclas 1 e 2 para trocar de estilo"
instructionsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
instructionsLabel.TextSize = 14
instructionsLabel.Font = Enum.Font.Gotham
instructionsLabel.TextWrapped = true
instructionsLabel.Parent = screenGui

local instructionsCorner = Instance.new("UICorner")
instructionsCorner.CornerRadius = UDim.new(0, 8)
instructionsCorner.Parent = instructionsLabel

-- Auto-hide após 10 segundos
task.wait(10)
instructionsLabel:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true)

print("UI de Combate: Inicializada!")
