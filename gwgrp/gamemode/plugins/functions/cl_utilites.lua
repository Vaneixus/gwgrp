--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--


function FormattedTime()

	local curtime = CurTime() -- We are using a more accurate timer function to time with real world time
	local minutes = math.floor( curtime / 60 ) -- gives us a natural number of minutes, without any decimals
	local seconds = math.floor( curtime - ( minutes * 60 ) ) -- gives us the seconds

	return minutes, seconds -- returns the minutes and seconds
end

function AddLog( Message, Player )
	if not IsValid( Player ) then
		local minutes, seconds = FormattedTime()
		MsgC( Color( 255, 0, 0 ), "[GWGRP]" )
		MsgC( Color( 194, 191, 186 ), "[ " )
		MsgC( Color( 255, 255, 255 ), minutes )
		MsgC( Color( 194, 191, 186 ), ":" )
		MsgC( Color( 255, 255, 255 ), seconds )
		MsgC( Color( 194, 191, 186 ), " ]" )
		MsgC( Color( 0, 0, 255 ), "[Clientside]" )
		MsgC( Color( 255, 255, 255 ), " : " .. Message .. "\n" )
	end
end
resource.AddFile( "materials/gwgrp/pp/vignette.png" )

local vignette = Material( "gwgrp/pp/vignette.png" )
local blur = Material( "pp/blurscreen" )

function DrawBlur( panel )
	local x, y = panel:LocalToScreen( 0, 0 )
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor( 255, 255, 255 )
	surface.SetMaterial( blur )
	for i = 1, 3 do
		blur:SetFloat("$blur", ( i / 3 ) * 4 )
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( x * -1, y * -1, scrW, scrH )
	end
end

function DrawVignette()
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.SetMaterial( vignette )
	surface.DrawTexturedRect( 0, 0, scrW, scrH )
end

function ContainsNumber( text )
	for _, char in pairs( text ) do
		if tonumber(char) == nil then
			return true
		end
	end
	return false
end