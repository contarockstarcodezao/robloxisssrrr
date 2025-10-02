--[[
    NPCData.lua
    Cole em: ReplicatedStorage/Modules/NPCData (ModuleScript)
]]

local NPCData = {}

NPCData.NPCs = {
    {Name = "Goblin Fraco", Rank = "F", Health = 100, Damage = 5, Defense = 2, XPReward = 10, Level = 1, Zone = "BeginnerZone", ShadowDropChance = 0.05, Drops = {{Item = "Cash", Amount = {10, 30}, Chance = 1.0}, {Item = "Diamonds", Amount = {1, 3}, Chance = 0.3}}, ModelColor = Color3.fromRGB(100, 150, 100), AttackRange = 5, DetectionRange = 20},
    
    {Name = "Slime", Rank = "F", Health = 80, Damage = 3, Defense = 1, XPReward = 8, Level = 1, Zone = "BeginnerZone", ShadowDropChance = 0.05, Drops = {{Item = "Cash", Amount = {8, 25}, Chance = 1.0}}, ModelColor = Color3.fromRGB(100, 200, 255), AttackRange = 4, DetectionRange = 15},
    
    {Name = "Goblin Guerreiro", Rank = "E", Health = 250, Damage = 12, Defense = 5, XPReward = 25, Level = 10, Zone = "BeginnerZone", ShadowDropChance = 0.08, Drops = {{Item = "Cash", Amount = {30, 70}, Chance = 1.0}, {Item = "Diamonds", Amount = {3, 7}, Chance = 0.35}}, ModelColor = Color3.fromRGB(80, 130, 80), AttackRange = 6, DetectionRange = 25},
    
    {Name = "Escorpião do Deserto", Rank = "D", Health = 600, Damage = 30, Defense = 10, XPReward = 60, Level = 20, Zone = "IntermediateZone", ShadowDropChance = 0.12, Drops = {{Item = "Cash", Amount = {80, 150}, Chance = 1.0}, {Item = "Diamonds", Amount = {8, 15}, Chance = 0.45}}, ModelColor = Color3.fromRGB(200, 180, 100), AttackRange = 8, DetectionRange = 35},
    
    {Name = "Guerreiro Orc", Rank = "C", Health = 1200, Damage = 60, Defense = 20, XPReward = 120, Level = 35, Zone = "IntermediateZone", ShadowDropChance = 0.15, Drops = {{Item = "Cash", Amount = {200, 350}, Chance = 1.0}, {Item = "Diamonds", Amount = {20, 35}, Chance = 0.55}}, ModelColor = Color3.fromRGB(100, 150, 100), AttackRange = 10, DetectionRange = 45},
    
    {Name = "Yeti Congelado", Rank = "B", Health = 2500, Damage = 120, Defense = 40, XPReward = 250, Level = 50, Zone = "AdvancedZone", ShadowDropChance = 0.18, Drops = {{Item = "Cash", Amount = {400, 700}, Chance = 1.0}, {Item = "Diamonds", Amount = {40, 70}, Chance = 0.65}}, ModelColor = Color3.fromRGB(200, 220, 255), AttackRange = 12, DetectionRange = 55},
    
    {Name = "Dragão Menor", Rank = "A", Health = 5000, Damage = 250, Defense = 80, XPReward = 500, Level = 70, Zone = "AdvancedZone", ShadowDropChance = 0.22, Drops = {{Item = "Cash", Amount = {800, 1400}, Chance = 1.0}, {Item = "Diamonds", Amount = {80, 140}, Chance = 0.75}}, ModelColor = Color3.fromRGB(200, 100, 100), AttackRange = 15, DetectionRange = 70},
    
    {Name = "Goku", Rank = "S", Health = 12000, Damage = 500, Defense = 180, XPReward = 1200, Level = 100, Zone = "EliteZone", ShadowDropChance = 0.25, Drops = {{Item = "Cash", Amount = {2000, 3000}, Chance = 1.0}, {Item = "Diamonds", Amount = {200, 300}, Chance = 0.9}}, ModelColor = Color3.fromRGB(255, 150, 0), AttackRange = 20, DetectionRange = 90},
    
    {Name = "Vegeta", Rank = "SS", Health = 22000, Damage = 800, Defense = 280, XPReward = 2200, Level = 120, Zone = "EliteZone", ShadowDropChance = 0.30, Drops = {{Item = "Cash", Amount = {3500, 5500}, Chance = 1.0}, {Item = "Diamonds", Amount = {350, 550}, Chance = 0.95}}, ModelColor = Color3.fromRGB(100, 100, 200), AttackRange = 23, DetectionRange = 105},
    
    {Name = "Sung Jin-Woo", Rank = "GM", Health = 100000, Damage = 3000, Defense = 800, XPReward = 10000, Level = 200, Zone = "LegendaryZone", ShadowDropChance = 0.40, Drops = {{Item = "Cash", Amount = {15000, 25000}, Chance = 1.0}, {Item = "Diamonds", Amount = {1500, 2500}, Chance = 1.0}}, ModelColor = Color3.fromRGB(100, 0, 200), AttackRange = 35, DetectionRange = 200},
}

function NPCData:GetNPCByName(name)
    for _, npc in ipairs(self.NPCs) do
        if npc.Name == name then return npc end
    end
    return nil
end

function NPCData:GetNPCsByZone(zone)
    local npcs = {}
    for _, npc in ipairs(self.NPCs) do
        if npc.Zone == zone then table.insert(npcs, npc) end
    end
    return npcs
end

return NPCData
