# 🎮 Arise Crossover - Instruções de Instalação

## 📋 Pré-requisitos
- Roblox Studio instalado
- Conta do Roblox
- Conhecimento básico do Roblox Studio

## 🚀 Passo a Passo da Instalação

### 1. Criar Novo Lugar
1. Abra o Roblox Studio
2. Clique em "New" para criar um novo lugar
3. Escolha "Baseplate" como template

### 2. Configurar Estrutura de Pastas

#### ReplicatedStorage
Crie as seguintes pastas em ReplicatedStorage:
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
Crie as seguintes pastas em ServerScriptService:
```
ServerScriptService/
├── ShadowSystem/
│   └── ShadowManager.lua
├── Combat/
│   └── CombatManager.lua
├── Drops/
│   └── DropManager.lua
├── LevelSystem/
│   └── LevelManager.lua
├── Dungeons/
│   └── DungeonManager.lua
├── Ranking/
│   └── RankingManager.lua
├── Inventory/
│   └── InventoryManager.lua
├── Weapons/
│   └── WeaponManager.lua
├── Economy/
│   └── EconomyManager.lua
├── Relics/
│   └── RelicManager.lua
├── MainServer.lua
└── TestSystem.lua
```

#### StarterPlayer
Crie a seguinte pasta em StarterPlayer:
```
StarterPlayer/
└── StarterPlayerScripts/
    └── ClientManager.lua
```

### 3. Copiar Scripts

#### ReplicatedStorage/Data/
1. Copie o conteúdo de `ReplicatedStorage/Data/ShadowData.lua`
2. Cole em um novo Script em ReplicatedStorage/Data/ShadowData
3. Repita para WeaponData.lua e RelicData.lua

#### ReplicatedStorage/Events/
1. Copie o conteúdo de `ReplicatedStorage/Events/RemoteEvents.lua`
2. Cole em um novo Script em ReplicatedStorage/Events/RemoteEvents

#### ServerScriptService/
1. Copie o conteúdo de cada arquivo .lua para sua respectiva pasta
2. Certifique-se de que cada script está na pasta correta

#### StarterPlayer/StarterPlayerScripts/
1. Copie o conteúdo de `StarterPlayer/StarterPlayerScripts/ClientManager.lua`
2. Cole em um novo Script em StarterPlayer/StarterPlayerScripts/ClientManager

### 4. Configurar Workspace

#### Adicionar NPCs de Teste
1. Crie alguns Parts no Workspace
2. Adicione um Humanoid a cada Part
3. Nomeie-os como "Enemy1", "Enemy2", etc.

#### Configurar Spawn
1. Crie um Part chamado "SpawnLocation"
2. Posicione-o onde os jogadores devem aparecer
3. Adicione um SpawnLocation ao Part

### 5. Testar o Sistema

#### Executar Testes
1. Execute o jogo no Roblox Studio
2. Verifique se o TestSystem.lua está funcionando
3. Observe os logs no Output

#### Verificar Funcionalidades
1. Teste o sistema de sombras
2. Teste o sistema de combate
3. Teste o sistema de inventário
4. Teste o sistema de economia

## 🔧 Configurações Avançadas

### Personalizar Dados
- Edite `ShadowData.lua` para adicionar novas sombras
- Edite `WeaponData.lua` para adicionar novas armas
- Edite `RelicData.lua` para adicionar novas relíquias

### Ajustar Configurações
- Modifique `MainServer.lua` para alterar configurações globais
- Ajuste os valores de XP, dano, etc. nos arquivos de dados

### Adicionar Novos Sistemas
1. Crie um novo módulo em ServerScriptService
2. Adicione os eventos necessários em RemoteEvents.lua
3. Integre com os sistemas existentes

## 🐛 Solução de Problemas

### Erros Comuns

#### "Module not found"
- Verifique se o arquivo está na pasta correta
- Certifique-se de que o nome do arquivo está correto

#### "RemoteEvent not found"
- Verifique se RemoteEvents.lua foi executado
- Certifique-se de que os eventos estão sendo criados

#### "Player data not initialized"
- Verifique se os sistemas estão sendo inicializados
- Certifique-se de que MainServer.lua está executando

### Logs de Debug
- Verifique o Output do Roblox Studio
- Use print() para debugar
- Execute TestSystem.lua para verificar integridade

## 📚 Documentação Adicional

### Sistemas Implementados
1. **Sistema de Sombras** - Captura, evolução e invocação
2. **Sistema de Combate** - Armas, ataques e dano
3. **Sistema de Drops** - Coleta automática e raridade
4. **Sistema de XP** - Progressão e níveis
5. **Sistema de Dungeons** - Instâncias e raids
6. **Sistema de Ranking** - Leaderboards
7. **Sistema de Inventário** - Gestão de itens
8. **Sistema de Armas** - Forja e melhorias
9. **Sistema de Economia** - Cash e diamantes
10. **Sistema de Relíquias** - Bônus passivos

### Estrutura de Dados
- **Sombras**: Rank, atributos, habilidades
- **Armas**: Tipo, raridade, efeitos especiais
- **Relíquias**: Tipo, raridade, bônus
- **Jogadores**: Nível, XP, inventário, moedas

## 🎯 Próximos Passos

### Melhorias Sugeridas
1. Adicionar mais sombras e armas
2. Implementar sistema de guilds
3. Adicionar sistema de eventos
4. Criar sistema de achievements
5. Implementar sistema de chat

### Otimizações
1. Implementar sistema de cache
2. Otimizar scripts de performance
3. Adicionar sistema de backup
4. Implementar sistema de logs

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs de erro
2. Execute TestSystem.lua
3. Verifique se todos os arquivos estão na pasta correta
4. Certifique-se de que os scripts estão executando

## 🎉 Conclusão

Parabéns! Você configurou com sucesso o jogo Arise Crossover. O sistema está pronto para ser usado e pode ser expandido conforme necessário.

**Lembre-se**: Este é um sistema modular, então você pode adicionar novos recursos facilmente seguindo a estrutura existente.