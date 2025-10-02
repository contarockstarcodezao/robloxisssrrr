-- ReplicatedStorage/Modules/ShadowData
-- Cole este script como ModuleScript dentro de ReplicatedStorage/Modules/

local ShadowData = {}

-- 🧞‍♂️ BANCO DE DADOS DE SOMBRAS
ShadowData.Templates = {
	-- RANK F
	{
		ID = "SHADOW_001",
		Name = "Goblin Sombrio",
		Rank = "F",
		BaseStats = {
			Health = 100,
			Damage = 10,
			Speed = 12,
			AttackRange = 8,
		},
		Abilities = {
			Passive = {
				Name = "Fúria Goblin",
				Description = "+5% de dano ao atacar alvos com menos de 50% de vida",
				Effect = {Type = "DamageBoost", Value = 0.05, Condition = "LowHealth"},
			},
		},
		ModelID = "rbxassetid://0", -- Substitua por modelo real
		Rarity = 100, -- Peso de spawn
	},
	
	{
		ID = "SHADOW_002",
		Name = "Lobo das Sombras",
		Rank = "F",
		BaseStats = {
			Health = 120,
			Damage = 8,
			Speed = 15,
			AttackRange = 6,
		},
		Abilities = {
			Passive = {
				Name = "Velocidade Lupina",
				Description = "+10% de velocidade de movimento",
				Effect = {Type = "SpeedBoost", Value = 0.10},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 100,
	},
	
	-- RANK E
	{
		ID = "SHADOW_003",
		Name = "Esqueleto Guerreiro",
		Rank = "E",
		BaseStats = {
			Health = 180,
			Damage = 15,
			Speed = 10,
			AttackRange = 10,
		},
		Abilities = {
			Passive = {
				Name = "Armadura Óssea",
				Description = "Reduz 5% do dano recebido",
				Effect = {Type = "DamageReduction", Value = 0.05},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 80,
	},
	
	{
		ID = "SHADOW_004",
		Name = "Mago Sombrio",
		Rank = "E",
		BaseStats = {
			Health = 150,
			Damage = 20,
			Speed = 8,
			AttackRange = 15,
		},
		Abilities = {
			Active = {
				Name = "Bola de Fogo Sombria",
				Description = "Lança uma bola de fogo que causa dano em área",
				Effect = {Type = "AOEDamage", Value = 25, Radius = 10, Cooldown = 8},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 70,
	},
	
	-- RANK D
	{
		ID = "SHADOW_005",
		Name = "Orc Berserker",
		Rank = "D",
		BaseStats = {
			Health = 300,
			Damage = 25,
			Speed = 14,
			AttackRange = 8,
		},
		Abilities = {
			Active = {
				Name = "Fúria Berserker",
				Description = "Aumenta dano em 50% por 5 segundos",
				Effect = {Type = "DamageBuff", Value = 0.5, Duration = 5, Cooldown = 15},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 60,
	},
	
	{
		ID = "SHADOW_006",
		Name = "Arqueiro Fantasma",
		Rank = "D",
		BaseStats = {
			Health = 220,
			Damage = 30,
			Speed = 16,
			AttackRange = 25,
		},
		Abilities = {
			Passive = {
				Name = "Tiro Preciso",
				Description = "15% de chance de crítico (2x dano)",
				Effect = {Type = "CriticalChance", Value = 0.15, Multiplier = 2},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 55,
	},
	
	-- RANK C
	{
		ID = "SHADOW_007",
		Name = "Cavaleiro das Trevas",
		Rank = "C",
		BaseStats = {
			Health = 500,
			Damage = 40,
			Speed = 12,
			AttackRange = 10,
		},
		Abilities = {
			Passive = {
				Name = "Armadura Pesada",
				Description = "Reduz 15% do dano recebido",
				Effect = {Type = "DamageReduction", Value = 0.15},
			},
			Active = {
				Name = "Golpe Devastador",
				Description = "Causa 150% de dano com knockback",
				Effect = {Type = "HeavyStrike", Value = 1.5, Cooldown = 10},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 45,
	},
	
	{
		ID = "SHADOW_008",
		Name = "Necromante",
		Rank = "C",
		BaseStats = {
			Health = 400,
			Damage = 35,
			Speed = 10,
			AttackRange = 20,
		},
		Abilities = {
			Active = {
				Name = "Invocar Esqueletos",
				Description = "Invoca 2 esqueletos que lutam por 15 segundos",
				Effect = {Type = "Summon", Count = 2, Duration = 15, Cooldown = 25},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 40,
	},
	
	-- RANK B
	{
		ID = "SHADOW_009",
		Name = "Dragão Menor",
		Rank = "B",
		BaseStats = {
			Health = 800,
			Damage = 60,
			Speed = 16,
			AttackRange = 15,
		},
		Abilities = {
			Active = {
				Name = "Sopro de Fogo",
				Description = "Lança chamas em cone, causando dano massivo",
				Effect = {Type = "ConeDamage", Value = 80, Range = 20, Cooldown = 12},
			},
			Passive = {
				Name = "Escamas Dracônicas",
				Description = "Reduz 20% do dano recebido",
				Effect = {Type = "DamageReduction", Value = 0.20},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 30,
	},
	
	{
		ID = "SHADOW_010",
		Name = "Demônio Guerreiro",
		Rank = "B",
		BaseStats = {
			Health = 750,
			Damage = 70,
			Speed = 14,
			AttackRange = 12,
		},
		Abilities = {
			Active = {
				Name = "Corte Infernal",
				Description = "Ataque giratório que causa dano em área",
				Effect = {Type = "SpinAttack", Value = 85, Radius = 15, Cooldown = 10},
			},
			Passive = {
				Name = "Regeneração Demoníaca",
				Description = "Regenera 2% de vida por segundo",
				Effect = {Type = "HealthRegen", Value = 0.02},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 28,
	},
	
	-- RANK A
	{
		ID = "SHADOW_011",
		Name = "Anjo Caído",
		Rank = "A",
		BaseStats = {
			Health = 1200,
			Damage = 90,
			Speed = 18,
			AttackRange = 18,
		},
		Abilities = {
			Active = {
				Name = "Julgamento Divino",
				Description = "Chuva de lanças sagradas em área",
				Effect = {Type = "AOEStrike", Value = 120, Radius = 20, Cooldown = 15},
			},
			Passive = {
				Name = "Asas da Redenção",
				Description = "+25% velocidade e voo",
				Effect = {Type = "Flight", SpeedBoost = 0.25},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 20,
	},
	
	{
		ID = "SHADOW_012",
		Name = "Titã de Pedra",
		Rank = "A",
		BaseStats = {
			Health = 2000,
			Damage = 80,
			Speed = 8,
			AttackRange = 15,
		},
		Abilities = {
			Active = {
				Name = "Terremoto",
				Description = "Golpeia o chão causando dano e atordoamento",
				Effect = {Type = "Earthquake", Value = 100, Radius = 25, Stun = 2, Cooldown = 20},
			},
			Passive = {
				Name = "Pele de Granito",
				Description = "Reduz 30% do dano recebido",
				Effect = {Type = "DamageReduction", Value = 0.30},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 18,
	},
	
	-- RANK S
	{
		ID = "SHADOW_013",
		Name = "Fênix Sombria",
		Rank = "S",
		BaseStats = {
			Health = 1800,
			Damage = 120,
			Speed = 22,
			AttackRange = 20,
		},
		Abilities = {
			Active = {
				Name = "Ressurreição das Cinzas",
				Description = "Revive com 50% de vida ao morrer (1x por invocação)",
				Effect = {Type = "Revive", Value = 0.5, Uses = 1},
			},
			Passive = {
				Name = "Chamas Eternas",
				Description = "Ataques causam dano de queimadura contínuo",
				Effect = {Type = "BurnDOT", Value = 10, Duration = 5},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 10,
	},
	
	{
		ID = "SHADOW_014",
		Name = "Lich Ancião",
		Rank = "S",
		BaseStats = {
			Health = 1500,
			Damage = 130,
			Speed = 12,
			AttackRange = 25,
		},
		Abilities = {
			Active = {
				Name = "Praga Mortal",
				Description = "Espalha doença que causa dano ao longo do tempo",
				Effect = {Type = "PlagueAOE", Value = 20, Duration = 10, Radius = 30, Cooldown = 18},
			},
			Passive = {
				Name = "Imortalidade Arcana",
				Description = "Regenera 3% de vida por segundo",
				Effect = {Type = "HealthRegen", Value = 0.03},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 8,
	},
	
	-- RANK SS
	{
		ID = "SHADOW_015",
		Name = "Dragão Ancião",
		Rank = "SS",
		BaseStats = {
			Health = 3000,
			Damage = 180,
			Speed = 20,
			AttackRange = 30,
		},
		Abilities = {
			Active = {
				Name = "Cólera do Dragão",
				Description = "Transforma-se, aumentando todos atributos em 100%",
				Effect = {Type = "Transformation", Value = 1.0, Duration = 15, Cooldown = 60},
			},
			Passive = {
				Name = "Domínio Dracônico",
				Description = "Reduz 40% do dano e aumenta dano em 30%",
				Effect = {Type = "MultiBonus", DamageReduction = 0.40, DamageBoost = 0.30},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 5,
	},
	
	{
		ID = "SHADOW_016",
		Name = "Lorde Demônio",
		Rank = "SS",
		BaseStats = {
			Health = 2800,
			Damage = 200,
			Speed = 18,
			AttackRange = 25,
		},
		Abilities = {
			Active = {
				Name = "Apocalipse Infernal",
				Description = "Causa dano massivo em toda área ao redor",
				Effect = {Type = "MegaAOE", Value = 250, Radius = 50, Cooldown = 40},
			},
			Passive = {
				Name = "Aura das Trevas",
				Description = "Enfraquece inimigos próximos em 25%",
				Effect = {Type = "DebuffAura", Value = 0.25, Radius = 20},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 4,
	},
	
	-- RANK GM (Grand Master)
	{
		ID = "SHADOW_017",
		Name = "Imperador das Sombras",
		Rank = "GM",
		BaseStats = {
			Health = 5000,
			Damage = 300,
			Speed = 25,
			AttackRange = 40,
		},
		Abilities = {
			Active = {
				Name = "Domínio Absoluto",
				Description = "Paralisa todos inimigos próximos e causa dano devastador",
				Effect = {Type = "UltimatePower", Value = 500, Radius = 60, Stun = 5, Cooldown = 90},
			},
			Passive = {
				Name = "Reinado das Trevas",
				Description = "Todos atributos aumentados em 50%, regeneração massiva",
				Effect = {Type = "GodMode", AllStats = 0.5, HealthRegen = 0.05},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 1,
	},
	
	{
		ID = "SHADOW_018",
		Name = "Guardião Celestial Corrompido",
		Rank = "GM",
		BaseStats = {
			Health = 4500,
			Damage = 280,
			Speed = 28,
			AttackRange = 35,
		},
		Abilities = {
			Active = {
				Name = "Estrela Cadente",
				Description = "Invoca meteoros que causam destruição em massa",
				Effect = {Type = "MeteorStorm", Value = 400, Count = 5, Radius = 30, Cooldown = 75},
			},
			Passive = {
				Name = "Benção Corrompida",
				Description = "Imune a controle de grupo e reduz 50% do dano",
				Effect = {Type = "CCImmunity", DamageReduction = 0.50},
			},
		},
		ModelID = "rbxassetid://0",
		Rarity = 1,
	},
}

-- 🎯 FUNÇÕES AUXILIARES

-- Obter sombra por ID
function ShadowData:GetShadowByID(id)
	for _, shadow in ipairs(self.Templates) do
		if shadow.ID == id then
			return shadow
		end
	end
	return nil
end

-- Obter sombras por rank
function ShadowData:GetShadowsByRank(rank)
	local shadows = {}
	for _, shadow in ipairs(self.Templates) do
		if shadow.Rank == rank then
			table.insert(shadows, shadow)
		end
	end
	return shadows
end

-- Obter sombra aleatória por rank
function ShadowData:GetRandomShadowByRank(rank)
	local shadows = self:GetShadowsByRank(rank)
	if #shadows > 0 then
		return shadows[math.random(1, #shadows)]
	end
	return nil
end

-- Obter sombra aleatória ponderada por raridade
function ShadowData:GetRandomShadow()
	local totalWeight = 0
	for _, shadow in ipairs(self.Templates) do
		totalWeight = totalWeight + shadow.Rarity
	end
	
	local random = math.random() * totalWeight
	local currentWeight = 0
	
	for _, shadow in ipairs(self.Templates) do
		currentWeight = currentWeight + shadow.Rarity
		if random <= currentWeight then
			return shadow
		end
	end
	
	return self.Templates[1] -- Fallback
end

-- Calcular stats com evolução
function ShadowData:CalculateStats(baseShadow, evolutionLevel)
	local GameConfig = require(script.Parent.GameConfig)
	local multiplier = GameConfig.Shadows.EvolutionMultiplier ^ evolutionLevel
	
	return {
		Health = math.floor(baseShadow.BaseStats.Health * multiplier),
		Damage = math.floor(baseShadow.BaseStats.Damage * multiplier),
		Speed = baseShadow.BaseStats.Speed * multiplier,
		AttackRange = baseShadow.BaseStats.AttackRange,
	}
end

-- Criar instância de sombra para jogador
function ShadowData:CreateShadowInstance(shadowID, evolutionLevel)
	evolutionLevel = evolutionLevel or 0
	local template = self:GetShadowByID(shadowID)
	
	if not template then
		return nil
	end
	
	return {
		ID = shadowID,
		Name = template.Name,
		Rank = template.Rank,
		EvolutionLevel = evolutionLevel,
		Stats = self:CalculateStats(template, evolutionLevel),
		Abilities = template.Abilities,
		ModelID = template.ModelID,
		CapturedAt = os.time(),
	}
end

return ShadowData
