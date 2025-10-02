--[[
    SETUP_COMMAND.lua
    
    COMO USAR:
    1. Abra Roblox Studio
    2. Vá em "View" -> "Command Bar" (ou pressione Ctrl+Shift+X)
    3. Cole TODO este código na Command Bar
    4. Pressione Enter
    5. Aguarde a mensagem "Setup completo!"
    
    Este script irá criar automaticamente toda a estrutura do jogo Shadow Hunter
]]

-- Função para criar arquivos remotamente
local function CreateStructure()
    print("=== Iniciando Setup do Shadow Hunter ===")
    
    -- URLs dos arquivos no GitHub (você precisará hospedar os arquivos)
    -- Por enquanto, vamos criar a estrutura básica
    
    -- Criar pastas principais
    local ServerScriptService = game:GetService("ServerScriptService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local StarterPlayer = game:GetService("StarterPlayer")
    local StarterGui = game:GetService("StarterGui")
    
    -- ReplicatedStorage
    local rsModules = Instance.new("Folder")
    rsModules.Name = "Modules"
    rsModules.Parent = ReplicatedStorage
    
    local rsEvents = Instance.new("Folder")
    rsEvents.Name = "Events"
    rsEvents.Parent = ReplicatedStorage
    
    -- ServerScriptService
    local ssCore = Instance.new("Folder")
    ssCore.Name = "Core"
    ssCore.Parent = ServerScriptService
    
    local ssCombat = Instance.new("Folder")
    ssCombat.Name = "Combat"
    ssCombat.Parent = ServerScriptService
    
    local ssZones = Instance.new("Folder")
    ssZones.Name = "Zones"
    ssZones.Parent = ServerScriptService
    
    local ssEconomy = Instance.new("Folder")
    ssEconomy.Name = "Economy"
    ssEconomy.Parent = ServerScriptService
    
    -- StarterPlayer
    local starterPlayerScripts = StarterPlayer:FindFirstChild("StarterPlayerScripts")
    if not starterPlayerScripts then
        starterPlayerScripts = Instance.new("Folder")
        starterPlayerScripts.Name = "StarterPlayerScripts"
        starterPlayerScripts.Parent = StarterPlayer
    end
    
    local spClient = Instance.new("Folder")
    spClient.Name = "Client"
    spClient.Parent = starterPlayerScripts
    
    local spUI = Instance.new("Folder")
    spUI.Name = "UI"
    spUI.Parent = starterPlayerScripts
    
    -- Workspace
    local workspace = game:GetService("Workspace")
    
    local zonesFolder = Instance.new("Folder")
    zonesFolder.Name = "Zones"
    zonesFolder.Parent = workspace
    
    local npcsFolder = Instance.new("Folder")
    npcsFolder.Name = "NPCs"
    npcsFolder.Parent = workspace
    
    print("✅ Estrutura de pastas criada!")
    print("")
    print("=== PRÓXIMOS PASSOS ===")
    print("1. Copie os arquivos .lua da pasta do projeto para as pastas correspondentes no Roblox Studio")
    print("2. Os arquivos devem ser do tipo 'Script' para servidor e 'LocalScript' para cliente")
    print("")
    print("📂 Estrutura criada:")
    print("   - ReplicatedStorage/Modules (RankData, NPCData, ShadowData)")
    print("   - ReplicatedStorage/Events (RemoteEvents)")
    print("   - ServerScriptService/Core (DataManager, RankSystem, MissionSystem)")
    print("   - ServerScriptService/Combat (NPCManager, CombatSystem, ShadowSystem)")
    print("   - ServerScriptService/Zones (ZoneManager)")
    print("   - StarterPlayer/StarterPlayerScripts/Client (CombatClient, ShadowClient)")
    print("   - StarterPlayer/StarterPlayerScripts/UI (HUDController)")
    print("")
    print("=== Setup Completo! ===")
end

-- Executa
CreateStructure()
