--[[
    ZoneManager.lua
    Gerencia zonas, portais e spawn de NPCs
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local NPCData = require(ReplicatedStorage.Modules.NPCData)

local ZoneManager = {}
ZoneManager.NPCManager = nil
ZoneManager.RankSystem = nil

-- Definição das zonas
ZoneManager.Zones = {
    {
        Name = "BeginnerZone",
        DisplayName = "Floresta Silenciosa",
        RequiredRank = "F",
        SpawnPoint = Vector3.new(0, 10, 0),
        NPCs = {"Goblin Fraco", "Slime", "Goblin Guerreiro", "Lobo Selvagem"},
        NPCCount = 10,
        Color = Color3.fromRGB(100, 200, 100)
    },
    {
        Name = "IntermediateZone",
        DisplayName = "Deserto Árido",
        RequiredRank = "D",
        SpawnPoint = Vector3.new(200, 10, 0),
        NPCs = {"Escorpião do Deserto", "Bandido do Deserto", "Guerreiro Orc", "Mago das Sombras"},
        NPCCount = 8,
        Color = Color3.fromRGB(255, 200, 100)
    },
    {
        Name = "AdvancedZone",
        DisplayName = "Montanhas Congeladas",
        RequiredRank = "B",
        SpawnPoint = Vector3.new(400, 10, 0),
        NPCs = {"Yeti Congelado", "Cavaleiro Gélido", "Dragão Menor", "Golem Anciã"},
        NPCCount = 6,
        Color = Color3.fromRGB(150, 200, 255)
    },
    {
        Name = "EliteZone",
        DisplayName = "Vulcão Sombrio",
        RequiredRank = "S",
        SpawnPoint = Vector3.new(600, 10, 0),
        NPCs = {"Demônio de Fogo", "Goku", "Titã Sombrio", "Vegeta"},
        NPCCount = 5,
        Color = Color3.fromRGB(255, 100, 50)
    },
    {
        Name = "LegendaryZone",
        DisplayName = "Abismo Eterno",
        RequiredRank = "SSS",
        SpawnPoint = Vector3.new(800, 10, 0),
        NPCs = {"Rei Demônio", "Jiren", "Lúcifer", "Sung Jin-Woo"},
        NPCCount = 4,
        Color = Color3.fromRGB(150, 0, 200)
    }
}

-- Cria uma zona no mundo
function ZoneManager:CreateZone(zoneData)
    local zonesFolder = workspace:FindFirstChild("Zones") or Instance.new("Folder", workspace)
    zonesFolder.Name = "Zones"
    
    local zoneFolder = Instance.new("Folder")
    zoneFolder.Name = zoneData.Name
    zoneFolder.Parent = zonesFolder
    
    -- Cria plataforma base
    local basePart = Instance.new("Part")
    basePart.Name = "ZoneBase"
    basePart.Size = Vector3.new(150, 1, 150)
    basePart.Position = zoneData.SpawnPoint
    basePart.Anchored = true
    basePart.Color = zoneData.Color
    basePart.Material = Enum.Material.Grass
    basePart.Parent = zoneFolder
    
    -- Cria spawn point do jogador
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "SpawnLocation"
    spawnLocation.Size = Vector3.new(6, 1, 6)
    spawnLocation.Position = zoneData.SpawnPoint + Vector3.new(0, 5, 0)
    spawnLocation.Anchored = true
    spawnLocation.Color = Color3.fromRGB(100, 255, 100)
    spawnLocation.Transparency = 0.5
    spawnLocation.CanCollide = false
    spawnLocation.Enabled = false -- Spawn manual
    spawnLocation.Parent = zoneFolder
    
    -- Cria label da zona
    local labelPart = Instance.new("Part")
    labelPart.Name = "ZoneLabel"
    labelPart.Size = Vector3.new(0.1, 0.1, 0.1)
    labelPart.Position = zoneData.SpawnPoint + Vector3.new(0, 20, 0)
    labelPart.Anchored = true
    labelPart.Transparency = 1
    labelPart.CanCollide = false
    labelPart.Parent = zoneFolder
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 400, 0, 100)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = labelPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = zoneData.DisplayName .. "\n[Rank " .. zoneData.RequiredRank .. "+]"
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 32
    textLabel.Parent = billboardGui
    
    -- Spawna NPCs na zona
    self:SpawnNPCsInZone(zoneData)
    
    return zoneFolder
end

-- Spawna NPCs em uma zona
function ZoneManager:SpawnNPCsInZone(zoneData)
    local spawnPoints = self:GenerateSpawnPoints(zoneData.SpawnPoint, zoneData.NPCCount)
    
    for _, spawnPoint in ipairs(spawnPoints) do
        local npcName = zoneData.NPCs[math.random(1, #zoneData.NPCs)]
        self.NPCManager:SpawnNPC(npcName, spawnPoint, zoneData.Name)
    end
end

-- Gera pontos de spawn aleatórios em uma zona
function ZoneManager:GenerateSpawnPoints(center, count)
    local points = {}
    local radius = 60
    
    for i = 1, count do
        local angle = (i / count) * math.pi * 2
        local distance = math.random(20, radius)
        local x = center.X + math.cos(angle) * distance
        local z = center.Z + math.sin(angle) * distance
        
        table.insert(points, Vector3.new(x, center.Y + 5, z))
    end
    
    return points
end

-- Cria portal entre zonas
function ZoneManager:CreatePortal(fromZone, toZone)
    local fromZoneData = self:GetZoneByName(fromZone)
    local toZoneData = self:GetZoneByName(toZone)
    
    if not fromZoneData or not toZoneData then return end
    
    local zonesFolder = workspace:FindFirstChild("Zones")
    if not zonesFolder then return end
    
    local fromFolder = zonesFolder:FindFirstChild(fromZone)
    if not fromFolder then return end
    
    -- Cria parte do portal
    local portalPart = Instance.new("Part")
    portalPart.Name = "Portal_" .. toZone
    portalPart.Size = Vector3.new(10, 15, 1)
    portalPart.Position = fromZoneData.SpawnPoint + Vector3.new(70, 7, 0)
    portalPart.Anchored = true
    portalPart.Color = toZoneData.Color
    portalPart.Material = Enum.Material.Neon
    portalPart.Transparency = 0.3
    portalPart.Parent = fromFolder
    
    -- Adiciona atributos
    portalPart:SetAttribute("ToZone", toZone)
    portalPart:SetAttribute("RequiredRank", toZoneData.RequiredRank)
    
    -- Label do portal
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 300, 0, 80)
    billboardGui.StudsOffset = Vector3.new(0, 8, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = portalPart
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Portal para\n" .. toZoneData.DisplayName
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 20
    textLabel.Parent = billboardGui
    
    -- Detecta quando jogador toca
    portalPart.Touched:Connect(function(hit)
        local character = hit.Parent
        local player = game.Players:GetPlayerFromCharacter(character)
        
        if player then
            self:TeleportToZone(player, toZone)
        end
    end)
    
    return portalPart
end

-- Teleporta jogador para zona
function ZoneManager:TeleportToZone(player, zoneName)
    local zoneData = self:GetZoneByName(zoneName)
    if not zoneData then return false end
    
    -- Verifica se jogador pode acessar
    local canAccess = self.RankSystem:CanAccessZone(player, zoneData.RequiredRank)
    
    if not canAccess then
        RemoteEvents.ShowNotification:FireClient(
            player,
            "Acesso Negado",
            "Você precisa ser Rank " .. zoneData.RequiredRank .. " ou superior para acessar esta zona",
            Color3.fromRGB(255, 100, 100)
        )
        return false
    end
    
    -- Teleporta
    local character = player.Character
    if character then
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CFrame = CFrame.new(zoneData.SpawnPoint + Vector3.new(0, 5, 0))
            
            RemoteEvents.ShowNotification:FireClient(
                player,
                "Bem-vindo!",
                "Você entrou em " .. zoneData.DisplayName,
                zoneData.Color
            )
            
            RemoteEvents.ZoneEntered:FireClient(player, zoneData)
            return true
        end
    end
    
    return false
end

-- Obtém zona por nome
function ZoneManager:GetZoneByName(name)
    for _, zone in ipairs(self.Zones) do
        if zone.Name == name then
            return zone
        end
    end
    return nil
end

-- Sistema de respawn de NPCs
function ZoneManager:StartNPCRespawn()
    spawn(function()
        while true do
            wait(30) -- Verifica a cada 30 segundos
            
            for _, zoneData in ipairs(self.Zones) do
                local npcsFolder = workspace:FindFirstChild("NPCs")
                if npcsFolder then
                    -- Conta NPCs na zona
                    local npcCount = 0
                    for _, npc in ipairs(npcsFolder:GetChildren()) do
                        if npc:IsA("Model") then
                            local npcInfo = self.NPCManager.ActiveNPCs[npc]
                            if npcInfo and npcInfo.Zone == zoneData.Name then
                                npcCount = npcCount + 1
                            end
                        end
                    end
                    
                    -- Spawna NPCs se necessário
                    local toSpawn = zoneData.NPCCount - npcCount
                    if toSpawn > 0 then
                        local spawnPoints = self:GenerateSpawnPoints(zoneData.SpawnPoint, toSpawn)
                        for _, spawnPoint in ipairs(spawnPoints) do
                            local npcName = zoneData.NPCs[math.random(1, #zoneData.NPCs)]
                            self.NPCManager:SpawnNPC(npcName, spawnPoint, zoneData.Name)
                        end
                    end
                end
            end
        end
    end)
end

-- Inicialização
function ZoneManager:Init(npcManager, rankSystem)
    self.NPCManager = npcManager
    self.RankSystem = rankSystem
    
    -- Cria todas as zonas
    for _, zoneData in ipairs(self.Zones) do
        self:CreateZone(zoneData)
    end
    
    -- Cria portais
    self:CreatePortal("BeginnerZone", "IntermediateZone")
    self:CreatePortal("IntermediateZone", "AdvancedZone")
    self:CreatePortal("AdvancedZone", "EliteZone")
    self:CreatePortal("EliteZone", "LegendaryZone")
    
    -- Inicia sistema de respawn
    self:StartNPCRespawn()
    
    -- Setup evento de teleporte
    RemoteEvents.TeleportToZone.OnServerEvent:Connect(function(player, zoneName)
        self:TeleportToZone(player, zoneName)
    end)
    
    print("[ZoneManager] Inicializado com sucesso!")
end

return ZoneManager
