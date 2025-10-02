-- ReplicatedStorage/Modules/GameConfig
-- Configurações globais do jogo Arise: Crossover

local GameConfig = {}

-- 💰 ECONOMIA
GameConfig.Economy = {
	StartingGold = 5000,
	StartingDiamonds = 100,
	GoldPerKill = {
		F = 10, E = 20, D = 35, C = 50,
		B = 75, A = 100, S = 150, ["S+"] = 200,
		SS = 300, ["SS+"] = 450, G = 600,
		["G+"] = 800, GM = 1200, ["GM+"] = 2000
	},
	XPPerKill = {
		F = 15, E = 30, D = 50, C = 80,
		B = 120, A = 180, S = 250, ["S+"] = 350,
		SS = 500, ["SS+"] = 700, G = 1000,
		["G+"] = 1500, GM = 2500, ["GM+"] = 4000
	}
}

-- 📈 PROGRESSÃO DE NÍVEL
GameConfig.Leveling = {
	BaseXPRequired = 100,
	XPScaling = 1.4,
	MaxLevel = 500,
	StatusPointsPerLevel = 3,
	ShadowSlotIncrease = {10, 25, 50, 100, 200, 350, 500} -- Níveis que desbloqueiam slots
}

-- ⚔️ COMBATE BASE
GameConfig.Combat = {
	PlayerBaseDamage = 25,
	PlayerBaseAttackSpeed = 1.2,
	PlayerBaseRange = 6,
	CritChance = 0.05, -- 5%
	CritMultiplier = 1.5,
	
	-- Cooldowns (segundos)
	BasicAttackCooldown = 0.8,
	ShadowAttackCooldown = 1.5,
	
	-- Hitbox
	HitboxRadius = 8,
	DebugMode = false
}

-- 🧞‍♂️ SISTEMA DE SOMBRAS
GameConfig.Shadows = {
	MaxActiveShadows = 1, -- Jogador pode ter apenas 1 sombra ativa por vez
	DefaultInventorySlots = 30,
	MaxInventorySlots = 100,
	
	-- Chance de captura por rank
	CaptureChance = {
		F = 0.90, E = 0.80, D = 0.65, C = 0.50,
		B = 0.35, A = 0.25, S = 0.18, ["S+"] = 0.12,
		SS = 0.08, ["SS+"] = 0.05, G = 0.04,
		["G+"] = 0.03, GM = 0.02, ["GM+"] = 0.01
	},
	
	MaxCaptureAttempts = 3,
	
	-- Custo de evolução (Gold)
	EvolutionCost = {
		F = 500, E = 1000, D = 2500, C = 5000,
		B = 10000, A = 20000, S = 40000, ["S+"] = 80000,
		SS = 150000, ["SS+"] = 300000, G = 600000,
		["G+"] = 1200000, GM = 2500000, ["GM+"] = 5000000
	},
	
	-- Fragmentos necessários para evolução
	FragmentsRequired = {
		F = 10, E = 15, D = 25, C = 40,
		B = 60, A = 90, S = 150, ["S+"] = 250,
		SS = 400, ["SS+"] = 650, G = 1000,
		["G+"] = 1500, GM = 2500, ["GM+"] = 4000
	}
}

-- 📊 PONTOS DE STATUS
GameConfig.StatusPoints = {
	Categories = {
		PlayerSpeed = { Name = "Velocidade do Jogador", MaxPoints = 100, IncreasePerPoint = 0.5 },
		PlayerDamage = { Name = "Dano do Jogador", MaxPoints = 100, IncreasePerPoint = 2 },
		ShadowSpeed = { Name = "Velocidade da Sombra", MaxPoints = 100, IncreasePerPoint = 0.3 },
		ShadowDamage = { Name = "Dano da Sombra", MaxPoints = 100, IncreasePerPoint = 3 },
		ShadowRange = { Name = "Range da Sombra", MaxPoints = 50, IncreasePerPoint = 0.5 }
	},
	ResetCostDiamonds = 500
}

-- 🏰 DUNGEONS
GameConfig.Dungeons = {
	MinLevel = 10,
	CooldownMinutes = 60,
	Difficulties = {
		Easy = { Name = "Fácil", Multiplier = 1.0, MinLevel = 10 },
		Medium = { Name = "Médio", Multiplier = 1.5, MinLevel = 25 },
		Hard = { Name = "Difícil", Multiplier = 2.0, MinLevel = 50 },
		Nightmare = { Name = "Pesadelo", Multiplier = 3.0, MinLevel = 100 },
		Hell = { Name = "Inferno", Multiplier = 5.0, MinLevel = 200 }
	}
}

-- 🏆 SISTEMA DE TÍTULOS
GameConfig.Titles = {
	-- Cada título dá buffs passivos
	{
		ID = "beginner",
		Name = "Novato",
		Description = "Bem-vindo ao mundo das sombras",
		UnlockCondition = { Type = "Level", Value = 1 },
		Buffs = { XPBoost = 0.05 }
	},
	{
		ID = "hunter",
		Name = "Caçador",
		Description = "Derrote 100 inimigos",
		UnlockCondition = { Type = "Kills", Value = 100 },
		Buffs = { DamageBoost = 0.10 }
	},
	{
		ID = "shadow_master",
		Name = "Mestre das Sombras",
		Description = "Capture 50 sombras",
		UnlockCondition = { Type = "ShadowsCaptured", Value = 50 },
		Buffs = { CaptureBoost = 0.15 }
	},
	{
		ID = "monarch",
		Name = "Monarca",
		Description = "Alcance nível 100",
		UnlockCondition = { Type = "Level", Value = 100 },
		Buffs = { AllStats = 0.20 }
	}
}

-- 👥 SISTEMA DE GUILDAS
GameConfig.Guilds = {
	CreationCostGold = 50000,
	MaxMembers = 50,
	MaxNameLength = 20,
	RankNames = {"Membro", "Veterano", "Oficial", "Vice-Líder", "Líder"}
}

-- 📋 MISSÕES
GameConfig.Missions = {
	Daily = {
		{ ID = "daily_kills", Name = "Derrotar 30 inimigos", Requirement = { Type = "Kills", Amount = 30 }, Rewards = { Gold = 1000, XP = 500 } },
		{ ID = "daily_dungeon", Name = "Completar 1 dungeon", Requirement = { Type = "Dungeons", Amount = 1 }, Rewards = { Gold = 2000, Diamonds = 10 } },
		{ ID = "daily_capture", Name = "Capturar 5 sombras", Requirement = { Type = "Captures", Amount = 5 }, Rewards = { Gold = 1500, XP = 800 } }
	},
	Weekly = {
		{ ID = "weekly_boss", Name = "Derrotar 10 bosses", Requirement = { Type = "BossKills", Amount = 10 }, Rewards = { Gold = 10000, Diamonds = 50, XP = 5000 } },
		{ ID = "weekly_level", Name = "Subir 5 níveis", Requirement = { Type = "LevelUps", Amount = 5 }, Rewards = { Gold = 15000, Diamonds = 100 } }
	}
}

-- 🎰 SORTEIOS E ROLETA
GameConfig.Raffle = {
	SpinCostGold = 1000,
	SpinCostDiamonds = 50,
	DailyFreeSpins = 3,
	
	Rewards = {
		{ Type = "Gold", Amount = 5000, Weight = 30, Rarity = "Comum" },
		{ Type = "Gold", Amount = 10000, Weight = 20, Rarity = "Comum" },
		{ Type = "Diamonds", Amount = 50, Weight = 15, Rarity = "Raro" },
		{ Type = "Diamonds", Amount = 100, Weight = 10, Rarity = "Raro" },
		{ Type = "XP", Amount = 5000, Weight = 20, Rarity = "Comum" },
		{ Type = "ShadowFragment", Amount = 50, Weight = 12, Rarity = "Épico" },
		{ Type = "Weapon", WeaponID = "legendary_sword", Weight = 2, Rarity = "Lendário" },
		{ Type = "Shadow", Rank = "S", Weight = 1, Rarity = "Lendário" }
	}
}

-- ⏰ TIMERS
GameConfig.Timers = {
	AutoSaveInterval = 300, -- 5 minutos
	DataUpdateInterval = 1, -- Atualizar UI a cada 1 segundo
	MissionResetDaily = 86400, -- 24 horas
	MissionResetWeekly = 604800 -- 7 dias
}

-- 🎨 RARIDADE E CORES
GameConfig.Rarity = {
	Comum = { Color = Color3.fromRGB(200, 200, 200), Glow = false },
	Incomum = { Color = Color3.fromRGB(100, 255, 100), Glow = false },
	Raro = { Color = Color3.fromRGB(100, 150, 255), Glow = true },
	Épico = { Color = Color3.fromRGB(200, 100, 255), Glow = true },
	Lendário = { Color = Color3.fromRGB(255, 200, 50), Glow = true },
	Mítico = { Color = Color3.fromRGB(255, 50, 50), Glow = true }
}

-- 🏷️ TAGS DE NPCs
GameConfig.Tags = {
	Enemy = "Enemy",
	Boss = "Boss",
	Dungeon = "DungeonMob",
	Event = "EventBoss"
}

-- 🐎 MONTARIAS
GameConfig.Mounts = {
	SpeedBoost = 1.5, -- 50% mais rápido
	UnlockLevel = 20
}

return GameConfig
