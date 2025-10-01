# Sistema de Combate Completo para Roblox

Um sistema de combate modular e escalável para Roblox Studio com suporte a múltiplos estilos de ataque, NPCs com respawn automático, sistema de recompensas (XP e moedas), e interface gráfica moderna.

## 🎮 Características

- ✅ **Múltiplos Estilos de Combate**: Soco e Espada (facilmente expansível)
- ✅ **Sistema de Hitbox**: Detecção precisa de inimigos em área (raio configurável)
- ✅ **NPCs com IA**: Vida, sistema de morte e respawn automático
- ✅ **Sistema de Recompensas**: XP e moedas ao derrotar inimigos
- ✅ **Interface Moderna**: UI responsiva para alternar estilos e visualizar recompensas
- ✅ **Arquitetura Cliente-Servidor**: Comunicação segura via RemoteEvents
- ✅ **Sistema Anti-Spam**: Cooldowns por estilo de ataque
- ✅ **Modular e Escalável**: Fácil de expandir e customizar

## 📁 Estrutura de Arquivos

```
ReplicatedStorage/
├── CombatRemotes.lua       # RemoteEvents (AttackEvent, RewardUpdate, AttackFeedback)
└── CombatConfig.lua        # Configurações centralizadas

ServerScriptService/
└── CombatServer.lua        # Lógica do servidor (dano, drops, respawn)

StarterPlayer/StarterCharacterScripts/
└── CombatClient.lua        # Detecção de cliques e input do jogador

StarterGui/
└── CombatUI.lua            # Interface gráfica (LocalScript)
```

## 🚀 Instalação

### Passo 1: Configurar a Estrutura

1. Abra o **Roblox Studio**
2. Crie/abra seu projeto

### Passo 2: Instalar os Scripts

#### ReplicatedStorage

1. Em **ReplicatedStorage**, crie um **ModuleScript** chamado `CombatRemotes`
   - Cole o código de `ReplicatedStorage/CombatRemotes.lua`

2. Em **ReplicatedStorage**, crie um **ModuleScript** chamado `CombatConfig`
   - Cole o código de `ReplicatedStorage/CombatConfig.lua`

#### ServerScriptService

1. Em **ServerScriptService**, crie um **Script** chamado `CombatServer`
   - Cole o código de `ServerScriptService/CombatServer.lua`

#### StarterPlayer

1. Navegue até **StarterPlayer** → **StarterCharacterScripts**
2. Crie um **LocalScript** chamado `CombatClient`
   - Cole o código de `StarterPlayer/StarterCharacterScripts/CombatClient.lua`

#### StarterGui

1. Em **StarterGui**, crie um **LocalScript** chamado `CombatUI`
   - Cole o código de `StarterGui/CombatUI.lua`

### Passo 3: Configurar os NPCs

1. Crie um **Model** no workspace para seu NPC (deve ter um `Humanoid`)
2. Certifique-se de que o NPC tem:
   - `HumanoidRootPart`
   - `Humanoid`
3. Selecione o **Model** do NPC
4. No painel **Properties**, adicione uma **Tag**:
   - Vá em **Tags** (ícone de etiqueta)
   - Clique em **+**
   - Digite: `Enemy`
   - Pressione Enter

**Nota**: Você pode adicionar quantos NPCs quiser. Basta adicionar a tag `Enemy` a cada um.

### Passo 4: Testar

1. Clique em **Play** (F5) no Roblox Studio
2. Você verá:
   - Painel de estilos de combate (lado esquerdo)
   - Contador de XP e moedas (canto superior direito)
   - Instruções na parte inferior

3. **Controles**:
   - **Clique esquerdo**: Atacar
   - **Tecla 1**: Trocar para Soco
   - **Tecla 2**: Trocar para Espada

## ⚙️ Configuração

### Personalizar Estilos de Ataque

Edite `ReplicatedStorage/CombatConfig.lua`:

```lua
CombatConfig.AttackStyles = {
    Punch = {
        Name = "Soco",
        Damage = 10,        -- Dano por ataque
        Range = 5,          -- Alcance em studs
        Cooldown = 0.5,     -- Tempo entre ataques (segundos)
        Animation = nil     -- ID da animação (opcional)
    },
    Sword = {
        Name = "Espada",
        Damage = 25,
        Range = 7,
        Cooldown = 1.0,
        Animation = nil
    },
    -- Adicione mais estilos aqui!
}
```

### Personalizar NPCs

```lua
CombatConfig.NPCSettings = {
    RespawnTime = 5,        -- Tempo para respawn (segundos)
    DefaultHealth = 100,    -- Vida máxima
    XPReward = 15,          -- XP ao derrotar
    CoinsReward = 10        -- Moedas ao derrotar
}
```

### Modo Debug (Visualizar Hitbox)

```lua
CombatConfig.HitboxSettings = {
    DebugMode = true,  -- Mostra esfera vermelha ao atacar
    CheckInterval = 0.1
}
```

## 🎯 Como Funciona

### Fluxo de Ataque

1. **Cliente** (CombatClient.lua):
   - Detecta clique do mouse
   - Verifica cooldown local
   - Calcula posição do ataque
   - Envia para o servidor via `AttackEvent`

2. **Servidor** (CombatServer.lua):
   - Recebe requisição de ataque
   - Valida cooldown do servidor
   - Procura NPCs com tag "Enemy" no alcance
   - Aplica dano aos NPCs encontrados
   - Envia feedback para o cliente

3. **Recompensas**:
   - Quando NPC morre, servidor calcula recompensas
   - Envia XP e moedas via `RewardUpdate`
   - Cliente atualiza a UI

4. **Respawn**:
   - Servidor salva posição inicial do NPC
   - Após morte, aguarda tempo configurado
   - Restaura vida e posição do NPC

## 🔧 Expansão

### Adicionar Novo Estilo de Ataque

1. Em `CombatConfig.lua`, adicione ao `AttackStyles`:
```lua
Bow = {
    Name = "Arco",
    Damage = 15,
    Range = 20,
    Cooldown = 1.5,
    Animation = nil
}
```

2. A UI e o sistema de combate automaticamente reconhecerão o novo estilo!

### Adicionar Animações

1. Faça upload da animação no Roblox
2. Copie o Asset ID
3. Em `CombatConfig.lua`:
```lua
Punch = {
    Name = "Soco",
    Damage = 10,
    Range = 5,
    Cooldown = 0.5,
    Animation = 123456789  -- Seu Asset ID aqui
}
```

4. Em `CombatClient.lua`, descomente o código de animação:
```lua
local function PlayAttackAnimation()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local attackConfig = CombatConfig.AttackStyles[currentAttackStyle]
    if attackConfig.Animation then
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://" .. attackConfig.Animation
        local track = humanoid:LoadAnimation(animation)
        track:Play()
    end
end
```

### Integrar com DataStore

Para salvar progresso dos jogadores, adicione em `CombatServer.lua`:

```lua
local DataStoreService = game:GetService("DataStoreService")
local PlayerDataStore = DataStoreService:GetDataStore("PlayerCombatData")

-- Ao jogador entrar
local function LoadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        PlayerData[player.UserId] = data
    else
        InitializePlayerData(player)
    end
end

-- Ao jogador sair
local function SavePlayerData(player)
    local data = PlayerData[player.UserId]
    if data then
        pcall(function()
            PlayerDataStore:SetAsync(player.UserId, data)
        end)
    end
end
```

## 🐛 Solução de Problemas

### NPCs não tomam dano

- Verifique se o NPC tem a tag `Enemy` aplicada
- Confirme que o NPC tem `Humanoid` e `HumanoidRootPart`
- Teste com `DebugMode = true` para ver a hitbox

### UI não aparece

- Certifique-se de que `CombatUI.lua` está em **StarterGui** como **LocalScript**
- Verifique o console (F9) para erros
- Confirme que os módulos em ReplicatedStorage existem

### Cooldown não funciona

- O cooldown é aplicado tanto no cliente quanto no servidor
- Não edite valores de tempo enquanto estiver testando

### NPCs não respawnam

- Verifique se `NPCSettings.RespawnTime` está configurado
- Certifique-se de que o NPC não foi deletado do workspace
- O sistema salva a posição inicial automaticamente

## 📝 Licença

Este sistema é de código aberto e pode ser usado livremente em seus projetos Roblox.

## 🤝 Contribuições

Sinta-se livre para melhorar este sistema! Sugestões:
- Sistema de combos
- Diferentes tipos de NPCs
- Efeitos visuais e sonoros
- Sistema de níveis baseado em XP
- Loja de upgrades com moedas

## 📞 Suporte

Se encontrar problemas:
1. Verifique se todos os scripts estão nos locais corretos
2. Confirme que os nomes dos arquivos estão exatos
3. Teste em um projeto novo para isolar problemas
4. Verifique o console (F9) para mensagens de erro

---

**Desenvolvido com ❤️ para a comunidade Roblox**
