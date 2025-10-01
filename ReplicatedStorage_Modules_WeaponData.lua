-- ReplicatedStorage/Modules/WeaponData
-- Cole este script como ModuleScript dentro de ReplicatedStorage/Modules/

local WeaponData = {}

-- ⚔️ BANCO DE DADOS DE ARMAS
WeaponData.Templates = {
	-- ARMAS COMUNS
	{
		ID = "WEAPON_001",
		Name = "Espada Enferrujada",
		Type = "Sword",
		Rarity = "Common",
		BaseStats = {
			Damage = 15,
			Speed = 1.0,
			Range = 8,
			CritChance = 0.05,
			CritMultiplier = 1.5,
		},
		SpecialEffect = nil,
		ModelID = "rbxassetid://0",
		DropRate = 100,
	},
	
	{
		ID = "WEAPON_002",
		Name = "Luvas de Couro",
		Type = "Fist",
		Rarity = "Common",
		BaseStats = {
			Damage = 12,
			Speed = 1.3,
			Range = 5,
			CritChance = 0.08,
			CritMultiplier = 1.5,
		},
		SpecialEffect = nil,
		ModelID = "rbxassetid://0",
		DropRate = 100,
	},
	
	-- ARMAS RARAS
	{
		ID = "WEAPON_003",
		Name = "Espada de Aço",
		Type = "Sword",
		Rarity = "Rare",
		BaseStats = {
			Damage = 25,
			Speed = 1.1,
			Range = 10,
			CritChance = 0.10,
			CritMultiplier = 1.8,
		},
		SpecialEffect = {
			Type = "LifeSteal",
			Value = 0.05, -- 5% de roubo de vida
			Description = "Recupera 5% do dano causado como vida",
		},
		ModelID = "rbxassetid://0",
		DropRate = 50,
	},
	
	{
		ID = "WEAPON_004",
		Name = "Manoplas de Ferro",
		Type = "Fist",
		Rarity = "Rare",
		BaseStats = {
			Damage = 20,
			Speed = 1.4,
			Range = 6,
			CritChance = 0.12,
			CritMultiplier = 1.8,
		},
		SpecialEffect = {
			Type = "AttackSpeed",
			Value = 0.10, -- +10% velocidade de ataque
			Description = "Aumenta a velocidade de ataque em 10%",
		},
		ModelID = "rbxassetid://0",
		DropRate = 50,
	},
	
	-- ARMAS ÉPICAS
	{
		ID = "WEAPON_005",
		Name = "Lâmina das Sombras",
		Type = "Sword",
		Rarity = "Epic",
		BaseStats = {
			Damage = 40,
			Speed = 1.2,
			Range = 12,
			CritChance = 0.20,
			CritMultiplier = 2.0,
		},
		SpecialEffect = {
			Type = "DamageOverTime",
			Value = 10, -- 10 de dano por segundo
			Duration = 5, -- por 5 segundos
			Description = "Causa sangramento: 10 de dano por segundo durante 5 segundos",
		},
		ModelID = "rbxassetid://0",
		DropRate = 20,
	},
	
	{
		ID = "WEAPON_006",
		Name = "Punhos Flamejantes",
		Type = "Fist",
		Rarity = "Epic",
		BaseStats = {
			Damage = 35,
			Speed = 1.5,
			Range = 7,
			CritChance = 0.18,
			CritMultiplier = 2.0,
		},
		SpecialEffect = {
			Type = "ElementalDamage",
			Element = "Fire",
			Value = 0.25, -- +25% dano de fogo
			Description = "Ataques causam 25% de dano adicional como fogo",
		},
		ModelID = "rbxassetid://0",
		DropRate = 20,
	},
	
	{
		ID = "WEAPON_007",
		Name = "Espada de Gelo Eterno",
		Type = "Sword",
		Rarity = "Epic",
		BaseStats = {
			Damage = 38,
			Speed = 1.0,
			Range = 11,
			CritChance = 0.15,
			CritMultiplier = 2.2,
		},
		SpecialEffect = {
			Type = "Slow",
			Value = 0.30, -- Reduz velocidade em 30%
			Duration = 3, -- por 3 segundos
			Description = "Ataques congelam inimigos, reduzindo velocidade em 30%",
		},
		ModelID = "rbxassetid://0",
		DropRate = 18,
	},
	
	-- ARMAS LENDÁRIAS
	{
		ID = "WEAPON_008",
		Name = "Espada do Dragão",
		Type = "Sword",
		Rarity = "Legendary",
		BaseStats = {
			Damage = 70,
			Speed = 1.3,
			Range = 15,
			CritChance = 0.30,
			CritMultiplier = 2.5,
		},
		SpecialEffect = {
			Type = "AOEAttack",
			Value = 0.50, -- 50% do dano em área
			Radius = 10,
			Description = "Ataques causam 50% do dano em área de 10 studs",
		},
		ModelID = "rbxassetid://0",
		DropRate = 5,
	},
	
	{
		ID = "WEAPON_009",
		Name = "Garras do Demônio",
		Type = "Fist",
		Rarity = "Legendary",
		BaseStats = {
			Damage = 65,
			Speed = 1.7,
			Range = 8,
			CritChance = 0.35,
			CritMultiplier = 2.5,
		},
		SpecialEffect = {
			Type = "MultiStrike",
			Value = 3, -- 3 ataques consecutivos
			Description = "Cada ataque causa 3 golpes rápidos consecutivos",
		},
		ModelID = "rbxassetid://0",
		DropRate = 5,
	},
	
	{
		ID = "WEAPON_010",
		Name = "Excalibur das Trevas",
		Type = "Sword",
		Rarity = "Legendary",
		BaseStats = {
			Damage = 75,
			Speed = 1.2,
			Range = 14,
			CritChance = 0.25,
			CritMultiplier = 3.0,
		},
		SpecialEffect = {
			Type = "ExecuteDamage",
			Value = 0.20, -- Executa alvos com menos de 20% de vida
			BonusDamage = 2.0, -- +200% dano contra alvos baixa vida
			Description = "Causa 200% de dano extra contra alvos com menos de 20% de vida",
		},
		ModelID = "rbxassetid://0",
		DropRate = 4,
	},
	
	-- ARMAS MÍTICAS
	{
		ID = "WEAPON_011",
		Name = "Lâmina do Caos Primordial",
		Type = "Sword",
		Rarity = "Mythic",
		BaseStats = {
			Damage = 120,
			Speed = 1.5,
			Range = 20,
			CritChance = 0.50,
			CritMultiplier = 4.0,
		},
		SpecialEffect = {
			Type = "ChaosStrike",
			Effects = {
				{Type = "LifeSteal", Value = 0.15},
				{Type = "AOEAttack", Value = 0.75, Radius = 15},
				{Type = "DamageOverTime", Value = 20, Duration = 10},
			},
			Description = "Combina roubo de vida, dano em área e sangramento devastador",
		},
		ModelID = "rbxassetid://0",
		DropRate = 1,
	},
	
	{
		ID = "WEAPON_012",
		Name = "Punhos do Deus da Destruição",
		Type = "Fist",
		Rarity = "Mythic",
		BaseStats = {
			Damage = 110,
			Speed = 2.0,
			Range = 10,
			CritChance = 0.60,
			CritMultiplier = 4.0,
		},
		SpecialEffect = {
			Type = "DevastatingCombo",
			Effects = {
				{Type = "MultiStrike", Value = 5},
				{Type = "AttackSpeed", Value = 0.30},
				{Type = "TrueStrike", Description = "Ignora 50% da defesa"},
			},
			Description = "Causa 5 golpes consecutivos com velocidade aumentada, ignorando defesas",
		},
		ModelID = "rbxassetid://0",
		DropRate = 1,
	},
	
	{
		ID = "WEAPON_013",
		Name = "Espada do Fim dos Tempos",
		Type = "Sword",
		Rarity = "Mythic",
		BaseStats = {
			Damage = 150,
			Speed = 1.4,
			Range = 25,
			CritChance = 0.45,
			CritMultiplier = 5.0,
		},
		SpecialEffect = {
			Type = "Apocalypse",
			Effects = {
				{Type = "InstantKill", Chance = 0.05, Description = "5% chance de eliminar instantaneamente"},
				{Type = "AOEAttack", Value = 1.0, Radius = 20},
				{Type = "ElementalDamage", Element = "All", Value = 0.50},
			},
			Description = "Poder devastador: 5% chance de eliminação instantânea + dano elemental massivo",
		},
		ModelID = "rbxassetid://0",
		DropRate = 1,
	},
}

-- 🎯 FUNÇÕES AUXILIARES

-- Obter arma por ID
function WeaponData:GetWeaponByID(id)
	for _, weapon in ipairs(self.Templates) do
		if weapon.ID == id then
			return weapon
		end
	end
	return nil
end

-- Obter armas por tipo
function WeaponData:GetWeaponsByType(weaponType)
	local weapons = {}
	for _, weapon in ipairs(self.Templates) do
		if weapon.Type == weaponType then
			table.insert(weapons, weapon)
		end
	end
	return weapons
end

-- Obter armas por raridade
function WeaponData:GetWeaponsByRarity(rarity)
	local weapons = {}
	for _, weapon in ipairs(self.Templates) do
		if weapon.Rarity == rarity then
			table.insert(weapons, weapon)
		end
	end
	return weapons
end

-- Obter arma aleatória ponderada por drop rate
function WeaponData:GetRandomWeapon()
	local totalWeight = 0
	for _, weapon in ipairs(self.Templates) do
		totalWeight = totalWeight + weapon.DropRate
	end
	
	local random = math.random() * totalWeight
	local currentWeight = 0
	
	for _, weapon in ipairs(self.Templates) do
		currentWeight = currentWeight + weapon.DropRate
		if random <= currentWeight then
			return weapon
		end
	end
	
	return self.Templates[1] -- Fallback
end

-- Calcular stats com upgrade
function WeaponData:CalculateUpgradedStats(baseWeapon, upgradeLevel)
	local GameConfig = require(script.Parent.GameConfig)
	local multiplier = 1 + (upgradeLevel * 0.1) -- +10% por nível
	
	return {
		Damage = math.floor(baseWeapon.BaseStats.Damage * multiplier),
		Speed = baseWeapon.BaseStats.Speed * (1 + upgradeLevel * 0.05), -- +5% velocidade
		Range = baseWeapon.BaseStats.Range,
		CritChance = math.min(baseWeapon.BaseStats.CritChance + (upgradeLevel * 0.02), 0.95), -- +2% crit, max 95%
		CritMultiplier = baseWeapon.BaseStats.CritMultiplier + (upgradeLevel * 0.1), -- +0.1x por nível
	}
end

-- Criar instância de arma para jogador
function WeaponData:CreateWeaponInstance(weaponID, upgradeLevel)
	upgradeLevel = upgradeLevel or 0
	local template = self:GetWeaponByID(weaponID)
	
	if not template then
		return nil
	end
	
	return {
		ID = weaponID,
		Name = template.Name,
		Type = template.Type,
		Rarity = template.Rarity,
		UpgradeLevel = upgradeLevel,
		Stats = self:CalculateUpgradedStats(template, upgradeLevel),
		SpecialEffect = template.SpecialEffect,
		ModelID = template.ModelID,
		AcquiredAt = os.time(),
	}
end

-- Calcular custo de upgrade
function WeaponData:GetUpgradeCost(rarity, currentLevel)
	local GameConfig = require(script.Parent.GameConfig)
	local baseCost = GameConfig.WeaponSystem.UpgradeCosts[rarity]
	
	if not baseCost then
		return nil
	end
	
	-- Custo aumenta com o nível
	return {
		Cash = baseCost.Cash * (currentLevel + 1),
		Diamonds = baseCost.Diamonds * (currentLevel + 1),
	}
end

-- Calcular poder da arma
function WeaponData:CalculatePower(weaponInstance)
	local stats = weaponInstance.Stats
	local power = stats.Damage * stats.Speed * (1 + stats.CritChance * stats.CritMultiplier)
	
	-- Multiplicador de raridade
	local rarityMultipliers = {
		Common = 1.0,
		Rare = 1.5,
		Epic = 2.5,
		Legendary = 4.0,
		Mythic = 10.0,
	}
	
	return power * (rarityMultipliers[weaponInstance.Rarity] or 1.0)
end

return WeaponData
