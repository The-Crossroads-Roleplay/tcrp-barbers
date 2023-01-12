-- Terrible
local telegrams = {}
local index = 1
local menu = false

------------------------------------
--- ADD YOUR OWN LOCATIONS BELOW ---
------------------------------------
--xSound = exports.xsound

-- RegisterCommand('playFFG', function(source, args, raw)
--     local pos = GetEntityCoords(PlayerPedId())
--     xSound:Destroy("name")
--     xSound:PlayUrlPos("name",string.sub(raw, 9),1,pos)
--     -- xSound:PlayUrlPos("name", "file:///C:/servers/RedM/Server/cfx-server-data/resources/[vorp]/[resources]/[addons]/xsound/robbery_voice.mp3", 1, pos)
--     --some links will not work cause to copyright or author did not allow to play video from an iframe.
--     xSound:Distance("name",100)
    
-- end, false)

local locations = {
    ['VALENTINE']             = {restricted = false, coordinates = vector3(-178.90, 626.71, 114.09) }, -- Valentine train station
    ['RHODES']                = {restricted = false, coordinates = vector3(1225.57, -1293.87, 76.91) }, -- Rhodes train station
    ['SAINT DENIS']           = {restricted = false, coordinates = vector3(2749.55, -1399.91, 46.19) }, -- Saint Denis train station
    ['ANNESBURG']             = {restricted = false, coordinates = vector3(2939.5, 1288.56, 44.65) }, -- Annesburg Post Office
    ['BLACKWATER']            = {restricted = false, coordinates = vector3(-875.12, -1328.76, 43.96) }, -- Blackwater  Post Office
    ['STRAWBERRY']            = {restricted = false, coordinates = vector3(-1764.97, -384.16, 157.74) }, -- Strawberry  Post Office
    ['ARMADILLO']             = {restricted = false, coordinates = vector3(-3733.95, -2597.76, -12.93) }, -- Armadillo  Post Office
    ['BENEDICT POINT']        = {restricted = false, coordinates = vector3(-5227.39, -3470.52, -20.57) }, -- Benedict Point  Post Office
    ['EMERALD STATION']       = {restricted = false, coordinates = vector3(1521.99, 439.54, 90.68) }, -- Emerald Station  Post Office
    ['RIGGS STATION']         = {restricted = false, coordinates = vector3(-1094.07, -575.13, 81.89) }, -- Riggs Station  Post Office
    ['WALLACE STATION']       = {restricted = false, coordinates = vector3(-1301.11, 398.97, 94.97) }, -- Wallace Station  Post Office
    ['VALENTINE SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(-277.87, 807.51, 119.48) }, -- Valentine Sheriff's Office
    ['RHODES SHERIFFS OFFICE']         = {restricted = true, coordinates = vector3(1359.22, -1299.7, 77.76) }, -- Rhodes Sheriff's Office
    ['SAINT DENIS SHERIFFS OFFICE']    = {restricted = true, coordinates = vector3(2507.49, -1301.38, 48.95) }, -- Saint Denis Sheriff's Office
    ['ANNESBURG SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(2908.47, 1309.0, 44.94) }, -- Annesburg Sheriff's Office
    ['BLACKWATER SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-767.63, -1266.52, 44.05) }, -- Blackwater Sheriff's Office
    ['STRAWBERRY SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-1811.99, -354.0, 164.65) }, -- Strawberry Sheriff's Office
    ['ARMADILLO SHERIFFS OFFICE']      = {restricted = true, coordinates = vector3(-3623.35, -2602.36, -13.34) }, -- Armadillo Sheriff's Office
    ['TUMBLEWEED SHERIFFS OFFICE']     = {restricted = true, coordinates = vector3(-5531.56, -2929.12, -1.36) }, -- Tumbleweed Sheriff's Office
    ['STATE OFFICES']             = {restricted = false, coordinates = vector3(2395.47, -1083.21, 52.75) }, -- CITY HALL
	['RAVENS REST MANOR']     = {restricted = false, coordinates = vector3(2370.42, -1221.95, 47.10) }, -- Ravens Rest Manor
    ['MARSHALLS: FORT WALLACE'] = {restricted = true, coordinates = vector3(338.95, 1504.24, 181.53) }, -- Marshal's Office
}

RegisterNetEvent("Telegram:recievedNoise")
AddEventHandler("Telegram:recievedNoise", function(station)
    local station = tostring(station)
    if station ~= 'regional' then
        if locations[station] then
            local options =
            {
                isDynamic = true
            }  
            --xSound:Destroy(station)
            --xSound:PlayUrlPos(station, "https://www.youtube.com/watch?v=JEKQtTxcr8I",1, locations[station].coordinates, options)
            --xSound:setSoundDynamic(station, true)
            --xSound:Distance(station, 35)
            --xSound:setVolumeMax(station, 0.3)
            Citizen.Wait(5000)
            --xSound:Destroy(station)
        end
    else
        for k, v in pairs(locations) do
            if v.restricted then
                station = k
                local options =
                {
                    isDynamic = true
                }  
                --xSound:Destroy(station)
                --xSound:PlayUrlPos(station, "https://www.youtube.com/watch?v=JEKQtTxcr8I",1, locations[station].coordinates, options)
                --xSound:setSoundDynamic(station, true)
                --xSound:Distance(station, 35)
                --xSound:setVolumeMax(station, 0.3)
                Citizen.Wait(250)
            end
        end
        Citizen.Wait(5000)
        for k, v in pairs(locations) do
            if v.restricted then
                station = k
                --xSound:Destroy(station)
                Citizen.Wait(500)
            end
        end
    end
end)

RegisterNetEvent("Telegram:ReturnMessages")
AddEventHandler("Telegram:ReturnMessages", function(data, recipient, station, restricted)
    index = 1
	telegrams = data
    if next(telegrams) == nil then
        SetNuiFocus(true, true)
        SendNUIMessage({station = station, recipient = recipient, message = false, restricted = restricted})
    else
        SetNuiFocus(true, true)
        SendNUIMessage({station = string.upper(telegrams[index].station), sender = telegrams[index].sender, recipient = telegrams[index].recipient, message = telegrams[index].message, restricted = restricted})
    end
end)

Citizen.CreateThread(function()
    SetNuiFocus(false, false)
    while true do
        for key, value in pairs(locations) do
           if IsPlayerNearCoords(value.coordinates.x, value.coordinates.y, value.coordinates.z) then
		        if not menu then
                    if IsControlPressed(0, `INPUT_GAME_MENU_TAB_LEFT_SECONDARY`) then
                        if not value.restricted then
						    TriggerServerEvent("Telegram:GetMessages", false, key)
                        else
                            TriggerServerEvent("Telegram:GetMessagesRestricted", false, key)
                        end
                        menu = true
                    end
                end
            end
        end
        Citizen.Wait(15)
    end
end)


RegisterNetEvent('Telegrams:Access')
AddEventHandler('Telegrams:Access', function(actionData, entityData)
    if actionData.type == 'inspect' then
        TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6* You notice it is a telegram machine")
        return
    end
    local stationZone = string.gsub(entityData.name, 'Telegram_', '')
    if locations[stationZone] then
        if not locations[stationZone].restricted then
            TriggerServerEvent("Telegram:GetMessages", false, stationZone)
        else
            TriggerServerEvent("Telegram:GetMessagesRestricted", false, stationZone)
        end
    end
end)

RegisterNetEvent('Telegrams:AccessTrain')
AddEventHandler('Telegrams:AccessTrain', function(actionData, entityData)
    if actionData.type == 'inspect' then
        TriggerEvent('chatMessage', "", {255, 0, 0}, " ^6* You notice it is a telegram machine")
        return
    end
    TriggerServerEvent("Telegram:GetMessagesRestricted", false, 'CORNWALL TRAIN OFFICE')
end)

function IsPlayerNearCoords(x, y, z)
    local playerx, playery, playerz = table.unpack(GetEntityCoords(PlayerPedId(), 0))
    local distance = GetDistanceBetweenCoords(playerx, playery, playerz, x, y, z, true)

    if distance < 2.0 then
        return true
    end
end

function CloseTelegram()
    index = 1
    menu = false
    SetNuiFocus(false, false)
    SendNUIMessage({})
end

RegisterNUICallback('back', function(data)
    if index > 1 and telegrams[index-1] ~= nil then
        index = index - 1
        SendNUIMessage({station = string.upper(telegrams[index].station), sender = telegrams[index].sender, recipient = telegrams[index].recipient, message = telegrams[index].message, restricted=data.restricted})
    end
end)

RegisterNUICallback('next', function(data)
    if index < #telegrams and telegrams[(index+1)] ~= nil then
        index = index + 1       
        SendNUIMessage({station = string.upper(telegrams[index].station), sender = telegrams[index].sender, recipient = telegrams[index].recipient, message = telegrams[index].message, restricted= data.restricted})
    end
end)

RegisterNUICallback('close', function()
    CloseTelegram()
end)

RegisterNUICallback('new', function(data)
    CloseTelegram()

    if data.recipientId == '' or data.message == '' then
        TriggerEvent('pNotify:SendNotification', {
            style = 'example',
            title = '',
            message = 'You cannot send a telegram without both a recipient and a message.',
            duration = 1000,
            custom = true
        })
        return
    end

    if data.recipientId == '0' and locations[data.station].restricted ~= true then
        TriggerEvent('pNotify:SendNotification', {
            style = 'example',
            title = '',
            message = 'You cannot send a telegram to law at that station.',
            duration = 1000,
            custom = true
        })
        return
    end

    if locations[data.station].restricted == true and data.recipientId ~= '0' then
        TriggerEvent('pNotify:SendNotification', {
            style = 'example',
            title = '',
            message = 'Only law can recieve telegrams at that station. Use P.O. Box #0 for the recipient.',
            duration = 5000,
            custom = true
        })
        return
    end
    TriggerServerEvent('Telegram:SendMessage', data.station, data.recipientId, data.message)
end)

RegisterNUICallback('delete', function(data)
    if telegrams[index] ~= nil then
        TriggerServerEvent("Telegram:DeleteMessage", telegrams[index].id, telegrams[index].station, data.restricted)
    end
end)

RegisterNUICallback('track', function()
    if telegrams[index].coordinates == nil then 
        return
    end
    TriggerEvent('pNotify:SendNotification', {
        style = 'example',
        title = '',
        message = 'You marked the location on your map.',
        duration = 1000,
        custom = true
    })
    TriggerEvent("gorp_saferobbery:CreateBlip", telegrams[index].sender, telegrams[index].coordinates)
end)

function GetPlayerServerIds()
    local players = {}

    for i = 0, 1200 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end

    return players
end