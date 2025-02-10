local ESX = exports['es_extended']:getSharedObject()

LocalPlayer.state.menuOpen = false
local group

if Config.commands['openMenu'].enabled then
    RegisterCommand(Config.commands['openMenu'].name, function(source, args)
        ESX.TriggerServerCallback('kd_weather:checkGroup', function(canOpen, playerGroup)
            if canOpen then
                group = playerGroup
                if canUseAction('open') then
                    openMenu()
                end
            else
                Utils.notify('Error', L('notify.error.notAdmin'), 'error')
            end
        end)
    end)
end

if Config.commands['openMenu'].keybind.enabled then
    local keybind = lib.addKeybind({
        name = 'adminmenu',
        description = Config.commands['openMenu'].keybind.help,
        defaultKey = Config.commands['openMenu'].keybind.key,
        onPressed = function(self)
            ESX.TriggerServerCallback('kd_weather:checkGroup', function(canOpen, playerGroup)
                if canOpen then
                    group = playerGroup
                    if canUseAction('open') then
                        openMenu()
                    end
                else
                    Utils.notify('Error', L('notify.error.notAdmin'), 'error')
                end
            end)
        end
    })
end 

RegisterNetEvent("kd_weather:sendPlayerSettings")
AddEventHandler("kd_weather:sendPlayerSettings", function(settings)
    SendNUIMessage({
        action = "applySettings",
        settings = settings,
    })
end)

Citizen.CreateThread(function()
    TriggerServerEvent("kd_weather:getPlayerSettings")
end)

function openMenu()
    if not canUseAction('open') then return end
    LocalPlayer.state.menuOpen = not LocalPlayer.state.menuOpen
    SetNuiFocus(LocalPlayer.state.menuOpen, LocalPlayer.state.menuOpen)
    SendNUIMessage({
        action = LocalPlayer.state.menuOpen and "showMenu" or "hideMenu"
    })
end

function canUseAction(menu)
    if Config.groups[group] then
        if Config.groups[group][menu] then
            return true
        else
            return Utils.notify('Error', L('notify.error.noAccess'), 'error')
        end
    else 
        return Utils.notify('Error', L('notify.error.groupNotAllowed'), 'error')
    end
end