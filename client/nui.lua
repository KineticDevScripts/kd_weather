RegisterNUICallback("savePlayerSettings", function(data, cb)
    TriggerServerEvent("kd_weather:savePlayerSettings", data)
end)

RegisterNUICallback("freezeWeather", function(data, cb)
    if not canUseAction('freezeWeather') then return end
    TriggerServerEvent("kd_weather:freezeWeather", data)
end)

RegisterNUICallback("freezeTime", function(data, cb)
    if not canUseAction('freezeTime') then return end
    TriggerServerEvent("kd_weather:freezeTime", data)
end)

RegisterNUICallback("setMorning", function(data, cb)
    if not canUseAction('setTime') then return end
    TriggerServerEvent("kd_weather:setMorning", data)
end)

RegisterNUICallback("setNoon", function(data, cb)
    if not canUseAction('setTime') then return end
    TriggerServerEvent("kd_weather:setNoon", data)
end)

RegisterNUICallback("setEvening", function(data, cb)
    if not canUseAction('setTime') then return end
    TriggerServerEvent("kd_weather:setEvening", data)
end)

RegisterNUICallback("setNight", function(data, cb)
    if not canUseAction('setTime') then return end
    TriggerServerEvent("kd_weather:setNight", data)
end)

RegisterNUICallback("setExtraSunny", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'EXTRASUNNY')
end)

RegisterNUICallback("setClear", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'CLEAR')
end)

RegisterNUICallback("setNeutral", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'NEUTRAL')
end)

RegisterNUICallback("setSmog", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'SMOG')
end)

RegisterNUICallback("setFoggy", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'FOGGY')
end)

RegisterNUICallback("setBlizzard", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'BLIZZARD')
end)

RegisterNUICallback("setOvercast", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'OVERCAST')
end)

RegisterNUICallback("setClouds", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'CLOUDS')
end)

RegisterNUICallback("setClearing", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'CLEARING')
end)

RegisterNUICallback("setRain", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'RAIN')
end)

RegisterNUICallback("setThunder", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'THUNDER')
end)

RegisterNUICallback("setSnow", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'SNOW')
end)

RegisterNUICallback("setSnowLight", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'SNOWLIGHT')
end)

RegisterNUICallback("setXmas", function(data, cb)
    if not canUseAction('setWeather') then return end
    TriggerServerEvent("kd_weather:setWeather", 'XMAS')
end)

RegisterNUICallback("manualSetTime", function(data, cb)
    if not canUseAction('setTime') then return end
    TriggerServerEvent("kd_weather:setTime", data.time)
end)

RegisterNUICallback("closeMenu", function(data, cb)
    LocalPlayer.state.menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "hideMenu"
    })
end)