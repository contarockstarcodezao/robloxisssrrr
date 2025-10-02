-- ReplicatedStorage/Modules/UtilityFunctions
-- Funções utilitárias compartilhadas

local UtilityFunctions = {}

-- 📊 CALCULAR XP NECESSÁRIO PARA PRÓXIMO LEVEL
function UtilityFunctions:CalculateXPRequired(level, baseXP, scaling)
	return math.floor(baseXP * (scaling ^ (level - 1)))
end

-- 🕐 FORMATAR TEMPO (segundos para "00:00:00")
function UtilityFunctions:FormatTime(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	
	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end

-- 🔢 FORMATAR NÚMERO (1000 -> 1,000 ou 1K)
function UtilityFunctions:FormatNumber(number, useAbbreviation)
	if useAbbreviation then
		if number >= 1000000000 then
			return string.format("%.1fB", number / 1000000000)
		elseif number >= 1000000 then
			return string.format("%.1fM", number / 1000000)
		elseif number >= 1000 then
			return string.format("%.1fK", number / 1000)
		end
	else
		-- Adiciona vírgulas
		local formatted = tostring(number)
		local k
		while true do
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
			if k == 0 then break end
		end
		return formatted
	end
	
	return tostring(number)
end

-- 📊 CALCULAR PORCENTAGEM DE PROGRESSO
function UtilityFunctions:CalculateProgress(current, max)
	if max == 0 then return 0 end
	return math.clamp((current / max) * 100, 0, 100)
end

-- 🎲 CHANCE ALEATÓRIA
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

-- 📏 DISTÂNCIA 3D
function UtilityFunctions:GetDistance(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

-- 🎯 CLONAR TABELA (deep copy)
function UtilityFunctions:DeepCopy(original)
	local copy
	if type(original) == 'table' then
		copy = {}
		for key, value in next, original, nil do
			copy[UtilityFunctions:DeepCopy(key)] = UtilityFunctions:DeepCopy(value)
		end
		setmetatable(copy, UtilityFunctions:DeepCopy(getmetatable(original)))
	else
		copy = original
	end
	return copy
end

-- 🔍 ENCONTRAR ITEM NA TABELA
function UtilityFunctions:FindInTable(tbl, predicate)
	for i, v in ipairs(tbl) do
		if predicate(v, i) then
			return v, i
		end
	end
	return nil, nil
end

-- ✨ CRIAR EFEITO DE PARTÍCULA
function UtilityFunctions:CreateHitEffect(position, color)
	local part = Instance.new("Part")
	part.Shape = Enum.PartType.Ball
	part.Size = Vector3.new(1, 1, 1)
	part.Position = position
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = color or Color3.fromRGB(255, 0, 0)
	part.Transparency = 0.3
	part.Parent = workspace.Effects or workspace
	
	-- Animação de expansão e fade
	task.spawn(function()
		for i = 1, 10 do
			part.Size = part.Size + Vector3.new(0.3, 0.3, 0.3)
			part.Transparency = part.Transparency + 0.07
			task.wait(0.03)
		end
		part:Destroy()
	end)
	
	return part
end

-- 🎵 TOCAR SOM
function UtilityFunctions:PlaySound(soundId, parent, volume, pitch)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. soundId
	sound.Volume = volume or 0.5
	sound.PlaybackSpeed = pitch or 1
	sound.Parent = parent or workspace
	sound:Play()
	
	game:GetService("Debris"):AddItem(sound, 3)
	return sound
end

return UtilityFunctions
