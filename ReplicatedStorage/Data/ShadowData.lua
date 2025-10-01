--[[
    SHADOW DATA MODULE
    Localização: ReplicatedStorage/Data/ShadowData.lua
    
    Este módulo contém todos os dados das sombras, incluindo:
    - Ranks e atributos
    - Habilidades passivas e ativas
    - Configurações de evolução
]]

local ShadowData = {}

-- Ranks das sombras
ShadowData.RANKS = {
    F = {multiplier = 1.0, color = Color3.fromRGB(128, 128, 128)},
    E = {multiplier = 1.2, color = Color3.fromRGB(255, 255, 255)},
    D = {multiplier = 1.5, color = Color3.fromRGB(0, 255, 0)},
    C = {multiplier = 1.8, color = Color3.fromRGB(0, 0, 255)},
    B = {multiplier = 2.2, color = Color3.fromRGB(128, 0, 255)},
    A = {multiplier = 2.7, color = Color3.fromRGB(255, 165, 0)},
    S = {multiplier = 3.3, color = Color3.fromRGB(255, 0, 0)},
    SS = {multiplier = 4.0, color = Color3.fromRGB(255, 215, 0)},
    GM = {multiplier = 5.0, color = Color3.fromRGB(255, 0, 255)}
}

-- Dados das sombras disponíveis
ShadowData.SHADOWS = {
    ["Shadow Wolf"] = {
        rank = "F",
        baseHealth = 100,
        baseDamage = 25,
        baseSpeed = 16,
        rarity = 0.8,
        abilities = {
            passive = "Regeneration",
            active = "Bite"
        },
        evolutionCost = {
            cash = 1000,
            diamonds = 0,
            fragments = 50
        }
    },
    
    ["Shadow Bear"] = {
        rank = "E",
        baseHealth = 200,
        baseDamage = 45,
        baseSpeed = 12,
        rarity = 0.6,
        abilities = {
            passive = "Thick Skin",
            active = "Roar"
        },
        evolutionCost = {
            cash = 2500,
            diamonds = 0,
            fragments = 100
        }
    },
    
    ["Shadow Tiger"] = {
        rank = "D",
        baseHealth = 300,
        baseDamage = 70,
        baseSpeed = 20,
        rarity = 0.4,
        abilities = {
            passive = "Speed Boost",
            active = "Claw Slash"
        },
        evolutionCost = {
            cash = 5000,
            diamonds = 10,
            fragments = 200
        }
    },
    
    ["Shadow Dragon"] = {
        rank = "A",
        baseHealth = 800,
        baseDamage = 150,
        baseSpeed = 18,
        rarity = 0.1,
        abilities = {
            passive = "Fire Aura",
            active = "Dragon Breath"
        },
        evolutionCost = {
            cash = 25000,
            diamonds = 100,
            fragments = 1000
        }
    },
    
    ["Shadow Phoenix"] = {
        rank = "S",
        baseHealth = 1200,
        baseDamage = 200,
        baseSpeed = 25,
        rarity = 0.05,
        abilities = {
            passive = "Rebirth",
            active = "Phoenix Flames"
        },
        evolutionCost = {
            cash = 50000,
            diamonds = 250,
            fragments = 2500
        }
    }
}

-- Habilidades das sombras
ShadowData.ABILITIES = {
    -- Habilidades Passivas
    ["Regeneration"] = {
        type = "passive",
        description = "Regenera 5 HP por segundo",
        effect = function(shadow)
            -- Implementar regeneração
        end
    },
    
    ["Thick Skin"] = {
        type = "passive",
        description = "Reduz dano recebido em 20%",
        effect = function(shadow)
            -- Implementar redução de dano
        end
    },
    
    ["Speed Boost"] = {
        type = "passive",
        description = "Aumenta velocidade em 30%",
        effect = function(shadow)
            -- Implementar aumento de velocidade
        end
    },
    
    ["Fire Aura"] = {
        type = "passive",
        description = "Queima inimigos próximos",
        effect = function(shadow)
            -- Implementar aura de fogo
        end
    },
    
    ["Rebirth"] = {
        type = "passive",
        description = "Revive com 50% HP quando morre",
        effect = function(shadow)
            -- Implementar revivificação
        end
    },
    
    -- Habilidades Ativas
    ["Bite"] = {
        type = "active",
        description = "Ataque básico com 1.2x dano",
        cooldown = 2,
        effect = function(shadow, target)
            -- Implementar mordida
        end
    },
    
    ["Roar"] = {
        type = "active",
        description = "Atordoa inimigos próximos",
        cooldown = 8,
        effect = function(shadow, area)
            -- Implementar rugido
        end
    },
    
    ["Claw Slash"] = {
        type = "active",
        description = "Ataque em área com 1.5x dano",
        cooldown = 5,
        effect = function(shadow, area)
            -- Implementar golpe de garra
        end
    },
    
    ["Dragon Breath"] = {
        type = "active",
        description = "Ataque de fogo em linha",
        cooldown = 10,
        effect = function(shadow, direction)
            -- Implementar sopro de dragão
        end
    },
    
    ["Phoenix Flames"] = {
        type = "active",
        description = "Explosão de fogo em área grande",
        cooldown = 15,
        effect = function(shadow, area)
            -- Implementar chamas da fênix
        end
    }
}

-- Configurações de evolução
ShadowData.EVOLUTION = {
    maxLevel = 100,
    expPerLevel = 1000,
    statIncreasePerLevel = 0.1, -- 10% por nível
    evolutionRequirements = {
        ["F"] = {level = 20, rank = "E"},
        ["E"] = {level = 30, rank = "D"},
        ["D"] = {level = 40, rank = "C"},
        ["C"] = {level = 50, rank = "B"},
        ["B"] = {level = 60, rank = "A"},
        ["A"] = {level = 70, rank = "S"},
        ["S"] = {level = 80, rank = "SS"},
        ["SS"] = {level = 90, rank = "GM"}
    }
}

return ShadowData