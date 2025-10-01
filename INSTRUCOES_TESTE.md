# 🧪 Instruções de Teste - Arise Crossover

## 🚨 Problema Identificado

O sistema anterior estava tentando carregar módulos que ainda não existiam, causando falhas no carregamento. Criei uma versão simplificada para teste.

## ✅ Solução Imediata

### 1. Remover Scripts Problemáticos

**DELETE** os seguintes scripts se existirem:
- `ServerScriptService/TestSystem.lua`
- `ServerScriptService/MainServer.lua`
- Qualquer script que tente carregar módulos inexistentes

### 2. Adicionar Scripts de Teste

**ADICIONE** estes scripts:

#### ServerScriptService/TestSystem_Simple.lua
```lua
-- Script de teste simplificado que funciona sem dependências
-- Copie o conteúdo do arquivo TestSystem_Simple.lua
```

#### StarterGui/TestGUI.lua
```lua
-- GUI de teste simples
-- Copie o conteúdo do arquivo TestGUI.lua
```

## 🎮 Como Testar

### 1. Execute o Jogo
1. Abra o Roblox Studio
2. Execute o jogo (F5)
3. Aguarde 2-3 segundos

### 2. Verifique o Console
Você deve ver:
```
🧪 === TESTE SIMPLES INICIADO ===
✅ Testando funcionalidades básicas...
  ✓ Jogo funcionando
  ✓ Jogadores conectados: 1
  ✓ Workspace acessível
  ✓ ReplicatedStorage acessível
✅ Testando criação de dados...
  ✓ Pasta Data criada
  ✓ Pasta Events criada
✅ Testando criação de GUI...
  ✓ GUI de teste criada
✅ Testando eventos básicos...
  ✓ Eventos básicos conectados
🧪 === RELATÓRIO DE TESTES ===
🎉 Todos os testes passaram! Sistema funcionando.
```

### 3. Verifique a Interface
Você deve ver:
- **Barra de status** no topo da tela
- **Informações do jogador** (nome, nível, XP)
- **Moedas** (Cash e Diamantes)
- **Botões** (Inventário, Sombras, Armas, Relíquias, Ranking)
- **Notificação de boas-vindas**

### 4. Teste os Botões
- Clique nos botões para ver notificações
- Use as teclas **I, S, W, R, L** para atalhos
- Pressione **F1** para ajuda

## 🔧 Se Ainda Não Funcionar

### Verifique o Console
Procure por erros como:
- `Module not found`
- `Script error`
- `Failed to load`

### Soluções Comuns

#### Erro: "Module not found"
- **Causa**: Script tentando carregar módulo inexistente
- **Solução**: Use apenas os scripts de teste fornecidos

#### Erro: "Script error"
- **Causa**: Erro de sintaxe no script
- **Solução**: Verifique se copiou o código corretamente

#### Erro: "Failed to load"
- **Causa**: Script na pasta errada
- **Solução**: Verifique se está em StarterGui ou ServerScriptService

## 📋 Próximos Passos

### Após o Teste Funcionar

1. **Copie os scripts das GUIs** para StarterGui
2. **Copie os scripts dos sistemas** para ServerScriptService
3. **Execute o jogo** novamente
4. **Teste todas as funcionalidades**

### Estrutura Final Esperada

```
StarterGui/
├── TestGUI.lua              # GUI de teste
├── MainGUI.lua              # Interface principal
├── InventoryGUI.lua         # Sistema de inventário
├── ShadowGUI.lua           # Sistema de sombras
├── CombatGUI.lua           # Interface de combate
├── RankingGUI.lua          # Sistema de ranking
├── WeaponGUI.lua           # Sistema de armas
├── RelicGUI.lua            # Sistema de relíquias
├── DungeonGUI.lua          # Sistema de dungeons
└── GUIManager.lua          # Gerenciador principal

ServerScriptService/
├── TestSystem_Simple.lua   # Sistema de teste
├── ShadowSystem/           # Sistema de sombras
├── Combat/                 # Sistema de combate
├── Drops/                  # Sistema de drops
├── LevelSystem/            # Sistema de níveis
├── Dungeons/               # Sistema de dungeons
├── Ranking/                # Sistema de ranking
├── Inventory/              # Sistema de inventário
├── Weapons/                # Sistema de armas
├── Economy/                # Sistema de economia
└── Relics/                 # Sistema de relíquias

ReplicatedStorage/
├── Data/                   # Dados do jogo
└── Events/                  # Eventos
```

## 🎯 Teste Completo

### Funcionalidades a Testar

1. **Interface Principal**
   - Barra de status visível
   - Informações do jogador
   - Moedas funcionando
   - Botões responsivos

2. **Sistema de Notificações**
   - Notificações aparecem
   - Animações funcionando
   - Auto-fechamento

3. **Atalhos de Teclado**
   - I - Inventário
   - S - Sombras
   - W - Armas
   - R - Relíquias
   - L - Ranking
   - F1 - Ajuda

4. **Efeitos Visuais**
   - Hover nos botões
   - Animações suaves
   - Cores consistentes

## 🚀 Resultado Esperado

Após seguir estas instruções, você deve ter:

- ✅ **Sistema funcionando** sem erros
- ✅ **Interface visível** na tela
- ✅ **Botões responsivos** funcionando
- ✅ **Notificações** aparecendo
- ✅ **Atalhos de teclado** funcionando
- ✅ **Console limpo** sem erros

## 🆘 Suporte

Se ainda houver problemas:

1. **Verifique o console** para erros específicos
2. **Teste um script por vez** para identificar o problema
3. **Verifique a estrutura** de pastas
4. **Reinicie o Roblox Studio** se necessário

O sistema de teste simplificado deve funcionar imediatamente e fornecer uma base sólida para adicionar as funcionalidades completas!