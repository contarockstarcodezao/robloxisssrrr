--[[
    RankData.lua
    Define todos os ranks do jogo e suas propriedades
]]

local RankData = {}

RankData.Ranks = {
    {
        Name = "F",
        Level = 1,
        Color = Color3.fromRGB(139, 69, 19), -- Marrom
        RequiredXP = 0,
        Multiplier = 1.0,
        Order = 1
    },
    {
        Name = "E",
        Level = 10,
        Color = Color3.fromRGB(128, 128, 128), -- Cinza
        RequiredXP = 1000,
        Multiplier = 1.2,
        Order = 2
    },
    {
        Name = "D",
        Level = 20,
        Color = Color3.fromRGB(0, 128, 0), -- Verde
        RequiredXP = 3000,
        Multiplier = 1.5,
        Order = 3
    },
    {
        Name = "C",
        Level = 35,
        Color = Color3.fromRGB(0, 0, 255), -- Azul
        RequiredXP = 7000,
        Multiplier = 2.0,
        Order = 4
    },
    {
        Name = "B",
        Level = 50,
        Color = Color3.fromRGB(138, 43, 226), -- Roxo
        RequiredXP = 15000,
        Multiplier = 2.5,
        Order = 5
    },
    {
        Name = "A",
        Level = 70,
        Color = Color3.fromRGB(255, 165, 0), -- Laranja
        RequiredXP = 30000,
        Multiplier = 3.0,
        Order = 6
    },
    {
        Name = "S",
        Level = 90,
        Color = Color3.fromRGB(255, 215, 0), -- Dourado
        RequiredXP = 60000,
        Multiplier = 4.0,
        Order = 7
    },
    {
        Name = "SS",
        Level = 110,
        Color = Color3.fromRGB(255, 255, 0), -- Amarelo brilhante
        RequiredXP = 120000,
        Multiplier = 5.5,
        Order = 8
    },
    {
        Name = "SSS",
        Level = 140,
        Color = Color3.fromRGB(255, 0, 255), -- Magenta
        RequiredXP = 250000,
        Multiplier = 7.5,
        Order = 9
    },
    {
        Name = "GM",
        Level = 180,
        Color = Color3.fromRGB(255, 0, 0), -- Vermelho
        RequiredXP = 500000,
        Multiplier = 10.0,
        Order = 10
    }
}

-- Funções auxiliares
function RankData:GetRankByName(name)
    for _, rank in ipairs(self.Ranks) do
        if rank.Name == name then
            return rank
        end
    end
    return self.Ranks[1] -- Retorna F por padrão
end

function RankData:GetRankByLevel(level)
    local currentRank = self.Ranks[1]
    for _, rank in ipairs(self.Ranks) do
        if level >= rank.Level then
            currentRank = rank
        else
            break
        end
    end
    return currentRank
end

function RankData:GetNextRank(currentRankName)
    local currentOrder = self:GetRankByName(currentRankName).Order
    for _, rank in ipairs(self.Ranks) do
        if rank.Order == currentOrder + 1 then
            return rank
        end
    end
    return nil -- Já está no rank máximo
end

function RankData:GetRankOrder(rankName)
    return self:GetRankByName(rankName).Order
end

function RankData:CompareRanks(rank1, rank2)
    -- Retorna: 1 se rank1 > rank2, 0 se iguais, -1 se rank1 < rank2
    local order1 = self:GetRankOrder(rank1)
    local order2 = self:GetRankOrder(rank2)
    
    if order1 > order2 then
        return 1
    elseif order1 < order2 then
        return -1
    else
        return 0
    end
end

return RankData
