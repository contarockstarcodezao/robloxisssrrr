--- SISTEMA COMPLETO COM DATAMANAGER ---
# 🎮 Sistema de Combate + DataManager - Roblox

## 📋 VISÃO GERAL

Sistema completo de RPG para Roblox incluindo:
- ✅ Sistema de combate com hitbox
- ✅ DataManager com DataStore integrado
- ✅ Sistema de níveis e XP
- ✅ Economia (Cash e Diamantes)
- ✅ Sistema de conquistas automático
- ✅ Estatísticas detalhadas
- ✅ Tempo de jogo rastreado
- ✅ Sistema de sombras (capturas)
- ✅ Inventário e relíquias
- ✅ Interface completa com menu detalhado
- ✅ Auto-save a cada 5 minutos

---

## 📁 ESTRUTURA DE ARQUIVOS

```
ReplicatedStorage/
└── Modules/
    ├── GameConfig.lua (ModuleScript)
    ├── UtilityFunctions.lua (ModuleScript)
    ├── RelicData.lua (ModuleScript)
    └── RemoteEvents.lua (ModuleScript)

ServerScriptService/
├── Core/
│   └── DataManager.lua (Script)
└── Systems/
    └── CombatServer.lua (Script)

StarterPlayer/
└── StarterCharacterScripts/
    └── CombatClient.lua (LocalScript)

StarterGui/
├── PlayerUI.lua (LocalScript)
└── MenuUI.lua (LocalScript)
```

---

## 🚀 INSTALAÇÃO PASSO A PASSO

### PASSO 1: ReplicatedStorage

1. Em **ReplicatedStorage**, crie uma **Folder** chamada `Modules`

2. Dentro de `Modules`, crie 4 **ModuleScripts**:

   **a) GameConfig**
   - Cole o código de `/workspace/ReplicatedStorage/Modules/GameConfig.lua`
   
   **b) UtilityFunctions**
   - Cole o código de `/workspace/ReplicatedStorage/Modules/UtilityFunctions.lua`
   
   **c) RelicData**
   - Cole o código de `/workspace/ReplicatedStorage/Modules/RelicData.lua`
   
   **d) RemoteEvents**
   - Cole o código de `/workspace/ReplicatedStorage/Modules/RemoteEvents.lua`

---

### PASSO 2: ServerScriptService

1. Em **ServerScriptService**, crie uma **Folder** chamada `Core`

2. Dentro de `Core`, crie 1 **Script**:

   **DataManager**
   - Cole o código de `/workspace/ServerScriptService/Core/DataManager.lua`

3. Em **ServerScriptService**, crie uma **Folder** chamada `Systems`

4. Dentro de `Systems`, crie 1 **Script**:

   **CombatServer**
   - Cole o código de `/workspace/ServerScriptService/Systems/CombatServer.lua`

---

### PASSO 3: StarterPlayer

1. Navegue até **StarterPlayer** → **StarterCharacterScripts**

2. Crie 1 **LocalScript**:

   **CombatClient**
   - Cole o código de `/workspace/StarterPlayer/StarterCharacterScripts/CombatClient.lua`

---

### PASSO 4: StarterGui

1. Em **StarterGui**, crie 2 **LocalScripts**:

   **a) PlayerUI**
   - Cole o código de `/workspace/StarterGui/PlayerUI.lua`
   
   **b) MenuUI**
   - Cole o código de `/workspace/StarterGui/MenuUI.lua`

---

### PASSO 5: Configurar NPCs

Para cada inimigo no jogo:

1. Crie um **Model** no Workspace
2. Adicione:
   - `Humanoid`
   - `HumanoidRootPart`
   - Partes do corpo
3. Selecione o **Model**
4. No painel **Properties**:
   - Vá em **Tags** (ícone de etiqueta)
   - Clique em **+**
   - Digite: `Enemy`
   - Pressione Enter

**Para criar um BOSS:**
- Adicione DUAS tags: `Enemy` E `Boss`
- Bosses dão 5x mais recompensas!

**Definir nível do NPC (opcional):**
- Com o Model selecionado
- Em **Properties**, clique em **Attributes**
- Adicione um atributo:
  - Nome: `Level`
  - Tipo: Number
  - Valor: (ex: 5)

---

## 🎮 CONTROLES DO JOGO

| Ação | Tecla/Botão |
|------|-------------|
| Atacar | **Clique Esquerdo** |
| Trocar para Soco | **1** |
| Trocar para Espada | **2** |
| Abrir Menu | **TAB** |

---

## 📊 MENU DO JOGADOR (TAB)

O menu possui 4 abas:

### 1. 📊 Estatísticas
- Inimigos derrotados
- Chefes derrotados
- Sombras capturadas
- Dungeons e Raids
- Dano causado/recebido
- Mortes
- Tempo jogado

### 2. 🏆 Conquistas
- Visualizar todas as conquistas
- Ver progresso
- Conquistas desbloqueadas
- Recompensas recebidas

### 3. 🎒 Inventário
- Sistema de inventário (em desenvolvimento)

### 4. 🧞‍♂️ Sombras
- Ver sombras capturadas
- Gerenciar slots

---

## ⚙️ CONFIGURAÇÕES

### Editar Dano e Alcance

Em `GameConfig.lua`:

```lua
AttackStyles = {
    Fist = {
        Name = "Soco",
        Damage = 15,      -- ← Dano base
        Range = 5,        -- ← Alcance em studs
        Cooldown = 0.5,   -- ← Tempo entre ataques
    },
    Sword = {
        Name = "Espada",
        Damage = 30,
        Range = 7,
        Cooldown = 1.0,
    },
}
```

### Editar Economia Inicial

```lua
Economy = {
    StartingCash = 1000,     -- ← Cash inicial
    StartingDiamonds = 50,   -- ← Diamantes iniciais
}
```

### Editar Sistema de XP

```lua
Experience = {
    BaseXPRequired = 100,    -- ← XP base para level 2
    XPScaling = 1.5,         -- ← Multiplicador (fica mais difícil)
    MaxLevel = 100,          -- ← Level máximo
}
```

### Editar Recompensas de NPCs

```lua
NPCSettings = {
    RespawnTime = 5,         -- ← Tempo de respawn (segundos)
    DefaultHealth = 100,     -- ← Vida dos NPCs
    BaseXPReward = 25,       -- ← XP por morte
    BaseCashReward = 15,     -- ← Cash por morte
    BossMultiplier = 5,      -- ← Bosses dão 5x mais
}
```

### Editar Conquistas

Adicione novas conquistas em `GameConfig.lua`:

```lua
{
    ID = "sua_conquista",
    Name = "Nome da Conquista",
    Description = "Descrição do que fazer",
    Icon = "🎯",
    Requirement = { 
        Type = "Kills",    -- ou BossKills, Level, PlayTime, ShadowsCaptured
        Amount = 100 
    },
    Rewards = { 
        Cash = 500, 
        XP = 250, 
        Diamonds = 10 
    },
}
```

### Editar Auto-Save

```lua
Time = {
    AutoSaveInterval = 300,           -- ← 300 segundos = 5 minutos
    PlayTimeUpdateInterval = 60,      -- ← Atualizar tempo a cada minuto
}
```

---

## 🧿 SISTEMA DE RELÍQUIAS

Relíquias dão bônus permanentes quando equipadas.

### Tipos de Bônus:
- `XPBoost` - Aumenta XP ganho
- `CashBoost` - Aumenta Cash ganho
- `DamageBoost` - Aumenta dano
- `HealthBoost` - Aumenta vida máxima
- `ShadowCaptureBoost` - Aumenta chance de captura

### Adicionar Nova Relíquia

Em `RelicData.lua`:

```lua
{
    ID = "sua_reliquia",
    Name = "Nome da Relíquia",
    Description = "+50% XP",
    Rarity = "Épico",
    Icon = "💎",
    Bonuses = { 
        XPBoost = 0.50  -- 50% de bônus
    },
}
```

---

## 🏆 SISTEMA DE CONQUISTAS

Conquistas são verificadas **automaticamente** quando:
- Jogador mata inimigo (verifica Kills, BossKills)
- Jogador sobe de nível (verifica Level)
- Tempo de jogo aumenta (verifica PlayTime)
- Sombra é capturada (verifica ShadowsCaptured)

**Não precisa programar nada extra!**

Quando desbloqueada:
1. Adiciona à lista de conquistas do jogador
2. Concede recompensas automaticamente
3. Mostra notificação na tela
4. Salva no DataStore

---

## 🧞‍♂️ SISTEMA DE SOMBRAS

Ao matar um NPC, há uma chance de capturar sua "sombra".

- **Chance Base**: 15%
- **Aumenta com**: Relíquias de captura
- **Limite**: 5 slots (configurável)

As sombras capturadas ficam salvas no perfil do jogador.

---

## 💾 SISTEMA DE SALVAMENTO

### Auto-Save
- Salva automaticamente **a cada 5 minutos**
- Salva quando jogador sai do jogo
- Salva quando servidor fecha

### O que é salvo:
✅ Level e XP  
✅ Cash e Diamantes  
✅ Tipo de arma equipada  
✅ Sombras capturadas  
✅ Inventário completo  
✅ Relíquias equipadas  
✅ Todas as estatísticas  
✅ Conquistas desbloqueadas  
✅ Tempo de jogo total  

### DataStore
- Nome: `PlayerData_v2`
- Chave: `Player_[UserId]`

**IMPORTANTE**: Se alterar a estrutura de dados, mude a versão (ex: `PlayerData_v3`) para evitar conflitos.

---

## 🎨 PERSONALIZAR UI

### Cores

Em `PlayerUI.lua` e `MenuUI.lua`, procure por:

```lua
BackgroundColor3 = Color3.fromRGB(25, 25, 30)  -- Fundo escuro
TextColor3 = Color3.fromRGB(255, 255, 255)     -- Texto branco
```

### Tamanhos

```lua
Size = UDim2.new(0, 280, 0, 140)  -- Largura: 280, Altura: 140
```

### Posições

```lua
Position = UDim2.new(0, 20, 0, 20)  -- X: 20, Y: 20 pixels
```

---

## 🐛 SOLUÇÃO DE PROBLEMAS

### ❌ Erro: "GameConfig não encontrado"

**Solução**: Verifique se todos os ModuleScripts estão em `ReplicatedStorage/Modules/`

---

### ❌ NPCs não tomam dano

**Solução**: 
1. Verifique se o NPC tem a tag `Enemy`
2. Confirme que tem `Humanoid` e `HumanoidRootPart`
3. Ative `DebugMode` em `GameConfig.lua` para ver a hitbox

---

### ❌ UI não aparece

**Solução**:
1. Confirme que os LocalScripts estão em `StarterGui`
2. Verifique o console (F9) para erros
3. Aguarde 2-3 segundos após entrar no jogo

---

### ❌ Dados não salvam

**Solução**:
1. Verifique se **API Services** está ativado:
   - Home → Game Settings → Security → Enable Studio Access to API Services
2. Teste em um servidor real, não no Studio

---

### ❌ Conquistas não desbloqueiam

**Solução**:
1. Verifique se a estatística está sendo atualizada
2. Confira os valores em `GameConfig.Achievements`
3. Use `print()` para debugar

---

### ❌ Level up não acontece

**Solução**:
1. Verifique se está ganhando XP (veja no HUD)
2. Confirme o cálculo em `UtilityFunctions:CalculateXPRequired()`

---

## 📈 EXPANSÕES FUTURAS

### Ideias para implementar:

1. **Sistema de Dungeons**
   - Adicionar cooldowns
   - Recompensas especiais

2. **Sistema de Raids**
   - Multiplayer
   - Boss final

3. **Loja**
   - Comprar armas com Cash
   - Comprar relíquias com Diamantes

4. **PvP (Combate entre jogadores)**
   - Arena
   - Ranking

5. **Pets/Sombras Invocáveis**
   - Usar sombras capturadas em combate
   - Sistema de evolução

6. **Sistema de Clãs/Guildas**
   - Chat de clã
   - Guerras de clãs

---

## 📝 CHECKLIST DE INSTALAÇÃO

Antes de testar:

- [ ] Todos os ModuleScripts em `ReplicatedStorage/Modules/`
- [ ] DataManager em `ServerScriptService/Core/`
- [ ] CombatServer em `ServerScriptService/Systems/`
- [ ] CombatClient em `StarterCharacterScripts`
- [ ] PlayerUI e MenuUI em `StarterGui`
- [ ] Pelo menos 1 NPC com tag `Enemy`
- [ ] API Services ativado (para DataStore)

---

## 🎯 TESTES RECOMENDADOS

1. ✅ Atacar NPC e verificar dano
2. ✅ Matar NPC e verificar XP/Cash
3. ✅ Subir de nível
4. ✅ Abrir menu com TAB
5. ✅ Verificar estatísticas
6. ✅ Desbloquear conquista
7. ✅ Sair e entrar (testar salvamento)
8. ✅ Capturar sombra

---

## 📞 SUPORTE

Se encontrar erros:

1. Abra o **console** (F9 no Roblox Studio)
2. Procure por mensagens de erro em vermelho
3. Verifique se todos os scripts estão nos locais corretos
4. Confirme que os nomes dos arquivos estão exatos

---

## 🎉 SISTEMA PRONTO!

Seu jogo agora possui:
- ✅ Sistema de combate completo
- ✅ Progressão de personagem
- ✅ Economia funcional
- ✅ Conquistas automáticas
- ✅ Salvamento em nuvem
- ✅ Interface profissional

**Divirta-se criando seu RPG no Roblox! 🚀**

---

**Desenvolvido com ❤️ para a comunidade Roblox**
