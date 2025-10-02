--[[
    NPCManager.lua - CORRIGIDO
    Cole em: ServerScriptService/Combat/NPCManager (Script)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NPCData = require(ReplicatedStorage.Modules.NPCData)

local NPCManager = {}
NPCManager.ActiveNPCs = {}
NPCManager.NPCHealths = {}
NPCManager.OnNPCDeathCallback = nil

function NPCManager:CreateNPCModel(npcData)
    local model = Instance.new("Model")
    model.Name = npcData.Name
    local torso = Instance.new("Part")
    torso.Name = "HumanoidRootPart"
    torso.Size = Vector3.new(2, 3, 1)
    torso.Color = npcData.ModelColor
    torso.Anchored = false
    torso.CanCollide = true
    torso.Parent = model
    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1.5, 1.5, 1.5)
    head.Color = npcData.ModelColor
    head.Parent = model
    head.Position = torso.Position + Vector3.new(0, 2.25, 0)
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = torso
    weld.Part1 = head
    weld.Parent = torso
    local humanoid = Instance.new("Humanoid")
    humanoid.MaxHealth = npcData.Health
    humanoid.Health = npcData.Health
    humanoid.WalkSpeed = 0
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.Parent = model
    model.PrimaryPart = torso
    return model
end

function NPCManager:SpawnNPC(npcName, position, zone)
    local npcData = NPCData:GetNPCByName(npcName)
    if not npcData then return nil end
    local npcModel = self:CreateNPCModel(npcData)
    npcModel:SetPrimaryPartCFrame(CFrame.new(position))
    npcModel.Parent = workspace:FindFirstChild("NPCs") or workspace
    self.ActiveNPCs[npcModel] = {Data = npcData, Zone = zone, SpawnTime = tick()}
    self.NPCHealths[npcModel] = npcData.Health
    local humanoid = npcModel:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Connect(function()
            self:OnNPCDeath(npcModel, npcData)
        end)
    end
    return npcModel
end

function NPCManager:OnNPCDeath(npc, npcData)
    if self.OnNPCDeathCallback then
        self.OnNPCDeathCallback(npc, npcData)
    end
    self:CreateCapturePrompt(npc, npcData)
end

function NPCManager:CreateCapturePrompt(npc, npcData)
    local rootPart = npc:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local promptPart = Instance.new("Part")
    promptPart.Name = "CapturePrompt"
    promptPart.Size = Vector3.new(4, 1, 4)
    promptPart.Transparency = 0.7
    promptPart.Color = Color3.fromRGB(100, 0, 200)
    promptPart.Material = Enum.Material.Neon
    promptPart.Anchored = true
    promptPart.CanCollide = false
    promptPart.Position = rootPart.Position
    promptPart:SetAttribute("NPCName", npcData.Name)
    promptPart:SetAttribute("NPCRank", npcData.Rank)
    promptPart.Parent = workspace
    game:GetService("Debris"):AddItem(promptPart, 30)
    game:GetService("Debris"):AddItem(npc, 31)
end

function NPCManager:DamageNPC(npc, damage, attacker)
    if not self.ActiveNPCs[npc] then return false end
    local currentHealth = self.NPCHealths[npc]
    if not currentHealth then return false end
    local npcData = self.ActiveNPCs[npc].Data
    local actualDamage = math.max(1, damage - npcData.Defense)
    currentHealth = currentHealth - actualDamage
    self.NPCHealths[npc] = currentHealth
    if currentHealth <= 0 then
        self.ActiveNPCs[npc].Killer = attacker
        local humanoid = npc:FindFirstChild("Humanoid")
        if humanoid then humanoid.Health = 0 end
    end
    return true
end

function NPCManager:Init()
    if not workspace:FindFirstChild("NPCs") then
        local npcsFolder = Instance.new("Folder")
        npcsFolder.Name = "NPCs"
        npcsFolder.Parent = workspace
    end
    print("[NPCManager] ✅ Inicializado")
end

return NPCManager
