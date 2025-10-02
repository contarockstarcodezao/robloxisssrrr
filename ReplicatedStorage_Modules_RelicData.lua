-- ReplicatedStorage/Modules/RelicData
-- Cole este script como ModuleScript dentro de ReplicatedStorage/Modules/

local RelicData = {}

-- 🧿 BANCO DE DADOS DE RELÍQUIAS
RelicData.Templates = {
	-- RELÍQUIAS COMUNS
	{
		ID = "RELIC_001",
		Name = "Anel de Força Menor",
		Rarity = "Common",
		BonusType = "Damage",
		BonusValue = 0.05, -- +5%
		Description = "Aumenta o dano em 5%",
		DropRate = 100,
	},
	
	{
		ID = "RELIC_002",
		Name = "Amuleto de Vida",
		Rarity = "Common",
		BonusType = "Health",
		BonusValue = 0.08, -- +8%
		Description = "Aumenta a vida máxima em 8%",
		DropRate = 100,
	},
	
	{
		ID = "RELIC_003",
		Name = "Botas Leves",
		Rarity = "Common",
		BonusType = "Speed",
		BonusValue = 0.10, -- +10%
		Description = "Aumenta a velocidade de movimento em 10%",
		DropRate = 100,
	},
	
	-- RELÍQUIAS RARAS
	{
		ID = "RELIC_004",
		Name = "Colar do Caçador",
		Rarity = "Rare",
		BonusType = "CaptureRate",
		BonusValue = 0.15, -- +15%
		Description = "Aumenta a chance de capturar sombras em 15%",
		DropRate = 50,
	},
	
	{
		ID = "RELIC_005",
		Name = "Anel da Sorte",
		Rarity = "Rare",
		BonusType = "DropRate",
		BonusValue = 0.20, -- +20%
		Description = "Aumenta a chance de drop de itens em 20%",
		DropRate = 50,
	},
	
	{
		ID = "RELIC_006",
		Name = "Medalha do Sábio",
		Rarity = "Rare",
		BonusType = "XPBoost",
		BonusValue = 0.25, -- +25%
		Description = "Aumenta o ganho de XP em 25%",
		DropRate = 50,
	},
	
	{
		ID = "RELIC_007",
		Name = "Braceletes de Poder",
		Rarity = "Rare",
		BonusType = "Damage",
		BonusValue = 0.15, -- +15%
		Description = "Aumenta o dano em 15%",
		DropRate = 45,
	},
	
	-- RELÍQUIAS ÉPICAS
	{
		ID = "RELIC_008",
		Name = "Coroa do Dominador",
		Rarity = "Epic",
		BonusType = "Damage",
		BonusValue = 0.30, -- +30%
		Description = "Aumenta o dano em 30%",
		DropRate = 20,
	},
	
	{
		ID = "RELIC_009",
		Name = "Armadura Etérea",
		Rarity = "Epic",
		BonusType = "Health",
		BonusValue = 0.35, -- +35%
		Description = "Aumenta a vida máxima em 35%",
		DropRate = 20,
	},
	
	{
		ID = "RELIC_010",
		Name = "Asas de Mercúrio",
		Rarity = "Epic",
		BonusType = "Speed",
		BonusValue = 0.30, -- +30%
		Description = "Aumenta a velocidade de movimento em 30%",
		DropRate = 20,
	},
	
	{
		ID = "RELIC_011",
		Name = "Orbe do Colecionador",
		Rarity = "Epic",
		BonusType = "CaptureRate",
		BonusValue = 0.35, -- +35%
		Description = "Aumenta a chance de capturar sombras em 35%",
		DropRate = 18,
	},
	
	{
		ID = "RELIC_012",
		Name = "Talismã da Fortuna",
		Rarity = "Epic",
		BonusType = "DropRate",
		BonusValue = 0.40, -- +40%
		Description = "Aumenta a chance de drop de itens em 40%",
		DropRate = 18,
	},
	
	-- RELÍQUIAS LENDÁRIAS
	{
		ID = "RELIC_013",
		Name = "Coração do Dragão",
		Rarity = "Legendary",
		BonusType = "MultiBonus",
		BonusValues = {
			Damage = 0.40,
			Health = 0.40,
		},
		Description = "Aumenta dano e vida em 40%",
		DropRate = 5,
	},
	
	{
		ID = "RELIC_014",
		Name = "Elmo do Conquistador",
		Rarity = "Legendary",
		BonusType = "MultiBonus",
		BonusValues = {
			Damage = 0.35,
			CaptureRate = 0.35,
			XPBoost = 0.35,
		},
		Description = "Aumenta dano, captura e XP em 35%",
		DropRate = 5,
	},
	
	{
		ID = "RELIC_015",
		Name = "Manto das Sombras",
		Rarity = "Legendary",
		BonusType = "MultiBonus",
		BonusValues = {
			Speed = 0.45,
			DropRate = 0.45,
		},
		Description = "Aumenta velocidade e drop rate em 45%",
		DropRate = 5,
	},
	
	{
		ID = "RELIC_016",
		Name = "Cetro do Mestre das Sombras",
		Rarity = "Legendary",
		BonusType = "ShadowPower",
		BonusValue = 0.50, -- +50% em todas stats das sombras
		Description = "Aumenta todos atributos das sombras invocadas em 50%",
		DropRate = 4,
	},
	
	-- RELÍQUIAS MÍTICAS
	{
		ID = "RELIC_017",
		Name = "Coroa do Rei das Sombras",
		Rarity = "Mythic",
		BonusType = "MultiBonus",
		BonusValues = {
			Damage = 0.70,
			Health = 0.70,
			Speed = 0.70,
			CaptureRate = 0.70,
		},
		Description = "Aumenta dano, vida, velocidade e captura em 70%",
		DropRate = 1,
	},
	
	{
		ID = "RELIC_018",
		Name = "Olho de Horus Sombrio",
		Rarity = "Mythic",
		BonusType = "MultiBonus",
		BonusValues = {
			DropRate = 1.0, -- +100%
			XPBoost = 1.0, -- +100%
			CaptureRate = 0.80, -- +80%
		},
		Description = "Dobra ganho de XP e drops, +80% captura",
		DropRate = 1,
	},
	
	{
		ID = "RELIC_019",
		Name = "Alma do Imperador",
		Rarity = "Mythic",
		BonusType = "Ultimate",
		BonusValues = {
			Damage = 1.0, -- +100%
			Health = 1.0,
			Speed = 0.80,
			ShadowPower = 1.0, -- +100% em sombras
		},
		Description = "Poder supremo: dobra dano, vida e poder das sombras, +80% velocidade",
		DropRate = 1,
	},
	
	{
		ID = "RELIC_020",
		Name = "Fragmento da Criação",
		Rarity = "Mythic",
		BonusType = "AllBonus",
		BonusValue = 0.50, -- +50% em TUDO
		Description = "Aumenta TODOS os atributos e taxas em 50%",
		DropRate = 1,
	},
}

-- 🎯 FUNÇÕES AUXILIARES

-- Obter relíquia por ID
function RelicData:GetRelicByID(id)
	for _, relic in ipairs(self.Templates) do
		if relic.ID == id then
			return relic
		end
	end
	return nil
end

-- Obter relíquias por raridade
function RelicData:GetRelicsByRarity(rarity)
	local relics = {}
	for _, relic in ipairs(self.Templates) do
		if relic.Rarity == rarity then
			table.insert(relics, relic)
		end
	end
	return relics
end

-- Obter relíquias por tipo de bônus
function RelicData:GetRelicsByBonusType(bonusType)
	local relics = {}
	for _, relic in ipairs(self.Templates) do
		if relic.BonusType == bonusType then
			table.insert(relics, relic)
		end
	end
	return relics
end

-- Obter relíquia aleatória ponderada
function RelicData:GetRandomRelic()
	local totalWeight = 0
	for _, relic in ipairs(self.Templates) do
		totalWeight = totalWeight + relic.DropRate
	end
	
	local random = math.random() * totalWeight
	local currentWeight = 0
	
	for _, relic in ipairs(self.Templates) do
		currentWeight = currentWeight + relic.DropRate
		if random <= currentWeight then
			return relic
		end
	end
	
	return self.Templates[1] -- Fallback
end

-- Criar instância de relíquia
function RelicData:CreateRelicInstance(relicID, level)
	level = level or 1
	local template = self:GetRelicByID(relicID)
	
	if not template then
		return nil
	end
	
	local instance = {
		ID = relicID,
		Name = template.Name,
		Rarity = template.Rarity,
		BonusType = template.BonusType,
		Level = level,
		Description = template.Description,
		AcquiredAt = os.time(),
	}
	
	-- Calcular bônus com nível
	if template.BonusType == "MultiBonus" or template.BonusType == "Ultimate" or template.BonusType == "AllBonus" then
		instance.BonusValues = {}
		for key, value in pairs(template.BonusValues or {BonusValue = template.BonusValue}) do
			instance.BonusValues[key] = value * (1 + (level - 1) * 0.1) -- +10% por nível
		end
	else
		instance.BonusValue = template.BonusValue * (1 + (level - 1) * 0.1)
	end
	
	return instance
end

-- Calcular custo de fusão (2 relíquias = 1 de nível maior)
function RelicData:GetFusionCost()
	local GameConfig = require(script.Parent.GameConfig)
	return GameConfig.Relics.FusionCost
end

-- Fundir duas relíquias (mesma ID e raridade)
function RelicData:FuseRelics(relic1, relic2)
	if relic1.ID ~= relic2.ID then
		return nil, "Relíquias devem ser do mesmo tipo"
	end
	
	if relic1.Rarity ~= relic2.Rarity then
		return nil, "Relíquias devem ter a mesma raridade"
	end
	
	local newLevel = math.max(relic1.Level, relic2.Level) + 1
	
	return self:CreateRelicInstance(relic1.ID, newLevel)
end

-- Calcular bônus total de múltiplas relíquias equipadas
function RelicData:CalculateTotalBonus(equippedRelics)
	local totalBonus = {
		Damage = 0,
		Health = 0,
		Speed = 0,
		CaptureRate = 0,
		DropRate = 0,
		XPBoost = 0,
		ShadowPower = 0,
	}
	
	for _, relicInstance in ipairs(equippedRelics) do
		local template = self:GetRelicByID(relicInstance.ID)
		
		if template then
			if template.BonusType == "MultiBonus" or template.BonusType == "Ultimate" then
				for key, value in pairs(relicInstance.BonusValues) do
					totalBonus[key] = totalBonus[key] + value
				end
			elseif template.BonusType == "AllBonus" then
				local value = relicInstance.BonusValue
				for key in pairs(totalBonus) do
					totalBonus[key] = totalBonus[key] + value
				end
			else
				totalBonus[template.BonusType] = totalBonus[template.BonusType] + relicInstance.BonusValue
			end
		end
	end
	
	return totalBonus
end

-- Calcular poder de uma relíquia
function RelicData:CalculatePower(relicInstance)
	local rarityMultipliers = {
		Common = 1,
		Rare = 3,
		Epic = 10,
		Legendary = 30,
		Mythic = 100,
	}
	
	local basePower = rarityMultipliers[relicInstance.Rarity] or 1
	return basePower * relicInstance.Level
end

return RelicData
