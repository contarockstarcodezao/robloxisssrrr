-- EXECUTE ESTE SCRIPT UMA VEZ e depois DELETE
-- Cole em ServerScriptService como Script
-- Nome: CriarMenus

print("🎨 ========== CRIANDO MENUS ==========")

local StarterGui = game:GetService("StarterGui")

-- Criar ou pegar GameUI
local gameUI = StarterGui:FindFirstChild("GameUI")
if not gameUI then
    gameUI = Instance.new("ScreenGui")
    gameUI.Name = "GameUI"
    gameUI.ResetOnSpawn = false
    gameUI.Parent = StarterGui
    print("✅ GameUI criado")
else
    print("✅ GameUI já existe")
end

-- Função para criar Frame base
local function criarFrame(nome, visivel)
    local frame = gameUI:FindFirstChild(nome)
    if frame then 
        print("⚠️", nome, "já existe, recriando...")
        frame:Destroy() 
    end
    
    frame = Instance.new("Frame")
    frame.Name = nome
    frame.Size = UDim2.new(0, 600, 0, 400)
    frame.Position = UDim2.new(0.5, -300, 0.5, -200)
    frame.AnchorPoint = Vector2.new(0, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    frame.Visible = visivel or false
    frame.Parent = gameUI
    
    -- UICorner para bordas arredondadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = nome
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = title
    
    -- Botão fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn
    
    -- ScrollingFrame
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "ScrollingFrame"
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    scroll.BorderSizePixel = 1
    scroll.BorderColor3 = Color3.fromRGB(100, 100, 100)
    scroll.ScrollBarThickness = 8
    scroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    scroll.Parent = frame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 4)
    scrollCorner.Parent = scroll
    
    -- Texto de exemplo no scroll
    local exemplo = Instance.new("TextLabel")
    exemplo.Size = UDim2.new(1, -10, 0, 40)
    exemplo.Position = UDim2.new(0, 5, 0, 5)
    exemplo.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    exemplo.BorderSizePixel = 0
    exemplo.Text = "📦 " .. nome .. " - Em breve conteúdo aqui!"
    exemplo.TextColor3 = Color3.fromRGB(200, 200, 200)
    exemplo.Font = Enum.Font.Gotham
    exemplo.TextSize = 16
    exemplo.Parent = scroll
    
    local exCorner = Instance.new("UICorner")
    exCorner.CornerRadius = UDim.new(0, 4)
    exCorner.Parent = exemplo
    
    print("✅ Frame criado:", nome)
    
    return frame
end

-- Criar HUD especial (sempre visível)
print("\n🎮 Criando HUD...")
local hud = gameUI:FindFirstChild("HUD")
if hud then 
    print("⚠️ HUD já existe, recriando...")
    hud:Destroy() 
end

hud = Instance.new("Frame")
hud.Name = "HUD"
hud.Size = UDim2.new(0, 350, 0, 140)
hud.Position = UDim2.new(0, 10, 0, 10)
hud.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hud.BackgroundTransparency = 0.2
hud.BorderSizePixel = 2
hud.BorderColor3 = Color3.fromRGB(255, 215, 0)
hud.Visible = true
hud.Parent = gameUI

local hudCorner = Instance.new("UICorner")
hudCorner.CornerRadius = UDim.new(0, 8)
hudCorner.Parent = hud

-- Título HUD
local hudTitle = Instance.new("TextLabel")
hudTitle.Size = UDim2.new(1, 0, 0, 30)
hudTitle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hudTitle.BackgroundTransparency = 0.2
hudTitle.Text = "🎮 ARISE CROSSOVER"
hudTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
hudTitle.Font = Enum.Font.GothamBold
hudTitle.TextSize = 18
hudTitle.BorderSizePixel = 0
hudTitle.Parent = hud

local hudTitleCorner = Instance.new("UICorner")
hudTitleCorner.CornerRadius = UDim.new(0, 8)
hudTitleCorner.Parent = hudTitle

-- Level Label
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(1, -10, 0, 30)
levelLabel.Position = UDim2.new(0, 5, 0, 35)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "⭐ Nível: 1"
levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
levelLabel.Font = Enum.Font.Gotham
levelLabel.TextSize = 18
levelLabel.TextXAlignment = Enum.TextXAlignment.Left
levelLabel.Parent = hud

-- Cash Label
local cashLabel = Instance.new("TextLabel")
cashLabel.Name = "CashLabel"
cashLabel.Size = UDim2.new(1, -10, 0, 30)
cashLabel.Position = UDim2.new(0, 5, 0, 68)
cashLabel.BackgroundTransparency = 1
cashLabel.Text = "💰 Cash: 1,000"
cashLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
cashLabel.Font = Enum.Font.Gotham
cashLabel.TextSize = 18
cashLabel.TextXAlignment = Enum.TextXAlignment.Left
cashLabel.Parent = hud

-- Diamonds Label
local diamondsLabel = Instance.new("TextLabel")
diamondsLabel.Name = "DiamondsLabel"
diamondsLabel.Size = UDim2.new(1, -10, 0, 30)
diamondsLabel.Position = UDim2.new(0, 5, 0, 101)
diamondsLabel.BackgroundTransparency = 1
diamondsLabel.Text = "💎 Diamantes: 50"
diamondsLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
diamondsLabel.Font = Enum.Font.Gotham
diamondsLabel.TextSize = 18
diamondsLabel.TextXAlignment = Enum.TextXAlignment.Left
diamondsLabel.Parent = hud

print("✅ HUD criado com sucesso!")

-- Criar todos os menus
print("\n📂 Criando menus...")
criarFrame("ShadowInventory", false)
criarFrame("Backpack", false)
criarFrame("Forge", false)
criarFrame("Ranking", false)
criarFrame("DungeonUI", false)

print("\n🎉 ========== MENUS CRIADOS COM SUCESSO! ==========")
print("📝 Próximo passo: Cole o MenuController no Cliente")
print("📍 Localização: StarterPlayer/StarterPlayerScripts")
print("⚠️ IMPORTANTE: Deve ser LocalScript (azul)!")
print("🗑️ Você pode DELETAR este script agora")
print("==================================================\n")
