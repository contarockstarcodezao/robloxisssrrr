--[[
    INTERFACE MANAGER - Gerenciador de Interfaces
    Framework completo e funcional para Arise Crossover
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("🎮 Criando gerenciador de interfaces...")

-- Estado das interfaces
local interfaceState = {
    mainInterface = true,
    inventorySystem = false,
    shadowSystem = false,
    combatSystem = true
}

-- Sistema de notificações centralizado
local notificationFrame = Instance.new("Frame")
notificationFrame.Name = "NotificationFrame"
notificationFrame.Size = UDim2.new(0, 400, 0, 60)
notificationFrame.Position = UDim2.new(1, -420, 0, 100)
notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
notificationFrame.BorderSizePixel = 0
notificationFrame.Visible = false
notificationFrame.Parent = playerGui

local notificationBorder = Instance.new("Frame")
notificationBorder.Name = "NotificationBorder"
notificationBorder.Size = UDim2.new(1, 4, 1, 4)
notificationBorder.Position = UDim2.new(0, -2, 0, -2)
notificationBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notificationBorder.BorderSizePixel = 0
notificationBorder.Parent = notificationFrame

local notificationText = Instance.new("TextLabel")
notificationText.Name = "NotificationText"
notificationText.Size = UDim2.new(1, -20, 1, 0)
notificationText.Position = UDim2.new(0, 10, 0, 0)
notificationText.BackgroundTransparency = 1
notificationText.Text = "Notificação de teste"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.TextScaled = true
notificationText.Font = Enum.Font.SourceSansBold
notificationText.TextXAlignment = Enum.TextXAlignment.Left
notificationText.Parent = notificationFrame

-- Função para mostrar notificação
local function showNotification(text, duration)
    duration = duration or 3
    
    notificationText.Text = text
    notificationFrame.Visible = true
    
    -- Animação de entrada
    notificationFrame.Position = UDim2.new(1, -420, 0, 100)
    local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Position = UDim2.new(1, -420, 0, 100)
    })
    tween:Play()
    
    -- Auto-fechar
    spawn(function()
        wait(duration)
        local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1, 0, 0, 100)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            notificationFrame.Visible = false
        end)
    end)
end

-- Função para alternar interface
local function toggleInterface(interfaceName)
    if interfaceState[interfaceName] ~= nil then
        interfaceState[interfaceName] = not interfaceState[interfaceName]
        
        -- Atualizar interface correspondente
        if interfaceName == "inventorySystem" then
            if _G.toggleInventory then
                _G.toggleInventory()
            end
        elseif interfaceName == "shadowSystem" then
            if _G.toggleShadowGUI then
                _G.toggleShadowGUI()
            end
        end
        
        return interfaceState[interfaceName]
    end
    return false
end

-- Função para fechar todas as interfaces
local function closeAllInterfaces()
    interfaceState.inventorySystem = false
    interfaceState.shadowSystem = false
    
    -- Fechar todas as interfaces
    if _G.toggleInventory then _G.toggleInventory() end
    if _G.toggleShadowGUI then _G.toggleShadowGUI() end
end

-- Conectar atalhos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I then
        -- Inventário
        toggleInterface("inventorySystem")
        showNotification("📦 Abrindo inventário...", 2)
    elseif input.KeyCode == Enum.KeyCode.S then
        -- Sombras
        toggleInterface("shadowSystem")
        showNotification("👻 Abrindo sistema de sombras...", 2)
    elseif input.KeyCode == Enum.KeyCode.W then
        -- Armas
        showNotification("⚔️ Sistema de armas em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Relíquias
        showNotification("💎 Sistema de relíquias em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.D then
        -- Dungeons
        showNotification("🏰 Sistema de dungeons em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.L then
        -- Ranking
        showNotification("🏆 Sistema de ranking em desenvolvimento...", 2)
    elseif input.KeyCode == Enum.KeyCode.Escape then
        -- Fechar todas as interfaces
        closeAllInterfaces()
        showNotification("❌ Fechando todas as interfaces...", 2)
    elseif input.KeyCode == Enum.KeyCode.F1 then
        -- Ajuda
        showNotification("❓ Ajuda: Use as teclas I, S, W, R, D, L", 5)
    end
end)

-- Conectar eventos dos botões da MainInterface
local function connectMainInterfaceEvents()
    -- Aguardar MainInterface carregar
    wait(2)
    
    local mainInterface = playerGui:FindFirstChild("MainInterface")
    if mainInterface then
        local mainFrame = mainInterface:FindFirstChild("MainFrame")
        if mainFrame then
            local statusBar = mainFrame:FindFirstChild("StatusBar")
            if statusBar then
                local buttonFrame = statusBar:FindFirstChild("ButtonFrame")
                if buttonFrame then
                    -- Conectar botão de inventário
                    local inventoryButton = buttonFrame:FindFirstChild("InventoryButton")
                    if inventoryButton then
                        inventoryButton.MouseButton1Click:Connect(function()
                            toggleInterface("inventorySystem")
                        end)
                    end
                    
                    -- Conectar botão de sombras
                    local shadowButton = buttonFrame:FindFirstChild("ShadowButton")
                    if shadowButton then
                        shadowButton.MouseButton1Click:Connect(function()
                            toggleInterface("shadowSystem")
                        end)
                    end
                    
                    -- Conectar botão de armas
                    local weaponButton = buttonFrame:FindFirstChild("WeaponButton")
                    if weaponButton then
                        weaponButton.MouseButton1Click:Connect(function()
                            showNotification("⚔️ Sistema de armas em desenvolvimento...", 2)
                        end)
                    end
                    
                    -- Conectar botão de relíquias
                    local relicButton = buttonFrame:FindFirstChild("RelicButton")
                    if relicButton then
                        relicButton.MouseButton1Click:Connect(function()
                            showNotification("💎 Sistema de relíquias em desenvolvimento...", 2)
                        end)
                    end
                    
                    -- Conectar botão de ranking
                    local rankingButton = buttonFrame:FindFirstChild("RankingButton")
                    if rankingButton then
                        rankingButton.MouseButton1Click:Connect(function()
                            showNotification("🏆 Sistema de ranking em desenvolvimento...", 2)
                        end)
                    end
                end
            end
        end
    end
end

-- Sistema de ajuda
local function createHelpSystem()
    local helpFrame = Instance.new("Frame")
    helpFrame.Name = "HelpFrame"
    helpFrame.Size = UDim2.new(0, 300, 0, 200)
    helpFrame.Position = UDim2.new(0, 10, 0, 10)
    helpFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    helpFrame.BorderSizePixel = 0
    helpFrame.Visible = false
    helpFrame.Parent = playerGui
    
    local helpBorder = Instance.new("Frame")
    helpBorder.Name = "HelpBorder"
    helpBorder.Size = UDim2.new(1, 4, 1, 4)
    helpBorder.Position = UDim2.new(0, -2, 0, -2)
    helpBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    helpBorder.BorderSizePixel = 0
    helpBorder.Parent = helpFrame
    
    local helpTitle = Instance.new("TextLabel")
    helpTitle.Name = "HelpTitle"
    helpTitle.Size = UDim2.new(1, 0, 0, 30)
    helpTitle.Position = UDim2.new(0, 0, 0, 0)
    helpTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    helpTitle.BorderSizePixel = 0
    helpTitle.Text = "❓ ATALHOS DE TECLADO"
    helpTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    helpTitle.TextScaled = true
    helpTitle.Font = Enum.Font.SourceSansBold
    helpTitle.Parent = helpFrame
    
    local helpContent = Instance.new("TextLabel")
    helpContent.Name = "HelpContent"
    helpContent.Size = UDim2.new(1, -10, 1, -40)
    helpContent.Position = UDim2.new(0, 5, 0, 35)
    helpContent.BackgroundTransparency = 1
    helpContent.Text = "I - Inventário\nS - Sombras\nW - Armas\nR - Relíquias\nD - Dungeons\nL - Ranking\nESC - Fechar tudo\nF1 - Ajuda"
    helpContent.TextColor3 = Color3.fromRGB(200, 200, 200)
    helpContent.TextScaled = true
    helpContent.Font = Enum.Font.SourceSans
    helpContent.TextXAlignment = Enum.TextXAlignment.Left
    helpContent.TextYAlignment = Enum.TextYAlignment.Top
    helpContent.Parent = helpFrame
    
    -- Função para mostrar/ocultar ajuda
    local function toggleHelp()
        helpFrame.Visible = not helpFrame.Visible
    end
    
    return toggleHelp
end

-- Conectar eventos do servidor
local function connectServerEvents()
    local eventsFolder = ReplicatedStorage:FindFirstChild("Events")
    if eventsFolder then
        local playerDataEvent = eventsFolder:FindFirstChild("PlayerDataUpdated")
        if playerDataEvent then
            playerDataEvent.OnClientEvent:Connect(function(dataType, value, extra)
                if dataType == "Notification" then
                    showNotification(value, extra or 3)
                end
            end)
        end
    end
end

-- Inicializar sistema
local function initialize()
    print("🎮 Inicializando InterfaceManager...")
    
    -- Criar sistema de ajuda
    local toggleHelp = createHelpSystem()
    
    -- Conectar eventos da MainInterface
    connectMainInterfaceEvents()
    
    -- Conectar eventos do servidor
    connectServerEvents()
    
    -- Mostrar notificação de boas-vindas
    showNotification("🎮 Bem-vindo ao Arise Crossover!", 5)
    
    print("✅ InterfaceManager inicializado com sucesso!")
end

-- Exportar funções
_G.showNotification = showNotification
_G.toggleInterface = toggleInterface
_G.closeAllInterfaces = closeAllInterfaces

-- Inicializar automaticamente
initialize()

print("✅ InterfaceManager criado com sucesso!")