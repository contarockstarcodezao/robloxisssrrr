-- ReplicatedStorage/Modules/RelicData
-- Sistema de relíquias com buffs passivos

local RelicData = {}

RelicData.Relics = {
	{
		ID = "xp_amulet",
		Name = "Amuleto de XP",
		Description = "+30% XP ganho",
		Rarity = "Raro",
		Buffs = { XPBoost = 0.30 }
	},
	{
		ID = "gold_talisman",
		Name = "Talismã Dourado",
		Description = "+25% Gold ganho",
		Rarity = "Raro",
		Buffs = { GoldBoost = 0.25 }
	},
	{
		ID = "damage_ring",
		Name = "Anel do Destruidor",
		Description = "+20% Dano total",
		Rarity = "Épico",
		Buffs = { DamageBoost = 0.20 }
	},
	{
		ID = "speed_boots",
		Name = "Botas da Velocidade",
		Description = "+35% Velocidade de movimento",
		Rarity = "Épico",
		Buffs = { SpeedBoost = 0.35 }
	},
	{
		ID = "capture_orb",
		Name = "Orbe de Captura",
		Description = "+20% Chance de captura",
		Rarity = "Lendário",
		Buffs = { CaptureBoost = 0.20 }
	},
	{
		ID = "god_relic",
		Name = "Relíquia Divina",
		Description = "+50% todos os atributos",
		Rarity = "Mítico",
		Buffs = { AllStats = 0.50 }
	}
}

function RelicData:GetRelicByID(relicID)
	for _, relic in ipairs(self.Relics) do
		if relic.ID == relicID then
			return relic
		end
	end
	return nil
end

function RelicData:CalculateTotalBuffs(equippedRelics)
	local totalBuffs = {
		XPBoost = 0,
		GoldBoost = 0,
		DamageBoost = 0,
		SpeedBoost = 0,
		CaptureBoost = 0,
		AllStats = 0
	}
	
	for _, relicID in ipairs(equippedRelics) do
		local relic = self:GetRelicByID(relicID)
		if relic then
			for buffType, value in pairs(relic.Buffs) do
				if totalBuffs[buffType] then
					totalBuffs[buffType] = totalBuffs[buffType] + value
				end
			end
		end
	end
	
	return totalBuffs
end

return RelicData
