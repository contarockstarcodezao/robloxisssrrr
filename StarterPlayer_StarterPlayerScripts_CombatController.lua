-- StarterPlayer/StarterPlayerScripts/CombatController
-- Cole este script como ModuleScript dentro de StarterPlayer/StarterPlayerScripts/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local CombatEvent = ReplicatedStorage.Events.CombatEvent

local CombatController = {}
CombatController.Player = nil
CombatController.Character = nil
CombatController.IsAttacking = false
CombatController.LastAttackTime = 0

-- 🎯 INICIALIZAR
function CombatController:Initialize(player, character)
	self.Player = player
	self.Character = character
	
	-- Detectar cliques
	local mouse = player:GetMouse()
	
	mouse.Button1Down:Connect(function()
		self:Attack(mouse.Hit.Position)
	end)
	
	-- Escutar respostas do servidor
	CombatEvent.OnClientEvent:Connect(function(action, data)
		if action == "AttackSuccess" then
			self:OnAttackSuccess(data)
		elseif action == "WeaponEquipped" then
			self:OnWeaponEquipped(data)
		elseif action == "WeaponUpgraded" then
			self:OnWeaponUpgraded(data)
		elseif action == "Error" then
			self:ShowError(data)
		end
	end)
	
	print("✅ CombatController inicializado")
end

-- ⚔️ ATACAR
function CombatController:Attack(targetPosition)
	-- Verificar cooldown local
	local currentTime = tick()
	if currentTime - self.LastAttackTime < GameConfig.Combat.AttackCooldown then
		return
	end
	
	if self.IsAttacking then return end
	
	self.IsAttacking = true
	self.LastAttackTime = currentTime
	
	-- Tocar animação de ataque
	self:PlayAttackAnimation()
	
	-- Enviar para servidor
	CombatEvent:FireServer("Attack", targetPosition)
	
	task.wait(GameConfig.Combat.AttackCooldown)
	self.IsAttacking = false
end

-- 🎭 TOCAR ANIMAÇÃO DE ATAQUE
function CombatController:PlayAttackAnimation()
	local humanoid = self.Character:FindFirstChild("Humanoid")
	if not humanoid then return end
	
	-- Criar animação básica (substitua por animação real)
	local animator = humanoid:FindFirstChildOfClass("Animator")
	if animator then
		-- Use IDs de animação reais aqui
		-- local animation = Instance.new("Animation")
		-- animation.AnimationId = "rbxassetid://YOUR_ANIMATION_ID"
		-- local track = animator:LoadAnimation(animation)
		-- track:Play()
	end
	
	-- Efeito visual temporário
	if self.Character.PrimaryPart then
		local effect = Instance.new("Part")
		effect.Size = Vector3.new(1, 1, 1)
		effect.Anchored = true
		effect.CanCollide = false
		effect.Material = Enum.Material.Neon
		effect.Color = Color3.fromRGB(255, 255, 0)
		effect.CFrame = self.Character.PrimaryPart.CFrame * CFrame.new(0, 0, -3)
		effect.Parent = workspace
		
		game:GetService("Debris"):AddItem(effect, 0.5)
	end
end

-- ✅ QUANDO ATAQUE TEM SUCESSO
function CombatController:OnAttackSuccess(data)
	-- Criar efeito visual de hit
	if data.Target and data.Target.PrimaryPart then
		local hitEffect = Instance.new("Part")
		hitEffect.Size = Vector3.new(2, 2, 2)
		hitEffect.Anchored = true
		hitEffect.CanCollide = false
		hitEffect.Material = Enum.Material.Neon
		hitEffect.Transparency = 0.5
		hitEffect.Color = data.IsCrit and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 0, 0)
		hitEffect.CFrame = data.Target.PrimaryPart.CFrame
		hitEffect.Parent = workspace
		
		-- Animação de expansão
		local tween = game:GetService("TweenService"):Create(
			hitEffect,
			TweenInfo.new(0.5),
			{Size = Vector3.new(4, 4, 4), Transparency = 1}
		)
		tween:Play()
		
		game:GetService("Debris"):AddItem(hitEffect, 0.5)
	end
	
	-- Som de hit
	local hitSound = Instance.new("Sound")
	hitSound.SoundId = "rbxasset://sounds/hit.wav"
	hitSound.Volume = 0.5
	hitSound.Parent = workspace
	hitSound:Play()
	game:GetService("Debris"):AddItem(hitSound, 2)
end

-- 🗡️ QUANDO ARMA É EQUIPADA
function CombatController:OnWeaponEquipped(weaponID)
	print("✅ Arma equipada:", weaponID)
	-- Atualizar visual da arma no personagem
end

-- ⬆️ QUANDO ARMA É MELHORADA
function CombatController:OnWeaponUpgraded(weaponData)
	print("✅ Arma melhorada:", weaponData.Name, "Nível", weaponData.UpgradeLevel)
	-- Mostrar notificação
end

-- ❌ MOSTRAR ERRO
function CombatController:ShowError(message)
	warn("❌ Erro de combate:", message)
	-- Mostrar na UI
end

return CombatController
