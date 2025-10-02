# ⚡ Arise Crossover - Quick Start (Início Rápido)

## 🚀 Instalação em 10 Minutos

### 1️⃣ Preparação (2 min)
```
1. Abra Roblox Studio
2. Crie novo lugar (Baseplate)
3. Ative API Services em Game Settings > Security
```

### 2️⃣ Estrutura de Pastas (1 min)
```
ReplicatedStorage/
  ├── Modules/ (Folder)
  └── Events/ (Folder)

ServerScriptService/
  ├── Core/ (Folder)
  └── Systems/ (Folder)

StarterGui/
  └── GameUI (ScreenGui)
```

### 3️⃣ Copiar Scripts (5 min)

#### ReplicatedStorage/Modules/
Cole como **ModuleScript**:
- ✅ GameConfig
- ✅ ShadowData
- ✅ WeaponData
- ✅ RelicData
- ✅ UtilityFunctions

#### ReplicatedStorage/Events/
Crie estes **RemoteEvent**:
- CombatEvent
- ShadowEvent
- InventoryEvent
- ShopEvent
- DungeonEvent
- RankingEvent

Crie este **RemoteFunction**:
- DataRequest

#### ServerScriptService/Core/
Cole como **Script**:
- DataManager
- ServerMain

#### ServerScriptService/Systems/
Cole como **Script**:
- CombatSystem
- ShadowSystem
- DropSystem
- XPSystem
- DungeonSystem
- RankingSystem
- NPCManager

#### StarterPlayer/StarterPlayerScripts/
Cole **ClientMain** como **LocalScript**

Cole como **ModuleScript**:
- CombatController
- ShadowController
- UIController

### 4️⃣ Interface Mínima (2 min)

Em **StarterGui/GameUI**, crie estes **Frame**:

```lua
HUD (Visible = true)
  └── Adicione 2 TextLabels: "LevelLabel", "CashLabel"

ShadowInventory (Visible = false)
  └── Adicione 1 ScrollingFrame

Backpack (Visible = false)
  └── Adicione 1 ScrollingFrame

Forge (Visible = false)
  └── Adicione 1 ScrollingFrame

Ranking (Visible = false)
  └── Adicione 1 ScrollingFrame

DungeonUI (Visible = false)
  └── Adicione 1 Frame
```

### 5️⃣ Testar! ✅
```
Pressione F5
Procure no Output:
  ✅ DataManager inicializado
  ✅ Todos os sistemas carregados
  ✅ Cliente inicializado

Controles:
  🖱️ Clique: Atacar
  ⌨️ B: Inventário
  ⌨️ C: Sombras
  ⌨️ F: Forja
  ⌨️ L: Ranking
```

---

## 📦 Lista de Arquivos Para Copiar

### Módulos (5 arquivos)
1. `ReplicatedStorage_Modules_GameConfig.lua`
2. `ReplicatedStorage_Modules_ShadowData.lua`
3. `ReplicatedStorage_Modules_WeaponData.lua`
4. `ReplicatedStorage_Modules_RelicData.lua`
5. `ReplicatedStorage_Modules_UtilityFunctions.lua`

### Servidor (9 arquivos)
6. `ServerScriptService_Core_DataManager.lua`
7. `ServerScriptService_Core_ServerMain.lua`
8. `ServerScriptService_Systems_CombatSystem.lua`
9. `ServerScriptService_Systems_ShadowSystem.lua`
10. `ServerScriptService_Systems_DropSystem.lua`
11. `ServerScriptService_Systems_XPSystem.lua`
12. `ServerScriptService_Systems_DungeonSystem.lua`
13. `ServerScriptService_Systems_RankingSystem.lua`
14. `ServerScriptService_Systems_NPCManager.lua`

### Cliente (4 arquivos)
15. `StarterPlayer_StarterPlayerScripts_ClientMain.lua`
16. `StarterPlayer_StarterPlayerScripts_CombatController.lua`
17. `StarterPlayer_StarterPlayerScripts_ShadowController.lua`
18. `StarterPlayer_StarterPlayerScripts_UIController.lua`

---

## 🎯 Ordem de Instalação Recomendada

```
1. Criar pastas
2. Criar RemoteEvents
3. Instalar Módulos
4. Instalar Servidor (Core primeiro, depois Systems)
5. Instalar Cliente
6. Criar Interface básica
7. Testar
```

---

## ⚠️ Checklist Rápido

Antes de testar, confirme:

- [ ] 5 Módulos em ReplicatedStorage/Modules
- [ ] 7 RemoteEvents + 1 RemoteFunction em ReplicatedStorage/Events
- [ ] 2 Scripts em ServerScriptService/Core
- [ ] 7 Scripts em ServerScriptService/Systems
- [ ] 1 LocalScript + 3 ModuleScripts em StarterPlayerScripts
- [ ] 6 Frames em StarterGui/GameUI
- [ ] API Services ativado

---

## 🐛 Erros Comuns

| Erro | Solução |
|------|---------|
| "WaitForChild timed out" | Verifique nome dos objetos |
| "Attempt to index nil" | Falta criar RemoteEvent |
| "DataStore error" | Ative API Services |
| NPCs não spawnam | Normal, aguarde 5 segundos |

---

## 📞 Próximos Passos

1. ✅ Jogo funcionando básico
2. 🎨 Melhorar interface (UICorner, cores, etc)
3. 🎭 Adicionar modelos 3D reais
4. 🎵 Adicionar sons e músicas
5. 🗺️ Criar mapas e áreas
6. 💎 Adicionar Game Passes

---

**Tempo total: ~10-15 minutos**

Para guia detalhado, veja: `INSTALLATION_GUIDE.md`
