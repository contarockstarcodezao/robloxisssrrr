# 💰 CORRIGIR DROPS E CAPTURA DE SOMBRAS

## 🚨 PROBLEMA: NPCs morrem mas não dão drops nem sombras

---

## ⚡ SOLUÇÃO COMPLETA (Cole 1 script)

### 📜 Script Completo de Drops e Sombras

Cole este script em **ServerScriptService** como **Script**:

```lua
-- Nome: DropsSombrasCompleto

print("💰 ========== SISTEMA DE DROPS E SOMBRAS ==========")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Criar ou pegar RemoteEvent
local combatEvent = ReplicatedStorage:FindFirstChild("CombatEvent")
if not combatEvent then
    combatEvent = Instance.new("RemoteEvent")
    combatEvent.Name = "CombatEvent"
    combatEvent.Parent = ReplicatedStorage
end

local shadowEvent = ReplicatedStorage:FindFirstChild("ShadowEvent")
if not shadowEvent then
    shadowEvent = Instance.new("RemoteEvent")
    shadowEvent.Name = "ShadowEvent"
    shadowEvent.Parent = ReplicatedStorage
end

-- Dados dos jogadores (simplificado)
local PlayerData = {}

-- Função para inicializar dados do jogador
local function initPlayerData(player)
    if not PlayerData[player.UserId] then
        PlayerData[player.UserId] = {
            Cash = 1000,
            Diamonds = 50,
            Fragments = 0,
            Level = 1,
            XP = 0,
            Shadows = {},
            TotalKills = 0
        }
        print("✅ Dados inicializados para:", player.Name)
    end
    return PlayerData[player.UserId]
end

-- Atualizar leaderstats
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

-- Sistema de drops visuais
local function createDrop(position, dropType, amount, npcRank)
    local drop = Instance.new("Part")
    drop.Name = "Drop_" .. dropType
    drop.Size = Vector3.new(1.5, 1.5, 1.5)
    drop.Position = position + Vector3.new(math.random(-2, 2), 2, math.random(-2, 2))
    drop.Anchored = true
    drop.CanCollide = false
    drop.Material = Enum.Material.Neon
    drop.Shape = Enum.PartType.Ball
    
    -- Cor baseada no tipo
    if dropType == "Cash" then
        drop.Color = Color3.fromRGB(255, 215, 0) -- Dourado
    elseif dropType == "Diamonds" then
        drop.Color = Color3.fromRGB(0, 200, 255) -- Azul
    elseif dropType == "Fragments" then
        drop.Color = Color3.fromRGB(150, 0, 255) -- Roxo
    elseif dropType == "Shadow" then
        -- Cor baseada no rank
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
    end
    
    drop.Parent = workspace
    
    -- Efeito de partículas
    local particle = Instance.new("ParticleEmitter")
    particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particle.Color = ColorSequence.new(drop.Color)
    particle.Size = NumberSequence.new(0.5)
    particle.Lifetime = NumberRange.new(1)
    particle.Rate = 20
    particle.Speed = NumberRange.new(2)
    particle.Parent = drop
    
    -- BillboardGui com informação
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = drop
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = billboard
    
    if dropType == "Shadow" then
        label.Text = "🧞 " .. npcRank .. "\n[E] Capturar"
        drop:SetAttribute("ShadowRank", npcRank)
    else
        label.Text = dropType .. "\n+" .. amount
    end
    
    drop:SetAttribute("DropType", dropType)
    drop:SetAttribute("Amount", amount)
    
    -- Rotação contínua
    task.spawn(function()
        while drop.Parent do
            drop.CFrame = drop.CFrame * CFrame.Angles(0, math.rad(2), 0)
            task.wait(0.03)
        end
    end)
    
    -- Auto-coletar após 2 segundos
    task.delay(2, function()
        if drop.Parent then
            -- Procurar jogador próximo
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character.PrimaryPart then
                    local distance = (player.Character.PrimaryPart.Position - drop.Position).Magnitude
                    if distance <= 30 then
                        collectDrop(player, drop)
                        break
                    end
                end
            end
        end
    end)
    
    -- Remover após 30 segundos
    game:GetService("Debris"):AddItem(drop, 30)
    
    return drop
end

-- Coletar drop
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
        captureShadow(player, shadowRank, drop)
        return -- Não destruir ainda, deixar jogador escolher
    end
    
    -- Efeito de coleta
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
    
    local tween = game:GetService("TweenService"):Create(
        effect,
        TweenInfo.new(0.5),
        {Size = Vector3.new(6, 6, 6), Transparency = 1}
    )
    tween:Play()
    game:GetService("Debris"):AddItem(effect, 0.5)
    
    drop:Destroy()
end

-- Capturar sombra
function captureShadow(player, shadowRank, drop)
    local data = PlayerData[player.UserId]
    if not data then return end
    
    -- Criar GUI de escolha
    local gui = Instance.new("ScreenGui")
    gui.Name = "ShadowChoice"
    gui.ResetOnSpawn = false
    gui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 250)
    frame.Position = UDim2.new(0.5, -200, 0.5, -125)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 3
    frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    title.BorderSizePixel = 0
    title.Text = "🧞 SOMBRA CAPTURADA!"
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundTransparency = 1
    info.Text = "Rank: " .. shadowRank .. "\nO que deseja fazer?"
    info.TextColor3 = Color3.fromRGB(255, 255, 255)
    info.Font = Enum.Font.Gotham
    info.TextSize = 18
    info.Parent = frame
    
    -- Botão Coletar
    local btnColetar = Instance.new("TextButton")
    btnColetar.Size = UDim2.new(0, 180, 0, 50)
    btnColetar.Position = UDim2.new(0.5, -90, 0, 150)
    btnColetar.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    btnColetar.Text = "✓ COLETAR SOMBRA"
    btnColetar.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnColetar.Font = Enum.Font.GothamBold
    btnColetar.TextSize = 16
    btnColetar.Parent = frame
    
    local btnColetarCorner = Instance.new("UICorner")
    btnColetarCorner.CornerRadius = UDim.new(0, 8)
    btnColetarCorner.Parent = btnColetar
    
    -- Botão Destruir
    local btnDestruir = Instance.new("TextButton")
    btnDestruir.Size = UDim2.new(0, 180, 0, 50)
    btnDestruir.Position = UDim2.new(0.5, -90, 0, 210)
    btnDestruir.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btnDestruir.Text = "💎 DESTRUIR (+50 💎)"
    btnDestruir.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnDestruir.Font = Enum.Font.GothamBold
    btnDestruir.TextSize = 16
    btnDestruir.Parent = frame
    
    local btnDestruirCorner = Instance.new("UICorner")
    btnDestruirCorner.CornerRadius = UDim.new(0, 8)
    btnDestruirCorner.Parent = btnDestruir
    
    -- Evento Coletar
    btnColetar.MouseButton1Click:Connect(function()
        local shadow = {
            Rank = shadowRank,
            Name = "Sombra " .. shadowRank,
            CapturedAt = os.time()
        }
        table.insert(data.Shadows, shadow)
        
        notifyPlayer(player, "🧞 Sombra " .. shadowRank .. " coletada!", Color3.fromRGB(0, 255, 0))
        
        if drop.Parent then
            drop:Destroy()
        end
        gui:Destroy()
    end)
    
    -- Evento Destruir
    btnDestruir.MouseButton1Click:Connect(function()
        local diamonds = 50
        data.Diamonds = data.Diamonds + diamonds
        
        notifyPlayer(player, "💎 +" .. diamonds .. " Diamantes!", Color3.fromRGB(0, 200, 255))
        
        if drop.Parent then
            drop:Destroy()
        end
        gui:Destroy()
    end)
    
    -- Auto-fechar após 15 segundos
    task.delay(15, function()
        if gui.Parent then
            gui:Destroy()
            if drop.Parent then
                drop:Destroy()
            end
        end
    end)
end

-- Notificar jogador
function notifyPlayer(player, text, color)
    local gui = Instance.new("ScreenGui")
    gui.Parent = player.PlayerGui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 300, 0, 60)
    label.Position = UDim2.new(0.5, -150, 0.8, 0)
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
    
    -- Animar
    label:TweenPosition(
        UDim2.new(0.5, -150, 0.7, 0),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.3
    )
    
    task.delay(2, function()
        label:TweenPosition(
            UDim2.new(0.5, -150, 0.6, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.3
        )
        task.wait(0.3)
        gui:Destroy()
    end)
end

-- Processar drops ao matar NPC
local function processNPCKill(player, npc)
    local data = initPlayerData(player)
    data.TotalKills = data.TotalKills + 1
    
    local npcRank = npc:GetAttribute("Rank") or "F"
    local dropPosition = npc.PrimaryPart.Position
    
    print("💀 NPC morto:", npc.Name, "| Rank:", npcRank, "| Killer:", player.Name)
    
    -- Cash (sempre dropa)
    local cashValues = {
        F = {Min = 10, Max = 25},
        E = {Min = 25, Max = 50},
        D = {Min = 50, Max = 100},
        C = {Min = 100, Max = 200},
        B = {Min = 200, Max = 400},
        A = {Min = 400, Max = 800},
        S = {Min = 800, Max = 1600},
        SS = {Min = 1600, Max = 3200},
        GM = {Min = 5000, Max = 10000}
    }
    local cashData = cashValues[npcRank] or cashValues.F
    local cash = math.random(cashData.Min, cashData.Max)
    createDrop(dropPosition, "Cash", cash, npcRank)
    
    -- XP (dar diretamente)
    local xpValues = {F=10, E=20, D=40, C=80, B=160, A=320, S=640, SS=1280, GM=5000}
    local xp = xpValues[npcRank] or 10
    data.XP = data.XP + xp
    notifyPlayer(player, "⭐ +" .. xp .. " XP", Color3.fromRGB(255, 255, 0))
    
    -- Fragmentos (40% chance)
    if math.random() <= 0.4 then
        local fragments = math.random(5, 20)
        createDrop(dropPosition, "Fragments", fragments, npcRank)
    end
    
    -- Sombra (chance baseada no rank)
    local captureChances = {
        F = 0.70, E = 0.60, D = 0.50, C = 0.40, B = 0.30,
        A = 0.20, S = 0.10, SS = 0.05, GM = 0.01
    }
    local chance = captureChances[npcRank] or 0.25
    
    if math.random() <= chance then
        createDrop(dropPosition, "Shadow", 0, npcRank)
    end
    
    -- Diamantes (raro - 5%)
    if math.random() <= 0.05 then
        local diamonds = math.random(1, 5)
        createDrop(dropPosition, "Diamonds", diamonds, npcRank)
    end
end

-- Sistema de combate
combatEvent.OnServerEvent:Connect(function(player, action, targetPosition)
    local character = player.Character
    if not character or not character.PrimaryPart then return end
    
    initPlayerData(player)
    
    -- Procurar NPCs próximos
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:GetAttribute("IsNPC") then
            local npcPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            if npcPart then
                local distance = (npcPart.Position - character.PrimaryPart.Position).Magnitude
                
                if distance <= 20 then
                    local humanoid = obj:FindFirstChild("Humanoid")
                    if humanoid and humanoid.Health > 0 then
                        humanoid:TakeDamage(25)
                        
                        -- Se matou
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

-- Eventos de jogadores
Players.PlayerAdded:Connect(function(player)
    initPlayerData(player)
    updateLeaderstats(player)
    
    print("👤 Jogador entrou:", player.Name)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerData[player.UserId] = nil
end)

print("✅ Sistema de Drops e Sombras ATIVO!")
print("💰 NPCs agora dropam: Cash, XP, Fragmentos, Sombras, Diamantes")
print("🧞 Sombras podem ser coletadas ou destruídas por diamantes")
print("================================================\n")
```

---

## 🎮 COMO FUNCIONA AGORA

Quando você matar um NPC:

1. ✅ **Cash** - Sempre dropa (10-10000 baseado no rank)
2. ✅ **XP** - Ganho automático (aparece notificação)
3. ✅ **Fragmentos** - 40% de chance (5-20 unidades)
4. ✅ **Sombra** - Chance baseada no rank (70% F até 1% GM)
5. ✅ **Diamantes** - 5% de chance (1-5 unidades)

### 🧞 Sistema de Sombras:

Quando uma sombra dropar:
1. Aparece uma **bola brilhante** com a cor do rank
2. Mostra **"[E] Capturar"** (auto-coleta em 2 segundos)
3. Abre menu com 2 opções:
   - **✓ COLETAR** - Adiciona à sua coleção
   - **💎 DESTRUIR** - Recebe 50 diamantes

---

## ✅ RESULTADO ESPERADO

### No Output:
```
✅ Sistema de Drops e Sombras ATIVO!
💀 NPC morto: NPC_F | Rank: F | Killer: SeuNome
```

### No Jogo:
1. 💰 Drops aparecem flutuando
2. 🔄 Giram automaticamente
3. ✨ Tem efeito de partículas
4. 📊 Mostram quantidade
5. 🧲 Auto-coletam após 2 segundos
6. 💬 Notificações aparecem na tela
7. 🧞 Sombras abrem menu de escolha

---

## 🔧 TESTE RÁPIDO

1. Cole o script acima
2. Pressione F5
3. Mate um NPC
4. Veja os drops aparecerem!

---

**Agora os drops e sombras funcionam! 💰🧞✨**
