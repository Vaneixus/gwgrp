 --[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--

Commands = {}

function AddCommand( command, functionID ) -- function to add new Chat commands
	Commands[command] = functionID -- Adds the command to a list as a identifier for the function
end

local function CheckifCommand( ply, arguments ) -- function ran on each text input, to check if any commands are called
	arguments = string.Explode( " ", arguments ) -- divides the text input, for easier identification of the command
	if ( Commands[ string.lower( arguments[1] ) ] != nil ) then -- makes sure that the first argument is an actual command
		Commands[ string.lower( arguments[1] ) ]( ply, unpack( arguments, 2 ) ) -- runs the function and gives it arguments
	end
end

hook.Add( "PlayerSay", "CommandCheck", CheckifCommand ) -- calls the command check function whenever there's a text input.