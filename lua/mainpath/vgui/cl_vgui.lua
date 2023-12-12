--[[
        BUG LIST!
            1  {
            If the sub panels still do not show up, likely issue is due to the file split & SM.Settings is not filled

            Fix: No clue right now
               }

]]--

do
    -- The colors are self explanitory, they are colors and thats all it is!
    local DiscordMidGrey = Color(47, 49, 54);
    local DiscordContrastGrey = Color(34, 35, 39)
    local DiscordInsideGrey = Color(52, 55, 60);
    local HeadColor = Color(255, 89, 14);
    local WhiteIsh = Color(200, 200, 200, 200);
    local GreyIsh = Color(100, 100, 100, 100)

    local PANEL = {};  -- Makes the table for the panel
    local X = Material( "materials/vgui/closebutton.png", "noclamp smooth" ); -- This is the material for the close button, With the current material it will likely show up as a black and purple picture unless icon added to workshop

    -- Panel Initiate Function
    function PANEL:Init()
        SM.Load() -- Loads the settings manager
        self.PostInitcalled = false; -- No idea
        self.Buttons = {}; -- a buttons table for all of the switches and such
        self.MainPanel = vgui.Create("DIconLayout", self) -- The button holder
        NextPage = self:Add("DButton") -- Next Page button
        PrevPage = self:Add("DButton") -- Previous Page Button

        PageNumber = 1 -- Sets the default page number to 1
        
 
        self.startTime = SysTime() -- For blur, see line 267

        local ply = LocalPlayer()
        superadmin = ""

        if ply:GetUserGroup() == "superadmin" then
            superadmin = true 
        else
            superadmin = false
        end

        if superadmin then
            CreateSettingsButton = self:Add("DButton")

            CreateSettingsButton.Paint = function(s, w, h) -- Self, Width, Height
                surface.SetDrawColor(s:IsHovered() and WhiteIsh or Color(255, 255, 255)); -- Sets the hover color (and when not hovering)
                surface.Drawrect(0, 0, w, h);
            end

            CreateSettingsButton.DoClick = function()
                vgui.Create("SM.SettingsCreation")
            end

            CreateSettingsButton:SetSize(35, TextSize * 3)
            CreateSettingsButton:SetPos(w-45, h -35)
        end

        local i = 0; -- I as in iteration.
        
        -- Below goes through the for loop in the order that they are set in according to the "order" variable, see line 5 in settings/cl_settingslist
        for id, data in SortedPairsByMemberValue(SM.Settings, "order") do
            i = i + 1 --Every time you go through the for loop, the iteration (I) goes up by 1
            
            local name = data.name; -- The name of the setting
            local desc = data.desc; -- The description of the setting
            local switch = data.min == 0 and data.max == 1 -- Way to tell if its a switch or not
            
            local button = self.MainPanel:Add("DButton"); -- The settings panels (Well.. buttons in this case)

            self.Buttons[i] = button; -- for every interaction of button its added to a table in self.Buttons

            button.PerformLayout = function(s, w, h) -- Self, Width, Height
                s:SetPos(7 + 20, 5); -- Sets pos (I don't know exactly how this will work),
                s:SetTextColor(Color(0, 0, 0, 0)) -- Hacky way to get rid of the original text on the buttons (DO NOT DO s:SetText(""))
            end

            button.Paint = function(s, w, h) -- Self, Width, Height
                draw.RoundedBox(8, 0, 0, w, h, DiscordContrastGrey); -- Sets the color of the Panel (button) to (34, 35, 39)
               

                if (switch) then -- Checks if the button is a switch
                    local Red = Color(127, 25, 0);
                    local Green = Color(0, 127, 25);
                    -- local OverGreen = w/2-.2 -- The width position of where the green goes, Currently not used.
                    -- local OverRed = 0.2  -- The width position of where the red goes, Currently not used.

                    
                    if (tobool(data.value)) then -- Checks if the switch is 1 (true)
                        draw.RoundedBoxEx(10,  w/2-.2, h - 5.2, w / 2, 5, Green, false, false, false, true); -- Sets switch color to green (Switch bar being at bottom of panel (Button))
                    else
                        draw.RoundedBoxEx(10, 0.2, h - 5.2, w / 2, 5, Red, false, false, true, false) -- Sets switch color to red (Switch bar being at bottom of panel (Button))
                    end

                    
                else  -- if its not a switch, do whats below
                    -- below draws outlined text of what the current value is and what the max is, example 50/500
                    CookieSM.OutlinedText(data.value .. "/" .. data.max, "Size14", w-20-surface.GetTextSize("500/500")/2, 5, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_CENTER)
                end

                CookieSM.OutlinedText(name, "Size20", w/2, 3, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_CENTER); -- draws outlined text for the name of the settings
                CookieSM.OutlinedText(desc, "Size14", w/2, 20, Color(255, 255, 255), Color(0, 0, 0), TEXT_ALIGN_CENTER); -- draws outlined text for the description of the setting
            end

            button.DoClick = function(s) -- Self
                if data.click then --click overrides the button's doclick
					data.click() -- Executes the settings click function
					return -- Ends the buttons do click, wont continue
				end
                -- If there isnt a click function pre-made for the setting do whats below
				SM.Set(id, data.value >= data.max and data.min or data.value + 1) -- if value is max then set it to min, and if its min set it to max, but its its not either set the  value + 1 (The only case it would be either would be if its not a switch)
               --  print(tobool(data.value)) 
                -- print("^ for: " .. id)
            end
        end



        local iter = 0 -- iter as in iteration.
        for k, v in pairs(self.Buttons) do
            iter = iter + 1 --Every time you go through the for loop, the iteration (iter) goes up by 1

            if PageNumber == 1 then
                if iter > 14 then -- Hides every button over 14 that there is (If theres 15 buttons, it'll hide the 15th button)
                    v:Hide();
                else    -- Shows 14 buttons
                    v:Show();
                end
            end

            if PageNumber > 2 then
                v:Hide()
            end
        end

        

        NextPage.Paint = function(s, w, h) -- Self, Width, Height
            draw.RoundedBox(5, 0, 0, w, h, DiscordMidGrey)
            hovercolor = ""
            if PageNumber == 1 then
                hovercolor = Color(35, 185, 55)
            else
                hovercolor = Color(185, 35, 55)
            end

            surface.SetDrawColor(s:IsHovered() and hovercolor or Color(0, 0, 0, 0))
            surface.DrawOutlinedRect(1, 1, w, h, 2)
        end

        PrevPage.Paint = function(s, w, h) -- Self, Width, Height
            draw.RoundedBox(5, 0, 0, w, h, DiscordMidGrey)
            hovercolor = ""
            if PageNumber == 2 then
                hovercolor = Color(35, 185, 55)
            else
                hovercolor = Color(185, 35, 55)
            end

            surface.SetDrawColor(s:IsHovered() and hovercolor or Color(0, 0, 0, 0))
            surface.DrawOutlinedRect(1, 1, w, h, 2)
        end

        NextPage.DoClick = function()
            SM.Save()
            if PageNumber + 1 > 2 then return end
            PageNumber = PageNumber + 1

            
            local iter = 0
            for k, v in pairs(self.Buttons) do
                iter = iter + 1
                
                if PageNumber == 2 then
                    if iter > 14 and iter < 28 then
                        v:Show()
                    else
                        v:Hide()
                    end
                end

                if PageNumber >=3 then
                    v:Hide()
                end
            end
        
            print(PageNumber .. " is the page number now")
        end

        PrevPage.DoClick = function()
            SM.Save()
            if (PageNumber == 1) then print("Already at page 1") return end

            PageNumber = PageNumber - 1

            local iter = 0
            for k, v in pairs(self.Buttons) do
                iter = iter + 1
    
                if PageNumber == 1 then
                    if iter > 14 then
                        v:Hide();
                    else
                        v:Show();
                    end
                end

                if PageNumber == 2 then
                    if iter > 14 and iter < 28 then
                        v:Show()
                    else
                        v:Hide()
                    end
                end
            end

            print(PageNumber .. " is the page number now")
        end

        if PageNumber > 3 then
            PageNumber = 3
        end

        self.Exit = self:Add("DButton"); -- The exit button
        self.Exit:SetText(""); -- Sets the text of the close button to an empty string
        self.Exit.Paint = function(s, w, h) -- Self, Width, Height
            surface.SetDrawColor(0, 0, 0, 0); -- Transparent Background
            surface.DrawRect(0, 0, w, h);

            surface.SetDrawColor(s:IsHovered() and WhiteIsh or Color(255, 255, 255)); -- Sets the hover color (and when not hovering)
            surface.SetMaterial(X); -- Close button
            surface.DrawTexturedRect(2, 2, 15, 15);
        end

        self.Exit.DoClick = function()
            if IsValid(self) then
                SM.Save()
                self:Remove()
            end
        end
    end

    function PANEL:DrawOutlinedRect(x, y, w, h, size) -- X Pos, Y Pos, Width, Height, Size
		surface.DrawRect(size, 0, w - (size * 2), size);
		surface.DrawRect(size, h - size, w - (size * 2), size);
		surface.DrawRect(0, 0, size, h);
		surface.DrawRect(w - size, 0, size, h);
	end

	function PANEL:Think()
		do return end
		if (not self.PostInitCalled) then
			self:PostInit();

			self.PostInitCalled = true;
		end
	end

	function PANEL:PerformLayout(w, h) -- Width, Height

        local buttonsover14 = {}

		local bw = (w - 20 - 12)/2
		for i = 1, #self.Buttons do			
			local button = self.Buttons[i];
            if i >= 15 then
                table.insert(buttonsover14, button)
            end
			button:SetSize(bw, 60);
			if i%2 == 1 then
				button:SetPos(0, 65 * math.floor((i - 1)/2));
			else
				button:SetPos(bw + (20 - 12)/2, 65 * math.floor((i - 1)/2));

			end
		end

        for int = 1, #buttonsover14 do
            local button = buttonsover14[int]
            if int%2 == 1 then
                button:SetPos(0, 65 * math.floor((int - 1)/2));
            else
                button:SetPos(bw + (20 - 12)/2, 65 * math.floor((int - 1)/2))
            end
        end

        local TextSize = surface.GetTextSize(" >> ")

        NextPage:SetPos(w/2+TextSize-15, h-35)
        NextPage:SetSize(TextSize * 2, TextSize * 2)
        NextPage:SetText(">>")
        PrevPage:SetPos(w/2-TextSize-33, h-35)
        PrevPage:SetSize(TextSize * 2, TextSize * 2)
        PrevPage:SetText("<<")

        if PrevPage:IsHovered() then
            if (PageNumber == 1) then
                PrevPage:SetCursor("no")
            else
                PrevPage:SetCursor("hand")
            end
        end

        if NextPage:IsHovered() then
            if (PageNumber == 2) then
                NextPage:SetCursor("no")
            else
                NextPage:SetCursor("hand")
            end
        end


		self.MainPanel:SetPos(6, 60);
		self.MainPanel:SetSize(w, h - 43)
		self.Exit:SetPos(w - 30 , 10);
		self.Exit:SetSize(20, 20);
	end

	function PANEL:Paint(w, h)
        Derma_DrawBackgroundBlur(self, self.startTime)
		draw.RoundedBox(8,0,0,w,h,DiscordMidGrey)
		draw.RoundedBoxEx(8, 0, 0, w, 40, HeadColor, true, true, false, false)
        draw.RoundedBoxEx(8, 0, h-40, w, 40, DiscordInsideGrey, false, false, true, true)
		draw.RoundedBoxEx(0, 0, 40, w, 2, Color(255,255,255, 75), false, false, true, true);	
        draw.RoundedBoxEx(0, 0, h-41, w, 2, Color(255, 255, 255, 75), true, true, false, false)

        local ply = LocalPlayer()
		draw.SimpleText("Settings for " .. ply:Nick(), "Size28", w/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
        draw.SimpleText("Page", "Size14", w-(surface.GetTextSize("Page 1")), h-35, Color(255, 255, 255, 155, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER))
        draw.SimpleText(tostring(PageNumber), "Size14", w-(surface.GetTextSize("Page 1")), h-35, Color(255, 255, 255, 155, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER))
    end
	vgui.Register("SM.Settings", PANEL, "EditablePanel");
end

