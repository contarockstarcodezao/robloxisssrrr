--[[
    INVENTORY MANAGER
    Localização: ServerScriptService/Inventory/InventoryManager.lua
    
    Este script gerencia o sistema de inventário:
    - Armazenamento de itens
    - Expansão de slots
    - Organização e filtros
    - Integração com outros sistemas
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Importar dados e eventos
local WeaponData = require(ReplicatedStorage.Data.WeaponData)
local RelicData = require(ReplicatedStorage.Data.RelicData)
local RemoteEvents = require(ReplicatedStorage.Events.RemoteEvents)

local InventoryManager = {}

-- Tipos de itens
local ITEM_TYPES = {
    WEAPON = "Weapon",
    SHADOW = "Shadow",
    RELIC = "Relic",
    POTION = "Potion",
    FRAGMENT = "Fragment",
    CURRENCY = "Currency"
}

-- Dados dos jogadores
local playerInventories = {}

-- Inicializar inventário do jogador
function InventoryManager.InitializePlayer(player)
    if not playerInventories[player] then
        playerInventories[player] = {
            weapons = {},
            shadows = {},
            relics = {},
            potions = {},
            fragments = {},
            currency = {
                cash = 0,
                diamonds = 0
            },
            maxSlots = {
                weapons = 20,
                shadows = 20,
                relics = 20,
                potions = 50,
                fragments = 100
            },
            usedSlots = {
                weapons = 0,
                shadows = 0,
                relics = 0,
                potions = 0,
                fragments = 0
            }
        }
    end
end

-- Adicionar item ao inventário
function InventoryManager.AddItem(player, itemName, quantity, itemType)
    InventoryManager.InitializePlayer(player)
    
    local inventory = playerInventories[player]
    quantity = quantity or 1
    itemType = itemType or InventoryManager.GetItemType(itemName)
    
    if not itemType then
        return false, "Tipo de item não reconhecido"
    end
    
    -- Verificar se há espaço
    if not InventoryManager.HasSpace(player, itemType, quantity) then
        return false, "Inventário cheio"
    end
    
    -- Adicionar item
    if itemType == ITEM_TYPES.WEAPON then
        InventoryManager.AddWeapon(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.SHADOW then
        InventoryManager.AddShadow(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.RELIC then
        InventoryManager.AddRelic(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.POTION then
        InventoryManager.AddPotion(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.FRAGMENT then
        InventoryManager.AddFragment(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.CURRENCY then
        InventoryManager.AddCurrency(player, itemName, quantity)
    end
    
    -- Notificar cliente
    RemoteEvents.Inventory.AddItem:FireClient(player, itemName, quantity, itemType)
    
    return true, "Item adicionado com sucesso!"
end

-- Remover item do inventário
function InventoryManager.RemoveItem(player, itemName, quantity, itemType)
    InventoryManager.InitializePlayer(player)
    
    local inventory = playerInventories[player]
    quantity = quantity or 1
    itemType = itemType or InventoryManager.GetItemType(itemName)
    
    if not itemType then
        return false, "Tipo de item não reconhecido"
    end
    
    -- Verificar se o item existe
    if not InventoryManager.HasItem(player, itemName, quantity, itemType) then
        return false, "Item não encontrado ou quantidade insuficiente"
    end
    
    -- Remover item
    if itemType == ITEM_TYPES.WEAPON then
        InventoryManager.RemoveWeapon(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.SHADOW then
        InventoryManager.RemoveShadow(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.RELIC then
        InventoryManager.RemoveRelic(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.POTION then
        InventoryManager.RemovePotion(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.FRAGMENT then
        InventoryManager.RemoveFragment(player, itemName, quantity)
    elseif itemType == ITEM_TYPES.CURRENCY then
        InventoryManager.RemoveCurrency(player, itemName, quantity)
    end
    
    -- Notificar cliente
    RemoteEvents.Inventory.RemoveItem:FireClient(player, itemName, quantity, itemType)
    
    return true, "Item removido com sucesso!"
end

-- Adicionar arma
function InventoryManager.AddWeapon(player, weaponName, quantity)
    local inventory = playerInventories[player]
    local weapons = inventory.weapons
    
    if weapons[weaponName] then
        weapons[weaponName] = weapons[weaponName] + quantity
    else
        weapons[weaponName] = quantity
        inventory.usedSlots.weapons = inventory.usedSlots.weapons + 1
    end
end

-- Remover arma
function InventoryManager.RemoveWeapon(player, weaponName, quantity)
    local inventory = playerInventories[player]
    local weapons = inventory.weapons
    
    if weapons[weaponName] then
        weapons[weaponName] = weapons[weaponName] - quantity
        if weapons[weaponName] <= 0 then
            weapons[weaponName] = nil
            inventory.usedSlots.weapons = inventory.usedSlots.weapons - 1
        end
    end
end

-- Adicionar sombra
function InventoryManager.AddShadow(player, shadowName, quantity)
    local inventory = playerInventories[player]
    local shadows = inventory.shadows
    
    if shadows[shadowName] then
        shadows[shadowName] = shadows[shadowName] + quantity
    else
        shadows[shadowName] = quantity
        inventory.usedSlots.shadows = inventory.usedSlots.shadows + 1
    end
end

-- Remover sombra
function InventoryManager.RemoveShadow(player, shadowName, quantity)
    local inventory = playerInventories[player]
    local shadows = inventory.shadows
    
    if shadows[shadowName] then
        shadows[shadowName] = shadows[shadowName] - quantity
        if shadows[shadowName] <= 0 then
            shadows[shadowName] = nil
            inventory.usedSlots.shadows = inventory.usedSlots.shadows - 1
        end
    end
end

-- Adicionar relíquia
function InventoryManager.AddRelic(player, relicName, quantity)
    local inventory = playerInventories[player]
    local relics = inventory.relics
    
    if relics[relicName] then
        relics[relicName] = relics[relicName] + quantity
    else
        relics[relicName] = quantity
        inventory.usedSlots.relics = inventory.usedSlots.relics + 1
    end
end

-- Remover relíquia
function InventoryManager.RemoveRelic(player, relicName, quantity)
    local inventory = playerInventories[player]
    local relics = inventory.relics
    
    if relics[relicName] then
        relics[relicName] = relics[relicName] - quantity
        if relics[relicName] <= 0 then
            relics[relicName] = nil
            inventory.usedSlots.relics = inventory.usedSlots.relics - 1
        end
    end
end

-- Adicionar poção
function InventoryManager.AddPotion(player, potionName, quantity)
    local inventory = playerInventories[player]
    local potions = inventory.potions
    
    if potions[potionName] then
        potions[potionName] = potions[potionName] + quantity
    else
        potions[potionName] = quantity
        inventory.usedSlots.potions = inventory.usedSlots.potions + 1
    end
end

-- Remover poção
function InventoryManager.RemovePotion(player, potionName, quantity)
    local inventory = playerInventories[player]
    local potions = inventory.potions
    
    if potions[potionName] then
        potions[potionName] = potions[potionName] - quantity
        if potions[potionName] <= 0 then
            potions[potionName] = nil
            inventory.usedSlots.potions = inventory.usedSlots.potions - 1
        end
    end
end

-- Adicionar fragmento
function InventoryManager.AddFragment(player, fragmentName, quantity)
    local inventory = playerInventories[player]
    local fragments = inventory.fragments
    
    if fragments[fragmentName] then
        fragments[fragmentName] = fragments[fragmentName] + quantity
    else
        fragments[fragmentName] = quantity
        inventory.usedSlots.fragments = inventory.usedSlots.fragments + 1
    end
end

-- Remover fragmento
function InventoryManager.RemoveFragment(player, fragmentName, quantity)
    local inventory = playerInventories[player]
    local fragments = inventory.fragments
    
    if fragments[fragmentName] then
        fragments[fragmentName] = fragments[fragmentName] - quantity
        if fragments[fragmentName] <= 0 then
            fragments[fragmentName] = nil
            inventory.usedSlots.fragments = inventory.usedSlots.fragments - 1
        end
    end
end

-- Adicionar moeda
function InventoryManager.AddCurrency(player, currencyName, quantity)
    local inventory = playerInventories[player]
    local currency = inventory.currency
    
    if currencyName == "Cash" then
        currency.cash = currency.cash + quantity
    elseif currencyName == "Diamonds" then
        currency.diamonds = currency.diamonds + quantity
    end
end

-- Remover moeda
function InventoryManager.RemoveCurrency(player, currencyName, quantity)
    local inventory = playerInventories[player]
    local currency = inventory.currency
    
    if currencyName == "Cash" then
        currency.cash = math.max(0, currency.cash - quantity)
    elseif currencyName == "Diamonds" then
        currency.diamonds = math.max(0, currency.diamonds - quantity)
    end
end

-- Verificar se tem espaço
function InventoryManager.HasSpace(player, itemType, quantity)
    local inventory = playerInventories[player]
    
    if itemType == ITEM_TYPES.WEAPON then
        return inventory.usedSlots.weapons < inventory.maxSlots.weapons
    elseif itemType == ITEM_TYPES.SHADOW then
        return inventory.usedSlots.shadows < inventory.maxSlots.shadows
    elseif itemType == ITEM_TYPES.RELIC then
        return inventory.usedSlots.relics < inventory.maxSlots.relics
    elseif itemType == ITEM_TYPES.POTION then
        return inventory.usedSlots.potions < inventory.maxSlots.potions
    elseif itemType == ITEM_TYPES.FRAGMENT then
        return inventory.usedSlots.fragments < inventory.maxSlots.fragments
    elseif itemType == ITEM_TYPES.CURRENCY then
        return true -- Moedas não ocupam slots
    end
    
    return false
end

-- Verificar se tem item
function InventoryManager.HasItem(player, itemName, quantity, itemType)
    local inventory = playerInventories[player]
    quantity = quantity or 1
    itemType = itemType or InventoryManager.GetItemType(itemName)
    
    if not itemType then
        return false
    end
    
    if itemType == ITEM_TYPES.WEAPON then
        return inventory.weapons[itemName] and inventory.weapons[itemName] >= quantity
    elseif itemType == ITEM_TYPES.SHADOW then
        return inventory.shadows[itemName] and inventory.shadows[itemName] >= quantity
    elseif itemType == ITEM_TYPES.RELIC then
        return inventory.relics[itemName] and inventory.relics[itemName] >= quantity
    elseif itemType == ITEM_TYPES.POTION then
        return inventory.potions[itemName] and inventory.potions[itemName] >= quantity
    elseif itemType == ITEM_TYPES.FRAGMENT then
        return inventory.fragments[itemName] and inventory.fragments[itemName] >= quantity
    elseif itemType == ITEM_TYPES.CURRENCY then
        if itemName == "Cash" then
            return inventory.currency.cash >= quantity
        elseif itemName == "Diamonds" then
            return inventory.currency.diamonds >= quantity
        end
    end
    
    return false
end

-- Obter tipo do item
function InventoryManager.GetItemType(itemName)
    if WeaponData.WEAPONS[itemName] then
        return ITEM_TYPES.WEAPON
    elseif RelicData.RELICS[itemName] then
        return ITEM_TYPES.RELIC
    elseif itemName == "Cash" or itemName == "Diamonds" then
        return ITEM_TYPES.CURRENCY
    elseif itemName:find("Potion") then
        return ITEM_TYPES.POTION
    elseif itemName:find("Fragment") then
        return ITEM_TYPES.FRAGMENT
    elseif itemName:find("Shadow") then
        return ITEM_TYPES.SHADOW
    end
    
    return nil
end

-- Expandir inventário
function InventoryManager.ExpandInventory(player, itemType, cost)
    local inventory = playerInventories[player]
    
    if not InventoryManager.HasCurrency(player, "Diamonds", cost) then
        return false, "Diamantes insuficientes"
    end
    
    -- Remover diamantes
    InventoryManager.RemoveCurrency(player, "Diamonds", cost)
    
    -- Expandir slots
    if itemType == ITEM_TYPES.WEAPON then
        inventory.maxSlots.weapons = inventory.maxSlots.weapons + 5
    elseif itemType == ITEM_TYPES.SHADOW then
        inventory.maxSlots.shadows = inventory.maxSlots.shadows + 5
    elseif itemType == ITEM_TYPES.RELIC then
        inventory.maxSlots.relics = inventory.maxSlots.relics + 5
    elseif itemType == ITEM_TYPES.POTION then
        inventory.maxSlots.potions = inventory.maxSlots.potions + 10
    elseif itemType == ITEM_TYPES.FRAGMENT then
        inventory.maxSlots.fragments = inventory.maxSlots.fragments + 20
    end
    
    -- Notificar cliente
    RemoteEvents.Inventory.InventoryExpanded:FireClient(player, itemType, inventory.maxSlots[itemType:lower()])
    
    return true, "Inventário expandido com sucesso!"
end

-- Verificar se tem moeda
function InventoryManager.HasCurrency(player, currencyName, amount)
    local inventory = playerInventories[player]
    
    if currencyName == "Cash" then
        return inventory.currency.cash >= amount
    elseif currencyName == "Diamonds" then
        return inventory.currency.diamonds >= amount
    end
    
    return false
end

-- Obter inventário do jogador
function InventoryManager.GetPlayerInventory(player)
    InventoryManager.InitializePlayer(player)
    return playerInventories[player]
end

-- Ordenar inventário
function InventoryManager.SortInventory(player, itemType, sortBy)
    local inventory = playerInventories[player]
    local items = {}
    
    if itemType == ITEM_TYPES.WEAPON then
        items = inventory.weapons
    elseif itemType == ITEM_TYPES.SHADOW then
        items = inventory.shadows
    elseif itemType == ITEM_TYPES.RELIC then
        items = inventory.relics
    elseif itemType == ITEM_TYPES.POTION then
        items = inventory.potions
    elseif itemType == ITEM_TYPES.FRAGMENT then
        items = inventory.fragments
    end
    
    -- TODO: Implementar ordenação
    -- Por enquanto, apenas notificar o cliente
    RemoteEvents.Inventory.SortInventory:FireClient(player, itemType, sortBy)
end

-- Filtrar inventário
function InventoryManager.FilterInventory(player, itemType, filter)
    local inventory = playerInventories[player]
    
    -- TODO: Implementar filtros
    -- Por enquanto, apenas notificar o cliente
    RemoteEvents.Inventory.FilterInventory:FireClient(player, itemType, filter)
end

-- Conectar eventos
local function onPlayerAdded(player)
    InventoryManager.InitializePlayer(player)
end

local function onPlayerRemoving(player)
    playerInventories[player] = nil
end

-- Conectar eventos de inventário
RemoteEvents.Inventory.AddItem.OnServerEvent:Connect(function(player, itemName, quantity, itemType)
    local success, message = InventoryManager.AddItem(player, itemName, quantity, itemType)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Inventory.RemoveItem.OnServerEvent:Connect(function(player, itemName, quantity, itemType)
    local success, message = InventoryManager.RemoveItem(player, itemName, quantity, itemType)
    -- TODO: Implementar feedback visual
end)

RemoteEvents.Inventory.ExpandInventory.OnServerEvent:Connect(function(player, itemType, cost)
    local success, message = InventoryManager.ExpandInventory(player, itemType, cost)
    -- TODO: Implementar feedback visual
end)

-- Conectar eventos de jogadores
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Inicializar jogadores existentes
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return InventoryManager