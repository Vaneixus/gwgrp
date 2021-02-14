--[[
|---------------------------------------|
|			 GWGRP © Reserved 			|
|   Based on Industrial17 Team's Code   |
|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|
]]--
--[
Skybox = {} -- Table to store the Skybox Cycle functionality.
Skybox.self = Skybox
Skybox.Initialized = false -- Value to store if the Skybox Data Has Been Initialized.
function Skybox:SetupDynamicLightTable()
	local tbl = {}
	for _, LightEnt in pairs( ents.FindByClass( "light_dynamic" ) ) do
		tbl[ LightEnt ] = LightEnt:GetKeyValues()["brightness"]
	end
	return tbl
end

function Skybox:Init() -- Initialize data.
	Skybox.DynamicLightTable 	= Skybox.DynamicLightTable or Skybox:SetupDynamicLightTable()	-- we initialise the default light table for later maths
	PrintTable( Skybox.DynamicLightTable )
	Skybox.DayLength 			= 60						-- Sets that a day lasts about that many seconds. 3600 - 1 hour
	Skybox.Noon 				= 12						-- Tells it that Noon Starts at 12:00 PM
	Skybox.MidNight 			= 0 						-- Tells it that Mid-Night starts at 12:00 AM
	Skybox.DawnStart			= 4		 					-- 4:00am
	Skybox.DawnMidPoint			= 5.25						-- 5:15am
	Skybox.DawnEnd				= 6.5						-- 6:30am
	Skybox.DuskStart			= 17						-- 5:00pm
	Skybox.DuskMidPoint			= 18.25						-- 6:15pm
	Skybox.DuskEnd				= 19.5						-- 7:30pm
	Skybox.Time 				= 0							-- Value to Store the Current Time
	Skybox.Progress 			= 0
	Skybox.CurMOTD				= "NIGHT"
	Skybox.NextMOTD				= "MORNING"
	Skybox.NextTick				= math.floor( CurTime() )
	Skybox.Skypaint 			= ents.FindByClass( "env_skypaint" )[1]			-- Sets the Skypaint we're editing to the first found in map
	Skybox.Sun 					= ents.FindByClass( "env_sun" )[1]				-- Sets the Sun we're using to the first found in the map
	Skybox.LightEnvironment 	= ents.FindByClass( "light_environment" )[1]	-- Sets the Light env. we're editing to the first found in the map
	Skybox.FogController		= ents.FindByClass( "env_fog_controller" )[1]		-- Sets the Fog Controller to the first found in the map.
	Skybox.SkypaintTable = { -- Values Provided by Industiral 17 Team

		["MORNING"] = {
			TopColor		= Vector( 0.2, 0.5, 1 ),
			BottomColor		= Vector( 1, 0.71, 0 ),
			FadeBias		= 1,
			HDRScale		= 0.26,
			StarScale		= 0.66,
			StarFade		= 0.0,
			DuskScale		= 1,
			DuskIntensity	= 1,
			DuskColor		= Vector( 1, 0.2, 0 ),
			SunColor		= Vector( 0.2, 0.1, 0 ),
			SunSize			= 2,
			DarknessDensity = -0.25,
			LightIntensity	= 2
		},

		["DAYTIME"] = {
			TopColor		= Vector( 0.2, 0.49, 1 ),
			BottomColor		= Vector( 0.01, 0.96, 1 ),
			FadeBias		= 1,
			HDRScale		= 0.26,
			StarScale		= 0.66,
			StarFade		= 1.5,
			DuskScale		= 1,
			DuskIntensity	= 1,
			DuskColor		= Vector( 1, 0.2, 0 ),
			SunColor		= Vector( 0.83, 0.45, 0.11 ),
			SunSize			= 0.34,
			DarknessDensity = 0,
			LightIntensity	= 0
		},

		["DUSK"] = {
			TopColor		= Vector( 0.09, 0.32, 0.32 ),
			BottomColor		= Vector( 1, 0.48, 0 ),
			FadeBias		= 1,
			HDRScale		= 0.36,
			StarScale		= 0.66,
			StarFade		= 0.0,
			DuskScale		= 1,
			DuskIntensity	= 5.31,
			DuskColor		= Vector( 1, 0.36, 0 ),
			SunColor		= Vector( 0.83, 0.45, 0.11 ),
			SunSize			= 0.34,
			DarknessDensity = -0.25,
			LightIntensity	= 2

		},

		["NIGHT"] = {
			TopColor		= Vector( 0.00, 0.00, 0.00 ),
			BottomColor		= Vector( 0.02, 0.04, 0.06 ),
			FadeBias		= 0.27,
			HDRScale		= 0.19,
			StarScale		= 0.66,
			StarFade		= 5.0,
			DuskScale		= 0,
			DuskIntensity	= 0,
			DuskColor		= Vector( 1, 0.36, 0 ),
			SunColor		= Vector( 0.83, 0.45, 0.11 ),
			SunSize			= 0.001,
			DarknessDensity = -0.5,
			LightIntensity	= 5

		
		}
	}

	-- put the sun on the horizon initially
		if( IsValid( Skybox.Sun ) ) then
			Skybox.Sun:SetKeyValue( "sun_dir", "1 0 0" )
		end

	-- HACK: Fixes prop lighting since the first pattern change fails to update it.
		if( IsValid( Skybox.LightEnvironment ) ) then
			Skybox.LightEnvironment:Fire( "FadeToPattern", 'a' )
		end

	Skybox.Initialized 		= true -- tells the server that the data has been successfully Initialized
end


function Skybox.Think() -- The main event

	if not (Skybox.Initialized) then Skybox.Init() end

			Skybox.Time = Skybox.Time + ( 24 / Skybox.DayLength ) * FrameTime()
			if IsValid( Skybox.SyncEnt ) then
				Skybox.SyncEnt:SetTime( Skybox.Time )
			end
			if Skybox.Time >= 24 then -- makes sure we don't go off cycle
				Skybox.Time = 0
			end
		
		
		if ( Skybox.Time > Skybox.DawnStart ) and ( Skybox.Time < Skybox.DawnMidPoint ) then -- transition from night to dawn
			Skybox.Progress = ( ( Skybox.Time - Skybox.DawnStart ) / ( Skybox.DawnMidPoint - Skybox.DawnStart ) )
			Skybox.CurMOTD = "NIGHT"
			Skybox.NextMOTD = "MORNING"
		


		elseif ( Skybox.Time > Skybox.DawnMidPoint ) and ( Skybox.Time < Skybox.DawnEnd ) then
			Skybox.Progress = ( ( Skybox.Time - Skybox.DawnMidPoint ) / ( Skybox.DawnEnd - Skybox.DawnMidPoint ) )
			Skybox.CurMOTD = "MORNING"
			Skybox.NextMOTD = "DAYTIME"




		elseif ( Skybox.Time > Skybox.DuskStart ) and ( Skybox.Time < Skybox.DuskMidPoint ) then
			Skybox.Progress = ( ( Skybox.Time - Skybox.DuskStart ) / ( Skybox.DuskMidPoint - Skybox.DuskStart ) )
			Skybox.CurMOTD = "DAYTIME"
			Skybox.NextMOTD = "DUSK"




		elseif ( Skybox.Time > Skybox.DuskMidPoint ) and ( Skybox.Time < Skybox.DuskEnd ) then
			Skybox.Progress = ( ( Skybox.Time - Skybox.DuskMidPoint ) / ( Skybox.DuskEnd - Skybox.DuskMidPoint ) )
			Skybox.CurMOTD = "DUSK"
			Skybox.NextMOTD = "NIGHT"
		end

		Skybox.Skypaint:SetTopColor( LerpVector( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].TopColor, Skybox.SkypaintTable[Skybox.NextMOTD].TopColor ) )
		Skybox.Skypaint:SetBottomColor( LerpVector( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].BottomColor, Skybox.SkypaintTable[Skybox.NextMOTD].BottomColor ) )
		Skybox.Skypaint:SetFadeBias( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].FadeBias, Skybox.SkypaintTable[Skybox.NextMOTD].FadeBias ) )
		Skybox.Skypaint:SetHDRScale( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].HDRScale, Skybox.SkypaintTable[Skybox.NextMOTD].HDRScale ) )
		Skybox.Skypaint:SetStarScale( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].StarScale, Skybox.SkypaintTable[Skybox.NextMOTD].StarScale ) )
		Skybox.Skypaint:SetStarFade(  Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].StarFade, Skybox.SkypaintTable[Skybox.NextMOTD].StarFade ) )
		Skybox.Skypaint:SetDuskScale( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].DuskScale, Skybox.SkypaintTable[Skybox.NextMOTD].DuskScale ) )
		Skybox.Skypaint:SetDuskIntensity( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].DuskIntensity, Skybox.SkypaintTable[Skybox.NextMOTD].DuskIntensity ) )
		Skybox.Skypaint:SetDuskColor( LerpVector( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].DuskColor, Skybox.SkypaintTable[Skybox.NextMOTD].DuskColor ) )
		Skybox.Skypaint:SetSunColor( LerpVector( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].SunColor, Skybox.SkypaintTable[Skybox.NextMOTD].SunColor ) )
		Skybox.Skypaint:SetSunSize( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].SunSize, Skybox.SkypaintTable[Skybox.NextMOTD].SunSize ) )
		net.Start("PlayersDarknessSimulation")
		net.WriteFloat( Lerp( Skybox.Progress, Skybox.SkypaintTable[Skybox.CurMOTD].DarknessDensity, Skybox.SkypaintTable[Skybox.NextMOTD].DarknessDensity ) )
		net.Broadcast()
		for key, entity in pairs( ents.FindByClass( "light_dynamic" ) ) do
			entity:SetKeyValue( "brightness", Lerp( Skybox.Progress, Skybox.DynamicLightTable[entity] + Skybox.SkypaintTable[Skybox.CurMOTD].LightIntensity, Skybox.DynamicLightTable[entity] + Skybox.SkypaintTable[Skybox.NextMOTD].LightIntensity ) )
		end

		if ( Skybox.Time > Skybox.DuskEnd and Skybox.Time < 24 ) or ( Skybox.Time > 0 and Skybox.Time < Skybox.DawnStart ) then
			Skybox.Skypaint:SetSunSize( 0 )
			Skybox.Sun:SetKeyValue( "size", "0" )
			Skybox.Sun:SetKeyValue( "overlaysize", "0" )
		else
			Skybox.Sun:SetKeyValue( "size", "16" )
			Skybox.Sun:SetKeyValue( "overlaysize", "4" )
		end


-- Code Below is Provided By Industrial Team for Public Usage

	if( IsValid( Skybox.Sun ) ) then
			if( Skybox.Time >= Skybox.DawnStart and Skybox.Time <= Skybox.DuskEnd ) then
				local frac = 1 - ( ( Skybox.Time - Skybox.DawnStart ) / ( Skybox.DuskEnd - Skybox.DawnStart ) );
				local angle = Angle( -180 * frac, 15, 0 );

				Skybox.Sun:SetKeyValue( "sun_dir", tostring( angle:Forward() ) );
			end
		end


	if( IsValid( Skybox.LightEnvironment ) ) then
		local STYLE_LOW = string.byte( 'a' )
		local STYLE_HIGH = string.byte( 'm' )
		local LastStyle = '.'
		local frac = 0

		if( Skybox.Time >= Skybox.DawnMidPoint and Skybox.Time < Skybox.Noon ) then
			frac = ( Skybox.Time - Skybox.DawnMidPoint ) / ( Skybox.Noon - Skybox.DawnMidPoint )
		elseif( Skybox.Time >= Skybox.Noon and Skybox.Time < Skybox.DuskMidPoint ) then
			frac = 1 - ( ( Skybox.Time - Skybox.Noon ) / ( Skybox.DuskMidPoint - Skybox.Noon ) )
		end

		local Style = string.char( math.floor( Lerp( frac, STYLE_LOW, STYLE_HIGH ) + 0.5 ) )

		if( LastStyle ~= Style ) then
			Skybox.LightEnvironment:Fire( "FadeToPattern", style )
			LastStyle = Style
		end
	end

end

function GetFormattedDNTime()
	local time = Skybox.Time
	local hours = math.floor( time )
	local minutes = math.floor( (time - hours) * 60 )
	
	return hours, minutes
end

hook.Add( "Think", "SkyboxThink", Skybox.Think )
--]]--