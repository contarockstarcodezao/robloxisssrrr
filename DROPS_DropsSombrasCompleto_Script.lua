-- SISTEMA COMPLETO DE DROPS E SOMBRAS
-- Cole em ServerScriptService como Script
-- Nome: DropsSombrasCompleto

print("💰 ========== SISTEMA DE DROPS E SOMBRAS ==========")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Criar ou pegar RemoteEvents
local function getOrCreateRemote(nome, tipo)
    local remote = ReplicatedStorage:FindFirstChild(nome)
    if not remote then
        if tipo == "Event" then
            remote = Instance.new("RemoteEvent")
        else
            remote = Instance.new("RemoteFunction")
        end
        remote.Name = nome
        remote.Parent = ReplicatedStorage
        print("✅ Criado:", nome)
    end
    return remote
end

local combatEvent = getOrCreateRemote("CombatEvent", "Event")
local shadowEvent = getOrCreateRemote("ShadowEvent", "Event")

-- ==================== DADOS DOS JOGADORES ====================
local PlayerData = {}

local function initPlayerData(player)
    if not PlayerData[player.UserId] then
        PlayerData[player.UserId] = {
            Cash = 1000,
            Diamonds = 50,
            Fragments = 0,
            Level = 1,
            XP = 0,
            XPToNextLevel = 100,
            Shadows = {},
            TotalKills = 0
        }
        print("✅ Dados inicializados para:", player.Name)
    end
    return PlayerData[player.UserId]
end

-- ==================== LEADERSTATS ====================
local function updateLeaderstats(player)
    local data = PlayerData[player.UserId]
    if not data then return end
    
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end
    
    local level = leaderstats:FindFirstChild("Level")
    if not level then
        level = Instance.new("IntValue")
        level.Name = "Level"
        level.Parent = leaderstats
    end
    level.Value = data.Level
    
    local cash = leaderstats:FindFirstChild("Cash")
    if not cash then
        cash = Instance.new("IntValue")
        cash.Name = "Cash"
        cash.Parent = leaderstats
    end
    cash.Value = data.Cash
end

-- ==================== NOTIFICAÇÕES ====================
local function notifyPlayer(player, text, color)
    local gui = Instance.new("ScreenGui")
    gui.Parent = player.PlayerGui
    gui.ResetOnSpawn = false
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 300, 0, 60)
    label.Position = UDim2.new(0.5, -150, 0.9, 0)
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 0.3
    label.BorderSizePixel = 0
    label.Text = text
    label.TextColor3 = color
    label.Font = Enum.Font.GothamBold
    label.TextSize = 20
    label.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = label
    
    -- Animar entrada
    label:TweenPosition(
        UDim2.new(0.5, -150, 0.75, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.3,
        true
    )
    
    -- Animar saída
    task.delay(2, function()
        if label.Parent then
            label:TweenPosition(
                UDim2.new(0.5, -150, 0.6, 0),
                Enum.EasingDirection.In,
                Enum.EasingStyle.Back,
                0.3,
                true
            )
            task.wait(0.3)
            gui:Destroy()
        end
    end)
end

-- ==================== CRIAR DROP VISUAL ====================
local function createDrop(position, dropType, amount, npcRank)
    local drop = Instance.new("Part")
    drop.Name = "Drop_" .. dropType
    drop.Size = Vector3.new(1.5, 1.5, 1.5)
    drop.Position = position + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
    drop.Anchored = true
    drop.CanCollide = false
    drop.Material = Enum.Material.Neon
    drop.Shape = Enum.PartType.Ball
    
    -- Cores por tipo
    local colors = {
        Cash = Color3.fromRGB(255, 215, 0),
        Diamonds = Color3.fromRGB(0, 200, 255),
        Fragments = Color3.fromRGB(150, 0, 255)
    }
    
    if dropType == "Shadow" then
        local rankColors = {
            F = Color3.fromRGB(128, 128, 128),
            E = Color3.fromRGB(255, 255, 255),
            D = Color3.fromRGB(0, 255, 0),
            C = Color3.fromRGB(0, 150, 255),
            B = Color3.fromRGB(150, 0, 255),
            A = Color3.fromRGB(255, 165, 0),
            S = Color3.fromRGB(255, 0, 0),
            SS = Color3.fromRGB(255, 215, 0),
            GM = Color3.fromRGB(255, 0, 255)
        }
        drop.Color = rankColors[npcRank] or Color3.fromRGB(255, 255, 255)
    else
        drop.Color = colors[dropType] or Color3.fromRGB(255, 255, 255)
    end
    
    drop.Parent = workspace
    
    -- Partículas
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particle.Color = ColorSequence.new(drop.Color)
    particle.Size = NumberSequence.new(0.5)
    particle.Lifetime = NumberRange.new(1)
    particle.Rate = 20
    particle.Speed = NumberRange.new(2)
    particle.Parent = drop
    
    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 120, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = drop
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.5
    label.Parent = billboard
    
    if dropType == "Shadow" then
        label.Text = "🧞 " .. npcRank .. "\n[Auto-coleta]"
        drop:SetAttribute("ShadowRank", npcRank)
    else
        label.Text = "+" .. amount .. "\n" .. dropType
    end
    
    drop:SetAttribute("DropType", dropType)
    drop:SetAttribute("Amount", amount)
    
    -- Rotação
    task.spawn(function()
        while drop.Parent do
            drop.CFrame = drop.CFrame * CFrame.Angles(0, math.rad(3), 0)
            task.wait(0.03)
        end
    end)
    
    -- Auto-coletar
    task.delay(2, function()
        if drop.Parent then
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character.PrimaryPart then
                    local distance = (player.Character.PrimaryPart.Position - drop.Position).Magnitude
                    if distance <= 40 then
                        collectDrop(player, drop)
                        break
                    end
                end
            end
        end
    end)
    
    Debris:AddItem(drop, 30)
    return drop
end

-- ==================== COLETAR DROP ====================
function collectDrop(player, drop)
    if not drop.Parent then return end
    
    local dropType = drop:GetAttribute("DropType")
    local amount = drop:GetAttribute("Amount")
    local data = PlayerData[player.UserId]
    
    if not data then return end
    
    if dropType == "Cash" then
        data.Cash = data.Cash + amount
        updateLeaderstats(player)
        notifyPlayer(player, "💰 +" .. amount .. " Cash", Color3.fromRGB(255, 215, 0))
        
    elseif dropType == "Diamonds" then
        data.Diamonds = data.Diamonds + amount
        notifyPlayer(player, "💎 +" .. amount .. " Diamantes", Color3.fromRGB(0, 200, 255))
        
    elseif dropType == "Fragments" then
        data.Fragments = data.Fragments + amount
        notifyPlayer(player, "🔷 +" .. amount .. " Fragmentos", Color3.fromRGB(150, 0, 255))
        
    elseif dropType == "Shadow" then
        local shadowRank = drop:GetAttribute("ShadowRank")
        showShadowChoice(player, shadowRank, drop)
        return
    end
    
    -- Efeito visual
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(3, 3, 3)
    effect.Anchored = true
    effect.CanCollide = false
    effect.Material = Enum.Material.Neon
    effect.Color = drop.Color
    effect.Transparency = 0.5
    effect.CFrame = drop.CFrame
    effect.Shape = Enum.PartType.Ball
    effect.Parent = workspace
    
    TweenService:Create(effect, TweenInfo.new(0.5), {
        Size = Vector3.new(6, 6, 6),
        Transparency = 1
    }):Play()
    
    Debris:AddItem(effect, 0.5)
    drop:Destroy()
end

-- ==================== MENU DE ESCOLHA DE SOMBRA ====================
function showShadowChoice(player, shadowRank, drop)
    local data = PlayerData[player.UserId]
    if not data then return end
    
    -- Remover GUI antiga
    local oldGui = player.PlayerGui:FindFirstChild("ShadowChoice")
    if oldGui then oldGui:Destroy() end
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "ShadowChoice"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 450, 0, 280)
    frame.Position = UDim2.new(0.5, -225, 0.5, -140)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 60)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "🧞 SOMBRA CAPTURADA!"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 90)
    info.Position = UDim2.new(0, 10, 0, 70)
    info.BackgroundTransparency = 1
    info.Text = "Rank: " .. shadowRank .. "\n\nO que deseja fazer com esta sombra?"
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.Font = Enum.Font.Gotham
    info.TextSize = 18
    info.Parent = frame
    
    -- Botão Coletar
    local btnColetar = Instance.new("TextButton")
    btnColetar.Size = UDim2.new(0, 200, 0, 55)
    btnColetar.Position = UDim2.new(0.5, -100, 0, 170)
    btnColetar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btnColetar.Text = "✓ COLETAR SOMBRA"
    btnColetar.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnColetar.Font = Enum.Font.GothamBold
    btnColetar.TextSize = 18
    btnColetar.Parent = frame
    
    local btnColetarCorner = Instance.new("UICorner")
    btnColetarCorner.CornerRadius = UDim.new(0, 10)
    btnColetarCorner.Parent = btnColetar
    
    -- Botão Destruir
    local btnDestruir = Instance.new("TextButton")
    btnDestruir.Size = UDim2.new(0, 200, 0, 55)
    btnDestruir.Position = UDim2.new(0.5, -100, 0, 235)
    btnDestruir.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btnDestruir.Text = "💎 DESTRUIR (+50 💎)"
    btnDestruir.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnDestruir.Font = Enum.Font.GothamBold
    btnDestruir.TextSize = 18
    btnDestruir.Parent = frame
    
    local btnDestruirCorner = Instance.new("UICorner")
    btnDestruirCorner.CornerRadius = UDim.new(0, 10)
    btnDestruirCorner.Parent = btnDestruir
    
    -- Evento Coletar
    btnColetar.MouseButton1Click:Connect(function()
        table.insert(data.Shadows, {
            Rank = shadowRank,
            Name = "Sombra " .. shadowRank,
            CapturedAt = os.time()
        })
        
        notifyPlayer(player, "🧞 Sombra " .. shadowRank .. " coletada!", Color3.fromRGB(0, 255, 0))
        print("✅", player.Name, "coletou sombra", shadowRank)
        
        if drop.Parent then drop:Destroy() end
        gui:Destroy()
    end)
    
    -- Evento Destruir
    btnDestruir.MouseButton1Click:Connect(function()
        local diamonds = 50
        data.Diamonds = data.Diamonds + diamonds
        
        notifyPlayer(player, "💎 +" .. diamonds .. " Diamantes!", Color3.fromRGB(0, 200, 255))
        print("💎", player.Name, "destruiu sombra", shadowRank, "por", diamonds, "diamantes")
        
        if drop.Parent then drop:Destroy() end
        gui:Destroy()
    end)
    
    -- Auto-fechar
    task.delay(15, function()
        if gui.Parent then
            gui:Destroy()
            if drop.Parent then drop:Destroy() end
        end
    end)
end

-- ==================== PROCESSAR MORTE DE NPC ====================
local function processNPCKill(player, npc)
    local data = initPlayerData(player)
    data.TotalKills = data.TotalKills + 1
    
    local npcRank = npc:GetAttribute("Rank") or "F"
    local dropPos = npc.PrimaryPart.Position
    
    print("💀 Kill:", player.Name, "→", npc.Name, "Rank:", npcRank)
    
    -- Cash (sempre)
    local cashValues = {
        F = {10, 25}, E = {25, 50}, D = {50, 100}, C = {100, 200},
        B = {200, 400}, A = {400, 800}, S = {800, 1600},
        SS = {1600, 3200}, GM = {5000, 10000}
    }
    local cashRange = cashValues[npcRank] or cashValues.F
    local cash = math.random(cashRange[1], cashRange[2])
    createDrop(dropPos, "Cash", cash, npcRank)
    
    -- XP (direto)
    local xpValues = {F=10, E=20, D=40, C=80, B=160, A=320, S=640, SS=1280, GM=5000}
    local xp = xpValues[npcRank] or 10
    data.XP = data.XP + xp
    notifyPlayer(player, "⭐ +" .. xp .. " XP", Color3.fromRGB(255, 255, 0))
    
    -- Fragmentos (40%)
    if math.random() <= 0.4 then
        createDrop(dropPos, "Fragments", math.random(5, 20), npcRank)
    end
    
    -- Sombra (chance por rank)
    local captureChances = {
        F=0.7, E=0.6, D=0.5, C=0.4, B=0.3, A=0.2, S=0.1, SS=0.05, GM=0.01
    }
    if math.random() <= (captureChances[npcRank] or 0.25) then
        createDrop(dropPos, "Shadow", 0, npcRank)
    end
    
    -- Diamantes (5%)
    if math.random() <= 0.05 then
        createDrop(dropPos, "Diamonds", math.random(1, 5), npcRank)
    end
end

-- ==================== COMBATE ====================
combatEvent.OnServerEvent:Connect(function(player, action, targetPosition)
    local character = player.Character
    if not character or not character.PrimaryPart then return end
    
    initPlayerData(player)
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:GetAttribute("IsNPC") then
            local npcPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if npcPart then
                local distance = (npcPart.Position - character.PrimaryPart.Position).Magnitude
                
                if distance <= 20 then
                    local humanoid = obj:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        humanoid:TakeDamage(25)
                        
                        if humanoid.Health <= 0 then
                            processNPCKill(player, obj)
                        end
                        break
                    end
                end
            end
        end
    end
end)

-- ==================== JOGADORES ====================
Players.PlayerAdded:Connect(function(player)
    initPlayerData(player)
    updateLeaderstats(player)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerData[player.UserId] = nil
end)

print("\n✅ ========== SISTEMA PRONTO! ==========")
print("💰 Cash: Sempre dropa")
print("⭐ XP: Ganho automático")
print("🔷 Fragmentos: 40% chance")
print("🧞 Sombras: Chance por rank (70% F → 1% GM)")
print("💎 Diamantes: 5% chance")
print("========================================\n")
