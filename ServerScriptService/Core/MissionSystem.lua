--[[
    MissionSystem.lua
    Sistema de missões para progressão de rank
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)
local RankData = require(ReplicatedStorage.Modules.RankData)

local MissionSystem = {}
MissionSystem.DataManager = nil
MissionSystem.RankSystem = nil

-- Definição de missões por rank
MissionSystem.Missions = {
    -- Missões Rank F -> E
    {
        ID = "F_TO_E_1",
        Name = "Primeiro Sangue",
        Description = "Derrote 10 NPCs de Rank F",
        RequiredRank = "F",
        RewardRank = "E",
        Type = "KillNPCs",
        Target = {Rank = "F", Count = 10},
        Rewards = {Cash = 500, Diamonds = 50, XP = 200}
    },
    {
        ID = "F_TO_E_2",
        Name = "Coletor de Sombras",
        Description = "Capture 3 sombras",
        RequiredRank = "F",
        RewardRank = "E",
        Type = "CaptureShadows",
        Target = {Count = 3},
        Rewards = {Cash = 300, Diamonds = 30, XP = 150}
    },
    
    -- Missões Rank E -> D
    {
        ID = "E_TO_D_1",
        Name = "Caçador Intermediário",
        Description = "Derrote 20 NPCs de Rank E ou superior",
        RequiredRank = "E",
        RewardRank = "D",
        Type = "KillNPCs",
        Target = {MinRank = "E", Count = 20},
        Rewards = {Cash = 1000, Diamonds = 100, XP = 500}
    },
    {
        ID = "E_TO_D_2",
        Name = "Arsenal de Sombras",
        Description = "Capture 8 sombras",
        RequiredRank = "E",
        RewardRank = "D",
        Type = "CaptureShadows",
        Target = {Count = 8},
        Rewards = {Cash = 800, Diamonds = 80, XP = 400}
    },
    
    -- Missões Rank D -> C
    {
        ID = "D_TO_C_1",
        Name = "Explorador do Deserto",
        Description = "Derrote 30 NPCs na Zona Intermediária",
        RequiredRank = "D",
        RewardRank = "C",
        Type = "KillNPCs",
        Target = {Zone = "IntermediateZone", Count = 30},
        Rewards = {Cash = 2000, Diamonds = 200, XP = 1000}
    },
    {
        ID = "D_TO_C_2",
        Name = "Colecionador Dedicado",
        Description = "Possua 15 sombras no inventário",
        RequiredRank = "D",
        RewardRank = "C",
        Type = "CollectShadows",
        Target = {Count = 15},
        Rewards = {Cash = 1500, Diamonds = 150, XP = 800}
    },
    
    -- Missões Rank C -> B
    {
        ID = "C_TO_B_1",
        Name = "Conquistador das Montanhas",
        Description = "Derrote 40 NPCs de Rank C ou superior",
        RequiredRank = "C",
        RewardRank = "B",
        Type = "KillNPCs",
        Target = {MinRank = "C", Count = 40},
        Rewards = {Cash = 4000, Diamonds = 400, XP = 2000}
    },
    
    -- Missões Rank B -> A
    {
        ID = "B_TO_A_1",
        Name = "Mestre das Sombras",
        Description = "Capture 25 sombras",
        RequiredRank = "B",
        RewardRank = "A",
        Type = "CaptureShadows",
        Target = {Count = 25},
        Rewards = {Cash = 8000, Diamonds = 800, XP = 4000}
    },
    
    -- Missões Rank A -> S
    {
        ID = "A_TO_S_1",
        Name = "Caçador Elite",
        Description = "Derrote 50 NPCs de Rank A ou superior",
        RequiredRank = "A",
        RewardRank = "S",
        Type = "KillNPCs",
        Target = {MinRank = "A", Count = 50},
        Rewards = {Cash = 15000, Diamonds = 1500, XP = 8000}
    },
    
    -- Missões Rank S -> SS
    {
        ID = "S_TO_SS_1",
        Name = "Senhor das Chamas",
        Description = "Derrote 30 NPCs na Zona Elite",
        RequiredRank = "S",
        RewardRank = "SS",
        Type = "KillNPCs",
        Target = {Zone = "EliteZone", Count = 30},
        Rewards = {Cash = 30000, Diamonds = 3000, XP = 15000}
    },
    
    -- Missões Rank SS -> SSS
    {
        ID = "SS_TO_SSS_1",
        Name = "Lenda Ascendente",
        Description = "Derrote 20 NPCs de Rank SS ou superior",
        RequiredRank = "SS",
        RewardRank = "SSS",
        Type = "KillNPCs",
        Target = {MinRank = "SS", Count = 20},
        Rewards = {Cash = 60000, Diamonds = 6000, XP = 30000}
    },
    
    -- Missões Rank SSS -> GM
    {
        ID = "SSS_TO_GM_1",
        Name = "Monarca das Sombras",
        Description = "Derrote 50 NPCs na Zona Lendária",
        RequiredRank = "SSS",
        RewardRank = "GM",
        Type = "KillNPCs",
        Target = {Zone = "LegendaryZone", Count = 50},
        Rewards = {Cash = 100000, Diamonds = 10000, XP = 50000}
    },
    {
        ID = "SSS_TO_GM_2",
        Name = "Coleção Suprema",
        Description = "Capture 50 sombras",
        RequiredRank = "SSS",
        RewardRank = "GM",
        Type = "CaptureShadows",
        Target = {Count = 50},
        Rewards = {Cash = 80000, Diamonds = 8000, XP = 40000}
    }
}

-- Atribui missões ao jogador baseado no rank
function MissionSystem:AssignMissions(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return end
    
    local availableMissions = {}
    for _, mission in ipairs(self.Missions) do
        if mission.RequiredRank == data.Rank then
            -- Verifica se já não está nas missões atuais
            local alreadyHas = false
            for _, currentMission in ipairs(data.CurrentMissions) do
                if currentMission.ID == mission.ID then
                    alreadyHas = true
                    break
                end
            end
            
            if not alreadyHas then
                table.insert(availableMissions, mission)
            end
        end
    end
    
    -- Atribui missões disponíveis
    for _, mission in ipairs(availableMissions) do
        local missionData = {
            ID = mission.ID,
            Progress = 0
        }
        table.insert(data.CurrentMissions, missionData)
    end
    
    self.DataManager:UpdateClient(player)
end

-- Atualiza progresso de missão
function MissionSystem:UpdateProgress(player, missionType, additionalData)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return end
    
    for _, currentMission in ipairs(data.CurrentMissions) do
        local mission = self:GetMissionByID(currentMission.ID)
        if mission and mission.Type == missionType then
            -- Verifica se o progresso deve ser contabilizado
            local shouldCount = self:ShouldCountProgress(mission, additionalData)
            
            if shouldCount then
                currentMission.Progress = currentMission.Progress + 1
                
                -- Verifica se completou
                if currentMission.Progress >= mission.Target.Count then
                    self:CompleteMission(player, mission)
                else
                    -- Notifica progresso
                    RemoteEvents.MissionProgress:FireClient(
                        player,
                        mission.Name,
                        currentMission.Progress,
                        mission.Target.Count
                    )
                end
            end
        end
    end
    
    self.DataManager:UpdateClient(player)
end

-- Verifica se deve contar o progresso
function MissionSystem:ShouldCountProgress(mission, data)
    if mission.Type == "KillNPCs" then
        -- Verifica rank mínimo
        if mission.Target.MinRank then
            local npcRankOrder = RankData:GetRankOrder(data.NPCRank)
            local minRankOrder = RankData:GetRankOrder(mission.Target.MinRank)
            if npcRankOrder < minRankOrder then
                return false
            end
        end
        
        -- Verifica rank específico
        if mission.Target.Rank then
            if data.NPCRank ~= mission.Target.Rank then
                return false
            end
        end
        
        -- Verifica zona
        if mission.Target.Zone then
            if data.Zone ~= mission.Target.Zone then
                return false
            end
        end
        
        return true
    elseif mission.Type == "CaptureShadows" then
        return true
    elseif mission.Type == "CollectShadows" then
        -- Para este tipo, verifica o total de sombras
        return false -- Será verificado manualmente
    end
    
    return false
end

-- Completa missão
function MissionSystem:CompleteMission(player, mission)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return end
    
    -- Remove da lista de missões atuais
    for i, currentMission in ipairs(data.CurrentMissions) do
        if currentMission.ID == mission.ID then
            table.remove(data.CurrentMissions, i)
            break
        end
    end
    
    -- Adiciona à lista de completadas
    table.insert(data.CompletedMissions, mission.ID)
    
    -- Concede recompensas
    self.DataManager:AddCash(player, mission.Rewards.Cash)
    self.DataManager:AddDiamonds(player, mission.Rewards.Diamonds)
    self.DataManager:AddXP(player, mission.Rewards.XP)
    
    -- Concede novo rank se aplicável
    if mission.RewardRank then
        self.RankSystem:GrantRank(player, mission.RewardRank)
    end
    
    -- Notifica jogador
    RemoteEvents.MissionCompleted:FireClient(player, mission)
    
    -- Atribui novas missões
    self:AssignMissions(player)
end

-- Obtém missão por ID
function MissionSystem:GetMissionByID(id)
    for _, mission in ipairs(self.Missions) do
        if mission.ID == id then
            return mission
        end
    end
    return nil
end

-- Obtém missões do jogador com informações completas
function MissionSystem:GetPlayerMissions(player)
    local data = self.DataManager:GetPlayerData(player)
    if not data then return {} end
    
    local missions = {}
    for _, currentMission in ipairs(data.CurrentMissions) do
        local mission = self:GetMissionByID(currentMission.ID)
        if mission then
            local missionInfo = {}
            for k, v in pairs(mission) do
                missionInfo[k] = v
            end
            missionInfo.Progress = currentMission.Progress
            table.insert(missions, missionInfo)
        end
    end
    
    return missions
end

-- Inicialização
function MissionSystem:Init(dataManager, rankSystem)
    self.DataManager = dataManager
    self.RankSystem = rankSystem
    
    -- Atribui missões quando jogador entra
    game.Players.PlayerAdded:Connect(function(player)
        wait(1) -- Espera dados carregarem
        self:AssignMissions(player)
    end)
    
    -- Setup Remote Function
    RemoteEvents.GetMissions.OnServerInvoke = function(player)
        return self:GetPlayerMissions(player)
    end
    
    print("[MissionSystem] Inicializado com sucesso!")
end

return MissionSystem
