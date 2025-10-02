# 📖 Guia de Instalação - Shadow Hunter

## 🚀 Método 1: Instalação Manual (Recomendado)

### Passo 1: Preparar o Roblox Studio
1. Abra o Roblox Studio
2. Crie um novo Place ou abra um existente
3. Certifique-se de ter o painel "Explorer" e "Properties" abertos

### Passo 2: Criar Estrutura de Pastas

#### No ReplicatedStorage:
1. Clique com botão direito em `ReplicatedStorage`
2. Insert Object → Folder
3. Crie as seguintes pastas:
   - `Modules`
   - `Events`

#### No ServerScriptService:
1. Clique com botão direito em `ServerScriptService`
2. Crie as seguintes pastas:
   - `Core`
   - `Combat`
   - `Zones`
   - `Economy`

#### No StarterPlayer:
1. Vá para `StarterPlayer` → `StarterPlayerScripts`
2. Crie as seguintes pastas:
   - `Client`
   - `UI`

#### No Workspace:
1. Crie as seguintes pastas:
   - `Zones`
   - `NPCs`

### Passo 3: Adicionar Scripts

#### ReplicatedStorage/Modules (ModuleScript):
1. Clique com botão direito em `ReplicatedStorage/Modules`
2. Insert Object → ModuleScript
3. Copie o conteúdo dos seguintes arquivos:
   - `RankData.lua`
   - `NPCData.lua`
   - `ShadowData.lua`

#### ReplicatedStorage/Events (ModuleScript):
1. Clique com botão direito em `ReplicatedStorage/Events`
2. Insert Object → ModuleScript
3. Copie o conteúdo de:
   - `RemoteEvents.lua`

#### ServerScriptService/Core (Script):
1. Clique com botão direito em `ServerScriptService/Core`
2. Insert Object → Script
3. Copie o conteúdo dos seguintes arquivos:
   - `DataManager.lua`
   - `RankSystem.lua`
   - `MissionSystem.lua`

#### ServerScriptService/Combat (Script):
1. Clique com botão direito em `ServerScriptService/Combat`
2. Insert Object → Script
3. Copie o conteúdo dos seguintes arquivos:
   - `NPCManager.lua`
   - `CombatSystem.lua`
   - `ShadowSystem.lua`

#### ServerScriptService/Zones (Script):
1. Clique com botão direito em `ServerScriptService/Zones`
2. Insert Object → Script
3. Copie o conteúdo de:
   - `ZoneManager.lua`

#### ServerScriptService (Script Principal):
1. Clique com botão direito em `ServerScriptService`
2. Insert Object → Script
3. Renomeie para `MainServer`
4. Copie o conteúdo de:
   - `MainServer.lua`

#### StarterPlayer/StarterPlayerScripts/Client (LocalScript):
1. Clique com botão direito em `StarterPlayer/StarterPlayerScripts/Client`
2. Insert Object → LocalScript
3. Copie o conteúdo dos seguintes arquivos:
   - `CombatClient.lua`
   - `ShadowClient.lua`

#### StarterPlayer/StarterPlayerScripts/UI (LocalScript):
1. Clique com botão direito em `StarterPlayer/StarterPlayerScripts/UI`
2. Insert Object → LocalScript
3. Copie o conteúdo de:
   - `HUDController.lua`

### Passo 4: Configurações Finais

1. **Habilitar API Services:**
   - Game Settings → Security → Enable Studio Access to API Services ✅

2. **Habilitar HTTP Requests (opcional):**
   - Game Settings → Security → Allow HTTP Requests ✅

3. **Configurar Spawn:**
   - Delete o SpawnLocation padrão do Workspace
   - O jogo usará o sistema de zonas para spawn

### Passo 5: Testar o Jogo

1. Clique em "Play" (F5)
2. Você deve ver:
   - Mensagens de inicialização no Output
   - HUD aparecendo no canto superior esquerdo
   - Zonas criadas no Workspace
   - NPCs spawnados nas zonas

## 🔧 Método 2: Usando Command Bar

1. Abra o Command Bar (View → Command Bar ou Ctrl+Shift+X)
2. Cole o conteúdo de `SETUP_COMMAND.lua`
3. Pressione Enter
4. A estrutura de pastas será criada automaticamente
5. Você ainda precisará copiar manualmente o código dos arquivos .lua

## ⚠️ Problemas Comuns

### Erro: "RemoteEvents not found"
**Solução:** Certifique-se de que `RemoteEvents.lua` está em `ReplicatedStorage/Events` e é um **ModuleScript**

### Erro: "DataStore request was rejected"
**Solução:** 
1. Publique o jogo no Roblox
2. Habilite API Services nas configurações do jogo

### NPCs não aparecem
**Solução:**
1. Verifique se `MainServer` está rodando (veja Output)
2. Certifique-se de que existe uma pasta `NPCs` no Workspace
3. Verifique se não há erros no Output

### HUD não aparece
**Solução:**
1. Certifique-se de que `HUDController.lua` é um **LocalScript**
2. Verifique se está na pasta correta: `StarterPlayer/StarterPlayerScripts/UI`
3. Verifique o Output para erros

### Sombras não são capturadas
**Solução:**
1. Aproxime-se do prompt de captura
2. Pressione **E** para capturar (3 tentativas)
3. Verifique se `ShadowClient.lua` está ativo

## 📝 Checklist de Instalação

- [ ] Estrutura de pastas criada
- [ ] Todos os ModuleScripts adicionados ao ReplicatedStorage
- [ ] Todos os Scripts do servidor adicionados
- [ ] Todos os LocalScripts do cliente adicionados
- [ ] MainServer.lua adicionado e configurado
- [ ] API Services habilitado
- [ ] Testado no Play Solo
- [ ] Sem erros no Output

## 🎮 Primeiros Passos Após Instalação

1. **Spawne no jogo** - Você começará na Floresta Silenciosa (Zona Iniciante)
2. **Ataque NPCs** - Clique ou pressione Espaço para atacar
3. **Capture Sombras** - Após derrotar um NPC, pressione **E** para capturar ou **F** para destruir
4. **Abra o Inventário** - Clique no botão "Inventário" no HUD
5. **Complete Missões** - Suba de rank completando missões
6. **Explore Zonas** - Use portais para acessar novas áreas

## 🆘 Suporte

Se encontrar problemas:
1. Verifique o Output para mensagens de erro
2. Certifique-se de que todos os arquivos estão nas pastas corretas
3. Verifique se os tipos de script estão corretos (Script vs LocalScript vs ModuleScript)
4. Recomece a instalação se necessário

## 📚 Documentação Adicional

- Ver `README.md` para visão geral do jogo
- Ver `TECHNICAL_DOCUMENTATION.md` para detalhes técnicos
- Ver `CONFIGURATION_GUIDE.md` para personalização

---

**Desenvolvido para Roblox Studio**
**Versão: 1.0**
