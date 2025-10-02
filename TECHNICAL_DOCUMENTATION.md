# 📘 Documentação Técnica - Shadow Hunter

## 🏗️ Arquitetura do Sistema

### Visão Geral
Shadow Hunter é construído com uma arquitetura modular cliente-servidor, separando claramente a lógica de jogo e a apresentação.

```
Client (LocalScripts)
    ↕️ RemoteEvents/RemoteFunctions
Server (Scripts)
    ↕️ DataStore
Player Data Storage
```

## 🗂️ Estrutura de Módulos

### 📦 ReplicatedStorage/Modules

#### RankData.lua
**Propósito:** Define todos os ranks do jogo e suas propriedades

**Funções Principais:**
```lua
RankData:GetRankByName(name) -> RankInfo
RankData:GetRankByLevel(level) -> RankInfo
RankData:GetNextRank(currentRankName) -> RankInfo
RankData:CompareRanks(rank1, rank2) -> number
```

**Estrutura de Dados:**
```lua
{
    Name = "S",
    Level = 90,
    Color = Color3.fromRGB(255, 215, 0),
    RequiredXP = 60000,
    Multiplier = 4.0,
    Order = 7
}
```

#### NPCData.lua
**Propósito:** Define todos os NPCs, suas estatísticas e drops

**Funções Principais:**
```lua
NPCData:GetNPCByName(name) -> NPCInfo
NPCData:GetNPCsByRank(rank) -> {NPCInfo}
NPCData:GetNPCsByZone(zone) -> {NPCInfo}
```

**Estrutura de Dados:**
```lua
{
    Name = "Goku",
    Rank = "S",
    Health = 12000,
    Damage = 500,
    Defense = 180,
    XPReward = 1200,
    Level = 100,
    Zone = "EliteZone",
    ShadowDropChance = 0.25,
    Drops = {...},
    ModelColor = Color3,
    AttackRange = 20,
    DetectionRange = 90
}
```

#### ShadowData.lua
**Propósito:** Gerencia sistema de sombras, captura e balanceamento

**Funções Principais:**
```lua
ShadowData:DetermineShadowRank(npcRank) -> string
ShadowData:CreateShadow(npcName, npcData) -> Shadow
ShadowData:GetShadowStats(shadow) -> Stats
ShadowData:CalculateCaptureSuccess(attemptNumber) -> boolean
ShadowData:CalculateDestroyDiamonds(npcRank) -> number
```

**Sistema de Balanceamento:**
- Rank F: 70% chance de dropar mesma raridade
- Rank S: 90% chance de dropar mesma raridade
- Rank GM: 98% chance de dropar mesma raridade
- 3 tentativas de captura: 40%, 30%, 20%

### 🔧 ServerScriptService/Core

#### DataManager.lua
**Propósito:** Gerenciamento completo de dados do jogador com DataStore

**Funções Principais:**
```lua
DataManager:LoadPlayerData(player) -> PlayerData
DataManager:SavePlayerData(player) -> boolean
DataManager:GetPlayerData(player) -> PlayerData
DataManager:AddXP(player, amount)
DataManager:AddCash(player, amount)
DataManager:AddDiamonds(player, amount)
DataManager:AddShadow(player, shadowData) -> boolean
DataManager:EquipShadow(player, shadowID) -> boolean, message
DataManager:UnequipShadow(player, shadowID) -> boolean
DataManager:GetEquippedShadows(player) -> {Shadow}
```

**Estrutura PlayerData:**
```lua
{
    Level = 1,
    XP = 0,
    Rank = "F",
    Cash = 100,
    Diamonds = 10,
    Shadows = {},
    Weapons = {},
    EquippedShadows = {},
    CurrentMissions = {},
    CompletedMissions = {},
    Stats = {
        NPCsKilled = 0,
        ShadowsCaptured = 0,
        ShadowsDestroyed = 0,
        DamageDealt = 0,
        TotalPlayTime = 0
    },
    Settings = {...},
    LastLogin = os.time(),
    CreatedAt = os.time()
}
```

**Auto-Save:** Salva dados a cada 5 minutos

#### RankSystem.lua
**Propósito:** Gerencia sistema de ranks e progressão

**Funções Principais:**
```lua
RankSystem:CanAccessZone(player, requiredRank) -> boolean
RankSystem:GetPlayerRankInfo(player) -> RankInfo
RankSystem:GrantRank(player, rankName) -> boolean
RankSystem:GetRewardMultiplier(player) -> number
RankSystem:GetDamageBonus(player) -> number
RankSystem:GetAllPlayerRanks() -> {PlayerRank}
```

#### MissionSystem.lua
**Propósito:** Sistema de missões para progressão

**Tipos de Missões:**
- `KillNPCs` - Derrotar NPCs específicos
- `CaptureShadows` - Capturar número de sombras
- `CollectShadows` - Ter número de sombras no inventário

**Funções Principais:**
```lua
MissionSystem:AssignMissions(player)
MissionSystem:UpdateProgress(player, missionType, additionalData)
MissionSystem:CompleteMission(player, mission)
MissionSystem:GetPlayerMissions(player) -> {Mission}
```

### ⚔️ ServerScriptService/Combat

#### NPCManager.lua
**Propósito:** Gerencia spawn, comportamento e vida dos NPCs

**Funções Principais:**
```lua
NPCManager:CreateNPCModel(npcData) -> Model
NPCManager:CreateHealthBar(npc, npcData)
NPCManager:UpdateHealthBar(npc, currentHealth, maxHealth)
NPCManager:SpawnNPC(npcName, position, zone) -> Model
NPCManager:DamageNPC(npc, damage, attacker) -> boolean
NPCManager:CreateCapturePrompt(npc, npcData)
NPCManager:ShowDamageNumber(npc, damage)
```

**Sistema de Barra de Vida:**
- Verde: > 50% HP
- Amarelo: 25-50% HP
- Vermelho: < 25% HP

#### CombatSystem.lua
**Propósito:** Sistema principal de combate

**Funções Principais:**
```lua
CombatSystem:PlayerAttackNPC(player, npc) -> boolean, message
CombatSystem:CalculatePlayerDamage(player) -> number
CombatSystem:ShadowAttackNPC(player, shadowID, npc) -> boolean
CombatSystem:HandleNPCDeath(npc, killer)
CombatSystem:ProcessDrops(player, npcData)
CombatSystem:CreateAttackEffect(origin, target)
```

**Cálculo de Dano:**
```lua
Dano Base = 20
+ Bônus de Level (5% por level)
+ Bônus de Rank (10% por ordem de rank)
+ Bônus de Sombras Equipadas (10% do dano de cada sombra)
- Defesa do NPC
= Dano Final
```

**Sistema de Auto-Ataque:**
- Sombras equipadas atacam automaticamente NPCs no range
- Verifica a cada 1 segundo
- Máximo 3 sombras equipadas

#### ShadowSystem.lua
**Propósito:** Sistema de captura e gerenciamento de sombras

**Funções Principais:**
```lua
ShadowSystem:AttemptCapture(player, npcName, npcRank) -> boolean, message, shadow
ShadowSystem:DestroyShadow(player, npcName, npcRank) -> boolean, message, diamonds
ShadowSystem:EquipShadow(player, shadowID) -> boolean, message
ShadowSystem:UnequipShadow(player, shadowID) -> boolean
ShadowSystem:CreateShadowVisuals(player)
```

**Sistema de Captura:**
1. Jogador derrota NPC
2. Aparece prompt de captura (30 segundos)
3. 3 tentativas com chances: 40%, 30%, 20%
4. Se falhar em todas, sombra desaparece
5. Alternativa: Destruir por diamantes

### 🗺️ ServerScriptService/Zones

#### ZoneManager.lua
**Propósito:** Gerencia zonas, portais e spawn de NPCs

**Zonas Disponíveis:**
1. **Floresta Silenciosa** (F+) - Zona Iniciante
2. **Deserto Árido** (D+) - Zona Intermediária
3. **Montanhas Congeladas** (B+) - Zona Avançada
4. **Vulcão Sombrio** (S+) - Zona Elite
5. **Abismo Eterno** (SSS+) - Zona Lendária

**Funções Principais:**
```lua
ZoneManager:CreateZone(zoneData) -> Folder
ZoneManager:SpawnNPCsInZone(zoneData)
ZoneManager:CreatePortal(fromZone, toZone) -> Part
ZoneManager:TeleportToZone(player, zoneName) -> boolean
ZoneManager:StartNPCRespawn()
```

**Sistema de Respawn:**
- Verifica a cada 30 segundos
- Spawna NPCs faltantes até o limite da zona
- Distribuição aleatória dos NPCs da zona

## 💻 Client-Side

### CombatClient.lua
**Propósito:** Input e feedback visual de combate

**Controles:**
- **Clique Esquerdo** ou **Espaço**: Atacar NPC mais próximo
- **Highlight**: NPC no range fica destacado

### ShadowClient.lua
**Propósito:** Input para captura de sombras

**Controles:**
- **E**: Tentar capturar sombra (Arise)
- **F**: Destruir sombra e coletar diamantes

### HUDController.lua
**Propósito:** Interface do usuário

**Elementos do HUD:**
- Avatar do jogador (placeholder)
- Nome e Rank (com cor)
- Level atual
- Barra de XP com progresso
- Cash (💰)
- Diamantes (💎)
- Botão de Inventário

**Sistema de Notificações:**
- Aparecem no topo da tela
- Animação suave de entrada/saída
- Auto-remove após 4 segundos
- Cores customizáveis

## 🔄 Comunicação Cliente-Servidor

### RemoteEvents
```lua
-- Combate
AttackNPC(npc)
NPCDied(npc, npcData)

-- Sombras
CaptureShadow(npcName, npcRank)
DestroyShadow(npcName, npcRank)
EquipShadow(shadowID)
UnequipShadow(shadowID)

-- UI
UpdateHUD(data)
ShowNotification(title, message, color)
DataLoaded(playerData)
DataUpdated(playerData)

-- Missões
MissionCompleted(mission)
MissionProgress(name, current, total)

-- Zonas
TeleportToZone(zoneName)
ZoneEntered(zoneData)
```

### RemoteFunctions
```lua
GetPlayerData() -> PlayerData
GetShadows() -> {Shadow}
GetEquippedShadows() -> {Shadow}
GetMissions() -> {Mission}
GetScoreboardData() -> {PlayerRank}
```

## 🎮 Fluxo de Jogo

### 1. Entrada do Jogador
```
Player Joins
    ↓
DataManager:LoadPlayerData()
    ↓
Send data to client
    ↓
HUD Created & Updated
    ↓
Spawn in BeginnerZone
    ↓
Assign Missions
```

### 2. Combate
```
Player clicks/presses Space
    ↓
CombatClient finds nearest NPC
    ↓
FireServer AttackNPC
    ↓
CombatSystem validates and applies damage
    ↓
Update health bar
    ↓
If dead: Create capture prompt
```

### 3. Captura de Sombra
```
NPC dies
    ↓
Prompt appears (30s)
    ↓
Player presses E
    ↓
ShadowSystem:AttemptCapture
    ↓
Roll for success (3 attempts)
    ↓
If success: Add to inventory
    ↓
If fail: Try again or destroy
    ↓
Update missions progress
```

### 4. Progressão
```
Complete mission
    ↓
Grant rewards (Cash, Diamonds, XP)
    ↓
Check if rank up
    ↓
Grant new rank
    ↓
Unlock new zones
    ↓
Assign new missions
```

## 🔧 Configuração e Balanceamento

### XP Necessário por Level
```lua
RequiredXP = 100 * (Level ^ 1.5)
```

### Multiplicadores de Rank
- F: 1.0x
- E: 1.2x
- D: 1.5x
- C: 2.0x
- B: 2.5x
- A: 3.0x
- S: 4.0x
- SS: 5.5x
- SSS: 7.5x
- GM: 10.0x

### Chances de Drop de Sombra
Configurável por NPC em `NPCData.lua`:
- Rank F-E: 5-8%
- Rank D-C: 12-15%
- Rank B-A: 18-22%
- Rank S-SS: 25-30%
- Rank SSS-GM: 35-40%

## 📊 Sistema de Estatísticas

Rastreado por jogador:
- NPCs Mortos
- Sombras Capturadas
- Sombras Destruídas
- Dano Total Causado
- Tempo Total de Jogo

## 🛡️ Segurança

### Validações Servidor-Side
- Todos os inputs do cliente são validados
- Distância de ataque verificada
- Cooldowns de ataque aplicados
- Verificação de rank para acesso a zonas
- DataStore com tratamento de erros

### Prevenção de Exploits
- Sem confiança em dados do cliente
- Validação de inventário no servidor
- Rate limiting em ações
- Verificação de existência de NPCs

## 🚀 Performance

### Otimizações Implementadas
- Auto-save a cada 5 minutos (não a cada ação)
- Respawn de NPCs em batch
- Update loops otimizados
- Uso de Debris service para limpeza
- Pooling implícito de objetos

### Limites Recomendados
- Máximo 50 NPCs simultâneos por servidor
- Máximo 3 sombras equipadas por jogador
- Inventário ilimitado (mas pode ser limitado)

## 📝 Extensibilidade

### Como Adicionar Novo NPC
1. Adicione entrada em `NPCData.lua`
2. Configure zona apropriada
3. Ajuste drops e estatísticas

### Como Adicionar Nova Zona
1. Adicione entrada em `ZoneManager.Zones`
2. Configure NPCs e rank mínimo
3. Crie portal da zona anterior

### Como Adicionar Nova Missão
1. Adicione entrada em `MissionSystem.Missions`
2. Configure tipo e requisitos
3. Defina recompensas

## 🐛 Debug

### Mensagens de Log
Todos os sistemas imprimem mensagens de inicialização:
```
[DataManager] Inicializado com sucesso!
[RankSystem] Inicializado com sucesso!
[CombatSystem] Inicializado com sucesso!
```

### Output Útil
- Erros de DataStore aparecem como warnings
- Ações de jogador são logadas
- Spawn de NPCs é rastreado

---

**Versão:** 1.0  
**Última Atualização:** 2025  
**Licença:** Livre para uso e modificação
