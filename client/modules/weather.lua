CurrentWeather = 'EXTRASUNNY'
local lastWeather = CurrentWeather
local baseTime = 0
local timeOffset = 0
local timer = 0
local freezeTime = false
local blackout = false
local Synced = true

-- Toggle Weather Sync
RegisterNetEvent('kd_weather:ToggleWeatherSync')
AddEventHandler('kd_weather:ToggleWeatherSync', function(state)
    Synced = state
end)

-- Update Current Server Weather
RegisterNetEvent('kd_weather:updateWeather')
AddEventHandler('kd_weather:updateWeather', function(NewWeather, newblackout)
	if not Synced then
        return
    end

    CurrentWeather = NewWeather
    blackout = newblackout
end)

-- Weather Sync Thread
Citizen.CreateThread(function()
    while true do
        if Synced then
            if lastWeather ~= CurrentWeather then
                lastWeather = CurrentWeather
                SetWeatherTypeOverTime(CurrentWeather, 15.0)
                Citizen.Wait(15000)
            end
            Citizen.Wait(100) -- Wait 0 seconds to prevent crashing.
            SetBlackout(blackout)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)
            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        else
            Citizen.Wait(500)
        end
    end
end)

-- Update Current Server Time
RegisterNetEvent('kd_weather:updateTime')
AddEventHandler('kd_weather:updateTime', function(base, offset, freeze)
    local hour = math.floor(((baseTime + timeOffset) / 60) % 24)
    local minute = math.floor((baseTime+timeOffset)%60)
    
	if not Synced then
        return
    end

    freezeTime = freeze
    timeOffset = offset
    baseTime = base

    if minute < 10 then 
        SendNUIMessage({
            action = "updateCurrent",
            currentTime = hour..':0'..minute,
            currentWeather =  CurrentWeather,
        })
    else
        SendNUIMessage({
            action = "updateCurrent",
            currentTime = hour..':'..minute,
            currentWeather =  CurrentWeather,
        })
    end
end)

-- Time Sync Thread
Citizen.CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        local sleep = 500

        if Synced then
            sleep = 100
            local newBaseTime = baseTime
            if GetGameTimer() - 500  > timer then
                newBaseTime = newBaseTime + 0.25
                timer = GetGameTimer()
            end
            if freezeTime then
                timeOffset = timeOffset + baseTime - newBaseTime			
            end
            baseTime = newBaseTime
            hour = math.floor(((baseTime+timeOffset)/60)%24)
            minute = math.floor((baseTime+timeOffset)%60)
            NetworkOverrideClockTime(hour, minute, 0)
        end

        Citizen.Wait(sleep)
    end
end)

-- Sync On Player Spawn
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('kd_weather:requestSync')
end)

RegisterNUICallback('getServerData', function(data, cb)
    local hour = math.floor(((baseTime + timeOffset) / 60) % 24)
    local minute = math.floor((baseTime+timeOffset)%60)

    if minute < 10 then 
        local serverData = {
            currentWeather =  CurrentWeather,
            currentTime = hour..':0'..minute
        }
        
        cb(serverData)
    else
        local serverData = {
            currentWeather =  CurrentWeather,
            currentTime = hour..':'..minute
        }
            
        cb(serverData)
    end
end)