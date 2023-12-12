do
    local PANEL = {}
    local X = Material( "materials/vgui/closebutton.png", "noclamp smooth");

    function PANEL:Init(ply)
        SM.Load()

        self.MainFrame = vgui.Create("DPanel", self)
        self.MainFrame:SetSize(500, 98+math.ceil(table.Count(SM.Settings)*68) / 4)
        self.MainFrame:Center()
        self.MainFrame:MakePopup()

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

    PANEL:PerformLayout(w, h);
        self.Exit:SEtPos(w - 20, 10);
        self.Exit:SetSize(20, 20)
    end

    function PANEL:Paint(w, h)
        draw.RoundedBoxEx(8, 0, 0, w, 40, HeadColor, true, true, false, false)
        draw.SimpleText("Settings Creation", "Size28", w/2, 5, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end 
    vgui.Register("SM.SettingsCreation", PANEL, "EditablePanel")
end