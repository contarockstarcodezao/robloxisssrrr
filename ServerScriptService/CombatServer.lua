-- ServerScriptService/CombatServer
-- Lógica principal do servidor para o sistema de combate

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")

-- Módulos
local CombatConfig = require(ReplicatedStorage:WaitForChild("CombatConfig"))
local CombatRemotes = require(ReplicatedStorage:WaitForChild("CombatRemotes"))

-- Cooldowns dos jogadores (previne spam)
local PlayerCooldowns = {}

-- Dados dos jogadores (XP e moedas)
local PlayerData = {}

-- Posições originais dos NPCs para respawn
local NPCSpawnPositions = {}

-- ============================
-- FUNÇÕES DE UTILIDADE
-- ============================

local function InitializePlayerData(player)
	if not PlayerData[player.UserId] then
		PlayerData[player.UserId] = {
			XP = 0,
			Coins = 0
		}
	end
end

local function GetPlayerData(player)
	InitializePlayerData(player)
	return PlayerData[player.UserId]
end

local function AddReward(player, xp, coins)
	local data = GetPlayerData(player)
	data.XP = data.XP + xp
	data.Coins = data.Coins + coins
	
	-- Envia atualização para o cliente
	CombatRemotes.RewardUpdate:FireClient(player, data.XP, data.Coins)
end

-- ============================
-- SISTEMA DE HITBOX
-- ============================

local function GetNPCsInRange(position, range)
	local npcsInRange = {}
	
	-- Procura por todos os NPCs marcados com a tag "Enemy"
	for _, npc in ipairs(CollectionService:GetTagged(CombatConfig.NPCTag)) do
		if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") then
			local humanoid = npc:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Health > 0 then
				local npcPosition = npc.HumanoidRootPart.Position
				local distance = (position - npcPosition).Magnitude
				
				if distance <= range then
					table.insert(npcsInRange, npc)
				end
			end
		end
	end
	
	return npcsInRange
end

-- ============================
-- SISTEMA DE DANO
-- ============================

local function ApplyDamage(npc, damage, attacker)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end
	
	humanoid:TakeDamage(damage)
	
	-- Verifica se o NPC morreu
	if humanoid.Health <= 0 then
		-- Gera recompensas
		local xpReward = CombatConfig.NPCSettings.XPReward
		local coinsReward = CombatConfig.NPCSettings.CoinsReward
		
		AddReward(attacker, xpReward, coinsReward)
		
		-- Agenda o respawn
		task.spawn(function()
			RespawnNPC(npc)
		end)
		
		return true -- NPC morreu
	end
	
	return false -- NPC ainda está vivo
end

-- ============================
-- SISTEMA DE RESPAWN
-- ============================

local function SaveNPCSpawnPosition(npc)
	if not npc:FindFirstChild("HumanoidRootPart") then return end
	
	if not NPCSpawnPositions[npc] then
		NPCSpawnPositions[npc] = {
			Position = npc.HumanoidRootPart.CFrame,
			Parent = npc.Parent
		}
	end
end

function RespawnNPC(npc)
	local spawnData = NPCSpawnPositions[npc]
	if not spawnData then return end
	
	-- Aguarda o tempo de respawn
	task.wait(CombatConfig.NPCSettings.RespawnTime)
	
	-- Verifica se o NPC ainda existe
	if npc and npc.Parent then
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = CombatConfig.NPCSettings.DefaultHealth
			
			-- Restaura a posição
			if npc:FindFirstChild("HumanoidRootPart") then
				npc.HumanoidRootPart.CFrame = spawnData.Position
			end
		end
	end
end

-- ============================
-- PROCESSAMENTO DE ATAQUES
-- ============================

local function ProcessAttack(player, attackStyle, attackPosition)
	-- Verifica se o jogador existe
	if not player or not player.Character then
		return
	end
	
	-- Verifica cooldown
	local currentTime = tick()
	local cooldownKey = player.UserId
	
	if PlayerCooldowns[cooldownKey] then
		if currentTime - PlayerCooldowns[cooldownKey] < CombatConfig.AttackStyles[attackStyle].Cooldown then
			return -- Ainda em cooldown
		end
	end
	
	-- Atualiza cooldown
	PlayerCooldowns[cooldownKey] = currentTime
	
	-- Obtém configurações do estilo de ataque
	local attackConfig = CombatConfig.AttackStyles[attackStyle]
	if not attackConfig then
		warn("Estilo de ataque inválido:", attackStyle)
		return
	end
	
	-- Encontra NPCs dentro do alcance
	local npcsInRange = GetNPCsInRange(attackPosition, attackConfig.Range)
	
	-- Aplica dano a todos os NPCs na área
	local hitCount = 0
	for _, npc in ipairs(npcsInRange) do
		local killed = ApplyDamage(npc, attackConfig.Damage, player)
		hitCount = hitCount + 1
		
		-- Envia feedback visual para o cliente
		CombatRemotes.AttackFeedback:FireClient(player, "hit", npc, killed)
	end
	
	-- Se não acertou ninguém, envia feedback de miss
	if hitCount == 0 then
		CombatRemotes.AttackFeedback:FireClient(player, "miss")
	end
end

-- ============================
-- INICIALIZAÇÃO
-- ============================

local function InitializeNPCs()
	-- Salva a posição inicial de todos os NPCs existentes
	for _, npc in ipairs(CollectionService:GetTagged(CombatConfig.NPCTag)) do
		SaveNPCSpawnPosition(npc)
		
		-- Configura a vida inicial
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = CombatConfig.NPCSettings.DefaultHealth
			humanoid.Health = CombatConfig.NPCSettings.DefaultHealth
		end
	end
	
	-- Monitora novos NPCs adicionados
	CollectionService:GetInstanceAddedSignal(CombatConfig.NPCTag):Connect(function(npc)
		SaveNPCSpawnPosition(npc)
		
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = CombatConfig.NPCSettings.DefaultHealth
			humanoid.Health = CombatConfig.NPCSettings.DefaultHealth
		end
	end)
end

local function InitializePlayers()
	-- Inicializa jogadores existentes
	for _, player in ipairs(game.Players:GetPlayers()) do
		InitializePlayerData(player)
	end
	
	-- Monitora novos jogadores
	game.Players.PlayerAdded:Connect(function(player)
		InitializePlayerData(player)
		
		-- Envia dados iniciais
		local data = GetPlayerData(player)
		CombatRemotes.RewardUpdate:FireClient(player, data.XP, data.Coins)
	end)
	
	-- Limpa dados quando jogador sai
	game.Players.PlayerRemoving:Connect(function(player)
		PlayerCooldowns[player.UserId] = nil
		-- Nota: PlayerData pode ser salvo em DataStore aqui
	end)
end

-- ============================
-- CONEXÕES DE EVENTOS
-- ============================

CombatRemotes.AttackEvent.OnServerEvent:Connect(function(player, attackStyle, attackPosition)
	ProcessAttack(player, attackStyle, attackPosition)
end)

-- ============================
-- INICIALIZAÇÃO PRINCIPAL
-- ============================

InitializeNPCs()
InitializePlayers()

print("Sistema de Combate: Servidor inicializado!")
