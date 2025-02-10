ESX = exports["es_extended"]:getSharedObject()

local playerSettings = {} 
CurrentWeather = "EXTRASUNNY"
local baseTime = 0
local timeOffset = 0
local freezeTime = false
local blackout = false
local newWeatherTimer = 10
DynamicWeather = Config.enableDynamicWeather

-------------------- DON'T TOUCH --------------------
AvailableWeatherTypes = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN',
}

RegisterServerEvent('kd_weather:requestSync')
AddEventHandler('kd_weather:requestSync', function()
    TriggerClientEvent('kd_weather:updateWeather', -1, CurrentWeather, blackout)
    TriggerClientEvent('kd_weather:updateTime', -1, baseTime, timeOffset, freezeTime)
end)

RegisterServerEvent('kd_weather:freezeWeather')
AddEventHandler('kd_weather:freezeWeather', function()
    if checkGroup(source, true) then
        DynamicWeather = not DynamicWeather

        if not DynamicWeather then
            Utils.notify('Success', L('notify.success.weatherFrozen'), 'success', source)
        else
            Utils.notify('Success', L('notify.success.weatherUnfrozen'), 'success', source)
        end
    end
end)

RegisterServerEvent('kd_weather:freezeTime')
AddEventHandler('kd_weather:freezeTime', function()
    if checkGroup(source, true) then
        freezeTime = not freezeTime

        if freezeTime then
            Utils.notify('Success', L('notify.success.timeFrozen'), 'success', source)
        else
            Utils.notify('Success', L('notify.success.timeUnfrozen'), 'success', source)
        end
    end
end)

RegisterServerEvent('kd_weather:setMorning')
AddEventHandler('kd_weather:setMorning', function()
    if checkGroup(source, true) then
        ShiftToMinute(0)
        ShiftToHour(9)
        TriggerEvent('kd_weather:requestSync')

        Utils.notify('Success', L('notify.success.setMorning'), 'success', source)
    end
end)

RegisterServerEvent('kd_weather:setNoon')
AddEventHandler('kd_weather:setNoon', function()
    if checkGroup(source, true) then
        ShiftToMinute(0)
        ShiftToHour(12)
        TriggerEvent('kd_weather:requestSync')

        Utils.notify('Success', L('notify.success.setNoon'), 'success', source)
    end
end)

RegisterServerEvent('kd_weather:setEvening')
AddEventHandler('kd_weather:setEvening', function()
    if checkGroup(source, true) then
        ShiftToMinute(0)
        ShiftToHour(18)
        TriggerEvent('kd_weather:requestSync')

        Utils.notify('Success', L('notify.success.setEvening'), 'success', source)
    end
end)

RegisterServerEvent('kd_weather:setNight')
AddEventHandler('kd_weather:setNight', function()
    if checkGroup(source, true) then
        ShiftToMinute(0)
        ShiftToHour(23)
        TriggerEvent('kd_weather:requestSync')

        Utils.notify('Success', L('notify.success.setNight'), 'success', source)
    end
end)

RegisterServerEvent('kd_weather:setTime')
AddEventHandler('kd_weather:setTime', function(time)
    if checkGroup(source, true) then
        ShiftToMinute(0)
        ShiftToHour(time)
        TriggerEvent('kd_weather:requestSync')

        Utils.notify('Success', L('notify.success.setTime'):format(time), 'success', source)
    end
end)

RegisterServerEvent('kd_weather:setWeather')
AddEventHandler('kd_weather:setWeather', function(weather)
    if checkGroup(source, true) then
        local validWeatherType = false

        for i, wtype in ipairs(AvailableWeatherTypes) do
            if wtype == string.upper(weather) then
                validWeatherType = true
            end
        end

        if validWeatherType then
            CurrentWeather = string.upper(weather)
            newWeatherTimer = 10
            TriggerEvent('kd_weather:requestSync')
            Utils.notify('Success', L('notify.success.setTime'):format(string.upper(weather)), 'success', source)
        else
            Utils.notify('Error', L('notify.error.invalidWeatherType'), 'error', source)
        end
    end
end)

function NextWeatherStage()
    if CurrentWeather == "CLEAR" or CurrentWeather == "CLOUDS" or CurrentWeather == "EXTRASUNNY" then
        local new = math.random(1, 2)
        if new == 1 then
            CurrentWeather = "CLEARING"
        else
            CurrentWeather = "OVERCAST"
        end
    elseif CurrentWeather == "CLEARING" or CurrentWeather == "OVERCAST" then
        local new = math.random(1, 6)
        if new == 1 then
            if CurrentWeather == "CLEARING" then CurrentWeather = "FOGGY" else CurrentWeather = "RAIN" end
        elseif new == 2 then
            CurrentWeather = "CLOUDS"
        elseif new == 3 then
            CurrentWeather = "CLEAR"
        elseif new == 4 then
            CurrentWeather = "EXTRASUNNY"
        elseif new == 5 then
            CurrentWeather = "SMOG"
        else
            CurrentWeather = "FOGGY"
        end
    elseif CurrentWeather == "THUNDER" or CurrentWeather == "RAIN" then
        CurrentWeather = "CLEARING"
    elseif CurrentWeather == "SMOG" or CurrentWeather == "FOGGY" then
        CurrentWeather = "CLEAR"
    end
    TriggerEvent("kd_weather:requestSync")
end

function ShiftToMinute(minute)
    timeOffset = timeOffset - (((baseTime + timeOffset) % 60) - minute)
end

function ShiftToHour(hour)
    timeOffset = timeOffset - ((((baseTime + timeOffset) / 60) % 24) - hour) * 60
end

ESX.RegisterServerCallback('kd_weather:checkGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()

    if checkGroup(source, false) then
        cb(true, group)
    else 
        cb(false)
    end
end)

function checkGroup(player, doAction)
    local xPlayer = ESX.GetPlayerFromId(player)
    local playerGroup = xPlayer.getGroup()

    if Config.groups[playerGroup] then
        return true
    end

    if doAction then
        xPlayer.kick(L('notify.error.notAdmin'))
    end

    return false
end

function loadSettings()
    local file = LoadResourceFile(GetCurrentResourceName(), "data/player-settings.json")
    if file then
        playerSettings = json.decode(file) or {}
    end
end

function saveSettings()
    SaveResourceFile(GetCurrentResourceName(), "data/player-settings.json", json.encode(playerSettings, { indent = true }), -1)
end

RegisterNetEvent("kd_weather:getPlayerSettings")
AddEventHandler("kd_weather:getPlayerSettings", function()
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    if playerSettings[identifier] then
        TriggerClientEvent("kd_weather:sendPlayerSettings", src, playerSettings[identifier])
    else
        -- Default settings
        playerSettings[identifier] = Config.defaultSettings
        TriggerClientEvent("kd_weather:sendPlayerSettings", src, playerSettings[identifier])
    end
end)

RegisterNetEvent("kd_weather:savePlayerSettings")
AddEventHandler("kd_weather:savePlayerSettings", function(newSettings)
    local src = source
    local identifier = GetPlayerIdentifier(src, 0)

    playerSettings[identifier] = newSettings
    saveSettings()
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local newBaseTime = os.time(os.date("!*t")) / 2 + 360
        if freezeTime then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerClientEvent('kd_weather:updateTime', -1, baseTime, timeOffset, freezeTime)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('kd_weather:updateWeather', -1, CurrentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        newWeatherTimer = newWeatherTimer - 1
        Citizen.Wait(60000)
        if newWeatherTimer == 0 then
            if DynamicWeather then
                NextWeatherStage()
            end
            newWeatherTimer = 10
        end
    end
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        loadSettings()
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        saveSettings()
    end
end)

-- Return Current Weather Type (EXTRASUNNY)
exports('getWeather', function()
    return CurrentWeather
end)

-- Return Current Server Time (H)
exports('getTimeHour', function()
    local hour = math.floor(((baseTime + timeOffset) / 60) % 24)
    return hour
end)

-- Return Current Server Time (H:M)
exports('getTime', function()
    local hour = math.floor(((baseTime + timeOffset) / 60) % 24)
    local minute = math.floor((baseTime+timeOffset)%60)

    return ('%s:%s'):format(hour, minute)
end)