--[[
    GUI MANAGER
    Localização: StarterGui/GUIManager.lua
    
    Gerenciador principal das interfaces gráficas:
    - Conecta todas as GUIs
    - Gerencia abertura/fechamento
    - Sistema de notificações
    - Atalhos de teclado
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Importar todas as GUIs
local MainGUI = require(script.Parent.MainGUI)
local InventoryGUI = require(script.Parent.InventoryGUI)
local ShadowGUI = require(script.Parent.ShadowGUI)
local CombatGUI = require(script.Parent.CombatGUI)
local RankingGUI = require(script.Parent.RankingGUI)
local WeaponGUI = require(script.Parent.WeaponGUI)
local RelicGUI = require(script.Parent.RelicGUI)
local DungeonGUI = require(script.Parent.DungeonGUI)

local GUIManager = {}

-- Estado das GUIs
local guiState = {
    mainGUI = true,
    inventoryGUI = false,
    shadowGUI = false,
    combatGUI = true,
    rankingGUI = false,
    weaponGUI = false,
    relicGUI = false,
    dungeonGUI = false
}

-- Função para alternar GUI
local function toggleGUI(guiName)
    if guiState[guiName] ~= nil then
        guiState[guiName] = not guiState[guiName]
        
        -- Atualizar GUI correspondente
        if guiName == "mainGUI" then
            -- MainGUI sempre visível
            guiState[guiName] = true
        elseif guiName == "inventoryGUI" then
            _G.toggleInventory()
        elseif guiName == "shadowGUI" then
            _G.toggleShadowGUI()
        elseif guiName == "rankingGUI" then
            _G.toggleRankingGUI()
        elseif guiName == "weaponGUI" then
            _G.toggleWeaponGUI()
        elseif guiName == "relicGUI" then
            _G.toggleRelicGUI()
        elseif guiName == "dungeonGUI" then
            _G.toggleDungeonGUI()
        end
        
        return guiState[guiName]
    end
    return false
end

-- Função para fechar todas as GUIs
local function closeAllGUIs()
    guiState.inventoryGUI = false
    guiState.shadowGUI = false
    guiState.rankingGUI = false
    guiState.weaponGUI = false
    guiState.relicGUI = false
    guiState.dungeonGUI = false
    
    -- Fechar todas as GUIs
    if _G.toggleInventory then _G.toggleInventory() end
    if _G.toggleShadowGUI then _G.toggleShadowGUI() end
    if _G.toggleRankingGUI then _G.toggleRankingGUI() end
    if _G.toggleWeaponGUI then _G.toggleWeaponGUI() end
    if _G.toggleRelicGUI then _G.toggleRelicGUI() end
    if _G.toggleDungeonGUI then _G.toggleDungeonGUI() end
end

-- Função para mostrar notificação
local function showNotification(text, icon, duration)
    if _G.showNotification then
        _G.showNotification(text, icon, duration)
    else
        print("📢 Notificação:", text)
    end
end

-- Conectar atalhos de teclado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.I then
        -- Inventário
        toggleGUI("inventoryGUI")
        showNotification("Abrindo inventário...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.S then
        -- Sombras
        toggleGUI("shadowGUI")
        showNotification("Abrindo sistema de sombras...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.W then
        -- Armas
        toggleGUI("weaponGUI")
        showNotification("Abrindo sistema de armas...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.R then
        -- Relíquias
        toggleGUI("relicGUI")
        showNotification("Abrindo sistema de relíquias...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.D then
        -- Dungeons
        toggleGUI("dungeonGUI")
        showNotification("Abrindo dungeons...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.L then
        -- Ranking
        toggleGUI("rankingGUI")
        showNotification("Abrindo ranking...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    elseif input.KeyCode == Enum.KeyCode.Escape then
        -- Fechar todas as GUIs
        closeAllGUIs()
        showNotification("Fechando todas as interfaces...", "rbxasset://textures/ui/GuiImagePlaceholder.png", 1)
    end
end)

-- Conectar eventos dos botões da MainGUI
local function connectMainGUIEvents()
    -- Aguardar MainGUI carregar
    wait(1)
    
    if _G.toggleInventory then
        -- Conectar botão de inventário
        local mainGUI = playerGui:FindFirstChild("MainGUI")
        if mainGUI then
            local inventoryButton = mainGUI:FindFirstChild("InventoryButton")
            if inventoryButton then
                inventoryButton.MouseButton1Click:Connect(function()
                    toggleGUI("inventoryGUI")
                end)
            end
        end
    end
    
    if _G.toggleShadowGUI then
        -- Conectar botão de sombras
        local mainGUI = playerGui:FindFirstChild("MainGUI")
        if mainGUI then
            local shadowButton = mainGUI:FindFirstChild("ShadowButton")
            if shadowButton then
                shadowButton.MouseButton1Click:Connect(function()
                    toggleGUI("shadowGUI")
                end)
            end
        end
    end
    
    if _G.toggleWeaponGUI then
        -- Conectar botão de armas
        local mainGUI = playerGui:FindFirstChild("MainGUI")
        if mainGUI then
            local weaponButton = mainGUI:FindFirstChild("WeaponButton")
            if weaponButton then
                weaponButton.MouseButton1Click:Connect(function()
                    toggleGUI("weaponGUI")
                end)
            end
        end
    end
    
    if _G.toggleRelicGUI then
        -- Conectar botão de relíquias
        local mainGUI = playerGui:FindFirstChild("MainGUI")
        if mainGUI then
            local relicButton = mainGUI:FindFirstChild("RelicButton")
            if relicButton then
                relicButton.MouseButton1Click:Connect(function()
                    toggleGUI("relicGUI")
                end)
            end
        end
    end
    
    if _G.toggleRankingGUI then
        -- Conectar botão de ranking
        local mainGUI = playerGui:FindFirstChild("MainGUI")
        if mainGUI then
            local rankingButton = mainGUI:FindFirstChild("RankingButton")
            if rankingButton then
                rankingButton.MouseButton1Click:Connect(function()
                    toggleGUI("rankingGUI")
                end)
            end
        end
    end
end

-- Sistema de notificações avançado
local function createNotificationSystem()
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "NotificationFrame"
    notificationFrame.Size = UDim2.new(0, 400, 0, 60)
    notificationFrame.Position = UDim2.new(1, -420, 0, 100)
    notificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    notificationFrame.BorderSizePixel = 0
    notificationFrame.Visible = false
    notificationFrame.Parent = playerGui
    
    -- Borda da notificação
    local notificationBorder = Instance.new("Frame")
    notificationBorder.Name = "NotificationBorder"
    notificationBorder.Size = UDim2.new(1, 4, 1, 4)
    notificationBorder.Position = UDim2.new(0, -2, 0, -2)
    notificationBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    notificationBorder.BorderSizePixel = 0
    notificationBorder.Parent = notificationFrame
    
    -- Texto da notificação
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
    
    -- Ícone da notificação
    local notificationIcon = Instance.new("ImageLabel")
    notificationIcon.Name = "NotificationIcon"
    notificationIcon.Size = UDim2.new(0, 40, 0, 40)
    notificationIcon.Position = UDim2.new(1, -50, 0.5, -20)
    notificationIcon.BackgroundTransparency = 1
    notificationIcon.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    notificationIcon.Parent = notificationFrame
    
    -- Função para mostrar notificação
    local function showNotification(text, icon, duration)
        duration = duration or 3
        
        notificationText.Text = text
        notificationIcon.Image = icon or "rbxasset://textures/ui/GuiImagePlaceholder.png"
        notificationFrame.Visible = true
        
        -- Animação de entrada
        notificationFrame.Position = UDim2.new(1, -420, 0, 100)
        local tween = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
            Position = UDim2.new(1, -420, 0, 100)
        })
        tween:Play()
        
        -- Auto-fechar após duração
        spawn(function()
            wait(duration)
            
            -- Animação de saída
            local tweenOut = TweenService:Create(notificationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Position = UDim2.new(1, 0, 0, 100)
            })
            tweenOut:Play()
            
            tweenOut.Completed:Connect(function()
                notificationFrame.Visible = false
            end)
        end)
    end
    
    -- Exportar função
    _G.showNotification = showNotification
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
    
    -- Borda da ajuda
    local helpBorder = Instance.new("Frame")
    helpBorder.Name = "HelpBorder"
    helpBorder.Size = UDim2.new(1, 4, 1, 4)
    helpBorder.Position = UDim2.new(0, -2, 0, -2)
    helpBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    helpBorder.BorderSizePixel = 0
    helpBorder.Parent = helpFrame
    
    -- Título da ajuda
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
    
    -- Conteúdo da ajuda
    local helpContent = Instance.new("TextLabel")
    helpContent.Name = "HelpContent"
    helpContent.Size = UDim2.new(1, -10, 1, -40)
    helpContent.Position = UDim2.new(0, 5, 0, 35)
    helpContent.BackgroundTransparency = 1
    helpContent.Text = "I - Inventário\nS - Sombras\nW - Armas\nR - Relíquias\nD - Dungeons\nL - Ranking\nESC - Fechar tudo"
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
    
    -- Conectar tecla F1 para ajuda
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.F1 then
            toggleHelp()
        end
    end)
end

-- Inicializar sistema
local function initialize()
    print("🎮 Inicializando GUIManager...")
    
    -- Criar sistema de notificações
    createNotificationSystem()
    
    -- Criar sistema de ajuda
    createHelpSystem()
    
    -- Conectar eventos da MainGUI
    connectMainGUIEvents()
    
    -- Mostrar notificação de boas-vindas
    showNotification("Bem-vindo ao Arise Crossover!", "rbxasset://textures/ui/GuiImagePlaceholder.png", 3)
    
    print("✅ GUIManager inicializado com sucesso!")
end

-- Exportar funções
GUIManager.toggleGUI = toggleGUI
GUIManager.closeAllGUIs = closeAllGUIs
GUIManager.showNotification = showNotification
GUIManager.initialize = initialize

-- Inicializar automaticamente
initialize()

return GUIManager