-- ServerScriptService/Systems/CombatSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local WeaponData = require(ReplicatedStorage.Modules.WeaponData)
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local DataManager = require(ServerScriptService.Core.DataManager)

local CombatEvent = ReplicatedStorage.Events.CombatEvent

local CombatSystem = {}
CombatSystem.AttackCooldowns = {} -- {[player] = lastAttackTime}

-- ⚔️ PROCESSAR ATAQUE
function CombatSystem:ProcessAttack(player, targetPosition)
	-- Verificar cooldown
	local currentTime = tick()
	local lastAttack = self.AttackCooldowns[player] or 0
	
	if currentTime - lastAttack < GameConfig.Combat.AttackCooldown then
		return false, "Cooldown ativo"
	end
	
	self.AttackCooldowns[player] = currentTime
	
	local character = player.Character
	if not character or not character.PrimaryPart then
		return false, "Personagem inválido"
	end
	
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Obter arma equipada
	local weaponType = playerData.WeaponType or "Fist"
	local weaponStats = GameConfig.Combat.Weapons[weaponType]
	
	-- Se tem arma equipada, usar suas stats
	if playerData.EquippedWeapon then
		local weapon = WeaponData:GetWeaponByID(playerData.EquippedWeapon)
		if weapon then
			local weaponInstance = WeaponData:CreateWeaponInstance(playerData.EquippedWeapon, 0)
			weaponStats = weaponInstance.Stats
		end
	end
	
	-- Encontrar inimigos no alcance
	local enemies = UtilityFunctions:FindEnemiesInRadius(
		character.PrimaryPart.Position,
		weaponStats.Range or 10,
		{character}
	)
	
	if #enemies == 0 then
		return false, "Nenhum inimigo no alcance"
	end
	
	-- Atacar inimigo mais próximo
	local target = enemies[1].Enemy
	
	-- Calcular dano (com crítico)
	local damage, isCrit = UtilityFunctions:CalculateDamage(
		weaponStats.Damage or 10,
		weaponStats.CritChance or 0.05,
		weaponStats.CritMultiplier or 1.5
	)
	
	-- Aplicar dano
	local success = UtilityFunctions:ApplyDamage(
		target,
		damage,
		isCrit and "Critical" or "Normal"
	)
	
	if success then
		-- Verificar se matou
		local targetHumanoid = target:FindFirstChild("Humanoid")
		if targetHumanoid and targetHumanoid.Health <= 0 then
			self:OnEnemyKilled(player, target)
		end
		
		-- Notificar cliente para animação
		CombatEvent:FireClient(player, "AttackSuccess", {
			Target = target,
			Damage = damage,
			IsCrit = isCrit
		})
		
		return true
	end
	
	return false, "Falha ao aplicar dano"
end

-- 💀 QUANDO INIMIGO É MORTO
function CombatSystem:OnEnemyKilled(player, enemy)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return end
	
	-- Adicionar estatística
	DataManager:AddStat(player, "TotalKills", 1)
	
	-- Obter rank do NPC (assumindo que está no nome ou em um atributo)
	local npcRank = enemy:GetAttribute("Rank") or "F"
	
	-- Sistema de drops
	local DropSystem = require(ServerScriptService.Systems.DropSystem)
	DropSystem:ProcessDrops(player, enemy, npcRank)
	
	-- Sistema de XP
	local XPSystem = require(ServerScriptService.Systems.XPSystem)
	XPSystem:GiveXP(player, npcRank)
	
	-- Tentar capturar sombra
	local ShadowSystem = require(ServerScriptService.Systems.ShadowSystem)
	ShadowSystem:TryCaptureShadow(player, npcRank)
end

-- 🔫 EQUIPAR ARMA
function CombatSystem:EquipWeapon(player, weaponID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Verificar se jogador possui a arma
	local hasWeapon = false
	for _, weapon in ipairs(playerData.Inventory.Weapons) do
		if weapon.ID == weaponID then
			hasWeapon = true
			break
		end
	end
	
	if not hasWeapon then
		return false, "Arma não encontrada no inventário"
	end
	
	-- Equipar
	playerData.EquippedWeapon = weaponID
	
	-- Atualizar tipo de arma
	local weapon = WeaponData:GetWeaponByID(weaponID)
	if weapon then
		playerData.WeaponType = weapon.Type
	end
	
	CombatEvent:FireClient(player, "WeaponEquipped", weaponID)
	return true
end

-- 🔧 MELHORAR ARMA
function CombatSystem:UpgradeWeapon(player, weaponID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Encontrar arma
	local weaponInstance = nil
	local weaponIndex = nil
	for i, weapon in ipairs(playerData.Inventory.Weapons) do
		if weapon.ID == weaponID then
			weaponInstance = weapon
			weaponIndex = i
			break
		end
	end
	
	if not weaponInstance then
		return false, "Arma não encontrada"
	end
	
	-- Verificar nível máximo
	if weaponInstance.UpgradeLevel >= GameConfig.WeaponSystem.MaxUpgradeLevel then
		return false, "Nível máximo atingido"
	end
	
	-- Obter custo
	local cost = WeaponData:GetUpgradeCost(weaponInstance.Rarity, weaponInstance.UpgradeLevel)
	if not cost then
		return false, "Custo não disponível"
	end
	
	-- Validar recursos
	local valid, err = UtilityFunctions:ValidatePurchase(playerData, cost)
	if not valid then
		return false, err
	end
	
	-- Deduzir recursos
	UtilityFunctions:DeductResources(playerData, cost)
	
	-- Melhorar arma
	weaponInstance.UpgradeLevel = weaponInstance.UpgradeLevel + 1
	weaponInstance.Stats = WeaponData:CalculateUpgradedStats(
		WeaponData:GetWeaponByID(weaponID),
		weaponInstance.UpgradeLevel
	)
	
	-- Atualizar no inventário
	playerData.Inventory.Weapons[weaponIndex] = weaponInstance
	
	CombatEvent:FireClient(player, "WeaponUpgraded", weaponInstance)
	return true, weaponInstance
end

-- 📋 EVENTOS DO CLIENTE
CombatEvent.OnServerEvent:Connect(function(player, action, ...)
	if action == "Attack" then
		local targetPosition = ...
		CombatSystem:ProcessAttack(player, targetPosition)
		
	elseif action == "EquipWeapon" then
		local weaponID = ...
		local success, result = CombatSystem:EquipWeapon(player, weaponID)
		
		if not success then
			CombatEvent:FireClient(player, "Error", result)
		end
		
	elseif action == "UpgradeWeapon" then
		local weaponID = ...
		local success, result = CombatSystem:UpgradeWeapon(player, weaponID)
		
		if success then
			CombatEvent:FireClient(player, "WeaponUpgraded", result)
		else
			CombatEvent:FireClient(player, "Error", result)
		end
	end
end)

print("✅ CombatSystem inicializado")

return CombatSystem
