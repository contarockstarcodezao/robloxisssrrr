# ⚙️ Guia de Configuração - Shadow Hunter

Este guia mostra como personalizar e configurar o jogo Shadow Hunter.

## 🎨 Personalizando NPCs

### Adicionar Novo NPC

Edite: `ReplicatedStorage/Modules/NPCData.lua`

```lua
{
    Name = "Seu NPC",
    Rank = "S",              -- Rank do NPC (F, E, D, C, B, A, S, SS, SSS, GM)
    Health = 10000,          -- Vida total
    Damage = 400,            -- Dano base
    Defense = 150,           -- Defesa (reduz dano recebido)
    XPReward = 1000,         -- XP concedido ao derrotar
    Level = 90,              -- Level do NPC
    Zone = "EliteZone",      -- Zona onde aparece
    ShadowDropChance = 0.25, -- Chance de dropar sombra (0.0 - 1.0)
    Drops = {
        {Item = "Cash", Amount = {1500, 2500}, Chance = 1.0},
        {Item = "Diamonds", Amount = {150, 250}, Chance = 0.85}
    },
    ModelColor = Color3.fromRGB(255, 100, 0), -- Cor do modelo
    AttackRange = 18,        -- Range de ataque
    DetectionRange = 80      -- Range de detecção
}
```

### Configurar Drops de NPC

Estrutura de drop:
```lua
Drops = {
    {
        Item = "Cash",           -- Tipo de item (Cash, Diamonds)
        Amount = {min, max},     -- Quantidade aleatória entre min e max
        Chance = 1.0             -- Chance de drop (0.0 = 0%, 1.0 = 100%)
    }
}
```

### Personalizar Aparência de NPC

Para mudar a aparência:
1. Localize a função `CreateNPCModel` em `NPCManager.lua`
2. Modifique:
   - `torso.Size` - Tamanho do corpo
   - `head.Size` - Tamanho da cabeça
   - Use `npcData.ModelColor` para cores personalizadas

## 🏆 Configurando Ranks

### Modificar Ranks Existentes

Edite: `ReplicatedStorage/Modules/RankData.lua`

```lua
{
    Name = "S",              -- Nome do rank
    Level = 90,              -- Level mínimo necessário
    Color = Color3.fromRGB(255, 215, 0), -- Cor do rank
    RequiredXP = 60000,      -- XP acumulado necessário
    Multiplier = 4.0,        -- Multiplicador de recompensas
    Order = 7                -- Ordem do rank (1 = mais baixo)
}
```

### Adicionar Novo Rank

1. Adicione nova entrada em `RankData.Ranks`
2. Certifique-se de que `Order` está correto
3. Crie missões correspondentes em `MissionSystem.lua`

## 🎯 Configurando Missões

### Adicionar Nova Missão

Edite: `ServerScriptService/Core/MissionSystem.lua`

```lua
{
    ID = "S_TO_SS_1",              -- ID único
    Name = "Nome da Missão",       -- Nome exibido
    Description = "Descrição",      -- Descrição
    RequiredRank = "S",            -- Rank necessário
    RewardRank = "SS",             -- Rank concedido ao completar
    Type = "KillNPCs",             -- Tipo de missão
    Target = {                      -- Objetivo
        MinRank = "S",             -- Rank mínimo dos NPCs (opcional)
        Rank = "S",                -- Rank específico (opcional)
        Zone = "EliteZone",        -- Zona específica (opcional)
        Count = 30                 -- Quantidade necessária
    },
    Rewards = {
        Cash = 30000,              -- Recompensa de cash
        Diamonds = 3000,           -- Recompensa de diamantes
        XP = 15000                 -- Recompensa de XP
    }
}
```

### Tipos de Missões

**1. KillNPCs** - Derrotar NPCs
```lua
Type = "KillNPCs",
Target = {
    MinRank = "S",    -- Rank mínimo (opcional)
    Rank = "F",       -- Rank específico (opcional)
    Zone = "EliteZone", -- Zona específica (opcional)
    Count = 10        -- Quantidade
}
```

**2. CaptureShadows** - Capturar sombras
```lua
Type = "CaptureShadows",
Target = {
    Count = 5  -- Quantidade
}
```

**3. CollectShadows** - Ter sombras no inventário
```lua
Type = "CollectShadows",
Target = {
    Count = 15  -- Quantidade total no inventário
}
```

## 🗺️ Configurando Zonas

### Adicionar Nova Zona

Edite: `ServerScriptService/Zones/ZoneManager.lua`

```lua
{
    Name = "MyZone",                    -- Nome interno
    DisplayName = "Minha Zona",         -- Nome exibido
    RequiredRank = "A",                 -- Rank mínimo para acesso
    SpawnPoint = Vector3.new(1000, 10, 0), -- Posição da zona
    NPCs = {"NPC1", "NPC2", "NPC3"},   -- NPCs que aparecem
    NPCCount = 8,                       -- Quantidade de NPCs
    Color = Color3.fromRGB(255, 0, 255) -- Cor da zona
}
```

### Criar Portal para Nova Zona

Após adicionar a zona, adicione portal em `Init`:
```lua
self:CreatePortal("ZonaOrigem", "MinhaNovaZona")
```

### Ajustar Spawn de NPCs por Zona

1. Configure `NPCCount` - Quantidade total de NPCs
2. Configure `NPCs` - Lista de NPCs que podem aparecer
3. Sistema escolhe aleatoriamente da lista

## ⚔️ Balanceamento de Combate

### Configurações Globais

Edite: `ServerScriptService/Combat/CombatSystem.lua`

```lua
CombatSystem.Config = {
    AttackCooldown = 1.0,  -- Tempo entre ataques (segundos)
    BaseDamage = 20,       -- Dano base do jogador
    AttackRange = 10       -- Range de ataque
}
```

### Fórmula de Dano

Dano do Jogador:
```lua
Dano Base (20)
× (1 + (Level - 1) × 0.05)      -- +5% por level
× (1 + RankBonus)               -- +10% por ordem de rank
+ (SombrasEquipadas × 10%)      -- +10% do dano de cada sombra
```

### Ajustar Defesa de NPCs

Quanto maior a defesa, menos dano o NPC recebe:
```lua
DanoFinal = max(1, DanoBase - DefesaNPC)
```

## 👻 Sistema de Sombras

### Configurar Chances de Captura

Edite: `ReplicatedStorage/Modules/ShadowData.lua`

```lua
-- Chances por tentativa (3 tentativas)
function ShadowData:CalculateCaptureSuccess(attemptNumber)
    local chances = {0.40, 0.30, 0.20}  -- Modificar aqui
    -- Tentativa 1: 40%
    -- Tentativa 2: 30%
    -- Tentativa 3: 20%
end
```

### Configurar Balanceamento de Rank da Sombra

```lua
ShadowData.SameRankChances = {
    ["F"] = 0.70,   -- 70% de dropar mesmo rank
    ["E"] = 0.75,
    ["D"] = 0.80,
    -- ... ajuste conforme necessário
}
```

### Propriedades de Sombras por Rank

```lua
ShadowData.ShadowProperties = {
    ["S"] = {
        DamageMultiplier = 7.5,    -- Dano × 7.5
        HealthMultiplier = 6.0,    -- Vida × 6.0
        AttackSpeed = 1.8,         -- Velocidade de ataque
        Range = 32                 -- Range de ataque
    }
}
```

### Ajustar Diamantes por Destruição

```lua
function ShadowData:CalculateDestroyDiamonds(npcRank)
    local baseDiamonds = rankOrder * 10  -- Modificar multiplicador
    local variance = math.random(-5, 15) -- Variação
    return math.max(5, baseDiamonds + variance)
end
```

## 💰 Economia do Jogo

### Valores Iniciais

Edite: `ServerScriptService/Core/DataManager.lua`

```lua
local function GetDefaultData()
    return {
        Level = 1,
        XP = 0,
        Rank = "F",
        Cash = 100,      -- Cash inicial
        Diamonds = 10,   -- Diamantes iniciais
        -- ...
    }
end
```

### Fórmula de XP por Level

```lua
function DataManager:GetRequiredXP(level)
    return math.floor(100 * (level ^ 1.5))  -- Modificar aqui
end
```

Exemplos:
- Level 1 → 2: 100 XP
- Level 10 → 11: 3,162 XP
- Level 50 → 51: 35,355 XP

## 🎨 Personalização de UI

### Cores do HUD

Edite: `StarterPlayer/StarterPlayerScripts/UI/HUDController.lua`

```lua
-- Background do frame principal
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

-- Barra de XP
xpBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)

-- Cash
cashFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)

-- Diamantes
diamondFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
```

### Tamanho e Posição do HUD

```lua
-- Frame principal
mainFrame.Size = UDim2.new(0, 350, 0, 200)  -- Largura, Altura
mainFrame.Position = UDim2.new(0, 20, 0, 20) -- X, Y
```

### Duração de Notificações

```lua
function HUDController:ShowNotification(...)
    -- ...
    wait(4)  -- Modificar tempo (segundos)
    -- ...
end
```

## 🔄 Sistema de Respawn

### Configurar Tempo de Respawn de NPCs

Edite: `ServerScriptService/Zones/ZoneManager.lua`

```lua
function ZoneManager:StartNPCRespawn()
    spawn(function()
        while true do
            wait(30)  -- Modificar tempo (segundos)
            -- ...
        end
    end)
end
```

### Configurar Tempo do Prompt de Captura

Edite: `ServerScriptService/Combat/NPCManager.lua`

```lua
function NPCManager:CreateCapturePrompt(npc, npcData)
    -- ...
    game:GetService("Debris"):AddItem(promptPart, 30)  -- Modificar tempo
    -- ...
end
```

## 💾 DataStore

### Configurar Auto-Save

Edite: `ServerScriptService/Core/DataManager.lua`

```lua
function DataManager:StartAutoSave()
    spawn(function()
        while true do
            wait(300)  -- Modificar tempo (5 minutos = 300 segundos)
            -- ...
        end
    end)
end
```

### Versão do DataStore

```lua
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData_V1")
-- Modificar "V1" para resetar dados (cuidado!)
```

## 🎮 Configurações de Gameplay

### Máximo de Sombras Equipadas

Edite: `ServerScriptService/Core/DataManager.lua`

```lua
function DataManager:EquipShadow(player, shadowID)
    -- ...
    if #data.EquippedShadows >= 3 then  -- Modificar limite
        return false, "Máximo de 3 sombras equipadas"
    end
    -- ...
end
```

### Range de Interação com Prompts

Edite: `StarterPlayer/StarterPlayerScripts/Client/ShadowClient.lua`

```lua
ShadowClient.InteractionRange = 15  -- Modificar distância
```

### Range de Ataque

Edite: `StarterPlayer/StarterPlayerScripts/Client/CombatClient.lua`

```lua
CombatClient.AttackRange = 10  -- Modificar distância
```

## 🔧 Dicas de Balanceamento

### Para Tornar o Jogo Mais Fácil:
1. ↑ Aumentar `ShadowDropChance` dos NPCs
2. ↑ Aumentar chances de captura em `ShadowData`
3. ↓ Reduzir `Health` e `Defense` dos NPCs
4. ↑ Aumentar `BaseDamage` do jogador
5. ↑ Aumentar `Cash` e `Diamonds` iniciais

### Para Tornar o Jogo Mais Difícil:
1. ↓ Reduzir `ShadowDropChance` dos NPCs
2. ↓ Reduzir chances de captura
3. ↑ Aumentar `Health` e `Defense` dos NPCs
4. ↓ Reduzir `BaseDamage` do jogador
5. ↓ Reduzir recompensas de missões

### Para Progressão Mais Rápida:
1. ↓ Reduzir `RequiredXP` dos ranks
2. ↑ Aumentar `XPReward` dos NPCs
3. ↓ Reduzir requisitos de missões
4. ↑ Aumentar recompensas de XP

### Para Progressão Mais Lenta:
1. ↑ Aumentar `RequiredXP` dos ranks
2. ↓ Reduzir `XPReward` dos NPCs
3. ↑ Aumentar requisitos de missões
4. ↓ Reduzir recompensas de XP

## 📊 Testes e Debug

### Habilitar Modo Debug

Adicione no início de `MainServer.lua`:
```lua
local DEBUG_MODE = true

if DEBUG_MODE then
    -- Conceder recursos extras para teste
    game.Players.PlayerAdded:Connect(function(player)
        wait(2)
        local data = DataManager:GetPlayerData(player)
        data.Cash = 999999
        data.Diamonds = 99999
        data.Level = 50
    end)
end
```

### Comandos Úteis no Command Bar

```lua
-- Resetar dados de um jogador
local player = game.Players:FindFirstChild("NomeDoJogador")
local DataStore = game:GetService("DataStoreService"):GetDataStore("PlayerData_V1")
DataStore:RemoveAsync(player.UserId)

-- Conceder rank
local RankSystem = require(game.ServerScriptService.Core.RankSystem)
RankSystem:GrantRank(player, "S")

-- Adicionar XP
local DataManager = require(game.ServerScriptService.Core.DataManager)
DataManager:AddXP(player, 10000)
```

## 🚀 Otimizações de Performance

### Reduzir NPCs Simultâneos
```lua
-- Em cada zona
NPCCount = 5  -- Reduzir de 10 para 5
```

### Aumentar Intervalo de Updates
```lua
-- CombatSystem auto-attack
wait(2)  -- De 1 para 2 segundos

-- ZoneManager respawn
wait(60)  -- De 30 para 60 segundos
```

---

**Dica:** Sempre teste suas mudanças antes de publicar!  
**Backup:** Faça backup dos arquivos antes de modificar!
