# 🔄 Fluxo do Sistema - Shadow Hunter Corrigido

## 📊 Diagrama de Fluxo de Combate

```
┌─────────────────────────────────────────────────────────────┐
│                    1. JOGADOR CLICA NO NPC                  │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  CombatClient.lua (Cliente)                                 │
│  • Encontra NPC mais próximo                                │
│  • Verifica distância                                       │
│  • Dispara: RemoteEvents.AttackNPC:FireServer(npc)         │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  CombatSystem.lua (Servidor)                                │
│  • Escuta evento AttackNPC                                  │
│  • PlayerAttackNPC(player, npc)                            │
│    - Verifica cooldown                                      │
│    - Verifica distância                                     │
│    - Calcula dano (base + level + rank + shadows)          │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  NPCManager.lua                                             │
│  • DamageNPC(npc, damage, attacker)                        │
│    - Aplica dano com defesa                                 │
│    - Atualiza barra de vida                                 │
│    - Mostra número de dano                                  │
│    - Armazena KILLER ⭐                                      │
│    - Se HP <= 0: humanoid.Health = 0                       │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  Humanoid.Died Event                                        │
│  • NPCManager:OnNPCDeath(npc, npcData)                     │
│  • ⭐ CHAMA CALLBACK:                                        │
│    NPCManager.OnNPCDeathCallback(npc, npcData)             │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  CombatSystem:HandleNPCDeath(npc, npcData)                 │
│  • Obtém killer de npcInfo.Killer ⭐                        │
│  • ProcessDrops(killer, npcData)                           │
│    - Adiciona Cash                                          │
│    - Adiciona Diamonds                                      │
│  • DataManager:AddXP(killer, xpReward)                     │
│  • DataManager:IncrementStatistic("NPCsKilled", 1)         │
│  • MissionSystem:UpdateProgress(...)                       │
│  • Mostra notificação                                       │
│  • Limpa dados do NPC                                       │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│  NPCManager:CreateCapturePrompt(npc, npcData)              │
│  • Cria Part com prompt                                     │
│  • Billboard com "[E] to Arise" e "[F] to Destroy"         │
│  • Armazena atributos (NPCName, NPCRank)                   │
│  • Remove após 30 segundos                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔄 Fluxo de Inicialização

```
┌─────────────────────────────────────────────────────────────┐
│                   MAINSERVER.LUA INICIA                     │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [1/9] Aguarda RemoteEvents  │
        │ WaitForChild("RemoteEvents")│
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [2/9] Carrega Módulos Core  │
        │ • DataManager               │
        │ • RankSystem                │
        │ • MissionSystem             │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [3/9] Carrega Combate       │
        │ • NPCManager                │
        │ • CombatSystem              │
        │ • ShadowSystem              │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [4/9] Carrega ZoneManager   │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [5/9] DataManager:Init()    │
        │ • Setup DataStore           │
        │ • PlayerAdded event         │
        │ • Auto-save                 │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [6/9] RankSystem:Init()     │
        │ • Recebe DataManager        │
        │ • Setup funções de rank     │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [7/9] Inicializa Combate    │
        │ • NPCManager:Init()         │
        │ • MissionSystem:Init()      │
        │ • CombatSystem:Init() ⭐    │
        │   - REGISTRA CALLBACK!      │
        │   - CONECTA AttackNPC!      │
        │ • ShadowSystem:Init()       │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [8/9] ZoneManager:Init()    │
        │ • Cria zonas                │
        │ • Cria portais              │
        │ • Spawna NPCs               │
        └─────────────┬───────────────┘
                      │
                      ▼
        ┌─────────────────────────────┐
        │ [9/9] Mensagem Boas-vindas  │
        │ • PlayerAdded event         │
        └─────────────┬───────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│              ✅ JOGO PRONTO PARA JOGAR!                     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔗 Conexões Entre Sistemas (Antes vs Depois)

### ❌ ANTES (NÃO FUNCIONAVA):

```
CombatSystem ────╳───► NPCManager
     │                     │
     │                     ╳ (NPC morre mas ninguém sabe)
     │                     │
     ╳                     ▼
DataManager          (Nada acontece)
```

### ✅ DEPOIS (FUNCIONA):

```
CombatSystem ────✓───► NPCManager
     │                     │
     │              ┌──────┴──────┐
     │              │ OnNPCDeath  │
     │              │   Callback  │
     │              └──────┬──────┘
     │                     │
     ▼                     ▼
DataManager ◄──────✓─── HandleNPCDeath
     │                     │
     ├─ AddXP             │
     ├─ AddCash           │
     └─ IncrementStat     │
                          │
                          ▼
                    MissionSystem
                    (UpdateProgress)
```

---

## 📦 Estrutura de Dados (DataManager)

```
PlayerData = {
    Level = 1
    XP = 0
    Rank = "F"
    Cash = 100
    Diamonds = 10
    
    Stats = {
        PlayerSpeed = 0
        PlayerDamage = 0
        ShadowSpeed = 0
        ...
    }
    
    ⭐ Statistics = {        // NOVO - CAMPO CRÍTICO!
        NPCsKilled = 0
        ShadowsCaptured = 0
        DamageDealt = 0      // ✅ AGORA EXISTE!
        ...
    }
    
    Shadows = [...]
    EquippedShadows = [...]
    CurrentMissions = [...]
    CompletedMissions = [...]
    ...
}
```

---

## 🎯 Callback System (Crítico!)

### Como Funciona:

```lua
-- 1. NPCManager declara callback
NPCManager.OnNPCDeathCallback = nil

-- 2. Quando NPC morre, chama callback
function NPCManager:OnNPCDeath(npc, npcData)
    if self.OnNPCDeathCallback then
        self.OnNPCDeathCallback(npc, npcData)  // ⭐ CHAMA
    end
end

-- 3. CombatSystem registra callback no Init()
function CombatSystem:Init(..., npcManager, ...)
    npcManager.OnNPCDeathCallback = function(npc, npcData)
        self:HandleNPCDeath(npc, npcData)  // ⭐ REGISTRA
    end
end

-- 4. HandleNPCDeath processa tudo
function CombatSystem:HandleNPCDeath(npc, npcData)
    local killer = npcInfo.Killer  // ⭐ OBTÉM KILLER
    
    // Dar recompensas
    DataManager:AddXP(killer, ...)
    DataManager:AddCash(killer, ...)
    MissionSystem:UpdateProgress(killer, ...)
end
```

---

## 🔍 Rastreamento de Killer

### Problema Antigo:
```
NPC morreu → ??? → Quem matou?
```

### Solução:
```lua
// 1. Ao dar dano, armazena killer
function NPCManager:DamageNPC(npc, damage, attacker)
    // ...
    if currentHealth <= 0 then
        self.ActiveNPCs[npc].Killer = attacker  // ⭐ ARMAZENA
        humanoid.Health = 0
    end
end

// 2. Ao morrer, recupera killer
function CombatSystem:HandleNPCDeath(npc, npcData)
    local killer = npcInfo.Killer  // ⭐ RECUPERA
    
    if killer then
        // Dar recompensas para o killer
    end
end
```

---

## 📊 Fluxo de Captura de Sombra

```
┌─────────────────────────────────────────┐
│  NPC Morre                              │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  NPCManager:CreateCapturePrompt()      │
│  • Cria Part "CapturePrompt"           │
│  • Atributos: NPCName, NPCRank         │
└─────────────┬───────────────────────────┘
              │
              ▼
┌─────────────────────────────────────────┐
│  ShadowClient.lua                       │
│  • Procura CapturePrompt próximo       │
│  • Escuta tecla E ou F                 │
└─────────────┬───────────────────────────┘
              │
        ┌─────┴─────┐
        │           │
     [E]          [F]
        │           │
        ▼           ▼
   ┌────────┐  ┌──────────┐
   │Capturar│  │ Destruir │
   └───┬────┘  └────┬─────┘
       │            │
       ▼            ▼
┌────────────┐ ┌───────────┐
│FireServer: │ │FireServer:│
│CaptureShadow│DestroyShadow
└─────┬──────┘ └─────┬─────┘
      │              │
      ▼              ▼
┌──────────────────────────────┐
│ ShadowSystem (Servidor)      │
│ • AttemptCapture (3 chances) │
│ • DestroyShadow (diamantes)  │
└──────────────────────────────┘
```

---

## ✅ Validações em Todas as Funções

```lua
// ANTES (❌ CRASHAVA):
data.Statistics.NPCsKilled = data.Statistics.NPCsKilled + 1
// ❌ ERRO se data.Statistics não existir!

// DEPOIS (✅ SEGURO):
function DataManager:IncrementStatistic(player, statName, amount)
    local data = self:GetPlayerData(player)
    
    // ⭐ VALIDAÇÃO 1
    if not data then return false end
    
    // ⭐ VALIDAÇÃO 2
    if not data.Statistics then return false end
    
    // ⭐ VALIDAÇÃO 3
    if data.Statistics[statName] ~= nil then
        data.Statistics[statName] = data.Statistics[statName] + amount
        return true
    end
    
    return false
end
```

---

## 📝 Logs em Cada Etapa

```
// Inicialização
[DataManager] 🚀 Inicializando...
[DataManager] ✅ Inicializado

// Combate
[CombatSystem] Player1 atacou Goblin Fraco com 20 de dano
[NPCManager] Player1 causou 18 de dano em Goblin Fraco (HP: 82)

// Morte
[NPCManager] 💀 Goblin Fraco morreu
[NPCManager] ⚡ Acionando callback de morte
[CombatSystem] 💀 Goblin Fraco foi morto por Player1

// Recompensas
[DataManager] Player1 ganhou 10 XP (Total: 10)
[CombatSystem] Player1 ganhou 25 Cash
[DataManager] Player1 ganhou 25 Cash

// Captura
[DataManager] Player1 capturou sombra: Goblin Fraco (Rank F)
```

---

**Este fluxo representa o sistema CORRIGIDO e FUNCIONAL!** ✅
