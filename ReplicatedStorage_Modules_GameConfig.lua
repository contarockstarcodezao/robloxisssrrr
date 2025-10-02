-- ReplicatedStorage/Modules/GameConfig
-- Cole este script como ModuleScript dentro de ReplicatedStorage/Modules/

local GameConfig = {}

-- ⚙️ CONFIGURAÇÕES GERAIS
GameConfig.Game = {
	Name = "Arise Crossover",
	Version = "1.0.0",
	MaxPlayers = 50,
	AutoSaveInterval = 300, -- 5 minutos
}

-- 🧞‍♂️ SISTEMA DE SOMBRAS
GameConfig.Shadows = {
	MaxSlots = 50, -- Slots iniciais
	SlotExpansionCost = 100, -- Diamantes por slot
	InvokeCooldown = 1, -- Segundos entre ataques da sombra
	CaptureDistance = 50, -- Distância máxima para captura
	
	-- Chances de captura por rank (%)
	CaptureChances = {
		F = 70,
		E = 60,
		D = 50,
		C = 40,
		B = 30,
		A = 20,
		S = 10,
		SS = 5,
		GM = 1,
	},
	
	-- Custo de evolução (cash, diamantes, fragmentos)
	EvolutionCosts = {
		F = {Cash = 500, Diamonds = 0, Fragments = 10},
		E = {Cash = 1000, Diamonds = 0, Fragments = 20},
		D = {Cash = 2500, Diamonds = 5, Fragments = 50},
		C = {Cash = 5000, Diamonds = 10, Fragments = 100},
		B = {Cash = 10000, Diamonds = 25, Fragments = 200},
		A = {Cash = 25000, Diamonds = 50, Fragments = 500},
		S = {Cash = 50000, Diamonds = 100, Fragments = 1000},
		SS = {Cash = 100000, Diamonds = 250, Fragments = 2500},
		GM = {Cash = 500000, Diamonds = 1000, Fragments = 10000},
	},
	
	-- Multiplicador de stats por evolução
	EvolutionMultiplier = 1.5,
}

-- ⚔️ SISTEMA DE COMBATE
GameConfig.Combat = {
	AttackCooldown = 0.8, -- Segundos entre ataques
	DetectionRange = 30, -- Alcance de detecção de inimigos
	
	-- Dados das armas
	Weapons = {
		Fist = {
			Name = "Soco",
			Damage = 10,
			Speed = 1.2,
			Range = 5,
			Animation = "rbxassetid://0", -- Substitua por ID real
		},
		Sword = {
			Name = "Espada",
			Damage = 15,
			Speed = 1.0,
			Range = 8,
			Animation = "rbxassetid://0", -- Substitua por ID real
		},
	},
}

-- 💰 SISTEMA DE DROPS
GameConfig.Drops = {
	-- Chance de drop por tipo (%)
	DropChances = {
		Cash = 100,
		Fragments = 40,
		Potion = 15,
		Shadow = 25,
		Weapon = 10,
		Relic = 5,
	},
	
	-- Valores de drop de cash por rank de NPC
	CashDrops = {
		F = {Min = 10, Max = 25},
		E = {Min = 25, Max = 50},
		D = {Min = 50, Max = 100},
		C = {Min = 100, Max = 200},
		B = {Min = 200, Max = 400},
		A = {Min = 400, Max = 800},
		S = {Min = 800, Max = 1600},
		SS = {Min = 1600, Max = 3200},
		GM = {Min = 5000, Max = 10000},
	},
	
	-- Auto coleta
	AutoCollectRange = 15,
	DropLifetime = 60, -- Segundos antes de desaparecer
}

-- 📈 SISTEMA DE XP E NÍVEL
GameConfig.Experience = {
	BaseXPRequired = 100,
	XPScaling = 1.15, -- Multiplicador por nível
	MaxLevel = 1000,
	
	-- XP ganho por rank de NPC
	XPRewards = {
		F = 10,
		E = 20,
		D = 40,
		C = 80,
		B = 160,
		A = 320,
		S = 640,
		SS = 1280,
		GM = 5000,
	},
	
	-- Bônus por level up
	LevelUpBonus = {
		Health = 10,
		Damage = 2,
		Speed = 0.1,
	},
}

-- 🧭 DUNGEONS E RAIDS
GameConfig.Dungeons = {
	EntryCooldown = 300, -- 5 minutos
	MaxDuration = 600, -- 10 minutos
	MinPlayers = 1,
	MaxPlayers = 4,
	
	-- Recompensas base
	Rewards = {
		Cash = {Min = 1000, Max = 5000},
		Diamonds = {Min = 10, Max = 50},
		Fragments = {Min = 100, Max = 500},
	},
}

GameConfig.Raids = {
	EntryCooldown = 3600, -- 1 hora
	MaxDuration = 1800, -- 30 minutos
	MinPlayers = 4,
	MaxPlayers = 10,
	
	-- Recompensas épicas
	Rewards = {
		Cash = {Min = 10000, Max = 50000},
		Diamonds = {Min = 100, Max = 500},
		Fragments = {Min = 1000, Max = 5000},
		GuaranteedShadow = true, -- Sempre dropa sombra rara
	},
}

-- 🧪 SISTEMA DE RANKING
GameConfig.Ranking = {
	UpdateInterval = 60, -- Atualiza a cada 1 minuto
	TopPlayersShown = 100,
	WeeklyResetDay = 1, -- Segunda-feira
	
	-- Pesos para cálculo de poder
	PowerWeights = {
		Level = 10,
		ShadowPower = 1,
		RaidWins = 50,
	},
}

-- 🎒 SISTEMA DE INVENTÁRIO
GameConfig.Inventory = {
	InitialSlots = {
		Weapons = 20,
		Shadows = 50,
		Relics = 30,
		Consumables = 100,
	},
	
	SlotExpansionCost = 50, -- Diamantes
	MaxSlotsPerCategory = 200,
}

-- ⚙️ SISTEMA DE ARMAS
GameConfig.WeaponSystem = {
	Rarities = {"Common", "Rare", "Epic", "Legendary", "Mythic"},
	
	-- Multiplicadores por raridade
	RarityMultipliers = {
		Common = 1.0,
		Rare = 1.5,
		Epic = 2.0,
		Legendary = 3.0,
		Mythic = 5.0,
	},
	
	-- Custo de melhoria
	UpgradeCosts = {
		Common = {Cash = 100, Diamonds = 0},
		Rare = {Cash = 500, Diamonds = 5},
		Epic = {Cash = 2000, Diamonds = 20},
		Legendary = {Cash = 10000, Diamonds = 100},
		Mythic = {Cash = 50000, Diamonds = 500},
	},
	
	MaxUpgradeLevel = 10,
}

-- 💎 ECONOMIA
GameConfig.Economy = {
	StartingCash = 1000,
	StartingDiamonds = 50,
	
	-- Preços da loja
	Shop = {
		FragmentsPack = {Price = 100, Amount = 1000, Currency = "Diamonds"},
		CashPack = {Price = 50, Amount = 10000, Currency = "Diamonds"},
		SlotExpansion = {Price = 100, Currency = "Diamonds"},
	},
	
	-- Taxas de venda (% do valor original)
	SellValuePercent = 50,
}

-- 🧿 SISTEMA DE RELÍQUIAS
GameConfig.Relics = {
	MaxEquipped = 3, -- Por jogador/sombra
	
	-- Tipos de bônus
	BonusTypes = {
		"Damage",
		"Health",
		"Speed",
		"CaptureRate",
		"DropRate",
		"XPBoost",
	},
	
	-- Valores de bônus por raridade (%)
	BonusValues = {
		Common = {Min = 5, Max = 10},
		Rare = {Min = 10, Max = 20},
		Epic = {Min = 20, Max = 35},
		Legendary = {Min = 35, Max = 50},
		Mythic = {Min = 50, Max = 100},
	},
	
	-- Custo de fusão
	FusionCost = {
		Cash = 5000,
		Diamonds = 25,
	},
}

-- 🎨 CORES POR RARIDADE
GameConfig.Colors = {
	Ranks = {
		F = Color3.fromRGB(128, 128, 128), -- Cinza
		E = Color3.fromRGB(255, 255, 255), -- Branco
		D = Color3.fromRGB(0, 255, 0), -- Verde
		C = Color3.fromRGB(0, 150, 255), -- Azul
		B = Color3.fromRGB(150, 0, 255), -- Roxo
		A = Color3.fromRGB(255, 165, 0), -- Laranja
		S = Color3.fromRGB(255, 0, 0), -- Vermelho
		SS = Color3.fromRGB(255, 215, 0), -- Dourado
		GM = Color3.fromRGB(255, 0, 255), -- Magenta
	},
	
	Rarities = {
		Common = Color3.fromRGB(200, 200, 200),
		Rare = Color3.fromRGB(0, 150, 255),
		Epic = Color3.fromRGB(150, 0, 255),
		Legendary = Color3.fromRGB(255, 165, 0),
		Mythic = Color3.fromRGB(255, 0, 255),
	},
}

return GameConfig
