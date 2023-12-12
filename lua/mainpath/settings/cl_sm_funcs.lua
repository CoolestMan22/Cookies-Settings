SM = SM or {}
SM.Settings = SM.Settings or {}
local order = 0
local filename = "FG_CLSettings.txt"

-- ID and Datatable
function SM.CreateSetting(id, datatable)
    local Settings = SM.Settings
    order = order + 1
    datatable.name = datatable.name or "Unnamed Setting"
    datatable.desc = datatable.desc or ""
    datatable.min = datatable.min or 0
    datatable.max = datatable.max or 1
    datatable.default = datatable.default or datatable.min
    datatable.value = datatable.value or datatable.default -- if there is a value cool, otherwise go with the default which is already defaulted above
    datatable.click = datatable.click --what to do when the button is clicked, overwrites the default increment by 1 method
    datatable.change = datatable.change --what to do when the value changes
    datatable.order = order
    Settings[id] = datatable
end

-- ID
function SM.GetSetting(id)
    return SM.Settings[id]
end

function SM.GetValue(id, default)
    local setting = SM.GetSetting(id)

    return setting and setting.value or default
end

function SM.Set(id, value)
    local setting = SM.GetSetting(id)
    if not setting then return false end
    local prechange = setting.prechange

    if prechange then
        prechange(value) --new in argument, value is still unset
    end

    setting.value = value
    local change = setting.change

    if change then
        change(value) --new in argument for the fun of it
    end
end

function SM.Save()
    local tosave = {}

    for id, tab in pairs(SM.Settings) do
        tosave[id] = tab.value
    end

    file.Write(filename, util.TableToJSON(tosave, true))
end

function SM.Load()
    file.AsyncRead(filename, "DATA", function(_, _, status, data)
        local savedSettings = util.JSONToTable(data or "") or {}

        for id, setting in pairs(SM.Settings) do
            local saved = savedSettings[id]

            if saved then
                setting.value = saved
            end

            if setting.min == 0 and setting.max == 1 and setting.value == 1 and setting.change then
                -- Above checks the Following: Switch, Enabled, Run on change.
                setting.change(1) -- Know that its 1 from above
            end

            if setting.onload then
                setting.onload()
            end
        end
    end)
end