local cnpc = {}

-- funtions
function SET_PED_RELATIONSHIP_GROUP_HASH ( iVar0, iParam0 )
    return Citizen.InvokeNative( 0xC80A74AC829DDD92, iVar0, _GET_DEFAULT_RELATIONSHIP_GROUP_HASH( iParam0 ) )
end

function _GET_DEFAULT_RELATIONSHIP_GROUP_HASH ( iParam0 )
    return Citizen.InvokeNative( 0x3CC4A718C258BDD0 , iParam0 );
end

function modelrequest( model )
    Citizen.CreateThread(function()
        RequestModel( model )
    end)
end

local spawnedPeds = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        for k,v in pairs(Config.BarberNpc) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - v.Pos.xyz)

            if distance < Config.DistanceSpawn and not spawnedPeds[k] then
                local spawnedPed = NearPed(v.Model, v.Pos, v.Heading)
                spawnedPeds[k] = { spawnedPed = spawnedPed }
            end
            
            if distance >= Config.DistanceSpawn and spawnedPeds[k] then
                if Config.FadeIn then
                    for i = 255, 0, -51 do
                        Citizen.Wait(50)
                        SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
                    end
                end
                DeletePed(spawnedPeds[k].spawnedPed)
                spawnedPeds[k] = nil
            end
        end
    end
end)

function NearPed(model, coords, heading)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(50)
    end
    spawnedPed = CreatePed(model, coords.x, coords.y, coords.z-1, heading, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    Citizen.InvokeNative(0x283978A15512B2FE, spawnedPed, true)
    SetEntityCanBeDamaged(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)
    FreezeEntityPosition(spawnedPed, true)
    Citizen.InvokeNative(0x9587913B9E772D29, spawnedped, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    table.insert(cnpc, spawnedPed)
    if Config.FadeIn then
        for i = 0, 255, 51 do
            Citizen.Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end
    return spawnedPed
end

AddEventHandler('onResourceStop', function(resource)
    if (resource == GetCurrentResourceName()) then
        for k,v in pairs(cnpc) do
            DeletePed(v)
            SetEntityAsNoLongerNeeded(v)
        end
    end
end)