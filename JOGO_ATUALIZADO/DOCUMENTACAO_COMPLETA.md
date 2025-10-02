# 📚 Documentação Completa - Shadow Hunter

## 🎯 Visão Geral

Shadow Hunter é um jogo completo para Roblox inspirado em Solo Leveling onde você derrota NPCs, captura suas sombras e progride através de 10 ranks.

---

## 🎮 Sistemas Implementados

### 1. **Sistema de Combate**
- Clique ou Espaço para atacar
- Cooldown de 1 segundo
- Cálculo de dano: Base (20) + Level Bonus (5% por level)
- Range de ataque: 10 studs

### 2. **Sistema de NPCs**
**10 NPCs Únicos:**
1. **Goblin Fraco** (Rank F) - 100 HP, 5 Dano
2. **Slime** (Rank F) - 80 HP, 3 Dano
3. **Goblin Guerreiro** (Rank E) - 250 HP, 12 Dano
4. **Escorpião do Deserto** (Rank D) - 600 HP, 30 Dano
5. **Guerreiro Orc** (Rank C) - 1,200 HP, 60 Dano
6. **Yeti Congelado** (Rank B) - 2,500 HP, 120 Dano
7. **Dragão Menor** (Rank A) - 5,000 HP, 250 Dano
8. **Goku** (Rank S) - 12,000 HP, 500 Dano ⭐
9. **Vegeta** (Rank SS) - 22,000 HP, 800 Dano ⭐
10. **Sung Jin-Woo** (Rank GM) - 100,000 HP, 3,000 Dano ⭐

### 3. **Sistema de Sombras**
- **Captura:** 3 tentativas (40%, 30%, 20% de chance)
- **Ranks:** Chance de dropar mesmo rank do NPC:
  - Rank F: 70%
  - Rank S: 90%
  - Rank GM: 98%
- **Equipamento:** Até 3 sombras simultâneas
- **Destruição:** Ganhe diamantes baseado no rank

### 4. **Sistema de Ranks**
**10 Ranks de Progressão:**
- **F** (Level 1) - Marrom - 1.0x multiplier
- **E** (Level 10) - Cinza - 1.2x multiplier
- **D** (Level 20) - Verde - 1.5x multiplier
- **C** (Level 35) - Azul - 2.0x multiplier
- **B** (Level 50) - Roxo - 2.5x multiplier
- **A** (Level 70) - Laranja - 3.0x multiplier
- **S** (Level 90) - Dourado - 4.0x multiplier
- **SS** (Level 110) - Amarelo - 5.5x multiplier
- **SSS** (Level 140) - Magenta - 7.5x multiplier
- **GM** (Level 180) - Vermelho - 10.0x multiplier

### 5. **Sistema de Progressão**
- **XP Necessário:** 100 × (Level ^ 1.5)
- **Level Up Automático:** Ao atingir XP necessário
- **Rank Up:** Baseado no level alcançado
- **Recompensas por NPC:**
  - Goblin Fraco: 10 XP, 10-30 Cash
  - Goku: 1,200 XP, 2,000-3,000 Cash
  - Sung Jin-Woo: 10,000 XP, 15,000-25,000 Cash

### 6. **DataManager**
- **Save/Load Automático:** DataStore do Roblox
- **Auto-save:** A cada 5 minutos
- **Dados Salvos:**
  - Level, XP, Rank
  - Cash e Diamantes
  - Sombras capturadas
  - Sombras equipadas
  - Estatísticas (NPCs mortos, dano causado)

---

## 🎯 Controles

| Ação | Tecla |
|------|-------|
| Atacar NPC | Clique do Mouse ou Espaço |
| Capturar Sombra | **E** (próximo ao prompt) |
| Destruir Sombra | **F** (próximo ao prompt) |

---

## 📊 Estrutura de Dados

### PlayerData:
```lua
{
    Level = 1,
    XP = 0,
    Rank = "F",
    Cash = 100,
    Diamonds = 10,
    Stats = {
        PlayerSpeed = 0,
        PlayerDamage = 0,
        PlayerHealth = 0,
        PlayerDefense = 0,
        ShadowSpeed = 0,
        ShadowDamage = 0,
        ShadowRange = 0
    },
    Shadows = {}, -- Sombras capturadas
    EquippedShadows = {}, -- IDs das equipadas (max 3)
    Statistics = {
        NPCsKilled = 0,
        ShadowsCaptured = 0,
        ShadowsDestroyed = 0,
        DamageDealt = 0
    }
}
```

---

## 🔧 Como Personalizar

### Adicionar Mais NPCs ao Spawn

Edite o final do `COMANDO_INSTALACAO.lua`:
```lua
-- Adicione aqui:
NPCManager:SpawnNPC("Slime", Vector3.new(20, 5, 20), "BeginnerZone")
NPCManager:SpawnNPC("Goku", Vector3.new(0, 5, 50), "EliteZone")
```

### Modificar Stats de NPCs

No arquivo, procure por `NPCData.NPCs` e edite:
```lua
{
    Name = "Goblin Fraco",
    Health = 100,    -- Modifique aqui
    Damage = 5,      -- Modifique aqui
    XPReward = 10,   -- Modifique aqui
    -- ...
}
```

### Mudar Chances de Captura

Procure por `CalculateCaptureSuccess`:
```lua
local chances = {0.40, 0.30, 0.20}  -- Modifique aqui
-- Tentativa 1: 40%
-- Tentativa 2: 30%
-- Tentativa 3: 20%
```

---

## 🐛 Troubleshooting

### NPCs não aparecem
- Verifique pasta "NPCs" no Workspace
- Devem ter 5 modelos verdes (Goblin Fraco)

### Clicar não ataca
- Aproxime-se MUITO do NPC (< 10 studs)
- Clique diretamente no NPC
- Verifique Output para erros

### Dados não salvam
- Habilite API Services:
  - Game Settings → Security → Enable Studio Access to API Services

### Prompt de captura não aparece
- Aguarde NPC morrer completamente
- Prompt aparece no chão (parte roxa)
- Dura 30 segundos

---

## 📈 Progressão Sugerida

1. **Levels 1-10:** Mate Goblins Fracos e Slimes
2. **Levels 10-20:** Goblin Guerreiro
3. **Levels 20-35:** Escorpião do Deserto
4. **Levels 35-50:** Guerreiro Orc
5. **Levels 50-70:** Yeti Congelado
6. **Levels 70-90:** Dragão Menor
7. **Levels 90-110:** Goku
8. **Levels 110-140:** Vegeta
9. **Levels 140+:** Sung Jin-Woo

---

## 🎨 Funcionalidades Extras (Expansíveis)

O código está preparado para adicionar:
- Sistema de Zonas (5 zonas prontas)
- Sistema de Missões
- Sistema de Guilds
- PvP Arena
- Boss Raids
- Sistema de Pets
- Daily Rewards

---

## 📞 Arquivos Criados

Após executar o comando, você terá:

### ReplicatedStorage:
- `Modules/RankData`
- `Modules/NPCData`
- `Modules/ShadowData`
- `Events/RemoteEvents`
- `RemoteEvents/` (11 eventos)
- `RemoteFunctions/` (4 funções)

### ServerScriptService:
- `MainServer` ⭐ (Script principal)
- `Core/DataManager`
- `Combat/NPCManager`
- `Combat/CombatSystem`

### Workspace:
- `Zones/` (pasta criada)
- `NPCs/` (pasta criada)
- 5 Goblin Fraco (spawnados)

---

## ✅ Checklist de Funcionamento

- [ ] Jogo inicia sem erros
- [ ] Output mostra "✅ SHADOW HUNTER INICIALIZADO!"
- [ ] 5 Goblins aparecem no Workspace
- [ ] Clicar ataca o Goblin
- [ ] Goblin morre e dropa prompt
- [ ] Pressionar E tenta capturar
- [ ] Sair e entrar mantém Level e XP

---

## 🎉 Pronto!

Agora você tem um jogo completo e funcional!

**Divirta-se criando e expandindo!** 🎮✨
