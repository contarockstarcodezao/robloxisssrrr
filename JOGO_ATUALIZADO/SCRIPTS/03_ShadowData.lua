--[[
    ShadowData.lua
    Cole em: ReplicatedStorage/Modules/ShadowData (ModuleScript)
]]

local ShadowData = {}

ShadowData.SameRankChances = {
    ["F"] = 0.70, ["E"] = 0.75, ["D"] = 0.80, ["C"] = 0.82, ["B"] = 0.85,
    ["A"] = 0.88, ["S"] = 0.90, ["SS"] = 0.93, ["SSS"] = 0.95, ["GM"] = 0.98
}

ShadowData.ShadowProperties = {
    ["F"] = {DamageMultiplier = 1.0, HealthMultiplier = 1.0, AttackSpeed = 1.0, Range = 15},
    ["E"] = {DamageMultiplier = 1.3, HealthMultiplier = 1.2, AttackSpeed = 1.1, Range = 18},
    ["D"] = {DamageMultiplier = 1.8, HealthMultiplier = 1.5, AttackSpeed = 1.2, Range = 20},
    ["C"] = {DamageMultiplier = 2.5, HealthMultiplier = 2.0, AttackSpeed = 1.3, Range = 23},
    ["B"] = {DamageMultiplier = 3.5, HealthMultiplier = 2.8, AttackSpeed = 1.4, Range = 25},
    ["A"] = {DamageMultiplier = 5.0, HealthMultiplier = 4.0, AttackSpeed = 1.6, Range = 28},
    ["S"] = {DamageMultiplier = 7.5, HealthMultiplier = 6.0, AttackSpeed = 1.8, Range = 32},
    ["SS"] = {DamageMultiplier = 11.0, HealthMultiplier = 9.0, AttackSpeed = 2.0, Range = 35},
    ["SSS"] = {DamageMultiplier = 16.0, HealthMultiplier = 13.0, AttackSpeed = 2.3, Range = 40},
    ["GM"] = {DamageMultiplier = 25.0, HealthMultiplier = 20.0, AttackSpeed = 2.5, Range = 50}
}

function ShadowData:DetermineShadowRank(npcRank)
    local RankData = require(game.ReplicatedStorage.Modules.RankData)
    local sameRankChance = self.SameRankChances[npcRank] or 0.70
    if math.random() <= sameRankChance then return npcRank
    else
        local npcOrder = RankData:GetRankByName(npcRank).Order
        if npcOrder > 1 then
            local lowerOrder = math.random(1, npcOrder - 1)
            for _, rank in ipairs(RankData.Ranks) do
                if rank.Order == lowerOrder then return rank.Name end
            end
        end
        return npcRank
    end
end

function ShadowData:CreateShadow(npcName, npcData)
    local shadowRank = self:DetermineShadowRank(npcData.Rank)
    local properties = self.ShadowProperties[shadowRank]
    return {
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
end

function ShadowData:GetShadowStats(shadow)
    local levelMultiplier = 1 + (shadow.Level - 1) * 0.05
    return {
        Damage = math.floor(shadow.Damage * levelMultiplier),
        Health = math.floor(shadow.Health * levelMultiplier),
        AttackSpeed = shadow.AttackSpeed,
        Range = shadow.Range
    }
end

function ShadowData:CalculateCaptureSuccess(attemptNumber)
    local chances = {0.40, 0.30, 0.20}
    return math.random() <= (chances[attemptNumber] or 0.20)
end

function ShadowData:CalculateDestroyDiamonds(npcRank)
    local RankData = require(game.ReplicatedStorage.Modules.RankData)
    local rankOrder = RankData:GetRankByName(npcRank).Order
    return math.max(5, rankOrder * 10 + math.random(-5, 15))
end

return ShadowData
