-- server.lua

local ESX = nil
local CostWeaponLicense = 2500
local CostHuntingLicense = 1500
local WeaponLicenseName = 'weapon'
local HuntingLicenseName = 'hunting'
local WeaponLicenseItem = 'gun_license'  -- The item name for the weapon license
local HuntingLicenseItem = 'hunting_license'  -- The item name for the hunting license

-- Wait until ESX is ready
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    print("ESX is initialized successfully!") -- Debugging line
end)

RegisterServerEvent('license:purchase')
AddEventHandler('license:purchase', function(licenseType)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not xPlayer then
        print('Failed to get xPlayer for source:', _source)
        return
    end

    local PlayerMoney = xPlayer.getMoney()

    -- Use esx_license:checkLicense to check if the player already has the license
    TriggerEvent('esx_license:checkLicense', xPlayer.source, licenseType, function(hasLicense)
        if hasLicense then
            -- Player already has the license
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'You already have this license.')
            return
        end

        -- Handle license purchases based on the selected license type
        if licenseType == 'weapon' then
            if PlayerMoney >= CostWeaponLicense then
                xPlayer.removeMoney(CostWeaponLicense)
                -- Add the weapon license item to the player's inventory
                xPlayer.addInventoryItem(WeaponLicenseItem, 1)
                TriggerEvent('esx_license:addLicense', xPlayer.source, WeaponLicenseName)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'You have purchased the Weapon License!')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'You do not have enough money for the Weapon License.')
            end
        elseif licenseType == 'hunting' then
            if PlayerMoney >= CostHuntingLicense then
                xPlayer.removeMoney(CostHuntingLicense)
                -- Add the hunting license item to the player's inventory
                xPlayer.addInventoryItem(HuntingLicenseItem, 1)
                TriggerEvent('esx_license:addLicense', xPlayer.source, HuntingLicenseName)
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'You have purchased the Hunting License!')
            else
                TriggerClientEvent('esx:showNotification', xPlayer.source, 'You do not have enough money for the Hunting License.')
            end
        end
    end)
end)
