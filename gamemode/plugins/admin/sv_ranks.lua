--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--

local RanksTable = {}

function AddRank( RankName, Admin, Mod, Manager, Owner, VIPLevel, ID )
	if not isnumber( ID ) then AddLog( "A Rank has an ID that is not a Number." ) return end
	if not isstring( RankName ) then AddLog( "Rank Name of (" .. ID .. ") is not a String." ) return end
	if not isbool( Admin ) then AddLog( "Admin boolean of (" .. ID .. ") is not a boolean." ) return end
	if not isbool( Mod ) then AddLog( "Mod boolean of(" .. ID .. ") is not a boolean." ) return end
	if not isbool( Manager ) then AddLog( "Manager boolean of (" .. ID .. ") is not a boolean." ) return end
	if not isbool( Owner ) then AddLog( "Owner boolean of (" .. ID .. ") is not a boolean." ) return end
	if not isnumber(VIPLevel) then AddLog( "VIPLevel of (" .. ID .. ") is not a number." ) return end


	local temptable = {
	name = RankName,
	IsAdmin = Admin,
	IsMod = Manager,
	IsOwner = Owner,
	VIP = VIPLevel
}
	table.insert( RanksTable, ID, temptable )
end


--[[  Meta functions  ]]--
function Playermeta:SetRank( RankID )
	if isnumber( RankID ) then
		self:GetPlayerTable()[ srank ] = RankID
	elseif isstring( RankID ) then
		for ID, Table in pairs( RanksTable ) do
			if ( Table[ name ] == RankID ) and ( ID <= #RanksTable ) then
				self:GetPlayerTable()[ srank ] = ID
				return
			end
		end
	else
		AddLog( "A function has called the SetRank function on" .. Playermeta:Nick() .. "but has not given the right RankID" )
	end
end

function Playermeta:Promote( Caller )
	if not IsPlayer(Caller) then return end
	local rank = self:SetRank( [ srank ] + 1  ) -- We locally cache the rankid so we can do math on it
	if ( rank <= #RanksTable ) and ( rank > 1 ) and Caller:CanPromote() and Caller ~= self then -- checks that the rankid isn't higher than the highest rankid and above
		self:SetRank( rank )
		AddLog( Playermeta:Name() .. "Has Been Promoted" )
	end
end

function Playermeta:Demote( Caller )
	local rank = self:SetRank( [ srank ] + 1  ) -- We locally cache the rankid so we can do math on it
	if ( rank <= #SRanks ) and ( rank > 0 ) and Caller:CanPromote() and Caller ~=self then -- checks that the rankid isn't higher than the highest rankid and above
		self:SetRank( rank )
		AddLog( Playermeta:Name() .. "Has Been Demoted" )
	end
end
// Code Incomplete
function Playermeta:CanPromote()
	if Playermeta:GetPlayerTable()[ srank ] == 
end