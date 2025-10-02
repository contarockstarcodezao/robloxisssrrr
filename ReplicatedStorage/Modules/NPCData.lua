--[[
    NPCData.lua
    Define todos os NPCs do jogo com suas propriedades
]]

local NPCData = {}

NPCData.NPCs = {
    -- RANK F
    {
        Name = "Goblin Fraco",
        Rank = "F",
        Health = 100,
        Damage = 5,
        Defense = 2,
        XPReward = 10,
        Level = 1,
        Zone = "BeginnerZone",
        ShadowDropChance = 0.05, -- 5% de chance
        Drops = {
            {Item = "Cash", Amount = {10, 30}, Chance = 1.0},
            {Item = "Diamonds", Amount = {1, 3}, Chance = 0.3}
        },
        ModelColor = Color3.fromRGB(100, 150, 100),
        AttackRange = 5,
        DetectionRange = 20
    },
    {
        Name = "Slime",
        Rank = "F",
        Health = 80,
        Damage = 3,
        Defense = 1,
        XPReward = 8,
        Level = 1,
        Zone = "BeginnerZone",
        ShadowDropChance = 0.05,
        Drops = {
            {Item = "Cash", Amount = {8, 25}, Chance = 1.0},
            {Item = "Diamonds", Amount = {1, 2}, Chance = 0.25}
        },
        ModelColor = Color3.fromRGB(100, 200, 255),
        AttackRange = 4,
        DetectionRange = 15
    },
    
    -- RANK E
    {
        Name = "Goblin Guerreiro",
        Rank = "E",
        Health = 250,
        Damage = 12,
        Defense = 5,
        XPReward = 25,
        Level = 10,
        Zone = "BeginnerZone",
        ShadowDropChance = 0.08,
        Drops = {
            {Item = "Cash", Amount = {30, 70}, Chance = 1.0},
            {Item = "Diamonds", Amount = {3, 7}, Chance = 0.35}
        },
        ModelColor = Color3.fromRGB(80, 130, 80),
        AttackRange = 6,
        DetectionRange = 25
    },
    {
        Name = "Lobo Selvagem",
        Rank = "E",
        Health = 300,
        Damage = 15,
        Defense = 4,
        XPReward = 30,
        Level = 12,
        Zone = "BeginnerZone",
        ShadowDropChance = 0.08,
        Drops = {
            {Item = "Cash", Amount = {35, 80}, Chance = 1.0},
            {Item = "Diamonds", Amount = {3, 8}, Chance = 0.4}
        },
        ModelColor = Color3.fromRGB(120, 120, 120),
        AttackRange = 7,
        DetectionRange = 30
    },
    
    -- RANK D
    {
        Name = "Escorpião do Deserto",
        Rank = "D",
        Health = 600,
        Damage = 30,
        Defense = 10,
        XPReward = 60,
        Level = 20,
        Zone = "IntermediateZone",
        ShadowDropChance = 0.12,
        Drops = {
            {Item = "Cash", Amount = {80, 150}, Chance = 1.0},
            {Item = "Diamonds", Amount = {8, 15}, Chance = 0.45}
        },
        ModelColor = Color3.fromRGB(200, 180, 100),
        AttackRange = 8,
        DetectionRange = 35
    },
    {
        Name = "Bandido do Deserto",
        Rank = "D",
        Health = 700,
        Damage = 35,
        Defense = 12,
        XPReward = 70,
        Level = 25,
        Zone = "IntermediateZone",
        ShadowDropChance = 0.12,
        Drops = {
            {Item = "Cash", Amount = {100, 180}, Chance = 1.0},
            {Item = "Diamonds", Amount = {10, 18}, Chance = 0.5}
        },
        ModelColor = Color3.fromRGB(150, 120, 80),
        AttackRange = 9,
        DetectionRange = 40
    },
    
    -- RANK C
    {
        Name = "Guerreiro Orc",
        Rank = "C",
        Health = 1200,
        Damage = 60,
        Defense = 20,
        XPReward = 120,
        Level = 35,
        Zone = "IntermediateZone",
        ShadowDropChance = 0.15,
        Drops = {
            {Item = "Cash", Amount = {200, 350}, Chance = 1.0},
            {Item = "Diamonds", Amount = {20, 35}, Chance = 0.55}
        },
        ModelColor = Color3.fromRGB(100, 150, 100),
        AttackRange = 10,
        DetectionRange = 45
    },
    {
        Name = "Mago das Sombras",
        Rank = "C",
        Health = 1000,
        Damage = 80,
        Defense = 15,
        XPReward = 140,
        Level = 40,
        Zone = "IntermediateZone",
        ShadowDropChance = 0.15,
        Drops = {
            {Item = "Cash", Amount = {250, 400}, Chance = 1.0},
            {Item = "Diamonds", Amount = {25, 40}, Chance = 0.6}
        },
        ModelColor = Color3.fromRGB(80, 80, 150),
        AttackRange = 15,
        DetectionRange = 50
    },
    
    -- RANK B
    {
        Name = "Yeti Congelado",
        Rank = "B",
        Health = 2500,
        Damage = 120,
        Defense = 40,
        XPReward = 250,
        Level = 50,
        Zone = "AdvancedZone",
        ShadowDropChance = 0.18,
        Drops = {
            {Item = "Cash", Amount = {400, 700}, Chance = 1.0},
            {Item = "Diamonds", Amount = {40, 70}, Chance = 0.65}
        },
        ModelColor = Color3.fromRGB(200, 220, 255),
        AttackRange = 12,
        DetectionRange = 55
    },
    {
        Name = "Cavaleiro Gélido",
        Rank = "B",
        Health = 3000,
        Damage = 150,
        Defense = 50,
        XPReward = 300,
        Level = 60,
        Zone = "AdvancedZone",
        ShadowDropChance = 0.18,
        Drops = {
            {Item = "Cash", Amount = {500, 850}, Chance = 1.0},
            {Item = "Diamonds", Amount = {50, 85}, Chance = 0.7}
        },
        ModelColor = Color3.fromRGB(150, 200, 255),
        AttackRange = 13,
        DetectionRange = 60
    },
    
    -- RANK A
    {
        Name = "Dragão Menor",
        Rank = "A",
        Health = 5000,
        Damage = 250,
        Defense = 80,
        XPReward = 500,
        Level = 70,
        Zone = "AdvancedZone",
        ShadowDropChance = 0.22,
        Drops = {
            {Item = "Cash", Amount = {800, 1400}, Chance = 1.0},
            {Item = "Diamonds", Amount = {80, 140}, Chance = 0.75}
        },
        ModelColor = Color3.fromRGB(200, 100, 100),
        AttackRange = 15,
        DetectionRange = 70
    },
    {
        Name = "Golem Anciã",
        Rank = "A",
        Health = 6000,
        Damage = 200,
        Defense = 120,
        XPReward = 550,
        Level = 80,
        Zone = "AdvancedZone",
        ShadowDropChance = 0.22,
        Drops = {
            {Item = "Cash", Amount = {1000, 1600}, Chance = 1.0},
            {Item = "Diamonds", Amount = {100, 160}, Chance = 0.8}
        },
        ModelColor = Color3.fromRGB(150, 150, 150),
        AttackRange = 14,
        DetectionRange = 65
    },
    
    -- RANK S
    {
        Name = "Demônio de Fogo",
        Rank = "S",
        Health = 10000,
        Damage = 400,
        Defense = 150,
        XPReward = 1000,
        Level = 90,
        Zone = "EliteZone",
        ShadowDropChance = 0.25,
        Drops = {
            {Item = "Cash", Amount = {1500, 2500}, Chance = 1.0},
            {Item = "Diamonds", Amount = {150, 250}, Chance = 0.85}
        },
        ModelColor = Color3.fromRGB(255, 100, 0),
        AttackRange = 18,
        DetectionRange = 80
    },
    {
        Name = "Goku",
        Rank = "S",
        Health = 12000,
        Damage = 500,
        Defense = 180,
        XPReward = 1200,
        Level = 100,
        Zone = "EliteZone",
        ShadowDropChance = 0.25,
        Drops = {
            {Item = "Cash", Amount = {2000, 3000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {200, 300}, Chance = 0.9}
        },
        ModelColor = Color3.fromRGB(255, 150, 0),
        AttackRange = 20,
        DetectionRange = 90,
        Special = "Kamehameha"
    },
    
    -- RANK SS
    {
        Name = "Titã Sombrio",
        Rank = "SS",
        Health = 20000,
        Damage = 700,
        Defense = 250,
        XPReward = 2000,
        Level = 110,
        Zone = "EliteZone",
        ShadowDropChance = 0.30,
        Drops = {
            {Item = "Cash", Amount = {3000, 5000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {300, 500}, Chance = 0.95}
        },
        ModelColor = Color3.fromRGB(50, 50, 50),
        AttackRange = 22,
        DetectionRange = 100
    },
    {
        Name = "Vegeta",
        Rank = "SS",
        Health = 22000,
        Damage = 800,
        Defense = 280,
        XPReward = 2200,
        Level = 120,
        Zone = "EliteZone",
        ShadowDropChance = 0.30,
        Drops = {
            {Item = "Cash", Amount = {3500, 5500}, Chance = 1.0},
            {Item = "Diamonds", Amount = {350, 550}, Chance = 0.95}
        },
        ModelColor = Color3.fromRGB(100, 100, 200),
        AttackRange = 23,
        DetectionRange = 105,
        Special = "Final Flash"
    },
    
    -- RANK SSS
    {
        Name = "Rei Demônio",
        Rank = "SSS",
        Health = 40000,
        Damage = 1200,
        Defense = 400,
        XPReward = 4000,
        Level = 140,
        Zone = "LegendaryZone",
        ShadowDropChance = 0.35,
        Drops = {
            {Item = "Cash", Amount = {6000, 10000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {600, 1000}, Chance = 1.0}
        },
        ModelColor = Color3.fromRGB(150, 0, 150),
        AttackRange = 25,
        DetectionRange = 120
    },
    {
        Name = "Jiren",
        Rank = "SSS",
        Health = 45000,
        Damage = 1500,
        Defense = 450,
        XPReward = 4500,
        Level = 160,
        Zone = "LegendaryZone",
        ShadowDropChance = 0.35,
        Drops = {
            {Item = "Cash", Amount = {7000, 12000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {700, 1200}, Chance = 1.0}
        },
        ModelColor = Color3.fromRGB(200, 200, 200),
        AttackRange = 27,
        DetectionRange = 130,
        Special = "Glare"
    },
    
    -- RANK GM (Grand Master)
    {
        Name = "Lúcifer",
        Rank = "GM",
        Health = 80000,
        Damage = 2500,
        Defense = 700,
        XPReward = 8000,
        Level = 180,
        Zone = "LegendaryZone",
        ShadowDropChance = 0.40,
        Drops = {
            {Item = "Cash", Amount = {12000, 20000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {1200, 2000}, Chance = 1.0}
        },
        ModelColor = Color3.fromRGB(255, 0, 0),
        AttackRange = 30,
        DetectionRange = 150,
        Special = "Hellfire"
    },
    {
        Name = "Sung Jin-Woo",
        Rank = "GM",
        Health = 100000,
        Damage = 3000,
        Defense = 800,
        XPReward = 10000,
        Level = 200,
        Zone = "LegendaryZone",
        ShadowDropChance = 0.40,
        Drops = {
            {Item = "Cash", Amount = {15000, 25000}, Chance = 1.0},
            {Item = "Diamonds", Amount = {1500, 2500}, Chance = 1.0}
        },
        ModelColor = Color3.fromRGB(100, 0, 200),
        AttackRange = 35,
        DetectionRange = 200,
        Special = "Shadow Monarch"
    }
}

-- Funções auxiliares
function NPCData:GetNPCByName(name)
    for _, npc in ipairs(self.NPCs) do
        if npc.Name == name then
            return npc
        end
    end
    return nil
end

function NPCData:GetNPCsByRank(rank)
    local npcs = {}
    for _, npc in ipairs(self.NPCs) do
        if npc.Rank == rank then
            table.insert(npcs, npc)
        end
    end
    return npcs
end

function NPCData:GetNPCsByZone(zone)
    local npcs = {}
    for _, npc in ipairs(self.NPCs) do
        if npc.Zone == zone then
            table.insert(npcs, npc)
        end
    end
    return npcs
end

return NPCData
