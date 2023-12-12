local order

do
    local i = 0

    order = function()
        i = i + 1

        return i
    end
end

Settings = {
    setting1 = {
        order = order(),
        name = "Setting 1",
        desc = "This is setting 1",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting2 = {
        order = order(),
        name = "Setting 2",
        desc = "This is setting 2\nIt has 2 lines",
        current = 2,
        useSwitch = false,
        max = 2,
        click = function(i, self)
            local setting2 = CookieSM:GetSetting("setting2", 1)

            if setting2 == 2 then
                self.ChangeSetting("setting2", 1)
            else
                self.ChangeSetting("setting2", 2)
            end
        end
    },
    setting3 = {
        order = order(),
        name = "Setting 3",
        desc = "This is setting 3\nIt also has 2 lines",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting4 = {
        order = order(),
        name = "Setting 4",
        desc = "This is setting 4",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting5 = {
        order = order(),
        name = "Setting 5",
        desc = "This is setting 5",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting6 = {
        order = order(),
        name = "Setting 6",
        desc = "This is setting 6",
        enabled = false,
        useSwitch = true,
        onEnable = function() end,
        onDisable = function() end
    },
    setting7 = {
        order = order(),
        name = "Setting 7",
        desc = "This is setting 7",
        enabled = false,
        useSwitch = true,
        onEnable = function() end,
        onDisable = function() end
    },
    setting8 = {
        order = order(),
        name = "Setting 8",
        desc = "This is setting 8",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting9 = {
        order = order(),
        name = "Setting 9",
        desc = "This is setting 9\nIt also has 2 lines",
        current = 0,
        useSwitch = false,
        max = 256,
        click = function(i, self)
            local S9 = CookieSM:GetSetting("setting9", 0)
            S9 = S9 >= 255 and 0 or S9 + 25 > 255 and 255 or S9 + 25
            self:ChangeSetting("setting9", S9)
            print("Changed")
        end,
        onLoad = function()
            print("Set")
        end
    },
    setting10 = {
        order = order(),
        name = "Setting 10",
        desc = "This is setting 10",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting11 = {
        order = order(),
        name = "Setting 11",
        desc = "This is setting 11",
        enabled = false,
        useSwitch = true,
        onEnable = function()
            print("Enabled")
        end,
        onDisable = function()
            print("Disabled")
        end
    },
    setting12 = {
        order = order(),
        name = "Setting 12",
        desc = "This is setting 12",
        current = 1,
        max = 1e9,
        click = function(i, self)
            local S12 = CookieSM:GetSetting("setting12", 1)
            self:ChangeSetting("setting12", S12 + 1)
        end
    }
}