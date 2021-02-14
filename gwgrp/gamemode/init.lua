//----------------------//
//   GWGRP © Reserved   //
//¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯//


// Set The vital Gamemode info

Playermeta = FindMetaTable( "Player" )

GM.Version = "1.0.0"
GM.Name = "MilitaryRP"
GM.Author = "GWGRP Studios | Vaneix"
DeriveGamemode("sandbox")

DEFINE_BASECLASS("gamemode_sandbox")
GM.Sandbox = BaseClass



// Load The Main Files into the Client & Server sides
include('sh_init.lua')


// Load Server-side Modules
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")

// Load Serverside modules
_ ,  folders = file.Find( "gwgrp/gamemode/plugins/*", "LUA")
for _, folder in pairs( folders ) do
	files, fol = file.Find("gwgrp/gamemode/plugins/" .. folder .. "/sv_*.lua", "LUA")
	for _, document in pairs( files ) do
		include( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
	end
end

// Add the Shared Modules to the download list and also load it up on this side
_ ,  folders = file.Find( "gwgrp/gamemode/plugins/*", "LUA")
for _, folder in pairs( folders ) do
	files, fol = file.Find("gwgrp/gamemode/plugins/" .. folder .. "/sh_*.lua", "LUA")
	for _, document in pairs( files ) do
		AddCSLuaFile( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
		include( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
	end
end

// Add the Clientside Modules to the download list
_ ,  folders = file.Find( "gwgrp/gamemode/plugins/*", "LUA")
for _, folder in pairs( folders ) do
	files, fol = file.Find("gwgrp/gamemode/plugins/" .. folder .. "/cl_*.lua", "LUA")
	for _, document in pairs( files ) do
		AddCSLuaFile( "gwgrp/gamemode/plugins/" .. folder .. "/" .. document )
	end
end

// Load Order, Required for properly loading the code without errors.

CheckDataFolders()