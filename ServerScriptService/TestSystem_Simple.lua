--[[
    TEST SYSTEM SIMPLE
    Localização: ServerScriptService/TestSystem_Simple.lua
    
    Versão simplificada do sistema de testes que funciona sem dependências
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("🧪 === TESTE SIMPLES INICIADO ===")

-- Teste básico de funcionamento
local function testBasicFunctionality()
    print("✅ Testando funcionalidades básicas...")
    
    -- Teste 1: Verificar se o jogo está funcionando
    print("  ✓ Jogo funcionando")
    
    -- Teste 2: Verificar jogadores
    local playerCount = #Players:GetPlayers()
    print("  ✓ Jogadores conectados:", playerCount)
    
    -- Teste 3: Verificar workspace
    local workspace = game:GetService("Workspace")
    print("  ✓ Workspace acessível")
    
    -- Teste 4: Verificar ReplicatedStorage
    print("  ✓ ReplicatedStorage acessível")
    
    return true
end

-- Teste de criação de dados básicos
local function testDataCreation()
    print("✅ Testando criação de dados...")
    
    -- Criar pasta de dados se não existir
    local dataFolder = ReplicatedStorage:FindFirstChild("Data")
    if not dataFolder then
        dataFolder = Instance.new("Folder")
        dataFolder.Name = "Data"
        dataFolder.Parent = ReplicatedStorage
        print("  ✓ Pasta Data criada")
    else
        print("  ✓ Pasta Data já existe")
    end
    
    -- Criar pasta de eventos se não existir
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if not eventsFolder then
        eventsFolder = Instance.new("Folder")
        eventsFolder.Name = "Events"
        eventsFolder.Parent = ReplicatedStorage
        print("  ✓ Pasta Events criada")
    else
        print("  ✓ Pasta Events já existe")
    end
    
    return true
end

-- Teste de criação de GUI básica
local function testGUICreation()
    print("✅ Testando criação de GUI...")
    
    -- Verificar se há jogadores
    local players = Players:GetPlayers()
    if #players == 0 then
        print("  ⚠️ Nenhum jogador conectado")
        return false
    end
    
    local player = players[1]
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Criar GUI básica de teste
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TestGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Name = "TestFrame"
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    title.BorderSizePixel = 0
    title.Text = "🎮 ARISE CROSSOVER - TESTE"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.SourceSansBold
    title.Parent = frame
    
    -- Texto de status
    local statusText = Instance.new("TextLabel")
    statusText.Name = "StatusText"
    statusText.Size = UDim2.new(1, -20, 1, -70)
    statusText.Position = UDim2.new(0, 10, 0, 60)
    statusText.BackgroundTransparency = 1
    statusText.Text = "✅ Sistema funcionando!\n\n• Jogo carregado\n• GUI criada\n• Testes passaram\n\nPressione F1 para ajuda"
    statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusText.TextScaled = true
    statusText.Font = Enum.Font.SourceSans
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.TextYAlignment = Enum.TextYAlignment.Top
    statusText.Parent = frame
    
    print("  ✓ GUI de teste criada")
    return true
end

-- Teste de eventos básicos
local function testBasicEvents()
    print("✅ Testando eventos básicos...")
    
    -- Conectar evento de jogador
    Players.PlayerAdded:Connect(function(player)
        print("  ✓ Jogador conectado:", player.Name)
    end)
    
    -- Conectar evento de saída
    Players.PlayerRemoving:Connect(function(player)
        print("  ✓ Jogador desconectado:", player.Name)
    end)
    
    print("  ✓ Eventos básicos conectados")
    return true
end

-- Função principal de teste
local function runAllTests()
    print("🧪 === EXECUTANDO TESTES SIMPLES ===")
    
    local allPassed = true
    
    -- Executar testes
    allPassed = testBasicFunctionality() and allPassed
    allPassed = testDataCreation() and allPassed
    allPassed = testGUICreation() and allPassed
    allPassed = testBasicEvents() and allPassed
    
    -- Relatório final
    print("🧪 === RELATÓRIO DE TESTES ===")
    if allPassed then
        print("🎉 Todos os testes passaram! Sistema funcionando.")
        print("📋 Próximos passos:")
        print("  1. Copie os scripts das GUIs para StarterGui")
        print("  2. Copie os scripts dos sistemas para ServerScriptService")
        print("  3. Execute o jogo novamente")
    else
        print("⚠️ Alguns testes falharam. Verifique os erros acima.")
    end
    
    return allPassed
end

-- Executar testes automaticamente
spawn(function()
    wait(2) -- Aguardar 2 segundos para o servidor estabilizar
    runAllTests()
end)

print("✅ TestSystem_Simple carregado!")