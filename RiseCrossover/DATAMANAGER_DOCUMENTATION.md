# 📘 DataManager - Documentação Completa

## 🎯 Visão Geral

O **DataManager** é um sistema robusto e completo de gerenciamento de dados para jogos Roblox, com foco em confiabilidade, segurança e facilidade de uso.

## ✨ Funcionalidades Principais

### 🔐 Segurança e Confiabilidade
- ✅ **Sistema de Retry**: Até 3 tentativas em caso de falha
- ✅ **Backup Automático**: Backup de dados em DataStore separado
- ✅ **Validação de Dados**: Verifica integridade dos dados carregados
- ✅ **Tratamento de Erros**: Proteção contra erros críticos
- ✅ **Migração de Dados**: Atualiza dados de versões antigas automaticamente

### 💾 Persistência
- ✅ **Auto-Save**: Salva automaticamente a cada 3 minutos
- ✅ **Save on Leave**: Salva quando jogador sai
- ✅ **Save on Shutdown**: Salva todos antes de fechar servidor
- ✅ **Cache em Sessão**: Dados em memória para acesso rápido

### 📊 Estrutura de Dados Completa
- ✅ **Progressão**: XP, Level, Rank, Status Points
- ✅ **Stats**: PlayerSpeed, PlayerDamage, ShadowSpeed, etc.
- ✅ **Inventários**: Sombras, Armas, Relíquias, Itens
- ✅ **Economia**: Gold, Gems, Crystals (3 moedas)
- ✅ **Social**: Guild, Friends, Party
- ✅ **Missões**: Ativas, Completadas, Diárias
- ✅ **Estatísticas**: NPCs mortos, Bosses derrotados, etc.
- ✅ **Conquistas**: Achievements e Títulos

## 📁 Estrutura de Dados

```lua
{
    -- Básico
    Version = 2,
    CreatedAt = timestamp,
    LastLogin = timestamp,
    PlayTime = seconds,
    
    -- Progressão
    XP = 0,
    Level = 1,
    Rank = "F", -- F, E, D, C, B, A, S, SS, SSS, GM
    StatusPoints = 0,
    
    -- Stats
    Stats = {
        PlayerSpeed = 0,
        PlayerDamage = 0,
        PlayerHealth = 0,
        PlayerDefense = 0,
        ShadowSpeed = 0,
        ShadowDamage = 0,
        ShadowRange = 0,
        ShadowCapacity = 3,
    },
    
    -- Inventários
    Shadows = {}, -- Lista de sombras capturadas
    Weapons = {}, -- Lista de armas
    Relics = {}, -- Lista de relíquias
    Items = {}, -- Itens consumíveis
    
    -- Economia (3 moedas!)
    Currency = {
        Gold = 100,
        Gems = 10,
        Crystals = 0,
    },
    
    -- Equipamento
    Equipped = {
        Weapon = nil,
        Shadows = {}, -- Max 3
        Relics = {},
    },
    
    -- Social
    Guild = nil,
    Friends = {},
    PartyID = nil,
    
    -- Missões
    Missions = {
        Active = {},
        Completed = {},
        Daily = {},
    },
    
    -- Conquistas
    Achievements = {},
    Titles = {},
    EquippedTitle = nil,
    
    -- Estatísticas
    Statistics = {
        NPCsKilled = 0,
        BossesDefeated = 0,
        ShadowsCaptured = 0,
        DungeonsCompleted = 0,
        PvPWins = 0,
        PvPLosses = 0,
        DamageDealt = 0,
        DamageTaken = 0,
        Deaths = 0,
    },
    
    -- Configurações
    Settings = {
        MusicVolume = 0.5,
        SFXVolume = 0.7,
        ShowDamageNumbers = true,
        AutoEquipShadows = false,
    },
    
    -- Outros
    Banned = false,
    DailyRewardClaimed = 0,
    LoginStreak = 0,
}
```

## 🔧 API - Funções Disponíveis

### Inicialização

```lua
DataManager:Init()
```
Inicializa o sistema. **Chame apenas uma vez no servidor!**

---

### Obter Dados

```lua
local data = DataManager:GetPlayerData(player)
```
Retorna a tabela completa de dados do jogador.

```lua
local isLoaded = DataManager:IsDataLoaded(player)
```
Verifica se os dados foram carregados com sucesso.

---

### XP e Level

```lua
DataManager:AddXP(player, amount)
```
Adiciona XP ao jogador. **Level up automático!**

**Exemplo:**
```lua
DataManager:AddXP(player, 100) -- Adiciona 100 XP
```

```lua
local requiredXP = DataManager:GetRequiredXP(level)
```
Retorna XP necessário para o próximo level.

**Fórmula:** `100 × (level ^ 1.5)`

---

### Stats

```lua
DataManager:UpdateStat(player, statName, value)
```
Define um stat para um valor específico.

**Exemplo:**
```lua
DataManager:UpdateStat(player, "PlayerDamage", 50)
```

```lua
DataManager:IncrementStat(player, statName, amount)
```
Incrementa um stat.

**Exemplo:**
```lua
DataManager:IncrementStat(player, "PlayerSpeed", 10)
```

---

### Moedas

```lua
DataManager:AddCurrency(player, currencyType, amount)
```
Adiciona moeda. **Tipos:** `"Gold"`, `"Gems"`, `"Crystals"`

**Exemplo:**
```lua
DataManager:AddCurrency(player, "Gold", 500)
DataManager:AddCurrency(player, "Gems", 10)
```

```lua
local success = DataManager:RemoveCurrency(player, currencyType, amount)
```
Remove moeda. **Retorna `true` se teve sucesso (jogador tinha dinheiro suficiente).**

**Exemplo:**
```lua
if DataManager:RemoveCurrency(player, "Gold", 1000) then
    print("Compra realizada!")
else
    print("Dinheiro insuficiente!")
end
```

---

### Sombras

```lua
local success, shadowID = DataManager:AddShadow(player, shadowData)
```
Adiciona uma sombra ao inventário.

**Exemplo:**
```lua
local shadowData = {
    Name = "Shadow Goku",
    Rank = "S",
    Level = 1,
    Damage = 500,
    Speed = 100,
}

local success, id = DataManager:AddShadow(player, shadowData)
print("Shadow ID:", id)
```

```lua
DataManager:RemoveShadow(player, shadowID)
```
Remove uma sombra.

```lua
local success, message = DataManager:EquipShadow(player, shadowID)
```
Equipa uma sombra. **Máximo 3 equipadas!**

**Exemplo:**
```lua
local success, msg = DataManager:EquipShadow(player, shadowID)
if not success then
    print("Erro:", msg)
end
```

```lua
DataManager:UnequipShadow(player, shadowID)
```
Desequipa uma sombra.

---

### Armas

```lua
local success, weaponID = DataManager:AddWeapon(player, weaponData)
```
Adiciona uma arma.

**Exemplo:**
```lua
local weaponData = {
    Name = "Espada Sombria",
    Type = "Sword",
    Damage = 150,
    Special = "Corte das Sombras",
}

DataManager:AddWeapon(player, weaponData)
```

```lua
DataManager:EquipWeapon(player, weaponID)
```
Equipa uma arma.

---

### Relíquias

```lua
local success, relicID = DataManager:AddRelic(player, relicData)
```
Adiciona uma relíquia.

**Exemplo:**
```lua
local relicData = {
    Name = "Anel do Monarca",
    Rarity = "Legendary",
    Effect = "+50% Shadow Damage",
}

DataManager:AddRelic(player, relicData)
```

---

### Estatísticas

```lua
DataManager:IncrementStatistic(player, statName, amount)
```
Incrementa uma estatística.

**Exemplo:**
```lua
DataManager:IncrementStatistic(player, "NPCsKilled", 1)
DataManager:IncrementStatistic(player, "DamageDealt", 500)
```

---

### Save Manual

```lua
DataManager:SavePlayerData(player)
```
Salva manualmente os dados do jogador.

**Nota:** Não é necessário chamar sempre, pois há auto-save!

---

## 📝 Exemplos de Uso

### Exemplo 1: Sistema de Level Up

```lua
-- Quando jogador mata um NPC
local function OnNPCKilled(player, npc)
    local xpReward = 50
    
    -- Adiciona XP (level up automático)
    DataManager:AddXP(player, xpReward)
    
    -- Adiciona gold
    DataManager:AddCurrency(player, "Gold", 100)
    
    -- Atualiza estatística
    DataManager:IncrementStatistic(player, "NPCsKilled", 1)
    
    -- Obtém dados para verificar level
    local data = DataManager:GetPlayerData(player)
    print(player.Name, "está no level", data.Level)
end
```

### Exemplo 2: Sistema de Captura de Sombras

```lua
-- Quando jogador captura uma sombra
local function CaptureShadow(player, npcName, npcRank)
    local shadowData = {
        Name = npcName,
        Rank = npcRank,
        Level = 1,
        Damage = 100,
        Speed = 50,
        Range = 20,
    }
    
    local success, shadowID = DataManager:AddShadow(player, shadowData)
    
    if success then
        print("Sombra capturada! ID:", shadowID)
        
        -- Auto-equipa se possível
        local equipped, msg = DataManager:EquipShadow(player, shadowID)
        if equipped then
            print("Sombra equipada automaticamente!")
        else
            print("Não foi possível equipar:", msg)
        end
    end
end
```

### Exemplo 3: Sistema de Loja

```lua
-- Sistema de compra
local function BuyItem(player, itemName, price)
    -- Verifica se tem dinheiro
    local data = DataManager:GetPlayerData(player)
    
    if data.Currency.Gold >= price then
        -- Remove gold
        if DataManager:RemoveCurrency(player, "Gold", price) then
            -- Adiciona item ao inventário
            -- (você precisaria criar uma função AddItem similar)
            print("Item comprado!")
            return true
        end
    else
        print("Gold insuficiente!")
        return false
    end
end
```

### Exemplo 4: Sistema de Stats

```lua
-- Quando jogador usa pontos de status
local function AllocateStatusPoint(player, statName)
    local data = DataManager:GetPlayerData(player)
    
    if data.StatusPoints > 0 then
        -- Usa 1 ponto
        data.StatusPoints = data.StatusPoints - 1
        
        -- Aumenta stat
        DataManager:IncrementStat(player, statName, 10)
        
        print("Stat aumentado:", statName)
        return true
    else
        print("Sem pontos de status!")
        return false
    end
end
```

### Exemplo 5: Daily Login Reward

```lua
-- Verifica se pode receber recompensa diária
local function ClaimDailyReward(player)
    local data = DataManager:GetPlayerData(player)
    local lastClaim = data.DailyRewardClaimed or 0
    local timeSince = os.time() - lastClaim
    
    if timeSince >= 86400 then -- 24 horas
        -- Recompensa baseada em streak
        local streak = data.LoginStreak or 1
        local goldReward = 100 * streak
        local gemReward = streak
        
        DataManager:AddCurrency(player, "Gold", goldReward)
        DataManager:AddCurrency(player, "Gems", gemReward)
        
        data.DailyRewardClaimed = os.time()
        
        print(string.format("Dia %d! Ganhou %d gold e %d gems!", 
            streak, goldReward, gemReward))
        return true
    else
        print("Já recebeu hoje!")
        return false
    end
end
```

---

## ⚙️ Configurações

Edite as configurações no início do `DataManager.lua`:

```lua
local CONFIG = {
    DataStoreName = "PlayerData_V2", -- Nome do DataStore
    BackupStoreName = "PlayerBackup_V2", -- Nome do backup
    AutoSaveInterval = 180, -- Auto-save a cada 3 min
    MaxRetries = 3, -- Tentativas de retry
    RetryDelay = 1, -- Delay entre retries
    UseBackup = true, -- Usar backup
    DebugMode = false, -- Prints extras (use true para debug)
}
```

---

## 🔄 Migração de Dados

O sistema detecta automaticamente versões antigas e migra os dados!

**Exemplo:** Se você mudar `Currency` de `number` para `table`, o sistema migra automaticamente:

```lua
-- V1 (antigo)
Currency = 500

-- V2 (novo) - migrado automaticamente!
Currency = {
    Gold = 500,
    Gems = 0,
    Crystals = 0,
}
```

---

## 🛡️ Sistema de Backup

- ✅ Backup automático em cada save
- ✅ DataStore separado para backups
- ✅ Restauração automática se dados corrompidos

---

## 🔍 Debug

Para ativar modo debug:

```lua
CONFIG.DebugMode = true
```

Isso mostrará prints detalhados de:
- Load/Save de dados
- Auto-saves
- Migrações
- Erros

---

## ⚠️ Importante

### Leaderstats
O sistema cria automaticamente `leaderstats` com:
- **Level**
- **Rank**
- **Gold**

Eles são atualizados automaticamente quando você modifica os dados!

### Performance
- Dados são armazenados em **cache de sessão** (rápido)
- Save acontece apenas no DataStore (sem lag no jogo)
- Auto-save otimizado (apenas jogadores com dados carregados)

### Segurança
- ✅ Validação de dados ao carregar
- ✅ Retry automático em falhas
- ✅ Backup de segurança
- ✅ Proteção contra dados corrompidos

---

## 📊 Diferenças do Seu Código Antigo

| Recurso | Código Antigo | Novo DataManager |
|---------|---------------|------------------|
| **Retry** | ❌ Não | ✅ Até 3 tentativas |
| **Backup** | ❌ Não | ✅ DataStore separado |
| **Validação** | ❌ Não | ✅ Completa |
| **Migração** | ❌ Não | ✅ Automática |
| **Moedas** | 1 tipo | 3 tipos (Gold, Gems, Crystals) |
| **Auto-Save** | ❌ Não | ✅ A cada 3 min |
| **Estatísticas** | ❌ Não | ✅ 9 estatísticas |
| **Equipamento** | Básico | ✅ Completo (Armas, Sombras, Relíquias) |
| **Daily Rewards** | ❌ Não | ✅ Com login streak |
| **Leaderstats** | Básico | ✅ Auto-atualizado |

---

## 🚀 Instalação

1. Crie a pasta `Core` em `ServerScriptService`
2. Cole o código do `DataManager.lua`
3. Crie `Init.lua` em `ServerScriptService`
4. Cole o código do `Init.lua`
5. Teste! (F5)

---

## 📞 Exemplo Completo de Uso

```lua
-- Em qualquer script do servidor
local DataManager = _G.DataManager

-- Quando jogador mata NPC
Players.PlayerAdded:Connect(function(player)
    wait(1) -- Aguarda dados carregarem
    
    -- Obtém dados
    local data = DataManager:GetPlayerData(player)
    print("Level:", data.Level)
    print("XP:", data.XP)
    print("Gold:", data.Currency.Gold)
    
    -- Adiciona XP
    DataManager:AddXP(player, 100)
    
    -- Adiciona moeda
    DataManager:AddCurrency(player, "Gold", 500)
end)
```

---

**DataManager Completo e Profissional!** 🎮✨
