--[[
    ShadowClient.lua
    Cliente de sombras - Input para captura/destruição
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local ShadowClient = {}
ShadowClient.NearestPrompt = nil
ShadowClient.InteractionRange = 15

-- Encontra prompt mais próximo
function ShadowClient:FindNearestPrompt()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local nearestPrompt = nil
    local nearestDistance = self.InteractionRange
    
    for _, part in ipairs(workspace:GetChildren()) do
        if part.Name == "CapturePrompt" and part:IsA("BasePart") then
            local distance = (humanoidRootPart.Position - part.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPrompt = part
            end
        end
    end
    
    return nearestPrompt
end

-- Tenta capturar sombra
function ShadowClient:TryCapture()
    local prompt = self:FindNearestPrompt()
    if not prompt then return end
    
    local npcName = prompt:GetAttribute("NPCName")
    local npcRank = prompt:GetAttribute("NPCRank")
    
    if npcName and npcRank then
        RemoteEvents.CaptureShadow:FireServer(npcName, npcRank)
    end
end

-- Destrói sombra
function ShadowClient:DestroyPrompt()
    local prompt = self:FindNearestPrompt()
    if not prompt then return end
    
    local npcName = prompt:GetAttribute("NPCName")
    local npcRank = prompt:GetAttribute("NPCRank")
    
    if npcName and npcRank then
        RemoteEvents.DestroyShadow:FireServer(npcName, npcRank)
        prompt:Destroy()
    end
end

-- Destaca prompt mais próximo
function ShadowClient:HighlightNearestPrompt()
    local nearestPrompt = self:FindNearestPrompt()
    
    -- Remove highlight anterior
    if self.NearestPrompt and self.NearestPrompt ~= nearestPrompt then
        self.NearestPrompt.Transparency = 0.7
    end
    
    self.NearestPrompt = nearestPrompt
    
    -- Adiciona highlight
    if nearestPrompt then
        nearestPrompt.Transparency = 0.3
    end
end

-- Loop de update
function ShadowClient:StartUpdateLoop()
    spawn(function()
        while true do
            wait(0.1)
            self:HighlightNearestPrompt()
        end
    end)
end

-- Input handling
function ShadowClient:SetupInputs()
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- E para capturar
        if input.KeyCode == Enum.KeyCode.E then
            self:TryCapture()
        end
        
        -- F para destruir
        if input.KeyCode == Enum.KeyCode.F then
            self:DestroyPrompt()
        end
    end)
end

-- Inicialização
function ShadowClient:Init()
    self:SetupInputs()
    self:StartUpdateLoop()
    print("[ShadowClient] Inicializado")
end

-- Inicia quando personagem spawna
player.CharacterAdded:Connect(function()
    wait(1)
    ShadowClient:Init()
end)

if player.Character then
    ShadowClient:Init()
end

return ShadowClient
