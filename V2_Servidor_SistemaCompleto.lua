-- SISTEMA COMPLETO V2.0 - SERVIDOR
-- Cole em ServerScriptService como Script
-- Nome: SistemaCompletoServidor

print("🎮 ========== ARISE CROSSOVER V2.0 - SERVIDOR ==========")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local HttpService = game:GetService("HttpService")

-- ==================== CRIAR REMOTEEVENTS ====================
local function createRemote(name, rType)
    local existing = ReplicatedStorage:FindFirstChild(name)
    if existing then return existing end
    
    local remote
    if rType == "Event" then
        remote = Instance.new("RemoteEvent")
    else
        remote = Instance.new("RemoteFunction")
    end
    remote.Name = name
    remote.Parent = ReplicatedStorage
    print("✅ Criado:", name)
    return remote
end

local GameEvents = {
    Combat = createRemote("CombatEvent", "Event"),
    UpdateUI = createRemote("UpdateUIEvent", "Event"),
    ShadowChoice = createRemote("ShadowChoiceEvent", "Event"),
    DataRequest = createRemote("DataRequest", "Function")
}

-- ==================== DADOS DOS JOGADORES ====================
local PlayerData = {}

local function getDefaultData()
    return {
        Cash = 1000,
        Diamonds = 50,
        Fragments = 0,
        Level = 1,
        XP = 0,
        XPToNextLevel = 100,
        Shadows = {},
        EquippedWeapon = "Sword",
        Stats = {
            TotalKills = 0,
            ShadowsCaptured = 0,
            ShadowsDestroyed = 0
        }
    }
end

local function initPlayer(player)
    if not PlayerData[player.UserId] then
        PlayerData[player.UserId] = getDefaultData()
        print("✅ Dados inicializados:", player.Name)
    end
    return PlayerData[player.UserId]
end

-- ==================== ATUALIZAR UI ====================
local function updatePlayerUI(player)
    local data = PlayerData[player.UserId]
    if not data then return end
    
    GameEvents.UpdateUI:FireClient(player, "FullUpdate", {
        Cash = data.Cash,
        Diamonds = data.Diamonds,
        Fragments = data.Fragments,
        Level = data.Level,
        XP = data.XP,
        XPToNextLevel = data.XPToNextLevel,
        ShadowCount = #data.Shadows
    })
end

-- ==================== SISTEMA DE XP ====================
local function addXP(player, amount)
    local data = PlayerData[player.UserId]
    if not data then return end
    
    data.XP = data.XP + amount
    
    while data.XP >= data.XPToNextLevel do
        data.XP = data.XP - data.XPToNextLevel
        data.Level = data.Level + 1
        data.XPToNextLevel = math.floor(data.XPToNextLevel * 1.15)
        
        GameEvents.UpdateUI:FireClient(player, "LevelUp", {
            NewLevel = data.Level,
            XPToNext = data.XPToNextLevel
        })
        
        print("🎉", player.Name, "subiu para nível", data.Level)
    end
    
    updatePlayerUI(player)
end

-- ==================== SISTEMA DE DROPS ====================
local dropsAtivos = {}

local function createDrop(position, dropType, amount, npcRank)
    local dropId = HttpService:GenerateGUID(false)
    
    local drop = Instance.new("Part")
    drop.Name = "Drop_" .. dropId
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
        Fragments = Color3.fromRGB(150, 0, 255),
        XP = Color3.fromRGB(255, 255, 0)
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
        drop.Color = rankColors[npcRank] or Color3.new(1, 1, 1)
    else
        drop.Color = colors[dropType] or Color3.new(1, 1, 1)
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
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = drop
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.Parent = billboard
    
    if dropType == "Shadow" then
        label.Text = "🧞 " .. npcRank
    else
        label.Text = "+" .. amount
    end
    
    -- Salvar info
    dropsAtivos[dropId] = {
        Part = drop,
        Type = dropType,
        Amount = amount,
        Rank = npcRank,
        Time = tick()
    }
    
    -- Rotação
    task.spawn(function()
        while drop.Parent do
            drop.CFrame = drop.CFrame * CFrame.Angles(0, math.rad(3), 0)
            task.wait(0.03)
        end
    end)
    
    -- Auto-coleta
    task.spawn(function()
        task.wait(1)
        while drop.Parent do
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character.PrimaryPart then
                    local dist = (player.Character.PrimaryPart.Position - drop.Position).Magnitude
                    if dist <= 15 then
                        collectDrop(player, dropId)
                        return
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    
    -- Auto-delete
    task.delay(30, function()
        if dropsAtivos[dropId] then
            if dropsAtivos[dropId].Part and dropsAtivos[dropId].Part.Parent then
                dropsAtivos[dropId].Part:Destroy()
            end
            dropsAtivos[dropId] = nil
        end
    end)
    
    return dropId
end

-- ==================== COLETAR DROP ====================
function collectDrop(player, dropId)
    local dropInfo = dropsAtivos[dropId]
    if not dropInfo or not dropInfo.Part or not dropInfo.Part.Parent then return end
    
    local data = PlayerData[player.UserId]
    if not data then return end
    
    local dropType = dropInfo.Type
    local amount = dropInfo.Amount
    
    if dropType == "Cash" then
        data.Cash = data.Cash + amount
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "💰 +" .. amount .. " Cash",
            Color = Color3.fromRGB(255, 215, 0)
        })
        
    elseif dropType == "Diamonds" then
        data.Diamonds = data.Diamonds + amount
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "💎 +" .. amount .. " Diamantes",
            Color = Color3.fromRGB(0, 200, 255)
        })
        
    elseif dropType == "Fragments" then
        data.Fragments = data.Fragments + amount
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "🔷 +" .. amount .. " Fragmentos",
            Color = Color3.fromRGB(150, 0, 255)
        })
        
    elseif dropType == "XP" then
        addXP(player, amount)
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "⭐ +" .. amount .. " XP",
            Color = Color3.fromRGB(255, 255, 0)
        })
        
    elseif dropType == "Shadow" then
        GameEvents.ShadowChoice:FireClient(player, dropInfo.Rank, dropId)
        return
    end
    
    -- Efeito visual
    local effect = Instance.new("Part")
    effect.Size = Vector3.new(3, 3, 3)
    effect.Anchored = true
    effect.CanCollide = false
    effect.Material = Enum.Material.Neon
    effect.Color = dropInfo.Part.Color
    effect.Transparency = 0.5
    effect.CFrame = dropInfo.Part.CFrame
    effect.Shape = Enum.PartType.Ball
    effect.Parent = workspace
    
    TweenService:Create(effect, TweenInfo.new(0.5), {
        Size = Vector3.new(6, 6, 6),
        Transparency = 1
    }):Play()
    
    Debris:AddItem(effect, 0.5)
    
    dropInfo.Part:Destroy()
    dropsAtivos[dropId] = nil
    
    updatePlayerUI(player)
end

-- ==================== ESCOLHA DE SOMBRA ====================
GameEvents.ShadowChoice.OnServerEvent:Connect(function(player, action, dropId)
    local dropInfo = dropsAtivos[dropId]
    if not dropInfo then return end
    
    local data = PlayerData[player.UserId]
    if not data then return end
    
    if action == "Collect" then
        table.insert(data.Shadows, {
            Rank = dropInfo.Rank,
            Name = "Sombra " .. dropInfo.Rank,
            Time = os.time()
        })
        data.Stats.ShadowsCaptured = data.Stats.ShadowsCaptured + 1
        
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "🧞 Sombra " .. dropInfo.Rank .. " coletada!",
            Color = Color3.fromRGB(0, 255, 0)
        })
        
    elseif action == "Destroy" then
        data.Diamonds = data.Diamonds + 50
        data.Stats.ShadowsDestroyed = data.Stats.ShadowsDestroyed + 1
        
        GameEvents.UpdateUI:FireClient(player, "Notification", {
            Text = "💎 +50 Diamantes!",
            Color = Color3.fromRGB(0, 200, 255)
        })
    end
    
    if dropInfo.Part and dropInfo.Part.Parent then
        dropInfo.Part:Destroy()
    end
    dropsAtivos[dropId] = nil
    
    updatePlayerUI(player)
end)

-- ==================== MORTE DE NPC ====================
local function onNPCKilled(player, npc)
    local data = initPlayer(player)
    data.Stats.TotalKills = data.Stats.TotalKills + 1
    
    local rank = npc:GetAttribute("Rank") or "F"
    local pos = npc.PrimaryPart.Position
    
    print("💀", player.Name, "matou", npc.Name, "Rank:", rank)
    
    -- Cash
    local cashValues = {
        F={10,25}, E={25,50}, D={50,100}, C={100,200},
        B={200,400}, A={400,800}, S={800,1600},
        SS={1600,3200}, GM={5000,10000}
    }
    local cashRange = cashValues[rank] or cashValues.F
    createDrop(pos, "Cash", math.random(cashRange[1], cashRange[2]), rank)
    
    -- XP
    local xpValues = {F=10, E=20, D=40, C=80, B=160, A=320, S=640, SS=1280, GM=5000}
    createDrop(pos, "XP", xpValues[rank] or 10, rank)
    
    -- Fragmentos (40%)
    if math.random() <= 0.4 then
        createDrop(pos, "Fragments", math.random(5, 20), rank)
    end
    
    -- Sombra
    local chances = {F=0.7, E=0.6, D=0.5, C=0.4, B=0.3, A=0.2, S=0.1, SS=0.05, GM=0.01}
    if math.random() <= (chances[rank] or 0.25) then
        createDrop(pos, "Shadow", 0, rank)
    end
    
    -- Diamantes (5%)
    if math.random() <= 0.05 then
        createDrop(pos, "Diamonds", math.random(1, 5), rank)
    end
end

-- ==================== COMBATE ====================
GameEvents.Combat.OnServerEvent:Connect(function(player, action)
    local char = player.Character
    if not char or not char.PrimaryPart then return end
    
    initPlayer(player)
    
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:GetAttribute("IsNPC") then
            local npcPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart")
            if npcPart then
                local dist = (npcPart.Position - char.PrimaryPart.Position).Magnitude
                if dist <= 20 then
                    local hum = obj:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        hum:TakeDamage(30)
                        
                        if hum.Health <= 0 then
                            onNPCKilled(player, obj)
                        end
                        break
                    end
                end
            end
        end
    end
end)

-- ==================== DATA REQUEST ====================
GameEvents.DataRequest.OnServerInvoke = function(player)
    return PlayerData[player.UserId] or getDefaultData()
end

-- ==================== JOGADORES ====================
Players.PlayerAdded:Connect(function(player)
    initPlayer(player)
    task.wait(2)
    updatePlayerUI(player)
end)

Players.PlayerRemoving:Connect(function(player)
    PlayerData[player.UserId] = nil
end)

print("✅ ========== SISTEMA V2.0 ATIVO! ==========")
print("💰 Drops funcionam e somem ao coletar")
print("🧞 Sombras com menu de escolha")
print("⭐ XP e Level Up integrados")
print("===========================================")
