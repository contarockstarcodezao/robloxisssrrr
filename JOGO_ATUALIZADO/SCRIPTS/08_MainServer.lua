--[[
    MainServer.lua
    Cole em: ServerScriptService/MainServer (Script)
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("═══════════════════════════════════════")
print("🎮 SHADOW HUNTER - INICIANDO")
print("═══════════════════════════════════════")

wait(1)

local DataManager = require(ServerScriptService.Core.DataManager)
local NPCManager = require(ServerScriptService.Combat.NPCManager)
local CombatSystem = require(ServerScriptService.Combat.CombatSystem)

DataManager:Init()
wait(0.5)

NPCManager:Init()
wait(0.5)

CombatSystem:Init(DataManager, NPCManager)
wait(0.5)

-- Spawna alguns NPCs de teste
local spawnPoints = {
    Vector3.new(0, 5, 20),
    Vector3.new(10, 5, 20),
    Vector3.new(-10, 5, 20),
    Vector3.new(0, 5, 30),
    Vector3.new(15, 5, 25)
}

for _, pos in ipairs(spawnPoints) do
    NPCManager:SpawnNPC("Goblin Fraco", pos, "BeginnerZone")
end

print("═══════════════════════════════════════")
print("✅ SHADOW HUNTER INICIALIZADO!")
print("═══════════════════════════════════════")
print("")
print("📊 NPCs Spawnados: 5 Goblin Fraco")
print("🎮 Jogo pronto para jogar!")
print("═══════════════════════════════════════")

_G.ShadowHunter = {
    DataManager = DataManager,
    NPCManager = NPCManager,
    CombatSystem = CombatSystem,
}
