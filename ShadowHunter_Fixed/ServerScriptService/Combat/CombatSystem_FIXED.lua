--[[
    CombatSystem.lua - VERSÃO CORRIGIDA
    Sistema de combate totalmente conectado
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local CombatSystem = {}
CombatSystem.DataManager = nil
CombatSystem.NPCManager = nil
CombatSystem.RankSystem = nil
CombatSystem.MissionSystem = nil

CombatSystem.AttackCooldowns = {}

CombatSystem.Config = {
    AttackCooldown = 1.0,
    BaseDamage = 20,
    AttackRange = 10
}

-- ========================================
-- ATAQUE DO JOGADOR
-- ========================================

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
    
    print(string.format("[CombatSystem] %s atacou %s com %d de dano", 
        player.Name, npc.Name, damage))
    
    -- Aplica dano
    local success = self.NPCManager:DamageNPC(npc, damage, player)
    
    if success then
        self.AttackCooldowns[player.UserId] = now
        
        -- ⭐ ATUALIZA ESTATÍSTICA (COM VERIFICAÇÃO)
        local data = self.DataManager:GetPlayerData(player)
        if data and data.Statistics then
            self.DataManager:IncrementStatistic(player, "DamageDealt", damage)
        end
        
        return true
    end
    
    return false
end

-- ========================================
-- CÁLCULO DE DANO
-- ========================================

function CombatSystem:CalculatePlayerDamage(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return self.Config.BaseDamage end
    
    local damage = self.Config.BaseDamage
    
    -- Bônus de level (5% por level)
    damage = damage * (1 + (data.Level - 1) * 0.05)
    
    -- Bônus de rank
    if self.RankSystem then
        local rankBonus = self.RankSystem:GetDamageBonus(player)
        damage = damage * (1 + rankBonus)
    end
    
    -- Bônus de sombras equipadas
    local equippedShadows = self.DataManager:GetEquippedShadows(player)
    for _, shadow in ipairs(equippedShadows) do
        damage = damage + (shadow.Damage * 0.1)
    end
    
    return math.floor(damage)
end

-- ========================================
-- MORTE DO NPC (CALLBACK)
-- ========================================

function CombatSystem:HandleNPCDeath(npc, npcData)
    -- Obtém o killer
    local npcInfo = self.NPCManager.ActiveNPCs[npc]
    if not npcInfo then 
        warn("[CombatSystem] ⚠️ NPC info não encontrado")
        return 
    end
    
    local killer = npcInfo.Killer
    if not killer or not killer.Parent then
        print("[CombatSystem] NPC morreu sem killer válido")
        
        -- Limpa dados do NPC
        self.NPCManager.ActiveNPCs[npc] = nil
        self.NPCManager.NPCHealths[npc] = nil
        return
    end
    
    print(string.format("[CombatSystem] 💀 %s foi morto por %s", npc.Name, killer.Name))
    
    -- Processa drops
    self:ProcessDrops(killer, npcData)
    
    -- Concede XP
    self.DataManager:AddXP(killer, npcData.XPReward)
    
    -- ⭐ ATUALIZA ESTATÍSTICA COM VERIFICAÇÃO
    self.DataManager:IncrementStatistic(killer, "NPCsKilled", 1)
    
    -- Atualiza progresso de missões
    if self.MissionSystem then
        self.MissionSystem:UpdateProgress(killer, "KillNPCs", {
            NPCRank = npcData.Rank,
            Zone = npcInfo.Zone,
            NPCName = npcData.Name
        })
    end
    
    -- Notifica jogador
    local RemoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
    if RemoteEvents then
        local ShowNotification = RemoteEvents:FindFirstChild("ShowNotification")
        if ShowNotification then
            ShowNotification:FireClient(
                killer,
                "NPC Derrotado!",
                string.format("Você derrotou %s (+%d XP)", npcData.Name, npcData.XPReward),
                Color3.fromRGB(255, 215, 0)
            )
        end
    end
    
    -- Limpa dados do NPC
    self.NPCManager.ActiveNPCs[npc] = nil
    self.NPCManager.NPCHealths[npc] = nil
end

-- ========================================
-- PROCESSA DROPS
-- ========================================

function CombatSystem:ProcessDrops(player, npcData)
    if not npcData.Drops then return end
    
    for _, drop in ipairs(npcData.Drops) do
        local roll = math.random()
        
        if roll <= drop.Chance then
            local amount = math.random(drop.Amount[1], drop.Amount[2])
            
            if drop.Item == "Cash" then
                self.DataManager:AddCash(player, amount)
            elseif drop.Item == "Diamonds" then
                self.DataManager:AddDiamonds(player, amount)
            end
            
            print(string.format("[CombatSystem] %s ganhou %d %s", 
                player.Name, amount, drop.Item))
        end
    end
end

-- ========================================
-- SOMBRA ATACA NPC
-- ========================================

function CombatSystem:ShadowAttackNPC(player, shadowID, npc)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return false end
    
    -- Verifica se a sombra existe e está equipada
    local shadow = nil
    for _, s in ipairs(data.Shadows) do
        if s.ID == shadowID then
            shadow = s
            break
        end
    end
    
    if not shadow then return false end
    
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

-- ========================================
-- AUTO-ATAQUE DE SOMBRAS
-- ========================================

function CombatSystem:StartAutoAttack(player)
    spawn(function()
        while player.Parent do
            wait(1)
            
            local character = player.Character
            if not character then continue end
            
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            if not humanoidRootPart then continue end
            
            local equippedShadows = self.DataManager:GetEquippedShadows(player)
            if #equippedShadows == 0 then continue end
            
            local npcsFolder = workspace:FindFirstChild("NPCs")
            if not npcsFolder then continue end
            
            for _, npc in ipairs(npcsFolder:GetChildren()) do
                if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
                    local npcHumanoid = npc:FindFirstChild("Humanoid")
                    if npcHumanoid.Health > 0 then
                        local npcRootPart = npc:FindFirstChild("HumanoidRootPart")
                        if npcRootPart then
                            local distance = (humanoidRootPart.Position - npcRootPart.Position).Magnitude
                            
                            for _, shadow in ipairs(equippedShadows) do
                                if distance <= shadow.Range then
                                    self:ShadowAttackNPC(player, shadow.ID, npc)
                                    
                                    -- Efeito visual
                                    self:CreateAttackEffect(
                                        humanoidRootPart.Position + Vector3.new(0, 2, 0),
                                        npcRootPart.Position + Vector3.new(0, 2, 0)
                                    )
                                    
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ========================================
-- EFEITO VISUAL
-- ========================================

function CombatSystem:CreateAttackEffect(origin, target)
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(0.2, 0.2, (origin - target).Magnitude)
    beam.CFrame = CFrame.new(origin, target) * CFrame.new(0, 0, -(origin - target).Magnitude / 2)
    beam.Color = Color3.fromRGB(255, 215, 0)
    beam.Material = Enum.Material.Neon
    beam.Anchored = true
    beam.CanCollide = false
    beam.Parent = workspace
    
    game:GetService("Debris"):AddItem(beam, 0.1)
end

-- ========================================
-- INICIALIZAÇÃO
-- ========================================

function CombatSystem:Init(dataManager, npcManager, rankSystem, missionSystem)
    print("[CombatSystem] 🚀 Inicializando...")
    
    self.DataManager = dataManager
    self.NPCManager = npcManager
    self.RankSystem = rankSystem
    self.MissionSystem = missionSystem
    
    -- ⭐ REGISTRA CALLBACK NO NPCMANAGER
    self.NPCManager.OnNPCDeathCallback = function(npc, npcData)
        self:HandleNPCDeath(npc, npcData)
    end
    print("[CombatSystem] ✅ Callback de morte registrado")
    
    -- Setup eventos
    local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
    if RemoteEvents then
        local AttackNPC = RemoteEvents:FindFirstChild("AttackNPC")
        if AttackNPC then
            AttackNPC.OnServerEvent:Connect(function(player, npc)
                self:PlayerAttackNPC(player, npc)
            end)
            print("[CombatSystem] ✅ Evento AttackNPC conectado")
        else
            warn("[CombatSystem] ⚠️ AttackNPC event não encontrado")
        end
    end
    
    -- Inicia auto-ataque quando jogador entra
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            wait(1)
            self:StartAutoAttack(player)
            print(string.format("[CombatSystem] ✅ Auto-ataque iniciado para %s", player.Name))
        end)
    end)
    
    -- Inicia auto-ataque para jogadores já presentes
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            self:StartAutoAttack(player)
        end
    end
    
    print("[CombatSystem] ✅ Inicializado com sucesso!")
end

return CombatSystem
