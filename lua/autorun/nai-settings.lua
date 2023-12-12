CookieSM = CookieSM or {}
CookieSM.DebugEnabled = true

-- Load File
function CookieSM:LoadFile(path)
    local filename = path:GetFileFromFilename()
    filename = filename ~= "" and filename or path
    local flagCL = filename:StartWith("cl_")
    local flagSV = filename:StartWith("sv_")
    local flagSH = filename:StartWith("sh_")

    if SERVER then
        if flagCL or flagSH then
            AddCSLuaFile(path)
        end

        if flagSV or flagSH then
            include(path)
        end
    elseif flagCL or flagSH then
        include(path)
    end
end

-- Load Directory
function CookieSM:LoadDir(dir)
    local files, folders = file.Find(dir .. "/*", "LUA")

    for _, v in ipairs(folders) do
        self:LoadDir(dir .. "/" .. v)
        print("Directory: " .. v .. " loaded")
    end

    for _, v in ipairs(files) do
        self:LoadFile(dir .. "/" .. v)
        print("File: " .. v .. " loaded")

        if v == "cl_vgui.lua" then
            self:LoadFile("mainpath/settings/cl_created_settings.lua")
            print("settings/cl_created_settings.lua loaded alongside vgui/cl_vgui.lua")
        end
    end
end

CookieSM:LoadDir("mainpath")

hook.Add("OnPlayerChat", "MakingTheSettingsCommand", function(ply, txt)
    if txt == "!settings" then
        local size

        if table.Count(SM.Settings) >= 14 then
            size = 14
        else
            size = table.Count(SM.Settings)
        end

        local ui = vgui.Create("SM.Settings")
        ui:SetSize(1000, 43 + math.ceil(size * 68 / 2) + 55)
        ui:Center()
        ui:MakePopup()
    end
end)