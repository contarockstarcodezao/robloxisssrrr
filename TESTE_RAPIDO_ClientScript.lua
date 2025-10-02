-- TESTE RÁPIDO CLIENTE - Cole em StarterPlayer/StarterPlayerScripts como LocalScript
-- Nome: TesteRapidoCliente

print("🖥️ ========== TESTE CLIENTE INICIADO ==========")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

print("👤 Cliente iniciado para:", player.Name)

-- Aguardar character
local character = player.Character or player.CharacterAdded:Wait()
print("✅ Character carregado")

-- Aguardar um pouco
wait(2)

-- Verificar CombatEvent
local combatEvent = ReplicatedStorage:FindFirstChild("CombatEvent")

if not combatEvent then
    print("⚠️ CombatEvent não encontrado! Procurando em Events...")
    
    local events = ReplicatedStorage:FindFirstChild("Events")
    if events then
        combatEvent = events:FindFirstChild("CombatEvent")
    end
end

if combatEvent then
    print("✅ CombatEvent encontrado!")
    
    -- Sistema de clique
    mouse.Button1Down:Connect(function()
        print("\n🖱️ ========== CLIQUE DETECTADO ==========")
        print("📍 Posição do clique:", mouse.Hit.Position)
        print("📤 Enviando ataque para servidor...")
        
        combatEvent:FireServer("Attack", mouse.Hit.Position)
        
        -- Efeito visual local
        local effect = Instance.new("Part")
        effect.Size = Vector3.new(1, 1, 1)
        effect.Anchored = true
        effect.CanCollide = false
        effect.Material = Enum.Material.Neon
        effect.Color = Color3.fromRGB(255, 255, 0)
        effect.Shape = Enum.PartType.Ball
        effect.CFrame = CFrame.new(mouse.Hit.Position)
        effect.Parent = workspace
        
        local tween = game:GetService("TweenService"):Create(
            effect,
            TweenInfo.new(0.3),
            {Size = Vector3.new(3, 3, 3), Transparency = 1}
        )
        tween:Play()
        
        game:GetService("Debris"):AddItem(effect, 0.5)
        
        print("✅ Ataque enviado!")
        print("=========================================\n")
    end)
    
    print("✅ Sistema de clique ativo!")
    print("🖱️ Clique com botão esquerdo para atacar!")
    
else
    print("❌ ERRO: CombatEvent não encontrado!")
    print("💡 Solução: Crie um RemoteEvent chamado 'CombatEvent' em ReplicatedStorage/Events/")
end

-- Teclas de atalho para debug
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        print("\n📊 ========== STATUS DO CLIENTE ==========")
        print("👤 Jogador:", player.Name)
        print("❤️ Vida:", character:FindFirstChild("Humanoid") and character.Humanoid.Health or "N/A")
        print("📍 Posição:", character.PrimaryPart and character.PrimaryPart.Position or "N/A")
        print("🎯 CombatEvent:", combatEvent and "Encontrado" or "NÃO ENCONTRADO")
        print("==========================================\n")
    end
    
    if input.KeyCode == Enum.KeyCode.F2 then
        print("\n🎯 ========== PROCURANDO NPCs ==========")
        local count = 0
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:GetAttribute("IsNPC") then
                count = count + 1
                local humanoid = obj:FindFirstChild("Humanoid")
                local hp = humanoid and humanoid.Health or "N/A"
                print("👾 NPC encontrado:", obj.Name, "| HP:", hp)
            end
        end
        print("📊 Total de NPCs:", count)
        print("========================================\n")
    end
end)

-- Criar HUD simples
local function criarHUD()
    local screenGui = player:WaitForChild("PlayerGui"):FindFirstChild("TesteHUD")
    if screenGui then screenGui:Destroy() end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TesteHUD"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0, 10, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 0)
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.Text = "🎮 TESTE RÁPIDO"
    title.TextColor3 = Color3.fromRGB(255, 255, 0)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.Parent = frame
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 1, -40)
    info.Position = UDim2.new(0, 10, 0, 35)
    info.BackgroundTransparency = 1
    info.Text = "🖱️ CLIQUE para atacar\nF1 = Status\nF2 = Ver NPCs"
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.Font = Enum.Font.Gotham
    info.TextSize = 16
    info.TextXAlignment = Enum.TextXAlignment.Left
    info.TextYAlignment = Enum.TextYAlignment.Top
    info.Parent = frame
    
    print("✅ HUD de teste criado!")
end

criarHUD()

-- Notificação de pronto
local function notificar(texto)
    local notification = Instance.new("ScreenGui")
    notification.Parent = player.PlayerGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 400, 0, 80)
    label.Position = UDim2.new(0.5, -200, 0.5, -40)
    label.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    label.BorderSizePixel = 3
    label.BorderColor3 = Color3.fromRGB(255, 255, 255)
    label.Text = texto
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
    label.Parent = notification
    
    wait(3)
    notification:Destroy()
end

wait(1)
notificar("✅ SISTEMA PRONTO!\n🖱️ Clique para atacar NPCs")

print("\n✅ ========== CLIENTE PRONTO ==========")
print("🖱️ Clique para atacar NPCs")
print("⌨️ F1 = Ver status")
print("⌨️ F2 = Listar NPCs")
print("=======================================\n")
