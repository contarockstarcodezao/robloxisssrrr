-- StarterPlayer/StarterCharacterScripts/CombatClient
-- Cliente: Detecta cliques e envia ataques para o servidor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = script.Parent
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Módulos
local CombatConfig = require(ReplicatedStorage:WaitForChild("CombatConfig"))
local CombatRemotes = require(ReplicatedStorage:WaitForChild("CombatRemotes"))

-- Estado do combate
local currentAttackStyle = "Punch" -- Padrão: Soco
local isAttacking = false
local lastAttackTime = 0

-- ============================
-- FUNÇÕES DE UTILIDADE
-- ============================

local function CanAttack()
	local currentTime = tick()
	local attackConfig = CombatConfig.AttackStyles[currentAttackStyle]
	
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
	local attackConfig = CombatConfig.AttackStyles[currentAttackStyle]
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
	
	local attackConfig = CombatConfig.AttackStyles[currentAttackStyle]
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
	CombatRemotes.AttackEvent:FireServer(currentAttackStyle, attackPosition)
	
	-- Debug visual (opcional)
	if CombatConfig.HitboxSettings.DebugMode then
		local attackConfig = CombatConfig.AttackStyles[currentAttackStyle]
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
	if CombatConfig.AttackStyles[newStyle] then
		currentAttackStyle = newStyle
		print("Estilo de ataque alterado para:", CombatConfig.AttackStyles[newStyle].Name)
		return true
	end
	return false
end

-- Expõe função para a UI
_G.ChangeAttackStyle = ChangeAttackStyle

-- ============================
-- ENTRADA DO JOGADOR
-- ============================

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- Ignora se o jogador estiver digitando em chat, etc.
	if gameProcessed then return end
	
	-- Clique esquerdo do mouse
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		PerformAttack()
	end
	
	-- Teclas de atalho (opcional)
	if input.KeyCode == Enum.KeyCode.One then
		ChangeAttackStyle("Punch")
	elseif input.KeyCode == Enum.KeyCode.Two then
		ChangeAttackStyle("Sword")
	end
end)

-- ============================
-- FEEDBACK VISUAL
-- ============================

CombatRemotes.AttackFeedback.OnClientEvent:Connect(function(feedbackType, npc, killed)
	if feedbackType == "hit" then
		-- Efeito visual de acerto
		print("Acertou!", killed and "NPC eliminado!" or "")
		
		-- Aqui você pode adicionar efeitos visuais/sonoros
		-- Exemplo: som de acerto
		-- local hitSound = Instance.new("Sound")
		-- hitSound.SoundId = "rbxassetid://SEU_ID_DE_SOM"
		-- hitSound.Parent = humanoidRootPart
		-- hitSound:Play()
		
	elseif feedbackType == "miss" then
		-- Efeito visual de erro
		print("Errou!")
	end
end)

print("Sistema de Combate: Cliente inicializado!")
