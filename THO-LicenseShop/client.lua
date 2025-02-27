-- client.lua

-- Reference coordinates and ped model from config.lua
local pedModel = Config.PedModel
local pedCoords = Config.PedCoords

Citizen.CreateThread(function()
    -- Create the ped entity at the specified coordinates
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(500)
    end

    local ped = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, 0.0, true, false)

    -- Set the ped as a mission entity to keep it in the game
    SetEntityAsMissionEntity(ped, true, true)

    -- Freeze the ped and make it invincible (optional)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)

    -- Set the ped to ignore the player
    TaskSetBlockingOfNonTemporaryEvents(ped, true)  -- Ped ignores non-temporary events like player interaction

    -- Set the heading (the direction the ped is facing)
    SetEntityHeading(ped, Config.PedHeading)   

    -- Now add the ox_target interaction after the ped is created
    exports['ox_target']:addLocalEntity(ped, {
        {
            name = 'weapon_license',
            icon = 'fas fa-gun',
            label = 'Buy Weapon License - $' .. Config.CostWeaponLicense,
            onSelect = function()
                TriggerServerEvent('license:purchase', 'weapon')
            end
        },
        {
            name = 'hunting_license',
            icon = 'fas fa-crosshairs',
            label = 'Buy Hunting License - $' .. Config.CostHuntingLicense,
            onSelect = function()
                TriggerServerEvent('license:purchase', 'hunting')
            end
        }
    })
end)
