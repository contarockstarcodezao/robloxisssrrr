-- StarterPlayer/StarterPlayerScripts/ClientMain
-- Cole este script como LocalScript dentro de StarterPlayer/StarterPlayerScripts/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

print("🎮 Cliente iniciado para:", player.Name)

-- Aguardar módulos
local GameConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("GameConfig"))
local UtilityFunctions = require(ReplicatedStorage.Modules:WaitForChild("UtilityFunctions"))

-- Aguardar eventos
local CombatEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("CombatEvent")
local ShadowEvent = ReplicatedStorage.Events:WaitForChild("ShadowEvent")
local InventoryEvent = ReplicatedStorage.Events:WaitForChild("InventoryEvent")
local DungeonEvent = ReplicatedStorage.Events:WaitForChild("DungeonEvent")
local RankingEvent = ReplicatedStorage.Events:WaitForChild("RankingEvent")
local DataRequest = ReplicatedStorage.Events:WaitForChild("DataRequest")

-- Controladores
local CombatController = require(script.Parent:WaitForChild("CombatController"))
local ShadowController = require(script.Parent:WaitForChild("ShadowController"))
local UIController = require(script.Parent:WaitForChild("UIController"))

-- 🎮 INICIALIZAÇÃO
local function Initialize()
	-- Inicializar controladores
	CombatController:Initialize(player, character)
	ShadowController:Initialize(player, character)
	UIController:Initialize(player)
	
	print("✅ Cliente inicializado com sucesso!")
end

-- ⌨️ INPUT HANDLING
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	-- B - Abrir inventário
	if input.KeyCode == Enum.KeyCode.B then
		UIController:ToggleInventory()
	end
	
	-- C - Abrir menu de sombras
	if input.KeyCode == Enum.KeyCode.C then
		UIController:ToggleShadowMenu()
	end
	
	-- F - Abrir forja
	if input.KeyCode == Enum.KeyCode.F then
		UIController:ToggleForge()
	end
	
	-- L - Abrir ranking
	if input.KeyCode == Enum.KeyCode.L then
		UIController:ToggleRanking()
	end
	
	-- ESC - Fechar tudo
	if input.KeyCode == Enum.KeyCode.Escape then
		UIController:CloseAll()
	end
end)

-- 🔄 ATUALIZAR HUD
task.spawn(function()
	while task.wait(1) do
		UIController:UpdateHUD()
	end
end)

-- Aguardar character e inicializar
if not character then
	character = player.CharacterAdded:Wait()
end

-- Reconectar controladores ao respawn
player.CharacterAdded:Connect(function(newCharacter)
	character = newCharacter
	CombatController:Initialize(player, character)
	ShadowController:Initialize(player, character)
end)

Initialize()

print("✅ ClientMain carregado!")
