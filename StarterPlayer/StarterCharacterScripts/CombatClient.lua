-- StarterPlayer/StarterCharacterScripts/CombatClient
-- Cliente: Detecta ataques e comunica com servidor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = script.Parent
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Módulos
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local RemoteEvents = require(ReplicatedStorage.Modules.RemoteEvents)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)

-- Estado do combate
local currentAttackStyle = "Fist" -- Padrão: Soco
local isAttacking = false
local lastAttackTime = 0

-- Dados do jogador (cache local)
local playerData = nil

-- ============================
-- SINCRONIZAÇÃO DE DADOS
-- ============================

local function RequestPlayerData()
	local success, data = pcall(function()
		return RemoteEvents.RequestData:InvokeServer()
	end)
	
	if success and data then
		playerData = data
		currentAttackStyle = data.WeaponType or "Fist"
	end
end

-- Requisita dados iniciais
RequestPlayerData()

-- Escuta atualizações de dados
RemoteEvents.DataUpdate.OnClientEvent:Connect(function(key, value)
	if key == "FullData" then
		playerData = value
		currentAttackStyle = value.WeaponType or "Fist"
	elseif key == "WeaponType" then
		currentAttackStyle = value
	elseif playerData then
		playerData[key] = value
	end
end)

-- ============================
-- FUNÇÕES DE UTILIDADE
-- ============================

local function CanAttack()
	local currentTime = tick()
	local attackConfig = GameConfig.Combat.AttackStyles[currentAttackStyle]
	
	if not attackConfig then
		return false
	end
	
	-- Verifica cooldown
	if currentTime - lastAttackTime < attackConfig.Cooldown then
		return false
	end
	
	-- Verifica se o personagem está vivo
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return false
	end
	
	return true
end

local function GetAttackPosition()
	-- Retorna a posição à frente do jogador
	local lookVector = humanoidRootPart.CFrame.LookVector
	local attackConfig = GameConfig.Combat.AttackStyles[currentAttackStyle]
	local range = attackConfig and attackConfig.Range or 5
	
	-- Posição de ataque (meio da distância do alcance)
	return humanoidRootPart.Position + (lookVector * (range / 2))
end

-- ============================
-- ANIMAÇÕES (OPCIONAL)
-- ============================

local function PlayAttackAnimation()
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	local attackConfig = GameConfig.Combat.AttackStyles[currentAttackStyle]
	if attackConfig.Animation then
		-- Se você tiver IDs de animação, carregue aqui
		-- local animation = Instance.new("Animation")
		-- animation.AnimationId = "rbxassetid://" .. attackConfig.Animation
		-- local track = humanoid:LoadAnimation(animation)
		-- track:Play()
	end
end

-- ============================
-- SISTEMA DE ATAQUE
-- ============================

local function PerformAttack()
	if not CanAttack() then
		return
	end
	
	isAttacking = true
	lastAttackTime = tick()
	
	-- Toca animação
	PlayAttackAnimation()
	
	-- Calcula posição do ataque
	local attackPosition = GetAttackPosition()
	
	-- Envia para o servidor
	RemoteEvents.AttackEvent:FireServer(currentAttackStyle, attackPosition)
	
	-- Debug visual (opcional)
	if GameConfig.Combat.HitboxSettings.DebugMode then
		local attackConfig = GameConfig.Combat.AttackStyles[currentAttackStyle]
		local part = Instance.new("Part")
		part.Shape = Enum.PartType.Ball
		part.Size = Vector3.new(attackConfig.Range * 2, attackConfig.Range * 2, attackConfig.Range * 2)
		part.Position = attackPosition
		part.Transparency = 0.7
		part.Color = Color3.fromRGB(255, 0, 0)
		part.Anchored = true
		part.CanCollide = false
		part.Parent = workspace
		
		game:GetService("Debris"):AddItem(part, 0.5)
	end
	
	task.wait(0.1)
	isAttacking = false
end

-- ============================
-- GERENCIAMENTO DE ESTILO
-- ============================

local function ChangeAttackStyle(newStyle)
	if GameConfig.Combat.AttackStyles[newStyle] then
		currentAttackStyle = newStyle
		print("✅ Estilo alterado:", GameConfig.Combat.AttackStyles[newStyle].Name)
		return true
	end
	return false
end

-- Expõe função globalmente para UI
_G.ChangeAttackStyle = ChangeAttackStyle

-- ============================
-- ENTRADA DO JOGADOR
-- ============================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- Ignora se o jogador estiver digitando
	if gameProcessed then return end
	
	-- Clique esquerdo do mouse
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PerformAttack()
	end
	
	-- Teclas de atalho
	if input.KeyCode == Enum.KeyCode.One then
		ChangeAttackStyle("Fist")
	elseif input.KeyCode == Enum.KeyCode.Two then
		ChangeAttackStyle("Sword")
	end
end)

-- ============================
-- FEEDBACK VISUAL DO SERVIDOR
-- ============================

RemoteEvents.AttackFeedback.OnClientEvent:Connect(function(feedbackType, data)
	if feedbackType == "hit" then
		-- Efeito de acerto
		print("💥 Acertou!", data.NPCName, "-", data.Damage, "dano", data.Killed and "🔥 ELIMINADO!" or "")
		
	elseif feedbackType == "miss" then
		-- Efeito de erro
		print("❌ Errou!")
		
	elseif feedbackType == "level_up" then
		-- Notificação de level up
		print("⭐ LEVEL UP! Nível", data)
		
	elseif feedbackType == "shadow_captured" then
		-- Notificação de captura de sombra
		print("🧞‍♂️ Sombra capturada:", data.Name)
	end
end)

print("✅ Sistema de Combate (Cliente) inicializado!")
