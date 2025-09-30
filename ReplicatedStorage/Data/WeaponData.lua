--[[
    WEAPON DATA MODULE
    Localização: ReplicatedStorage/Data/WeaponData.lua
    
    Este módulo contém todos os dados das armas, incluindo:
    - Tipos de armas (espada, soco)
    - Raridades e atributos
    - Efeitos especiais
]]

local WeaponData = {}

-- Tipos de armas
WeaponData.TYPES = {
    SWORD = "Sword",
    FIST = "Fist"
}

-- Raridades das armas
WeaponData.RARITIES = {
    COMMON = {name = "Common", color = Color3.fromRGB(128, 128, 128), multiplier = 1.0},
    RARE = {name = "Rare", color = Color3.fromRGB(0, 255, 0), multiplier = 1.5},
    EPIC = {name = "Epic", color = Color3.fromRGB(128, 0, 255), multiplier = 2.0},
    LEGENDARY = {name = "Legendary", color = Color3.fromRGB(255, 215, 0), multiplier = 3.0}
}

-- Dados das armas disponíveis
WeaponData.WEAPONS = {
    -- Espadas
    ["Iron Sword"] = {
        type = WeaponData.TYPES.SWORD,
        rarity = "COMMON",
        baseDamage = 50,
        attackSpeed = 1.0,
        range = 8,
        specialEffects = {},
        description = "Uma espada básica de ferro"
    },
    
    ["Steel Sword"] = {
        type = WeaponData.TYPES.SWORD,
        rarity = "RARE",
        baseDamage = 80,
        attackSpeed = 1.2,
        range = 10,
        specialEffects = {"Sharp Edge"},
        description = "Uma espada afiada de aço"
    },
    
    ["Dragon Blade"] = {
        type = WeaponData.TYPES.SWORD,
        rarity = "EPIC",
        baseDamage = 150,
        attackSpeed = 1.5,
        range = 12,
        specialEffects = {"Fire Damage", "Critical Hit"},
        description = "Uma lâmina forjada com escamas de dragão"
    },
    
    ["Excalibur"] = {
        type = WeaponData.TYPES.SWORD,
        rarity = "LEGENDARY",
        baseDamage = 300,
        attackSpeed = 2.0,
        range = 15,
        specialEffects = {"Holy Light", "Area Damage", "Life Steal"},
        description = "A lendária espada do rei"
    },
    
    -- Socos
    ["Iron Fist"] = {
        type = WeaponData.TYPES.FIST,
        rarity = "COMMON",
        baseDamage = 40,
        attackSpeed = 1.5,
        range = 6,
        specialEffects = {},
        description = "Luvas básicas de ferro"
    },
    
    ["Steel Gauntlets"] = {
        type = WeaponData.TYPES.FIST,
        rarity = "RARE",
        baseDamage = 70,
        attackSpeed = 1.8,
        range = 7,
        specialEffects = {"Knockback"},
        description = "Manoplas reforçadas de aço"
    },
    
    ["Thunder Fists"] = {
        type = WeaponData.TYPES.FIST,
        rarity = "EPIC",
        baseDamage = 120,
        attackSpeed = 2.2,
        range = 8,
        specialEffects = {"Lightning Damage", "Chain Lightning"},
        description = "Manoplas carregadas com energia elétrica"
    },
    
    ["God's Fist"] = {
        type = WeaponData.TYPES.FIST,
        rarity = "LEGENDARY",
        baseDamage = 250,
        attackSpeed = 2.5,
        range = 10,
        specialEffects = {"Divine Strike", "Shockwave", "Stun"},
        description = "As manoplas divinas do poder supremo"
    }
}

-- Efeitos especiais das armas
WeaponData.SPECIAL_EFFECTS = {
    ["Sharp Edge"] = {
        description = "Aumenta chance de crítico em 15%",
        effect = function(weapon, target)
            -- Implementar aumento de crítico
        end
    },
    
    ["Fire Damage"] = {
        description = "Adiciona dano de fogo",
        effect = function(weapon, target)
            -- Implementar dano de fogo
        end
    },
    
    ["Critical Hit"] = {
        description = "Chance de crítico em 25%",
        effect = function(weapon, target)
            -- Implementar crítico
        end
    },
    
    ["Holy Light"] = {
        description = "Dano extra contra criaturas das trevas",
        effect = function(weapon, target)
            -- Implementar dano sagrado
        end
    },
    
    ["Area Damage"] = {
        description = "Dano em área ao redor do alvo",
        effect = function(weapon, target)
            -- Implementar dano em área
        end
    },
    
    ["Life Steal"] = {
        description = "Rouba 20% do dano como vida",
        effect = function(weapon, target)
            -- Implementar roubo de vida
        end
    },
    
    ["Knockback"] = {
        description = "Empurra o inimigo para trás",
        effect = function(weapon, target)
            -- Implementar empurrão
        end
    },
    
    ["Lightning Damage"] = {
        description = "Adiciona dano elétrico",
        effect = function(weapon, target)
            -- Implementar dano elétrico
        end
    },
    
    ["Chain Lightning"] = {
        description = "Raios saltam para inimigos próximos",
        effect = function(weapon, target)
            -- Implementar corrente elétrica
        end
    },
    
    ["Divine Strike"] = {
        description = "Ataque divino com dano massivo",
        effect = function(weapon, target)
            -- Implementar golpe divino
        end
    },
    
    ["Shockwave"] = {
        description = "Onda de choque em área",
        effect = function(weapon, target)
            -- Implementar onda de choque
        end
    },
    
    ["Stun"] = {
        description = "Atordoa o inimigo por 2 segundos",
        effect = function(weapon, target)
            -- Implementar atordoamento
        end
    }
}

-- Configurações de forja
WeaponData.FORGING = {
    maxLevel = 50,
    upgradeCost = {
        cash = 1000,
        diamonds = 5,
        fragments = 25
    },
    fusionCost = {
        cash = 5000,
        diamonds = 25,
        fragments = 100
    },
    statIncreasePerLevel = 0.05 -- 5% por nível
}

return WeaponData