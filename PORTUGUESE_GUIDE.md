# 🎮 Guia Rápido de Instalação - Sistema de Combate Roblox

## 📋 Lista de Verificação Rápida

- [ ] Todos os scripts criados
- [ ] NPCs configurados com tag "Enemy"
- [ ] Testado no Roblox Studio

## 🎯 Instalação em 5 Passos

### 1️⃣ ReplicatedStorage

Crie 2 **ModuleScripts**:

**CombatRemotes** → Cole o código de `ReplicatedStorage/CombatRemotes.lua`
**CombatConfig** → Cole o código de `ReplicatedStorage/CombatConfig.lua`

### 2️⃣ ServerScriptService

Crie 1 **Script**:

**CombatServer** → Cole o código de `ServerScriptService/CombatServer.lua`

### 3️⃣ StarterPlayer

Navegue até **StarterPlayer** → **StarterCharacterScripts**

Crie 1 **LocalScript**:

**CombatClient** → Cole o código de `StarterPlayer/StarterCharacterScripts/CombatClient.lua`

### 4️⃣ StarterGui

Crie 1 **LocalScript**:

**CombatUI** → Cole o código de `StarterGui/CombatUI.lua`

### 5️⃣ Configurar NPCs

Para cada NPC inimigo:

1. Crie um **Model** no Workspace
2. Adicione um **Humanoid**
3. Adicione um **HumanoidRootPart**
4. Selecione o Model
5. No painel Properties → **Tags** → Adicione a tag `Enemy`

## 🎮 Controles do Jogo

| Ação | Controle |
|------|----------|
| Atacar | Clique Esquerdo do Mouse |
| Trocar para Soco | Tecla **1** |
| Trocar para Espada | Tecla **2** |

## ⚙️ Configurações Rápidas

Edite `CombatConfig.lua` para ajustar:

### Dano e Alcance

```lua
Punch = {
    Damage = 10,     -- ← Mude aqui o dano do soco
    Range = 5,       -- ← Mude aqui o alcance em studs
}

Sword = {
    Damage = 25,     -- ← Mude aqui o dano da espada
    Range = 7,       -- ← Mude aqui o alcance em studs
}
```

### Recompensas

```lua
NPCSettings = {
    XPReward = 15,      -- ← XP ao derrotar NPC
    CoinsReward = 10,   -- ← Moedas ao derrotar NPC
    RespawnTime = 5,    -- ← Tempo de respawn (segundos)
}
```

## 🔍 Modo Debug

Para ver a hitbox visual ao atacar:

```lua
HitboxSettings = {
    DebugMode = true,  -- ← Mude para true
}
```

Uma esfera vermelha aparecerá mostrando a área de ataque!

## ❗ Problemas Comuns

### ❌ NPCs não tomam dano

**Solução**: Verifique se adicionou a tag `Enemy` no Model do NPC

### ❌ UI não aparece

**Solução**: Confirme que `CombatUI.lua` está em **StarterGui** como **LocalScript**

### ❌ Erro "CombatConfig não encontrado"

**Solução**: Verifique se os ModuleScripts estão em **ReplicatedStorage**

### ❌ NPCs não respawnam

**Solução**: Certifique-se de que o NPC tem `HumanoidRootPart` e não foi deletado manualmente

## 🚀 Dicas de Expansão

### Adicionar Novo Estilo (ex: Arco)

Em `CombatConfig.lua`, adicione:

```lua
AttackStyles = {
    Punch = { ... },
    Sword = { ... },
    Bow = {
        Name = "Arco",
        Damage = 15,
        Range = 20,
        Cooldown = 1.5,
        Animation = nil
    }
}
```

A UI automaticamente mostrará o novo botão!

### Adicionar Som de Ataque

Em `CombatClient.lua`, função `PlayAttackAnimation()`, adicione:

```lua
local hitSound = Instance.new("Sound")
hitSound.SoundId = "rbxassetid://SEU_ID_AQUI"
hitSound.Parent = humanoidRootPart
hitSound:Play()
game:GetService("Debris"):AddItem(hitSound, 2)
```

## 📊 Estrutura Visual

```
📁 ReplicatedStorage
  📄 CombatRemotes (ModuleScript)
  📄 CombatConfig (ModuleScript)

📁 ServerScriptService
  📄 CombatServer (Script)

📁 StarterPlayer
  📁 StarterCharacterScripts
    📄 CombatClient (LocalScript)

📁 StarterGui
  📄 CombatUI (LocalScript)

📁 Workspace
  📦 NPC_Model (com tag "Enemy")
    👤 Humanoid
    🎯 HumanoidRootPart
    🦵 Body Parts...
```

## ✅ Checklist Final

Antes de publicar seu jogo:

- [ ] Desative `DebugMode` em `CombatConfig.lua`
- [ ] Ajuste valores de dano e recompensas
- [ ] Adicione animações personalizadas
- [ ] Teste com múltiplos jogadores
- [ ] Configure DataStore para salvar progresso
- [ ] Adicione sons e efeitos visuais

## 🎨 Personalização da UI

As cores da UI podem ser alteradas em `CombatUI.lua`:

```lua
-- Fundo dos painéis
BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Cor do botão selecionado
BackgroundColor3 = Color3.fromRGB(80, 200, 120)

-- Cor do texto de XP
TextColor3 = Color3.fromRGB(255, 215, 0)

-- Cor do texto de Moedas
TextColor3 = Color3.fromRGB(100, 255, 100)
```

## 📈 Próximos Passos

1. **Sistema de Níveis**: Use o XP para criar níveis
2. **Loja**: Use moedas para comprar upgrades
3. **Boss NPCs**: Crie NPCs especiais com mais vida
4. **Combos**: Adicione sistema de ataques sequenciais
5. **Equipamentos**: Permita equipar diferentes armas

---

**Bom desenvolvimento! 🚀**

Se precisar de ajuda, revise o `README.md` completo para mais detalhes técnicos.
