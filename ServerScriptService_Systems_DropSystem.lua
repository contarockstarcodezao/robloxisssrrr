-- ServerScriptService/Systems/DropSystem
-- Cole este script como Script dentro de ServerScriptService/Systems/

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local GameConfig = require(ReplicatedStorage.Modules.GameConfig)
local UtilityFunctions = require(ReplicatedStorage.Modules.UtilityFunctions)
local WeaponData = require(ReplicatedStorage.Modules.WeaponData)
local RelicData = require(ReplicatedStorage.Modules.RelicData)
local DataManager = require(ServerScriptService.Core.DataManager)

local DropSystem = {}

-- 💰 PROCESSAR DROPS DE UM INIMIGO
function DropSystem:ProcessDrops(player, enemy, npcRank)
	local playerData = DataManager:GetPlayerData(player)
	if not playerData then return end
	
	-- Aplicar bônus de drop rate de relíquias
	local relicBonus = require(ReplicatedStorage.Modules.RelicData):CalculateTotalBonus(playerData.EquippedRelics)
	local dropMultiplier = 1 + relicBonus.DropRate
	
	local drops = {}
	
	-- 💵 CASH (sempre dropa)
	local cashData = GameConfig.Drops.CashDrops[npcRank] or {Min = 10, Max = 25}
	local cashAmount = math.random(cashData.Min, cashData.Max)
	DataManager:AddResource(player, "Cash", cashAmount)
	table.insert(drops, {Type = "Cash", Amount = cashAmount})
	
	-- 💎 FRAGMENTOS
	if UtilityFunctions:RollChance((GameConfig.Drops.DropChances.Fragments / 100) * dropMultiplier) then
		local fragmentAmount = math.random(5, 20) * (npcRank == "S" and 3 or npcRank == "A" and 2 or 1)
		DataManager:AddResource(player, "Fragments", fragmentAmount)
		table.insert(drops, {Type = "Fragments", Amount = fragmentAmount})
	end
	
	-- 🧪 POÇÃO
	if UtilityFunctions:RollChance((GameConfig.Drops.DropChances.Potion / 100) * dropMultiplier) then
		local potion = {
			ID = "POTION_HEALTH",
			Name = "Poção de Vida",
			Type = "Health",
			Value = 100,
			AcquiredAt = os.time()
		}
		DataManager:AddItem(player, "Consumables", potion)
		table.insert(drops, {Type = "Potion", Item = potion})
	end
	
	-- ⚔️ ARMA
	if UtilityFunctions:RollChance((GameConfig.Drops.DropChances.Weapon / 100) * dropMultiplier) then
		local weapon = WeaponData:GetRandomWeapon()
		if weapon then
			local weaponInstance = WeaponData:CreateWeaponInstance(weapon.ID, 0)
			local success = DataManager:AddItem(player, "Weapons", weaponInstance)
			if success then
				table.insert(drops, {Type = "Weapon", Item = weaponInstance})
			end
		end
	end
	
	-- 🧿 RELÍQUIA
	if UtilityFunctions:RollChance((GameConfig.Drops.DropChances.Relic / 100) * dropMultiplier) then
		local relic = RelicData:GetRandomRelic()
		if relic then
			local relicInstance = RelicData:CreateRelicInstance(relic.ID, 1)
			local success = DataManager:AddItem(player, "Relics", relicInstance)
			if success then
				table.insert(drops, {Type = "Relic", Item = relicInstance})
			end
		end
	end
	
	-- Criar drops visuais no mundo (opcional)
	if enemy.PrimaryPart then
		self:CreateVisualDrops(enemy.PrimaryPart.Position, drops)
	end
	
	-- Notificar cliente
	local InventoryEvent = ReplicatedStorage.Events.InventoryEvent
	InventoryEvent:FireClient(player, "DropsReceived", drops)
	
	return drops
end

-- 🎨 CRIAR DROPS VISUAIS (OPCIONAL)
function DropSystem:CreateVisualDrops(position, drops)
	for _, drop in ipairs(drops) do
		task.spawn(function()
			local dropPart = Instance.new("Part")
			dropPart.Size = Vector3.new(1, 1, 1)
			dropPart.Anchored = true
			dropPart.CanCollide = false
			dropPart.Position = position + Vector3.new(math.random(-3, 3), 2, math.random(-3, 3))
			dropPart.Material = Enum.Material.Neon
			
			-- Cor baseada no tipo
			if drop.Type == "Cash" then
				dropPart.Color = Color3.fromRGB(255, 215, 0) -- Dourado
			elseif drop.Type == "Fragments" then
				dropPart.Color = Color3.fromRGB(150, 0, 255) -- Roxo
			elseif drop.Type == "Weapon" then
				dropPart.Color = UtilityFunctions:GetRarityColor(drop.Item.Rarity)
			elseif drop.Type == "Relic" then
				dropPart.Color = UtilityFunctions:GetRarityColor(drop.Item.Rarity)
			else
				dropPart.Color = Color3.fromRGB(0, 255, 0) -- Verde
			end
			
			dropPart.Parent = workspace
			
			-- Efeito de partículas
			UtilityFunctions:CreateParticleEffect(dropPart, dropPart.Color, 0.5, 1)
			
			-- Animação de rotação
			local rotation = 0
			for i = 1, 30 do
				rotation = rotation + 6
				dropPart.CFrame = dropPart.CFrame * CFrame.Angles(0, math.rad(6), 0)
				task.wait(0.1)
			end
			
			dropPart:Destroy()
		end)
	end
end

-- 🎁 DROP DE RAID/DUNGEON
function DropSystem:ProcessRaidRewards(players, difficulty)
	local config = difficulty == "Raid" and GameConfig.Raids.Rewards or GameConfig.Dungeons.Rewards
	
	for _, player in ipairs(players) do
		-- Cash
		local cash = math.random(config.Cash.Min, config.Cash.Max)
		DataManager:AddResource(player, "Cash", cash)
		
		-- Diamantes
		if config.Diamonds then
			local diamonds = math.random(config.Diamonds.Min, config.Diamonds.Max)
			DataManager:AddResource(player, "Diamonds", diamonds)
		end
		
		-- Fragmentos
		if config.Fragments then
			local fragments = math.random(config.Fragments.Min, config.Fragments.Max)
			DataManager:AddResource(player, "Fragments", fragments)
		end
		
		-- Sombra garantida (Raids)
		if config.GuaranteedShadow then
			local ShadowData = require(ReplicatedStorage.Modules.ShadowData)
			local rareShadow = ShadowData:GetRandomShadowByRank("A") or ShadowData:GetRandomShadowByRank("S")
			if rareShadow then
				local shadowInstance = ShadowData:CreateShadowInstance(rareShadow.ID, 0)
				DataManager:AddShadow(player, shadowInstance)
			end
		end
		
		-- Relíquia épica/lendária
		if math.random() < 0.3 then -- 30% chance
			local epicRelic = RelicData:GetRelicsByRarity("Epic")[1] or RelicData:GetRelicsByRarity("Legendary")[1]
			if epicRelic then
				local relicInstance = RelicData:CreateRelicInstance(epicRelic.ID, 1)
				DataManager:AddItem(player, "Relics", relicInstance)
			end
		end
		
		-- Notificar
		local InventoryEvent = ReplicatedStorage.Events.InventoryEvent
		InventoryEvent:FireClient(player, "RaidRewards", {
			Cash = cash,
			Diamonds = config.Diamonds and math.random(config.Diamonds.Min, config.Diamonds.Max) or 0,
			Fragments = config.Fragments and math.random(config.Fragments.Min, config.Fragments.Max) or 0
		})
	end
end

print("✅ DropSystem inicializado")

return DropSystem
