# 🎮 SHADOW HUNTER - INSTALAÇÃO MANUAL

## ⚠️ ATENÇÃO: Console do Roblox tem limite de caracteres!

Por isso, vamos instalar **manualmente** (leva 5 minutos)

---

## 📋 INSTALAÇÃO EM 5 MINUTOS

### Passo 1: Criar Pastas (1 min)

No **Roblox Studio Explorer**:

#### **ReplicatedStorage:**
1. Clique direito → Insert Object → Folder → Nome: `Modules`
2. Insert Object → Folder → Nome: `Events`
3. Insert Object → Folder → Nome: `RemoteEvents`
4. Insert Object → Folder → Nome: `RemoteFunctions`

#### **ServerScriptService:**
1. Clique direito → Insert Object → Folder → Nome: `Core`
2. Insert Object → Folder → Nome: `Combat`

#### **Workspace:**
1. Clique direito → Insert Object → Folder → Nome: `Zones`
2. Insert Object → Folder → Nome: `NPCs`

---

### Passo 2: Criar RemoteEvents (1 min)

Em **`ReplicatedStorage/RemoteEvents/`**:

Clique direito → Insert Object → **RemoteEvent**

Crie **11 eventos** com estes nomes:
1. `AttackNPC`
2. `NPCDied`
3. `CaptureShadow`
4. `DestroyShadow`
5. `EquipShadow`
6. `UnequipShadow`
7. `UpdateHUD`
8. `DataLoaded`
9. `DataUpdated`
10. `ShowNotification`
11. `MissionCompleted`

---

### Passo 3: Criar RemoteFunctions (30 seg)

Em **`ReplicatedStorage/RemoteFunctions/`**:

Clique direito → Insert Object → **RemoteFunction**

Crie **4 funções** com estes nomes:
1. `GetPlayerData`
2. `GetShadows`
3. `GetEquippedShadows`
4. `GetMissions`

---

### Passo 4: Copiar Scripts (3 min)

Agora copie os **8 scripts** da pasta `SCRIPTS/`:

#### **ReplicatedStorage/Modules/**

1. Clique direito em `Modules` → Insert Object → **ModuleScript**
2. Renomeie para `RankData`
3. Abra `SCRIPTS/01_RankData.lua`
4. Copie **TODO** o conteúdo
5. Cole no `RankData`

Repita para:
- `NPCData` ← `SCRIPTS/02_NPCData.lua`
- `ShadowData` ← `SCRIPTS/03_ShadowData.lua`

#### **ReplicatedStorage/Events/**

1. Clique direito em `Events` → Insert Object → **ModuleScript**
2. Renomeie para `RemoteEvents`
3. Copie de `SCRIPTS/04_RemoteEvents.lua`

#### **ServerScriptService/Core/**

1. Clique direito em `Core` → Insert Object → **Script**
2. Renomeie para `DataManager`
3. Copie de `SCRIPTS/05_DataManager.lua`

#### **ServerScriptService/Combat/**

1. Clique direito em `Combat` → Insert Object → **Script**
2. Renomeie para `NPCManager`
3. Copie de `SCRIPTS/06_NPCManager.lua`

Repita para:
- `CombatSystem` ← `SCRIPTS/07_CombatSystem.lua`

#### **ServerScriptService/**

1. Clique direito em `ServerScriptService` → Insert Object → **Script**
2. Renomeie para `MainServer`
3. Copie de `SCRIPTS/08_MainServer.lua`

---

### Passo 5: Testar! (10 seg)

1. Pressione **F5**
2. Veja o **Output** (View → Output)
3. Deve aparecer:

```
═══════════════════════════════════════
🎮 SHADOW HUNTER - INICIANDO
═══════════════════════════════════════
[DataManager] ✅ Inicializado
[NPCManager] ✅ Inicializado
[CombatSystem] ✅ Inicializado
═══════════════════════════════════════
✅ SHADOW HUNTER INICIALIZADO!
═══════════════════════════════════════
📊 NPCs Spawnados: 5 Goblin Fraco
🎮 Jogo pronto para jogar!
```

---

## ✅ CHECKLIST

- [ ] Todas as pastas criadas
- [ ] 11 RemoteEvents criados
- [ ] 4 RemoteFunctions criados
- [ ] 8 scripts copiados
- [ ] Output mostra "✅ INICIALIZADO!"
- [ ] 5 Goblins verdes aparecem no Workspace

---

## 🎮 COMO JOGAR

1. **Aproxime-se** de um Goblin verde
2. **Clique** nele para atacar (ou pressione Espaço)
3. **Mate** o Goblin (100 HP)
4. **Aparecerá** um prompt roxo no chão
5. **Pressione E** para capturar sombra (3 chances)
6. **Ou pressione F** para destruir e ganhar diamantes

---

## 📁 ARQUIVOS

- **`LEIA_PRIMEIRO.md`** ← Você está aqui
- **`SCRIPTS/`** ← 8 arquivos .lua para copiar
- **`DOCUMENTACAO_COMPLETA.md`** ← Detalhes técnicos
- **`INSTALADOR_PARTES.md`** ← Instruções completas

---

## ❓ PROBLEMAS?

### "RemoteEvents not found"
→ Verifique se criou a pasta `RemoteEvents` em `ReplicatedStorage`

### NPCs não aparecem
→ Veja se criou a pasta `NPCs` no Workspace

### Erros no Output
→ Verifique se copiou TODOS os 8 scripts
→ Certifique-se que são do tipo correto (Script vs ModuleScript)

---

**Boa sorte!** 🎮✨
