-- ReplicatedStorage/Events/RemoteEventsSetup
-- Cria todos os RemoteEvents e RemoteFunctions

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEvents = {}

-- Cria pasta para organizar
local EventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not EventsFolder then
	EventsFolder = Instance.new("Folder")
	EventsFolder.Name = "Events"
	EventsFolder.Parent = ReplicatedStorage
end

-- Função helper para criar remotes
local function CreateRemote(name, remoteType)
	local existing = EventsFolder:FindFirstChild(name)
	if existing then return existing end
	
	local remote
	if remoteType == "Event" then
		remote = Instance.new("RemoteEvent")
	else
		remote = Instance.new("RemoteFunction")
	end
	
	remote.Name = name
	remote.Parent = EventsFolder
	return remote
end

-- ⚔️ COMBATE
RemoteEvents.CombatAttack = CreateRemote("CombatAttack", "Event")
RemoteEvents.ShadowAttack = CreateRemote("ShadowAttack", "Event")
RemoteEvents.CombatFeedback = CreateRemote("CombatFeedback", "Event")

-- 🧞 SOMBRAS
RemoteEvents.CaptureShadow = CreateRemote("CaptureShadow", "Event")
RemoteEvents.EquipShadow = CreateRemote("EquipShadow", "Event")
RemoteEvents.UnequipShadow = CreateRemote("UnequipShadow", "Event")
RemoteEvents.EvolveShadow = CreateRemote("EvolveShadow", "Event")
RemoteEvents.ShadowUpdate = CreateRemote("ShadowUpdate", "Event")

-- 🎒 INVENTÁRIO
RemoteEvents.EquipWeapon = CreateRemote("EquipWeapon", "Event")
RemoteEvents.SellItem = CreateRemote("SellItem", "Event")
RemoteEvents.InventoryUpdate = CreateRemote("InventoryUpdate", "Event")

-- 🏪 LOJA
RemoteEvents.PurchaseItem = CreateRemote("PurchaseItem", "Event")
RemoteEvents.PurchaseSuccess = CreateRemote("PurchaseSuccess", "Event")

-- 🏰 DUNGEONS
RemoteEvents.EnterDungeon = CreateRemote("EnterDungeon", "Event")
RemoteEvents.ExitDungeon = CreateRemote("ExitDungeon", "Event")
RemoteEvents.DungeonComplete = CreateRemote("DungeonComplete", "Event")

-- 📊 DADOS DO JOGADOR
RemoteEvents.RequestPlayerData = CreateRemote("RequestPlayerData", "Function")
RemoteEvents.DataUpdate = CreateRemote("DataUpdate", "Event")

-- 📈 RANKING
RemoteEvents.RequestRanking = CreateRemote("RequestRanking", "Function")
RemoteEvents.RankingUpdate = CreateRemote("RankingUpdate", "Event")

-- 🏆 TÍTULOS
RemoteEvents.EquipTitle = CreateRemote("EquipTitle", "Event")
RemoteEvents.TitleUnlocked = CreateRemote("TitleUnlocked", "Event")

-- 👥 GUILDAS
RemoteEvents.CreateGuild = CreateRemote("CreateGuild", "Event")
RemoteEvents.JoinGuild = CreateRemote("JoinGuild", "Event")
RemoteEvents.LeaveGuild = CreateRemote("LeaveGuild", "Event")
RemoteEvents.GuildUpdate = CreateRemote("GuildUpdate", "Event")

-- 📋 MISSÕES
RemoteEvents.ClaimMissionReward = CreateRemote("ClaimMissionReward", "Event")
RemoteEvents.MissionUpdate = CreateRemote("MissionUpdate", "Event")

-- 🎰 SORTEIOS
RemoteEvents.SpinRaffle = CreateRemote("SpinRaffle", "Event")
RemoteEvents.RaffleResult = CreateRemote("RaffleResult", "Event")

-- 📊 PONTOS DE STATUS
RemoteEvents.AllocateStatusPoint = CreateRemote("AllocateStatusPoint", "Event")
RemoteEvents.ResetStatusPoints = CreateRemote("ResetStatusPoints", "Event")

-- 🔔 NOTIFICAÇÕES
RemoteEvents.ShowNotification = CreateRemote("ShowNotification", "Event")

print("✅ RemoteEvents configurados!")

return RemoteEvents
