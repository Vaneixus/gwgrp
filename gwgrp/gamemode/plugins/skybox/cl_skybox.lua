--[[--
--]]--
local ColorM = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 0.1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 1,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

--net.Receive("PlayersDarknessSimulation", function()
--	ColorM[ "$pp_colour_brightness" ] = net.ReadFloat()
--end )
hook.Add( "RenderScreenspaceEffects", "color_modify_example", function()
	DrawColorModify( ColorM )

end )

DrawSunbeams( 0.95, 1, 0.08, 0, 0 )