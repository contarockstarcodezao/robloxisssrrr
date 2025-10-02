# 📋 Lista Completa de Arquivos - Shadow Hunter

## 📂 Estrutura Completa do Projeto

### 📚 Documentação (5 arquivos)
```
/
├── README.md                          # Visão geral do projeto
├── QUICK_START.md                     # Guia rápido de 10 minutos
├── INSTALLATION_GUIDE.md              # Guia detalhado de instalação
├── TECHNICAL_DOCUMENTATION.md         # Documentação técnica completa
├── CONFIGURATION_GUIDE.md             # Guia de configuração e balanceamento
├── FILE_LIST.md                       # Este arquivo
└── SETUP_COMMAND.lua                  # Script de setup automático
```

### 🔄 ReplicatedStorage (4 arquivos)

#### Modules (3 ModuleScripts)
```
ReplicatedStorage/Modules/
├── RankData.lua          # Sistema de ranks (F até GM)
├── NPCData.lua           # Dados de 22 NPCs configuráveis
└── ShadowData.lua        # Sistema de sombras e balanceamento
```

#### Events (1 ModuleScript)
```
ReplicatedStorage/Events/
└── RemoteEvents.lua      # Todos os eventos remotos do jogo
```

### 🖥️ ServerScriptService (8 arquivos)

#### Core (3 Scripts)
```
ServerScriptService/Core/
├── DataManager.lua       # Gerenciamento de dados e DataStore
├── RankSystem.lua        # Sistema de progressão de ranks
└── MissionSystem.lua     # Sistema de missões (15+ missões)
```

#### Combat (3 Scripts)
```
ServerScriptService/Combat/
├── NPCManager.lua        # Spawn e gerenciamento de NPCs
├── CombatSystem.lua      # Sistema de combate principal
└── ShadowSystem.lua      # Captura e equipamento de sombras
```

#### Zones (1 Script)
```
ServerScriptService/Zones/
└── ZoneManager.lua       # 5 zonas com portais
```

#### Script Principal (1 Script)
```
ServerScriptService/
└── MainServer.lua        # Inicialização de todos os sistemas
```

### 💻 StarterPlayer (3 arquivos)

#### Client (2 LocalScripts)
```
StarterPlayer/StarterPlayerScripts/Client/
├── CombatClient.lua      # Input e feedback de combate
└── ShadowClient.lua      # Input para captura de sombras
```

#### UI (1 LocalScript)
```
StarterPlayer/StarterPlayerScripts/UI/
└── HUDController.lua     # Interface do usuário completa
```

## 📊 Estatísticas do Projeto

### Linhas de Código
- **Total**: ~3,500 linhas
- **Servidor**: ~2,300 linhas
- **Cliente**: ~600 linhas
- **Módulos**: ~600 linhas

### Arquivos por Categoria
- **Scripts de Servidor**: 8 arquivos
- **Scripts de Cliente**: 3 arquivos
- **Módulos de Dados**: 4 arquivos
- **Documentação**: 6 arquivos
- **Total**: 21 arquivos

### Funcionalidades Implementadas
- ✅ Sistema de Ranks (10 ranks)
- ✅ NPCs (22 NPCs únicos)
- ✅ Sistema de Sombras
- ✅ Sistema de Combate
- ✅ Sistema de Missões (15+ missões)
- ✅ 5 Zonas jogáveis
- ✅ Sistema de Portais
- ✅ HUD Completo
- ✅ Sistema de Inventário
- ✅ Economia (Cash e Diamantes)
- ✅ DataStore (Save/Load)
- ✅ Sistema de Progressão
- ✅ Auto-ataque com Sombras
- ✅ Notificações
- ✅ Respawn de NPCs
- ✅ Sistema de Drops

## 🎮 Conteúdo do Jogo

### Ranks (10 níveis)
1. F (Iniciante)
2. E
3. D
4. C
5. B
6. A
7. S
8. SS
9. SSS
10. GM (Grand Master)

### NPCs (22 únicos)
**Rank F (2)**:
- Goblin Fraco
- Slime

**Rank E (2)**:
- Goblin Guerreiro
- Lobo Selvagem

**Rank D (2)**:
- Escorpião do Deserto
- Bandido do Deserto

**Rank C (2)**:
- Guerreiro Orc
- Mago das Sombras

**Rank B (2)**:
- Yeti Congelado
- Cavaleiro Gélido

**Rank A (2)**:
- Dragão Menor
- Golem Anciã

**Rank S (2)**:
- Demônio de Fogo
- Goku ⭐

**Rank SS (2)**:
- Titã Sombrio
- Vegeta ⭐

**Rank SSS (2)**:
- Rei Demônio
- Jiren ⭐

**Rank GM (2)**:
- Lúcifer
- Sung Jin-Woo ⭐

### Zonas (5 áreas)
1. **Floresta Silenciosa** (F+)
2. **Deserto Árido** (D+)
3. **Montanhas Congeladas** (B+)
4. **Vulcão Sombrio** (S+)
5. **Abismo Eterno** (SSS+)

### Missões (15+)
- Progressão de F → E (2 missões)
- Progressão de E → D (2 missões)
- Progressão de D → C (2 missões)
- Progressão de C → B (1 missão)
- Progressão de B → A (1 missão)
- Progressão de A → S (1 missão)
- Progressão de S → SS (1 missão)
- Progressão de SS → SSS (1 missão)
- Progressão de SSS → GM (2 missões)

## 🔧 Tipo de Arquivo por Local

### ModuleScript
- Todos os arquivos em `ReplicatedStorage/`

### Script (Servidor)
- Todos os arquivos em `ServerScriptService/`

### LocalScript (Cliente)
- Todos os arquivos em `StarterPlayer/StarterPlayerScripts/`

## 📦 Instalação por Prioridade

### Alta Prioridade (Obrigatório)
1. ✅ ReplicatedStorage/Events/RemoteEvents.lua
2. ✅ ReplicatedStorage/Modules/RankData.lua
3. ✅ ReplicatedStorage/Modules/NPCData.lua
4. ✅ ReplicatedStorage/Modules/ShadowData.lua
5. ✅ ServerScriptService/Core/DataManager.lua
6. ✅ ServerScriptService/MainServer.lua

### Média Prioridade (Funcionalidades Core)
7. ✅ ServerScriptService/Core/RankSystem.lua
8. ✅ ServerScriptService/Core/MissionSystem.lua
9. ✅ ServerScriptService/Combat/NPCManager.lua
10. ✅ ServerScriptService/Combat/CombatSystem.lua
11. ✅ ServerScriptService/Combat/ShadowSystem.lua

### Baixa Prioridade (Melhorias)
12. ✅ ServerScriptService/Zones/ZoneManager.lua
13. ✅ StarterPlayer/.../Client/CombatClient.lua
14. ✅ StarterPlayer/.../Client/ShadowClient.lua
15. ✅ StarterPlayer/.../UI/HUDController.lua

## 🎯 Checklist de Instalação

### Antes de Começar
- [ ] Roblox Studio instalado
- [ ] Conta Roblox criada
- [ ] Novo Place criado

### Durante Instalação
- [ ] Estrutura de pastas criada
- [ ] Todos os ModuleScripts adicionados
- [ ] Todos os Scripts adicionados
- [ ] Todos os LocalScripts adicionados
- [ ] Tipos de arquivo corretos

### Configurações
- [ ] API Services habilitado
- [ ] HTTP Requests habilitado (opcional)
- [ ] SpawnLocation padrão removido

### Teste Final
- [ ] Jogo inicia sem erros
- [ ] Mensagens de inicialização no Output
- [ ] HUD aparece
- [ ] NPCs aparecem
- [ ] Combate funciona
- [ ] Captura de sombras funciona
- [ ] Zonas e portais funcionam

## 📝 Notas Importantes

### Arquivos Críticos
Sem estes arquivos o jogo não funcionará:
1. `RemoteEvents.lua`
2. `DataManager.lua`
3. `MainServer.lua`
4. `RankData.lua`
5. `NPCData.lua`

### Ordem de Inicialização
O `MainServer.lua` inicializa os sistemas nesta ordem:
1. RemoteEvents
2. DataManager
3. RankSystem
4. NPCManager
5. MissionSystem
6. CombatSystem
7. ShadowSystem
8. ZoneManager

### Dependências
- `RankSystem` depende de `DataManager`
- `MissionSystem` depende de `DataManager` e `RankSystem`
- `CombatSystem` depende de todos os sistemas Core
- `ShadowSystem` depende de `DataManager` e `MissionSystem`
- `ZoneManager` depende de `NPCManager` e `RankSystem`

## 🚀 Comandos Úteis

### Criar Estrutura (Command Bar)
```lua
-- Execute SETUP_COMMAND.lua no Command Bar
```

### Resetar Dados de Jogador
```lua
local DataStore = game:GetService("DataStoreService"):GetDataStore("PlayerData_V1")
local player = game.Players:FindFirstChild("NomeDoJogador")
DataStore:RemoveAsync(player.UserId)
```

### Testar Rank
```lua
local RankSystem = require(game.ServerScriptService.Core.RankSystem)
local player = game.Players:FindFirstChild("NomeDoJogador")
RankSystem:GrantRank(player, "S")
```

## 📖 Referência Rápida

### Ver também:
- `QUICK_START.md` - Instalação em 10 minutos
- `INSTALLATION_GUIDE.md` - Guia passo a passo
- `TECHNICAL_DOCUMENTATION.md` - Arquitetura e APIs
- `CONFIGURATION_GUIDE.md` - Como modificar o jogo
- `README.md` - Visão geral

---

**Total de Arquivos**: 21  
**Linhas de Código**: ~3,500  
**Tempo de Instalação**: 10-30 minutos  
**Nível de Complexidade**: Intermediário

Projeto completo e funcional! 🎮✨
