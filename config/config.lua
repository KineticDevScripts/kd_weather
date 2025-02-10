Config = {
    locale = 'en', -- only en, you can edit or add more in locales folder
    notifyAlign = 'top', -- 'top' or 'top-right' or 'top-left' or 'bottom' or 'bottom-right' or 'bottom-left' or 'center-right' or 'center-left'

    enableDynamicWeather = false, -- enable dynamic weather changes?

    defaultSettings = {
        primaryColor = "#ff0000",
        secondaryColor = "#0d0c0c",
        menuSize = 65, -- recommended default
        menuPosition = { 
            top = 178, -- recommended default
            left = 436 -- recommended default
        } 
    },

    commands = {
        openMenu = {
            enabled = true, -- enable command?
            name = 'weather', -- command name
            keybind = {
                enabled = false, -- enable keybind?
                key = 'M', -- default key
                help = 'Open the weather panel' -- keybind help
            }
        }
    },

    groups = { -- what groups can access what actions?
        ['admin'] = {
            ['open'] = true,
            ['freezeWeather'] = true,
            ['freezeTime'] = true,
            ['setWeather'] = true,
            ['setTime'] = true,
        },

        ['mod'] = {
            ['open'] = false,
            ['freezeWeather'] = false,
            ['freezeTime'] = false,
            ['setWeather'] = false,
            ['setTime'] = false,
        },
    }
}