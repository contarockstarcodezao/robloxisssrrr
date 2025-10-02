-- ReplicatedStorage/Modules/RelicData
-- Sistema de relíquias e seus bônus

local RelicData = {}

-- 🧿 TIPOS DE RELÍQUIAS DISPONÍVEIS
RelicData.Relics = {
	{
		ID = "xp_boost_1",
		Name = "Amuleto da Sabedoria",
		Description = "+25% XP",
		Rarity = "Comum",
		Icon = "📘",
		Bonuses = { XPBoost = 0.25 },
	},
	{
		ID = "cash_boost_1",
		Name = "Talismã da Fortuna",
		Description = "+20% Cash",
		Rarity = "Comum",
		Icon = "💰",
		Bonuses = { CashBoost = 0.20 },
	},
	{
		ID = "damage_boost_1",
		Name = "Anel do Poder",
		Description = "+15% Dano",
		Rarity = "Raro",
		Icon = "💍",
		Bonuses = { DamageBoost = 0.15 },
	},
	{
		ID = "health_boost_1",
		Name = "Colar da Vitalidade",
		Description = "+50 HP",
		Rarity = "Raro",
		Icon = "❤️",
		Bonuses = { HealthBoost = 50 },
	},
	{
		ID = "shadow_chance_1",
		Name = "Orbe Sombrio",
		Description = "+10% Chance de Captura",
		Rarity = "Épico",
		Icon = "🔮",
		Bonuses = { ShadowCaptureBoost = 0.10 },
	},
}

-- 🎨 CORES POR RARIDADE
RelicData.RarityColors = {
	Comum = Color3.fromRGB(200, 200, 200),
	Incomum = Color3.fromRGB(100, 255, 100),
	Raro = Color3.fromRGB(100, 150, 255),
	Épico = Color3.fromRGB(200, 100, 255),
	Lendário = Color3.fromRGB(255, 200, 50),
}

-- 📊 OBTER RELÍQUIA POR ID
function RelicData:GetRelicByID(relicID)
	for _, relic in ipairs(self.Relics) do
		if relic.ID == relicID then
			return relic
		end
	end
	return nil
end

-- 🧮 CALCULAR BÔNUS TOTAL DAS RELÍQUIAS EQUIPADAS
function RelicData:CalculateTotalBonus(equippedRelics)
	local totalBonus = {
		XPBoost = 0,
		CashBoost = 0,
		DamageBoost = 0,
		HealthBoost = 0,
		ShadowCaptureBoost = 0,
	}
	
	for _, relicID in ipairs(equippedRelics) do
		local relic = self:GetRelicByID(relicID)
		if relic then
			for bonusType, value in pairs(relic.Bonuses) do
				totalBonus[bonusType] = totalBonus[bonusType] + value
			end
		end
	end
	
	return totalBonus
end

-- 📝 OBTER DESCRIÇÃO DE BÔNUS
function RelicData:GetBonusDescription(bonuses)
	local descriptions = {}
	
	if bonuses.XPBoost > 0 then
		table.insert(descriptions, string.format("+%.0f%% XP", bonuses.XPBoost * 100))
	end
	if bonuses.CashBoost > 0 then
		table.insert(descriptions, string.format("+%.0f%% Cash", bonuses.CashBoost * 100))
	end
	if bonuses.DamageBoost > 0 then
		table.insert(descriptions, string.format("+%.0f%% Dano", bonuses.DamageBoost * 100))
	end
	if bonuses.HealthBoost > 0 then
		table.insert(descriptions, string.format("+%.0f HP", bonuses.HealthBoost))
	end
	if bonuses.ShadowCaptureBoost > 0 then
		table.insert(descriptions, string.format("+%.0f%% Captura", bonuses.ShadowCaptureBoost * 100))
	end
	
	return table.concat(descriptions, ", ")
end

return RelicData
