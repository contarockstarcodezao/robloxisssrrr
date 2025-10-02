-- ReplicatedStorage/Modules/ShadowData
-- Define todas as sombras, atributos, evolução e comportamento

local ShadowData = {}

-- 🧞‍♂️ RANKS DE SOMBRAS (ordem de progressão)
ShadowData.RankOrder = {
	"F", "E", "D", "C", "B", "A", "S", "S+", 
	"SS", "SS+", "G", "G+", "GM", "GM+"
}

-- 🎨 CORES POR RANK
ShadowData.RankColors = {
	F = Color3.fromRGB(100, 100, 100),
	E = Color3.fromRGB(150, 150, 150),
	D = Color3.fromRGB(100, 200, 100),
	C = Color3.fromRGB(100, 255, 200),
	B = Color3.fromRGB(100, 150, 255),
	A = Color3.fromRGB(150, 100, 255),
	S = Color3.fromRGB(255, 100, 255),
	["S+"] = Color3.fromRGB(255, 150, 255),
	SS = Color3.fromRGB(255, 200, 100),
	["SS+"] = Color3.fromRGB(255, 220, 150),
	G = Color3.fromRGB(255, 50, 50),
	["G+"] = Color3.fromRGB(255, 100, 100),
	GM = Color3.fromRGB(255, 215, 0),
	["GM+"] = Color3.fromRGB(255, 255, 100)
}

-- 📊 ATRIBUTOS BASE POR RANK
ShadowData.BaseStats = {
	F = { Damage = 20, AttackSpeed = 2.0, Range = 10, Health = 100 },
	E = { Damage = 35, AttackSpeed = 1.8, Range = 12, Health = 150 },
	D = { Damage = 55, AttackSpeed = 1.6, Range = 14, Health = 250 },
	C = { Damage = 85, AttackSpeed = 1.4, Range = 16, Health = 400 },
	B = { Damage = 130, AttackSpeed = 1.2, Range = 18, Health = 600 },
	A = { Damage = 200, AttackSpeed = 1.0, Range = 20, Health = 900 },
	S = { Damage = 300, AttackSpeed = 0.9, Range = 22, Health = 1400 },
	["S+"] = { Damage = 450, AttackSpeed = 0.8, Range = 24, Health = 2000 },
	SS = { Damage = 700, AttackSpeed = 0.7, Range = 26, Health = 3000 },
	["SS+"] = { Damage = 1000, AttackSpeed = 0.6, Range = 28, Health = 4500 },
	G = { Damage = 1500, AttackSpeed = 0.5, Range = 30, Health = 6500 },
	["G+"] = { Damage = 2200, AttackSpeed = 0.45, Range = 32, Health = 9000 },
	GM = { Damage = 3500, AttackSpeed = 0.4, Range = 35, Health = 13000 },
	["GM+"] = { Damage = 5500, AttackSpeed = 0.35, Range = 40, Health = 20000 }
}

-- 🧞 SOMBRAS DISPONÍVEIS NO JOGO
ShadowData.Shadows = {
	-- RANK F
	{
		ID = "shadow_wolf_f",
		Name = "Lobo Sombrio",
		Rank = "F",
		Type = "Melee",
		Description = "Um lobo das sombras, ágil mas fraco",
		SpecialAbility = nil,
		Model = "ShadowWolfModel" -- Nome do modelo no workspace/storage
	},
	{
		ID = "shadow_imp_f",
		Name = "Diabrete Sombrio",
		Rank = "F",
		Type = "Ranged",
		Description = "Pequeno demônio que atira projéteis",
		SpecialAbility = "DarkBolt",
		Model = "ShadowImpModel"
	},
	
	-- RANK E
	{
		ID = "shadow_knight_e",
		Name = "Cavaleiro Sombrio",
		Rank = "E",
		Type = "Melee",
		Description = "Guerreiro das trevas com espada",
		SpecialAbility = "SlashWave",
		Model = "ShadowKnightModel"
	},
	
	-- RANK D
	{
		ID = "shadow_mage_d",
		Name = "Mago Sombrio",
		Rank = "D",
		Type = "Ranged",
		Description = "Conjurador de magia das trevas",
		SpecialAbility = "DarkOrb",
		Model = "ShadowMageModel"
	},
	
	-- RANK C
	{
		ID = "shadow_berserker_c",
		Name = "Berserker Sombrio",
		Rank = "C",
		Type = "Melee",
		Description = "Guerreiro furioso com machado duplo",
		SpecialAbility = "RagingStrike",
		Model = "ShadowBerserkerModel"
	},
	
	-- RANK B
	{
		ID = "shadow_assassin_b",
		Name = "Assassino Sombrio",
		Rank = "B",
		Type = "Melee",
		Description = "Ninja das sombras, extremamente rápido",
		SpecialAbility = "ShadowStep",
		Model = "ShadowAssassinModel"
	},
	
	-- RANK A
	{
		ID = "shadow_dragon_a",
		Name = "Dragão Sombrio",
		Rank = "A",
		Type = "Ranged",
		Description = "Dragão menor com sopro das trevas",
		SpecialAbility = "DarkBreath",
		Model = "ShadowDragonModel"
	},
	
	-- RANK S
	{
		ID = "shadow_demon_s",
		Name = "Demônio Sombrio",
		Rank = "S",
		Type = "Melee",
		Description = "Demônio poderoso com chifres flamejantes",
		SpecialAbility = "Inferno",
		Model = "ShadowDemonModel"
	},
	
	-- RANK S+
	{
		ID = "shadow_lich_splus",
		Name = "Lich Sombrio",
		Rank = "S+",
		Type = "Ranged",
		Description = "Necromante supremo das trevas",
		SpecialAbility = "DeathCoil",
		Model = "ShadowLichModel"
	},
	
	-- RANK SS
	{
		ID = "shadow_titan_ss",
		Name = "Titã Sombrio",
		Rank = "SS",
		Type = "Melee",
		Description = "Gigante ancestral das sombras",
		SpecialAbility = "EarthShatter",
		Model = "ShadowTitanModel"
	},
	
	-- RANK SS+
	{
		ID = "shadow_phoenix_ssplus",
		Name = "Fênix Sombria",
		Rank = "SS+",
		Type = "Ranged",
		Description = "Ave imortal envolta em chamas negras",
		SpecialAbility = "DarkFlames",
		Model = "ShadowPhoenixModel"
	},
	
	-- RANK G
	{
		ID = "shadow_archon_g",
		Name = "Arconte Sombrio",
		Rank = "G",
		Type = "Melee",
		Description = "Guardião celestial corrompido",
		SpecialAbility = "DivineCorruption",
		Model = "ShadowArchonModel"
	},
	
	-- RANK G+
	{
		ID = "shadow_leviathan_gplus",
		Name = "Leviatã Sombrio",
		Rank = "G+",
		Type = "Ranged",
		Description = "Serpente colossal dos abismos",
		SpecialAbility = "AbyssalTide",
		Model = "ShadowLeviathanModel"
	},
	
	-- RANK GM
	{
		ID = "shadow_monarch_gm",
		Name = "Monarca das Sombras",
		Rank = "GM",
		Type = "Melee",
		Description = "Rei supremo das trevas",
		SpecialAbility = "MonarchDomain",
		Model = "ShadowMonarchModel"
	},
	
	-- RANK GM+
	{
		ID = "shadow_primordial_gmplus",
		Name = "Primordial Sombrio",
		Rank = "GM+",
		Type = "Hybrid",
		Description = "Entidade primordial das sombras, origem de tudo",
		SpecialAbility = "VoidAnnihilation",
		Model = "ShadowPrimordialModel"
	}
}

-- 🎯 OBTER SOMBRA POR ID
function ShadowData:GetShadowByID(shadowID)
	for _, shadow in ipairs(self.Shadows) do
		if shadow.ID == shadowID then
			return shadow
		end
	end
	return nil
end

-- 🎯 OBTER SOMBRAS POR RANK
function ShadowData:GetShadowsByRank(rank)
	local shadows = {}
	for _, shadow in ipairs(self.Shadows) do
		if shadow.Rank == rank then
			table.insert(shadows, shadow)
		end
	end
	return shadows
end

-- 📊 CALCULAR ATRIBUTOS FINAIS (Base + Level + Evoluções)
function ShadowData:CalculateFinalStats(shadowData, playerStatusPoints)
	local baseStats = self.BaseStats[shadowData.Rank]
	if not baseStats then return nil end
	
	-- Atributos base
	local finalStats = {
		Damage = baseStats.Damage,
		AttackSpeed = baseStats.AttackSpeed,
		Range = baseStats.Range,
		Health = baseStats.Health
	}
	
	-- Bônus de nível da sombra
	local levelMultiplier = 1 + (shadowData.Level or 1) * 0.05 -- 5% por nível
	finalStats.Damage = math.floor(finalStats.Damage * levelMultiplier)
	finalStats.Health = math.floor(finalStats.Health * levelMultiplier)
	
	-- Bônus de pontos de status do jogador
	if playerStatusPoints then
		finalStats.Damage = finalStats.Damage + (playerStatusPoints.ShadowDamage or 0)
		finalStats.AttackSpeed = math.max(0.1, finalStats.AttackSpeed - (playerStatusPoints.ShadowSpeed or 0) * 0.01)
		finalStats.Range = finalStats.Range + (playerStatusPoints.ShadowRange or 0)
	end
	
	return finalStats
end

-- 🔄 OBTER PRÓXIMO RANK
function ShadowData:GetNextRank(currentRank)
	local currentIndex = table.find(self.RankOrder, currentRank)
	if not currentIndex or currentIndex >= #self.RankOrder then
		return nil -- Já está no rank máximo
	end
	return self.RankOrder[currentIndex + 1]
end

-- 🎨 OBTER COR DE AURA POR RANK
function ShadowData:GetAuraColor(rank)
	return self.RankColors[rank] or Color3.fromRGB(255, 255, 255)
end

-- ✨ GERAR SOMBRA ALEATÓRIA POR RANK
function ShadowData:GenerateRandomShadow(rank)
	local shadowsOfRank = self:GetShadowsByRank(rank)
	if #shadowsOfRank == 0 then return nil end
	
	local randomShadow = shadowsOfRank[math.random(1, #shadowsOfRank)]
	
	return {
		ID = randomShadow.ID,
		Name = randomShadow.Name,
		Rank = randomShadow.Rank,
		Level = 1,
		XP = 0,
		CapturedAt = os.time()
	}
end

return ShadowData
