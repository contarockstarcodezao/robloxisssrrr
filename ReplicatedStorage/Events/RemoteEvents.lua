--[[
    REMOTE EVENTS MODULE
    Localização: ReplicatedStorage/Events/RemoteEvents.lua
    
    Este módulo contém todos os RemoteEvents e RemoteFunctions
    para comunicação entre cliente e servidor
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Criar pasta de eventos se não existir
local EventsFolder = ReplicatedStorage:FindFirstChild("Events")
if not EventsFolder then
    EventsFolder = Instance.new("Folder")
    EventsFolder.Name = "Events"
    EventsFolder.Parent = ReplicatedStorage
end

-- Sistema de Sombras
local ShadowEvents = {
    -- Captura de sombras
    CaptureShadow = Instance.new("RemoteEvent"),
    ShadowCaptured = Instance.new("RemoteEvent"),
    
    -- Invocação de sombras
    SummonShadow = Instance.new("RemoteEvent"),
    ShadowSummoned = Instance.new("RemoteEvent"),
    DismissShadow = Instance.new("RemoteEvent"),
    
    -- Evolução de sombras
    EvolveShadow = Instance.new("RemoteEvent"),
    ShadowEvolved = Instance.new("RemoteEvent"),
    
    -- Gerenciamento de sombras
    GetShadowInventory = Instance.new("RemoteFunction"),
    UpdateShadowStats = Instance.new("RemoteEvent")
}

-- Sistema de Combate
local CombatEvents = {
    -- Ataques
    PlayerAttack = Instance.new("RemoteEvent"),
    ShadowAttack = Instance.new("RemoteEvent"),
    
    -- Dano
    DealDamage = Instance.new("RemoteEvent"),
    TakeDamage = Instance.new("RemoteEvent"),
    
    -- Status
    UpdateHealth = Instance.new("RemoteEvent"),
    UpdateMana = Instance.new("RemoteEvent")
}

-- Sistema de Drops
local DropEvents = {
    -- Coleta de drops
    CollectDrop = Instance.new("RemoteEvent"),
    DropCollected = Instance.new("RemoteEvent"),
    
    -- Geração de drops
    GenerateDrop = Instance.new("RemoteEvent"),
    DropGenerated = Instance.new("RemoteEvent")
}

-- Sistema de XP e Nível
local LevelEvents = {
    -- Progressão
    GainXP = Instance.new("RemoteEvent"),
    LevelUp = Instance.new("RemoteEvent"),
    
    -- Status
    UpdateLevel = Instance.new("RemoteEvent"),
    UpdateXP = Instance.new("RemoteEvent")
}

-- Sistema de Dungeons e Raids
local DungeonEvents = {
    -- Dungeons
    EnterDungeon = Instance.new("RemoteEvent"),
    ExitDungeon = Instance.new("RemoteEvent"),
    DungeonCompleted = Instance.new("RemoteEvent"),
    
    -- Raids
    JoinRaid = Instance.new("RemoteEvent"),
    LeaveRaid = Instance.new("RemoteEvent"),
    RaidCompleted = Instance.new("RemoteEvent"),
    
    -- Matchmaking
    FindRaid = Instance.new("RemoteFunction"),
    RaidFound = Instance.new("RemoteEvent")
}

-- Sistema de Ranking
local RankingEvents = {
    -- Atualização de ranking
    UpdateRanking = Instance.new("RemoteEvent"),
    RankingUpdated = Instance.new("RemoteEvent"),
    
    -- Leaderboard
    GetLeaderboard = Instance.new("RemoteFunction"),
    LeaderboardUpdated = Instance.new("RemoteEvent")
}

-- Sistema de Inventário
local InventoryEvents = {
    -- Gerenciamento de itens
    AddItem = Instance.new("RemoteEvent"),
    RemoveItem = Instance.new("RemoteEvent"),
    UseItem = Instance.new("RemoteEvent"),
    
    -- Expansão de inventário
    ExpandInventory = Instance.new("RemoteEvent"),
    InventoryExpanded = Instance.new("RemoteEvent"),
    
    -- Organização
    SortInventory = Instance.new("RemoteEvent"),
    FilterInventory = Instance.new("RemoteEvent")
}

-- Sistema de Armas
local WeaponEvents = {
    -- Equipamento
    EquipWeapon = Instance.new("RemoteEvent"),
    WeaponEquipped = Instance.new("RemoteEvent"),
    UnequipWeapon = Instance.new("RemoteEvent"),
    
    -- Forja
    ForgeWeapon = Instance.new("RemoteEvent"),
    WeaponForged = Instance.new("RemoteEvent"),
    
    -- Fusão
    FuseWeapons = Instance.new("RemoteEvent"),
    WeaponsFused = Instance.new("RemoteEvent")
}

-- Sistema de Economia
local EconomyEvents = {
    -- Moedas
    AddCash = Instance.new("RemoteEvent"),
    RemoveCash = Instance.new("RemoteEvent"),
    AddDiamonds = Instance.new("RemoteEvent"),
    RemoveDiamonds = Instance.new("RemoteEvent"),
    
    -- Transações
    PurchaseItem = Instance.new("RemoteEvent"),
    ItemPurchased = Instance.new("RemoteEvent"),
    SellItem = Instance.new("RemoteEvent"),
    ItemSold = Instance.new("RemoteEvent")
}

-- Sistema de Relíquias
local RelicEvents = {
    -- Equipamento
    EquipRelic = Instance.new("RemoteEvent"),
    RelicEquipped = Instance.new("RemoteEvent"),
    UnequipRelic = Instance.new("RemoteEvent"),
    
    -- Fusão
    FuseRelics = Instance.new("RemoteEvent"),
    RelicsFused = Instance.new("RemoteEvent")
}

-- Função para configurar eventos
local function setupEvents(events, folderName)
    local folder = EventsFolder:FindFirstChild(folderName)
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = folderName
        folder.Parent = EventsFolder
    end
    
    for name, event in pairs(events) do
        event.Name = name
        event.Parent = folder
    end
end

-- Configurar todos os eventos
setupEvents(ShadowEvents, "Shadow")
setupEvents(CombatEvents, "Combat")
setupEvents(DropEvents, "Drop")
setupEvents(LevelEvents, "Level")
setupEvents(DungeonEvents, "Dungeon")
setupEvents(RankingEvents, "Ranking")
setupEvents(InventoryEvents, "Inventory")
setupEvents(WeaponEvents, "Weapon")
setupEvents(EconomyEvents, "Economy")
setupEvents(RelicEvents, "Relic")

-- Exportar eventos para uso em outros scripts
local RemoteEvents = {
    Shadow = ShadowEvents,
    Combat = CombatEvents,
    Drop = DropEvents,
    Level = LevelEvents,
    Dungeon = DungeonEvents,
    Ranking = RankingEvents,
    Inventory = InventoryEvents,
    Weapon = WeaponEvents,
    Economy = EconomyEvents,
    Relic = RelicEvents
}

return RemoteEvents