# 🎮 Arise Crossover - Guia de Instalação Completo

## 📌 Pré-requisitos
- Roblox Studio instalado
- Conta Roblox ativa
- Conhecimento básico do Roblox Studio

---

## 🚀 PASSO 1: Criar o Projeto

1. Abra o **Roblox Studio**
2. Crie um novo lugar usando o template **Baseplate**
3. Salve o jogo como **"Arise Crossover"**

---

## 📁 PASSO 2: Criar Estrutura de Pastas

### No ReplicatedStorage:
1. Clique com botão direito em **ReplicatedStorage**
2. Insira uma **Folder** e nomeie como **"Modules"**
3. Insira outra **Folder** e nomeie como **"Events"**

### No ServerScriptService:
1. Clique com botão direito em **ServerScriptService**
2. Insira uma **Folder** e nomeie como **"Core"**
3. Insira outra **Folder** e nomeie como **"Systems"**

### No StarterGui:
1. Clique com botão direito em **StarterGui**
2. Insira um **ScreenGui** e nomeie como **"GameUI"**

---

## 📜 PASSO 3: Instalar Módulos (ReplicatedStorage/Modules)

### 3.1 GameConfig
1. Em **ReplicatedStorage/Modules**, insira um **ModuleScript**
2. Renomeie para **"GameConfig"**
3. Cole o conteúdo de: `ReplicatedStorage_Modules_GameConfig.lua`

### 3.2 ShadowData
1. Em **ReplicatedStorage/Modules**, insira um **ModuleScript**
2. Renomeie para **"ShadowData"**
3. Cole o conteúdo de: `ReplicatedStorage_Modules_ShadowData.lua`

### 3.3 WeaponData
1. Em **ReplicatedStorage/Modules**, insira um **ModuleScript**
2. Renomeie para **"WeaponData"**
3. Cole o conteúdo de: `ReplicatedStorage_Modules_WeaponData.lua`

### 3.4 RelicData
1. Em **ReplicatedStorage/Modules**, insira um **ModuleScript**
2. Renomeie para **"RelicData"**
3. Cole o conteúdo de: `ReplicatedStorage_Modules_RelicData.lua`

### 3.5 UtilityFunctions
1. Em **ReplicatedStorage/Modules**, insira um **ModuleScript**
2. Renomeie para **"UtilityFunctions"**
3. Cole o conteúdo de: `ReplicatedStorage_Modules_UtilityFunctions.lua`

---

## 📡 PASSO 4: Criar RemoteEvents e RemoteFunctions

### Em ReplicatedStorage/Events:

1. **CombatEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"CombatEvent"**

2. **ShadowEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"ShadowEvent"**

3. **InventoryEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"InventoryEvent"**

4. **ShopEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"ShopEvent"**

5. **DungeonEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"DungeonEvent"**

6. **RankingEvent**
   - Insira um **RemoteEvent**
   - Renomeie para **"RankingEvent"**

7. **DataRequest**
   - Insira um **RemoteFunction**
   - Renomeie para **"DataRequest"**

---

## 🖥️ PASSO 5: Instalar Scripts do Servidor

### 5.1 Core Scripts

#### DataManager
1. Em **ServerScriptService/Core**, insira um **Script**
2. Renomeie para **"DataManager"**
3. Cole o conteúdo de: `ServerScriptService_Core_DataManager.lua`

#### ServerMain
1. Em **ServerScriptService/Core**, insira um **Script**
2. Renomeie para **"ServerMain"**
3. Cole o conteúdo de: `ServerScriptService_Core_ServerMain.lua`

### 5.2 Systems Scripts

#### CombatSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"CombatSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_CombatSystem.lua`

#### ShadowSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"ShadowSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_ShadowSystem.lua`

#### DropSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"DropSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_DropSystem.lua`

#### XPSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"XPSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_XPSystem.lua`

#### DungeonSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"DungeonSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_DungeonSystem.lua`

#### RankingSystem
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"RankingSystem"**
3. Cole o conteúdo de: `ServerScriptService_Systems_RankingSystem.lua`

#### NPCManager
1. Em **ServerScriptService/Systems**, insira um **Script**
2. Renomeie para **"NPCManager"**
3. Cole o conteúdo de: `ServerScriptService_Systems_NPCManager.lua`

---

## 💻 PASSO 6: Instalar Scripts do Cliente

### Em StarterPlayer/StarterPlayerScripts:

#### ClientMain
1. Em **StarterPlayer/StarterPlayerScripts**, insira um **LocalScript**
2. Renomeie para **"ClientMain"**
3. Cole o conteúdo de: `StarterPlayer_StarterPlayerScripts_ClientMain.lua`

#### CombatController
1. Em **StarterPlayer/StarterPlayerScripts**, insira um **ModuleScript**
2. Renomeie para **"CombatController"**
3. Cole o conteúdo de: `StarterPlayer_StarterPlayerScripts_CombatController.lua`

#### ShadowController
1. Em **StarterPlayer/StarterPlayerScripts**, insira um **ModuleScript**
2. Renomeie para **"ShadowController"**
3. Cole o conteúdo de: `StarterPlayer_StarterPlayerScripts_ShadowController.lua`

#### UIController
1. Em **StarterPlayer/StarterPlayerScripts**, insira um **ModuleScript**
2. Renomeie para **"UIController"**
3. Cole o conteúdo de: `StarterPlayer_StarterPlayerScripts_UIController.lua`

---

## 🎨 PASSO 7: Criar Interfaces Gráficas

### Em StarterGui/GameUI:

#### 7.1 HUD (sempre visível)
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"HUD"**
3. Configure:
   - Size: `{0, 300},{0, 100}`
   - Position: `{0, 10},{0, 10}`
   - BackgroundColor3: `(30, 30, 30)`
   - BackgroundTransparency: `0.3`

4. Dentro do HUD, adicione:
   - **TextLabel** "LevelLabel"
     - Size: `{1, 0},{0.5, 0}`
     - Text: "Nível: 1"
   - **TextLabel** "CashLabel"
     - Size: `{1, 0},{0.5, 0}`
     - Position: `{0, 0},{0.5, 0}`
     - Text: "💰 1000"

#### 7.2 ShadowInventory
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"ShadowInventory"**
3. Configure:
   - Size: `{0, 600},{0, 400}`
   - Position: `{0.5, -300},{0.5, -200}`
   - BackgroundColor3: `(20, 20, 20)`
   - Visible: `false`

4. Adicione um **ScrollingFrame** dentro
5. Adicione um **TextButton** "CloseButton" no canto superior direito

#### 7.3 Backpack (Inventário)
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"Backpack"**
3. Configure igual ao ShadowInventory
4. Visible: `false`

#### 7.4 Forge (Forja)
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"Forge"**
3. Configure igual aos anteriores
4. Visible: `false`

#### 7.5 Ranking
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"Ranking"**
3. Configure:
   - Size: `{0, 500},{0, 600}`
   - Position: `{0.5, -250},{0.5, -300}`
   - BackgroundColor3: `(20, 20, 20)`
   - Visible: `false`

4. Adicione um **ScrollingFrame** dentro

#### 7.6 DungeonUI
1. Em **GameUI**, insira um **Frame**
2. Renomeie para **"DungeonUI"**
3. Configure igual aos anteriores
4. Visible: `false`

---

## ⚙️ PASSO 8: Configurar DataStore

1. Vá em **Home > Game Settings** (ou pressione Alt+S)
2. Clique na aba **Security**
3. Ative **"Enable Studio Access to API Services"**
4. Clique em **Save**

---

## 🗺️ PASSO 9: Criar Área de Spawn de NPCs (Opcional)

1. No **Workspace**, insira uma **Folder**
2. Renomeie para **"NPCSpawns"**
3. Adicione várias **Part** dentro desta pasta
4. Posicione as Parts onde deseja que NPCs spawnem
5. Marque todas as Parts como **Anchored = true**
6. (Opcional) Deixe-as invisíveis: **Transparency = 1**

---

## 🎮 PASSO 10: Testar o Jogo

1. Pressione **F5** ou clique em **Play** para testar
2. Verifique o **Output** para mensagens de inicialização:
   - ✅ DataManager inicializado
   - ✅ CombatSystem inicializado
   - ✅ ShadowSystem inicializado
   - etc.

3. Teste os controles:
   - **Clique esquerdo**: Atacar
   - **B**: Abrir inventário
   - **C**: Menu de sombras
   - **F**: Forja
   - **L**: Ranking

---

## 🐛 PASSO 11: Solução de Problemas

### Erro: "Attempt to index nil with..."
**Solução**: Verifique se todos os módulos e eventos foram criados com os nomes corretos

### Erro: "DataStore request was rejected"
**Solução**: Certifique-se de que API Services está ativado e o jogo foi publicado

### NPCs não spawnam
**Solução**: Crie a pasta "NPCSpawns" no Workspace com Parts de spawn

### Interface não aparece
**Solução**: Verifique se todos os Frames foram criados dentro de StarterGui/GameUI

---

## 📝 PASSO 12: Publicar o Jogo

1. Clique em **File > Publish to Roblox**
2. Escolha um nome e descrição
3. Configure a visibilidade (Público/Privado)
4. Clique em **Create** ou **Update**

---

## 🎯 Recursos Adicionais

### Melhorias Recomendadas:
1. **Modelos 3D**: Substitua as Parts simples por modelos 3D reais de NPCs e sombras
2. **Animações**: Adicione IDs de animação reais nos scripts de combate
3. **Sons**: Adicione SoundIds reais para efeitos sonoros
4. **UI Design**: Melhore o design das interfaces com UICorner, UIGradient, etc.
5. **Mapas**: Crie áreas temáticas para diferentes ranks de NPCs
6. **Boss Arenas**: Crie arenas especiais para Raids

### Comandos Úteis para Teste:
Você pode adicionar comandos de admin temporários para testar:
- Dar cash
- Dar diamantes
- Dar sombras específicas
- Teleportar para dungeons

---

## ✅ Checklist Final

- [ ] Todos os ModuleScripts em ReplicatedStorage/Modules
- [ ] Todos os RemoteEvents em ReplicatedStorage/Events
- [ ] Todos os Scripts em ServerScriptService/Core e Systems
- [ ] Todos os LocalScripts em StarterPlayerScripts
- [ ] Todas as Frames em StarterGui/GameUI
- [ ] API Services ativado
- [ ] Jogo publicado
- [ ] Testado no Studio
- [ ] Testado no jogo publicado

---

## 🎊 Parabéns!

Seu jogo **Arise Crossover** está pronto! Agora você pode:
- Customizar sombras, armas e relíquias
- Adicionar novos sistemas
- Melhorar gráficos e UI
- Criar dungeons e raids únicas
- Adicionar Game Passes e Developer Products

**Boa sorte com seu jogo! 🎮✨**
