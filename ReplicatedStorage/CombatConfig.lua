-- ReplicatedStorage/CombatConfig
-- Configurações centralizadas do sistema de combate

local CombatConfig = {}

-- Configurações de estilos de combate
CombatConfig.AttackStyles = {
	Punch = {
		Name = "Soco",
		Damage = 10,
		Range = 5,
		Cooldown = 0.5, -- segundos
		Animation = nil -- ID da animação (opcional)
	},
	Sword = {
		Name = "Espada",
		Damage = 25,
		Range = 7,
		Cooldown = 1.0, -- segundos
		Animation = nil -- ID da animação (opcional)
	}
}

-- Configurações de NPCs
CombatConfig.NPCSettings = {
	RespawnTime = 5, -- segundos para respawn
	DefaultHealth = 100,
	XPReward = 15,
	CoinsReward = 10
}

-- Configurações de hitbox
CombatConfig.HitboxSettings = {
	DebugMode = false, -- Visualizar hitbox (útil para debug)
	CheckInterval = 0.1 -- Intervalo de verificação
}

-- Tags para identificar NPCs
CombatConfig.NPCTag = "Enemy"

return CombatConfig
