--[[
    RANKING MANAGER
    Localização: ServerScriptService/Ranking/RankingManager.lua
    
    Este script gerencia o sistema de ranking:
    - Cálculo de poder total
    - Leaderboards globais e semanais
    - Atualização de rankings
    - Estatísticas dos jogadores
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar eventos
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local RankingManager = {}

-- Tipos de ranking
local RANKING_TYPES = {
    LEVEL = "Level",
    POWER = "Power",
    CASH = "Cash",
    DIAMONDS = "Diamonds",
    DUNGEONS = "Dungeons",
    RAIDS = "Raids"
}

-- Dados dos rankings
local rankingData = {
    global = {},
    weekly = {},
    lastWeeklyReset = tick()
}

-- Dados dos jogadores
local playerStats = {}

-- Inicializar dados do jogador
function RankingManager.InitializePlayer(player)
    if not playerStats[player] then
        playerStats[player] = {
            level = 1,
            power = 0,
            cash = 0,
            diamonds = 0,
            dungeonsCompleted = 0,
            raidsCompleted = 0,
            totalXP = 0,
            shadowsCaptured = 0,
            enemiesKilled = 0,
            lastUpdate = tick()
        }
    end
end

-- Atualizar ranking do jogador
function RankingManager.UpdatePlayerRanking(player, stats)
    RankingManager.InitializePlayer(player)
    
    local data = playerStats[player]
    
    -- Atualizar estatísticas
    if stats.level then
        data.level = stats.level
    end
    if stats.power then
        data.power = stats.power
    end
    if stats.cash then
        data.cash = stats.cash
    end
    if stats.diamonds then
        data.diamonds = stats.diamonds
    end
    if stats.dungeonsCompleted then
        data.dungeonsCompleted = data.dungeonsCompleted + stats.dungeonsCompleted
    end
    if stats.raidsCompleted then
        data.raidsCompleted = data.raidsCompleted + stats.raidsCompleted
    end
    if stats.totalXP then
        data.totalXP = stats.totalXP
    end
    if stats.shadowsCaptured then
        data.shadowsCaptured = data.shadowsCaptured + stats.shadowsCaptured
    end
    if stats.enemiesKilled then
        data.enemiesKilled = data.enemiesKilled + stats.enemiesKilled
    end
    
    data.lastUpdate = tick()
    
    -- Atualizar rankings
    RankingManager.UpdateGlobalRanking()
    RankingManager.UpdateWeeklyRanking()
    
    -- Notificar jogadores
    RemoteEvents.Ranking.RankingUpdated:FireAllClients()
end

-- Atualizar ranking global
function RankingManager.UpdateGlobalRanking()
    local leaderboard = {}
    
    for player, data in pairs(playerStats) do
        if player and player.Parent then
            table.insert(leaderboard, {
                player = player,
                level = data.level,
                power = data.power,
                cash = data.cash,
                diamonds = data.diamonds,
                dungeonsCompleted = data.dungeonsCompleted,
                raidsCompleted = data.raidsCompleted,
                totalXP = data.totalXP,
                shadowsCaptured = data.shadowsCaptured,
                enemiesKilled = data.enemiesKilled
            })
        end
    end
    
    -- Ordenar por poder total
    table.sort(leaderboard, function(a, b)
        return a.power > b.power
    end)
    
    rankingData.global = leaderboard
end

-- Atualizar ranking semanal
function RankingManager.UpdateWeeklyRanking()
    local leaderboard = {}
    
    for player, data in pairs(playerStats) do
        if player and player.Parent then
            -- Calcular progresso semanal
            local weeklyProgress = {
                level = data.level,
                power = data.power,
                dungeonsCompleted = data.dungeonsCompleted,
                raidsCompleted = data.raidsCompleted,
                shadowsCaptured = data.shadowsCaptured,
                enemiesKilled = data.enemiesKilled
            }
            
            table.insert(leaderboard, {
                player = player,
                progress = weeklyProgress
            })
        end
    end
    
    -- Ordenar por progresso semanal
    table.sort(leaderboard, function(a, b)
        return a.progress.power > b.progress.power
    end)
    
    rankingData.weekly = leaderboard
end

-- Obter ranking global
function RankingManager.GetGlobalRanking(limit)
    limit = limit or 100
    
    local result = {}
    for i = 1, math.min(limit, #rankingData.global) do
        table.insert(result, rankingData.global[i])
    end
    
    return result
end

-- Obter ranking semanal
function RankingManager.GetWeeklyRanking(limit)
    limit = limit or 100
    
    local result = {}
    for i = 1, math.min(limit, #rankingData.weekly) do
        table.insert(result, rankingData.weekly[i])
    end
    
    return result
end

-- Obter posição do jogador no ranking
function RankingManager.GetPlayerRank(player, rankingType)
    rankingType = rankingType or "power"
    
    for i, entry in ipairs(rankingData.global) do
        if entry.player == player then
            return i
        end
    end
    
    return nil
end

-- Obter estatísticas do jogador
function RankingManager.GetPlayerStats(player)
    RankingManager.InitializePlayer(player)
    return playerStats[player]
end

-- Calcular poder total do jogador
function RankingManager.CalculatePlayerPower(player)
    local data = playerStats[player]
    if not data then
        return 0
    end
    
    local power = 0
    
    -- Poder base do nível
    power = power + (data.level * 100)
    
    -- Poder das sombras
    -- TODO: Integrar com sistema de sombras
    
    -- Poder das armas
    -- TODO: Integrar com sistema de armas
    
    -- Poder das relíquias
    -- TODO: Integrar com sistema de relíquias
    
    -- Bônus por conquistas
    power = power + (data.dungeonsCompleted * 50)
    power = power + (data.raidsCompleted * 100)
    power = power + (data.shadowsCaptured * 25)
    power = power + (data.enemiesKilled * 5)
    
    return power
end

-- Resetar ranking semanal
function RankingManager.ResetWeeklyRanking()
    rankingData.weekly = {}
    rankingData.lastWeeklyReset = tick()
    
    -- Notificar jogadores
    RemoteEvents.Ranking.RankingUpdated:FireAllClients()
end

-- Verificar se precisa resetar ranking semanal
function RankingManager.CheckWeeklyReset()
    local currentTime = tick()
    local timeSinceReset = currentTime - rankingData.lastWeeklyReset
    local weekInSeconds = 7 * 24 * 60 * 60 -- 7 dias em segundos
    
    if timeSinceReset >= weekInSeconds then
        RankingManager.ResetWeeklyRanking()
    end
end

-- Obter top jogadores por categoria
function RankingManager.GetTopPlayers(category, limit)
    category = category or "power"
    limit = limit or 10
    
    local leaderboard = {}
    
    for player, data in pairs(playerStats) do
        if player and player.Parent then
            local value = 0
            
            if category == "level" then
                value = data.level
            elseif category == "power" then
                value = data.power
            elseif category == "cash" then
                value = data.cash
            elseif category == "diamonds" then
                value = data.diamonds
            elseif category == "dungeons" then
                value = data.dungeonsCompleted
            elseif category == "raids" then
                value = data.raidsCompleted
            elseif category == "shadows" then
                value = data.shadowsCaptured
            elseif category == "kills" then
                value = data.enemiesKilled
            end
            
            table.insert(leaderboard, {
                player = player,
                value = value,
                level = data.level,
                power = data.power
            })
        end
    end
    
    -- Ordenar por valor
    table.sort(leaderboard, function(a, b)
        return a.value > b.value
    end)
    
    -- Retornar apenas o limite solicitado
    local result = {}
    for i = 1, math.min(limit, #leaderboard) do
        table.insert(result, leaderboard[i])
    end
    
    return result
end

-- Obter estatísticas gerais do servidor
function RankingManager.GetServerStats()
    local totalPlayers = 0
    local totalLevel = 0
    local totalPower = 0
    local totalCash = 0
    local totalDiamonds = 0
    local totalDungeons = 0
    local totalRaids = 0
    local totalShadows = 0
    local totalKills = 0
    
    for player, data in pairs(playerStats) do
        if player and player.Parent then
            totalPlayers = totalPlayers + 1
            totalLevel = totalLevel + data.level
            totalPower = totalPower + data.power
            totalCash = totalCash + data.cash
            totalDiamonds = totalDiamonds + data.diamonds
            totalDungeons = totalDungeons + data.dungeonsCompleted
            totalRaids = totalRaids + data.raidsCompleted
            totalShadows = totalShadows + data.shadowsCaptured
            totalKills = totalKills + data.enemiesKilled
        end
    end
    
    return {
        totalPlayers = totalPlayers,
        averageLevel = totalPlayers > 0 and totalLevel / totalPlayers or 0,
        averagePower = totalPlayers > 0 and totalPower / totalPlayers or 0,
        totalCash = totalCash,
        totalDiamonds = totalDiamonds,
        totalDungeons = totalDungeons,
        totalRaids = totalRaids,
        totalShadows = totalShadows,
        totalKills = totalKills
    }
end

-- Conectar eventos
local function onPlayerAdded(player)
    RankingManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerStats[player] = nil
end

-- Conectar eventos de ranking
RemoteEvents.Ranking.UpdateRanking.OnServerEvent:Connect(function(player, stats)
    RankingManager.UpdatePlayerRanking(player, stats)
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Loop de verificação de reset semanal
RunService.Heartbeat:Connect(function()
    RankingManager.CheckWeeklyReset()
end)

return RankingManager