--[[
    RankSystem.lua
    Gerencia o sistema de ranks dos jogadores
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RankData = require(ReplicatedStorage.Modules.RankData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local RankSystem = {}

-- Referência ao DataManager (será injetada)
RankSystem.DataManager = nil

-- Verifica se jogador pode acessar uma zona
function RankSystem:CanAccessZone(player, requiredRank)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return false end
    
    local playerRankOrder = RankData:GetRankOrder(data.Rank)
    local requiredRankOrder = RankData:GetRankOrder(requiredRank)
    
    return playerRankOrder >= requiredRankOrder
end

-- Obtém informações do rank do jogador
function RankSystem:GetPlayerRankInfo(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return nil end
    
    local rankInfo = RankData:GetRankByName(data.Rank)
    local nextRank = RankData:GetNextRank(data.Rank)
    
    return {
        Current = rankInfo,
        Next = nextRank,
        Level = data.Level,
        XP = data.XP,
        RequiredXP = self.DataManager:GetRequiredXP(data.Level)
    }
end

-- Concede rank ao jogador (usado em missões especiais)
function RankSystem:GrantRank(player, rankName)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return false end
    
    local newRank = RankData:GetRankByName(rankName)
    if not newRank then return false end
    
    -- Verifica se é um upgrade
    if RankData:CompareRanks(rankName, data.Rank) > 0 then
        data.Rank = rankName
        data.Level = math.max(data.Level, newRank.Level)
        
        RemoteEvents.ShowNotification:FireClient(
            player,
            "🎉 RANK UP! 🎉",
            "Você alcançou o Rank " .. rankName .. "!",
            newRank.Color
        )
        
        self.DataManager:UpdateClient(player)
        return true
    end
    
    return false
end

-- Obtém multiplicador de recompensas baseado no rank
function RankSystem:GetRewardMultiplier(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return 1.0 end
    
    local rankInfo = RankData:GetRankByName(data.Rank)
    return rankInfo.Multiplier
end

-- Calcula bônus de dano baseado no rank
function RankSystem:GetDamageBonus(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return 0 end
    
    local rankInfo = RankData:GetRankByName(data.Rank)
    -- +10% de dano por ordem de rank
    return (rankInfo.Order - 1) * 0.10
end

-- Obtém todos os jogadores e seus ranks (para scoreboard)
function RankSystem:GetAllPlayerRanks()
    local players = game:GetService("Players"):GetPlayers()
    local rankList = {}
    
    for _, player in ipairs(players) do
        local data = self.DataManager:GetPlayerData(player)
        if data then
            table.insert(rankList, {
                Name = player.Name,
                Rank = data.Rank,
                Level = data.Level,
                Diamonds = data.Diamonds,
                RankOrder = RankData:GetRankOrder(data.Rank)
            })
        end
    end
    
    -- Ordena por rank e level
    table.sort(rankList, function(a, b)
        if a.RankOrder == b.RankOrder then
            return a.Level > b.Level
        end
        return a.RankOrder > b.RankOrder
    end)
    
    return rankList
end

-- Inicialização
function RankSystem:Init(dataManager)
    self.DataManager = dataManager
    
    -- Setup Remote Function
    RemoteEvents.GetScoreboardData.OnServerInvoke = function()
        return self:GetAllPlayerRanks()
    end
    
    print("[RankSystem] Inicializado com sucesso!")
end

return RankSystem
