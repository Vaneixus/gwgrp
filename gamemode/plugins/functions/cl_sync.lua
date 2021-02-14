--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--

PlayerDataLayout = {
	FirstName = "Default",
	LastName = "Default",
	Side = "Default",
	SRank = 1
}
playerdata = playerdata or PlayerDataLayout
net.Receive( "SyncPlayersDataNS", function()
	AddLog( "Received Player Data, Upldating Table immediately" )
	playerdata = net.ReadTable()
end )

function UpdatePlayerData( Key, Val )
	if Key == ( "Side" or "SRank" ) then return end
	if Key == "Name" then
		net.Start( "SyncPlayersDataNS" )
		net.WriteString( Val )
		net.SendToServer()
	end
end