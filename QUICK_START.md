# 🚀 Quick Start - Shadow Hunter

## 📦 Instalação Rápida (10 minutos)

### 1. Criar Estrutura (2 min)

Abra Roblox Studio e crie estas pastas:

```
📁 ReplicatedStorage
  └─ 📁 Modules
  └─ 📁 Events

📁 ServerScriptService
  └─ 📁 Core
  └─ 📁 Combat
  └─ 📁 Zones

📁 StarterPlayer
  └─ 📁 StarterPlayerScripts
      └─ 📁 Client
      └─ 📁 UI

📁 Workspace
  └─ 📁 Zones
  └─ 📁 NPCs
```

### 2. Adicionar Módulos (3 min)

**ReplicatedStorage/Modules** (ModuleScript):
- `RankData.lua`
- `NPCData.lua`
- `ShadowData.lua`

**ReplicatedStorage/Events** (ModuleScript):
- `RemoteEvents.lua`

### 3. Adicionar Scripts do Servidor (3 min)

**ServerScriptService/Core** (Script):
- `DataManager.lua`
- `RankSystem.lua`
- `MissionSystem.lua`

**ServerScriptService/Combat** (Script):
- `NPCManager.lua`
- `CombatSystem.lua`
- `ShadowSystem.lua`

**ServerScriptService/Zones** (Script):
- `ZoneManager.lua`

**ServerScriptService** (Script):
- `MainServer.lua` ⭐ (Principal)

### 4. Adicionar Scripts do Cliente (2 min)

**StarterPlayer/StarterPlayerScripts/Client** (LocalScript):
- `CombatClient.lua`
- `ShadowClient.lua`

**StarterPlayer/StarterPlayerScripts/UI** (LocalScript):
- `HUDController.lua`

### 5. Configurar (1 min)

1. Game Settings → Security → ✅ Enable Studio Access to API Services
2. Delete o SpawnLocation padrão do Workspace

### 6. Testar! 🎮

Pressione **F5** e jogue!

## 🎮 Controles

| Ação | Tecla |
|------|-------|
| Atacar NPC | Clique ou Espaço |
| Capturar Sombra | E |
| Destruir Sombra | F |
| Abrir Inventário | Botão na tela |

## ✅ Checklist Rápido

- [ ] Todas as pastas criadas
- [ ] Todos os scripts adicionados
- [ ] Tipos corretos (Script/LocalScript/ModuleScript)
- [ ] API Services habilitado
- [ ] SpawnLocation removido
- [ ] Testado sem erros

## 🐛 Problemas Comuns

**Erro: "RemoteEvents not found"**
→ Verifique se `RemoteEvents.lua` é ModuleScript em `ReplicatedStorage/Events`

**NPCs não aparecem**
→ Verifique Output, deve ter mensagens `[Sistema] Inicializado`

**HUD não aparece**
→ `HUDController.lua` deve ser LocalScript em `UI`

## 📚 Próximos Passos

1. Leia `README.md` para entender o jogo
2. Veja `CONFIGURATION_GUIDE.md` para personalizar
3. Consulte `TECHNICAL_DOCUMENTATION.md` para detalhes

## 🎯 Primeiro Objetivos no Jogo

1. Derrote 3 Goblins Fracos
2. Capture sua primeira sombra
3. Equipe a sombra no inventário
4. Complete a missão "Primeiro Sangue"
5. Suba para Rank E
6. Explore a próxima zona!

---

**Tempo Total:** ~10 minutos  
**Dificuldade:** Fácil  
**Requer:** Roblox Studio

Boa sorte, Hunter! 🎮✨
