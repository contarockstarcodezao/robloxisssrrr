-- ServerScriptService/Systems/CombatServer
-- Sistema de combate integrado com DataManager

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")

-- Módulos
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local RelicData = require(ReplicatedStorage.Modules.RelicData)
local DataManager = require(ServerScriptService.Core.DataManager)

-- Cooldowns dos jogadores (previne spam)
local PlayerCooldowns = {}

-- Posições originais dos NPCs para respawn
local NPCSpawnPositions = {}

-- ============================
-- SISTEMA DE HITBOX
-- ============================

local function GetNPCsInRange(position, range)
	local npcsInRange = {}
	
	-- Procura por todos os NPCs marcados com a tag "Enemy"
	for _, npc in ipairs(CollectionService:GetTagged(GameConfig.Tags.Enemy)) do
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

local function CalculateDamage(baseDamage, playerData)
	-- Aplicar bônus de relíquias
	local totalBonus = RelicData:CalculateTotalBonus(playerData.EquippedRelics)
	local finalDamage = baseDamage * (1 + totalBonus.DamageBoost)
	
	-- Aplicar bônus de level (0.5% por level)
	finalDamage = finalDamage * (1 + (playerData.Level * 0.005))
	
	return math.floor(finalDamage)
end

local function IsBoss(npc)
	return CollectionService:HasTag(npc, GameConfig.Tags.Boss)
end

local function CalculateRewards(npc, playerData)
	local baseXP = GameConfig.Combat.NPCSettings.BaseXPReward
	local baseCash = GameConfig.Combat.NPCSettings.BaseCashReward
	
	-- Multiplicador para boss
	if IsBoss(npc) then
		baseXP = baseXP * GameConfig.Combat.NPCSettings.BossMultiplier
		baseCash = baseCash * GameConfig.Combat.NPCSettings.BossMultiplier
	end
	
	-- Bônus de level do NPC (se configurado)
	local npcLevel = npc:GetAttribute("Level") or 1
	baseXP = baseXP * npcLevel
	baseCash = baseCash * npcLevel
	
	return {
		XP = baseXP,
		Cash = baseCash,
		IsBoss = IsBoss(npc)
	}
end

local function ApplyDamage(npc, damage, attacker)
	local humanoid = npc:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end
	
	-- Aplicar dano
	humanoid:TakeDamage(damage)
	
	-- Criar efeito visual
	if npc:FindFirstChild("HumanoidRootPart") then
		UtilityFunctions:CreateHitEffect(
			npc.HumanoidRootPart.Position,
			Color3.fromRGB(255, 100, 100)
		)
	end
	
	-- Verificar se o NPC morreu
	if humanoid.Health <= 0 then
		local playerData = DataManager:GetPlayerData(attacker)
		if not playerData then return false end
		
		-- Calcular recompensas
		local rewards = CalculateRewards(npc, playerData)
		
		-- Adicionar XP e Cash
		local _, leveledUp, newLevel = DataManager:AddXP(attacker, rewards.XP)
		DataManager:AddCash(attacker, rewards.Cash)
		
		-- Atualizar estatísticas
		DataManager:AddStat(attacker, "TotalKills", 1)
		DataManager:AddStat(attacker, "DamageDealt", damage)
		
		if rewards.IsBoss then
			DataManager:AddStat(attacker, "BossKills", 1)
		end
		
		-- Chance de capturar sombra
		local captureChance = GameConfig.Shadows.CaptureChance
		local totalBonus = RelicData:CalculateTotalBonus(playerData.EquippedRelics)
		captureChance = captureChance + totalBonus.ShadowCaptureBoost
		
		if UtilityFunctions:RandomChance(captureChance) then
			local shadow = {
				ID = npc.Name .. "_" .. os.time(),
				Name = npc.Name,
				Level = npc:GetAttribute("Level") or 1,
				CapturedAt = os.time()
			}
			
			local success, msg = DataManager:AddShadow(attacker, shadow)
			if success then
				RemoteEvents.AttackFeedback:FireClient(attacker, "shadow_captured", shadow)
			end
		end
		
		-- Notificar level up
		if leveledUp then
			RemoteEvents.AttackFeedback:FireClient(attacker, "level_up", newLevel)
		end
		
		-- Agendar respawn
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
	task.wait(GameConfig.Combat.NPCSettings.RespawnTime)
	
	-- Verifica se o NPC ainda existe
	if npc and npc.Parent then
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = GameConfig.Combat.NPCSettings.DefaultHealth
			
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
	
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return end
	
	-- Verifica cooldown
	local currentTime = tick()
	local cooldownKey = player.UserId
	
	if PlayerCooldowns[cooldownKey] then
		local attackConfig = GameConfig.Combat.AttackStyles[attackStyle]
		if currentTime - PlayerCooldowns[cooldownKey] < attackConfig.Cooldown then
			return -- Ainda em cooldown
		end
	end
	
	-- Atualiza cooldown
	PlayerCooldowns[cooldownKey] = currentTime
	
	-- Obtém configurações do estilo de ataque
	local attackConfig = GameConfig.Combat.AttackStyles[attackStyle]
	if not attackConfig then
		warn("⚠️ Estilo de ataque inválido:", attackStyle)
		return
	end
	
	-- Calcula dano final
	local finalDamage = CalculateDamage(attackConfig.Damage, playerData)
	
	-- Encontra NPCs dentro do alcance
	local npcsInRange = GetNPCsInRange(attackPosition, attackConfig.Range)
	
	-- Aplica dano a todos os NPCs na área
	local hitCount = 0
	for _, npc in ipairs(npcsInRange) do
		local killed = ApplyDamage(npc, finalDamage, player)
		hitCount = hitCount + 1
		
		-- Envia feedback visual para o cliente
		RemoteEvents.AttackFeedback:FireClient(player, "hit", {
			NPCName = npc.Name,
			Damage = finalDamage,
			Killed = killed
		})
	end
	
	-- Se não acertou ninguém, envia feedback de miss
	if hitCount == 0 then
		RemoteEvents.AttackFeedback:FireClient(player, "miss")
	end
end

-- ============================
-- INICIALIZAÇÃO
-- ============================

local function InitializeNPCs()
	-- Salva a posição inicial de todos os NPCs existentes
	for _, npc in ipairs(CollectionService:GetTagged(GameConfig.Tags.Enemy)) do
		SaveNPCSpawnPosition(npc)
		
		-- Configura a vida inicial
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = GameConfig.Combat.NPCSettings.DefaultHealth
			humanoid.Health = GameConfig.Combat.NPCSettings.DefaultHealth
		end
		
		-- Define level padrão se não tiver
		if not npc:GetAttribute("Level") then
			npc:SetAttribute("Level", 1)
		end
	end
	
	-- Monitora novos NPCs adicionados
	CollectionService:GetInstanceAddedSignal(GameConfig.Tags.Enemy):Connect(function(npc)
		SaveNPCSpawnPosition(npc)
		
		local humanoid = npc:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.MaxHealth = GameConfig.Combat.NPCSettings.DefaultHealth
			humanoid.Health = GameConfig.Combat.NPCSettings.DefaultHealth
		end
		
		if not npc:GetAttribute("Level") then
			npc:SetAttribute("Level", 1)
		end
	end)
end

-- ============================
-- CONEXÕES DE EVENTOS
-- ============================

RemoteEvents.AttackEvent.OnServerEvent:Connect(function(player, attackStyle, attackPosition)
	ProcessAttack(player, attackStyle, attackPosition)
end)

-- ============================
-- INICIALIZAÇÃO PRINCIPAL
-- ============================

InitializeNPCs()

print("✅ Sistema de Combate (Servidor) inicializado!")
