--[[
    ECONOMY MANAGER
    Localização: ServerScriptService/Economy/EconomyManager.lua
    
    Este script gerencia o sistema de economia:
    - Gerenciamento de cash e diamantes
    - Sistema de compras e vendas
    - Transações e histórico
    - Integração com outros sistemas
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar eventos
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local EconomyManager = {}

-- Tipos de moedas
local CURRENCY_TYPES = {
    CASH = "Cash",
    DIAMONDS = "Diamonds"
}

-- Dados dos jogadores
local playerEconomy = {}

-- Inicializar dados do jogador
function EconomyManager.InitializePlayer(player)
    if not playerEconomy[player] then
        playerEconomy[player] = {
            cash = 1000, -- Cash inicial
            diamonds = 10, -- Diamantes iniciais
            totalEarned = {
                cash = 1000,
                diamonds = 10
            },
            totalSpent = {
                cash = 0,
                diamonds = 0
            },
            transactions = {},
            lastUpdate = tick()
        }
    end
end

-- Adicionar cash
function EconomyManager.AddCash(player, amount, source)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    data.cash = data.cash + amount
    data.totalEarned.cash = data.totalEarned.cash + amount
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Cash", amount, "earned", source)
    
    -- Notificar cliente
    RemoteEvents.Economy.AddCash:FireClient(player, amount, source)
    
    return true
end

-- Remover cash
function EconomyManager.RemoveCash(player, amount, source)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    if data.cash < amount then
        return false, "Cash insuficiente"
    end
    
    data.cash = data.cash - amount
    data.totalSpent.cash = data.totalSpent.cash + amount
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Cash", amount, "spent", source)
    
    -- Notificar cliente
    RemoteEvents.Economy.RemoveCash:FireClient(player, amount, source)
    
    return true
end

-- Adicionar diamantes
function EconomyManager.AddDiamonds(player, amount, source)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    data.diamonds = data.diamonds + amount
    data.totalEarned.diamonds = data.totalEarned.diamonds + amount
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Diamonds", amount, "earned", source)
    
    -- Notificar cliente
    RemoteEvents.Economy.AddDiamonds:FireClient(player, amount, source)
    
    return true
end

-- Remover diamantes
function EconomyManager.RemoveDiamonds(player, amount, source)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    if data.diamonds < amount then
        return false, "Diamantes insuficientes"
    end
    
    data.diamonds = data.diamonds - amount
    data.totalSpent.diamonds = data.totalSpent.diamonds + amount
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Diamonds", amount, "spent", source)
    
    -- Notificar cliente
    RemoteEvents.Economy.RemoveDiamonds:FireClient(player, amount, source)
    
    return true
end

-- Comprar item
function EconomyManager.PurchaseItem(player, itemName, itemType, cost)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    -- Verificar se tem recursos suficientes
    if cost.cash and data.cash < cost.cash then
        return false, "Cash insuficiente"
    end
    
    if cost.diamonds and data.diamonds < cost.diamonds then
        return false, "Diamantes insuficientes"
    end
    
    -- Remover recursos
    if cost.cash then
        data.cash = data.cash - cost.cash
        data.totalSpent.cash = data.totalSpent.cash + cost.cash
    end
    
    if cost.diamonds then
        data.diamonds = data.diamonds - cost.diamonds
        data.totalSpent.diamonds = data.totalSpent.diamonds + cost.diamonds
    end
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Purchase", cost, "spent", itemName)
    
    -- Adicionar item ao inventário
    -- TODO: Integrar com sistema de inventário
    
    -- Notificar cliente
    RemoteEvents.Economy.ItemPurchased:FireClient(player, itemName, cost)
    
    return true, "Item comprado com sucesso!"
end

-- Vender item
function EconomyManager.SellItem(player, itemName, itemType, price)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    -- Verificar se possui o item
    -- TODO: Integrar com sistema de inventário
    
    -- Adicionar cash
    data.cash = data.cash + price
    data.totalEarned.cash = data.totalEarned.cash + price
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Sale", price, "earned", itemName)
    
    -- Remover item do inventário
    -- TODO: Integrar com sistema de inventário
    
    -- Notificar cliente
    RemoteEvents.Economy.ItemSold:FireClient(player, itemName, price)
    
    return true, "Item vendido com sucesso!"
end

-- Registrar transação
function EconomyManager.RecordTransaction(player, currency, amount, type, source)
    local data = playerEconomy[player]
    
    local transaction = {
        id = tick(),
        currency = currency,
        amount = amount,
        type = type,
        source = source,
        timestamp = tick()
    }
    
    table.insert(data.transactions, transaction)
    
    -- Manter apenas as últimas 100 transações
    if #data.transactions > 100 then
        table.remove(data.transactions, 1)
    end
end

-- Obter saldo do jogador
function EconomyManager.GetBalance(player, currency)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    if currency == CURRENCY_TYPES.CASH then
        return data.cash
    elseif currency == CURRENCY_TYPES.DIAMONDS then
        return data.diamonds
    end
    
    return 0
end

-- Obter estatísticas do jogador
function EconomyManager.GetPlayerStats(player)
    EconomyManager.InitializePlayer(player)
    return playerEconomy[player]
end

-- Obter histórico de transações
function EconomyManager.GetTransactionHistory(player, limit)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    limit = limit or 50
    
    local history = {}
    local startIndex = math.max(1, #data.transactions - limit + 1)
    
    for i = startIndex, #data.transactions do
        table.insert(history, data.transactions[i])
    end
    
    return history
end

-- Verificar se pode comprar
function EconomyManager.CanAfford(player, cost)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    
    if cost.cash and data.cash < cost.cash then
        return false
    end
    
    if cost.diamonds and data.diamonds < cost.diamonds then
        return false
    end
    
    return true
end

-- Converter cash para diamantes
function EconomyManager.ConvertCashToDiamonds(player, cashAmount)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    local conversionRate = 1000 -- 1000 cash = 1 diamante
    
    if data.cash < cashAmount then
        return false, "Cash insuficiente"
    end
    
    local diamonds = math.floor(cashAmount / conversionRate)
    if diamonds <= 0 then
        return false, "Quantidade insuficiente para conversão"
    end
    
    -- Remover cash
    data.cash = data.cash - cashAmount
    data.totalSpent.cash = data.totalSpent.cash + cashAmount
    
    -- Adicionar diamantes
    data.diamonds = data.diamonds + diamonds
    data.totalEarned.diamonds = data.totalEarned.diamonds + diamonds
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Conversion", {cash = cashAmount, diamonds = diamonds}, "converted", "Cash to Diamonds")
    
    -- Notificar cliente
    RemoteEvents.Economy.CurrencyConverted:FireClient(player, "Cash", "Diamonds", cashAmount, diamonds)
    
    return true, "Conversão realizada com sucesso!"
end

-- Converter diamantes para cash
function EconomyManager.ConvertDiamondsToCash(player, diamondsAmount)
    EconomyManager.InitializePlayer(player)
    
    local data = playerEconomy[player]
    local conversionRate = 1000 -- 1 diamante = 1000 cash
    
    if data.diamonds < diamondsAmount then
        return false, "Diamantes insuficientes"
    end
    
    local cash = diamondsAmount * conversionRate
    
    -- Remover diamantes
    data.diamonds = data.diamonds - diamondsAmount
    data.totalSpent.diamonds = data.totalSpent.diamonds + diamondsAmount
    
    -- Adicionar cash
    data.cash = data.cash + cash
    data.totalEarned.cash = data.totalEarned.cash + cash
    
    -- Registrar transação
    EconomyManager.RecordTransaction(player, "Conversion", {diamonds = diamondsAmount, cash = cash}, "converted", "Diamonds to Cash")
    
    -- Notificar cliente
    RemoteEvents.Economy.CurrencyConverted:FireClient(player, "Diamonds", "Cash", diamondsAmount, cash)
    
    return true, "Conversão realizada com sucesso!"
end

-- Obter ranking de riqueza
function EconomyManager.GetWealthRanking(limit)
    limit = limit or 100
    
    local ranking = {}
    
    for player, data in pairs(playerEconomy) do
        if player and player.Parent then
            local totalWealth = data.cash + (data.diamonds * 1000) -- 1 diamante = 1000 cash
            table.insert(ranking, {
                player = player,
                cash = data.cash,
                diamonds = data.diamonds,
                totalWealth = totalWealth
            })
        end
    end
    
    -- Ordenar por riqueza total
    table.sort(ranking, function(a, b)
        return a.totalWealth > b.totalWealth
    end)
    
    -- Retornar apenas o limite solicitado
    local result = {}
    for i = 1, math.min(limit, #ranking) do
        table.insert(result, ranking[i])
    end
    
    return result
end

-- Obter estatísticas do servidor
function EconomyManager.GetServerStats()
    local totalCash = 0
    local totalDiamonds = 0
    local totalPlayers = 0
    
    for player, data in pairs(playerEconomy) do
        if player and player.Parent then
            totalCash = totalCash + data.cash
            totalDiamonds = totalDiamonds + data.diamonds
            totalPlayers = totalPlayers + 1
        end
    end
    
    return {
        totalCash = totalCash,
        totalDiamonds = totalDiamonds,
        totalPlayers = totalPlayers,
        averageCash = totalPlayers > 0 and totalCash / totalPlayers or 0,
        averageDiamonds = totalPlayers > 0 and totalDiamonds / totalPlayers or 0
    }
end

-- Conectar eventos
local function onPlayerAdded(player)
    EconomyManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerEconomy[player] = nil
end

-- Conectar eventos de economia
RemoteEvents.Economy.AddCash.OnServerEvent:Connect(function(player, amount, source)
    EconomyManager.AddCash(player, amount, source)
end)

RemoteEvents.Economy.RemoveCash.OnServerEvent:Connect(function(player, amount, source)
    EconomyManager.RemoveCash(player, amount, source)
end)

RemoteEvents.Economy.AddDiamonds.OnServerEvent:Connect(function(player, amount, source)
    EconomyManager.AddDiamonds(player, amount, source)
end)

RemoteEvents.Economy.RemoveDiamonds.OnServerEvent:Connect(function(player, amount, source)
    EconomyManager.RemoveDiamonds(player, amount, source)
end)

RemoteEvents.Economy.PurchaseItem.OnServerEvent:Connect(function(player, itemName, itemType, cost)
    local success, message = EconomyManager.PurchaseItem(player, itemName, itemType, cost)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Economy.SellItem.OnServerEvent:Connect(function(player, itemName, itemType, price)
    local success, message = EconomyManager.SellItem(player, itemName, itemType, price)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return EconomyManager