-- ServerScriptService/Core/DataManager
-- Sistema completo de gerenciamento de dados do jogador

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v2")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local RelicData = require(ReplicatedStorage.Modules.RelicData)

local DataManager = {}
DataManager.PlayerData = {} -- Cache de dados dos jogadores
DataManager.PlayTimeTracking = {} -- Rastreia tempo de jogo

-- 📊 ESTRUTURA PADRÃO DE DADOS
local function GetDefaultData()
	return {
		-- 📈 Progressão
		Level = 1,
		XP = 0,

		-- 💰 Economia
		Cash = GameConfig.Economy.StartingCash,
		Diamonds = GameConfig.Economy.StartingDiamonds,
		Fragments = 0,

		-- ⚔️ Combate
		WeaponType = "Fist", -- "Fist" ou "Sword"
		EquippedWeapon = nil,

		-- 🧞‍♂️ Sombras
		Shadows = {}, -- Array de sombras capturadas
		ActiveShadow = nil, -- ID da sombra invocada
		ShadowSlots = GameConfig.Shadows.MaxSlots,

		-- 🎒 Inventário
		Inventory = {
			Weapons = {},
			Relics = {},
			Consumables = {},
		},
		InventorySlots = UtilityFunctions:DeepCopy(GameConfig.Inventory.InitialSlots),

		-- 🧿 Relíquias Equipadas
		EquippedRelics = {}, -- Array de até 3 relíquias

		-- 🧪 Estatísticas
		Stats = {
			TotalKills = 0,
			BossKills = 0,
			ShadowsCaptured = 0,
			DungeonsCompleted = 0,
			RaidsCompleted = 0,
			RaidWins = 0,
			DeathCount = 0,
			DamageTaken = 0,
			DamageDealt = 0,
		},

		-- 🧭 Dungeons/Raids
		DungeonCooldowns = {},
		RaidCooldowns = {},

		-- 🎯 Conquistas
		Achievements = {},

		-- ⏰ Timestamps e tempo jogado
		PlayTime = 0, -- Em segundos
		LastSave = os.time(),
		CreatedAt = os.time(),
		LastLogin = os.time(),
	}
end

-- 💾 SALVAR DADOS DO JOGADOR
function DataManager:SavePlayerData(player)
	local playerData = self.PlayerData[player.UserId]

	if not playerData then
		warn("❌ Tentativa de salvar dados inexistentes para:", player.Name)
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
		warn("❌ Erro ao salvar dados de", player.Name, ":", errorMsg)
		return false
	end
end

-- 📥 CARREGAR DADOS DO JOGADOR
function DataManager:LoadPlayerData(player)
	local userId = player.UserId
	local data = nil

	local success, errorMsg = pcall(function()
		data = PlayerDataStore:GetAsync("Player_" .. userId)
	end)

	if success then
		if data then
			-- Mesclar com dados padrão (para adicionar novos campos)
			local defaultData = GetDefaultData()
			for key, value in pairs(defaultData) do
				if data[key] == nil then
					data[key] = value
				end
			end

			-- Atualizar timestamp de login
			data.LastLogin = os.time()
			
			self.PlayerData[userId] = data
			print("✅ Dados carregados:", player.Name)
		else
			-- Primeiro login, criar dados novos
			self.PlayerData[userId] = GetDefaultData()
			print("🆕 Novos dados criados para:", player.Name)
		end
	else
		warn("❌ Erro ao carregar dados de", player.Name, ":", errorMsg)
		-- Usar dados padrão em caso de erro
		self.PlayerData[userId] = GetDefaultData()
	end

	return self.PlayerData[userId]
end

-- 🔄 OBTER DADOS DO JOGADOR
function DataManager:GetPlayerData(player)
	return self.PlayerData[player.UserId]
end

-- ✏️ ATUALIZAR DADOS DO JOGADOR
function DataManager:UpdatePlayerData(player, key, value)
	local data = self:GetPlayerData(player)
	if data then
		data[key] = value
		self:SendDataUpdate(player, key, value)
		return true
	end
	return false
end

-- 📡 ENVIAR ATUALIZAÇÃO PARA O CLIENTE
function DataManager:SendDataUpdate(player, key, value)
	RemoteEvents.DataUpdate:FireClient(player, key, value)
end

-- ➕ ADICIONAR RECURSO
function DataManager:AddResource(player, resourceType, amount)
	local data = self:GetPlayerData(player)
	if data and data[resourceType] then
		data[resourceType] = data[resourceType] + amount
		self:SendDataUpdate(player, resourceType, data[resourceType])
		return true
	end
	return false
end

-- ➖ REMOVER RECURSO
function DataManager:RemoveResource(player, resourceType, amount)
	local data = self:GetPlayerData(player)
	if data and data[resourceType] and data[resourceType] >= amount then
		data[resourceType] = data[resourceType] - amount
		self:SendDataUpdate(player, resourceType, data[resourceType])
		return true
	end
	return false
end

-- 🎁 ADICIONAR ITEM AO INVENTÁRIO
function DataManager:AddItem(player, category, item)
	local data = self:GetPlayerData(player)
	if not data then return false end

	local inventory = data.Inventory[category]
	if not inventory then return false end

	local maxSlots = data.InventorySlots[category] or 50
	if #inventory >= maxSlots then
		return false, "Inventário cheio"
	end

	table.insert(inventory, item)
	self:SendDataUpdate(player, "Inventory", data.Inventory)
	return true
end

-- 🗑️ REMOVER ITEM DO INVENTÁRIO
function DataManager:RemoveItem(player, category, itemID)
	local data = self:GetPlayerData(player)
	if not data then return false end

	local inventory = data.Inventory[category]
	if not inventory then return false end

	for i, item in ipairs(inventory) do
		if item.ID == itemID then
			table.remove(inventory, i)
			self:SendDataUpdate(player, "Inventory", data.Inventory)
			return true
		end
	end

	return false
end

-- 🧞‍♂️ ADICIONAR SOMBRA
function DataManager:AddShadow(player, shadow)
	local data = self:GetPlayerData(player)
	if not data then return false end

	if #data.Shadows >= data.ShadowSlots then
		return false, "Slots de sombra cheios"
	end

	table.insert(data.Shadows, shadow)
	self:AddStat(player, "ShadowsCaptured", 1)
	self:SendDataUpdate(player, "Shadows", data.Shadows)
	return true
end

-- 📊 ADICIONAR XP
function DataManager:AddXP(player, amount)
	local data = self:GetPlayerData(player)
	if not data then return false end

	-- Aplicar bônus de relíquias
	local totalBonus = RelicData:CalculateTotalBonus(data.EquippedRelics)
	amount = math.floor(amount * (1 + totalBonus.XPBoost))

	data.XP = data.XP + amount

	-- Verificar level up
	local xpRequired = UtilityFunctions:CalculateXPRequired(
		data.Level,
		GameConfig.Experience.BaseXPRequired,
		GameConfig.Experience.XPScaling
	)

	local leveledUp = false
	while data.XP >= xpRequired and data.Level < GameConfig.Experience.MaxLevel do
		data.XP = data.XP - xpRequired
		data.Level = data.Level + 1
		leveledUp = true

		-- Verificar conquistas de level
		self:CheckAchievements(player)

		xpRequired = UtilityFunctions:CalculateXPRequired(
			data.Level,
			GameConfig.Experience.BaseXPRequired,
			GameConfig.Experience.XPScaling
		)
	end

	-- Enviar atualizações
	self:SendDataUpdate(player, "XP", data.XP)
	self:SendDataUpdate(player, "Level", data.Level)

	return true, leveledUp, data.Level
end

-- 💰 ADICIONAR CASH COM BÔNUS
function DataManager:AddCash(player, amount)
	local data = self:GetPlayerData(player)
	if not data then return false end

	-- Aplicar bônus de relíquias
	local totalBonus = RelicData:CalculateTotalBonus(data.EquippedRelics)
	amount = math.floor(amount * (1 + totalBonus.CashBoost))

	return self:AddResource(player, "Cash", amount)
end

-- 🏆 ADICIONAR ESTATÍSTICA
function DataManager:AddStat(player, statName, amount)
	local data = self:GetPlayerData(player)
	if not data or not data.Stats[statName] then return false end

	data.Stats[statName] = data.Stats[statName] + (amount or 1)
	self:SendDataUpdate(player, "Stats", data.Stats)
	
	-- Verificar conquistas
	self:CheckAchievements(player)
	
	return true
end

-- 🎯 VERIFICAR E DESBLOQUEAR CONQUISTAS
function DataManager:CheckAchievements(player)
	local data = self:GetPlayerData(player)
	if not data then return end

	for _, achievement in ipairs(GameConfig.Achievements) do
		-- Pula se já desbloqueado
		if table.find(data.Achievements, achievement.ID) then
			continue
		end

		-- Verifica requisito
		local unlocked = false
		local req = achievement.Requirement

		if req.Type == "Kills" and data.Stats.TotalKills >= req.Amount then
			unlocked = true
		elseif req.Type == "BossKills" and data.Stats.BossKills >= req.Amount then
			unlocked = true
		elseif req.Type == "ShadowsCaptured" and data.Stats.ShadowsCaptured >= req.Amount then
			unlocked = true
		elseif req.Type == "Level" and data.Level >= req.Amount then
			unlocked = true
		elseif req.Type == "PlayTime" and data.PlayTime >= req.Amount then
			unlocked = true
		end

		if unlocked then
			self:UnlockAchievement(player, achievement)
		end
	end
end

-- 🏅 DESBLOQUEAR CONQUISTA
function DataManager:UnlockAchievement(player, achievement)
	local data = self:GetPlayerData(player)
	if not data then return end

	-- Adiciona conquista
	table.insert(data.Achievements, achievement.ID)

	-- Concede recompensas
	if achievement.Rewards.Cash then
		self:AddCash(player, achievement.Rewards.Cash)
	end
	if achievement.Rewards.XP then
		self:AddXP(player, achievement.Rewards.XP)
	end
	if achievement.Rewards.Diamonds then
		self:AddResource(player, "Diamonds", achievement.Rewards.Diamonds)
	end

	-- Notifica cliente
	RemoteEvents.AchievementUnlocked:FireClient(player, achievement)
	
	print("🏆", player.Name, "desbloqueou:", achievement.Name)
end

-- ⏰ ATUALIZAR TEMPO JOGADO
function DataManager:UpdatePlayTime(player, deltaTime)
	local data = self:GetPlayerData(player)
	if not data then return end

	data.PlayTime = data.PlayTime + deltaTime
	
	-- Verificar conquistas de tempo
	self:CheckAchievements(player)
end

-- 🎮 GERENCIAR LEADERSTATS
function DataManager:CreateLeaderstats(player)
	local data = self:GetPlayerData(player)
	if not data then return end

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local levelValue = Instance.new("IntValue")
	levelValue.Name = "Level"
	levelValue.Value = data.Level
	levelValue.Parent = leaderstats

	local cashValue = Instance.new("IntValue")
	cashValue.Name = "Cash"
	cashValue.Value = data.Cash
	cashValue.Parent = leaderstats

	-- Atualizar leaderstats em tempo real
	task.spawn(function()
		while player.Parent do
			task.wait(1)
			local currentData = self:GetPlayerData(player)
			if currentData then
				levelValue.Value = currentData.Level
				cashValue.Value = currentData.Cash
			end
		end
	end)
end

-- 🔄 AUTO SAVE
local function AutoSave()
	while true do
		task.wait(GameConfig.Time.AutoSaveInterval)

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

-- ⏰ RASTREAMENTO DE TEMPO DE JOGO
local function TrackPlayTime()
	while true do
		task.wait(GameConfig.Time.PlayTimeUpdateInterval)

		for _, player in ipairs(Players:GetPlayers()) do
			if DataManager.PlayTimeTracking[player.UserId] then
				DataManager:UpdatePlayTime(player, GameConfig.Time.PlayTimeUpdateInterval)
			end
		end
	end
end

-- 🎮 EVENTOS DE JOGADORES
Players.PlayerAdded:Connect(function(player)
	print("👤 Jogador entrou:", player.Name)

	-- Carregar dados
	local data = DataManager:LoadPlayerData(player)

	-- Criar leaderstats
	DataManager:CreateLeaderstats(player)

	-- Iniciar rastreamento de tempo
	DataManager.PlayTimeTracking[player.UserId] = true

	-- Enviar dados iniciais para o cliente
	task.wait(1) -- Aguardar cliente carregar
	RemoteEvents.DataUpdate:FireClient(player, "FullData", data)
end)

Players.PlayerRemoving:Connect(function(player)
	print("👋 Jogador saindo:", player.Name)

	-- Parar rastreamento de tempo
	DataManager.PlayTimeTracking[player.UserId] = nil

	-- Salvar dados
	DataManager:SavePlayerData(player)

	-- Limpar cache
	DataManager.PlayerData[player.UserId] = nil
end)

-- 🚪 SALVAR TODOS AO FECHAR SERVIDOR
game:BindToClose(function()
	print("🚪 Servidor fechando, salvando todos os dados...")

	for _, player in ipairs(Players:GetPlayers()) do
		DataManager:SavePlayerData(player)
	end

	task.wait(3) -- Aguardar salvamentos
end)

-- 📡 REMOTE FUNCTION PARA REQUISITAR DADOS
RemoteEvents.RequestData.OnServerInvoke = function(player)
	return DataManager:GetPlayerData(player)
end

-- Iniciar sistemas
task.spawn(AutoSave)
task.spawn(TrackPlayTime)

print("✅ DataManager inicializado")

return DataManager
