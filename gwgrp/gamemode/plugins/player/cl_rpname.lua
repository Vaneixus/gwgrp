--[[
|----------------------|
|   GWGRP © Reserved   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--

TextColor = Color( 255, 0, 0, 255)
local function  RPNameUI()
	local RPNameFrame = vgui.Create( "DFrame" )
		RPNameFrame:SetPos( ScrW() / 2 - 250, ScrH() / 2 - 35 ) -- centers the Frame
		RPNameFrame:SetSize( 500, 70 ) -- Set's the Size of the Frame
		RPNameFrame:SetTitle( "" ) --  removes title so we can use a custom one integrated into the paint function
		RPNameFrame:SetDraggable( false ) -- makes the window Undraggable
		RPNameFrame:ShowCloseButton( false ) -- Disables the Control Box
		RPNameFrame:SetMouseInputEnabled( true ) -- Enables Mouse Input
		RPNameFrame:MouseCapture( true ) -- Captures the Mouse input
		RPNameFrame:MakePopup()
		function RPNameFrame:Paint( w, h ) -- adds few stuff to the frame
			DrawBlur( self )
			surface.SetDrawColor( 0, 0, 0, 230 ) -- set's the frame color to a alpha black
			surface.DrawRect( 0, 0, w, h ) --  creates a box to replace the default box
			surface.SetDrawColor( 120, 0, 0, 200 ) -- creates a alpha dark red color for the header
			surface.DrawRect( 0, 0, w, 25 ) -- creates the header to fill the top and have a size of 25 px
			surface.SetTextColor( 255, 255, 255, 255 ) -- makes the text pure white
			surface.SetTextPos( 70, 5 ) -- Centers Text
			surface.SetFont( "DermaDefaultBold" ) -- sets font width to bold, to make title stand out
			surface.DrawText( "Please insert a roleplay name you would like to use to continue:" ) -- sets the title to the following text.
			surface.SetTextPos( 5, 27 ) -- docks the text to the left
			surface.SetTextColor( 200, 200, 200, 255 ) -- Colors the Text A darkened White
			surface.SetFont( "DermaDefault" ) -- Sets the Text font to  less bold type of Derma Default
			surface.DrawText( "Please type in a first name and a last name seperated by a space and contains at least 8 letters in total" ) -- Gives a Hint to the player
		end

	local RPNameTextBox =  vgui.Create( "DTextEntry", RPNameFrame ) -- Creates a Textbox for the User Type in the Wanted Roleplay Name
		RPNameTextBox:SetPos( 15, 45 ) -- Set's co-ordinates for the Text Box, so It's Appropriatly Sized and placed
		RPNameTextBox:SetSize( 400, 20 ) -- Sets the box size
		RPNameTextBox:SetPlaceholderText( "e.g: John Apples" ) -- Set's An example for users

	local RPNameContinueButton =  vgui.Create( "DButton", RPNameFrame ) -- Creates a button for the player to continue with selected Roleplay name
		RPNameContinueButton:SetPos( 420, 45 ) -- Set's the Position after the Text box, and is aligned to it
		RPNameContinueButton:SetText( "Continue" ) -- Gives the Button a Title for easier Understanding from the player
		RPNameContinueButton:SetSize( 75, 20 ) -- Sets hieght to a one similar to the text box, and leaves a 5 px for the area between button and the frame border
		RPNameContinueButton:SetTextColor( Color(255, 255, 255, 255) ) -- Set's the Text Color to a pure white
		
	function RPNameContinueButton:Paint( w, h ) -- Paints the background of the button a redish color
			surface.SetDrawColor( Color( 120, 0, 0, 255 ) ) -- Sets the button color to a dark red
			surface.DrawRect( 0, 0, w, h ) -- Makes a box that covers teh entire surface area of the button.

		end

	function RPNameContinueButton:DoClick()
		print( playerdata )
		local FullName = RPNameTextBox:GetText()
		local tbl = string.Explode( " ", FullName )
		if table.Count( tbl ) == 2 then -- checks how many keys( Values ) are in the table, and makes sure that there are two
			playerdata["FirstName"] = tbl[ 1 ]
			playerdata["LastName"] = tbl[ 2 ]
			net.Start( "FullNameUpdate" )
			net.WriteTable( tbl )
			net.SendToServer()
			RPNameFrame:InvalidateChildren( true )
			PlayerRPName:SetText( "Roleplay Name: " .. playerdata["FirstName"] .. " " .. playerdata["LastName"] )
			RPNameFrame:SetVisible( false )
		else

		end
	end



end
RPNameUI()