Utils = {
    notify = function(title, msg, type, player)
        TriggerClientEvent('ox_lib:notify', player, {
            title = title,
            description = msg,
            position = Config.notifyAlign,
            type = type
        })
    end
}