-- ReplicatedStorage/Modules/UtilityFunctions
-- Cole este script como ModuleScript dentro de ReplicatedStorage/Modules/

local UtilityFunctions = {}

-- 🔧 FUNÇÕES MATEMÁTICAS

-- Formatar números grandes (ex: 1000000 -> 1M)
function UtilityFunctions:FormatNumber(number)
	if number >= 1000000000 then
		return string.format("%.2fB", number / 1000000000)
	elseif number >= 1000000 then
		return string.format("%.2fM", number / 1000000)
	elseif number >= 1000 then
		return string.format("%.2fK", number / 1000)
	else
		return tostring(math.floor(number))
	end
end

-- Calcular XP necessário para próximo nível
function UtilityFunctions:CalculateXPRequired(level, baseXP, scaling)
	return math.floor(baseXP * (scaling ^ (level - 1)))
end

-- Gerar número aleatório com seed
function UtilityFunctions:SeededRandom(seed, min, max)
	math.randomseed(seed)
	return math.random(min, max)
end

-- Verificar chance (0-1)
function UtilityFunctions:RollChance(chance)
	return math.random() <= chance
end

-- Interpolar entre dois valores
function UtilityFunctions:Lerp(a, b, t)
	return a + (b - a) * t
end

-- 🎨 FUNÇÕES DE UI

-- Criar cor gradiente entre duas cores
function UtilityFunctions:ColorGradient(color1, color2, t)
	return Color3.new(
		self:Lerp(color1.R, color2.R, t),
		self:Lerp(color1.G, color2.G, t),
		self:Lerp(color1.B, color2.B, t)
	)
end

-- Obter cor por raridade
function UtilityFunctions:GetRarityColor(rarity)
	local GameConfig = require(script.Parent.GameConfig)
	return GameConfig.Colors.Rarities[rarity] or Color3.fromRGB(255, 255, 255)
end

-- Obter cor por rank
function UtilityFunctions:GetRankColor(rank)
	local GameConfig = require(script.Parent.GameConfig)
	return GameConfig.Colors.Ranks[rank] or Color3.fromRGB(255, 255, 255)
end

-- Criar efeito de partículas
function UtilityFunctions:CreateParticleEffect(parent, color, size, lifetime)
	local particle = Instance.new("ParticleEmitter")
	particle.Parent = parent
	particle.Color = ColorSequence.new(color)
	particle.Size = NumberSequence.new(size or 1)
	particle.Lifetime = NumberRange.new(lifetime or 1)
	particle.Rate = 20
	particle.Speed = NumberRange.new(5, 10)
	particle.SpreadAngle = Vector2.new(180, 180)
	return particle
end

-- 🎯 FUNÇÕES DE COMBATE

-- Calcular dano com crítico
function UtilityFunctions:CalculateDamage(baseDamage, critChance, critMultiplier)
	if self:RollChance(critChance) then
		return baseDamage * critMultiplier, true -- Retorna dano e se foi crítico
	end
	return baseDamage, false
end

-- Encontrar inimigos em raio
function UtilityFunctions:FindEnemiesInRadius(position, radius, ignoreList)
	ignoreList = ignoreList or {}
	local enemies = {}
	
	local region = Region3.new(
		position - Vector3.new(radius, radius, radius),
		position + Vector3.new(radius, radius, radius)
	)
	region = region:ExpandToGrid(4)
	
	local parts = workspace:FindPartsInRegion3(region, nil, 100)
	
	for _, part in ipairs(parts) do
		local humanoid = part.Parent:FindFirstChild("Humanoid")
		if humanoid and humanoid.Health > 0 then
			local enemy = part.Parent
			if not table.find(ignoreList, enemy) then
				local distance = (enemy.PrimaryPart.Position - position).Magnitude
				if distance <= radius then
					table.insert(enemies, {Enemy = enemy, Distance = distance})
				end
			end
		end
	end
	
	-- Ordenar por distância
	table.sort(enemies, function(a, b)
		return a.Distance < b.Distance
	end)
	
	return enemies
end

-- Aplicar dano a um inimigo
function UtilityFunctions:ApplyDamage(enemy, damage, damageType)
	local humanoid = enemy:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health > 0 then
		humanoid:TakeDamage(damage)
		
		-- Criar indicador de dano
		self:CreateDamageIndicator(enemy.PrimaryPart.Position, damage, damageType)
		
		return true
	end
	return false
end

-- Criar indicador visual de dano
function UtilityFunctions:CreateDamageIndicator(position, damage, damageType)
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = workspace
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "-" .. self:FormatNumber(damage)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = billboard
	
	-- Cor baseada no tipo de dano
	if damageType == "Critical" then
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 0) -- Amarelo
	elseif damageType == "Normal" then
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Branco
	else
		textLabel.TextColor3 = Color3.fromRGB(255, 100, 100) -- Vermelho
	end
	
	-- Animação
	local attachment = Instance.new("Attachment")
	attachment.Position = position
	attachment.Parent = workspace.Terrain
	billboard.Adornee = attachment
	
	task.spawn(function()
		for i = 1, 20 do
			billboard.StudsOffset = billboard.StudsOffset + Vector3.new(0, 0.1, 0)
			textLabel.TextTransparency = i / 20
			task.wait(0.05)
		end
		billboard:Destroy()
		attachment:Destroy()
	end)
end

-- 📦 FUNÇÕES DE INVENTÁRIO

-- Verificar se inventário tem espaço
function UtilityFunctions:HasInventorySpace(inventory, category)
	local maxSlots = inventory.MaxSlots[category] or 0
	local currentItems = #inventory[category] or 0
	return currentItems < maxSlots
end

-- Adicionar item ao inventário
function UtilityFunctions:AddToInventory(inventory, category, item)
	if self:HasInventorySpace(inventory, category) then
		table.insert(inventory[category], item)
		return true
	end
	return false
end

-- Remover item do inventário
function UtilityFunctions:RemoveFromInventory(inventory, category, itemID)
	for i, item in ipairs(inventory[category]) do
		if item.ID == itemID then
			table.remove(inventory[category], i)
			return true
		end
	end
	return false
end

-- Ordenar inventário por critério
function UtilityFunctions:SortInventory(items, sortBy)
	if sortBy == "Name" then
		table.sort(items, function(a, b) return a.Name < b.Name end)
	elseif sortBy == "Rarity" then
		local rarityOrder = {Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythic = 5}
		table.sort(items, function(a, b)
			return (rarityOrder[a.Rarity] or 0) > (rarityOrder[b.Rarity] or 0)
		end)
	elseif sortBy == "Level" then
		table.sort(items, function(a, b)
			return (a.Level or a.EvolutionLevel or 0) > (b.Level or b.EvolutionLevel or 0)
		end)
	elseif sortBy == "Power" then
		table.sort(items, function(a, b)
			return (a.Power or 0) > (b.Power or 0)
		end)
	end
	return items
end

-- 🔄 FUNÇÕES DE CONVERSÃO

-- Converter segundos em formato legível
function UtilityFunctions:FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	
	if hours > 0 then
		return string.format("%02d:%02d:%02d", hours, minutes, secs)
	else
		return string.format("%02d:%02d", minutes, secs)
	end
end

-- Converter timestamp em data
function UtilityFunctions:FormatDate(timestamp)
	return os.date("%d/%m/%Y %H:%M", timestamp)
end

-- 🎲 FUNÇÕES DE DROP

-- Calcular drop baseado em chance
function UtilityFunctions:CalculateDrop(dropChance, dropTable)
	if not self:RollChance(dropChance / 100) then
		return nil
	end
	
	-- Selecionar item aleatório da tabela de drops
	local totalWeight = 0
	for _, drop in ipairs(dropTable) do
		totalWeight = totalWeight + (drop.Weight or 1)
	end
	
	local random = math.random() * totalWeight
	local currentWeight = 0
	
	for _, drop in ipairs(dropTable) do
		currentWeight = currentWeight + (drop.Weight or 1)
		if random <= currentWeight then
			return drop
		end
	end
	
	return dropTable[1] -- Fallback
end

-- 🌟 FUNÇÕES DE RANKING

-- Calcular poder total do jogador
function UtilityFunctions:CalculatePlayerPower(playerData)
	local GameConfig = require(script.Parent.GameConfig)
	local weights = GameConfig.Ranking.PowerWeights
	
	local power = 0
	power = power + (playerData.Level or 0) * weights.Level
	power = power + (playerData.ShadowPower or 0) * weights.ShadowPower
	power = power + (playerData.RaidWins or 0) * weights.RaidWins
	
	return power
end

-- Ordenar ranking
function UtilityFunctions:SortRanking(rankings)
	table.sort(rankings, function(a, b)
		return a.Power > b.Power
	end)
	return rankings
end

-- 🔐 FUNÇÕES DE VALIDAÇÃO

-- Validar compra
function UtilityFunctions:ValidatePurchase(playerData, cost)
	if cost.Cash and playerData.Cash < cost.Cash then
		return false, "Cash insuficiente"
	end
	
	if cost.Diamonds and playerData.Diamonds < cost.Diamonds then
		return false, "Diamantes insuficientes"
	end
	
	if cost.Fragments and playerData.Fragments < cost.Fragments then
		return false, "Fragmentos insuficientes"
	end
	
	return true, "OK"
end

-- Deduzir recursos
function UtilityFunctions:DeductResources(playerData, cost)
	if cost.Cash then
		playerData.Cash = playerData.Cash - cost.Cash
	end
	
	if cost.Diamonds then
		playerData.Diamonds = playerData.Diamonds - cost.Diamonds
	end
	
	if cost.Fragments then
		playerData.Fragments = playerData.Fragments - cost.Fragments
	end
end

-- 📊 FUNÇÕES DE DADOS

-- Deep copy de tabela
function UtilityFunctions:DeepCopy(original)
	local copy
	if type(original) == "table" then
		copy = {}
		for key, value in pairs(original) do
			copy[self:DeepCopy(key)] = self:DeepCopy(value)
		end
	else
		copy = original
	end
	return copy
end

-- Mesclar tabelas
function UtilityFunctions:MergeTables(t1, t2)
	local result = self:DeepCopy(t1)
	for key, value in pairs(t2) do
		result[key] = value
	end
	return result
end

return UtilityFunctions
