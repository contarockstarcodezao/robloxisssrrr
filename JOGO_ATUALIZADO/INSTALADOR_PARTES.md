# 🎮 INSTALADOR EM PARTES - Shadow Hunter

## ⚠️ PROBLEMA: Console do Roblox tem limite de caracteres

## ✅ SOLUÇÃO: Instalar em 3 Etapas

---

## 📋 MÉTODO 1: Copiar Arquivos Manualmente (RECOMENDADO)

### ⏱️ Tempo: 5 minutos

### Passo 1: Criar Pastas
No Roblox Studio Explorer:

**ReplicatedStorage:**
1. Clique direito → Insert Object → Folder
2. Nome: `Modules`
3. Nome: `Events`
4. Nome: `RemoteEvents`
5. Nome: `RemoteFunctions`

**ServerScriptService:**
1. Clique direito → Insert Object → Folder
2. Nome: `Core`
3. Nome: `Combat`

**Workspace:**
1. Clique direito → Insert Object → Folder
2. Nome: `Zones`
3. Nome: `NPCs`

---

### Passo 2: Criar RemoteEvents (11 eventos)

Em `ReplicatedStorage/RemoteEvents/`, crie **RemoteEvent** com estes nomes:
1. AttackNPC
2. NPCDied
3. CaptureShadow
4. DestroyShadow
5. EquipShadow
6. UnequipShadow
7. UpdateHUD
8. DataLoaded
9. DataUpdated
10. ShowNotification
11. MissionCompleted

---

### Passo 3: Criar RemoteFunctions (4 funções)

Em `ReplicatedStorage/RemoteFunctions/`, crie **RemoteFunction** com estes nomes:
1. GetPlayerData
2. GetShadows
3. GetEquippedShadows
4. GetMissions

---

### Passo 4: Copiar Scripts Principais

Agora copie os 6 scripts principais dos arquivos separados:

1. **ReplicatedStorage/Modules/RankData** (ModuleScript)
   → Copie de `SCRIPTS/01_RankData.lua`

2. **ReplicatedStorage/Modules/NPCData** (ModuleScript)
   → Copie de `SCRIPTS/02_NPCData.lua`

3. **ReplicatedStorage/Modules/ShadowData** (ModuleScript)
   → Copie de `SCRIPTS/03_ShadowData.lua`

4. **ReplicatedStorage/Events/RemoteEvents** (ModuleScript)
   → Copie de `SCRIPTS/04_RemoteEvents.lua`

5. **ServerScriptService/Core/DataManager** (Script)
   → Copie de `SCRIPTS/05_DataManager.lua`

6. **ServerScriptService/Combat/NPCManager** (Script)
   → Copie de `SCRIPTS/06_NPCManager.lua`

7. **ServerScriptService/Combat/CombatSystem** (Script)
   → Copie de `SCRIPTS/07_CombatSystem.lua`

8. **ServerScriptService/MainServer** (Script)
   → Copie de `SCRIPTS/08_MainServer.lua`

---

### Passo 5: Testar

1. Pressione **F5**
2. Veja o Output
3. Deve aparecer "✅ SHADOW HUNTER INICIALIZADO!"

---

## 📋 MÉTODO 2: Modelo do Roblox (MAIS FÁCIL)

### ⏱️ Tempo: 30 segundos

Vou criar um arquivo `.rbxm` que você pode importar direto!

**Instruções:**

1. Baixe o arquivo `ShadowHunter.rbxm`
2. No Roblox Studio:
   - Clique direito em `Workspace`
   - Insert from File
   - Selecione `ShadowHunter.rbxm`
3. Arraste os itens para os lugares corretos
4. Pronto!

*(Arquivo .rbxm será criado em seguida)*

---

## 📋 MÉTODO 3: Plugin Loader (AUTOMÁTICO)

Vou criar um **plugin simples** que instala tudo automaticamente!

**Instruções:**

1. Baixe `ShadowHunterInstaller.rbxm`
2. Coloque em `%localappdata%/Roblox/Plugins`
3. Abra Roblox Studio
4. Vá em Plugins → Shadow Hunter Installer
5. Clique em "Install"
6. Pronto!

---

## ❓ Qual método escolher?

| Método | Dificuldade | Tempo | Recomendado |
|--------|-------------|-------|-------------|
| **Manual** | ⭐⭐⭐ | 5 min | ✅ Sim |
| **Modelo .rbxm** | ⭐ | 30 seg | ✅✅ Melhor! |
| **Plugin** | ⭐ | 10 seg | Se souber usar plugins |

---

**Continue lendo para ver os scripts separados!**
