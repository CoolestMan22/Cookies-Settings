

-- Get Cur Path

function CookieSM.GetCurPath()
    return debug.getinfo(2).short_src;
end

-- Prints DEBUG

function CookieSM.Debug(s, ...)
    if (!CookieSM.DebugEnabled) then return end

    MsgC(Color(255, 0, 0, 255), "[");
    MsgC(Color(127, 255, 0, 255), "COOKIE DEBUG");
    MsgC(Color(255, 0, 0, 255), "] ");
    MsgC(Color(255, 255, 255, 255), string.format(s, ...));
    Msg("\n");
end

-- Gets Setting

function CookieSM.GetSetting(setting, default)
    local data = SM.Settings[setting]

	if data then
		return data.value and data.min == 0 and data.max == 1 and tobool(data.value) or data.value or default
	end
    return default;
end

-- Draws Outlined Text

function CookieSM.OutlinedText(str, font, posx, posy, clr, clr2, tpos1)
    draw.DrawText(str, font, posx + 2, posy + 1, clr2, tpos1);
    draw.DrawText(str, font, posx, posy, clr, tpos1);
end