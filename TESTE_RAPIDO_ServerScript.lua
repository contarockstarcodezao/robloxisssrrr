-- TESTE RÁPIDO - Cole em ServerScriptService como Script
-- Nome: TesteRapido

print("🔍 ========== TESTE RÁPIDO INICIADO ==========")

-- 1. Verificar estrutura básica
local function verificarEstrutura()
    local ok = true
    
    print("\n📁 Verificando estrutura...")
    
    -- ReplicatedStorage
    if game.ReplicatedStorage:FindFirstChild("Modules") then
        print("✅ ReplicatedStorage/Modules existe")
    else
        print("❌ FALTA: ReplicatedStorage/Modules")
        ok = false
    end
    
    if game.ReplicatedStorage:FindFirstChild("Events") then
        print("✅ ReplicatedStorage/Events existe")
    else
        print("❌ FALTA: ReplicatedStorage/Events")
        ok = false
    end
    
    -- ServerScriptService
    if game.ServerScriptService:FindFirstChild("Core") then
        print("✅ ServerScriptService/Core existe")
    else
        print("❌ FALTA: ServerScriptService/Core")
        ok = false
    end
    
    if game.ServerScriptService:FindFirstChild("Systems") then
        print("✅ ServerScriptService/Systems existe")
    else
        print("❌ FALTA: ServerScriptService/Systems")
        ok = false
    end
    
    return ok
end

-- 2. Testar módulos
local function testarModulos()
    print("\n📦 Testando módulos...")
    
    local modulos = {
        "GameConfig",
        "ShadowData", 
        "WeaponData",
        "RelicData",
        "UtilityFunctions"
    }
    
    for _, nome in ipairs(modulos) do
        local mod = game.ReplicatedStorage.Modules:FindFirstChild(nome)
        if mod then
            local success, result = pcall(function()
                return require(mod)
            end)
            
            if success then
                print("✅", nome, "- OK")
            else
                print("❌", nome, "- ERRO ao carregar:", result)
            end
        else
            print("❌", nome, "- NÃO ENCONTRADO")
        end
    end
end

-- 3. Testar RemoteEvents
local function testarEvents()
    print("\n📡 Testando RemoteEvents...")
    
    local events = {
        {Nome = "CombatEvent", Tipo = "RemoteEvent"},
        {Nome = "ShadowEvent", Tipo = "RemoteEvent"},
        {Nome = "InventoryEvent", Tipo = "RemoteEvent"},
        {Nome = "DungeonEvent", Tipo = "RemoteEvent"},
        {Nome = "RankingEvent", Tipo = "RemoteEvent"},
        {Nome = "DataRequest", Tipo = "RemoteFunction"},
    }
    
    for _, event in ipairs(events) do
        local obj = game.ReplicatedStorage.Events:FindFirstChild(event.Nome)
        if obj then
            if obj.ClassName == event.Tipo then
                print("✅", event.Nome, "-", event.Tipo)
            else
                print("⚠️", event.Nome, "existe mas é", obj.ClassName, "deveria ser", event.Tipo)
            end
        else
            print("❌", event.Nome, "- NÃO ENCONTRADO")
        end
    end
end

-- 4. Criar sistema de combate simples
local function criarCombateSimples()
    print("\n⚔️ Criando sistema de combate simples...")
    
    local combatEvent = game.ReplicatedStorage.Events:FindFirstChild("CombatEvent")
    
    if not combatEvent then
        print("❌ CombatEvent não encontrado, criando...")
        combatEvent = Instance.new("RemoteEvent")
        combatEvent.Name = "CombatEvent"
        combatEvent.Parent = game.ReplicatedStorage.Events or game.ReplicatedStorage
    end
    
    combatEvent.OnServerEvent:Connect(function(player, action, targetPosition)
        print("⚔️ Ataque recebido de:", player.Name)
        
        local character = player.Character
        if not character or not character.PrimaryPart then
            print("❌ Character inválido")
            return
        end
        
        print("🎯 Procurando NPCs próximos...")
        
        local atacou = false
        for _, obj in pairs(workspace:GetChildren()) do
            if obj:GetAttribute("IsNPC") then
                local npcPart = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
                if npcPart then
                    local distance = (npcPart.Position - character.PrimaryPart.Position).Magnitude
                    
                    if distance <= 20 then
                        local humanoid = obj:FindFirstChild("Humanoid")
                        if humanoid and humanoid.Health > 0 then
                            humanoid:TakeDamage(25)
                            print("💥 HIT! Dano: 25, HP restante:", humanoid.Health)
                            atacou = true
                            
                            -- Efeito visual
                            local effect = Instance.new("Part")
                            effect.Size = Vector3.new(2, 2, 2)
                            effect.Anchored = true
                            effect.CanCollide = false
                            effect.Material = Enum.Material.Neon
                            effect.Color = Color3.fromRGB(255, 0, 0)
                            effect.CFrame = npcPart.CFrame
                            effect.Parent = workspace
                            
                            game:GetService("Debris"):AddItem(effect, 0.5)
                            
                            break
                        end
                    end
                end
            end
        end
        
        if not atacou then
            print("⚠️ Nenhum NPC no alcance")
        end
    end)
    
    print("✅ Sistema de combate ativo!")
end

-- 5. Testar jogadores
local function testarJogadores()
    print("\n👥 Monitorando jogadores...")
    
    game.Players.PlayerAdded:Connect(function(player)
        print("👤 Jogador entrou:", player.Name)
        
        player.CharacterAdded:Connect(function(character)
            wait(1)
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                print("✅ Character pronto:", player.Name, "| HP:", humanoid.Health)
            else
                print("❌ Humanoid não encontrado para:", player.Name)
            end
        end)
    end)
end

-- EXECUTAR TESTES
verificarEstrutura()
testarModulos()
testarEvents()
criarCombateSimples()
testarJogadores()

print("\n🎮 ========== TESTE CONCLUÍDO ==========")
print("📝 Veja as mensagens acima para identificar problemas")
print("⚔️ Tente clicar para atacar NPCs!")
print("===============================================\n")
