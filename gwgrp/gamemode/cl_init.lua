//----------------------//
//   GWGRP © Reserved   //
//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯//


print("gamemode/cl_init.lua has been loaded")
DeriveGamemode( "sandbox" )

//Load Main Files
AddCSLuaFile("sh_init.lua")


// Load Clientside modules
_ ,  folders = file.Find( "gwgrp/gamemode/plugins/*", "LUA")
for _, folder in pairs( folders ) do
	files, fol = file.Find("gwgrp/gamemode/plugins/" .. folder .. "/cl_*.lua", "LUA")
	for key, document in pairs( files ) do
		include( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
	end
end

// Load Shared Moduless
_ ,  folders = file.Find( "gwgrp/gamemode/plugins/*", "LUA")
for _, folder in pairs( folders ) do
	files, fol = file.Find("gwgrp/gamemode/plugins/" .. folder .. "/sh_*.lua", "LUA")
	for key, document in pairs( files ) do
		AddCSLuaFile( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
		include( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
	end
end