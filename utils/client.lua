Utils = {
    notify = function(title, msg, type)
        lib.notify({
            title = title,
            description = msg,
            position = Config.notifyAlign,
            type = type
        })
    end
}