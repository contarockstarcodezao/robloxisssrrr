--[[
    ShadowData.lua
    Gerencia os dados e propriedades das sombras
]]

local ShadowData = {}

-- Sistema de balanceamento de captura de sombras
-- Quanto maior o rank, maior a chance de dropar a mesma raridade
ShadowData.SameRankChances = {
    ["F"] = 0.70,   -- 70% de chance de dropar rank F quando mata NPC rank F
    ["E"] = 0.75,   -- 75% de chance
    ["D"] = 0.80,   -- 80% de chance
    ["C"] = 0.82,   -- 82% de chance
    ["B"] = 0.85,   -- 85% de chance
    ["A"] = 0.88,   -- 88% de chance
    ["S"] = 0.90,   -- 90% de chance
    ["SS"] = 0.93,  -- 93% de chance
    ["SSS"] = 0.95, -- 95% de chance
    ["GM"] = 0.98   -- 98% de chance
}

-- Propriedades base das sombras por rank
ShadowData.ShadowProperties = {
    ["F"] = {
        DamageMultiplier = 1.0,
        HealthMultiplier = 1.0,
        AttackSpeed = 1.0,
        Range = 15
    },
    ["E"] = {
        DamageMultiplier = 1.3,
        HealthMultiplier = 1.2,
        AttackSpeed = 1.1,
        Range = 18
    },
    ["D"] = {
        DamageMultiplier = 1.8,
        HealthMultiplier = 1.5,
        AttackSpeed = 1.2,
        Range = 20
    },
    ["C"] = {
        DamageMultiplier = 2.5,
        HealthMultiplier = 2.0,
        AttackSpeed = 1.3,
        Range = 23
    },
    ["B"] = {
        DamageMultiplier = 3.5,
        HealthMultiplier = 2.8,
        AttackSpeed = 1.4,
        Range = 25
    },
    ["A"] = {
        DamageMultiplier = 5.0,
        HealthMultiplier = 4.0,
        AttackSpeed = 1.6,
        Range = 28
    },
    ["S"] = {
        DamageMultiplier = 7.5,
        HealthMultiplier = 6.0,
        AttackSpeed = 1.8,
        Range = 32
    },
    ["SS"] = {
        DamageMultiplier = 11.0,
        HealthMultiplier = 9.0,
        AttackSpeed = 2.0,
        Range = 35
    },
    ["SSS"] = {
        DamageMultiplier = 16.0,
        HealthMultiplier = 13.0,
        AttackSpeed = 2.3,
        Range = 40
    },
    ["GM"] = {
        DamageMultiplier = 25.0,
        HealthMultiplier = 20.0,
        AttackSpeed = 2.5,
        Range = 50
    }
}

-- Determina o rank da sombra baseado no rank do NPC
function ShadowData:DetermineShadowRank(npcRank)
    local RankData = require(game.ReplicatedStorage.Modules.RankData)
    local sameRankChance = self.SameRankChances[npcRank] or 0.70
    
    local roll = math.random()
    
    if roll <= sameRankChance then
        -- Dropa o mesmo rank
        return npcRank
    else
        -- Dropa um rank menor
        local npcOrder = RankData:GetRankByName(npcRank).Order
        if npcOrder > 1 then
            -- Pode dropar qualquer rank menor
            local lowerOrder = math.random(1, npcOrder - 1)
            for _, rank in ipairs(RankData.Ranks) do
                if rank.Order == lowerOrder then
                    return rank.Name
                end
            end
        end
        return npcRank -- Fallback
    end
end

-- Cria dados de uma sombra capturada
function ShadowData:CreateShadow(npcName, npcData)
    local shadowRank = self:DetermineShadowRank(npcData.Rank)
    local properties = self.ShadowProperties[shadowRank]
    
    local shadow = {
        ID = game:GetService("HttpService"):GenerateGUID(false),
        Name = npcName,
        OriginalRank = npcData.Rank,
        Rank = shadowRank,
        Damage = math.floor(npcData.Damage * properties.DamageMultiplier),
        Health = math.floor(npcData.Health * properties.HealthMultiplier),
        AttackSpeed = properties.AttackSpeed,
        Range = properties.Range,
        ModelColor = npcData.ModelColor,
        CapturedTime = os.time(),
        Level = 1,
        Experience = 0
    }
    
    return shadow
end

-- Calcula stats da sombra baseado no nível
function ShadowData:GetShadowStats(shadow)
    local levelMultiplier = 1 + (shadow.Level - 1) * 0.05 -- 5% por nível
    
    return {
        Damage = math.floor(shadow.Damage * levelMultiplier),
        Health = math.floor(shadow.Health * levelMultiplier),
        AttackSpeed = shadow.AttackSpeed,
        Range = shadow.Range
    }
end

-- Sistema de captura - 3 tentativas
function ShadowData:CalculateCaptureSuccess(attemptNumber)
    -- Primeira tentativa: 40%
    -- Segunda tentativa: 30%
    -- Terceira tentativa: 20%
    local chances = {0.40, 0.30, 0.20}
    local chance = chances[attemptNumber] or 0.20
    
    return math.random() <= chance
end

-- Calcula diamantes ao destruir
function ShadowData:CalculateDestroyDiamonds(npcRank)
    local RankData = require(game.ReplicatedStorage.Modules.RankData)
    local rankOrder = RankData:GetRankByName(npcRank).Order
    
    -- Quanto maior o rank, mais diamantes
    local baseDiamonds = rankOrder * 10
    local variance = math.random(-5, 15)
    
    return math.max(5, baseDiamonds + variance)
end

return ShadowData
