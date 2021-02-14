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
		MsgC( Color( 253, 103, 15 ), "[ServerSide]" )
		MsgC( Color( 255, 255, 255 ), " : " .. Message .. "\n" )
	end
end