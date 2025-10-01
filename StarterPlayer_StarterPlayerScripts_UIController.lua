-- StarterPlayer/StarterPlayerScripts/UIController
-- Cole este script como ModuleScript dentro de StarterPlayer/StarterPlayerScripts/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local DataRequest = ReplicatedStorage.Events.DataRequest
local InventoryEvent = ReplicatedStorage.Events.InventoryEvent
local RankingEvent = ReplicatedStorage.Events.RankingEvent

local UIController = {}
UIController.Player = nil
UIController.PlayerData = nil
UIController.GUIElements = {}

-- 🎯 INICIALIZAR
function UIController:Initialize(player)
	self.Player = player
	
	-- Aguardar GUI
	local gui = player:WaitForChild("PlayerGui"):WaitForChild("GameUI", 10)
	if not gui then
		warn("❌ GameUI não encontrada!")
		return
	end
	
	-- Referenciar elementos
	self.GUIElements.HUD = gui:WaitForChild("HUD", 5)
	self.GUIElements.ShadowInventory = gui:WaitForChild("ShadowInventory", 5)
	self.GUIElements.Backpack = gui:WaitForChild("Backpack", 5)
	self.GUIElements.Forge = gui:WaitForChild("Forge", 5)
	self.GUIElements.Ranking = gui:WaitForChild("Ranking", 5)
	self.GUIElements.DungeonUI = gui:WaitForChild("DungeonUI", 5)
	
	-- Ocultar todos menus inicialmente
	for name, element in pairs(self.GUIElements) do
		if name ~= "HUD" and element then
			element.Visible = false
		end
	end
	
	-- Escutar eventos
	InventoryEvent.OnClientEvent:Connect(function(action, data)
		if action == "DropsReceived" then
			self:OnDropsReceived(data)
		elseif action == "XPGained" then
			self:OnXPGained(data)
		elseif action == "LevelUp" then
			self:OnLevelUp(data)
		elseif action == "RaidRewards" then
			self:OnRaidRewards(data)
		end
	end)
	
	-- Atualizar dados do jogador
	self:RefreshPlayerData()
	
	print("✅ UIController inicializado")
end

-- 🔄 ATUALIZAR DADOS DO JOGADOR
function UIController:RefreshPlayerData()
	-- Solicitar dados do servidor (implementar RemoteFunction)
	-- Por enquanto, usar leaderstats
	task.spawn(function()
		while task.wait(2) do
			local leaderstats = self.Player:FindFirstChild("leaderstats")
			if leaderstats then
				-- Atualizar cache local
			end
		end
	end)
end

-- 📊 ATUALIZAR HUD
function UIController:UpdateHUD()
	if not self.GUIElements.HUD then return end
	
	local leaderstats = self.Player:FindFirstChild("leaderstats")
	if not leaderstats then return end
	
	-- Atualizar Level
	local levelLabel = self.GUIElements.HUD:FindFirstChild("LevelLabel")
	if levelLabel then
		local level = leaderstats:FindFirstChild("Level")
		if level then
			levelLabel.Text = "Nível: " .. level.Value
		end
	end
	
	-- Atualizar Cash
	local cashLabel = self.GUIElements.HUD:FindFirstChild("CashLabel")
	if cashLabel then
		local cash = leaderstats:FindFirstChild("Cash")
		if cash then
			cashLabel.Text = "💰 " .. UtilityFunctions:FormatNumber(cash.Value)
		end
	end
end

-- 🎒 TOGGLE INVENTÁRIO
function UIController:ToggleInventory()
	if not self.GUIElements.Backpack then return end
	
	self.GUIElements.Backpack.Visible = not self.GUIElements.Backpack.Visible
	
	if self.GUIElements.Backpack.Visible then
		self:LoadInventory()
	end
end

-- 📦 CARREGAR INVENTÁRIO
function UIController:LoadInventory()
	-- Implementar carregamento de itens do servidor
	print("Carregando inventário...")
end

-- 🧞‍♂️ TOGGLE MENU DE SOMBRAS
function UIController:ToggleShadowMenu()
	if not self.GUIElements.ShadowInventory then return end
	
	self.GUIElements.ShadowInventory.Visible = not self.GUIElements.ShadowInventory.Visible
	
	if self.GUIElements.ShadowInventory.Visible then
		self:LoadShadows()
	end
end

-- 🗡️ CARREGAR SOMBRAS
function UIController:LoadShadows()
	-- Implementar carregamento de sombras do servidor
	print("Carregando sombras...")
end

-- 🔨 TOGGLE FORJA
function UIController:ToggleForge()
	if not self.GUIElements.Forge then return end
	
	self.GUIElements.Forge.Visible = not self.GUIElements.Forge.Visible
end

-- 🏆 TOGGLE RANKING
function UIController:ToggleRanking()
	if not self.GUIElements.Ranking then return end
	
	self.GUIElements.Ranking.Visible = not self.GUIElements.Ranking.Visible
	
	if self.GUIElements.Ranking.Visible then
		self:LoadRanking()
	end
end

-- 📊 CARREGAR RANKING
function UIController:LoadRanking()
	RankingEvent:FireServer("GetRanking", "Global")
	
	RankingEvent.OnClientEvent:Connect(function(action, data)
		if action == "RankingData" then
			self:DisplayRanking(data)
		end
	end)
end

-- 📋 EXIBIR RANKING
function UIController:DisplayRanking(data)
	if not self.GUIElements.Ranking then return end
	
	local scrollFrame = self.GUIElements.Ranking:FindFirstChild("ScrollingFrame")
	if not scrollFrame then return end
	
	-- Limpar itens anteriores
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	-- Criar entradas
	for i, entry in ipairs(data.Data) do
		local entryFrame = Instance.new("Frame")
		entryFrame.Size = UDim2.new(1, -10, 0, 50)
		entryFrame.Position = UDim2.new(0, 5, 0, (i - 1) * 55)
		entryFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		entryFrame.BorderSizePixel = 0
		entryFrame.Parent = scrollFrame
		
		local rankLabel = Instance.new("TextLabel")
		rankLabel.Size = UDim2.new(0.1, 0, 1, 0)
		rankLabel.BackgroundTransparency = 1
		rankLabel.Text = "#" .. i
		rankLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
		rankLabel.TextScaled = true
		rankLabel.Font = Enum.Font.GothamBold
		rankLabel.Parent = entryFrame
		
		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.4, 0, 1, 0)
		nameLabel.Position = UDim2.new(0.1, 0, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = entry.Name
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		nameLabel.TextScaled = true
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.Parent = entryFrame
		
		local powerLabel = Instance.new("TextLabel")
		powerLabel.Size = UDim2.new(0.5, 0, 1, 0)
		powerLabel.Position = UDim2.new(0.5, 0, 0, 0)
		powerLabel.BackgroundTransparency = 1
		powerLabel.Text = "Poder: " .. UtilityFunctions:FormatNumber(entry.Power)
		powerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
		powerLabel.TextScaled = true
		powerLabel.Font = Enum.Font.Gotham
		powerLabel.Parent = entryFrame
	end
	
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #data.Data * 55)
end

-- ❌ FECHAR TODOS MENUS
function UIController:CloseAll()
	for name, element in pairs(self.GUIElements) do
		if name ~= "HUD" and element then
			element.Visible = false
		end
	end
end

-- 🎁 QUANDO RECEBE DROPS
function UIController:OnDropsReceived(drops)
	for _, drop in ipairs(drops) do
		if drop.Type == "Cash" then
			self:ShowFloatingText("+" .. drop.Amount .. " Cash", Color3.fromRGB(255, 215, 0))
		elseif drop.Type == "Fragments" then
			self:ShowFloatingText("+" .. drop.Amount .. " Fragmentos", Color3.fromRGB(150, 0, 255))
		end
	end
end

-- 📈 QUANDO GANHA XP
function UIController:OnXPGained(data)
	self:ShowFloatingText("+" .. data.Amount .. " XP", Color3.fromRGB(0, 255, 255))
	
	if data.LeveledUp then
		self:ShowLevelUpEffect(data.NewLevel)
	end
end

-- 🎉 QUANDO SOBE DE NÍVEL
function UIController:OnLevelUp(data)
	self:ShowLevelUpEffect(data.Level)
end

-- ✨ EFEITO DE LEVEL UP
function UIController:ShowLevelUpEffect(level)
	-- Criar tela de level up
	local levelUpGui = Instance.new("ScreenGui")
	levelUpGui.Parent = self.Player.PlayerGui
	levelUpGui.ResetOnSpawn = false
	
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 400, 0, 200)
	frame.Position = UDim2.new(0.5, -200, 0.5, -100)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 3
	frame.BorderColor3 = Color3.fromRGB(255, 215, 0)
	frame.Parent = levelUpGui
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "🎉 LEVEL UP! 🎉\nNível " .. level
	label.TextColor3 = Color3.fromRGB(255, 215, 0)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = frame
	
	-- Som de level up
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxasset://sounds/electronicpingshort.wav"
	sound.Volume = 1
	sound.Parent = workspace
	sound:Play()
	
	-- Remover após 3 segundos
	game:GetService("Debris"):AddItem(levelUpGui, 3)
	game:GetService("Debris"):AddItem(sound, 2)
end

-- 💫 MOSTRAR TEXTO FLUTUANTE
function UIController:ShowFloatingText(text, color)
	local character = self.Player.Character
	if not character or not character.PrimaryPart then return end
	
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = workspace
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = color
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = billboard
	
	local attachment = Instance.new("Attachment")
	attachment.Position = character.PrimaryPart.Position
	attachment.Parent = workspace.Terrain
	billboard.Adornee = attachment
	
	-- Animar
	task.spawn(function()
		for i = 1, 30 do
			billboard.StudsOffset = billboard.StudsOffset + Vector3.new(0, 0.1, 0)
			label.TextTransparency = i / 30
			task.wait(0.05)
		end
		billboard:Destroy()
		attachment:Destroy()
	end)
end

-- 🏆 QUANDO RECEBE RECOMPENSAS DE RAID
function UIController:OnRaidRewards(rewards)
	print("🏆 Recompensas de Raid:", rewards)
	-- Criar UI de recompensas
end

return UIController
