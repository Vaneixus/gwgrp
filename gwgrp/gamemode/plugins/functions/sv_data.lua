--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--


datafolders = { "gamemode",
	"gamemode/playersdata",
	"gamemode/serverdata" 
} -- folders that need loading

playersdata = playersdata or {} --  Table for storing everyone's data

playerdatalayout = {
	FirstName = "Default",
	LastName = "Default",
	Side = "Default",
	SRank = 1
}

function CreateDataDirectories() -- Create all the directors
	AddLog( "Main data directory wasn't created, creating now.." ) -- Adds a log for Troubleshooting purposes
	for k, folder in pairs( datafolders ) do --  loops through a datafolders list, and creates them.
		file.CreateDir( folder ) -- Creates the folder
	end
	if CheckDataFolders() then -- After the proccess is done, We need to verify our work
		AddLog( "Main data directory has been created successfully" ) -- Adds a log for Troubleshooting purposes
	else -- if folder check fails, we need to retry creating them
		AddLog( "Problem has occured, DATA folder has not been created successfully, Retrying" )
		CreateDataDirectories()
	end
end

function CheckDataFolders()
	for k, v in pairs( datafolders ) do
		if not ( file.Exists( v, "DATA" ) ) then
			AddLog( "Found non-existant folder, Creating now" )
			file.CreateDir( v )
		end
	end
end

function Playermeta:LoadPlayerData() -- function to load a specific player data
	CheckDataFolders() -- Makes sure that the data folder is existant before procceding
	if  IsValid( self ) and self:IsPlayer() then -- Verifies that the given player is a real player and isn't a bot
		if file.Exists( "gamemode/playersdata/player_" .. tostring( self:SteamID64() ) .. ".txt", "DATA" ) then -- makes sure that the player's data is existant before procceding.
			local dataJ = file.Read( "gamemode/playersdata/player_" .. self:SteamID64() .. ".txt", "DATA" ) -- Reads the player's personal data txt file and stores the file content into a variable
			local data = util.JSONToTable( dataJ ) -- Transforms JSON Table to a normal LUA Table.
			playersdata[ self:SteamID64() ] = data -- stores the imported table into the global players data table with an identifier.
		else -- in case we can not find the file, we need to ask the players to make a new character
			playersdata[ self:SteamID64() ] = playerdatalayout -- because there's no data, we setup a new data for the player
			self:SavePlayerData() -- Saving the player data after the character Creation Proccess is done
		end
		self:SyncPlayerData()
	end
end
function LoadPlayersData()
	for k, v in pairs( player.GetAll() ) do
		v:LoadPlayerData()
	end
end

function LoadServerData() -- global function for loading everything
	for k, v in pairs( player.GetAll() ) do -- for every player, run the load function on them
		v:LoadPlayerData()
	end

end

function Playermeta:SavePlayerData() -- saves a specific player's data
	CheckDataFolders() -- we're making sure that the data folder still exists
	local dataJ = util.TableToJSON( playersdata[ self:SteamID64() ] ) -- storing the player's data table into a variable, and convert it to a JSON String
	file.Write( "gamemode/playersdata/player_" .. self:SteamID64() .. ".txt", dataJ ) -- Save the JSON String into an identified file.
end

function SavePlayersData()
	for k, v in pairs( player.GetAll() ) do
		v:SavePlayerData()
	end
end

function SavePlayerDataOnDisconnect()

end







--[[ Meta Functions ]]--

function Playermeta:GetPlayerTable()
	return playersdata[ self:SteamID64() ]
end

// Hooks
hook.Add( "PlayerInitialSpawn", "LoadPlayerDataOnJoin", function( ply ) ply:LoadPlayerData() end )
timer.Create( "BackupData", 300, 0, function() SavePlayersData() end)
hook.Add( "PlayerDisconnected", "SavePlayerDataOnDisconnectHook", SavePlayerDataOnDisconnectS )