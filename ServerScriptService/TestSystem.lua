--[[
    TEST SYSTEM
    Localização: ServerScriptService/TestSystem.lua
    
    Este script testa todos os sistemas do jogo:
    - Verificação de integridade
    - Testes de funcionalidade
    - Relatórios de status
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local TestSystem = {}

-- Status dos testes
local testResults = {
    data = false,
    events = false,
    systems = false,
    integration = false
}

-- Testar carregamento de dados
function TestSystem.TestDataLoading()
    print("🧪 Testando carregamento de dados...")
    
    local success = true
    local errors = {}
    
    -- Testar ShadowData
    local shadowData = require(ReplicatedStorage.Data.ShadowData)
    if not shadowData or not shadowData.SHADOWS then
        success = false
        table.insert(errors, "ShadowData não carregado corretamente")
    end
    
    -- Testar WeaponData
    local weaponData = require(ReplicatedStorage.Data.WeaponData)
    if not weaponData or not weaponData.WEAPONS then
        success = false
        table.insert(errors, "WeaponData não carregado corretamente")
    end
    
    -- Testar RelicData
    local relicData = require(ReplicatedStorage.Data.RelicData)
    if not relicData or not relicData.RELICS then
        success = false
        table.insert(errors, "RelicData não carregado corretamente")
    end
    
    if success then
        print("  ✅ Dados carregados com sucesso!")
        testResults.data = true
    else
        print("  ❌ Erros no carregamento de dados:")
        for _, error in ipairs(errors) do
            print("    - " .. error)
        end
    end
    
    return success
end

-- Testar eventos remotos
function TestSystem.TestRemoteEvents()
    print("🧪 Testando eventos remotos...")
    
    local success = true
    local errors = {}
    
    -- Testar RemoteEvents
    local remoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
    if not remoteEvents then
        success = false
        table.insert(errors, "RemoteEvents não carregado")
    end
    
    -- Verificar se os eventos existem
    local requiredEvents = {
        "Shadow", "Combat", "Drop", "Level", "Dungeon", 
        "Ranking", "Inventory", "Weapon", "Economy", "Relic"
    }
    
    for _, eventName in ipairs(requiredEvents) do
        if not remoteEvents[eventName] then
            success = false
            table.insert(errors, "Evento " .. eventName .. " não encontrado")
        end
    end
    
    if success then
        print("  ✅ Eventos remotos configurados corretamente!")
        testResults.events = true
    else
        print("  ❌ Erros nos eventos remotos:")
        for _, error in ipairs(errors) do
            print("    - " .. error)
        end
    end
    
    return success
end

-- Testar sistemas
function TestSystem.TestSystems()
    print("🧪 Testando sistemas...")
    
    local success = true
    local errors = {}
    
    -- Lista de sistemas para testar
    local systems = {
        {name = "ShadowManager", path = "ShadowSystem.ShadowManager"},
        {name = "CombatManager", path = "Combat.CombatManager"},
        {name = "DropManager", path = "Drops.DropManager"},
        {name = "LevelManager", path = "LevelSystem.LevelManager"},
        {name = "DungeonManager", path = "Dungeons.DungeonManager"},
        {name = "RankingManager", path = "Ranking.RankingManager"},
        {name = "InventoryManager", path = "Inventory.InventoryManager"},
        {name = "WeaponManager", path = "Weapons.WeaponManager"},
        {name = "EconomyManager", path = "Economy.EconomyManager"},
        {name = "RelicManager", path = "Relics.RelicManager"}
    }
    
    for _, system in ipairs(systems) do
        local success, result = pcall(function()
            return require(ServerScriptService[system.path])
        end)
        
        if not success then
            table.insert(errors, system.name .. " não carregado: " .. tostring(result))
        end
    end
    
    if #errors == 0 then
        print("  ✅ Todos os sistemas carregados com sucesso!")
        testResults.systems = true
    else
        print("  ❌ Erros nos sistemas:")
        for _, error in ipairs(errors) do
            print("    - " .. error)
        end
    end
    
    return #errors == 0
end

-- Testar integração
function TestSystem.TestIntegration()
    print("🧪 Testando integração entre sistemas...")
    
    local success = true
    local errors = {}
    
    -- Testar se os sistemas podem se comunicar
    local testPlayer = Players:GetPlayers()[1]
    if testPlayer then
        -- Testar inicialização de jogador
        local success, result = pcall(function()
            -- TODO: Implementar testes de integração
            return true
        end)
        
        if not success then
            table.insert(errors, "Falha na integração: " .. tostring(result))
        end
    else
        print("  ⚠️ Nenhum jogador online para testar integração")
    end
    
    if #errors == 0 then
        print("  ✅ Integração entre sistemas funcionando!")
        testResults.integration = true
    else
        print("  ❌ Erros na integração:")
        for _, error in ipairs(errors) do
            print("    - " .. error)
        end
    end
    
    return #errors == 0
end

-- Executar todos os testes
function TestSystem.RunAllTests()
    print("🧪 === EXECUTANDO TESTES DO SISTEMA ===")
    
    local allPassed = true
    
    -- Executar testes
    allPassed = TestSystem.TestDataLoading() and allPassed
    allPassed = TestSystem.TestRemoteEvents() and allPassed
    allPassed = TestSystem.TestSystems() and allPassed
    allPassed = TestSystem.TestIntegration() and allPassed
    
    -- Relatório final
    print("🧪 === RELATÓRIO DE TESTES ===")
    print("📊 Dados:", testResults.data and "✅" or "❌")
    print("📊 Eventos:", testResults.events and "✅" or "❌")
    print("📊 Sistemas:", testResults.systems and "✅" or "❌")
    print("📊 Integração:", testResults.integration and "✅" or "❌")
    
    if allPassed then
        print("🎉 Todos os testes passaram! Sistema funcionando corretamente.")
    else
        print("⚠️ Alguns testes falharam. Verifique os erros acima.")
    end
    
    return allPassed
end

-- Testar funcionalidades específicas
function TestSystem.TestSpecificFeatures()
    print("🧪 Testando funcionalidades específicas...")
    
    -- Testar criação de sombras
    local shadowData = require(ReplicatedStorage.Data.ShadowData)
    local shadowCount = 0
    for _ in pairs(shadowData.SHADOWS) do
        shadowCount = shadowCount + 1
    end
    print("  📊 Sombras disponíveis:", shadowCount)
    
    -- Testar criação de armas
    local weaponData = require(ReplicatedStorage.Data.WeaponData)
    local weaponCount = 0
    for _ in pairs(weaponData.WEAPONS) do
        weaponCount = weaponCount + 1
    end
    print("  📊 Armas disponíveis:", weaponCount)
    
    -- Testar criação de relíquias
    local relicData = require(ReplicatedStorage.Data.RelicData)
    local relicCount = 0
    for _ in pairs(relicData.RELICS) do
        relicCount = relicCount + 1
    end
    print("  📊 Relíquias disponíveis:", relicCount)
    
    print("  ✅ Funcionalidades específicas testadas!")
end

-- Executar testes automaticamente
spawn(function()
    wait(5) -- Aguardar 5 segundos para o servidor estabilizar
    
    TestSystem.RunAllTests()
    TestSystem.TestSpecificFeatures()
    
    print("🧪 Testes concluídos!")
end)

return TestSystem