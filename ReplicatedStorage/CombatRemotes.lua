-- ReplicatedStorage/CombatRemotes
-- Este módulo cria e organiza todos os RemoteEvents para o sistema de combate

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cria uma pasta para organizar os RemoteEvents
local CombatFolder = ReplicatedStorage:FindFirstChild("CombatSystem")
if not CombatFolder then
	CombatFolder = Instance.new("Folder")
	CombatFolder.Name = "CombatSystem"
	CombatFolder.Parent = ReplicatedStorage
end

-- RemoteEvent para processar ataques
local AttackEvent = CombatFolder:FindFirstChild("AttackEvent")
if not AttackEvent then
	AttackEvent = Instance.new("RemoteEvent")
	AttackEvent.Name = "AttackEvent"
	AttackEvent.Parent = CombatFolder
end

-- RemoteEvent para atualizar XP e moedas no cliente
local RewardUpdate = CombatFolder:FindFirstChild("RewardUpdate")
if not RewardUpdate then
	RewardUpdate = Instance.new("RemoteEvent")
	RewardUpdate.Name = "RewardUpdate"
	RewardUpdate.Parent = CombatFolder
end

-- RemoteEvent para feedback visual de ataque
local AttackFeedback = CombatFolder:FindFirstChild("AttackFeedback")
if not AttackFeedback then
	AttackFeedback = Instance.new("RemoteEvent")
	AttackFeedback.Name = "AttackFeedback"
	AttackFeedback.Parent = CombatFolder
end

return {
	AttackEvent = AttackEvent,
	RewardUpdate = RewardUpdate,
	AttackFeedback = AttackFeedback
}
