ESX = exports["es_extended"]:getSharedObject()

local precioCompraMarihuana = 50

local npcCoords = vector3(1041.27, -3208.41, -38.16)  -- Coordenadas del NPC

RegisterServerEvent('venderMarihuana')
AddEventHandler('venderMarihuana', function(quantity)
    local src = source
    local player = ESX.GetPlayerFromId(src)
    
    -- Calcula la distancia en el lado del cliente
    -- local playerCoords = player.getCoords(true)
    -- local distance = #(playerCoords - npcCoords)

    -- No es necesario calcular la distancia en el servidor

    -- if distance < 3.0 then -- Esto no es necesario en el servidor
        local hasMarihuana = player.getInventoryItem('marijuana').count >= quantity

        if hasMarihuana then
            player.removeInventoryItem('marijuana', quantity)

            local totalPayment = quantity * precioCompraMarihuana

            -- Pagar al jugador el monto total en efectivo
            player.addMoney(totalPayment)

            TriggerClientEvent('esx:showNotification', src, 'Has vendido ' .. quantity .. ' unidades de marihuana por $' .. totalPayment)
        else
            TriggerClientEvent('esx:showNotification', src, 'No tienes suficiente marihuana para vender')
        end
    -- else
    --     TriggerClientEvent('esx:showNotification', src, 'Estás demasiado lejos del NPC')
    -- end
end)



------------------------------------------------------------------------------
                            --TEPEAR A JUGADOR--

                            RegisterNetEvent('teleportPlayer')
                            AddEventHandler('teleportPlayer', function(targetCoords)
                                local playerId = source
                                TriggerClientEvent('teleportPlayerClient', playerId, targetCoords)
                            end)
                            
                            