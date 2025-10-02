--[[
    CombatSystem.lua
    Sistema principal de combate do jogo
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local NPCData = require(ReplicatedStorage.Modules.NPCData)

local CombatSystem = {}
CombatSystem.DataManager = nil
CombatSystem.NPCManager = nil
CombatSystem.RankSystem = nil
CombatSystem.MissionSystem = nil

-- Cooldowns de ataque por jogador
CombatSystem.AttackCooldowns = {}

-- Configurações de combate
CombatSystem.Config = {
    AttackCooldown = 1.0, -- 1 segundo entre ataques
    BaseDamage = 20,
    AttackRange = 10
}

-- Jogador ataca NPC
function CombatSystem:PlayerAttackNPC(player, npc)
    -- Verifica cooldown
    local lastAttack = self.AttackCooldowns[player.UserId] or 0
    local now = tick()
    
    if now - lastAttack < self.Config.AttackCooldown then
        return false, "Aguarde para atacar novamente"
    end
    
    -- Verifica distância
    local character = player.Character
    if not character then return false, "Personagem não encontrado" end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart or not npcRootPart then
        return false, "Partes não encontradas"
    end
    
    local distance = (humanoidRootPart.Position - npcRootPart.Position).Magnitude
    if distance > self.Config.AttackRange then
        return false, "Muito longe do alvo"
    end
    
    -- Calcula dano
    local damage = self:CalculatePlayerDamage(player)
    
    -- Aplica dano
    local success = self.NPCManager:DamageNPC(npc, damage, player)
    
    if success then
        self.AttackCooldowns[player.UserId] = now
        
        -- Atualiza estatísticas
        local data = self.DataManager:GetPlayerData(player)
        if data then
            data.Stats.DamageDealt = data.Stats.DamageDealt + damage
        end
        
        return true
    end
    
    return false
end

-- Calcula dano do jogador
function CombatSystem:CalculatePlayerDamage(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return self.Config.BaseDamage end
    
    -- Dano base
    local damage = self.Config.BaseDamage
    
    -- Bônus de level (5% por level)
    damage = damage * (1 + (data.Level - 1) * 0.05)
    
    -- Bônus de rank
    local rankBonus = self.RankSystem:GetDamageBonus(player)
    damage = damage * (1 + rankBonus)
    
    -- Bônus de sombras equipadas
    local equippedShadows = self.DataManager:GetEquippedShadows(player)
    for _, shadow in ipairs(equippedShadows) do
        damage = damage + (shadow.Damage * 0.1) -- 10% do dano da sombra
    end
    
    return math.floor(damage)
end

-- Sombra ataca NPC
function CombatSystem:ShadowAttackNPC(player, shadowID, npc)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return false end
    
    -- Verifica se a sombra está equipada
    local shadow = nil
    for _, s in ipairs(data.Shadows) do
        if s.ID == shadowID then
            shadow = s
            break
        end
    end
    
    if not shadow then return false end
    
    -- Verifica se está equipada
    local isEquipped = false
    for _, id in ipairs(data.EquippedShadows) do
        if id == shadowID then
            isEquipped = true
            break
        end
    end
    
    if not isEquipped then return false end
    
    -- Calcula dano da sombra
    local ShadowData = require(ReplicatedStorage.Modules.ShadowData)
    local stats = ShadowData:GetShadowStats(shadow)
    
    -- Aplica dano
    local success = self.NPCManager:DamageNPC(npc, stats.Damage, player)
    
    return success
end

-- NPC morre e dropa itens
function CombatSystem:HandleNPCDeath(npc, killer)
    local npcInfo = self.NPCManager.ActiveNPCs[npc]
    if not npcInfo then return end
    
    local npcData = npcInfo.Data
    local zone = npcInfo.Zone
    
    if killer and killer:IsA("Player") then
        -- Processa drops
        self:ProcessDrops(killer, npcData)
        
        -- Concede XP
        self.DataManager:AddXP(killer, npcData.XPReward)
        
        -- Atualiza estatísticas
        local data = self.DataManager:GetPlayerData(killer)
        if data then
            data.Stats.NPCsKilled = data.Stats.NPCsKilled + 1
        end
        
        -- Atualiza progresso de missões
        self.MissionSystem:UpdateProgress(killer, "KillNPCs", {
            NPCRank = npcData.Rank,
            Zone = zone,
            NPCName = npcData.Name
        })
        
        -- Notifica jogador
        RemoteEvents.ShowNotification:FireClient(
            killer,
            "NPC Derrotado!",
            "Você derrotou " .. npcData.Name .. " (+" .. npcData.XPReward .. " XP)",
            Color3.fromRGB(255, 215, 0)
        )
    end
end

-- Processa drops do NPC
function CombatSystem:ProcessDrops(player, npcData)
    for _, drop in ipairs(npcData.Drops) do
        local roll = math.random()
        
        if roll <= drop.Chance then
            local amount = math.random(drop.Amount[1], drop.Amount[2])
            
            if drop.Item == "Cash" then
                self.DataManager:AddCash(player, amount)
            elseif drop.Item == "Diamonds" then
                self.DataManager:AddDiamonds(player, amount)
            end
        end
    end
end

-- Cria efeito de ataque visual
function CombatSystem:CreateAttackEffect(origin, target)
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(0.2, 0.2, (origin - target).Magnitude)
    beam.CFrame = CFrame.new(origin, target) * CFrame.new(0, 0, -(origin - target).Magnitude / 2)
    beam.Color = Color3.fromRGB(255, 215, 0)
    beam.Material = Enum.Material.Neon
    beam.Anchored = true
    beam.CanCollide = false
    beam.Parent = workspace
    
    -- Remove após pouco tempo
    game:GetService("Debris"):AddItem(beam, 0.1)
end

-- Auto-ataque das sombras equipadas
function CombatSystem:StartAutoAttack(player)
    spawn(function()
        while player.Parent do
            wait(1) -- Verifica a cada 1 segundo
            
            local character = player.Character
            if not character then continue end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then continue end
            
            -- Obtém sombras equipadas
            local equippedShadows = self.DataManager:GetEquippedShadows(player)
            if #equippedShadows == 0 then continue end
            
            -- Procura NPCs próximos
            local npcsFolder = workspace:FindFirstChild("NPCs")
            if not npcsFolder then continue end
            
            for _, npc in ipairs(npcsFolder:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                    local npcHumanoid = npc:FindFirstChild("Humanoid")
                    if npcHumanoid.Health > 0 then
                        local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
                        if npcRootPart then
                            local distance = (humanoidRootPart.Position - npcRootPart.Position).Magnitude
                            
                            -- Verifica se está dentro do range de alguma sombra
                            for _, shadow in ipairs(equippedShadows) do
                                if distance <= shadow.Range then
                                    -- Sombra ataca
                                    self:ShadowAttackNPC(player, shadow.ID, npc)
                                    
                                    -- Cria efeito visual
                                    self:CreateAttackEffect(
                                        humanoidRootPart.Position + Vector3.new(0, 2, 0),
                                        npcRootPart.Position + Vector3.new(0, 2, 0)
                                    )
                                    
                                    break -- Uma sombra por loop
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- Inicialização
function CombatSystem:Init(dataManager, npcManager, rankSystem, missionSystem)
    self.DataManager = dataManager
    self.NPCManager = npcManager
    self.RankSystem = rankSystem
    self.MissionSystem = missionSystem
    
    -- Setup eventos
    RemoteEvents.AttackNPC.OnServerEvent:Connect(function(player, npc)
        self:PlayerAttackNPC(player, npc)
    end)
    
    -- Inicia auto-ataque quando jogador entra
    game.Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            self:StartAutoAttack(player)
        end)
    end)
    
    print("[CombatSystem] Inicializado com sucesso!")
end

return CombatSystem
