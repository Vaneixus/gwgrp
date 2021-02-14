--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--
local ply = LocalPlayer()
local Redraw = false
local FirstDraw = FirstDraw or false

function SetupHud()
InfoPanel = InfoPanel or vgui.Create( "DFrame" ) 
		InfoPanel:SetPos( 25, 25 )
		InfoPanel:SetSize( 256, 120 )
		InfoPanel:SetText( "" )
		InfoPanel:SetDraggable( false )
		InfoPanel:ShowCloseButton( false )
		function InfoPanel:Paint( w, h )
			DrawBlur( self )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 180 ) )
		end


	PlayerAvatar = PlayerAvatar or vgui.Create( "AvatarImage", InfoPanel )
		PlayerAvatar:SetPlayer( ply, 64 )
		PlayerAvatar:SetPos( 4, 4 )
		PlayerAvatar:SetSize( 64, 64 )

	PlayerName = PlayerName or vgui.Create( "DLabel", InfoPanel )
		PlayerName:SetText( "Steam Name: " .. ply:Name() )
		PlayerName:SetPos( 72 , 8 )
		PlayerName:SetSize( 180, 12 )
		PlayerName:SetFont( "DermaDefaultBold" )

	PlayerRPName = PlayerRPName or vgui.Create( "DLabel", InfoPanel )
		PlayerRPName:SetText( "Roleplay Name: " .. playerdata.FirstName .. " " .. playerdata.LastName )
		PlayerRPName:SetPos( 72 , 20 )
		PlayerRPName:SetSize( 180, 12 )
		PlayerRPName:SetFont( "DermaDefaultBold" )


	Vingette = Vingette or vgui.Create( "DFrame" )
		Vingette:SetPos( 0, 0 )
		Vingette:SetSize( ScrW(), ScrH() )
		Vingette:SetDraggable( false )
		Vingette:ShowCloseButton( false )
		Vingette:SetText( "" )
		function Vingette:Paint( w, h )
			DrawVignette()
		end

end

if Redraw == false and FirstDraw == false then
	SetupHud()
	FirstDraw = true
	elseif Redraw == true then
		SetupHud()
end