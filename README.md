# 🎮 Sistema Completo de RPG para Roblox
## DataManager + Combat System + UI Completa

![Roblox](https://img.shields.io/badge/Roblox-Studio-00A2FF?style=for-the-badge&logo=roblox)
![Lua](https://img.shields.io/badge/Lua-Script-2C2D72?style=for-the-badge&logo=lua)
![Status](https://img.shields.io/badge/Status-Pronto-success?style=for-the-badge)

---

## 📋 Visão Geral

Sistema completo de RPG modular para Roblox incluindo gerenciamento de dados, combate com hitbox, sistema de progressão, economia, conquistas automáticas, e interface gráfica moderna.

### ✨ Características Principais

- ✅ **DataManager Completo** - Salva e carrega dados do DataStore
- ✅ **Sistema de Combate** - Hitbox baseada em raio, múltiplos estilos
- ✅ **Progressão de Personagem** - Níveis, XP com curva de dificuldade
- ✅ **Economia** - Cash, Diamantes, Fragmentos
- ✅ **Sistema de Conquistas** - Automático com recompensas
- ✅ **Estatísticas Detalhadas** - Rastreamento completo de ações
- ✅ **Tempo de Jogo** - Rastreamento preciso em tempo real
- ✅ **Sistema de Sombras** - Captura com chance configurável
- ✅ **Inventário** - Armas, relíquias, consumíveis
- ✅ **Sistema de Relíquias** - Bônus passivos quando equipadas
- ✅ **Interface Moderna** - HUD + Menu detalhado (TAB)
- ✅ **Auto-Save** - Salvamento automático a cada 5 minutos
- ✅ **Respawn de NPCs** - Automático após morte
- ✅ **Boss System** - NPCs especiais com recompensas 5x
- ✅ **Notificações** - Feedback visual para eventos importantes

---

## 📁 Estrutura do Projeto

```
ReplicatedStorage/Modules/
├── GameConfig.lua          # Configurações centralizadas
├── UtilityFunctions.lua    # Funções auxiliares
├── RelicData.lua           # Sistema de relíquias
└── RemoteEvents.lua        # Comunicação cliente-servidor

ServerScriptService/
├── Core/
│   └── DataManager.lua     # ⭐ Gerenciamento de dados principal
└── Systems/
    └── CombatServer.lua    # Lógica de combate do servidor

StarterPlayer/StarterCharacterScripts/
└── CombatClient.lua        # Detecção de input e ataques

StarterGui/
├── PlayerUI.lua            # HUD principal (sempre visível)
└── MenuUI.lua              # Menu detalhado (TAB)
```

---

## 🚀 Instalação

### Método Rápido (5 minutos)

Consulte **[GUIA_RAPIDO.md](GUIA_RAPIDO.md)** para instalação expressa.

### Método Detalhado

Consulte **[INSTALACAO_COMPLETA.md](INSTALACAO_COMPLETA.md)** para guia completo passo a passo com troubleshooting.

### Visualização da Estrutura

Consulte **[ESTRUTURA_VISUAL.txt](ESTRUTURA_VISUAL.txt)** para diagrama visual completo.

---

## 🎮 Como Usar

### Controles

| Ação | Tecla/Botão |
|------|-------------|
| Atacar | **Clique Esquerdo do Mouse** |
| Trocar para Soco | **1** |
| Trocar para Espada | **2** |
| Abrir/Fechar Menu | **TAB** |

### Interface

#### HUD (Sempre Visível)
- **Painel de Status** (canto superior esquerdo)
  - Nome e nível do jogador
  - Barra de XP animada com progresso
  - Cash e diamantes
  
- **Tempo Jogado** (canto superior direito)
  - Contador em tempo real (HH:MM:SS)
  
- **Painel de Combate** (lado esquerdo)
  - Botões para alternar entre estilos
  - Indicador visual do estilo ativo
  - Dano de cada estilo

#### Menu Detalhado (Tecla TAB)

**📊 Estatísticas**
- Inimigos derrotados
- Chefes derrotados
- Sombras capturadas
- Dungeons/Raids completadas
- Dano causado/recebido
- Mortes
- Tempo total jogado

**🏆 Conquistas**
- Lista de todas as conquistas
- Indicador de desbloqueadas/bloqueadas
- Descrição e recompensas
- Contador de progresso

**🎒 Inventário** *(em desenvolvimento)*
- Armas coletadas
- Relíquias disponíveis
- Consumíveis

**🧞‍♂️ Sombras**
- Sombras capturadas
- Slots disponíveis
- Sistema de invocação

---

## ⚙️ Configuração

### Editar Combate

Em `ReplicatedStorage/Modules/GameConfig.lua`:

```lua
Combat = {
    AttackStyles = {
        Fist = {
            Name = "Soco",
            Damage = 15,      -- Dano base
            Range = 5,        -- Alcance em studs
            Cooldown = 0.5,   -- Segundos entre ataques
        },
        Sword = {
            Name = "Espada",
            Damage = 30,
            Range = 7,
            Cooldown = 1.0,
        },
    },
}
```

### Editar Progressão

```lua
Experience = {
    BaseXPRequired = 100,    -- XP para level 2
    XPScaling = 1.5,         -- Multiplicador por level
    MaxLevel = 100,          -- Nível máximo
}
```

### Editar Economia

```lua
Economy = {
    StartingCash = 1000,     -- Cash inicial
    StartingDiamonds = 50,   -- Diamantes iniciais
}
```

### Adicionar Conquistas

```lua
{
    ID = "sua_conquista_id",
    Name = "Nome da Conquista",
    Description = "Descrição do objetivo",
    Icon = "🎯",
    Requirement = { 
        Type = "Kills",      -- Kills, BossKills, Level, PlayTime, ShadowsCaptured
        Amount = 100 
    },
    Rewards = { 
        Cash = 500, 
        XP = 250, 
        Diamonds = 10 
    },
}
```

### Configurar NPCs

1. Crie um **Model** no Workspace
2. Adicione **Humanoid** e **HumanoidRootPart**
3. Em **Properties** → **Tags**, adicione: `Enemy`
4. **(Opcional)** Para boss, adicione também: `Boss`
5. **(Opcional)** Em **Attributes**, adicione:
   - Nome: `Level`
   - Tipo: Number
   - Valor: nível do NPC

---

## 💾 Sistema de Dados

### O que é Salvo

- ✅ Level e XP atual
- ✅ Cash, Diamantes, Fragmentos
- ✅ Tipo de arma equipada
- ✅ Sombras capturadas (array completo)
- ✅ Inventário completo (armas, relíquias, consumíveis)
- ✅ Relíquias equipadas (até 3)
- ✅ Todas as estatísticas de combate
- ✅ Conquistas desbloqueadas
- ✅ Tempo de jogo total (em segundos)
- ✅ Cooldowns de dungeons/raids
- ✅ Timestamps (criação, último login, último save)

### Auto-Save

- **Frequência**: A cada 5 minutos (configurável)
- **Ao sair**: Salva automaticamente quando jogador deixa o jogo
- **Ao fechar**: Salva todos os jogadores quando servidor fecha

### DataStore

- **Nome**: `PlayerData_v2`
- **Chave**: `Player_[UserId]`
- **Versionamento**: Ao alterar estrutura, mude a versão (ex: v3)

---

## 🏆 Sistema de Conquistas

### Verificação Automática

O sistema verifica conquistas automaticamente quando:
- Jogador mata um NPC (verifica `Kills`, `BossKills`)
- Jogador sobe de nível (verifica `Level`)
- Tempo de jogo atualiza (verifica `PlayTime`)
- Sombra é capturada (verifica `ShadowsCaptured`)

### Conquistas Pré-configuradas

1. **Primeira Vítima** - Derrote 1 inimigo
2. **Guerreiro** - Derrote 50 inimigos
3. **Lenda** - Derrote 500 inimigos
4. **Caçador de Chefes** - Derrote 10 chefes
5. **Mestre das Sombras** - Capture 20 sombras
6. **Ascensão I** - Alcance nível 10
7. **Ascensão II** - Alcance nível 50
8. **Veterano** - Jogue por 10 horas

### Recompensas

Ao desbloquear uma conquista:
- Recompensas são adicionadas automaticamente
- Notificação aparece na tela
- Conquista é salva no DataStore

---

## 🧿 Sistema de Relíquias

### Tipos de Bônus

- **XPBoost** - Aumenta XP ganho em %
- **CashBoost** - Aumenta Cash ganho em %
- **DamageBoost** - Aumenta dano causado em %
- **HealthBoost** - Aumenta vida máxima em valor fixo
- **ShadowCaptureBoost** - Aumenta chance de captura em %

### Relíquias Pré-configuradas

1. **Amuleto da Sabedoria** - +25% XP
2. **Talismã da Fortuna** - +20% Cash
3. **Anel do Poder** - +15% Dano
4. **Colar da Vitalidade** - +50 HP
5. **Orbe Sombrio** - +10% Chance de Captura

### Limite

- Jogador pode equipar até **3 relíquias** simultaneamente
- Bônus são cumulativos

---

## 🧞‍♂️ Sistema de Sombras

### Mecânica

- Ao matar um NPC, há **15% de chance** de capturar sua "sombra"
- Chance aumenta com bônus de relíquias
- Sombras são salvas permanentemente

### Limite

- Jogador começa com **5 slots** (configurável)
- Pode ser expandido no futuro

---

## 🐛 Troubleshooting

### ❌ Erro: "GameConfig não encontrado"
**Solução**: Verifique se todos os ModuleScripts estão em `ReplicatedStorage/Modules/`

### ❌ NPCs não tomam dano
**Solução**: 
- Adicione a tag `Enemy` no Model do NPC
- Confirme que tem `Humanoid` e `HumanoidRootPart`
- Ative `DebugMode` para visualizar hitbox

### ❌ UI não aparece
**Solução**:
- Aguarde 2-3 segundos após entrar no jogo
- Verifique console (F9) para erros
- Confirme que LocalScripts estão em `StarterGui`

### ❌ Dados não salvam
**Solução**:
- Ative **API Services**: Home → Game Settings → Security → Enable Studio Access to API Services
- Teste em servidor real (não apenas Play no Studio)

### ❌ Conquistas não desbloqueiam
**Solução**:
- Verifique valores em `GameConfig.Achievements`
- Confirme que estatísticas estão sendo atualizadas
- Use prints para debugar

---

## 🔧 Modo Debug

Para visualizar hitbox ao atacar:

```lua
-- Em GameConfig.lua
HitboxSettings = {
    DebugMode = true,  -- Muda para true
}
```

Uma esfera vermelha aparecerá mostrando a área de ataque!

---

## 📈 Expansões Futuras

Ideias para implementar:

- [ ] Sistema de Dungeons com cooldowns
- [ ] Sistema de Raids multiplayer
- [ ] Loja de itens (armas, relíquias)
- [ ] PvP (combate entre jogadores)
- [ ] Sistema de invocação de sombras em combate
- [ ] Pets
- [ ] Sistema de clãs/guildas
- [ ] Ranking global de jogadores
- [ ] Eventos temporários
- [ ] Sistema de crafting

---

## 📊 Estatísticas do Sistema

- **Arquivos totais**: 11
- **Linhas de código**: ~3000+
- **Módulos**: 4
- **Scripts do servidor**: 2
- **LocalScripts**: 3
- **RemoteEvents**: 7+
- **Conquistas pré-configuradas**: 8
- **Relíquias pré-configuradas**: 5

---

## 📝 Licença

Este sistema é de código aberto e pode ser usado livremente em seus projetos Roblox.

---

## 🤝 Contribuições

Sugestões e melhorias são bem-vindas! Áreas para contribuir:
- Novos estilos de combate
- Mais conquistas
- Novas relíquias
- Melhorias na UI
- Sistema de sons e efeitos visuais
- Otimizações de performance

---

## 📞 Suporte

Para problemas:
1. Consulte o [GUIA_RAPIDO.md](GUIA_RAPIDO.md)
2. Veja a [INSTALACAO_COMPLETA.md](INSTALACAO_COMPLETA.md)
3. Verifique o console (F9) para erros
4. Confira se todos os arquivos estão nos locais corretos

---

## ✅ Checklist de Instalação

Antes de testar:

- [ ] Todos os ModuleScripts em `ReplicatedStorage/Modules/`
- [ ] DataManager em `ServerScriptService/Core/`
- [ ] CombatServer em `ServerScriptService/Systems/`
- [ ] CombatClient em `StarterCharacterScripts`
- [ ] PlayerUI e MenuUI em `StarterGui`
- [ ] Pelo menos 1 NPC com tag `Enemy`
- [ ] API Services ativado

---

## 🎉 Pronto para Usar!

Seu sistema de RPG está completo e pronto para ser expandido!

**Desenvolvido com ❤️ para a comunidade Roblox**

---

## 📚 Documentação Adicional

- **[GUIA_RAPIDO.md](GUIA_RAPIDO.md)** - Instalação em 5 minutos
- **[INSTALACAO_COMPLETA.md](INSTALACAO_COMPLETA.md)** - Guia detalhado completo
- **[ESTRUTURA_VISUAL.txt](ESTRUTURA_VISUAL.txt)** - Diagrama visual da estrutura

---

**Versão**: 2.0  
**Última atualização**: 2025  
**Compatibilidade**: Roblox Studio (Versão mais recente)
