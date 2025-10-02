--[[
    RankData.lua
    Cole em: ReplicatedStorage/Modules/RankData (ModuleScript)
]]

local RankData = {}

RankData.Ranks = {
    {Name = "F", Level = 1, Color = Color3.fromRGB(139, 69, 19), RequiredXP = 0, Multiplier = 1.0, Order = 1},
    {Name = "E", Level = 10, Color = Color3.fromRGB(128, 128, 128), RequiredXP = 1000, Multiplier = 1.2, Order = 2},
    {Name = "D", Level = 20, Color = Color3.fromRGB(0, 128, 0), RequiredXP = 3000, Multiplier = 1.5, Order = 3},
    {Name = "C", Level = 35, Color = Color3.fromRGB(0, 0, 255), RequiredXP = 7000, Multiplier = 2.0, Order = 4},
    {Name = "B", Level = 50, Color = Color3.fromRGB(138, 43, 226), RequiredXP = 15000, Multiplier = 2.5, Order = 5},
    {Name = "A", Level = 70, Color = Color3.fromRGB(255, 165, 0), RequiredXP = 30000, Multiplier = 3.0, Order = 6},
    {Name = "S", Level = 90, Color = Color3.fromRGB(255, 215, 0), RequiredXP = 60000, Multiplier = 4.0, Order = 7},
    {Name = "SS", Level = 110, Color = Color3.fromRGB(255, 255, 0), RequiredXP = 120000, Multiplier = 5.5, Order = 8},
    {Name = "SSS", Level = 140, Color = Color3.fromRGB(255, 0, 255), RequiredXP = 250000, Multiplier = 7.5, Order = 9},
    {Name = "GM", Level = 180, Color = Color3.fromRGB(255, 0, 0), RequiredXP = 500000, Multiplier = 10.0, Order = 10}
}

function RankData:GetRankByName(name)
    for _, rank in ipairs(self.Ranks) do
        if rank.Name == name then return rank end
    end
    return self.Ranks[1]
end

function RankData:GetRankByLevel(level)
    local currentRank = self.Ranks[1]
    for _, rank in ipairs(self.Ranks) do
        if level >= rank.Level then currentRank = rank else break end
    end
    return currentRank
end

function RankData:GetNextRank(currentRankName)
    local currentOrder = self:GetRankByName(currentRankName).Order
    for _, rank in ipairs(self.Ranks) do
        if rank.Order == currentOrder + 1 then return rank end
    end
    return nil
end

function RankData:GetRankOrder(rankName)
    return self:GetRankByName(rankName).Order
end

return RankData
