--[[
    DUNGEON MANAGER
    Localização: ServerScriptService/Dungeons/DungeonManager.lua
    
    Este script gerencia o sistema de dungeons e raids:
    - Criação de instâncias
    - Spawn de inimigos e chefes
    - Sistema de recompensas
    - Matchmaking para raids
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

-- Importar dados e eventos
local ShadowData = require(ReplicatedStorage.Data.ShadowData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local DungeonManager = {}

-- Tipos de dungeons
local DUNGEON_TYPES = {
    SOLO = "Solo",
    PARTY = "Party",
    RAID = "Raid"
}

-- Dados das dungeons
local DUNGEON_DATA = {
    ["Forest Dungeon"] = {
        type = DUNGEON_TYPES.SOLO,
        level = 1,
        enemies = {"Shadow Wolf", "Shadow Bear"},
        boss = "Shadow Tiger",
        rewards = {
            cash = 1000,
            xp = 500,
            items = {"Iron Sword", "Health Potion"}
        },
        timeLimit = 300 -- 5 minutos
    },
    
    ["Cave Dungeon"] = {
        type = DUNGEON_TYPES.SOLO,
        level = 5,
        enemies = {"Shadow Bear", "Shadow Tiger"},
        boss = "Shadow Dragon",
        rewards = {
            cash = 2500,
            xp = 1000,
            items = {"Steel Sword", "Mana Potion"}
        },
        timeLimit = 600 -- 10 minutos
    },
    
    ["Volcano Dungeon"] = {
        type = DUNGEON_TYPES.PARTY,
        level = 10,
        enemies = {"Shadow Dragon", "Shadow Phoenix"},
        boss = "Shadow Phoenix",
        rewards = {
            cash = 5000,
            xp = 2000,
            items = {"Dragon Blade", "Thunder Fists"}
        },
        timeLimit = 900 -- 15 minutos
    },
    
    ["Shadow Realm"] = {
        type = DUNGEON_TYPES.RAID,
        level = 20,
        enemies = {"Shadow Dragon", "Shadow Phoenix"},
        boss = "Shadow Phoenix",
        rewards = {
            cash = 10000,
            xp = 5000,
            items = {"Excalibur", "God's Fist", "Dragon's Heart"}
        },
        timeLimit = 1800 -- 30 minutos
    }
}

-- Instâncias ativas
local activeInstances = {}
local playerInstances = {}

-- Criar instância de dungeon
function DungeonManager.CreateDungeonInstance(dungeonName, players)
    local dungeonData = DUNGEON_DATA[dungeonName]
    if not dungeonData then
        return nil
    end
    
    local instanceId = tick()
    local instance = {
        id = instanceId,
        name = dungeonName,
        data = dungeonData,
        players = players,
        enemies = {},
        boss = nil,
        startTime = tick(),
        status = "active",
        rewards = {}
    }
    
    activeInstances[instanceId] = instance
    
    -- Registrar jogadores na instância
    for _, player in ipairs(players) do
        playerInstances[player] = instanceId
    end
    
    -- Criar ambiente da dungeon
    DungeonManager.CreateDungeonEnvironment(instance)
    
    -- Spawnar inimigos
    DungeonManager.SpawnEnemies(instance)
    
    -- Iniciar timer
    DungeonManager.StartDungeonTimer(instance)
    
    return instance
end

-- Criar ambiente da dungeon
function DungeonManager.CreateDungeonEnvironment(instance)
    local dungeonData = instance.data
    
    -- Criar modelo da dungeon
    local model = Instance.new("Model")
    model.Name = "Dungeon_" .. instance.id
    model.Parent = workspace
    
    -- Criar chão
    local floor = Instance.new("Part")
    floor.Name = "Floor"
    floor.Size = Vector3.new(50, 1, 50)
    floor.Material = Enum.Material.Rock
    floor.Color = Color3.fromRGB(100, 100, 100)
    floor.Position = Vector3.new(0, 0, 0)
    floor.Anchored = true
    floor.Parent = model
    
    -- Criar paredes
    local walls = {
        {Position = Vector3.new(0, 5, 25), Size = Vector3.new(50, 10, 1)},
        {Position = Vector3.new(0, 5, -25), Size = Vector3.new(50, 10, 1)},
        {Position = Vector3.new(25, 5, 0), Size = Vector3.new(1, 10, 50)},
        {Position = Vector3.new(-25, 5, 0), Size = Vector3.new(1, 10, 50)}
    }
    
    for _, wallData in ipairs(walls) do
        local wall = Instance.new("Part")
        wall.Name = "Wall"
        wall.Size = wallData.Size
        wall.Material = Enum.Material.Rock
        wall.Color = Color3.fromRGB(80, 80, 80)
        wall.Position = wallData.Position
        wall.Anchored = true
        wall.Parent = model
    end
    
    -- Teleportar jogadores
    for _, player in ipairs(instance.players) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Position = Vector3.new(0, 5, 0)
        end
    end
    
    instance.environment = model
end

-- Spawnar inimigos
function DungeonManager.SpawnEnemies(instance)
    local dungeonData = instance.data
    
    -- Spawnar inimigos normais
    for i, enemyName in ipairs(dungeonData.enemies) do
        local enemy = DungeonManager.SpawnEnemy(enemyName, instance)
        if enemy then
            table.insert(instance.enemies, enemy)
        end
    end
    
    -- Spawnar chefe
    if dungeonData.boss then
        local boss = DungeonManager.SpawnBoss(dungeonData.boss, instance)
        if boss then
            instance.boss = boss
        end
    end
end

-- Spawnar inimigo
function DungeonManager.SpawnEnemy(enemyName, instance)
    local shadowData = ShadowData.SHADOWS[enemyName]
    if not shadowData then
        return nil
    end
    
    -- Criar modelo do inimigo
    local model = Instance.new("Model")
    model.Name = enemyName
    model.Parent = instance.environment
    
    -- Criar parte principal
    local part = Instance.new("Part")
    part.Name = "EnemyBody"
    part.Size = Vector3.new(4, 4, 4)
    part.Material = Enum.Material.Neon
    part.Color = ShadowData.RANKS[shadowData.rank].color
    part.Position = Vector3.new(math.random(-20, 20), 5, math.random(-20, 20))
    part.Parent = model
    
    -- Adicionar Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.Health = shadowData.baseHealth
    humanoid.MaxHealth = shadowData.baseHealth
    humanoid.Parent = model
    
    -- Adicionar RootPart
    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 1)
    rootPart.Material = Enum.Material.Neon
    rootPart.Color = ShadowData.RANKS[shadowData.rank].color
    rootPart.Position = part.Position
    rootPart.Parent = model
    
    -- Adicionar script de comportamento
    local behaviorScript = Instance.new("Script")
    behaviorScript.Name = "EnemyBehavior"
    behaviorScript.Parent = model
    
    return model
end

-- Spawnar chefe
function DungeonManager.SpawnBoss(bossName, instance)
    local boss = DungeonManager.SpawnEnemy(bossName, instance)
    if boss then
        -- Aumentar tamanho e atributos do chefe
        local body = boss:FindFirstChild("EnemyBody")
        if body then
            body.Size = Vector3.new(8, 8, 8)
        end
        
        local humanoid = boss:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = humanoid.Health * 3
            humanoid.MaxHealth = humanoid.MaxHealth * 3
        end
        
        -- Efeitos visuais do chefe
        local fire = Instance.new("Fire")
        fire.Parent = boss
        fire.Size = 3
        fire.Heat = 5
    end
    
    return boss
end

-- Iniciar timer da dungeon
function DungeonManager.StartDungeonTimer(instance)
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not activeInstances[instance.id] then
            connection:Disconnect()
            return
        end
        
        local elapsedTime = tick() - instance.startTime
        local timeLimit = instance.data.timeLimit
        
        -- Verificar se o tempo acabou
        if elapsedTime >= timeLimit then
            DungeonManager.EndDungeon(instance, "timeout")
            connection:Disconnect()
        end
        
        -- Verificar se todos os inimigos foram derrotados
        local allEnemiesDead = true
        for _, enemy in ipairs(instance.enemies) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                allEnemiesDead = false
                break
            end
        end
        
        if instance.boss and instance.boss:FindFirstChild("Humanoid") and instance.boss.Humanoid.Health > 0 then
            allEnemiesDead = false
        end
        
        if allEnemiesDead then
            DungeonManager.CompleteDungeon(instance)
            connection:Disconnect()
        end
    end)
end

-- Completar dungeon
function DungeonManager.CompleteDungeon(instance)
    instance.status = "completed"
    
    -- Dar recompensas
    DungeonManager.GiveRewards(instance)
    
    -- Notificar jogadores
    for _, player in ipairs(instance.players) do
        RemoteEvents.Dungeon.DungeonCompleted:FireClient(player, instance.name, instance.rewards)
    end
    
    -- Limpar instância
    DungeonManager.CleanupInstance(instance)
end

-- Finalizar dungeon
function DungeonManager.EndDungeon(instance, reason)
    instance.status = "ended"
    
    -- Notificar jogadores
    for _, player in ipairs(instance.players) do
        RemoteEvents.Dungeon.DungeonCompleted:FireClient(player, instance.name, nil, reason)
    end
    
    -- Limpar instância
    DungeonManager.CleanupInstance(instance)
end

-- Dar recompensas
function DungeonManager.GiveRewards(instance)
    local dungeonData = instance.data
    
    for _, player in ipairs(instance.players) do
        local rewards = {
            cash = dungeonData.rewards.cash,
            xp = dungeonData.rewards.xp,
            items = dungeonData.rewards.items
        }
        
        -- Dar cash
        if rewards.cash then
            RemoteEvents.Economy.AddCash:FireServer(player, rewards.cash)
        end
        
        -- Dar XP
        if rewards.xp then
            RemoteEvents.Level.GainXP:FireServer(player, rewards.xp, "dungeon")
        end
        
        -- Dar itens
        if rewards.items then
            for _, item in ipairs(rewards.items) do
                RemoteEvents.Inventory.AddItem:FireServer(player, item, 1)
            end
        end
        
        instance.rewards[player] = rewards
    end
end

-- Limpar instância
function DungeonManager.CleanupInstance(instance)
    -- Remover ambiente
    if instance.environment then
        instance.environment:Destroy()
    end
    
    -- Limpar dados dos jogadores
    for _, player in ipairs(instance.players) do
        playerInstances[player] = nil
    end
    
    -- Remover da lista de instâncias ativas
    activeInstances[instance.id] = nil
end

-- Entrar em dungeon
function DungeonManager.EnterDungeon(player, dungeonName)
    local dungeonData = DUNGEON_DATA[dungeonName]
    if not dungeonData then
        return false, "Dungeon não encontrada"
    end
    
    -- Verificar se o jogador já está em uma instância
    if playerInstances[player] then
        return false, "Jogador já está em uma dungeon"
    end
    
    -- Verificar requisitos de nível
    local playerData = -- TODO: Obter dados do jogador
    if playerData and playerData.level < dungeonData.level then
        return false, "Nível insuficiente"
    end
    
    -- Criar instância
    local instance = DungeonManager.CreateDungeonInstance(dungeonName, {player})
    if instance then
        return true, "Dungeon iniciada com sucesso!"
    else
        return false, "Erro ao criar instância"
    end
end

-- Sair da dungeon
function DungeonManager.ExitDungeon(player)
    local instanceId = playerInstances[player]
    if not instanceId then
        return false, "Jogador não está em uma dungeon"
    end
    
    local instance = activeInstances[instanceId]
    if instance then
        -- Remover jogador da instância
        for i, p in ipairs(instance.players) do
            if p == player then
                table.remove(instance.players, i)
                break
            end
        end
        
        playerInstances[player] = nil
        
        -- Teleportar jogador de volta
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Position = Vector3.new(0, 5, 0)
        end
        
        return true, "Saiu da dungeon"
    end
    
    return false, "Instância não encontrada"
end

-- Conectar eventos
RemoteEvents.Dungeon.EnterDungeon.OnServerEvent:Connect(function(player, dungeonName)
    local success, message = DungeonManager.EnterDungeon(player, dungeonName)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Dungeon.ExitDungeon.OnServerEvent:Connect(function(player)
    local success, message = DungeonManager.ExitDungeon(player)
    -- TODO: Implementar feedback visual
end)

return DungeonManager