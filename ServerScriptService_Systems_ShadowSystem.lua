-- ServerScriptService/Systems/ShadowSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local ShadowData = require(ReplicatedStorage.Modules.ShadowData)
local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local DataManager = require(ServerScriptService.Core.DataManager)

local ShadowEvent = ReplicatedStorage.Events.ShadowEvent

local ShadowSystem = {}
ShadowSystem.ActiveShadows = {} -- {[player] = shadowModel}

-- 🎯 TENTAR CAPTURAR SOMBRA
function ShadowSystem:TryCaptureShadow(player, npcRank)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Calcular chance de captura
	local baseChance = GameConfig.Shadows.CaptureChances[npcRank] or 0
	
	-- Aplicar bônus de relíquias
	local RelicData = require(ReplicatedStorage.Modules.RelicData)
	local relicBonus = RelicData:CalculateTotalBonus(playerData.EquippedRelics)
	local finalChance = baseChance * (1 + relicBonus.CaptureRate)
	
	-- Verificar sucesso
	if not UtilityFunctions:RollChance(finalChance / 100) then
		return false, "Captura falhou"
	end
	
	-- Selecionar sombra aleatória do rank
	local shadowTemplate = ShadowData:GetRandomShadowByRank(npcRank)
	if not shadowTemplate then
		return false, "Nenhuma sombra disponível"
	end
	
	-- Criar instância da sombra
	local shadowInstance = ShadowData:CreateShadowInstance(shadowTemplate.ID, 0)
	
	-- Adicionar ao jogador
	local success, err = DataManager:AddShadow(player, shadowInstance)
	
	if success then
		-- Notificar cliente
		ShadowEvent:FireClient(player, "ShadowCaptured", shadowInstance)
		return true, shadowInstance
	else
		return false, err
	end
end

-- 🧞‍♂️ INVOCAR SOMBRA
function ShadowSystem:InvokeShadow(player, shadowID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Verificar se jogador possui a sombra
	local shadowInstance = nil
	for _, shadow in ipairs(playerData.Shadows) do
		if shadow.ID == shadowID then
			shadowInstance = shadow
			break
		end
	end
	
	if not shadowInstance then
		return false, "Sombra não encontrada"
	end
	
	-- Remover sombra ativa anterior
	if self.ActiveShadows[player] then
		self.ActiveShadows[player]:Destroy()
	end
	
	-- Criar modelo da sombra
	local shadowModel = self:CreateShadowModel(player, shadowInstance)
	self.ActiveShadows[player] = shadowModel
	
	-- Atualizar dados
	playerData.ActiveShadow = shadowID
	
	return true, shadowInstance
end

-- 🎨 CRIAR MODELO DA SOMBRA
function ShadowSystem:CreateShadowModel(player, shadowInstance)
	local character = player.Character
	if not character or not character.PrimaryPart then return nil end
	
	-- Criar modelo base (substitua por modelo 3D real)
	local shadowModel = Instance.new("Model")
	shadowModel.Name = shadowInstance.Name
	
	local part = Instance.new("Part")
	part.Size = Vector3.new(2, 4, 2)
	part.Anchored = false
	part.CanCollide = false
	part.Color = UtilityFunctions:GetRankColor(shadowInstance.Rank)
	part.Material = Enum.Material.Neon
	part.Parent = shadowModel
	
	local humanoid = Instance.new("Humanoid")
	humanoid.Health = shadowInstance.Stats.Health
	humanoid.MaxHealth = shadowInstance.Stats.Health
	humanoid.WalkSpeed = shadowInstance.Stats.Speed
	humanoid.Parent = shadowModel
	
	shadowModel.PrimaryPart = part
	shadowModel.Parent = workspace
	
	-- Posicionar perto do jogador
	shadowModel:SetPrimaryPartCFrame(character.PrimaryPart.CFrame * CFrame.new(3, 0, 0))
	
	-- Iniciar IA de combate
	self:StartShadowAI(player, shadowModel, shadowInstance)
	
	return shadowModel
end

-- 🤖 IA DE COMBATE DA SOMBRA
function ShadowSystem:StartShadowAI(player, shadowModel, shadowInstance)
	local character = player.Character
	if not character then return end
	
	task.spawn(function()
		while shadowModel and shadowModel.Parent and shadowModel.PrimaryPart do
			wait(GameConfig.Shadows.InvokeCooldown)
			
			-- Seguir jogador se não houver inimigos
			local enemies = UtilityFunctions:FindEnemiesInRadius(
				shadowModel.PrimaryPart.Position,
				GameConfig.Combat.DetectionRange,
				{character, shadowModel}
			)
			
			if #enemies > 0 then
				-- Atacar inimigo mais próximo
				local target = enemies[1].Enemy
				if target and target.PrimaryPart then
					-- Mover em direção ao alvo
					local humanoid = shadowModel:FindFirstChild("Humanoid")
					if humanoid then
						humanoid:MoveTo(target.PrimaryPart.Position)
					end
					
					-- Verificar se está no alcance
					local distance = (shadowModel.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude
					if distance <= shadowInstance.Stats.AttackRange then
						-- Aplicar dano
						UtilityFunctions:ApplyDamage(target, shadowInstance.Stats.Damage, "Normal")
					end
				end
			else
				-- Seguir jogador
				if character.PrimaryPart then
					local humanoid = shadowModel:FindFirstChild("Humanoid")
					if humanoid then
						local followPos = character.PrimaryPart.Position + Vector3.new(3, 0, 0)
						humanoid:MoveTo(followPos)
					end
				end
			end
		end
	end)
end

-- 🔄 EVOLUIR SOMBRA
function ShadowSystem:EvolveShadow(player, shadowID)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return false end
	
	-- Encontrar sombra
	local shadowInstance = nil
	local shadowIndex = nil
	for i, shadow in ipairs(playerData.Shadows) do
		if shadow.ID == shadowID then
			shadowInstance = shadow
			shadowIndex = i
			break
		end
	end
	
	if not shadowInstance then
		return false, "Sombra não encontrada"
	end
	
	-- Obter custo de evolução
	local evolutionCost = GameConfig.Shadows.EvolutionCosts[shadowInstance.Rank]
	if not evolutionCost then
		return false, "Evolução máxima atingida"
	end
	
	-- Verificar recursos
	local valid, err = UtilityFunctions:ValidatePurchase(playerData, evolutionCost)
	if not valid then
		return false, err
	end
	
	-- Deduzir recursos
	UtilityFunctions:DeductResources(playerData, evolutionCost)
	
	-- Evoluir sombra
	shadowInstance.EvolutionLevel = shadowInstance.EvolutionLevel + 1
	shadowInstance.Stats = ShadowData:CalculateStats(
		ShadowData:GetShadowByID(shadowID),
		shadowInstance.EvolutionLevel
	)
	
	-- Atualizar no array
	playerData.Shadows[shadowIndex] = shadowInstance
	
	-- Notificar cliente
	ShadowEvent:FireClient(player, "ShadowEvolved", shadowInstance)
	
	return true, shadowInstance
end

-- 📋 EVENTOS DO CLIENTE
ShadowEvent.OnServerEvent:Connect(function(player, action, ...)
	if action == "InvokeShadow" then
		local shadowID = ...
		local success, result = ShadowSystem:InvokeShadow(player, shadowID)
		
		if success then
			ShadowEvent:FireClient(player, "ShadowInvoked", result)
		else
			ShadowEvent:FireClient(player, "Error", result)
		end
		
	elseif action == "EvolveShadow" then
		local shadowID = ...
		local success, result = ShadowSystem:EvolveShadow(player, shadowID)
		
		if success then
			ShadowEvent:FireClient(player, "ShadowEvolved", result)
		else
			ShadowEvent:FireClient(player, "Error", result)
		end
		
	elseif action == "DismissShadow" then
		if ShadowSystem.ActiveShadows[player] then
			ShadowSystem.ActiveShadows[player]:Destroy()
			ShadowSystem.ActiveShadows[player] = nil
			
			local playerData = DataManager:GetPlayerData(player)
			if playerData then
				playerData.ActiveShadow = nil
			end
			
			ShadowEvent:FireClient(player, "ShadowDismissed")
		end
	end
end)

-- Limpar sombras quando jogador sai
game.Players.PlayerRemoving:Connect(function(player)
	if ShadowSystem.ActiveShadows[player] then
		ShadowSystem.ActiveShadows[player]:Destroy()
		ShadowSystem.ActiveShadows[player] = nil
	end
end)

print("✅ ShadowSystem inicializado")

return ShadowSystem
