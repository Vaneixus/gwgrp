--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--


util.AddNetworkString( "SyncPlayersDataNS" )
util.AddNetworkString( "FullNameUpdate" )
util.AddNetworkString( "PlayersDarknessSimulation" )
function Playermeta:SyncPlayerData()
	net.Start( "SyncPlayersDataNS" )
	net.WriteTable( playersdata[ self:SteamID64() ] )
	AddLog( "Sending in Player Data to : " .. self:Nick() .. "."  )
	net.Send( self )
end

function SyncPlayersData()
	for k, v in pairs( player.GetHumans() ) do
		self:SyncPlayerData()
	end
end