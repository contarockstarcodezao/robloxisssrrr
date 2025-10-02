# 🧪 Arise Crossover - Comandos de Teste e Debug

## ⚠️ IMPORTANTE
Estes comandos são apenas para teste no Studio. NÃO use em produção sem sistema de admin adequado!

---

## 🎮 Como Usar os Comandos

### Método 1: Command Bar (Studio)
1. Abra o **Command Bar** (View > Command Bar)
2. Cole o comando
3. Pressione Enter

### Método 2: Script Temporário
1. Insira um Script em ServerScriptService
2. Cole o comando dentro
3. Execute e delete o script

---

## 💰 Comandos de Recursos

### Dar Cash
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddResource(player, "Cash", 100000)
    print("✅ 100,000 Cash adicionado!")
end
```

### Dar Diamantes
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddResource(player, "Diamonds", 1000)
    print("✅ 1,000 Diamantes adicionados!")
end
```

### Dar Fragmentos
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddResource(player, "Fragments", 5000)
    print("✅ 5,000 Fragmentos adicionados!")
end
```

### Dar Tudo (Recursos)
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddResource(player, "Cash", 1000000)
    DataManager:AddResource(player, "Diamonds", 10000)
    DataManager:AddResource(player, "Fragments", 50000)
    print("✅ Todos recursos adicionados!")
end
```

---

## 📈 Comandos de Progressão

### Dar XP
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddXP(player, 10000)
    print("✅ 10,000 XP adicionado!")
end
```

### Setar Nível Específico
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    if data then
        data.Level = 100  -- Mude para o nível desejado
        data.XP = 0
        print("✅ Level setado para 100!")
    end
end
```

### Level MAX
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    if data then
        data.Level = 1000
        data.XP = 0
        print("✅ Level MAX!")
    end
end
```

---

## 🧞‍♂️ Comandos de Sombras

### Dar Sombra Específica (por ID)
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local ShadowData = require(game.ReplicatedStorage.Modules.ShadowData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local shadow = ShadowData:CreateShadowInstance("SHADOW_017", 0) -- Imperador das Sombras (GM)
    DataManager:AddShadow(player, shadow)
    print("✅ Sombra adicionada!")
end
```

### Dar Todas as Sombras
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local ShadowData = require(game.ReplicatedStorage.Modules.ShadowData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    for _, template in ipairs(ShadowData.Templates) do
        local shadow = ShadowData:CreateShadowInstance(template.ID, 0)
        DataManager:AddShadow(player, shadow)
    end
    print("✅ Todas as sombras adicionadas!")
end
```

### Dar Sombra GM Aleatória
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local ShadowData = require(game.ReplicatedStorage.Modules.ShadowData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local gmShadow = ShadowData:GetRandomShadowByRank("GM")
    if gmShadow then
        local shadow = ShadowData:CreateShadowInstance(gmShadow.ID, 0)
        DataManager:AddShadow(player, shadow)
        print("✅ Sombra GM adicionada:", gmShadow.Name)
    end
end
```

### Evoluir Sombra ao Máximo
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    if data and #data.Shadows > 0 then
        data.Shadows[1].EvolutionLevel = 10  -- Mude o índice [1] para outra sombra
        print("✅ Primeira sombra evoluída ao máximo!")
    end
end
```

---

## ⚔️ Comandos de Armas

### Dar Arma Específica
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local WeaponData = require(game.ReplicatedStorage.Modules.WeaponData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local weapon = WeaponData:CreateWeaponInstance("WEAPON_013", 0) -- Espada do Fim dos Tempos
    DataManager:AddItem(player, "Weapons", weapon)
    print("✅ Arma mítica adicionada!")
end
```

### Dar Todas as Armas
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local WeaponData = require(game.ReplicatedStorage.Modules.WeaponData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    for _, template in ipairs(WeaponData.Templates) do
        local weapon = WeaponData:CreateWeaponInstance(template.ID, 0)
        DataManager:AddItem(player, "Weapons", weapon)
    end
    print("✅ Todas as armas adicionadas!")
end
```

### Dar Arma MAX Level
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local WeaponData = require(game.ReplicatedStorage.Modules.WeaponData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local weapon = WeaponData:CreateWeaponInstance("WEAPON_013", 10) -- Level 10
    DataManager:AddItem(player, "Weapons", weapon)
    print("✅ Arma MAX level adicionada!")
end
```

---

## 🧿 Comandos de Relíquias

### Dar Relíquia Mítica
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local RelicData = require(game.ReplicatedStorage.Modules.RelicData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local relic = RelicData:CreateRelicInstance("RELIC_020", 1) -- Fragmento da Criação
    DataManager:AddItem(player, "Relics", relic)
    print("✅ Relíquia mítica adicionada!")
end
```

### Dar Todas as Relíquias
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local RelicData = require(game.ReplicatedStorage.Modules.RelicData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    for _, template in ipairs(RelicData.Templates) do
        local relic = RelicData:CreateRelicInstance(template.ID, 1)
        DataManager:AddItem(player, "Relics", relic)
    end
    print("✅ Todas as relíquias adicionadas!")
end
```

### Dar Relíquia Level Alto
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local RelicData = require(game.ReplicatedStorage.Modules.RelicData)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local relic = RelicData:CreateRelicInstance("RELIC_020", 50) -- Level 50
    DataManager:AddItem(player, "Relics", relic)
    print("✅ Relíquia level 50 adicionada!")
end
```

---

## 👾 Comandos de NPCs

### Spawnar NPC de Rank Específico
```lua
local NPCManager = require(game.ServerScriptService.Systems.NPCManager)
NPCManager:SpawnNPCsInArea("GM", 1)
print("✅ NPC GM spawnado!")
```

### Spawnar Muitos NPCs (Teste de Performance)
```lua
local NPCManager = require(game.ServerScriptService.Systems.NPCManager)
for i = 1, 20 do
    NPCManager:SpawnNPCsInArea("F", 1)
end
print("✅ 20 NPCs spawnados!")
```

### Limpar Todos NPCs
```lua
for _, npc in ipairs(workspace:GetChildren()) do
    if npc:GetAttribute("IsNPC") then
        npc:Destroy()
    end
end
print("✅ Todos NPCs removidos!")
```

---

## 🧭 Comandos de Dungeons/Raids

### Resetar Cooldown de Dungeon
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    if data then
        data.DungeonCooldowns = {}
        print("✅ Cooldowns de dungeon resetados!")
    end
end
```

### Resetar Cooldown de Raid
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    if data then
        data.RaidCooldowns = {}
        print("✅ Cooldowns de raid resetados!")
    end
end
```

---

## 🏆 Comandos de Ranking

### Adicionar ao Ranking
```lua
local RankingSystem = require(game.ServerScriptService.Systems.RankingSystem)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    RankingSystem:UpdateGlobalRanking(player)
    RankingSystem:UpdateWeeklyRanking(player)
    print("✅ Adicionado ao ranking!")
end
```

### Ver Ranking no Output
```lua
local RankingSystem = require(game.ServerScriptService.Systems.RankingSystem)
print("=== RANKING GLOBAL ===")
for i, entry in ipairs(RankingSystem.GlobalRanking) do
    print(i, entry.Name, "Poder:", entry.Power)
end
```

---

## 💾 Comandos de DataStore

### Salvar Dados Manualmente
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:SavePlayerData(player)
    print("✅ Dados salvos!")
end
```

### Ver Dados do Jogador
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    print("=== DADOS DO JOGADOR ===")
    print("Level:", data.Level)
    print("Cash:", data.Cash)
    print("Diamonds:", data.Diamonds)
    print("Sombras:", #data.Shadows)
    print("Armas:", #data.Inventory.Weapons)
end
```

### Resetar Dados do Jogador
```lua
-- ⚠️ CUIDADO: Isso APAGA todos os dados!
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    -- Recarregar dados padrão
    player:Kick("Dados resetados. Entre novamente.")
    -- OU deletar do DataStore (precisa de função adicional)
end
```

---

## 🎯 Comandos Úteis de Debug

### Teleportar para Origem
```lua
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player and player.Character then
    player.Character:SetPrimaryPartCFrame(CFrame.new(0, 50, 0))
    print("✅ Teleportado!")
end
```

### God Mode (Invencibilidade)
```lua
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player and player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        print("✅ God Mode ativado!")
    end
end
```

### Super Velocidade
```lua
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player and player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 100
        print("✅ Super velocidade ativada!")
    end
end
```

### Restaurar Stats Normais
```lua
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player and player.Character then
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        humanoid.WalkSpeed = 16
        print("✅ Stats restaurados!")
    end
end
```

---

## 📊 Comandos de Estatísticas

### Ver Todas Estatísticas
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    local data = DataManager:GetPlayerData(player)
    print("=== ESTATÍSTICAS ===")
    for stat, value in pairs(data.Stats) do
        print(stat .. ":", value)
    end
end
```

### Adicionar Kills
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local player = game.Players:FindFirstChild("SEU_NOME_AQUI")
if player then
    DataManager:AddStat(player, "TotalKills", 1000)
    print("✅ 1000 kills adicionados!")
end
```

---

## 🎁 Comando GOD (Tudo MAX)

### DAR TUDO DE UMA VEZ
```lua
local DataManager = require(game.ServerScriptService.Core.DataManager)
local ShadowData = require(game.ReplicatedStorage.Modules.ShadowData)
local WeaponData = require(game.ReplicatedStorage.Modules.WeaponData)
local RelicData = require(game.ReplicatedStorage.Modules.RelicData)

local player = game.Players:FindFirstChild("SEU_NOME_AQUI")

if player then
    -- Recursos
    DataManager:AddResource(player, "Cash", 10000000)
    DataManager:AddResource(player, "Diamonds", 100000)
    DataManager:AddResource(player, "Fragments", 500000)
    
    -- Level
    local data = DataManager:GetPlayerData(player)
    data.Level = 1000
    
    -- Todas Sombras (evoluídas)
    for _, template in ipairs(ShadowData.Templates) do
        local shadow = ShadowData:CreateShadowInstance(template.ID, 10)
        DataManager:AddShadow(player, shadow)
    end
    
    -- Todas Armas (max level)
    for _, template in ipairs(WeaponData.Templates) do
        local weapon = WeaponData:CreateWeaponInstance(template.ID, 10)
        DataManager:AddItem(player, "Weapons", weapon)
    end
    
    -- Todas Relíquias (high level)
    for _, template in ipairs(RelicData.Templates) do
        local relic = RelicData:CreateRelicInstance(template.ID, 50)
        DataManager:AddItem(player, "Relics", relic)
    end
    
    print("✅🎉 TUDO DESBLOQUEADO! MODO GOD ATIVADO! 🎉✅")
end
```

---

## 🔑 Dicas

1. **Sempre substitua** `SEU_NOME_AQUI` pelo seu nome de usuário exato
2. **Use no Studio** apenas, nunca em produção
3. **Teste um de cada vez** para evitar erros
4. **Salve o jogo** antes de testar comandos grandes
5. **Veja o Output** para mensagens de erro

---

## ⚠️ Segurança

Para usar comandos em um jogo publicado:
1. Crie um sistema de admin
2. Verifique UserId do jogador
3. Adicione logs de ações
4. Use RemoteEvents protegidos

**NUNCA deixe estes comandos acessíveis a todos os jogadores!**

---

**Happy Testing! 🧪✨**
