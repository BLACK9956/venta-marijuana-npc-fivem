local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local npcCoords = vector3(1041.27, -3208.41, -38.16)
local npcPed = nil

function DrawNPC()
    RequestModel(GetHashKey('g_m_y_ballasout_01'))
    while not HasModelLoaded(GetHashKey('g_m_y_ballasout_01')) do
        Wait(1)
    end

    local npcPed = CreatePed(4, GetHashKey('g_m_y_ballasout_01'), npcCoords.x, npcCoords.y, npcCoords.z - 1, 0.0, false, true)
    FreezeEntityPosition(npcPed, true)
    SetEntityHeading(npcPed, 360.0)
    SetEntityInvincible(npcPed, true)
    SetBlockingOfNonTemporaryEvents(npcPed, true)
end


Citizen.CreateThread(function()
    DrawNPC()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - npcCoords)

        if distance < 3.0 then
            local npcCoords = GetEntityCoords(npcPed)

            ESX.ShowHelpNotification('Presiona ~INPUT_CONTEXT~  para vender marihuana al NPC', notificationPos)
            
            if IsControlJustPressed(0, 38) then
                OpenMarijuanaMenu()
            end
        end
    end
end)


function OpenMarijuanaMenu()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'marijuana_quantity', {
        title = 'Cantidad de marihuana a vender'
    }, function(data, menu)
        local quantity = tonumber(data.value)

        if quantity ~= nil and quantity > 0 then
            menu.close()
            TriggerServerEvent('venderMarihuana', quantity)
        else
            ESX.ShowNotification('Cantidad inválida')
        end
    end, function(data, menu)
        menu.close()
    end)
end

-------------------------TEPEAR JUGADOR-------------------------------

function CreateMarker(markerType, coords, scale, color)
    local marker = AddBlipForCoord(coords)
    SetBlipSprite(marker, markerType)
    SetBlipScale(marker, scale)
    SetBlipColour(marker, color)
    SetBlipAsShortRange(marker, true)
    return marker
end

local firstMarkerCoords = vector3(32.47, 3671.84, 40.44)  -- Coordenadas del primer marcador
local secondMarkerCoords = vector3(1035.86, -3205.20, -38.17) -- Coordenadas del segundo marcador

-- Creamos el primer marcador
local firstMarker = CreateMarker(1, firstMarkerCoords, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 255, 0, 0, 200, false, false, 2, nil, nil, false)

local tpMarkerCoords = vector3(1035.86, -3205.20, -38.17)  -- Coordenadas del punto de teletransporte

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Dibuja el punto amarillo en las coordenadas del punto de teletransporte
        DrawMarker(1, tpMarkerCoords.x, tpMarkerCoords.y, tpMarkerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
    end
end)


-- Creamos el segundo marcador
local secondMarker = CreateMarker(1, secondMarkerCoords, 0, 0, 0, 0, 0, 0, 5.0, 5.0, 5.0, 0, 255, 0, 200, false, false, 2, nil, nil, false)

local tpMarkerCoords = vector3(32.47, 3671.84, 40.44)  -- Coordenadas del punto de teletransporte

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        -- Dibuja el punto amarillo en las coordenadas del punto de teletransporte
        DrawMarker(1, tpMarkerCoords.x, tpMarkerCoords.y, tpMarkerCoords.z - 1.0, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 255, 0, 100, false, true, 2, false, nil, nil, false)
    end
end)


-- Creamos el evento para cuando el jugador entra a un marcador
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        
        if IsPlayerInRangeOfMarker(firstMarkerCoords) then
            DrawText3D(firstMarkerCoords.x, firstMarkerCoords.y, firstMarkerCoords.z + 1.0, "~b~Presiona E para teleportarte")
            if IsControlJustReleased(0, 38) then -- E
                TriggerServerEvent('teleportPlayer', firstTeleportCoords) -- Enviamos las coordenadas de destino al servidor
            end
        elseif IsPlayerInRangeOfMarker(secondMarkerCoords) then
            DrawText3D(secondMarkerCoords.x, secondMarkerCoords.y, secondMarkerCoords.z + 1.0, "~b~Presiona E para teleportarte")
            if IsControlJustReleased(0, 38) then -- E
                TriggerServerEvent('teleportPlayer', secondTeleportCoords) -- Enviamos las coordenadas de destino al servidor
            end
        end
    end
end)

RegisterNetEvent('teleportPlayerClient')
AddEventHandler('teleportPlayerClient', function(coords)
    local playerPed = GetPlayerPed(-1)
    if coords and coords.x and coords.y and coords.z then
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z)
    end
end)



-- Función para crear un marcador
function CreateMarker(markerType, coords, scale, color)
    local marker = AddBlipForCoord(coords)
    SetBlipSprite(marker, markerType)
    SetBlipScale(marker, scale)
    SetBlipColour(marker, color)
    SetBlipAsShortRange(marker, true)
    return marker
end

-- Función para verificar si el jugador está cerca de un marcador
function IsPlayerInRangeOfMarker(coords)
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    local distance = GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, coords.x, coords.y, coords.z, true)
    return distance < 2.0
end

-- Función para mostrar un texto 3D
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

-- Creamos el evento para teletransportar al jugador
RegisterNetEvent('teleportPlayerClient')
AddEventHandler('teleportPlayerClient', function()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    
    if IsPlayerInRangeOfMarker(firstMarkerCoords) then
        SetEntityCoords(playerPed, secondMarkerCoords)
    elseif IsPlayerInRangeOfMarker(secondMarkerCoords) then
        SetEntityCoords(playerPed, firstMarkerCoords)
    end
end)
