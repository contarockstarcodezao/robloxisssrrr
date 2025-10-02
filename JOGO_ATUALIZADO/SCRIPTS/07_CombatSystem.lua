--[[
    CombatSystem.lua - CORRIGIDO
    Cole em: ServerScriptService/Combat/CombatSystem (Script)
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CombatSystem = {}
CombatSystem.DataManager = nil
CombatSystem.NPCManager = nil
CombatSystem.AttackCooldowns = {}
CombatSystem.Config = {AttackCooldown = 1.0, BaseDamage = 20, AttackRange = 10}

function CombatSystem:PlayerAttackNPC(player, npc)
    local lastAttack = self.AttackCooldowns[player.UserId] or 0
    local now = tick()
    if now - lastAttack < self.Config.AttackCooldown then return false end
    local character = player.Character
    if not character then return false end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart or not npcRootPart then return false end
    local distance = (humanoidRootPart.Position - npcRootPart.Position).Magnitude
    if distance > self.Config.AttackRange then return false end
    local damage = self:CalculatePlayerDamage(player)
    local success = self.NPCManager:DamageNPC(npc, damage, player)
    if success then
        self.AttackCooldowns[player.UserId] = now
        self.DataManager:IncrementStatistic(player, "DamageDealt", damage)
        return true
    end
    return false
end

function CombatSystem:CalculatePlayerDamage(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return self.Config.BaseDamage end
    local damage = self.Config.BaseDamage * (1 + (data.Level - 1) * 0.05)
    return math.floor(damage)
end

function CombatSystem:HandleNPCDeath(npc, npcData)
    local npcInfo = self.NPCManager.ActiveNPCs[npc]
    if not npcInfo then return end
    local killer = npcInfo.Killer
    if not killer or not killer.Parent then
        self.NPCManager.ActiveNPCs[npc] = nil
        self.NPCManager.NPCHealths[npc] = nil
        return
    end
    self:ProcessDrops(killer, npcData)
    self.DataManager:AddXP(killer, npcData.XPReward)
    self.DataManager:IncrementStatistic(killer, "NPCsKilled", 1)
    self.NPCManager.ActiveNPCs[npc] = nil
    self.NPCManager.NPCHealths[npc] = nil
end

function CombatSystem:ProcessDrops(player, npcData)
    if not npcData.Drops then return end
    for _, drop in ipairs(npcData.Drops) do
        if math.random() <= drop.Chance then
            local amount = math.random(drop.Amount[1], drop.Amount[2])
            if drop.Item == "Cash" then self.DataManager:AddCash(player, amount)
            elseif drop.Item == "Diamonds" then self.DataManager:AddDiamonds(player, amount) end
        end
    end
end

function CombatSystem:Init(dataManager, npcManager)
    self.DataManager = dataManager
    self.NPCManager = npcManager
    npcManager.OnNPCDeathCallback = function(npc, npcData)
        self:HandleNPCDeath(npc, npcData)
    end
    local re = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
    if re then
        local attackNPC = re:FindFirstChild("AttackNPC")
        if attackNPC then
            attackNPC.OnServerEvent:Connect(function(player, npc)
                self:PlayerAttackNPC(player, npc)
            end)
        end
    end
    print("[CombatSystem] ✅ Inicializado")
end

return CombatSystem
