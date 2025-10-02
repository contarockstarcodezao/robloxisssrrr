-- ServerScriptService/Core/DataManager
-- Sistema completo de dados para Arise: Crossover

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataStore = DataStoreService:GetDataStore("AriseData_v1")

-- Módulos
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEventsSetup)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)

local DataManager = {}
DataManager.PlayerData = {}

-- 📊 ESTRUTURA PADRÃO DE DADOS
local function GetDefaultData()
	return {
		-- 📈 Progressão
		Level = 1,
		XP = 0,
		
		-- 💰 Economia
		Gold = GameConfig.Economy.StartingGold,
		Diamonds = GameConfig.Economy.StartingDiamonds,
		ShadowFragments = 0,
		
		-- 📊 Pontos de Status
		StatusPoints = {
			Available = 0,
			PlayerSpeed = 0,
			PlayerDamage = 0,
			ShadowSpeed = 0,
			ShadowDamage = 0,
			ShadowRange = 0
		},
		
		-- 🧞 Sombras
		Shadows = {}, -- Array de sombras capturadas
		ActiveShadow = nil, -- ID da sombra equipada
		ShadowSlots = 5, -- Aumenta com level
		
		-- ⚔️ Armas e Relíquias
		EquippedWeapon = nil,
		EquippedRelics = {}, -- Até 3
		
		-- 🎒 Inventário
		Inventory = {
			Weapons = {},
			Relics = {},
			Consumables = {}
		},
		
		-- 🧪 Estatísticas
		Stats = {
			TotalKills = 0,
			BossKills = 0,
			ShadowsCaptured = 0,
			DungeonsCompleted = 0,
			DamageTaken = 0,
			DamageDealt = 0
		},
		
		-- 🏆 Títulos
		Titles = {},
		EquippedTitle = nil,
		
		-- 👥 Guilda
		GuildID = nil,
		GuildRank = 0,
		
		-- 📋 Missões
		Missions = {
			Daily = {},
			Weekly = {}
		},
		LastMissionReset = {
			Daily = os.time(),
			Weekly = os.time()
		},
		
		-- 🏰 Dungeons
		DungeonCooldowns = {},
		
		-- 🎰 Sorteios
		DailySpins = GameConfig.Raffle.DailyFreeSpins,
		LastSpinReset = os.time(),
		
		-- ⏰ Timestamps
		PlayTime = 0,
		LastSave = os.time(),
		CreatedAt = os.time(),
		LastLogin = os.time()
	}
end

-- 💾 SALVAR DADOS
function DataManager:SavePlayerData(player)
	local playerData = self.PlayerData[player.UserId]
	if not playerData then
		warn("❌ Dados não encontrados para:", player.Name)
		return false
	end
	
	playerData.LastSave = os.time()
	
	local success, errorMsg = pcall(function()
		PlayerDataStore:SetAsync("Player_" .. player.UserId, playerData)
	end)
	
	if success then
		print("✅ Dados salvos:", player.Name)
		return true
	else
		warn("❌ Erro ao salvar:", player.Name, errorMsg)
		return false
	end
end

-- 📥 CARREGAR DADOS
function DataManager:LoadPlayerData(player)
	local userId = player.UserId
	local data = nil
	
	local success, errorMsg = pcall(function()
		data = PlayerDataStore:GetAsync("Player_" .. userId)
	end)
	
	if success then
		if data then
			-- Mesclar com dados padrão (novos campos)
			local defaultData = GetDefaultData()
			for key, value in pairs(defaultData) do
				if data[key] == nil then
					data[key] = value
				end
			end
			data.LastLogin = os.time()
			self.PlayerData[userId] = data
			print("✅ Dados carregados:", player.Name)
		else
			self.PlayerData[userId] = GetDefaultData()
			print("🆕 Novos dados criados:", player.Name)
		end
	else
		warn("❌ Erro ao carregar:", player.Name, errorMsg)
		self.PlayerData[userId] = GetDefaultData()
	end
	
	return self.PlayerData[userId]
end

-- 🔄 OBTER DADOS
function DataManager:GetPlayerData(player)
	return self.PlayerData[player.UserId]
end

-- ✏️ ATUALIZAR DADOS
function DataManager:UpdateData(player, key, value)
	local data = self:GetPlayerData(player)
	if data then
		data[key] = value
		RemoteEvents.DataUpdate:FireClient(player, key, value)
		return true
	end
	return false
end

-- ➕ ADICIONAR RECURSO
function DataManager:AddResource(player, resourceType, amount)
	local data = self:GetPlayerData(player)
	if data and data[resourceType] then
		data[resourceType] = data[resourceType] + amount
		RemoteEvents.DataUpdate:FireClient(player, resourceType, data[resourceType])
		return true
	end
	return false
end

-- 📊 ADICIONAR XP E VERIFICAR LEVEL UP
function DataManager:AddXP(player, amount)
	local data = self:GetPlayerData(player)
	if not data then return false end
	
	data.XP = data.XP + amount
	
	local xpRequired = UtilityFunctions:CalculateXPRequired(
		data.Level,
		GameConfig.Leveling.BaseXPRequired,
		GameConfig.Leveling.XPScaling
	)
	
	local leveledUp = false
	while data.XP >= xpRequired and data.Level < GameConfig.Leveling.MaxLevel do
		data.XP = data.XP - xpRequired
		data.Level = data.Level + 1
		data.StatusPoints.Available = data.StatusPoints.Available + GameConfig.Leveling.StatusPointsPerLevel
		leveledUp = true
		
		-- Verificar se desbloqueia novo slot de sombra
		for _, unlockLevel in ipairs(GameConfig.Leveling.ShadowSlotIncrease) do
			if data.Level == unlockLevel then
				data.ShadowSlots = data.ShadowSlots + 1
			end
		end
		
		xpRequired = UtilityFunctions:CalculateXPRequired(
			data.Level,
			GameConfig.Leveling.BaseXPRequired,
			GameConfig.Leveling.XPScaling
		)
	end
	
	RemoteEvents.DataUpdate:FireClient(player, "XP", data.XP)
	RemoteEvents.DataUpdate:FireClient(player, "Level", data.Level)
	
	if leveledUp then
		RemoteEvents.ShowNotification:FireClient(player, "LEVEL UP!", "Nível " .. data.Level, "Success")
	end
	
	return true, leveledUp, data.Level
end

-- 🏆 ADICIONAR ESTATÍSTICA
function DataManager:AddStat(player, statName, amount)
	local data = self:GetPlayerData(player)
	if not data or not data.Stats[statName] then return false end
	
	data.Stats[statName] = data.Stats[statName] + (amount or 1)
	RemoteEvents.DataUpdate:FireClient(player, "Stats", data.Stats)
	return true
end

-- 🎮 CRIAR LEADERSTATS
function DataManager:CreateLeaderstats(player)
	local data = self:GetPlayerData(player)
	if not data then return end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local levelValue = Instance.new("IntValue")
	levelValue.Name = "Nível"
	levelValue.Value = data.Level
	levelValue.Parent = leaderstats
	
	local goldValue = Instance.new("IntValue")
	goldValue.Name = "Gold"
	goldValue.Value = data.Gold
	goldValue.Parent = leaderstats
	
	-- Atualizar periodicamente
	task.spawn(function()
		while player.Parent do
			task.wait(1)
			local currentData = self:GetPlayerData(player)
			if currentData then
				levelValue.Value = currentData.Level
				goldValue.Value = currentData.Gold
			end
		end
	end)
end

-- 🔄 AUTO-SAVE
local function AutoSave()
	while true do
		task.wait(GameConfig.Timers.AutoSaveInterval)
		print("🔄 Auto-save iniciado...")
		local savedCount = 0
		for _, player in ipairs(Players:GetPlayers()) do
			if DataManager:SavePlayerData(player) then
				savedCount = savedCount + 1
			end
		end
		print("✅ Auto-save concluído:", savedCount, "jogadores")
	end
end

-- 🎮 EVENTOS DE JOGADORES
Players.PlayerAdded:Connect(function(player)
	print("👤 Jogador entrou:", player.Name)
	local data = DataManager:LoadPlayerData(player)
	DataManager:CreateLeaderstats(player)
	
	task.wait(1)
	RemoteEvents.DataUpdate:FireClient(player, "FullData", data)
end)

Players.PlayerRemoving:Connect(function(player)
	print("👋 Jogador saindo:", player.Name)
	DataManager:SavePlayerData(player)
	DataManager.PlayerData[player.UserId] = nil
end)

-- 🚪 FECHAR SERVIDOR
game:BindToClose(function()
	print("🚪 Salvando todos os dados...")
	for _, player in ipairs(Players:GetPlayers()) do
		DataManager:SavePlayerData(player)
	end
	task.wait(3)
end)

-- 📡 REMOTE FUNCTION
RemoteEvents.RequestPlayerData.OnServerInvoke = function(player)
	return DataManager:GetPlayerData(player)
end

-- Inicializar
task.spawn(AutoSave)

print("✅ DataManager inicializado!")

return DataManager
