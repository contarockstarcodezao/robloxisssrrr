-- ServerScriptService/Systems/NPCManager
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)

local NPCManager = {}
NPCManager.SpawnedNPCs = {}
NPCManager.SpawnLocations = {} -- Configure no Workspace

-- 👾 CRIAR NPC
function NPCManager:CreateNPC(rank, position)
	local npc = Instance.new("Model")
	npc.Name = "NPC_" .. rank
	
	-- Corpo
	local part = Instance.new("Part")
	part.Name = "HumanoidRootPart"
	part.Size = Vector3.new(2, 5, 2)
	part.Anchored = false
	part.Color = UtilityFunctions:GetRankColor(rank)
	part.Position = position
	part.Parent = npc
	
	-- Humanoid
	local humanoid = Instance.new("Humanoid")
	humanoid.MaxHealth = self:GetNPCHealth(rank)
	humanoid.Health = humanoid.MaxHealth
	humanoid.WalkSpeed = 16
	humanoid.Parent = npc
	
	-- Head para display name
	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(2, 1, 1)
	head.Anchored = false
	head.Color = part.Color
	head.Position = position + Vector3.new(0, 3, 0)
	head.Parent = npc
	
	-- Weld head to body
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = part
	weld.Part1 = head
	weld.Parent = part
	
	-- Nome do NPC
	local billboard = Instance.new("BillboardGui")
	billboard.Size = UDim2.new(0, 100, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.Parent = head
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = rank .. " NPC"
	nameLabel.TextScaled = true
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.Parent = billboard
	
	npc.PrimaryPart = part
	npc:SetAttribute("Rank", rank)
	npc:SetAttribute("IsNPC", true)
	npc.Parent = workspace
	
	-- IA básica
	self:StartNPCAI(npc)
	
	-- Quando morre
	humanoid.Died:Connect(function()
		self:OnNPCDeath(npc)
	end)
	
	table.insert(self.SpawnedNPCs, npc)
	return npc
end

-- 💪 OBTER VIDA DO NPC POR RANK
function NPCManager:GetNPCHealth(rank)
	local healthTable = {
		F = 100,
		E = 200,
		D = 400,
		C = 800,
		B = 1600,
		A = 3200,
		S = 6400,
		SS = 12800,
		GM = 50000,
	}
	return healthTable[rank] or 100
end

-- 🤖 IA BÁSICA DO NPC
function NPCManager:StartNPCAI(npc)
	local humanoid = npc:FindFirstChild("Humanoid")
	if not humanoid then return end
	
	task.spawn(function()
		while npc and npc.Parent and humanoid.Health > 0 do
			wait(math.random(2, 5))
			
			-- Encontrar jogador próximo
			local nearestPlayer = nil
			local nearestDistance = 50
			
			for _, player in ipairs(game.Players:GetPlayers()) do
				if player.Character and player.Character.PrimaryPart then
					local distance = (player.Character.PrimaryPart.Position - npc.PrimaryPart.Position).Magnitude
					if distance < nearestDistance then
						nearestPlayer = player
						nearestDistance = distance
					end
				end
			end
			
			-- Mover em direção ao jogador
			if nearestPlayer and nearestPlayer.Character then
				humanoid:MoveTo(nearestPlayer.Character.PrimaryPart.Position)
				
				-- Atacar se próximo o suficiente
				if nearestDistance < 10 then
					self:NPCAttack(npc, nearestPlayer.Character)
				end
			else
				-- Andar aleatoriamente
				local randomPos = npc.PrimaryPart.Position + Vector3.new(
					math.random(-20, 20),
					0,
					math.random(-20, 20)
				)
				humanoid:MoveTo(randomPos)
			end
		end
	end)
end

-- ⚔️ NPC ATACAR JOGADOR
function NPCManager:NPCAttack(npc, targetCharacter)
	local rank = npc:GetAttribute("Rank") or "F"
	local damage = math.floor(self:GetNPCHealth(rank) * 0.05) -- 5% da vida como dano
	
	local targetHumanoid = targetCharacter:FindFirstChild("Humanoid")
	if targetHumanoid and targetHumanoid.Health > 0 then
		targetHumanoid:TakeDamage(damage)
	end
end

-- 💀 QUANDO NPC MORRE
function NPCManager:OnNPCDeath(npc)
	-- Remover da lista
	for i, n in ipairs(self.SpawnedNPCs) do
		if n == npc then
			table.remove(self.SpawnedNPCs, i)
			break
		end
	end
	
	-- Aguardar e remover
	task.wait(5)
	if npc and npc.Parent then
		npc:Destroy()
	end
	
	-- Respawn após delay
	task.wait(30)
	local rank = npc:GetAttribute("Rank") or "F"
	self:SpawnNPCsInArea(rank, 1)
end

-- 🌍 SPAWNAR NPCS EM ÁREA
function NPCManager:SpawnNPCsInArea(rank, count)
	-- Encontrar spawn locations no workspace
	local spawnFolder = workspace:FindFirstChild("NPCSpawns")
	if not spawnFolder then
		warn("❌ Pasta 'NPCSpawns' não encontrada no Workspace!")
		-- Criar spawn padrão
		local defaultPos = Vector3.new(0, 50, 50)
		for i = 1, count do
			local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
			self:CreateNPC(rank, defaultPos + offset)
		end
		return
	end
	
	-- Spawnar em locais aleatórios
	local spawns = spawnFolder:GetChildren()
	for i = 1, count do
		if #spawns > 0 then
			local spawn = spawns[math.random(1, #spawns)]
			self:CreateNPC(rank, spawn.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5)))
		end
	end
end

-- 🚀 INICIALIZAR SPAWNS
function NPCManager:Initialize()
	-- Spawnar NPCs iniciais
	self:SpawnNPCsInArea("F", 10)
	self:SpawnNPCsInArea("E", 8)
	self:SpawnNPCsInArea("D", 5)
	self:SpawnNPCsInArea("C", 3)
	self:SpawnNPCsInArea("B", 2)
	
	-- Spawnar NPCs raros periodicamente
	task.spawn(function()
		while true do
			wait(300) -- A cada 5 minutos
			
			if math.random() < 0.3 then -- 30% chance
				self:SpawnNPCsInArea("A", 1)
			end
			
			if math.random() < 0.1 then -- 10% chance
				self:SpawnNPCsInArea("S", 1)
			end
		end
	end)
	
	print("✅ NPCManager inicializado -", #self.SpawnedNPCs, "NPCs spawnados")
end

-- Inicializar após delay
task.wait(5)
NPCManager:Initialize()

return NPCManager
