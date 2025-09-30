--[[
    RELIC DATA MODULE
    Localização: ReplicatedStorage/Data/RelicData.lua
    
    Este módulo contém todos os dados das relíquias, incluindo:
    - Tipos de relíquias
    - Raridades e efeitos
    - Sistema de fusão
]]

local RelicData = {}

-- Tipos de relíquias
RelicData.TYPES = {
    DAMAGE = "Damage",
    SPEED = "Speed",
    HEALTH = "Health",
    CRITICAL = "Critical",
    CAPTURE = "Capture",
    EXPERIENCE = "Experience"
}

-- Raridades das relíquias
RelicData.RARITIES = {
    COMMON = {name = "Common", color = Color3.fromRGB(128, 128, 128), multiplier = 1.0},
    RARE = {name = "Rare", color = Color3.fromRGB(0, 255, 0), multiplier = 1.5},
    EPIC = {name = "Epic", color = Color3.fromRGB(128, 0, 255), multiplier = 2.0},
    LEGENDARY = {name = "Legendary", color = Color3.fromRGB(255, 215, 0), multiplier = 3.0}
}

-- Dados das relíquias disponíveis
RelicData.RELICS = {
    -- Relíquias de Dano
    ["Power Stone"] = {
        type = RelicData.TYPES.DAMAGE,
        rarity = "COMMON",
        effect = "damage_boost",
        value = 10, -- +10% dano
        description = "Aumenta o dano em 10%",
        icon = "rbxassetid://123456789"
    },
    
    ["Warrior's Gem"] = {
        type = RelicData.TYPES.DAMAGE,
        rarity = "RARE",
        effect = "damage_boost",
        value = 25, -- +25% dano
        description = "Aumenta o dano em 25%",
        icon = "rbxassetid://123456790"
    },
    
    ["Dragon's Heart"] = {
        type = RelicData.TYPES.DAMAGE,
        rarity = "EPIC",
        effect = "damage_boost",
        value = 50, -- +50% dano
        description = "Aumenta o dano em 50%",
        icon = "rbxassetid://123456791"
    },
    
    ["God's Wrath"] = {
        type = RelicData.TYPES.DAMAGE,
        rarity = "LEGENDARY",
        effect = "damage_boost",
        value = 100, -- +100% dano
        description = "Aumenta o dano em 100%",
        icon = "rbxassetid://123456792"
    },
    
    -- Relíquias de Velocidade
    ["Wind Crystal"] = {
        type = RelicData.TYPES.SPEED,
        rarity = "COMMON",
        effect = "speed_boost",
        value = 15, -- +15% velocidade
        description = "Aumenta a velocidade em 15%",
        icon = "rbxassetid://123456793"
    },
    
    ["Lightning Core"] = {
        type = RelicData.TYPES.SPEED,
        rarity = "RARE",
        effect = "speed_boost",
        value = 30, -- +30% velocidade
        description = "Aumenta a velocidade em 30%",
        icon = "rbxassetid://123456794"
    },
    
    ["Storm Essence"] = {
        type = RelicData.TYPES.SPEED,
        rarity = "EPIC",
        effect = "speed_boost",
        value = 60, -- +60% velocidade
        description = "Aumenta a velocidade em 60%",
        icon = "rbxassetid://123456795"
    },
    
    ["Time Shard"] = {
        type = RelicData.TYPES.SPEED,
        rarity = "LEGENDARY",
        effect = "speed_boost",
        value = 100, -- +100% velocidade
        description = "Aumenta a velocidade em 100%",
        icon = "rbxassetid://123456796"
    },
    
    -- Relíquias de Vida
    ["Health Orb"] = {
        type = RelicData.TYPES.HEALTH,
        rarity = "COMMON",
        effect = "health_boost",
        value = 20, -- +20% vida
        description = "Aumenta a vida em 20%",
        icon = "rbxassetid://123456797"
    },
    
    ["Vitality Stone"] = {
        type = RelicData.TYPES.HEALTH,
        rarity = "RARE",
        effect = "health_boost",
        value = 40, -- +40% vida
        description = "Aumenta a vida em 40%",
        icon = "rbxassetid://123456798"
    },
    
    ["Life Crystal"] = {
        type = RelicData.TYPES.HEALTH,
        rarity = "EPIC",
        effect = "health_boost",
        value = 80, -- +80% vida
        description = "Aumenta a vida em 80%",
        icon = "rbxassetid://123456799"
    },
    
    ["Immortality Core"] = {
        type = RelicData.TYPES.HEALTH,
        rarity = "LEGENDARY",
        effect = "health_boost",
        value = 150, -- +150% vida
        description = "Aumenta a vida em 150%",
        icon = "rbxassetid://123456800"
    },
    
    -- Relíquias de Crítico
    ["Lucky Charm"] = {
        type = RelicData.TYPES.CRITICAL,
        rarity = "COMMON",
        effect = "critical_boost",
        value = 10, -- +10% crítico
        description = "Aumenta a chance de crítico em 10%",
        icon = "rbxassetid://123456801"
    },
    
    ["Fortune Gem"] = {
        type = RelicData.TYPES.CRITICAL,
        rarity = "RARE",
        effect = "critical_boost",
        value = 20, -- +20% crítico
        description = "Aumenta a chance de crítico em 20%",
        icon = "rbxassetid://123456802"
    },
    
    ["Destiny Stone"] = {
        type = RelicData.TYPES.CRITICAL,
        rarity = "EPIC",
        effect = "critical_boost",
        value = 35, -- +35% crítico
        description = "Aumenta a chance de crítico em 35%",
        icon = "rbxassetid://123456803"
    },
    
    ["Fate's Edge"] = {
        type = RelicData.TYPES.CRITICAL,
        rarity = "LEGENDARY",
        effect = "critical_boost",
        value = 50, -- +50% crítico
        description = "Aumenta a chance de crítico em 50%",
        icon = "rbxassetid://123456804"
    },
    
    -- Relíquias de Captura
    ["Shadow Magnet"] = {
        type = RelicData.TYPES.CAPTURE,
        rarity = "COMMON",
        effect = "capture_boost",
        value = 15, -- +15% captura
        description = "Aumenta a chance de captura em 15%",
        icon = "rbxassetid://123456805"
    },
    
    ["Soul Trap"] = {
        type = RelicData.TYPES.CAPTURE,
        rarity = "RARE",
        effect = "capture_boost",
        value = 30, -- +30% captura
        description = "Aumenta a chance de captura em 30%",
        icon = "rbxassetid://123456806"
    },
    
    ["Void Seal"] = {
        type = RelicData.TYPES.CAPTURE,
        rarity = "EPIC",
        effect = "capture_boost",
        value = 50, -- +50% captura
        description = "Aumenta a chance de captura em 50%",
        icon = "rbxassetid://123456807"
    },
    
    ["Soul Reaper"] = {
        type = RelicData.TYPES.CAPTURE,
        rarity = "LEGENDARY",
        effect = "capture_boost",
        value = 75, -- +75% captura
        description = "Aumenta a chance de captura em 75%",
        icon = "rbxassetid://123456808"
    },
    
    -- Relíquias de Experiência
    ["Wisdom Stone"] = {
        type = RelicData.TYPES.EXPERIENCE,
        rarity = "COMMON",
        effect = "experience_boost",
        value = 25, -- +25% XP
        description = "Aumenta o XP ganho em 25%",
        icon = "rbxassetid://123456809"
    },
    
    ["Knowledge Crystal"] = {
        type = RelicData.TYPES.EXPERIENCE,
        rarity = "RARE",
        effect = "experience_boost",
        value = 50, -- +50% XP
        description = "Aumenta o XP ganho em 50%",
        icon = "rbxassetid://123456810"
    },
    
    ["Mentor's Gift"] = {
        type = RelicData.TYPES.EXPERIENCE,
        rarity = "EPIC",
        effect = "experience_boost",
        value = 100, -- +100% XP
        description = "Aumenta o XP ganho em 100%",
        icon = "rbxassetid://123456811"
    },
    
    ["Divine Wisdom"] = {
        type = RelicData.TYPES.EXPERIENCE,
        rarity = "LEGENDARY",
        effect = "experience_boost",
        value = 200, -- +200% XP
        description = "Aumenta o XP ganho em 200%",
        icon = "rbxassetid://123456812"
    }
}

-- Configurações de fusão
RelicData.FUSION = {
    maxLevel = 10,
    fusionCost = {
        cash = 2000,
        diamonds = 10,
        fragments = 50
    },
    statIncreasePerLevel = 0.1, -- 10% por nível
    fusionRequirements = {
        ["COMMON"] = {count = 3, result = "RARE"},
        ["RARE"] = {count = 3, result = "EPIC"},
        ["EPIC"] = {count = 3, result = "LEGENDARY"}
    }
}

return RelicData