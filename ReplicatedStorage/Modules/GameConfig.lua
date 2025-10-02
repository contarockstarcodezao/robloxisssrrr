-- ReplicatedStorage/Modules/GameConfig
-- Configurações centralizadas do jogo

local GameConfig = {}

-- 💰 ECONOMIA
GameConfig.Economy = {
	StartingCash = 1000,
	StartingDiamonds = 50,
}

-- 📈 EXPERIÊNCIA E LEVEL
GameConfig.Experience = {
	BaseXPRequired = 100,
	XPScaling = 1.5, -- Multiplicador por level
	MaxLevel = 100,
}

-- ⚔️ COMBATE
GameConfig.Combat = {
	AttackStyles = {
		Fist = {
			Name = "Soco",
			Damage = 15,
			Range = 5,
			Cooldown = 0.5,
			Animation = nil,
		},
		Sword = {
			Name = "Espada",
			Damage = 30,
			Range = 7,
			Cooldown = 1.0,
			Animation = nil,
		},
	},
	
	-- Configurações de NPCs
	NPCSettings = {
		RespawnTime = 5,
		DefaultHealth = 100,
		BaseXPReward = 25,
		BaseCashReward = 15,
		BossMultiplier = 5, -- Boss dá 5x mais recompensas
	},
	
	-- Sistema de hitbox
	HitboxSettings = {
		DebugMode = false,
		CheckInterval = 0.1,
	},
}

-- 🧞‍♂️ SOMBRAS
GameConfig.Shadows = {
	MaxSlots = 5,
	CaptureChance = 0.15, -- 15% de chance base
}

-- 🎒 INVENTÁRIO
GameConfig.Inventory = {
	InitialSlots = {
		Weapons = 20,
		Relics = 15,
		Consumables = 30,
	},
}

-- 🧿 RELÍQUIAS
GameConfig.Relics = {
	MaxEquipped = 3,
}

-- 🏆 CONQUISTAS
GameConfig.Achievements = {
	{
		ID = "first_kill",
		Name = "Primeira Vítima",
		Description = "Derrote seu primeiro inimigo",
		Icon = "🎯",
		Requirement = { Type = "Kills", Amount = 1 },
		Rewards = { Cash = 100, XP = 50 },
	},
	{
		ID = "warrior",
		Name = "Guerreiro",
		Description = "Derrote 50 inimigos",
		Icon = "⚔️",
		Requirement = { Type = "Kills", Amount = 50 },
		Rewards = { Cash = 500, XP = 250, Diamonds = 10 },
	},
	{
		ID = "legend",
		Name = "Lenda",
		Description = "Derrote 500 inimigos",
		Icon = "👑",
		Requirement = { Type = "Kills", Amount = 500 },
		Rewards = { Cash = 5000, XP = 2500, Diamonds = 100 },
	},
	{
		ID = "boss_hunter",
		Name = "Caçador de Chefes",
		Description = "Derrote 10 chefes",
		Icon = "💀",
		Requirement = { Type = "BossKills", Amount = 10 },
		Rewards = { Cash = 2000, XP = 1000, Diamonds = 50 },
	},
	{
		ID = "shadow_master",
		Name = "Mestre das Sombras",
		Description = "Capture 20 sombras",
		Icon = "🧞‍♂️",
		Requirement = { Type = "ShadowsCaptured", Amount = 20 },
		Rewards = { Cash = 3000, XP = 1500, Diamonds = 75 },
	},
	{
		ID = "level_10",
		Name = "Ascensão I",
		Description = "Alcance o nível 10",
		Icon = "⭐",
		Requirement = { Type = "Level", Amount = 10 },
		Rewards = { Cash = 1000, Diamonds = 25 },
	},
	{
		ID = "level_50",
		Name = "Ascensão II",
		Description = "Alcance o nível 50",
		Icon = "🌟",
		Requirement = { Type = "Level", Amount = 50 },
		Rewards = { Cash = 10000, Diamonds = 250 },
	},
	{
		ID = "veteran",
		Name = "Veterano",
		Description = "Jogue por 10 horas",
		Icon = "⏰",
		Requirement = { Type = "PlayTime", Amount = 36000 }, -- 10 horas em segundos
		Rewards = { Cash = 5000, XP = 2000, Diamonds = 100 },
	},
}

-- ⏰ TEMPO
GameConfig.Time = {
	AutoSaveInterval = 300, -- 5 minutos
	PlayTimeUpdateInterval = 60, -- Atualizar a cada 1 minuto
}

-- 🏷️ TAGS
GameConfig.Tags = {
	Enemy = "Enemy",
	Boss = "Boss",
}

return GameConfig
