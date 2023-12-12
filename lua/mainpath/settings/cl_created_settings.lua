local filename = "FG_CLSettings.txt"
local path = CookieSM.GetCurPath();

SM.CreateSetting("multicore_rendering", {
	name = "Multicore Rendering",
	desc = "Enable or disable multicore rendering. This'll increase performance.",
	change = function(new)
		if new == 1 then
			LocalPlayer():ConCommand("gmod_mcore_test 1; mat_queue_mode -1; cl_threaded_bone_setup 1");
		else
			LocalPlayer():ConCommand("gmod_mcore_test 0; mat_queue_mode -1; cl_threaded_bone_setup 0");
		end
	end
});

SM.CreateSetting("hud", {
	name = "HUD",
	desc = "Switch between huds",
	default = 2,
	min = 1,
	max = 2,
});

SM.CreateSetting("disableModels", {
	name = "Disable Custom Models",
	desc = "Enable or disable the custom models, good if you're afraid of Shaggy",
	change = function(new)
		if new == 1 then
			hook.Add("PostPlayerDraw", "IHateFortnite_PostPlayerDraw", function(v)
				if v==LocalPlayer() then return end
				
				curModel = v:getJobTable().model
				if type(curModel)=="table" then 
					v:SetModel(curModel[1])
				elseif type(curModel)=="string" then 
					v:SetModel(curModel)
				end
			end)
		else
			hook.Remove("PostPlayerDraw", "IHateFortnite_PostPlayerDraw")
		end
	end
})

SM.CreateSetting("disableHalos", {
	name = "Disable 'Halos'",
	desc = "Disables the outlining effect (turn on for better performance)",
	change = function(new)
		if new == 1 then
			hook.Remove("PostDrawEffects", "RenderHalos")
		else
			hook.Add("PostDrawEffects", "RenderHalos", function()
				hook.Run("PreDrawHalos")
			end)
			LocalPlayer():ChatPrint("You may need to relog to re-enable halos")
		end
	end
})

SM.CreateSetting("spawnmenuDarkmode", {
	name = "Darkmode spawnmenu",
    desc = "Enable for darkmode on the spawn menu (requires restart to fix text)\nThis requires you to have the Darkmode UI addon installed",
	change = function(new)
		if new == 1 then
			if !steamworks.IsSubscribed("888392108") then
				LocalPlayer():ChatPrint("You need to download the Dark UI:")
				LocalPlayer():ChatPrint("https://steamcommunity.com/sharedfiles/filedetails/?id=888392108")
				gui.OpenURL("https://steamcommunity.com/sharedfiles/filedetails/?id=888392108")
				return
			end
			
			if !steamworks.ShouldMountAddon("888392108") then
				LocalPlayer():ChatPrint("You don't seem to have the darkmode UI enabled in your addons")
				return
			end
			
			if !file.Exists("materials/gwenskin/cieroskin.png","GAME") then
				LocalPlayer():ChatPrint("Something else went wrong with your darkmode spawn menu, try reinstalling it")
				return
			end
			
			RunConsoleCommand("enabledarkui","1")
		else
			RunConsoleCommand("enabledarkui","0")
		end
	end
})

SM.CreateSetting("noflipmessage", {
	name = "Disable flip messages",
    desc = "Disables the coinflip chat messages",
})

SM.CreateSetting("nochatbubbles", {
	name = "Disable chat bubbles",
    desc = "For those that really want to look at chat to see what the no mic has to say",
})


SM.CreateSetting("nochatcondensing", {
	name = "Disable chat condensing",
	desc = "Disable the feature that condenses chat when people put the same message repeatedly",
	change = function(new)
		if new == 1 then
			GLOBAL_DisableChatCondensing = true
		else
			GLOBAL_DisableChatCondensing = false
		end
	end
})

SM.CreateSetting("disablepac3", {
	name = "Disable Accessories (PAC3)",
	desc = "Accessories are a huge performance eater, toggle this or lower the render distance\nyou may need to toggle this if people look funny",
	change = function(new)
		if new == 1 then
			RunConsoleCommand("pac_enable","0")
		else
			RunConsoleCommand("pac_enable","1")
		end
	end
})

SM.CreateSetting("showlaws", {
	name = "Show Laws on Screen",
	desc = "Number is text opacity",
	min = 0,
	max = 255,
	click = function()
		local value = SM.GetValue("showlaws", 0)
		value = 
					value >= 255 and 0 or
					value + 25 > 255 and 255 or
					value + 25
		SM.Set("showlaws",value)
	end,
	change = function(new)
        print("Value changed to: " .. SM.GetValue("setting9", 0))
	end,
	onload = function(new)
        print("Value set to: " .. SM.GetValue("setting9", 0))
	end
})

SM.CreateSetting("jobsalphabetized", {
	name = "Alphabetize the jobs menu",
	desc = "Toggleable since a lot of people dislike how it looks",
	change = function(new)
		if new == 1 then
			GLOBAL_AlphabetizeJobsMenu = true
		else
			GLOBAL_AlphabetizeJobsMenu = false
		end
	end
})

SM.CreateSetting("disablerainbowtext", {
	name = "Disable rainbow text",
	desc = "Do you hate rainbows in chat? Turns this on if you do",
	change = function(new)
		if new == 1 then
			GLOBAL_DisableRainbowText = true
		else
			GLOBAL_DisableRainbowText = false
		end
	end
})

SM.CreateSetting("justclicking", {
	name = "Click",
	desc = "Clicky clicky",
    default = 0,
	max = math.huge,
	click = function()
		SM.Set("justclicking",SM.GetValue("justclicking", 1) + 1)
	end,
})

SM.CreateSetting("fishysetting", {
	name = "Fish Limit",
	desc = "Incase you really like fish..\nor your machine cant handle them",
	min = 0,
	max = 500,
	click = function()
		local value = SM.GetValue("fishysetting", 0)
		value = 
					value >= 500 and 0 or
					value + 50 > 500 and 500 or
					value + 50
		SM.Set("fishysetting",value)
	end,
	change = function(new)
        print("Value changed to: " .. SM.GetValue("setting9", 0))
	end,
	onload = function(new)
        print("Value set to: " .. SM.GetValue("setting9", 0))
	end
})

SM.CreateSetting("testing", {
    name = "test",
    desc = "test",
    change = function(new)
        if new == 1 then
            print("enabled")
        else
            print("disabled")
        end
    end
})

SM.CreateSetting("misc setting1", {
    desc = "Misc setting"
})
SM.CreateSetting("misc setting2", {
    desc = "Misc setting"
})
SM.CreateSetting("misc setting3", {
    desc = "Misc setting"
})
SM.CreateSetting("misc setting4", {
    desc = "Misc setting"
})
SM.CreateSetting("misc setting5", {
    desc = "Misc setting"
})

hook.Add("InitPostEntity", path, function()
    SM.Load()
end)