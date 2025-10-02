--[[
    ShadowSystem.lua
    Sistema de captura e gerenciamento de sombras
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local ShadowData = require(ReplicatedStorage.Modules.ShadowData)
local NPCData = require(ReplicatedStorage.Modules.NPCData)

local ShadowSystem = {}
ShadowSystem.DataManager = nil
ShadowSystem.MissionSystem = nil

-- Armazena tentativas de captura por jogador
ShadowSystem.CaptureAttempts = {} -- {playerUserId -> {npcName -> attempts}}

-- Tenta capturar sombra
function ShadowSystem:AttemptCapture(player, npcName, npcRank)
    local playerData = self.DataManager:GetPlayerData(player)
    if not playerData then return false, "Dados não encontrados" end
    
    -- Inicializa tentativas se necessário
    if not self.CaptureAttempts[player.UserId] then
        self.CaptureAttempts[player.UserId] = {}
    end
    
    if not self.CaptureAttempts[player.UserId][npcName] then
        self.CaptureAttempts[player.UserId][npcName] = 0
    end
    
    local attempts = self.CaptureAttempts[player.UserId][npcName]
    
    -- Verifica se ainda tem tentativas
    if attempts >= 3 then
        return false, "Sem tentativas restantes"
    end
    
    attempts = attempts + 1
    self.CaptureAttempts[player.UserId][npcName] = attempts
    
    -- Calcula sucesso
    local success = ShadowData:CalculateCaptureSuccess(attempts)
    
    if success then
        -- Captura bem-sucedida
        local npcData = NPCData:GetNPCByName(npcName)
        if not npcData then return false, "NPC não encontrado" end
        
        -- Verifica chance de drop de sombra
        local dropRoll = math.random()
        if dropRoll > npcData.ShadowDropChance then
            -- Não dropou sombra
            return false, "A sombra escapou! (Drop falhou)"
        end
        
        -- Cria sombra
        local shadow = ShadowData:CreateShadow(npcName, npcData)
        
        -- Adiciona ao inventário
        self.DataManager:AddShadow(player, shadow)
        
        -- Limpa tentativas
        self.CaptureAttempts[player.UserId][npcName] = nil
        
        -- Atualiza missões
        self.MissionSystem:UpdateProgress(player, "CaptureShadows", {})
        
        -- Notifica jogador
        local RankData = require(ReplicatedStorage.Modules.RankData)
        local rankInfo = RankData:GetRankByName(shadow.Rank)
        
        RemoteEvents.ShowNotification:FireClient(
            player,
            "✨ SOMBRA CAPTURADA! ✨",
            string.format("%s [Rank %s] se juntou às suas sombras!", shadow.Name, shadow.Rank),
            rankInfo.Color
        )
        
        return true, "Sombra capturada com sucesso!", shadow
    else
        -- Falhou
        local remainingAttempts = 3 - attempts
        
        if remainingAttempts > 0 then
            RemoteEvents.ShowNotification:FireClient(
                player,
                "Captura Falhou",
                string.format("Tentativa %d/3 falhou. %d tentativas restantes.", attempts, remainingAttempts),
                Color3.fromRGB(255, 150, 150)
            )
            return false, string.format("Falhou! %d tentativas restantes", remainingAttempts)
        else
            -- Última tentativa falhou
            self.CaptureAttempts[player.UserId][npcName] = nil
            
            RemoteEvents.ShowNotification:FireClient(
                player,
                "Captura Falhou",
                "Todas as tentativas esgotadas. A sombra se dissipou.",
                Color3.fromRGB(255, 100, 100)
            )
            return false, "Todas as tentativas esgotadas"
        end
    end
end

-- Destrói sombra e coleta diamantes
function ShadowSystem:DestroyShadow(player, npcName, npcRank)
    local playerData = self.DataManager:GetPlayerData(player)
    if not playerData then return false, "Dados não encontrados" end
    
    -- Calcula diamantes
    local diamonds = ShadowData:CalculateDestroyDiamonds(npcRank)
    
    -- Adiciona diamantes
    self.DataManager:AddDiamonds(player, diamonds)
    
    -- Atualiza estatísticas
    playerData.Stats.ShadowsDestroyed = playerData.Stats.ShadowsDestroyed + 1
    
    -- Limpa tentativas
    if self.CaptureAttempts[player.UserId] then
        self.CaptureAttempts[player.UserId][npcName] = nil
    end
    
    -- Notifica jogador
    RemoteEvents.ShowNotification:FireClient(
        player,
        "Sombra Destruída",
        string.format("Você coletou %d diamantes!", diamonds),
        Color3.fromRGB(100, 200, 255)
    )
    
    return true, "Sombra destruída", diamonds
end

-- Equipa sombra
function ShadowSystem:EquipShadow(player, shadowID)
    local success, message = self.DataManager:EquipShadow(player, shadowID)
    
    if success then
        RemoteEvents.ShowNotification:FireClient(
            player,
            "Sombra Equipada",
            "Sombra equipada com sucesso!",
            Color3.fromRGB(150, 255, 150)
        )
    else
        RemoteEvents.ShowNotification:FireClient(
            player,
            "Erro",
            message or "Não foi possível equipar a sombra",
            Color3.fromRGB(255, 150, 150)
        )
    end
    
    return success, message
end

-- Desequipa sombra
function ShadowSystem:UnequipShadow(player, shadowID)
    local success = self.DataManager:UnequipShadow(player, shadowID)
    
    if success then
        RemoteEvents.ShowNotification:FireClient(
            player,
            "Sombra Desequipada",
            "Sombra desequipada com sucesso!",
            Color3.fromRGB(200, 200, 200)
        )
    end
    
    return success
end

-- Cria visualização de sombras equipadas ao redor do jogador
function ShadowSystem:CreateShadowVisuals(player)
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Remove visuais antigos
    local oldVisuals = character:FindFirstChild("ShadowVisuals")
    if oldVisuals then
        oldVisuals:Destroy()
    end
    
    -- Cria nova pasta
    local visualsFolder = Instance.new("Folder")
    visualsFolder.Name = "ShadowVisuals"
    visualsFolder.Parent = character
    
    -- Obtém sombras equipadas
    local equippedShadows = self.DataManager:GetEquippedShadows(player)
    
    for i, shadow in ipairs(equippedShadows) do
        -- Cria representação visual da sombra
        local shadowPart = Instance.new("Part")
        shadowPart.Name = "Shadow_" .. i
        shadowPart.Size = Vector3.new(1, 2, 0.5)
        shadowPart.Color = shadow.ModelColor or Color3.fromRGB(50, 50, 50)
        shadowPart.Material = Enum.Material.Neon
        shadowPart.Transparency = 0.3
        shadowPart.CanCollide = false
        shadowPart.Anchored = false
        shadowPart.Parent = visualsFolder
        
        -- Attachment para orbitar
        local attachment = Instance.new("Attachment")
        attachment.Parent = shadowPart
        
        -- AlignPosition para seguir o jogador
        local alignPosition = Instance.new("AlignPosition")
        alignPosition.Attachment0 = attachment
        alignPosition.RigidityEnabled = false
        alignPosition.MaxForce = 10000
        alignPosition.Responsiveness = 20
        alignPosition.Parent = shadowPart
        
        -- Cria attachment no jogador
        local playerAttachment = Instance.new("Attachment")
        playerAttachment.Name = "ShadowAttachment_" .. i
        playerAttachment.Parent = humanoidRootPart
        
        alignPosition.Attachment1 = playerAttachment
        
        -- Posiciona em círculo ao redor do jogador
        local angle = (i - 1) * (math.pi * 2 / 3) -- Máximo 3 sombras
        local radius = 3
        playerAttachment.Position = Vector3.new(
            math.cos(angle) * radius,
            0,
            math.sin(angle) * radius
        )
        
        -- BodyGyro para manter vertical
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        bodyGyro.P = 0
        bodyGyro.Parent = shadowPart
    end
end

-- Atualiza visuais quando sombras mudam
function ShadowSystem:UpdateShadowVisualsForPlayer(player)
    spawn(function()
        while player.Parent do
            wait(0.5)
            self:CreateShadowVisuals(player)
        end
    end)
end

-- Inicialização
function ShadowSystem:Init(dataManager, missionSystem)
    self.DataManager = dataManager
    self.MissionSystem = missionSystem
    
    -- Setup eventos
    RemoteEvents.CaptureShadow.OnServerEvent:Connect(function(player, npcName, npcRank)
        self:AttemptCapture(player, npcName, npcRank)
    end)
    
    RemoteEvents.DestroyShadow.OnServerEvent:Connect(function(player, npcName, npcRank)
        self:DestroyShadow(player, npcName, npcRank)
    end)
    
    RemoteEvents.EquipShadow.OnServerEvent:Connect(function(player, shadowID)
        self:EquipShadow(player, shadowID)
    end)
    
    RemoteEvents.UnequipShadow.OnServerEvent:Connect(function(player, shadowID)
        self:UnequipShadow(player, shadowID)
    end)
    
    -- Atualiza visuais quando jogador entra
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            self:UpdateShadowVisualsForPlayer(player)
        end)
    end)
    
    print("[ShadowSystem] Inicializado com sucesso!")
end

return ShadowSystem
