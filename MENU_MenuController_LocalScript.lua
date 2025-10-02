-- COLE ESTE SCRIPT PERMANENTEMENTE
-- StarterPlayer/StarterPlayerScripts como LocalScript (AZUL)
-- Nome: MenuController

print("🎮 ========== MENU CONTROLLER INICIADO ==========")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("👤 Cliente:", player.Name)

-- Aguardar GameUI com timeout
local gameUI = playerGui:WaitForChild("GameUI", 10)

if not gameUI then
    warn("❌ GameUI não encontrado!")
    warn("💡 Execute o script CriarMenus no servidor primeiro!")
    return
end

print("✅ GameUI encontrado")

-- Aguardar menus
local function aguardarMenu(nome)
    local menu = gameUI:WaitForChild(nome, 5)
    if menu then
        print("✅", nome, "encontrado")
    else
        warn("❌", nome, "NÃO encontrado")
    end
    return menu
end

-- Referências aos menus
local menus = {
    ShadowInventory = aguardarMenu("ShadowInventory"),
    Backpack = aguardarMenu("Backpack"),
    Forge = aguardarMenu("Forge"),
    Ranking = aguardarMenu("Ranking"),
    DungeonUI = aguardarMenu("DungeonUI"),
}

-- Função para fechar todos menus
local function fecharTodos()
    for _, menu in pairs(menus) do
        if menu then
            menu.Visible = false
        end
    end
end

-- Animação de abertura
local function animarAbertura(menu)
    if not menu then return end
    
    menu.Size = UDim2.new(0, 0, 0, 0)
    menu.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(
        menu,
        TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 600, 0, 400),
            Position = UDim2.new(0.5, -300, 0.5, -200)
        }
    )
    
    tween:Play()
end

-- Função para toggle menu
local function toggleMenu(menu)
    if not menu then 
        warn("❌ Menu não existe!")
        return 
    end
    
    local wasVisible = menu.Visible
    fecharTodos()
    
    if not wasVisible then
        menu.Visible = true
        animarAbertura(menu)
        print("📂 Menu aberto:", menu.Name)
        
        -- Som de abertura (opcional)
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
        sound.Volume = 0.3
        sound.Parent = game:GetService("SoundService")
        sound:Play()
        game:GetService("Debris"):AddItem(sound, 2)
    else
        print("📁 Menu já estava aberto, fechando")
    end
end

-- Configurar botões de fechar
for nome, menu in pairs(menus) do
    if menu then
        local closeBtn = menu:FindFirstChild("CloseButton")
        if closeBtn then
            closeBtn.MouseButton1Click:Connect(function()
                menu.Visible = false
                print("📁 Menu fechado:", nome)
                
                -- Som de fechar
                local sound = Instance.new("Sound")
                sound.SoundId = "rbxasset://sounds/button.wav"
                sound.Volume = 0.2
                sound.Parent = game:GetService("SoundService")
                sound:Play()
                game:GetService("Debris"):AddItem(sound, 2)
            end)
            print("✅ Botão X configurado em", nome)
        end
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- B - Inventário
    if input.KeyCode == Enum.KeyCode.B then
        print("⌨️ Tecla B pressionada - Abrindo Inventário")
        toggleMenu(menus.Backpack)
    end
    
    -- C - Sombras
    if input.KeyCode == Enum.KeyCode.C then
        print("⌨️ Tecla C pressionada - Abrindo Sombras")
        toggleMenu(menus.ShadowInventory)
    end
    
    -- F - Forja
    if input.KeyCode == Enum.KeyCode.F then
        print("⌨️ Tecla F pressionada - Abrindo Forja")
        toggleMenu(menus.Forge)
    end
    
    -- L - Ranking
    if input.KeyCode == Enum.KeyCode.L then
        print("⌨️ Tecla L pressionada - Abrindo Ranking")
        toggleMenu(menus.Ranking)
    end
    
    -- D - Dungeons (novo)
    if input.KeyCode == Enum.KeyCode.D then
        print("⌨️ Tecla D pressionada - Abrindo Dungeons")
        toggleMenu(menus.DungeonUI)
    end
    
    -- ESC - Fechar tudo
    if input.KeyCode == Enum.KeyCode.Escape then
        print("⌨️ ESC pressionado - Fechando todos os menus")
        fecharTodos()
    end
    
    -- F3 - Teste (abrir todos)
    if input.KeyCode == Enum.KeyCode.F3 then
        print("🔧 F3 - Teste: Alternando visibilidade de todos")
        local algumAberto = false
        for _, menu in pairs(menus) do
            if menu and menu.Visible then
                algumAberto = true
                break
            end
        end
        
        for _, menu in pairs(menus) do
            if menu then
                menu.Visible = not algumAberto
            end
        end
    end
    
    -- F4 - Info de debug
    if input.KeyCode == Enum.KeyCode.F4 then
        print("\n📊 ========== DEBUG INFO ==========")
        print("👤 Jogador:", player.Name)
        print("🎮 GameUI:", gameUI and "✅" or "❌")
        for nome, menu in pairs(menus) do
            local status = menu and "✅" or "❌"
            local visivel = menu and menu.Visible and "Visível" or "Oculto"
            print("📂", nome, status, visivel)
        end
        print("===================================\n")
    end
end)

-- Notificação visual de controles
local function mostrarControles()
    wait(2) -- Aguardar spawn
    
    local notif = Instance.new("ScreenGui")
    notif.Name = "ControlesNotif"
    notif.Parent = playerGui
    notif.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 450, 0, 300)
    frame.Position = UDim2.new(0.5, -225, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    frame.Parent = notif
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "⌨️ CONTROLES DO JOGO"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 1, -100)
    info.Position = UDim2.new(0, 10, 0, 55)
    info.BackgroundTransparency = 1
    info.Text = [[
⌨️ B = Inventário (Backpack)
⌨️ C = Menu de Sombras
⌨️ F = Forja
⌨️ L = Ranking
⌨️ D = Dungeons
⌨️ ESC = Fechar todos menus

🖱️ Clique = Atacar NPCs

🔧 Debug:
⌨️ F3 = Teste (abrir/fechar todos)
⌨️ F4 = Informações de debug
]]
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.Font = Enum.Font.Gotham
    info.TextSize = 16
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 35)
    closeBtn.Position = UDim2.new(0.5, -60, 1, -45)
    closeBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✓ ENTENDI"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        notif:Destroy()
    end)
    
    -- Auto-fechar após 10 segundos
    task.delay(10, function()
        if notif.Parent then
            notif:Destroy()
        end
    end)
end

-- Mostrar controles ao iniciar
mostrarControles()

print("\n✅ ========== MENU CONTROLLER PRONTO! ==========")
print("⌨️ Pressione as seguintes teclas:")
print("   B = Inventário")
print("   C = Sombras")
print("   F = Forja")
print("   L = Ranking")
print("   D = Dungeons")
print("   ESC = Fechar")
print("   F3 = Teste")
print("   F4 = Debug")
print("================================================\n")
