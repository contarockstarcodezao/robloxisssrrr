-- ServerScriptService/Core/ServerMain
-- Cole este script como Script dentro de ServerScriptService/Core/

print("🎮 Iniciando Arise Crossover Server...")

-- Require de todos os sistemas
local ServerScriptService = game:GetService("ServerScriptService")

-- Core
local DataManager = require(ServerScriptService.Core.DataManager)

-- Systems
local CombatSystem = require(ServerScriptService.Systems.CombatSystem)
local ShadowSystem = require(ServerScriptService.Systems.ShadowSystem)
local DropSystem = require(ServerScriptService.Systems.DropSystem)
local XPSystem = require(ServerScriptService.Systems.XPSystem)
local DungeonSystem = require(ServerScriptService.Systems.DungeonSystem)
local RankingSystem = require(ServerScriptService.Systems.RankingSystem)
local NPCManager = require(ServerScriptService.Systems.NPCManager)

print("✅ Todos os sistemas carregados com sucesso!")
print("🎮 Arise Crossover Server está pronto!")
