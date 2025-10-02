# 🎮 Shadow Hunter - Jogo Completo de Roblox

## 📋 Descrição
Shadow Hunter é um jogo inspirado em Solo Leveling onde você derrota NPCs, captura suas sombras e as usa em combate!

## ✨ Funcionalidades

### 🎯 Sistema de Combate
- NPCs com IA básica que ficam parados
- Barra de vida configurável
- Sistema de dano balanceado
- Drops personalizáveis por NPC

### 👥 Sistema de Sombras
- **10 Ranks:** F, E, D, C, B, A, S, SS, SSS, GM
- Captura de sombras ao derrotar NPCs
- Sistema de equipamento (equipe até 3 sombras)
- Sombras atacam inimigos dentro do range automaticamente
- Chance de drop baseada no rank do NPC

### 🎒 Inventários
- **Inventário de Sombras:** Armazena todas as sombras capturadas
- **Inventário de Armas:** Sistema de armas (expansível)

### 📊 Sistema de Progressão
- Sistema de Level e XP
- Sistema de Ranks (F até GM)
- Missões para subir de rank
- Moedas: Cash e Diamantes

### 🖼️ Interface UI (Estilo Anime)
- HUD principal com Level, XP, Cash, Diamantes
- Foto do personagem
- Scoreboard com rankings
- Inventários interativos
- Prompts de captura de sombra

### 🗺️ Mapas e Zonas
- **Zona Iniciante (Rank F-E):** Floresta Silenciosa
- **Zona Intermediária (Rank D-C):** Deserto Árido
- **Zona Avançada (Rank B-A):** Montanhas Congeladas
- **Zona Elite (Rank S-SS):** Vulcão Sombrio
- **Zona Lendária (Rank SSS-GM):** Abismo Eterno
- Sistema de portais entre zonas

## 📂 Estrutura do Projeto

```
ServerScriptService/
├── Core/
│   ├── DataManager.lua          # Gerenciamento de dados do jogador
│   ├── RankSystem.lua            # Sistema de ranks
│   └── MissionSystem.lua         # Sistema de missões
├── Combat/
│   ├── NPCManager.lua            # Gerenciamento de NPCs
│   ├── CombatSystem.lua          # Sistema de combate
│   └── ShadowSystem.lua          # Sistema de sombras
├── Economy/
│   └── DropSystem.lua            # Sistema de drops
└── Zones/
    └── ZoneManager.lua           # Gerenciamento de zonas

ReplicatedStorage/
├── Modules/
│   ├── RankData.lua              # Dados dos ranks
│   ├── NPCData.lua               # Dados dos NPCs
│   └── ShadowData.lua            # Dados das sombras
└── Events/
    └── RemoteEvents.lua          # Eventos remotos

StarterPlayer/StarterPlayerScripts/
├── UI/
│   ├── HUDController.lua         # Controlador do HUD
│   ├── InventoryController.lua   # Controlador de inventários
│   └── ScoreboardController.lua  # Controlador do scoreboard
└── Client/
    ├── CombatClient.lua          # Cliente de combate
    └── ShadowClient.lua          # Cliente de sombras

StarterGui/
├── MainHUD/                      # HUD principal
├── InventoryUI/                  # UI de inventários
└── ScoreboardUI/                 # UI do scoreboard

Workspace/
├── Zones/
│   ├── BeginnerZone/
│   ├── IntermediateZone/
│   ├── AdvancedZone/
│   ├── EliteZone/
│   └── LegendaryZone/
└── NPCs/                         # Modelos de NPCs
```

## 🎮 Como Jogar

1. **Início:** Você começa no Rank F na Zona Iniciante
2. **Combate:** Ataque NPCs para derrotá-los
3. **Captura:**
   - Pressione **E** para tentar capturar a sombra (3 tentativas)
   - Pressione **F** para destruir e ganhar diamantes
4. **Equipamento:** Abra o inventário e equipe suas sombras
5. **Progressão:** Complete missões para subir de rank
6. **Exploração:** Use portais para acessar novas zonas

## 🔧 Configuração

### NPCs Configuráveis
Edite `NPCData.lua` para adicionar/modificar NPCs:
```lua
{
    Name = "Goku",
    Rank = "S",
    Health = 5000,
    Damage = 50,
    Drops = {...},
    ShadowDropChance = 0.25
}
```

### Balanceamento
- Ranks mais altos = maior chance de drop da mesma raridade
- Sistema de XP progressivo
- Dano e vida escalam com o rank

## 🚀 Instalação

Use o comando de setup automático (ver SETUP_COMMAND.txt) ou instale manualmente seguindo a estrutura acima.

## 📝 Créditos
Sistema inspirado em Solo Leveling / Sung Jin-Woo
Desenvolvido para Roblox Studio

## 📄 Licença
Livre para uso e modificação
