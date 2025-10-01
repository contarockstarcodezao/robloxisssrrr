-- ServerScriptService/Systems/XPSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local DataManager = require(ServerScriptService.Core.DataManager)

local XPSystem = {}

-- 📈 DAR XP AO JOGADOR
function XPSystem:GiveXP(player, npcRank)
	local xpAmount = GameConfig.Experience.XPRewards[npcRank] or 10
	
	local success, leveledUp, newLevel = DataManager:AddXP(player, xpAmount)
	
	if success and leveledUp then
		self:OnLevelUp(player, newLevel)
	end
	
	-- Notificar cliente
	local InventoryEvent = ReplicatedStorage.Events.InventoryEvent
	InventoryEvent:FireClient(player, "XPGained", {
		Amount = xpAmount,
		LeveledUp = leveledUp,
		NewLevel = newLevel
	})
end

-- 🎉 EVENTO DE LEVEL UP
function XPSystem:OnLevelUp(player, newLevel)
	print("🎉", player.Name, "subiu para nível", newLevel)
	
	-- Aplicar bônus de stats
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			-- Aumentar vida máxima
			humanoid.MaxHealth = humanoid.MaxHealth + GameConfig.Experience.LevelUpBonus.Health
			humanoid.Health = humanoid.MaxHealth
			
			-- Aumentar velocidade
			humanoid.WalkSpeed = humanoid.WalkSpeed + GameConfig.Experience.LevelUpBonus.Speed
		end
	end
	
	-- Efeito visual de level up
	if character and character.PrimaryPart then
		local part = character.PrimaryPart
		
		-- Criar efeito de partículas
		local particle = Instance.new("ParticleEmitter")
		particle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		particle.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
		particle.Size = NumberSequence.new(2)
		particle.Lifetime = NumberRange.new(1)
		particle.Rate = 100
		particle.Speed = NumberRange.new(10)
		particle.Parent = part
		
		task.delay(3, function()
			particle:Destroy()
		end)
	end
	
	-- Notificar cliente
	local InventoryEvent = ReplicatedStorage.Events.InventoryEvent
	InventoryEvent:FireClient(player, "LevelUp", {Level = newLevel})
end

print("✅ XPSystem inicializado")

return XPSystem
