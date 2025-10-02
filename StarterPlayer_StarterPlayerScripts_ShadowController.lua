-- StarterPlayer/StarterPlayerScripts/ShadowController
-- Cole este script como ModuleScript dentro de StarterPlayer/StarterPlayerScripts/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local ShadowEvent = ReplicatedStorage.Events.ShadowEvent
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)

local ShadowController = {}
ShadowController.Player = nil
ShadowController.Character = nil
ShadowController.ActiveShadow = nil

-- 🎯 INICIALIZAR
function ShadowController:Initialize(player, character)
	self.Player = player
	self.Character = character
	
	-- Escutar eventos do servidor
	ShadowEvent.OnClientEvent:Connect(function(action, data)
		if action == "ShadowCaptured" then
			self:OnShadowCaptured(data)
		elseif action == "ShadowInvoked" then
			self:OnShadowInvoked(data)
		elseif action == "ShadowEvolved" then
			self:OnShadowEvolved(data)
		elseif action == "ShadowDismissed" then
			self:OnShadowDismissed()
		elseif action == "Error" then
			self:ShowError(data)
		end
	end)
	
	print("✅ ShadowController inicializado")
end

-- 🎉 QUANDO SOMBRA É CAPTURADA
function ShadowController:OnShadowCaptured(shadowData)
	print("🎉 Sombra capturada:", shadowData.Name, "Rank:", shadowData.Rank)
	
	-- Criar efeito visual de captura
	if self.Character and self.Character.PrimaryPart then
		local captureEffect = Instance.new("Part")
		captureEffect.Size = Vector3.new(5, 5, 5)
		captureEffect.Anchored = true
		captureEffect.CanCollide = false
		captureEffect.Material = Enum.Material.Neon
		captureEffect.Color = UtilityFunctions:GetRankColor(shadowData.Rank)
		captureEffect.Transparency = 0.5
		captureEffect.Shape = Enum.PartType.Ball
		captureEffect.CFrame = self.Character.PrimaryPart.CFrame
		captureEffect.Parent = workspace
		
		-- Animação
		local tween = game:GetService("TweenService"):Create(
			captureEffect,
			TweenInfo.new(1),
			{Size = Vector3.new(10, 10, 10), Transparency = 1}
		)
		tween:Play()
		
		game:GetService("Debris"):AddItem(captureEffect, 1)
	end
	
	-- Mostrar notificação na UI
	self:ShowNotification("Sombra Capturada!", shadowData.Name .. " [" .. shadowData.Rank .. "]")
	
	-- Som de captura
	local captureSound = Instance.new("Sound")
	captureSound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	captureSound.Volume = 0.7
	captureSound.Parent = workspace
	captureSound:Play()
	game:GetService("Debris"):AddItem(captureSound, 2)
end

-- 🧞‍♂️ INVOCAR SOMBRA
function ShadowController:InvokeShadow(shadowID)
	ShadowEvent:FireServer("InvokeShadow", shadowID)
end

-- ✅ QUANDO SOMBRA É INVOCADA
function ShadowController:OnShadowInvoked(shadowData)
	print("✅ Sombra invocada:", shadowData.Name)
	self.ActiveShadow = shadowData
	
	-- Mostrar indicador de sombra ativa na UI
	self:ShowNotification("Sombra Invocada!", shadowData.Name)
end

-- 🔄 EVOLUIR SOMBRA
function ShadowController:EvolveShadow(shadowID)
	ShadowEvent:FireServer("EvolveShadow", shadowID)
end

-- ⬆️ QUANDO SOMBRA É EVOLUÍDA
function ShadowController:OnShadowEvolved(shadowData)
	print("⬆️ Sombra evoluída:", shadowData.Name, "Nível:", shadowData.EvolutionLevel)
	
	-- Efeito visual
	if self.Character and self.Character.PrimaryPart then
		local evolveEffect = Instance.new("Part")
		evolveEffect.Size = Vector3.new(3, 10, 3)
		evolveEffect.Anchored = true
		evolveEffect.CanCollide = false
		evolveEffect.Material = Enum.Material.Neon
		evolveEffect.Color = Color3.fromRGB(255, 215, 0)
		evolveEffect.Transparency = 0.3
		evolveEffect.CFrame = self.Character.PrimaryPart.CFrame
		evolveEffect.Parent = workspace
		
		-- Rotação
		task.spawn(function()
			for i = 1, 20 do
				evolveEffect.CFrame = evolveEffect.CFrame * CFrame.Angles(0, math.rad(18), 0)
				evolveEffect.Transparency = evolveEffect.Transparency + 0.035
				task.wait(0.05)
			end
			evolveEffect:Destroy()
		end)
	end
	
	self:ShowNotification("Sombra Evoluída!", shadowData.Name .. " Nv." .. shadowData.EvolutionLevel)
end

-- 🚫 DISPENSAR SOMBRA
function ShadowController:DismissShadow()
	ShadowEvent:FireServer("DismissShadow")
end

-- ✅ QUANDO SOMBRA É DISPENSADA
function ShadowController:OnShadowDismissed()
	print("✅ Sombra dispensada")
	self.ActiveShadow = nil
end

-- 📢 MOSTRAR NOTIFICAÇÃO
function ShadowController:ShowNotification(title, message)
	-- Criar notificação simples (pode ser melhorada)
	local notification = Instance.new("ScreenGui")
	notification.Parent = self.Player.PlayerGui
	notification.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 300, 0, 100)
	frame.Position = UDim2.new(0.5, -150, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Parent = notification
	
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0.4, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
	titleLabel.TextScaled = true
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = frame
	
	local messageLabel = Instance.new("TextLabel")
	messageLabel.Size = UDim2.new(1, 0, 0.6, 0)
	messageLabel.Position = UDim2.new(0, 0, 0.4, 0)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Text = message
	messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	messageLabel.TextScaled = true
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.Parent = frame
	
	-- Animar e remover
	task.spawn(function()
		task.wait(3)
		local tween = game:GetService("TweenService"):Create(
			frame,
			TweenInfo.new(0.5),
			{Position = UDim2.new(0.5, -150, 0, -120)}
		)
		tween:Play()
		tween.Completed:Wait()
		notification:Destroy()
	end)
end

-- ❌ MOSTRAR ERRO
function ShadowController:ShowError(message)
	warn("❌ Erro de sombra:", message)
	self:ShowNotification("Erro", message)
end

return ShadowController
