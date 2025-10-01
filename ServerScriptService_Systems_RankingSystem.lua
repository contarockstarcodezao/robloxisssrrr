-- ServerScriptService/Systems/RankingSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local DataManager = require(ServerScriptService.Core.DataManager)

local RankingEvent = ReplicatedStorage.Events.RankingEvent
local RankingStore = DataStoreService:GetDataStore("Rankings_v1")

local RankingSystem = {}
RankingSystem.GlobalRanking = {}
RankingSystem.WeeklyRanking = {}

-- 📊 CALCULAR PODER DO JOGADOR
function RankingSystem:CalculatePlayerPower(playerData)
	return UtilityFunctions:CalculatePlayerPower(playerData)
end

-- 🔄 ATUALIZAR RANKING GLOBAL
function RankingSystem:UpdateGlobalRanking(player)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return end
	
	local power = self:CalculatePlayerPower(playerData)
	
	local rankingEntry = {
		UserId = player.UserId,
		Name = player.Name,
		DisplayName = player.DisplayName,
		Level = playerData.Level,
		Power = power,
		RaidWins = playerData.Stats.RaidWins or 0,
		Timestamp = os.time(),
	}
	
	-- Atualizar ou adicionar no ranking
	local found = false
	for i, entry in ipairs(self.GlobalRanking) do
		if entry.UserId == player.UserId then
			self.GlobalRanking[i] = rankingEntry
			found = true
			break
		end
	end
	
	if not found then
		table.insert(self.GlobalRanking, rankingEntry)
	end
	
	-- Ordenar
	self.GlobalRanking = UtilityFunctions:SortRanking(self.GlobalRanking)
	
	-- Limitar a top 100
	if #self.GlobalRanking > GameConfig.Ranking.TopPlayersShown then
		for i = #self.GlobalRanking, GameConfig.Ranking.TopPlayersShown + 1, -1 do
			table.remove(self.GlobalRanking, i)
		end
	end
	
	-- Salvar no DataStore
	self:SaveGlobalRanking()
end

-- 💾 SALVAR RANKING GLOBAL
function RankingSystem:SaveGlobalRanking()
	pcall(function()
		RankingStore:SetAsync("Global", self.GlobalRanking)
	end)
end

-- 📥 CARREGAR RANKING GLOBAL
function RankingSystem:LoadGlobalRanking()
	local success, data = pcall(function()
		return RankingStore:GetAsync("Global")
	end)
	
	if success and data then
		self.GlobalRanking = data
	end
end

-- 🔄 ATUALIZAR RANKING SEMANAL
function RankingSystem:UpdateWeeklyRanking(player)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return end
	
	local power = self:CalculatePlayerPower(playerData)
	
	local rankingEntry = {
		UserId = player.UserId,
		Name = player.Name,
		DisplayName = player.DisplayName,
		Level = playerData.Level,
		Power = power,
		RaidWins = playerData.Stats.RaidWins or 0,
		Timestamp = os.time(),
	}
	
	-- Atualizar ou adicionar
	local found = false
	for i, entry in ipairs(self.WeeklyRanking) do
		if entry.UserId == player.UserId then
			self.WeeklyRanking[i] = rankingEntry
			found = true
			break
		end
	end
	
	if not found then
		table.insert(self.WeeklyRanking, rankingEntry)
	end
	
	-- Ordenar
	self.WeeklyRanking = UtilityFunctions:SortRanking(self.WeeklyRanking)
	
	-- Limitar a top 100
	if #self.WeeklyRanking > GameConfig.Ranking.TopPlayersShown then
		for i = #self.WeeklyRanking, GameConfig.Ranking.TopPlayersShown + 1, -1 do
			table.remove(self.WeeklyRanking, i)
		end
	end
	
	-- Salvar
	self:SaveWeeklyRanking()
end

-- 💾 SALVAR RANKING SEMANAL
function RankingSystem:SaveWeeklyRanking()
	pcall(function()
		RankingStore:SetAsync("Weekly_" .. os.date("%Y%W"), self.WeeklyRanking)
	end)
end

-- 📥 CARREGAR RANKING SEMANAL
function RankingSystem:LoadWeeklyRanking()
	local weekKey = "Weekly_" .. os.date("%Y%W")
	
	local success, data = pcall(function()
		return RankingStore:GetAsync(weekKey)
	end)
	
	if success and data then
		self.WeeklyRanking = data
	end
end

-- 🔄 RESETAR RANKING SEMANAL
function RankingSystem:ResetWeeklyRanking()
	print("🔄 Resetando ranking semanal...")
	self.WeeklyRanking = {}
	self:SaveWeeklyRanking()
end

-- 🔍 OBTER POSIÇÃO DO JOGADOR
function RankingSystem:GetPlayerRank(player, rankingType)
	local ranking = rankingType == "Weekly" and self.WeeklyRanking or self.GlobalRanking
	
	for i, entry in ipairs(ranking) do
		if entry.UserId == player.UserId then
			return i, entry
		end
	end
	
	return nil, nil
end

-- 📋 OBTER TOP N JOGADORES
function RankingSystem:GetTopPlayers(rankingType, count)
	local ranking = rankingType == "Weekly" and self.WeeklyRanking or self.GlobalRanking
	count = count or 10
	
	local top = {}
	for i = 1, math.min(count, #ranking) do
		table.insert(top, ranking[i])
	end
	
	return top
end

-- 📋 EVENTOS
RankingEvent.OnServerEvent:Connect(function(player, action, ...)
	if action == "GetRanking" then
		local rankingType = ... or "Global"
		local ranking = rankingType == "Weekly" and RankingSystem.WeeklyRanking or RankingSystem.GlobalRanking
		
		RankingEvent:FireClient(player, "RankingData", {
			Type = rankingType,
			Data = ranking
		})
		
	elseif action == "GetMyRank" then
		local rankingType = ... or "Global"
		local rank, entry = RankingSystem:GetPlayerRank(player, rankingType)
		
		RankingEvent:FireClient(player, "MyRank", {
			Type = rankingType,
			Rank = rank,
			Data = entry
		})
	end
end)

-- 🔄 ATUALIZAÇÃO PERIÓDICA
task.spawn(function()
	while true do
		wait(GameConfig.Ranking.UpdateInterval)
		
		-- Atualizar rankings de todos jogadores online
		for _, player in ipairs(game.Players:GetPlayers()) do
			RankingSystem:UpdateGlobalRanking(player)
			RankingSystem:UpdateWeeklyRanking(player)
		end
	end
end)

-- 🗓️ VERIFICAR RESET SEMANAL
task.spawn(function()
	while true do
		wait(3600) -- Verificar a cada hora
		
		local weekday = tonumber(os.date("%w"))
		if weekday == GameConfig.Ranking.WeeklyResetDay then
			-- Resetar se ainda não foi feito esta semana
			local currentWeek = os.date("%Y%W")
			if not RankingSystem.LastWeeklyReset or RankingSystem.LastWeeklyReset ~= currentWeek then
				RankingSystem:ResetWeeklyRanking()
				RankingSystem.LastWeeklyReset = currentWeek
			end
		end
	end
end)

-- Inicializar
RankingSystem:LoadGlobalRanking()
RankingSystem:LoadWeeklyRanking()

print("✅ RankingSystem inicializado")

return RankingSystem
