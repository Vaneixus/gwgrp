 --[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--


// Set The vital Gamemode info
GM.Version 		= "1.0.0"
GM.Name 		= "MilitaryRP"
GM.Author 		= "GWGRP Studios | STG Vaneix"
DeriveGamemode( "sandbox" )

DEFINE_BASECLASS( "gamemode_sandbox" )
GM.Sandbox = BaseClass

function GM:Initialize()
	local gm_sync = ents.Create( "gm_sync" )
	gm_sync:Spawn()
    self.Sandbox.Initialize(self)
end
