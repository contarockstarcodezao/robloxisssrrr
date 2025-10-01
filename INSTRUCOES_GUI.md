# 🎨 Guias de Interface - Arise Crossover

## 📋 Instruções de Instalação das GUIs

### 1. Estrutura de Pastas

Crie a seguinte estrutura em **StarterGui**:

```
StarterGui/
├── MainGUI.lua
├── InventoryGUI.lua
├── ShadowGUI.lua
├── CombatGUI.lua
├── RankingGUI.lua
├── WeaponGUI.lua
├── RelicGUI.lua
├── DungeonGUI.lua
└── GUIManager.lua
```

### 2. Copiar Scripts

1. **MainGUI.lua** - Interface principal com barra de status e botões
2. **InventoryGUI.lua** - Sistema de inventário com abas e grid
3. **ShadowGUI.lua** - Sistema de sombras com lista e detalhes
4. **CombatGUI.lua** - Interface de combate com barras e botões
5. **RankingGUI.lua** - Sistema de ranking e leaderboard
6. **WeaponGUI.lua** - Sistema de armas com forja e fusão
7. **RelicGUI.lua** - Sistema de relíquias com equipamento
8. **DungeonGUI.lua** - Sistema de dungeons e raids
9. **GUIManager.lua** - Gerenciador principal das interfaces

### 3. Configuração

#### ReplicatedStorage
Certifique-se de que os seguintes módulos estão em ReplicatedStorage:

```
ReplicatedStorage/
├── Data/
│   ├── ShadowData.lua
│   ├── WeaponData.lua
│   └── RelicData.lua
└── Events/
    └── RemoteEvents.lua
```

#### ServerScriptService
Certifique-se de que os sistemas estão funcionando:

```
ServerScriptService/
├── ShadowSystem/
├── Combat/
├── Drops/
├── LevelSystem/
├── Dungeons/
├── Ranking/
├── Inventory/
├── Weapons/
├── Economy/
└── Relics/
```

## 🎮 Funcionalidades das GUIs

### 🏠 MainGUI
- **Barra de status** com informações do jogador
- **Moedas** (Cash e Diamantes)
- **Botões de acesso rápido** para todas as interfaces
- **Sistema de notificações** integrado

### 📦 InventoryGUI
- **Abas organizadas** por tipo de item
- **Grid de itens** com ícones e quantidades
- **Sistema de filtros** e ordenação
- **Expansão de slots** com diamantes

### 👻 ShadowGUI
- **Lista de sombras** capturadas
- **Detalhes completos** de cada sombra
- **Sistema de evolução** e melhorias
- **Invocação e dispensa** de sombras

### ⚔️ CombatGUI
- **Barras de vida e mana** em tempo real
- **Botões de ataque** e habilidades
- **Informações do inimigo** quando em combate
- **Sistema de cooldowns** visual

### 🏆 RankingGUI
- **Leaderboard global** e semanal
- **Filtros por categoria** (nível, poder, etc.)
- **Estatísticas detalhadas** dos jogadores
- **Sistema de atualização** automática

### ⚔️ WeaponGUI
- **Lista de armas** com raridades
- **Sistema de forja** e melhorias
- **Fusão de armas** para criar versões superiores
- **Detalhes completos** de cada arma

### 💎 RelicGUI
- **Sistema de relíquias** com bônus passivos
- **Fusão de relíquias** para aumentar raridade
- **Equipamento em slots** específicos
- **Gerenciamento de bônus** automático

### 🏰 DungeonGUI
- **Lista de dungeons** disponíveis
- **Sistema de raids** cooperativas
- **Matchmaking** automático
- **Recompensas** e dificuldades

## ⌨️ Atalhos de Teclado

| Tecla | Função |
|-------|--------|
| **I** | Abrir/Fechar Inventário |
| **S** | Abrir/Fechar Sombras |
| **W** | Abrir/Fechar Armas |
| **R** | Abrir/Fechar Relíquias |
| **D** | Abrir/Fechar Dungeons |
| **L** | Abrir/Fechar Ranking |
| **ESC** | Fechar todas as interfaces |
| **F1** | Mostrar/Ocultar ajuda |

## 🎨 Características Visuais

### 🎯 Design Moderno
- **Cores consistentes** com tema do jogo
- **Animações suaves** com TweenService
- **Efeitos hover** em todos os botões
- **Bordas coloridas** baseadas em raridade

### 📱 Responsividade
- **Adaptação automática** a diferentes resoluções
- **Scrolling** em listas longas
- **Layout flexível** para diferentes tamanhos
- **Otimização** para dispositivos móveis

### 🔧 Funcionalidades Avançadas
- **Sistema de notificações** com animações
- **Filtros e ordenação** em tempo real
- **Busca e pesquisa** de itens
- **Sistema de ajuda** integrado

## 🚀 Como Usar

### 1. Abertura de Interfaces
```lua
-- Via código
_G.toggleInventory()
_G.toggleShadowGUI()
_G.toggleWeaponGUI()

-- Via atalhos de teclado
-- Pressione I para inventário
-- Pressione S para sombras
-- Pressione W para armas
```

### 2. Sistema de Notificações
```lua
-- Mostrar notificação
_G.showNotification("Texto da notificação", "Ícone", duração)
```

### 3. Gerenciamento de Estado
```lua
-- Fechar todas as interfaces
_G.closeAllGUIs()

-- Verificar estado
local isOpen = _G.guiState.inventoryGUI
```

## 🐛 Solução de Problemas

### ❌ Problemas Comuns

#### "GUI não abre"
- Verifique se o script está na pasta correta
- Certifique-se de que não há erros de sintaxe
- Verifique se os módulos estão carregados

#### "Botões não funcionam"
- Verifique se os eventos estão conectados
- Certifique-se de que as funções estão exportadas
- Verifique se não há conflitos de nomes

#### "Notificações não aparecem"
- Verifique se o sistema de notificações está inicializado
- Certifique-se de que a função showNotification está disponível
- Verifique se não há erros no console

### 🔧 Debug

#### Verificar Estado das GUIs
```lua
-- No console do Roblox Studio
print(_G.guiState)
```

#### Verificar Funções Exportadas
```lua
-- No console do Roblox Studio
print(_G.toggleInventory)
print(_G.showNotification)
```

#### Verificar Erros
```lua
-- No Output do Roblox Studio
-- Procure por mensagens de erro
-- Verifique se todos os scripts estão carregando
```

## 📚 Documentação Adicional

### 🎨 Personalização
- **Cores**: Modifique as cores nos scripts
- **Tamanhos**: Ajuste os tamanhos dos elementos
- **Animações**: Personalize as animações com TweenService
- **Fontes**: Altere as fontes nos TextLabels

### 🔧 Extensibilidade
- **Novas GUIs**: Adicione novas interfaces seguindo o padrão
- **Novos Atalhos**: Adicione novos atalhos no GUIManager
- **Novas Funcionalidades**: Estenda as funcionalidades existentes

### 📊 Performance
- **Otimização**: As GUIs são otimizadas para performance
- **Lazy Loading**: Carregamento sob demanda
- **Memory Management**: Gerenciamento automático de memória

## 🎉 Conclusão

As GUIs do Arise Crossover são completamente funcionais e prontas para uso. Elas fornecem uma experiência de usuário moderna e intuitiva, com todas as funcionalidades necessárias para o jogo.

**Lembre-se**: Sempre teste as interfaces antes de publicar o jogo para garantir que tudo está funcionando corretamente!