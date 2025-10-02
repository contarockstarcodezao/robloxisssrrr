-- ServerScriptService/Systems/DungeonSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local DataManager = require(ServerScriptService.Core.DataManager)
local DropSystem = require(ServerScriptService.Systems.DropSystem)

local DungeonEvent = ReplicatedStorage.Events.DungeonEvent

local DungeonSystem = {}
DungeonSystem.ActiveDungeons = {} -- {[dungeonID] = {Players, StartTime, Enemies}}
DungeonSystem.ActiveRaids = {} -- {[raidID] = {Players, StartTime, Boss}}

-- 🏰 ENTRAR EM DUNGEON
function DungeonSystem:EnterDungeon(player, dungeonID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Verificar cooldown
	local lastEntry = playerData.DungeonCooldowns[dungeonID] or 0
	local currentTime = os.time()
	
	if currentTime - lastEntry < GameConfig.Dungeons.EntryCooldown then
		local remaining = GameConfig.Dungeons.EntryCooldown - (currentTime - lastEntry)
		return false, "Cooldown ativo: " .. remaining .. "s"
	end
	
	-- Criar instância da dungeon
	local dungeonInstance = {
		ID = dungeonID,
		Players = {player},
		StartTime = currentTime,
		Enemies = {},
		Completed = false,
	}
	
	-- Registrar cooldown
	playerData.DungeonCooldowns[dungeonID] = currentTime
	
	-- Adicionar à lista de dungeons ativas
	table.insert(self.ActiveDungeons, dungeonInstance)
	
	-- Teleportar jogador
	self:TeleportToDungeon(player, dungeonID)
	
	-- Spawnar inimigos
	self:SpawnDungeonEnemies(dungeonInstance)
	
	-- Iniciar timer
	self:StartDungeonTimer(dungeonInstance)
	
	DungeonEvent:FireClient(player, "DungeonEntered", dungeonID)
	return true
end

-- 🚪 TELEPORTAR PARA DUNGEON
function DungeonSystem:TeleportToDungeon(player, dungeonID)
	local character = player.Character
	if not character or not character.PrimaryPart then return end
	
	-- Posição da dungeon (substitua por posição real)
	local dungeonPosition = Vector3.new(1000, 50, 1000)
	character:SetPrimaryPartCFrame(CFrame.new(dungeonPosition))
end

-- 👹 SPAWNAR INIMIGOS DA DUNGEON
function DungeonSystem:SpawnDungeonEnemies(dungeonInstance)
	-- Spawnar 5-10 inimigos
	local enemyCount = math.random(5, 10)
	
	for i = 1, enemyCount do
		local enemy = self:CreateDungeonEnemy("D") -- Rank D por padrão
		table.insert(dungeonInstance.Enemies, enemy)
		
		-- Quando inimigo morre
		enemy.Humanoid.Died:Connect(function()
			self:OnDungeonEnemyKilled(dungeonInstance, enemy)
		end)
	end
end

-- 👾 CRIAR INIMIGO DE DUNGEON
function DungeonSystem:CreateDungeonEnemy(rank)
	local enemy = Instance.new("Model")
	enemy.Name = "DungeonEnemy_" .. rank
	
	local part = Instance.new("Part")
	part.Size = Vector3.new(2, 5, 2)
	part.Anchored = false
	part.Color = Color3.fromRGB(255, 0, 0)
	part.Position = Vector3.new(1010, 50, 1010) -- Perto da dungeon
	part.Parent = enemy
	
	local humanoid = Instance.new("Humanoid")
	humanoid.Health = 500
	humanoid.MaxHealth = 500
	humanoid.Parent = enemy
	
	enemy.PrimaryPart = part
	enemy:SetAttribute("Rank", rank)
	enemy.Parent = workspace
	
	return enemy
end

-- 💀 QUANDO INIMIGO DE DUNGEON MORRE
function DungeonSystem:OnDungeonEnemyKilled(dungeonInstance, enemy)
	-- Remover da lista
	for i, e in ipairs(dungeonInstance.Enemies) do
		if e == enemy then
			table.remove(dungeonInstance.Enemies, i)
			break
		end
	end
	
	-- Verificar se todos foram derrotados
	if #dungeonInstance.Enemies == 0 then
		self:CompleteDungeon(dungeonInstance)
	end
end

-- ✅ COMPLETAR DUNGEON
function DungeonSystem:CompleteDungeon(dungeonInstance)
	dungeonInstance.Completed = true
	
	-- Recompensar jogadores
	for _, player in ipairs(dungeonInstance.Players) do
		DropSystem:ProcessRaidRewards({player}, "Dungeon")
		DataManager:AddStat(player, "DungeonsCompleted", 1)
		
		DungeonEvent:FireClient(player, "DungeonCompleted", {
			TimeElapsed = os.time() - dungeonInstance.StartTime
		})
		
		-- Teleportar de volta
		self:TeleportToLobby(player)
	end
end

-- ⏱️ TIMER DA DUNGEON
function DungeonSystem:StartDungeonTimer(dungeonInstance)
	task.spawn(function()
		task.wait(GameConfig.Dungeons.MaxDuration)
		
		if not dungeonInstance.Completed then
			-- Tempo esgotado, falhou
			for _, player in ipairs(dungeonInstance.Players) do
				DungeonEvent:FireClient(player, "DungeonFailed", "Tempo esgotado")
				self:TeleportToLobby(player)
			end
		end
	end)
end

-- 🏠 TELEPORTAR PARA LOBBY
function DungeonSystem:TeleportToLobby(player)
	local character = player.Character
	if not character or not character.PrimaryPart then return end
	
	-- Posição do spawn (substitua por posição real)
	local spawnPosition = Vector3.new(0, 50, 0)
	character:SetPrimaryPartCFrame(CFrame.new(spawnPosition))
end

-- 🐉 ENTRAR EM RAID
function DungeonSystem:EnterRaid(player, raidID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Verificar level mínimo
	if playerData.Level < 20 then
		return false, "Level mínimo: 20"
	end
	
	-- Verificar cooldown
	local lastEntry = playerData.RaidCooldowns[raidID] or 0
	local currentTime = os.time()
	
	if currentTime - lastEntry < GameConfig.Raids.EntryCooldown then
		local remaining = GameConfig.Raids.EntryCooldown - (currentTime - lastEntry)
		return false, "Cooldown ativo: " .. math.floor(remaining / 60) .. " minutos"
	end
	
	-- Procurar raid ativa ou criar nova
	local raidInstance = self:FindOrCreateRaid(raidID)
	
	-- Adicionar jogador
	if #raidInstance.Players >= GameConfig.Raids.MaxPlayers then
		return false, "Raid cheia"
	end
	
	table.insert(raidInstance.Players, player)
	playerData.RaidCooldowns[raidID] = currentTime
	
	-- Teleportar
	self:TeleportToRaid(player, raidID)
	
	-- Se tiver jogadores suficientes, iniciar
	if #raidInstance.Players >= GameConfig.Raids.MinPlayers and not raidInstance.Started then
		self:StartRaid(raidInstance)
	end
	
	DungeonEvent:FireClient(player, "RaidEntered", raidID)
	return true
end

-- 🎯 ENCONTRAR OU CRIAR RAID
function DungeonSystem:FindOrCreateRaid(raidID)
	-- Procurar raid ativa
	for _, raid in ipairs(self.ActiveRaids) do
		if raid.ID == raidID and not raid.Started then
			return raid
		end
	end
	
	-- Criar nova
	local raidInstance = {
		ID = raidID,
		Players = {},
		StartTime = nil,
		Boss = nil,
		Started = false,
		Completed = false,
	}
	
	table.insert(self.ActiveRaids, raidInstance)
	return raidInstance
end

-- 🚀 INICIAR RAID
function DungeonSystem:StartRaid(raidInstance)
	raidInstance.Started = true
	raidInstance.StartTime = os.time()
	
	-- Spawnar boss
	raidInstance.Boss = self:SpawnRaidBoss(raidInstance.ID)
	
	-- Quando boss morre
	raidInstance.Boss.Humanoid.Died:Connect(function()
		self:CompleteRaid(raidInstance, true)
	end)
	
	-- Timer
	task.spawn(function()
		task.wait(GameConfig.Raids.MaxDuration)
		
		if not raidInstance.Completed then
			self:CompleteRaid(raidInstance, false)
		end
	end)
	
	-- Notificar jogadores
	for _, player in ipairs(raidInstance.Players) do
		DungeonEvent:FireClient(player, "RaidStarted", raidInstance.ID)
	end
end

-- 👑 SPAWNAR BOSS DA RAID
function DungeonSystem:SpawnRaidBoss(raidID)
	local boss = Instance.new("Model")
	boss.Name = "RaidBoss_" .. raidID
	
	local part = Instance.new("Part")
	part.Size = Vector3.new(10, 15, 10)
	part.Anchored = false
	part.Color = Color3.fromRGB(150, 0, 0)
	part.Position = Vector3.new(2000, 50, 2000)
	part.Parent = boss
	
	local humanoid = Instance.new("Humanoid")
	humanoid.Health = 50000
	humanoid.MaxHealth = 50000
	humanoid.Parent = boss
	
	boss.PrimaryPart = part
	boss:SetAttribute("Rank", "SS")
	boss.Parent = workspace
	
	return boss
end

-- ✅ COMPLETAR RAID
function DungeonSystem:CompleteRaid(raidInstance, victory)
	raidInstance.Completed = true
	
	for _, player in ipairs(raidInstance.Players) do
		if victory then
			DropSystem:ProcessRaidRewards({player}, "Raid")
			DataManager:AddStat(player, "RaidsCompleted", 1)
			DataManager:AddStat(player, "RaidWins", 1)
			
			DungeonEvent:FireClient(player, "RaidVictory")
		else
			DungeonEvent:FireClient(player, "RaidFailed", "Tempo esgotado")
		end
		
		self:TeleportToLobby(player)
	end
	
	-- Limpar boss
	if raidInstance.Boss then
		raidInstance.Boss:Destroy()
	end
end

-- 🚪 TELEPORTAR PARA RAID
function DungeonSystem:TeleportToRaid(player, raidID)
	local character = player.Character
	if not character or not character.PrimaryPart then return end
	
	local raidPosition = Vector3.new(2000, 50, 2000)
	character:SetPrimaryPartCFrame(CFrame.new(raidPosition))
end

-- 📋 EVENTOS
DungeonEvent.OnServerEvent:Connect(function(player, action, ...)
	if action == "EnterDungeon" then
		local dungeonID = ...
		local success, result = DungeonSystem:EnterDungeon(player, dungeonID)
		
		if not success then
			DungeonEvent:FireClient(player, "Error", result)
		end
		
	elseif action == "EnterRaid" then
		local raidID = ...
		local success, result = DungeonSystem:EnterRaid(player, raidID)
		
		if not success then
			DungeonEvent:FireClient(player, "Error", result)
		end
	end
end)

print("✅ DungeonSystem inicializado")

return DungeonSystem
