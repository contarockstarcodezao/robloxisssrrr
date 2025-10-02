# 🎨 Exemplos e Ideias de Expansão - Shadow Hunter

## 🔧 Exemplos de Código

### Adicionar Novo NPC Personalizado

```lua
-- Em NPCData.lua
{
    Name = "Naruto",
    Rank = "A",
    Health = 5500,
    Damage = 280,
    Defense = 90,
    XPReward = 600,
    Level = 75,
    Zone = "AdvancedZone",
    ShadowDropChance = 0.22,
    Drops = {
        {Item = "Cash", Amount = {900, 1500}, Chance = 1.0},
        {Item = "Diamonds", Amount = {90, 150}, Chance = 0.75}
    },
    ModelColor = Color3.fromRGB(255, 140, 0), -- Laranja
    AttackRange = 16,
    DetectionRange = 75,
    Special = "Rasengan"
}
```

### Criar Nova Missão Personalizada

```lua
-- Em MissionSystem.lua
{
    ID = "CUSTOM_1",
    Name = "Caçador de Lendas",
    Description = "Derrote Goku, Vegeta e Jiren",
    RequiredRank = "S",
    RewardRank = "SS",
    Type = "KillSpecificNPCs",  -- Novo tipo (você precisará implementar)
    Target = {
        NPCs = {"Goku", "Vegeta", "Jiren"},
        Count = {1, 1, 1}
    },
    Rewards = {
        Cash = 50000,
        Diamonds = 5000,
        XP = 25000
    }
}
```

### Sistema de Shop (Expansão)

```lua
-- Novo arquivo: ServerScriptService/Economy/ShopSystem.lua
local ShopSystem = {}

ShopSystem.Items = {
    {
        ID = "health_potion",
        Name = "Poção de Vida",
        Description = "Restaura 50% da vida",
        Price = 500,
        Currency = "Cash",
        Type = "Consumable"
    },
    {
        ID = "xp_boost",
        Name = "Boost de XP",
        Description = "2x XP por 30 minutos",
        Price = 100,
        Currency = "Diamonds",
        Type = "Boost"
    }
}

function ShopSystem:BuyItem(player, itemID)
    local item = self:GetItemByID(itemID)
    if not item then return false, "Item não encontrado" end
    
    local DataManager = require(script.Parent.Parent.Core.DataManager)
    local data = DataManager:GetPlayerData(player)
    
    -- Verifica se tem dinheiro
    if item.Currency == "Cash" then
        if data.Cash >= item.Price then
            DataManager:RemoveCash(player, item.Price)
            -- Aplicar efeito do item
            return true, "Item comprado!"
        end
    elseif item.Currency == "Diamonds" then
        if data.Diamonds >= item.Price then
            DataManager:RemoveDiamonds(player, item.Price)
            -- Aplicar efeito do item
            return true, "Item comprado!"
        end
    end
    
    return false, "Dinheiro insuficiente"
end

return ShopSystem
```

### Sistema de Party/Grupo (Expansão)

```lua
-- Novo arquivo: ServerScriptService/Social/PartySystem.lua
local PartySystem = {}
PartySystem.Parties = {}

function PartySystem:CreateParty(leader)
    local partyID = game:GetService("HttpService"):GenerateGUID(false)
    self.Parties[partyID] = {
        Leader = leader.UserId,
        Members = {leader.UserId},
        MaxMembers = 4,
        SharedXP = true,
        SharedLoot = false
    }
    return partyID
end

function PartySystem:InviteToParty(partyID, inviter, invitee)
    local party = self.Parties[partyID]
    if not party then return false end
    if party.Leader ~= inviter.UserId then return false end
    if #party.Members >= party.MaxMembers then return false end
    
    -- Enviar convite
    local RemoteEvents = require(game.ReplicatedStorage.Events.RemoteEvents)
    RemoteEvents.PartyInvite:FireClient(invitee, inviter.Name, partyID)
    return true
end

function PartySystem:ShareXP(partyID, xpAmount)
    local party = self.Parties[partyID]
    if not party or not party.SharedXP then return end
    
    local xpPerMember = math.floor(xpAmount / #party.Members)
    local DataManager = require(game.ServerScriptService.Core.DataManager)
    
    for _, userId in ipairs(party.Members) do
        local player = game.Players:GetPlayerByUserId(userId)
        if player then
            DataManager:AddXP(player, xpPerMember)
        end
    end
end

return PartySystem
```

### Sistema de Pets (Expansão)

```lua
-- Novo arquivo: ReplicatedStorage/Modules/PetData.lua
local PetData = {}

PetData.Pets = {
    {
        ID = "wolf_pet",
        Name = "Lobo Companheiro",
        Rarity = "Common",
        Stats = {
            DamageBonus = 0.05,  -- +5% dano
            XPBonus = 0.10,      -- +10% XP
            LootBonus = 0.05     -- +5% drop
        },
        Model = "rbxassetid://123456" -- ID do modelo
    },
    {
        ID = "dragon_pet",
        Name = "Dragão Bebê",
        Rarity = "Legendary",
        Stats = {
            DamageBonus = 0.20,
            XPBonus = 0.30,
            LootBonus = 0.15
        },
        Model = "rbxassetid://789012"
    }
}

return PetData
```

### Sistema de Clãs/Guilds (Expansão)

```lua
-- Novo arquivo: ServerScriptService/Social/GuildSystem.lua
local GuildSystem = {}
GuildSystem.Guilds = {}

function GuildSystem:CreateGuild(founder, guildName)
    local guildID = game:GetService("HttpService"):GenerateGUID(false)
    
    self.Guilds[guildID] = {
        ID = guildID,
        Name = guildName,
        Founder = founder.UserId,
        Leader = founder.UserId,
        Members = {founder.UserId},
        Level = 1,
        Experience = 0,
        MaxMembers = 20,
        CreatedAt = os.time(),
        Perks = {}
    }
    
    return guildID
end

function GuildSystem:AddGuildXP(guildID, xpAmount)
    local guild = self.Guilds[guildID]
    if not guild then return end
    
    guild.Experience = guild.Experience + xpAmount
    
    -- Level up da guilda
    local requiredXP = guild.Level * 1000
    while guild.Experience >= requiredXP do
        guild.Experience = guild.Experience - requiredXP
        guild.Level = guild.Level + 1
        guild.MaxMembers = guild.MaxMembers + 2
        -- Notificar membros
    end
end

return GuildSystem
```

## 💡 Ideias de Expansão

### 1. Sistema de Eventos Diários
```lua
-- Eventos que mudam diariamente
- Segunda: 2x XP
- Terça: 2x Cash
- Quarta: Chance aumentada de sombras
- Quinta: 2x Diamantes
- Sexta: Boss especial
- Fim de semana: Todos os bônus
```

### 2. Boss Raids
```lua
-- NPCs super poderosos que requerem grupos
{
    Name = "Rei Dragão",
    Type = "WorldBoss",
    Health = 500000,
    RequiresPlayers = 5,
    RespawnTime = 3600, -- 1 hora
    Rewards = {
        Cash = {10000, 20000},
        Diamonds = {1000, 2000},
        ExclusiveShadows = {"Rei Dragão"}
    }
}
```

### 3. Sistema de Crafting
```lua
-- Combine sombras para criar novas
{
    Recipe = {
        Ingredient1 = "Goku",
        Ingredient2 = "Vegeta",
        Result = "Gogeta",
        Cost = 5000 -- Diamantes
    }
}
```

### 4. PvP Arena
```lua
-- Área de duelo entre jogadores
{
    Name = "Arena de Batalha",
    Mode = "1v1",
    RankRequired = "B",
    Rewards = {
        Winner = {Cash = 1000, Rating = 10},
        Loser = {Cash = 200, Rating = -5}
    }
}
```

### 5. Sistema de Achievements
```lua
local Achievements = {
    {
        ID = "first_kill",
        Name = "Primeira Morte",
        Description = "Derrote seu primeiro NPC",
        Reward = {Diamonds = 50},
        Progress = function(data) return data.Stats.NPCsKilled >= 1 end
    },
    {
        ID = "shadow_collector",
        Name = "Colecionador",
        Description = "Capture 100 sombras",
        Reward = {Diamonds = 500},
        Progress = function(data) return data.Stats.ShadowsCaptured >= 100 end
    }
}
```

### 6. Sistema de Evolução de Sombras
```lua
function ShadowSystem:EvolveShadow(player, shadowID)
    local shadow = GetShadowByID(shadowID)
    
    -- Requisitos para evolução
    if shadow.Level >= 50 then
        shadow.Rank = GetNextRank(shadow.Rank)
        shadow.Damage = shadow.Damage * 1.5
        shadow.Health = shadow.Health * 1.5
        shadow.Level = 1 -- Reset level
        
        return true, "Sombra evoluída!"
    end
    
    return false, "Level insuficiente (necessário 50)"
end
```

### 7. Sistema de Quests Secundárias
```lua
local SideQuests = {
    {
        ID = "collect_items",
        Type = "Collection",
        Name = "Coletor de Materiais",
        Description = "Colete 50 cristais de sombra",
        Objective = {Item = "ShadowCrystal", Count = 50},
        Rewards = {Cash = 5000, Diamonds = 500},
        Repeatable = true
    }
}
```

### 8. Sistema de Títulos
```lua
local Titles = {
    {
        ID = "shadow_monarch",
        Name = "Monarca das Sombras",
        Color = Color3.fromRGB(150, 0, 200),
        Requirement = {Rank = "GM", ShadowsCaptured = 100}
    }
}
```

### 9. Sistema de Habilidades Especiais
```lua
local Skills = {
    {
        ID = "shadow_rush",
        Name = "Investida Sombria",
        Description = "Dash rápido para frente",
        Cooldown = 5,
        ManaCost = 20,
        Effect = function(player)
            -- Teleporta player para frente
            local char = player.Character
            local hrp = char.HumanoidRootPart
            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 20
        end
    }
}
```

### 10. Sistema de Temporadas (Seasons)
```lua
local Season = {
    Number = 1,
    Name = "Rise of Shadows",
    StartDate = os.time(),
    EndDate = os.time() + (90 * 24 * 60 * 60), -- 90 dias
    Rewards = {
        Bronze = {Diamonds = 500},
        Silver = {Diamonds = 1000},
        Gold = {Diamonds = 2500},
        Diamond = {Diamonds = 5000, ExclusiveShadow = "Limited Edition"}
    }
}
```

## 🎮 Mecânicas Adicionais

### Sistema de Stamina
```lua
-- Adicione ao PlayerData
Stamina = 100,
MaxStamina = 100,

-- Sistema de recuperação
function StaminaSystem:Regenerate(player)
    local data = DataManager:GetPlayerData(player)
    if data.Stamina < data.MaxStamina then
        data.Stamina = math.min(data.MaxStamina, data.Stamina + 1)
    end
end
```

### Sistema de Combo
```lua
-- Rastreia hits consecutivos
local ComboSystem = {
    Combos = {} -- {PlayerUserId -> {Count, LastHit}}
}

function ComboSystem:AddHit(player)
    local userId = player.UserId
    local now = tick()
    
    if not self.Combos[userId] then
        self.Combos[userId] = {Count = 0, LastHit = 0}
    end
    
    local combo = self.Combos[userId]
    
    -- Reset se passou muito tempo
    if now - combo.LastHit > 3 then
        combo.Count = 0
    end
    
    combo.Count = combo.Count + 1
    combo.LastHit = now
    
    -- Bônus de dano por combo
    local bonusDamage = combo.Count * 0.05 -- +5% por hit
    return bonusDamage
end
```

### Sistema de Clima
```lua
-- Afeta stats baseado no clima
local WeatherSystem = {
    Current = "Clear",
    Effects = {
        Rain = {XPBonus = 0.10},
        Storm = {DamageBonus = 0.20},
        Fog = {ShadowDropBonus = 0.15}
    }
}
```

### Sistema de Dia/Noite
```lua
-- Sombras mais fortes à noite
function TimeSystem:GetTimeBonus()
    local hour = os.date("*t").hour
    
    if hour >= 20 or hour <= 6 then
        -- Noite
        return {
            ShadowDamage = 1.25,  -- +25%
            ShadowDropChance = 1.30  -- +30%
        }
    else
        -- Dia
        return {
            PlayerDamage = 1.10,  -- +10%
            XPGain = 1.15  -- +15%
        }
    end
end
```

## 🏪 UI Expansions

### Sistema de Leaderboard Global
```lua
-- Top 100 players por rank e level
local LeaderboardUI = {
    Categories = {"Rank", "Level", "Shadows", "NPCsKilled"},
    RefreshTime = 60  -- Atualiza a cada minuto
}
```

### Sistema de Notificações Avançadas
```lua
-- Diferentes tipos de notificações
NotificationTypes = {
    Success = Color3.fromRGB(0, 255, 0),
    Error = Color3.fromRGB(255, 0, 0),
    Info = Color3.fromRGB(0, 150, 255),
    Warning = Color3.fromRGB(255, 200, 0),
    Epic = Color3.fromRGB(200, 0, 255)
}
```

### Inventário Expandido com Filtros
```lua
InventoryFilters = {
    "All",
    "Equipped",
    "ByRank",
    "ByLevel",
    "Favorites"
}
```

## 🔐 Sistema de Segurança Adicional

### Anti-Cheat Básico
```lua
local AntiCheat = {}

function AntiCheat:ValidatePlayerAction(player, action)
    -- Verifica teleporte suspeito
    if action.Type == "Attack" then
        local distance = action.Distance
        if distance > 50 then
            warn("Possível exploit detectado:", player.Name)
            return false
        end
    end
    
    return true
end
```

### Rate Limiting
```lua
local RateLimiter = {}
RateLimiter.Limits = {}

function RateLimiter:CheckLimit(player, action, maxPerSecond)
    local key = player.UserId .. "_" .. action
    local now = tick()
    
    if not self.Limits[key] then
        self.Limits[key] = {Count = 0, LastReset = now}
    end
    
    local limit = self.Limits[key]
    
    -- Reset a cada segundo
    if now - limit.LastReset >= 1 then
        limit.Count = 0
        limit.LastReset = now
    end
    
    limit.Count = limit.Count + 1
    
    return limit.Count <= maxPerSecond
end
```

## 📱 Integração com Roblox Services

### Gamepasses
```lua
local Gamepasses = {
    VIP = {
        ID = 123456,
        Benefits = {
            XPMultiplier = 2.0,
            CashMultiplier = 1.5,
            ExtraSlots = 2  -- Mais slots de sombra
        }
    }
}
```

### Developer Products
```lua
local Products = {
    {
        ID = 789012,
        Name = "1000 Diamantes",
        Price = 100,  -- Robux
        Reward = {Diamonds = 1000}
    }
}
```

---

## 📚 Recursos Adicionais

### Assets Recomendados
- **Sons**: Biblioteca de áudio do Roblox
- **Efeitos**: Partículas para ataques
- **Modelos**: Roblox Marketplace para NPCs
- **UI**: Templates do Roblox

### Comunidade
- **DevForum**: Roblox Developer Forum
- **YouTube**: Tutoriais de Roblox
- **Discord**: Comunidades de desenvolvimento

---

**Este arquivo contém exemplos e ideias para expandir seu jogo!**
**Use-os como inspiração para criar algo único!** 🚀
