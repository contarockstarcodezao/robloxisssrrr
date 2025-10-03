--[[
    COMBAT SYSTEM - Sistema de Combate
    Framework completo e funcional para Arise Crossover
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("⚔️ Criando sistema de combate...")

-- Criar GUI de combate
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CombatSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal de combate
local combatFrame = Instance.new("Frame")
combatFrame.Name = "CombatFrame"
combatFrame.Size = UDim2.new(0, 300, 0, 200)
combatFrame.Position = UDim2.new(1, -310, 1, -210)
combatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
combatFrame.BorderSizePixel = 0
combatFrame.Parent = screenGui

-- Borda do frame
local combatBorder = Instance.new("Frame")
combatBorder.Name = "CombatBorder"
combatBorder.Size = UDim2.new(1, 4, 1, 4)
combatBorder.Position = UDim2.new(0, -2, 0, -2)
combatBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
combatBorder.BorderSizePixel = 0
combatBorder.Parent = combatFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "⚔️ COMBATE"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = combatFrame

-- Barra de vida
local healthFrame = Instance.new("Frame")
healthFrame.Name = "HealthFrame"
healthFrame.Size = UDim2.new(1, -20, 0, 25)
healthFrame.Position = UDim2.new(0, 10, 0, 35)
healthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
healthFrame.BorderSizePixel = 0
healthFrame.Parent = combatFrame

local healthBar = Instance.new("Frame")
healthBar.Name = "HealthBar"
healthBar.Size = UDim2.new(1, 0, 1, 0)
healthBar.Position = UDim2.new(0, 0, 0, 0)
healthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
healthBar.BorderSizePixel = 0
healthBar.Parent = healthFrame

-- Texto da vida
local healthText = Instance.new("TextLabel")
healthText.Name = "HealthText"
healthText.Size = UDim2.new(1, 0, 1, 0)
healthText.Position = UDim2.new(0, 0, 0, 0)
healthText.BackgroundTransparency = 1
healthText.Text = "100/100"
healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
healthText.TextScaled = true
healthText.Font = Enum.Font.SourceSansBold
healthText.Parent = healthFrame

-- Barra de mana
local manaFrame = Instance.new("Frame")
manaFrame.Name = "ManaFrame"
manaFrame.Size = UDim2.new(1, -20, 0, 25)
manaFrame.Position = UDim2.new(0, 10, 0, 65)
manaFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
manaFrame.BorderSizePixel = 0
manaFrame.Parent = combatFrame

local manaBar = Instance.new("Frame")
manaBar.Name = "ManaBar"
manaBar.Size = UDim2.new(1, 0, 1, 0)
manaBar.Position = UDim2.new(0, 0, 0, 0)
manaBar.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
manaBar.BorderSizePixel = 0
manaBar.Parent = manaFrame

-- Texto da mana
local manaText = Instance.new("TextLabel")
manaText.Name = "ManaText"
manaText.Size = UDim2.new(1, 0, 1, 0)
manaText.Position = UDim2.new(0, 0, 0, 0)
manaText.BackgroundTransparency = 1
manaText.Text = "100/100"
manaText.TextColor3 = Color3.fromRGB(255, 255, 255)
manaText.TextScaled = true
manaText.Font = Enum.Font.SourceSansBold
manaText.Parent = manaFrame

-- Frame de botões
local buttonsFrame = Instance.new("Frame")
buttonsFrame.Name = "ButtonsFrame"
buttonsFrame.Size = UDim2.new(1, -20, 0, 100)
buttonsFrame.Position = UDim2.new(0, 10, 0, 95)
buttonsFrame.BackgroundTransparency = 1
buttonsFrame.Parent = combatFrame

-- Botão de ataque
local attackButton = Instance.new("TextButton")
attackButton.Name = "AttackButton"
attackButton.Size = UDim2.new(0, 80, 0, 40)
attackButton.Position = UDim2.new(0, 0, 0, 0)
attackButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
attackButton.BorderSizePixel = 0
attackButton.Text = "⚔️\nAtacar"
attackButton.TextColor3 = Color3.fromRGB(255, 255, 255)
attackButton.TextScaled = true
attackButton.Font = Enum.Font.SourceSansBold
attackButton.Parent = buttonsFrame

-- Botão de habilidade 1
local skill1Button = Instance.new("TextButton")
skill1Button.Name = "Skill1Button"
skill1Button.Size = UDim2.new(0, 80, 0, 40)
skill1Button.Position = UDim2.new(0, 90, 0, 0)
skill1Button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
skill1Button.BorderSizePixel = 0
skill1Button.Text = "🔥\nHabilidade"
skill1Button.TextColor3 = Color3.fromRGB(255, 255, 255)
skill1Button.TextScaled = true
skill1Button.Font = Enum.Font.SourceSansBold
skill1Button.Parent = buttonsFrame

-- Botão de habilidade 2
local skill2Button = Instance.new("TextButton")
skill2Button.Name = "Skill2Button"
skill2Button.Size = UDim2.new(0, 80, 0, 40)
skill2Button.Position = UDim2.new(0, 180, 0, 0)
skill2Button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
skill2Button.BorderSizePixel = 0
skill2Button.Text = "⚡\nUltimate"
skill2Button.TextColor3 = Color3.fromRGB(255, 255, 255)
skill2Button.TextScaled = true
skill2Button.Font = Enum.Font.SourceSansBold
skill2Button.Parent = buttonsFrame

-- Botão de defesa
local defenseButton = Instance.new("TextButton")
defenseButton.Name = "DefenseButton"
defenseButton.Size = UDim2.new(0, 80, 0, 40)
defenseButton.Position = UDim2.new(0, 0, 0, 50)
defenseButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
defenseButton.BorderSizePixel = 0
defenseButton.Text = "🛡️\nDefender"
defenseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
defenseButton.TextScaled = true
defenseButton.Font = Enum.Font.SourceSansBold
defenseButton.Parent = buttonsFrame

-- Botão de item
local itemButton = Instance.new("TextButton")
itemButton.Name = "ItemButton"
itemButton.Size = UDim2.new(0, 80, 0, 40)
itemButton.Position = UDim2.new(0, 90, 0, 50)
itemButton.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
itemButton.BorderSizePixel = 0
itemButton.Text = "🧪\nItem"
itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
itemButton.TextScaled = true
itemButton.Font = Enum.Font.SourceSansBold
itemButton.Parent = buttonsFrame

-- Botão de fuga
local escapeButton = Instance.new("TextButton")
escapeButton.Name = "EscapeButton"
escapeButton.Size = UDim2.new(0, 80, 0, 40)
escapeButton.Position = UDim2.new(0, 180, 0, 50)
escapeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
escapeButton.BorderSizePixel = 0
escapeButton.Text = "🏃\nFugir"
escapeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
escapeButton.TextScaled = true
escapeButton.Font = Enum.Font.SourceSansBold
escapeButton.Parent = buttonsFrame

-- Frame de informações do inimigo
local enemyFrame = Instance.new("Frame")
enemyFrame.Name = "EnemyFrame"
enemyFrame.Size = UDim2.new(0, 250, 0, 120)
enemyFrame.Position = UDim2.new(0, 10, 1, -130)
enemyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
enemyFrame.BorderSizePixel = 0
enemyFrame.Visible = false
enemyFrame.Parent = screenGui

-- Borda do frame do inimigo
local enemyBorder = Instance.new("Frame")
enemyBorder.Name = "EnemyBorder"
enemyBorder.Size = UDim2.new(1, 4, 1, 4)
enemyBorder.Position = UDim2.new(0, -2, 0, -2)
enemyBorder.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
enemyBorder.BorderSizePixel = 0
enemyBorder.Parent = enemyFrame

-- Nome do inimigo
local enemyNameLabel = Instance.new("TextLabel")
enemyNameLabel.Name = "EnemyNameLabel"
enemyNameLabel.Size = UDim2.new(1, 0, 0, 30)
enemyNameLabel.Position = UDim2.new(0, 0, 0, 0)
enemyNameLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
enemyNameLabel.BorderSizePixel = 0
enemyNameLabel.Text = "Shadow Wolf"
enemyNameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
enemyNameLabel.TextScaled = true
enemyNameLabel.Font = Enum.Font.SourceSansBold
enemyNameLabel.Parent = enemyFrame

-- Barra de vida do inimigo
local enemyHealthFrame = Instance.new("Frame")
enemyHealthFrame.Name = "EnemyHealthFrame"
enemyHealthFrame.Size = UDim2.new(1, -20, 0, 20)
enemyHealthFrame.Position = UDim2.new(0, 10, 0, 35)
enemyHealthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
enemyHealthFrame.BorderSizePixel = 0
enemyHealthFrame.Parent = enemyFrame

local enemyHealthBar = Instance.new("Frame")
enemyHealthBar.Name = "EnemyHealthBar"
enemyHealthBar.Size = UDim2.new(1, 0, 1, 0)
enemyHealthBar.Position = UDim2.new(0, 0, 0, 0)
enemyHealthBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
enemyHealthBar.BorderSizePixel = 0
enemyHealthBar.Parent = enemyHealthFrame

-- Texto da vida do inimigo
local enemyHealthText = Instance.new("TextLabel")
enemyHealthText.Name = "EnemyHealthText"
enemyHealthText.Size = UDim2.new(1, 0, 1, 0)
enemyHealthText.Position = UDim2.new(0, 0, 0, 0)
enemyHealthText.BackgroundTransparency = 1
enemyHealthText.Text = "500/500"
enemyHealthText.TextColor3 = Color3.fromRGB(255, 255, 255)
enemyHealthText.TextScaled = true
enemyHealthText.Font = Enum.Font.SourceSansBold
enemyHealthText.Parent = enemyHealthFrame

-- Nível do inimigo
local enemyLevelLabel = Instance.new("TextLabel")
enemyLevelLabel.Name = "EnemyLevelLabel"
enemyLevelLabel.Size = UDim2.new(1, 0, 0, 25)
enemyLevelLabel.Position = UDim2.new(0, 0, 0, 60)
enemyLevelLabel.BackgroundTransparency = 1
enemyLevelLabel.Text = "Nível: 5"
enemyLevelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
enemyLevelLabel.TextScaled = true
enemyLevelLabel.Font = Enum.Font.SourceSansBold
enemyLevelLabel.Parent = enemyFrame

-- Rank do inimigo
local enemyRankLabel = Instance.new("TextLabel")
enemyRankLabel.Name = "EnemyRankLabel"
enemyRankLabel.Size = UDim2.new(1, 0, 0, 25)
enemyRankLabel.Position = UDim2.new(0, 0, 0, 85)
enemyRankLabel.BackgroundTransparency = 1
enemyRankLabel.Text = "Rank: F"
enemyRankLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
enemyRankLabel.TextScaled = true
enemyRankLabel.Font = Enum.Font.SourceSansBold
enemyRankLabel.Parent = enemyFrame

-- Função para atualizar barras de vida e mana
local function updateHealthBar(current, max)
    local percentage = current / max
    healthBar.Size = UDim2.new(percentage, 0, 1, 0)
    healthText.Text = tostring(current) .. "/" .. tostring(max)
end

local function updateManaBar(current, max)
    local percentage = current / max
    manaBar.Size = UDim2.new(percentage, 0, 1, 0)
    manaText.Text = tostring(current) .. "/" .. tostring(max)
end

-- Função para mostrar informações do inimigo
local function showEnemyInfo(enemyName, enemyLevel, enemyRank, currentHealth, maxHealth)
    enemyFrame.Visible = true
    enemyNameLabel.Text = enemyName
    enemyLevelLabel.Text = "Nível: " .. tostring(enemyLevel)
    enemyRankLabel.Text = "Rank: " .. enemyRank
    
    local percentage = currentHealth / maxHealth
    enemyHealthBar.Size = UDim2.new(percentage, 0, 1, 0)
    enemyHealthText.Text = tostring(currentHealth) .. "/" .. tostring(maxHealth)
end

-- Função para esconder informações do inimigo
local function hideEnemyInfo()
    enemyFrame.Visible = false
end

-- Conectar eventos dos botões
attackButton.MouseButton1Click:Connect(function()
    print("Atacando inimigo...")
end)

skill1Button.MouseButton1Click:Connect(function()
    print("Usando habilidade 1...")
end)

skill2Button.MouseButton1Click:Connect(function()
    print("Usando habilidade 2...")
end)

defenseButton.MouseButton1Click:Connect(function()
    print("Defendendo...")
end)

itemButton.MouseButton1Click:Connect(function()
    print("Usando item...")
end)

escapeButton.MouseButton1Click:Connect(function()
    print("Tentando fugir...")
end)

-- Efeitos hover dos botões
local function addHoverEffect(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor})
        tween:Play()
    end)
end

-- Aplicar efeitos hover
addHoverEffect(attackButton, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 100, 100))
addHoverEffect(skill1Button, Color3.fromRGB(0, 0, 255), Color3.fromRGB(100, 100, 255))
addHoverEffect(skill2Button, Color3.fromRGB(0, 255, 0), Color3.fromRGB(100, 255, 100))
addHoverEffect(defenseButton, Color3.fromRGB(128, 128, 128), Color3.fromRGB(180, 180, 180))
addHoverEffect(itemButton, Color3.fromRGB(255, 150, 0), Color3.fromRGB(255, 200, 100))
addHoverEffect(escapeButton, Color3.fromRGB(200, 50, 50), Color3.fromRGB(255, 100, 100))

-- Simular combate (para demonstração)
spawn(function()
    while true do
        wait(5)
        -- Simular dano
        updateHealthBar(80, 100)
        updateManaBar(80, 100)
        
        -- Mostrar inimigo
        showEnemyInfo("Shadow Wolf", 5, "F", 400, 500)
        
        wait(3)
        
        -- Esconder inimigo
        hideEnemyInfo()
    end
end)

-- Exportar funções
_G.updateHealthBar = updateHealthBar
_G.updateManaBar = updateManaBar
_G.showEnemyInfo = showEnemyInfo
_G.hideEnemyInfo = hideEnemyInfo

print("✅ CombatSystem criado com sucesso!")