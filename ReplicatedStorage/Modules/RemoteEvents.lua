-- ReplicatedStorage/Modules/RemoteEvents
-- Centraliza todos os RemoteEvents e RemoteFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = {}

-- Cria pasta para organizar
local RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not RemotesFolder then
	RemotesFolder = Instance.new("Folder")
	RemotesFolder.Name = "Remotes"
	RemotesFolder.Parent = ReplicatedStorage
end

-- 🔧 FUNÇÃO HELPER PARA CRIAR REMOTES
local function CreateRemote(name, remoteType)
	local existing = RemotesFolder:FindFirstChild(name)
	if existing then return existing end
	
	local remote
	if remoteType == "Event" then
		remote = Instance.new("RemoteEvent")
	else
		remote = Instance.new("RemoteFunction")
	end
	
	remote.Name = name
	remote.Parent = RemotesFolder
	return remote
end

-- ⚔️ COMBATE
RemoteEvents.AttackEvent = CreateRemote("AttackEvent", "Event")
RemoteEvents.AttackFeedback = CreateRemote("AttackFeedback", "Event")

-- 📊 DADOS DO JOGADOR
RemoteEvents.RequestData = CreateRemote("RequestData", "Function")
RemoteEvents.DataUpdate = CreateRemote("DataUpdate", "Event")

-- 🎒 INVENTÁRIO
RemoteEvents.EquipItem = CreateRemote("EquipItem", "Event")
RemoteEvents.UnequipItem = CreateRemote("UnequipItem", "Event")

-- 🏆 CONQUISTAS
RemoteEvents.AchievementUnlocked = CreateRemote("AchievementUnlocked", "Event")

-- 🧞‍♂️ SOMBRAS
RemoteEvents.InvokeShadow = CreateRemote("InvokeShadow", "Event")
RemoteEvents.DismissShadow = CreateRemote("DismissShadow", "Event")

-- 🎨 UI
RemoteEvents.ToggleUI = CreateRemote("ToggleUI", "Event")

return RemoteEvents
