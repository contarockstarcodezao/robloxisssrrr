--[[
    MainServer.lua - VERSÃO CORRIGIDA
    Script principal do servidor com inicialização ordenada e logs detalhados
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("========================================")
print("🎮 SHADOW HUNTER - VERSÃO CORRIGIDA")
print("========================================")

-- ========================================
-- ETAPA 1: AGUARDA REMOTEEVENTS
-- ========================================

print("[1/9] ⏳ Aguardando RemoteEvents...")
local RemoteEventsModule = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteEvents", 10)

if not RemoteEventsModule then
    error("❌ ERRO CRÍTICO: RemoteEvents não encontrado!")
end

local success, RemoteEvents = pcall(function()
    return require(RemoteEventsModule)
end)

if not success then
    error("❌ ERRO CRÍTICO: Falha ao carregar RemoteEvents: " .. tostring(RemoteEvents))
end

print("[1/9] ✅ RemoteEvents carregado")
wait(0.5)

-- ========================================
-- ETAPA 2: CARREGA MÓDULOS CORE
-- ========================================

print("[2/9] 📦 Carregando módulos Core...")

local DataManager, RankSystem, MissionSystem

-- DataManager
local dmSuccess, dmError = pcall(function()
    DataManager = require(ServerScriptService.Core.DataManager)
end)

if not dmSuccess then
    error("❌ ERRO: Falha ao carregar DataManager: " .. tostring(dmError))
end
print("  ✅ DataManager carregado")

-- RankSystem
local rsSuccess, rsError = pcall(function()
    RankSystem = require(ServerScriptService.Core.RankSystem)
end)

if not rsSuccess then
    error("❌ ERRO: Falha ao carregar RankSystem: " .. tostring(rsError))
end
print("  ✅ RankSystem carregado")

-- MissionSystem
local msSuccess, msError = pcall(function()
    MissionSystem = require(ServerScriptService.Core.MissionSystem)
end)

if not msSuccess then
    error("❌ ERRO: Falha ao carregar MissionSystem: " .. tostring(msError))
end
print("  ✅ MissionSystem carregado")

-- ========================================
-- ETAPA 3: CARREGA MÓDULOS DE COMBATE
-- ========================================

print("[3/9] ⚔️ Carregando módulos de Combate...")

local NPCManager, CombatSystem, ShadowSystem

-- NPCManager
local nmSuccess, nmError = pcall(function()
    NPCManager = require(ServerScriptService.Combat.NPCManager)
end)

if not nmSuccess then
    error("❌ ERRO: Falha ao carregar NPCManager: " .. tostring(nmError))
end
print("  ✅ NPCManager carregado")

-- CombatSystem
local csSuccess, csError = pcall(function()
    CombatSystem = require(ServerScriptService.Combat.CombatSystem)
end)

if not csSuccess then
    error("❌ ERRO: Falha ao carregar CombatSystem: " .. tostring(csError))
end
print("  ✅ CombatSystem carregado")

-- ShadowSystem
local ssSuccess, ssError = pcall(function()
    ShadowSystem = require(ServerScriptService.Combat.ShadowSystem)
end)

if not ssSuccess then
    error("❌ ERRO: Falha ao carregar ShadowSystem: " .. tostring(ssError))
end
print("  ✅ ShadowSystem carregado")

-- ========================================
-- ETAPA 4: CARREGA ZONEMANAGER
-- ========================================

print("[4/9] 🗺️ Carregando ZoneManager...")

local ZoneManager
local zmSuccess, zmError = pcall(function()
    ZoneManager = require(ServerScriptService.Zones.ZoneManager)
end)

if not zmSuccess then
    warn("⚠️ AVISO: ZoneManager não carregado: " .. tostring(zmError))
    print("  ⏭️ Continuando sem ZoneManager")
else
    print("  ✅ ZoneManager carregado")
end

-- ========================================
-- ETAPA 5: INICIALIZA DATAMANAGER
-- ========================================

print("[5/9] 🗄️ Inicializando DataManager...")

local initDM = pcall(function()
    DataManager:Init()
end)

if not initDM then
    error("❌ ERRO CRÍTICO: DataManager falhou ao inicializar")
end

wait(0.5)

-- ========================================
-- ETAPA 6: INICIALIZA RANKSYSTEM
-- ========================================

print("[6/9] 🏆 Inicializando RankSystem...")

local initRS = pcall(function()
    RankSystem:Init(DataManager)
end)

if not initRS then
    error("❌ ERRO CRÍTICO: RankSystem falhou ao inicializar")
end

wait(0.3)

-- ========================================
-- ETAPA 7: INICIALIZA NPCMANAGER E COMBATE
-- ========================================

print("[7/9] ⚔️ Inicializando sistemas de combate...")

-- NPCManager primeiro
local initNM = pcall(function()
    NPCManager:Init()
end)

if not initNM then
    error("❌ ERRO: NPCManager falhou ao inicializar")
end

wait(0.3)

-- MissionSystem
local initMS = pcall(function()
    MissionSystem:Init(DataManager, RankSystem)
end)

if not initMS then
    warn("⚠️ AVISO: MissionSystem falhou ao inicializar")
end

wait(0.3)

-- CombatSystem (⭐ COM TODAS AS DEPENDÊNCIAS)
local initCS = pcall(function()
    CombatSystem:Init(DataManager, NPCManager, RankSystem, MissionSystem)
end)

if not initCS then
    error("❌ ERRO: CombatSystem falhou ao inicializar")
end

wait(0.3)

-- ShadowSystem
local initSS = pcall(function()
    ShadowSystem:Init(DataManager, MissionSystem)
end)

if not initSS then
    warn("⚠️ AVISO: ShadowSystem falhou ao inicializar")
end

wait(0.3)

-- ========================================
-- ETAPA 8: INICIALIZA ZONEMANAGER
-- ========================================

print("[8/9] 🗺️ Inicializando ZoneManager...")

if ZoneManager then
    local initZM = pcall(function()
        ZoneManager:Init(NPCManager, RankSystem)
    end)
    
    if not initZM then
        warn("⚠️ AVISO: ZoneManager falhou ao inicializar")
    end
else
    print("  ⏭️ ZoneManager não disponível")
end

wait(0.3)

-- ========================================
-- ETAPA 9: MENSAGEM DE BOAS-VINDAS
-- ========================================

print("[9/9] 👋 Configurando mensagem de boas-vindas...")

game.Players.PlayerAdded:Connect(function(player)
    wait(2)
    
    local showNotif = RemoteEvents and RemoteEvents.ShowNotification
    if showNotif then
        showNotif:FireClient(
            player,
            "🎮 Bem-vindo ao Shadow Hunter! 🎮",
            "Derrote NPCs, capture sombras e torne-se o mais forte!",
            Color3.fromRGB(255, 215, 0)
        )
    end
end)

-- ========================================
-- FINALIZAÇÃO
-- ========================================

print("========================================")
print("✅ SHADOW HUNTER INICIALIZADO COM SUCESSO!")
print("========================================")
print("")
print("📊 Status dos Sistemas:")
print("  ✅ DataManager")
print("  ✅ RankSystem")
print("  " .. (initMS and "✅" or "⚠️") .. " MissionSystem")
print("  ✅ NPCManager")
print("  ✅ CombatSystem")
print("  " .. (initSS and "✅" or "⚠️") .. " ShadowSystem")
print("  " .. (ZoneManager and "✅" or "⏭️") .. " ZoneManager")
print("")
print("🎮 O jogo está pronto para jogar!")
print("========================================")

-- Exporta para acesso global (opcional)
_G.ShadowHunter = {
    DataManager = DataManager,
    RankSystem = RankSystem,
    MissionSystem = MissionSystem,
    NPCManager = NPCManager,
    CombatSystem = CombatSystem,
    ShadowSystem = ShadowSystem,
    ZoneManager = ZoneManager,
}

return true
