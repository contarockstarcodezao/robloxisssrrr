--[[
    CombatClient.lua
    Cliente de combate - Input do jogador
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local CombatClient = {}
CombatClient.CurrentTarget = nil
CombatClient.AttackRange = 10

-- Encontra NPC mais próximo
function CombatClient:FindNearestNPC()
    local character = player.Character
    if not character then return nil end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end
    
    local npcsFolder = workspace:FindFirstChild("NPCs")
    if not npcsFolder then return nil end
    
    local nearestNPC = nil
    local nearestDistance = self.AttackRange
    
    for _, npc in ipairs(npcsFolder:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
            local npcHumanoid = npc:FindFirstChild("Humanoid")
            if npcHumanoid.Health > 0 then
                local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
                if npcRootPart then
                    local distance = (humanoidRootPart.Position - npcRootPart.Position).Magnitude
                    if distance < nearestDistance then
                        nearestDistance = distance
                        nearestNPC = npc
                    end
                end
            end
        end
    end
    
    return nearestNPC
end

-- Ataca NPC
function CombatClient:Attack()
    local target = self:FindNearestNPC()
    if target then
        RemoteEvents.AttackNPC:FireServer(target)
        self:CreateAttackAnimation()
    end
end

-- Animação de ataque
function CombatClient:CreateAttackAnimation()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if humanoid then
        -- Tenta usar animação padrão de punch
        local animator = humanoid:FindFirstChild("Animator")
        if animator then
            -- Aqui você pode carregar uma animação customizada
            -- Por enquanto, vamos fazer um simples efeito visual
        end
    end
end

-- Destaca NPC mais próximo
function CombatClient:HighlightNearestNPC()
    local nearestNPC = self:FindNearestNPC()
    
    -- Remove highlight anterior
    if self.CurrentTarget and self.CurrentTarget ~= nearestNPC then
        local oldHighlight = self.CurrentTarget:FindFirstChild("TargetHighlight")
        if oldHighlight then
            oldHighlight:Destroy()
        end
    end
    
    self.CurrentTarget = nearestNPC
    
    -- Adiciona novo highlight
    if nearestNPC then
        local highlight = nearestNPC:FindFirstChild("TargetHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "TargetHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.5
            highlight.Parent = nearestNPC
        end
    end
end

-- Loop de update
function CombatClient:StartUpdateLoop()
    spawn(function()
        while true do
            wait(0.1)
            self:HighlightNearestNPC()
        end
    end)
end

-- Input handling
function CombatClient:SetupInputs()
    -- Ataque com clique
    local mouse = player:GetMouse()
    mouse.Button1Down:Connect(function()
        self:Attack()
    end)
    
    -- Ataque com tecla (opcional)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            self:Attack()
        end
    end)
end

-- Inicialização
function CombatClient:Init()
    self:SetupInputs()
    self:StartUpdateLoop()
    print("[CombatClient] Inicializado")
end

-- Inicia quando personagem spawna
player.CharacterAdded:Connect(function()
    wait(1)
    CombatClient:Init()
end)

if player.Character then
    CombatClient:Init()
end

return CombatClient
