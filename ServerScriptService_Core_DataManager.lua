-- ServerScriptService/Core/DataManager
-- Cole este script como Script dentro de ServerScriptService/Core/

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_v1")

local DataManager = {}
DataManager.PlayerData = {} -- Cache de dados dos jogadores

-- 📊 ESTRUTURA PADRÃO DE DADOS
local function GetDefaultData()
	local GameConfig = require(game.ReplicatedStorage.Modules.GameConfig)
	
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
		InventorySlots = GameConfig.Inventory.InitialSlots,
		
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
		},
		
		-- 🧭 Dungeons/Raids
		DungeonCooldowns = {},
		RaidCooldowns = {},
		
		-- 🎯 Conquistas
		Achievements = {},
		
		-- ⏰ Timestamps
		LastSave = os.time(),
		CreatedAt = os.time(),
	}
end

-- 💾 SALVAR DADOS DO JOGADOR
function DataManager:SavePlayerData(player)
	local playerData = self.PlayerData[player.UserId]
	
	if not playerData then
		warn("Tentativa de salvar dados inexistentes para:", player.Name)
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
		return true
	end
	return false
end

-- ➕ ADICIONAR RECURSO
function DataManager:AddResource(player, resourceType, amount)
	local data = self:GetPlayerData(player)
	if data and data[resourceType] then
		data[resourceType] = data[resourceType] + amount
		return true
	end
	return false
end

-- ➖ REMOVER RECURSO
function DataManager:RemoveResource(player, resourceType, amount)
	local data = self:GetPlayerData(player)
	if data and data[resourceType] and data[resourceType] >= amount then
		data[resourceType] = data[resourceType] - amount
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
	data.Stats.ShadowsCaptured = data.Stats.ShadowsCaptured + 1
	return true
end

-- 📊 ADICIONAR XP
function DataManager:AddXP(player, amount)
	local data = self:GetPlayerData(player)
	if not data then return false end
	
	local GameConfig = require(game.ReplicatedStorage.Modules.GameConfig)
	
	-- Aplicar bônus de relíquias
	local UtilityFunctions = require(game.ReplicatedStorage.Modules.UtilityFunctions)
	local RelicData = require(game.ReplicatedStorage.Modules.RelicData)
	
	local totalBonus = RelicData:CalculateTotalBonus(data.EquippedRelics)
	amount = amount * (1 + totalBonus.XPBoost)
	
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
		
		-- Aplicar bônus de level up
		-- (Isso seria aplicado via atributos do personagem)
		
		xpRequired = UtilityFunctions:CalculateXPRequired(
			data.Level,
			GameConfig.Experience.BaseXPRequired,
			GameConfig.Experience.XPScaling
		)
	end
	
	return true, leveledUp, data.Level
end

-- 🏆 ADICIONAR ESTATÍSTICA
function DataManager:AddStat(player, statName, amount)
	local data = self:GetPlayerData(player)
	if not data or not data.Stats[statName] then return false end
	
	data.Stats[statName] = data.Stats[statName] + (amount or 1)
	return true
end

-- 🔄 AUTO SAVE
local function AutoSave()
	while true do
		wait(300) -- 5 minutos
		
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
	
	-- Carregar dados
	local data = DataManager:LoadPlayerData(player)
	
	-- Criar leaderstats
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
	
	-- Atualizar leaderstats periodicamente
	task.spawn(function()
		while player.Parent do
			wait(1)
			local currentData = DataManager:GetPlayerData(player)
			if currentData then
				levelValue.Value = currentData.Level
				cashValue.Value = currentData.Cash
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	print("👋 Jogador saindo:", player.Name)
	
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
	
	wait(3) -- Aguardar salvamentos
end)

-- Iniciar auto-save
task.spawn(AutoSave)

print("✅ DataManager inicializado")

return DataManager
