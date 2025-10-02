# 🏗️ Arise Crossover - Arquitetura do Sistema

## 📐 Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                    ARISE CROSSOVER                               │
│                   Jogo de RPG de Ação                           │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTE                                  │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  StarterPlayer/StarterPlayerScripts/                      │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐      │ │
│  │  │ ClientMain  │  │  Combat     │  │  Shadow     │      │ │
│  │  │ (LocalScript)  │  Controller │  │  Controller │      │ │
│  │  └──────┬──────┘  └──────┬──────┘  └──────┬──────┘      │ │
│  │         │                 │                 │              │ │
│  │         └─────────────────┴─────────────────┘              │ │
│  │                         │                                   │ │
│  │                    ┌────▼────┐                             │ │
│  │                    │   UI    │                             │ │
│  │                    │Controller                             │ │
│  │                    └─────────┘                             │ │
│  └───────────────────────────────────────────────────────────┘ │
│                              │                                   │
│                              │ RemoteEvents                      │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                              │                                   │
│  ┌───────────────────────────▼───────────────────────────────┐ │
│  │          ReplicatedStorage                                 │ │
│  │  ┌────────────────────┐      ┌────────────────────┐      │ │
│  │  │      Modules       │      │      Events        │      │ │
│  │  │  ┌──────────────┐ │      │  ┌──────────────┐  │      │ │
│  │  │  │ GameConfig   │ │      │  │ CombatEvent  │  │      │ │
│  │  │  │ ShadowData   │ │◄─────┼──┤ ShadowEvent  │  │      │ │
│  │  │  │ WeaponData   │ │      │  │ InventoryEv. │  │      │ │
│  │  │  │ RelicData    │ │      │  │ DungeonEvent │  │      │ │
│  │  │  │ UtilityFunc  │ │      │  │ RankingEvent │  │      │ │
│  │  │  └──────────────┘ │      │  └──────────────┘  │      │ │
│  │  └────────────────────┘      └────────────────────┘      │ │
│  └───────────────────────────────────────────────────────────┘ │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                         SERVIDOR                                 │
│  ┌───────────────────────────▼───────────────────────────────┐ │
│  │  ServerScriptService/Core/                                 │ │
│  │  ┌──────────────────┐      ┌──────────────────┐          │ │
│  │  │  DataManager     │◄─────┤  ServerMain      │          │ │
│  │  │  (DataStore +    │      │  (Inicializador) │          │ │
│  │  │   Auto-save)     │      └──────────────────┘          │ │
│  │  └────────┬─────────┘                                     │ │
│  └───────────┼───────────────────────────────────────────────┘ │
│              │                                                   │
│  ┌───────────▼───────────────────────────────────────────────┐ │
│  │  ServerScriptService/Systems/                              │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │ │
│  │  │   Combat     │  │    Shadow    │  │     Drop     │   │ │
│  │  │   System     │  │    System    │  │    System    │   │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘   │ │
│  │         │                  │                  │            │ │
│  │  ┌──────▼───────┐  ┌──────▼───────┐  ┌──────▼───────┐   │ │
│  │  │      XP      │  │   Dungeon    │  │   Ranking    │   │ │
│  │  │    System    │  │    System    │  │    System    │   │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │ │
│  │                          │                                 │ │
│  │                    ┌─────▼─────┐                          │ │
│  │                    │    NPC    │                          │ │
│  │                    │  Manager  │                          │ │
│  │                    └───────────┘                          │ │
│  └───────────────────────────────────────────────────────────┘ │
│                              │                                   │
│                              ▼                                   │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │              Roblox DataStore Service                      │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐   │ │
│  │  │  Player_123  │  │  Player_456  │  │  Rankings    │   │ │
│  │  │    (Data)    │  │    (Data)    │  │   (Global)   │   │ │
│  │  └──────────────┘  └──────────────┘  └──────────────┘   │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                         WORKSPACE                                │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  NPCs (Spawned)          Players           Drops           │ │
│  │  ┌────┐ ┌────┐ ┌────┐   ┌────┐ ┌────┐    ┌────┐ ┌────┐  │ │
│  │  │NPC │ │NPC │ │NPC │   │ P1 │ │ P2 │    │Drop│ │Drop│  │ │
│  │  │ F  │ │ E  │ │ D  │   └────┘ └────┘    └────┘ └────┘  │ │
│  │  └────┘ └────┘ └────┘                                     │ │
│  │                                                             │ │
│  │  Sombras Invocadas                                         │ │
│  │  ┌────────┐ ┌────────┐                                    │ │
│  │  │Shadow 1│ │Shadow 2│                                    │ │
│  │  │(Player)│ │(Player)│                                    │ │
│  │  └────────┘ └────────┘                                    │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      STARTERGUI                                  │
│  ┌───────────────────────────────────────────────────────────┐ │
│  │  GameUI (ScreenGui)                                        │ │
│  │  ┌─────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐     │ │
│  │  │   HUD   │ │  Shadow  │ │ Backpack │ │  Forge   │     │ │
│  │  │(Visible)│ │Inventory │ │          │ │          │     │ │
│  │  └─────────┘ └──────────┘ └──────────┘ └──────────┘     │ │
│  │  ┌──────────┐ ┌──────────┐                               │ │
│  │  │ Ranking  │ │ DungeonUI│                               │ │
│  │  └──────────┘ └──────────┘                               │ │
│  └───────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Fluxo de Dados

### 1. Combate
```
Cliente                RemoteEvent           Servidor
  │                        │                    │
  │   Clique do Mouse      │                    │
  ├────────────────────────►                    │
  │    (targetPos)         │                    │
  │                        │    ProcessAttack   │
  │                        ├────────────────────►
  │                        │                    │
  │                        │  Validate & Damage │
  │                        │   Apply to NPC     │
  │                        │                    │
  │  AttackSuccess Event   │◄───────────────────┤
  │◄───────────────────────┤                    │
  │  (damage, isCrit)      │                    │
  │                        │                    │
  └─► Mostrar Efeito Visual                    │
```

### 2. Captura de Sombra
```
Servidor                                      DataStore
  │                                              │
  │  NPC Morre (CombatSystem)                   │
  ├──────────►                                   │
  │  TryCaptureShadow (ShadowSystem)            │
  ├──────────►                                   │
  │  Verificar chance                            │
  ├──────────►                                   │
  │  Se sucesso: CreateShadowInstance            │
  ├──────────►                                   │
  │  AddShadow (DataManager)                     │
  ├──────────────────────────────────────────────►
  │                                       Salvar │
  │  Notificar Cliente                           │
  ├──────────►                                   │
  │  ShadowCaptured Event                        │
  └──────────►                                   │
              │                                  │
           Cliente                               │
              │  Mostrar Notificação             │
              │  Efeito Visual                   │
              └──────────►                       │
```

### 3. Salvamento de Dados
```
DataManager          DataStore Service
     │                      │
     │  Auto-save Timer     │
     │  (a cada 5 min)      │
     ├──────────────────────►
     │  GetPlayerData       │
     │  SerializeData       │
     ├──────────────────────►
     │  SetAsync()          │
     ├──────────────────────►
     │                   ✅ │
     │◄─────────────────────┤
     │  Success             │
     │                      │
```

---

## 🎮 Arquitetura de Sistemas

### Sistema de Sombras
```
ShadowSystem
    │
    ├── TryCaptureShadow()
    │   ├── Verificar chance
    │   ├── Criar instância
    │   └── Adicionar ao inventário
    │
    ├── InvokeShadow()
    │   ├── Criar modelo no workspace
    │   ├── Iniciar IA de combate
    │   └── Seguir jogador
    │
    └── EvolveShadow()
        ├── Verificar recursos
        ├── Deduzir custo
        ├── Aumentar stats
        └── Salvar dados
```

### Sistema de Combate
```
CombatSystem
    │
    ├── ProcessAttack()
    │   ├── Verificar cooldown
    │   ├── Obter arma equipada
    │   ├── Encontrar inimigos
    │   ├── Calcular dano
    │   └── Aplicar dano
    │
    ├── OnEnemyKilled()
    │   ├── Processar drops (DropSystem)
    │   ├── Dar XP (XPSystem)
    │   └── Tentar captura (ShadowSystem)
    │
    ├── EquipWeapon()
    │   └── Atualizar dados
    │
    └── UpgradeWeapon()
        ├── Verificar recursos
        ├── Deduzir custo
        └── Aumentar stats
```

### Sistema de Drops
```
DropSystem
    │
    ├── ProcessDrops()
    │   ├── Cash (sempre)
    │   ├── Fragmentos (40%)
    │   ├── Poções (15%)
    │   ├── Sombras (25%)
    │   ├── Armas (10%)
    │   └── Relíquias (5%)
    │
    ├── CreateVisualDrops()
    │   ├── Criar part no workspace
    │   ├── Aplicar cor por tipo
    │   ├── Adicionar partículas
    │   └── Animar e destruir
    │
    └── ProcessRaidRewards()
        ├── Cash massivo
        ├── Diamantes
        ├── Fragmentos
        └── Sombra garantida
```

---

## 📊 Estrutura de Dados

### PlayerData (DataStore)
```lua
PlayerData = {
    -- Progressão
    Level = 1,
    XP = 0,
    
    -- Economia
    Cash = 1000,
    Diamonds = 50,
    Fragments = 0,
    
    -- Sombras
    Shadows = {
        {
            ID = "SHADOW_001",
            Name = "Goblin Sombrio",
            Rank = "F",
            EvolutionLevel = 0,
            Stats = {...},
            Abilities = {...}
        },
        -- ...mais sombras
    },
    ActiveShadow = "SHADOW_001",
    
    -- Inventário
    Inventory = {
        Weapons = { {...}, {...} },
        Relics = { {...}, {...} },
        Consumables = { {...}, {...} }
    },
    
    -- Relíquias Equipadas
    EquippedRelics = { {...}, {...}, {...} },
    
    -- Estatísticas
    Stats = {
        TotalKills = 0,
        BossKills = 0,
        ShadowsCaptured = 0,
        DungeonsCompleted = 0,
        RaidsCompleted = 0
    },
    
    -- Cooldowns
    DungeonCooldowns = {},
    RaidCooldowns = {},
    
    -- Timestamps
    LastSave = os.time(),
    CreatedAt = os.time()
}
```

---

## 🔄 Ciclo de Vida do Jogo

```
┌─────────────────┐
│ Jogador Entra   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Carregar Dados  │◄────────┐
└────────┬────────┘         │
         │              DataStore
         ▼
┌─────────────────┐
│  Spawn Player   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Iniciar Cliente │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│   Gameplay      │◄──────┐
│  (Loop Infinito)│       │
└────────┬────────┘       │
         │                 │
    ┌────┴────┐           │
    │         │            │
    ▼         ▼            │
┌─────┐   ┌─────┐        │
│Combat   │ UI  │        │
│       │ │     │        │
└─────┘   └─────┘        │
    │         │           │
    └────┬────┘           │
         │                 │
         └─────────────────┘
         │
         ▼
┌─────────────────┐
│ Jogador Sai     │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Salvar Dados   │─────────►
└─────────────────┘      DataStore
```

---

## 🔐 Camadas de Segurança

```
┌─────────────────────────────────────────┐
│              CLIENTE                     │
│  ┌───────────────────────────────────┐ │
│  │  Input Handling                   │ │
│  │  • Cliques                        │ │
│  │  • Teclas                         │ │
│  │  • UI                             │ │
│  └──────────────┬────────────────────┘ │
└─────────────────┼──────────────────────┘
                  │
                  │ RemoteEvents
                  │ (Apenas Requests)
                  ▼
┌─────────────────────────────────────────┐
│           VALIDAÇÃO SERVIDOR             │
│  ┌───────────────────────────────────┐ │
│  │  ✅ Verificar Cooldown            │ │
│  │  ✅ Verificar Recursos            │ │
│  │  ✅ Verificar Permissões          │ │
│  │  ✅ Validar Parâmetros            │ │
│  │  ✅ Anti-exploit                  │ │
│  └──────────────┬────────────────────┘ │
└─────────────────┼──────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│          LÓGICA DE NEGÓCIO               │
│  ┌───────────────────────────────────┐ │
│  │  • Processar ação                 │ │
│  │  • Calcular resultados            │ │
│  │  • Atualizar dados                │ │
│  │  • Salvar no DataStore            │ │
│  └──────────────┬────────────────────┘ │
└─────────────────┼──────────────────────┘
                  │
                  │ RemoteEvents
                  │ (Confirmação/Resultado)
                  ▼
┌─────────────────────────────────────────┐
│              CLIENTE                     │
│  ┌───────────────────────────────────┐ │
│  │  Atualizar UI                     │ │
│  │  Mostrar Feedback                 │ │
│  │  Efeitos Visuais                  │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

---

## ⚡ Performance e Otimização

### Cache e DataStore
```
┌──────────────┐
│   Cliente    │
└──────┬───────┘
       │
       │ Request Data
       ▼
┌──────────────┐
│   Servidor   │◄────────┐
└──────┬───────┘         │
       │            Cache Local
       │           (RAM rápido)
       ▼                 │
┌──────────────┐        │
│     Cache    │────────┘
│   (Memória)  │
└──────┬───────┘
       │
       │ Se não existe no cache
       ▼
┌──────────────┐
│  DataStore   │
│   (Disco)    │
└──────────────┘
```

### Spawn de NPCs
```
NPCManager
    │
    ├── Spawn Inicial (ao iniciar)
    │   ├── 10x Rank F
    │   ├── 8x Rank E
    │   ├── 5x Rank D
    │   ├── 3x Rank C
    │   └── 2x Rank B
    │
    ├── Spawn Periódico (a cada 5 min)
    │   ├── 30% chance → 1x Rank A
    │   └── 10% chance → 1x Rank S
    │
    └── Respawn ao Morrer (após 30s)
        └── Mesmo rank
```

---

## 🎯 Pontos de Extensão

### Adicionar Nova Sombra
```
1. ShadowData.lua
   └── Adicionar ao array Templates

2. GameConfig.lua
   └── (Opcional) Ajustar chances

3. (Opcional) Criar modelo 3D
   └── Adicionar ModelID
```

### Adicionar Nova Arma
```
1. WeaponData.lua
   └── Adicionar ao array Templates

2. GameConfig.lua
   └── (Opcional) Ajustar drops

3. (Opcional) Criar modelo 3D
   └── Adicionar ModelID
```

### Adicionar Novo Sistema
```
1. Criar Script em Systems/
   └── NomeDoSistema.lua

2. Adicionar RemoteEvent
   └── ReplicatedStorage/Events/

3. Atualizar ServerMain.lua
   └── require(novo sistema)

4. Criar Controller no Cliente
   └── (se necessário)
```

---

## 📈 Escalabilidade

### Horizontal (Mais Conteúdo)
```
✅ Fácil adicionar:
   • Novas sombras
   • Novas armas
   • Novas relíquias
   • Novos dungeons
   • Novos ranks

📝 Basta editar os arquivos de dados
```

### Vertical (Mais Recursos)
```
✅ Preparado para:
   • Mais jogadores (até 50)
   • Mais NPCs simultâneos
   • Mais dados por jogador
   • Mais sistemas complexos

⚙️ Usa caching e otimizações
```

---

**Arquitetura:** Modular e Escalável  
**Padrão:** Client-Server com Validação  
**Performance:** Otimizada para Multiplayer  
**Segurança:** Validação Server-Side Completa
