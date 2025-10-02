-- ReplicatedStorage/Modules/UtilityFunctions
-- Funções auxiliares compartilhadas

local UtilityFunctions = {}

-- 📊 CALCULAR XP NECESSÁRIO PARA PRÓXIMO NÍVEL
function UtilityFunctions:CalculateXPRequired(level, baseXP, scaling)
	return math.floor(baseXP * (scaling ^ (level - 1)))
end

-- 🕐 FORMATAR TEMPO (segundos para HH:MM:SS)
function UtilityFunctions:FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- 🔢 FORMATAR NÚMERO (1000 -> 1K, 1000000 -> 1M)
function UtilityFunctions:FormatNumber(number)
	if number >= 1000000000 then
		return string.format("%.2fB", number / 1000000000)
	elseif number >= 1000000 then
		return string.format("%.2fM", number / 1000000)
	elseif number >= 1000 then
		return string.format("%.2fK", number / 1000)
	end
	return tostring(number)
end

-- 📏 CALCULAR DISTÂNCIA 3D
function UtilityFunctions:GetDistance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

-- 🎲 CHANCE ALEATÓRIA (0 a 1)
function UtilityFunctions:RandomChance(chance)
	return math.random() <= chance
end

-- 🎨 INTERPOLAR COR
function UtilityFunctions:LerpColor(color1, color2, alpha)
	return Color3.new(
		color1.R + (color2.R - color1.R) * alpha,
		color1.G + (color2.G - color1.G) * alpha,
		color1.B + (color2.B - color1.B) * alpha
	)
end

-- 🎯 DEEP COPY DE TABELA
function UtilityFunctions:DeepCopy(original)
	local copy
	if type(original) == 'table' then
		copy = {}
		for key, value in next, original, nil do
			copy[self:DeepCopy(key)] = self:DeepCopy(value)
		end
	else
		copy = original
	end
	return copy
end

-- ✨ CRIAR EFEITO DE HIT
function UtilityFunctions:CreateHitEffect(position, color)
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(2, 2, 2)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = color or Color3.fromRGB(255, 0, 0)
	part.Transparency = 0.3
	part.Parent = workspace.Effects or workspace
	
	task.spawn(function()
		for i = 1, 10 do
			part.Size = part.Size + Vector3.new(0.5, 0.5, 0.5)
			part.Transparency = part.Transparency + 0.07
			task.wait(0.03)
		end
		part:Destroy()
	end)
end

-- 🌟 CRIAR AURA POR RANK
function UtilityFunctions:CreateAura(parent, rank, color)
	local ShadowData = require(game.ReplicatedStorage.Modules.ShadowData)
	local auraColor = color or ShadowData:GetAuraColor(rank)
	
	-- Partículas de aura
	local attachment = Instance.new("Attachment")
	attachment.Parent = parent
	
	local particles = Instance.new("ParticleEmitter")
	particles.Color = ColorSequence.new(auraColor)
	particles.Size = NumberSequence.new(2, 0)
	particles.Transparency = NumberSequence.new(0.5, 1)
	particles.Lifetime = NumberRange.new(1, 2)
	particles.Rate = 20
	particles.Speed = NumberRange.new(2, 4)
	particles.Parent = attachment
	
	return particles
end

-- 📊 CALCULAR PORCENTAGEM
function UtilityFunctions:CalculatePercentage(current, max)
	if max == 0 then return 0 end
	return math.clamp((current / max) * 100, 0, 100)
end

-- 🎰 WEIGHTED RANDOM (para sistema de sorteio)
function UtilityFunctions:WeightedRandom(items, weightKey)
	local totalWeight = 0
	for _, item in ipairs(items) do
		totalWeight = totalWeight + (item[weightKey] or 1)
	end
	
	local random = math.random() * totalWeight
	local cumulativeWeight = 0
	
	for _, item in ipairs(items) do
		cumulativeWeight = cumulativeWeight + (item[weightKey] or 1)
		if random <= cumulativeWeight then
			return item
		end
	end
	
	return items[1] -- Fallback
end

return UtilityFunctions
