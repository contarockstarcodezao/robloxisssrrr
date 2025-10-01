# 📚 Arise Crossover - Visão Geral dos Sistemas

## 🎮 Sistemas Implementados

### 1. 🧞‍♂️ Sistema de Sombras

**Arquivos:**
- `ShadowData.lua` - 18 sombras únicas de rank F até GM
- `ShadowSystem.lua` - Lógica de captura, invocação e evolução

**Recursos:**
- ✅ 9 Ranks: F, E, D, C, B, A, S, SS, GM
- ✅ Chance de captura baseada em raridade
- ✅ 18 sombras pré-configuradas com stats e habilidades únicas
- ✅ Sistema de invocação com IA de combate
- ✅ Evolução com custo crescente (cash, diamantes, fragmentos)
- ✅ Stats multiplicam a cada evolução (1.5x)
- ✅ Limite de slots expansível
- ✅ Habilidades passivas e ativas

**Como usar:**
```lua
-- Servidor (automático ao matar NPC)
ShadowSystem:TryCaptureShadow(player, npcRank)

-- Cliente
ShadowController:InvokeShadow(shadowID)
ShadowController:EvolveShadow(shadowID)
```

---

### 2. ⚔️ Sistema de Combate

**Arquivos:**
- `WeaponData.lua` - 13 armas com raridades e efeitos especiais
- `CombatSystem.lua` - Lógica de ataque e dano

**Recursos:**
- ✅ 2 estilos: Soco e Espada
- ✅ Sistema de crítico
- ✅ Detecção automática de inimigos
- ✅ Cooldown configurável
- ✅ Sistema de upgrade de armas (10 níveis)
- ✅ Efeitos especiais: roubo de vida, dano em área, queimadura, congelamento
- ✅ Animações de ataque

**Raridades de Armas:**
- Common (1x)
- Rare (1.5x)
- Epic (2x)
- Legendary (3x)
- Mythic (5x)

**Como usar:**
```lua
-- Cliente
CombatController:Attack(targetPosition) -- Clique do mouse

-- Servidor
CombatSystem:EquipWeapon(player, weaponID)
CombatSystem:UpgradeWeapon(player, weaponID)
```

---

### 3. 💰 Sistema de Drops e Economia

**Arquivos:**
- `DropSystem.lua` - Gerenciamento de drops e recompensas

**Recursos:**
- ✅ Cash (sempre dropa)
- ✅ Fragmentos (40% chance)
- ✅ Poções (15% chance)
- ✅ Armas (10% chance)
- ✅ Sombras (25% chance)
- ✅ Relíquias (5% chance)
- ✅ Drops visuais com cores por raridade
- ✅ Bônus de drop rate via relíquias
- ✅ Valores escalam com rank do NPC

**Valores de Cash por Rank:**
- F: 10-25
- E: 25-50
- D: 50-100
- C: 100-200
- B: 200-400
- A: 400-800
- S: 800-1600
- SS: 1600-3200
- GM: 5000-10000

---

### 4. 📈 Sistema de XP e Níveis

**Arquivos:**
- `XPSystem.lua` - Gerenciamento de experiência

**Recursos:**
- ✅ Level up com scaling exponencial
- ✅ XP por kill baseado em rank
- ✅ Bônus de stats automáticos
- ✅ Efeitos visuais de level up
- ✅ Máximo: Level 1000
- ✅ Bônus de XP via relíquias

**XP por Rank:**
- F: 10 XP
- E: 20 XP
- D: 40 XP
- C: 80 XP
- B: 160 XP
- A: 320 XP
- S: 640 XP
- SS: 1280 XP
- GM: 5000 XP

**Bônus por Level:**
- +10 HP
- +2 Dano
- +0.1 Velocidade

---

### 5. 🧭 Dungeons e Raids

**Arquivos:**
- `DungeonSystem.lua` - Instâncias, matchmaking, recompensas

**Dungeons:**
- ✅ Instâncias solo ou grupo (1-4 players)
- ✅ 5-10 inimigos por dungeon
- ✅ Cooldown: 5 minutos
- ✅ Duração máxima: 10 minutos
- ✅ Recompensas: Cash, Diamantes, Fragmentos

**Raids:**
- ✅ Multiplayer obrigatório (4-10 players)
- ✅ Boss com 50,000 HP
- ✅ Cooldown: 1 hora
- ✅ Duração máxima: 30 minutos
- ✅ Recompensas épicas: Sombras raras garantidas
- ✅ Level mínimo: 20

---

### 6. 🧪 Sistema de Ranking

**Arquivos:**
- `RankingSystem.lua` - Leaderboards global e semanal

**Recursos:**
- ✅ Ranking Global (permanente)
- ✅ Ranking Semanal (reseta segunda-feira)
- ✅ Top 100 jogadores
- ✅ Cálculo de poder: Level × 10 + ShadowPower + RaidWins × 50
- ✅ Atualização automática a cada 1 minuto
- ✅ DataStore persistente

---

### 7. 🎒 Sistema de Inventário

**Recursos:**
- ✅ 4 categorias: Armas, Sombras, Relíquias, Consumíveis
- ✅ Slots iniciais: 20 armas, 50 sombras, 30 relíquias, 100 consumíveis
- ✅ Expansão: 50 diamantes por slot
- ✅ Máximo: 200 slots por categoria
- ✅ Sistema de filtragem e ordenação

---

### 8. 🧿 Sistema de Relíquias

**Arquivos:**
- `RelicData.lua` - 20 relíquias com bônus únicos

**Recursos:**
- ✅ 20 relíquias de Common a Mythic
- ✅ Máximo 3 equipadas por vez
- ✅ Bônus: Dano, Vida, Velocidade, Captura, Drop, XP, Poder de Sombras
- ✅ Sistema de fusão (2 iguais = 1 melhorada)
- ✅ Níveis infinitos (cada fusão aumenta 10%)

**Tipos de Bônus:**
- Damage: +5% a +100%
- Health: +8% a +100%
- Speed: +10% a +80%
- CaptureRate: +15% a +80%
- DropRate: +20% a +100%
- XPBoost: +25% a +100%
- ShadowPower: +50% a +100%

---

### 9. 👾 Sistema de NPCs

**Arquivos:**
- `NPCManager.lua` - Spawn, IA, gerenciamento

**Recursos:**
- ✅ Spawn automático por rank
- ✅ IA básica: perseguir e atacar jogadores
- ✅ Vida escala com rank (100 a 50,000 HP)
- ✅ Respawn automático após morte
- ✅ Spawn de NPCs raros a cada 5 minutos
- ✅ Billboard com nome e rank
- ✅ Cores por rank

**Spawns Iniciais:**
- 10x Rank F
- 8x Rank E
- 5x Rank D
- 3x Rank C
- 2x Rank B

**Spawns Periódicos:**
- 30% chance de Rank A a cada 5 min
- 10% chance de Rank S a cada 5 min

---

### 10. 💾 Sistema de DataStore

**Arquivos:**
- `DataManager.lua` - Salvamento e carregamento de dados

**Recursos:**
- ✅ Auto-save a cada 5 minutos
- ✅ Save ao sair do jogo
- ✅ Save ao fechar servidor
- ✅ Dados padrão para novos jogadores
- ✅ Mesclagem de dados (para atualizações)
- ✅ Tratamento de erros

**Dados Salvos:**
- Level, XP
- Cash, Diamantes, Fragmentos
- Sombras capturadas
- Inventário completo
- Estatísticas
- Cooldowns
- Conquistas

---

## 🎯 Fluxo de Jogo

### 1. Início
```
Jogador entra → Dados carregados → Spawn no mundo
```

### 2. Combate
```
Ver NPC → Clicar para atacar → NPC morre → Recebe drops
```

### 3. Captura de Sombra
```
Matar NPC → Chance de captura → Sombra adicionada ao inventário
```

### 4. Progressão
```
Ganhar XP → Level up → Stats aumentam → Desbloquear áreas
```

### 5. Economia
```
Farmar cash → Melhorar armas → Evoluir sombras → Comprar relíquias
```

### 6. End-game
```
Raids → Sombras raras → Top ranking → Conquistas
```

---

## ⚙️ Configurações Principais

Todas em `GameConfig.lua`:

### Ajustar Dificuldade:
```lua
GameConfig.Shadows.CaptureChances -- Chance de captura
GameConfig.Drops.DropChances -- Taxa de drops
GameConfig.Experience.XPRewards -- XP por kill
```

### Ajustar Economia:
```lua
GameConfig.Economy.StartingCash -- Cash inicial
GameConfig.Shadows.EvolutionCosts -- Custo de evolução
GameConfig.WeaponSystem.UpgradeCosts -- Custo de upgrade
```

### Ajustar Combate:
```lua
GameConfig.Combat.AttackCooldown -- Velocidade de ataque
GameConfig.Combat.DetectionRange -- Alcance de detecção
```

---

## 🔧 Expansibilidade

### Adicionar Nova Sombra:
1. Abra `ShadowData.lua`
2. Adicione novo objeto ao array `Templates`
3. Configure ID, Nome, Rank, Stats, Habilidades

### Adicionar Nova Arma:
1. Abra `WeaponData.lua`
2. Adicione ao array `Templates`
3. Configure stats e efeitos especiais

### Adicionar Nova Relíquia:
1. Abra `RelicData.lua`
2. Adicione ao array `Templates`
3. Configure bônus e raridade

### Adicionar Novo Dungeon:
1. Crie área no Workspace
2. Adicione lógica em `DungeonSystem.lua`
3. Configure inimigos e recompensas

---

## 📊 Performance

### Otimizações Implementadas:
- ✅ DataStore com cache local
- ✅ Auto-save assíncrono
- ✅ Destruição automática de drops antigos
- ✅ Limite de NPCs simultâneos
- ✅ Debounce em todos os eventos
- ✅ Validação server-side de todas ações

### Capacidade:
- Suporta até 50 jogadores simultâneos
- ~100-150 NPCs ativos
- Salvamento eficiente (<1 segundo)

---

## 🎨 Customização Fácil

### Cores:
```lua
GameConfig.Colors.Ranks -- Cores por rank
GameConfig.Colors.Rarities -- Cores por raridade
```

### Textos:
Todos os textos estão em português e podem ser facilmente traduzidos.

### UI:
Todas as interfaces estão em `StarterGui/GameUI` e podem ser editadas visualmente.

---

## 🔐 Segurança

### Medidas Implementadas:
- ✅ Todas as ações validadas no servidor
- ✅ Cooldowns server-side
- ✅ Verificação de recursos antes de compras
- ✅ Validação de inventário
- ✅ Anti-exploit em combate

---

## 📈 Próximas Features Sugeridas

1. **Sistema de Clãs/Guildas**
2. **PvP Arena**
3. **Boss World Events**
4. **Sistema de Quests**
5. **Sistema de Pets**
6. **Loja de Cosméticos**
7. **Sistema de Trading**
8. **Daily Rewards**
9. **Achievement System**
10. **VIP/Game Pass System**

---

**Documentação completa e pronta para uso! 🎮✨**
