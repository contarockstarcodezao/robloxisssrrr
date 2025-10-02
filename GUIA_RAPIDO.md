# ⚡ GUIA RÁPIDO - Sistema DataManager

## 🎯 INSTALAÇÃO EM 5 MINUTOS

### 1️⃣ ReplicatedStorage/Modules
Crie **Folder** `Modules`, adicione 4 **ModuleScripts**:
- ✅ GameConfig
- ✅ UtilityFunctions
- ✅ RelicData
- ✅ RemoteEvents

### 2️⃣ ServerScriptService
Crie **Folder** `Core`, adicione **Script**:
- ✅ DataManager

Crie **Folder** `Systems`, adicione **Script**:
- ✅ CombatServer

### 3️⃣ StarterCharacterScripts
Adicione **LocalScript**:
- ✅ CombatClient

### 4️⃣ StarterGui
Adicione 2 **LocalScripts**:
- ✅ PlayerUI
- ✅ MenuUI

### 5️⃣ Configurar NPCs
- Crie Model com Humanoid + HumanoidRootPart
- Adicione tag `Enemy`
- (Opcional) Adicione tag `Boss` para chefes

---

## 🎮 CONTROLES

| Tecla | Ação |
|-------|------|
| **Clique Esquerdo** | Atacar |
| **1** | Soco |
| **2** | Espada |
| **TAB** | Menu |

---

## 📊 O QUE O SISTEMA FAZ

### ✅ Automático
- Salva dados a cada 5 minutos
- Rastreia tempo de jogo
- Verifica conquistas automaticamente
- Calcula XP e level up
- Aplica bônus de relíquias
- Respawna NPCs

### 📋 Interface Mostra
- Level e barra de XP
- Cash e Diamantes
- Tempo jogado
- Estilo de combate atual

### 📱 Menu (TAB) Mostra
- **Estatísticas**: Kills, dano, mortes, etc
- **Conquistas**: Progresso e recompensas
- **Inventário**: Itens (em desenvolvimento)
- **Sombras**: Capturas (15% de chance)

---

## ⚙️ CONFIGURAÇÃO RÁPIDA

### Editar Dano
`GameConfig.lua` → `AttackStyles` → `Damage`

### Editar XP Necessário
`GameConfig.lua` → `Experience` → `BaseXPRequired` e `XPScaling`

### Editar Cash Inicial
`GameConfig.lua` → `Economy` → `StartingCash`

### Adicionar Conquista
`GameConfig.lua` → `Achievements` → Adicione novo objeto

### Tempo de Auto-Save
`GameConfig.lua` → `Time` → `AutoSaveInterval` (em segundos)

---

## 🧿 SISTEMA DE BÔNUS

### Relíquias (até 3 equipadas)
- **XPBoost**: +% XP ganho
- **CashBoost**: +% Cash ganho
- **DamageBoost**: +% Dano
- **HealthBoost**: +HP máximo
- **ShadowCaptureBoost**: +% Chance de captura

### Bônus de Level
- Cada level = +0.5% de dano

---

## 🏆 CONQUISTAS PRÉ-CONFIGURADAS

1. **Primeira Vítima** - 1 kill
2. **Guerreiro** - 50 kills
3. **Lenda** - 500 kills
4. **Caçador de Chefes** - 10 boss kills
5. **Mestre das Sombras** - 20 sombras
6. **Ascensão I** - Level 10
7. **Ascensão II** - Level 50
8. **Veterano** - 10 horas jogadas

---

## 💾 DADOS SALVOS

✅ Level, XP  
✅ Cash, Diamantes, Fragmentos  
✅ Arma equipada  
✅ Sombras capturadas  
✅ Inventário  
✅ Relíquias equipadas  
✅ Estatísticas (kills, dano, etc)  
✅ Conquistas  
✅ Tempo de jogo  
✅ Cooldowns  

---

## 🐛 PROBLEMAS COMUNS

### ❌ "GameConfig não encontrado"
→ Verifique se está em `ReplicatedStorage/Modules/`

### ❌ NPCs não tomam dano
→ Adicione tag `Enemy` no Model do NPC

### ❌ Dados não salvam
→ Ative API Services: Home → Game Settings → Security → Enable Studio Access to API Services

### ❌ UI não aparece
→ Aguarde 2-3 segundos após entrar no jogo

---

## 📈 PRÓXIMOS PASSOS

1. Criar mais NPCs com diferentes níveis
2. Adicionar bosses (tag `Boss`)
3. Criar mais conquistas
4. Adicionar relíquias
5. Implementar sistema de dungeons
6. Criar loja de itens

---

## 🔧 MODO DEBUG

Ativar visualização de hitbox:

```lua
-- Em GameConfig.lua
HitboxSettings = {
    DebugMode = true,  -- ← Mude para true
}
```

Uma esfera vermelha aparecerá ao atacar!

---

## 📞 VERIFICAR SE FUNCIONA

Ao entrar no jogo, procure no console (F9):

```
✅ DataManager inicializado
✅ Sistema de Combate (Servidor) inicializado!
✅ Sistema de Combate (Cliente) inicializado!
✅ UI do Jogador inicializada!
✅ Menu UI inicializado!
```

Se ver todas essas mensagens = **SUCESSO!** 🎉

---

## 🎯 TESTE RÁPIDO

1. Entre no jogo
2. Veja a UI aparecer (canto superior esquerdo)
3. Clique em um NPC para atacar
4. Veja XP e Cash aumentarem
5. Pressione TAB para abrir menu
6. Verifique suas estatísticas

---

**Sistema pronto para uso! 🚀**

Leia `INSTALACAO_COMPLETA.md` para detalhes avançados.
