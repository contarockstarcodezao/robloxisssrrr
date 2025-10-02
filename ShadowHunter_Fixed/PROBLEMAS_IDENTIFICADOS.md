# 🔧 Problemas Identificados no Framework

## ❌ Problemas Encontrados

### 1. **Incompatibilidade de Estrutura de Dados**
- `CombatSystem` tenta acessar `data.Stats.DamageDealt`
- `DataManager` original não tem campo `Statistics` ou `DamageDealt`
- **Resultado:** Erro ao tentar registrar dano

### 2. **Campos Faltando no DataManager**
```lua
-- CombatSystem espera:
data.Stats.DamageDealt
data.Stats.NPCsKilled
data.Stats.ShadowsCaptured

-- Mas DataManager tem:
data.Stats = {
    PlayerSpeed = 0,
    PlayerDamage = 0,
    // Falta DamageDealt, NPCsKilled, etc
}
```

### 3. **RemoteEvents Não Conectados**
- `CombatClient` dispara eventos
- Mas `CombatSystem` não escuta os eventos corretamente
- **Conexões faltando no Init()**

### 4. **NPCManager OnDeath Não Conectado**
- NPCs morrem mas não acionam `CombatSystem:HandleNPCDeath`
- Falta conexão entre NPCManager e CombatSystem

### 5. **Prompts de Captura Não Funcionam**
- `ShadowClient` procura por `CapturePrompt`
- `NPCManager` cria o prompt mas não conecta aos eventos

### 6. **Falta de Validação de Existência**
- Scripts tentam acessar módulos sem verificar se existem
- Causa erros se algum módulo não foi carregado

### 7. **Auto-ataque de Sombras Não Inicia**
- `CombatSystem:StartAutoAttack` é chamado
- Mas loop pode falhar se player sair antes

## ✅ Soluções Aplicadas

Vou criar versões CORRIGIDAS de todos os scripts principais com:

1. ✅ Estrutura de dados unificada
2. ✅ Todas as conexões de eventos
3. ✅ Validações robustas
4. ✅ Sistema de callback entre módulos
5. ✅ Logs de debug para facilitar troubleshooting
