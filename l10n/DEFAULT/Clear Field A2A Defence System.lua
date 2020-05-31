--//////////////////////////////////////////////
--Name: Operation Clear Field A2A Defence System
--Author: Surrexen    ༼ つ ◕_◕ ༽つ    (づ｡◕‿◕｡)づ 
--//////////////////////////////////////////////

-- Disengage Radius  - The radius to disengage any target when the distance of the defender to the home base is larger than the specified meters. The default Disengage Radius is 100km
-- Engage Radius     - For example, if 50000 or 50km is given as a value, then any friendly that is airborne within 50km from the detected target, will be considered to receive the command to engage that target area.

function SEF_BLUEDISPATCHERON()
	--BLUE AIR DISPATCHER
	BLUEDetectionSetGroup = SET_GROUP:New()
	BLUEDetectionSetGroup:FilterPrefixes({"DF BLUE EWR", "RT AWACS BLUE#"}) 
	BLUEDetectionSetGroup:FilterStart()
	BLUEDetection = DETECTION_AREAS:New(BLUEDetectionSetGroup, 30000)
	BLUEA2ADispatcher = AI_A2A_DISPATCHER:New(BLUEDetection)
	BLUEA2ADispatcher:SetTacticalDisplay(false)
			
	BLUEA2ADispatcher:SetDefaultFuelThreshold(0.15)
	BLUEA2ADispatcher:SetDefaultCapLimit(1)
	BLUEA2ADispatcher:SetDefaultTakeoffInAirAltitude(3000)
	
	BLUEA2ADispatcher:SetEngageRadius(80000) 
	BLUEA2ADispatcher:SetDisengageRadius(90000)
end	

function SEF_KutaisiCAP()		
	if ( GameMode == 0 ) then
		--////KUTAISI CAP F-16's MULTIPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Rogue", AIRBASE.Caucasus.Kutaisi, {"SQ BLUE F-16C" })
		BLUEA2ADispatcher:SetSquadronOverhead("Rogue", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Rogue", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffInAir("Rogue")
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Rogue")
		
		CAPZoneBlue1 = ZONE:New("CAP Zone BLUE 1")
		BLUEA2ADispatcher:SetSquadronCap("Rogue", CAPZoneBlue1, 4000, 11000, 743, 867, 800, 1200, "BARO")
		BLUEA2ADispatcher:SetSquadronCapInterval("Rogue", 1, 150, 600, 1)
	else
		--////KUTAISI CAP F-16's SINGLEPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Rogue", AIRBASE.Caucasus.Kutaisi, {"SQ BLUE F-16C"})
		BLUEA2ADispatcher:SetSquadronOverhead("Rogue", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Rogue", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffFromParkingHot("Rogue")
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Rogue")
		
		CAPZoneBlue1 = ZONE:New("CAP Zone BLUE 1")
		BLUEA2ADispatcher:SetSquadronCap("Rogue", CAPZoneBlue1, 4000, 11000, 743, 867, 800, 1200, "BARO")
		BLUEA2ADispatcher:SetSquadronCapInterval("Rogue", 1, 150, 600, 1)
	end
	
	trigger.action.outText("Kutaisi Vipers Are Now Enabled", 15)
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = "Clear Field Options", [2] = "Clear Field CAP Options", [3] = "Enable Kutaisi Vipers"})
end	

function SEF_FleetTomcats()	
		
	if ( GameMode == 0 ) then
		--////CARRIER GROUP TOMCATS MULTIPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Tomcat", "CVN-74 John C. Stennis", {"SQ BLUE F-14B"})
		BLUEA2ADispatcher:SetSquadronOverhead("Tomcat", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Tomcat", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffInAir("Tomcat")
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Tomcat")
			
		CAPZoneBlueCarrier = ZONE_GROUP:New("CAP Zone Carrier", GROUP:FindByName( "CVN-74 John C. Stennis" ), 20000)
		BLUEA2ADispatcher:SetSquadronCap("Tomcat", CAPZoneBlueCarrier, 3000, 11000, 768, 905, 800, 1200, "BARO")
		BLUEA2ADispatcher:SetSquadronCapInterval("Tomcat", 1, 150, 600, 1)
	else
		--////CARRIER GROUP TOMCATS SINGLEPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Tomcat", "CVN-74 John C. Stennis", { "SQ BLUE F-14B"})
		BLUEA2ADispatcher:SetSquadronOverhead("Tomcat", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Tomcat", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffFromParkingHot("Tomcat")		
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Tomcat")
			
		CAPZoneBlueCarrier = ZONE_GROUP:New("CAP Zone Carrier", GROUP:FindByName( "CVN-74 John C. Stennis" ), 20000)
		BLUEA2ADispatcher:SetSquadronCap("Tomcat", CAPZoneBlueCarrier, 3000, 11000, 768, 905, 800, 1200, "BARO")
		BLUEA2ADispatcher:SetSquadronCapInterval("Tomcat", 1, 150, 600, 1)	
	end
	
	trigger.action.outText("Fleet Defence Tomcats Are Now Enabled", 15)
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = "Clear Field Options", [2] = "Clear Field CAP Options", [3] = "Enable Fleet Tomcats"})
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = "Clear Field Options", [2] = "Clear Field CAP Options", [3] = "Enable Fleet Hornets"})	
end

function SEF_FleetHornets()		
	if (GameMode == 0) then
		--////CARRIER GROUP HORNETS MULTIPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Hornet", "CVN-74 John C. Stennis", {"SQ BLUE F/A-18C"})
		BLUEA2ADispatcher:SetSquadronOverhead("Hornet", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Hornet", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffInAir("Hornet")
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Hornet")
		
		CAPZoneBlueCarrier = ZONE_GROUP:New("CAP Zone Carrier", GROUP:FindByName( "CVN-74 John C. Stennis" ), 20000)
		BLUEA2ADispatcher:SetSquadronCap("Hornet", CAPZoneBlueCarrier, 3000, 11000, 743, 867, 800, 1200, "BARO")
		BLUEA2ADispatcher:SetSquadronCapInterval("Hornet", 1, 150, 600, 1)
	else
		--////CARRIER GROUP HORNETS SINGLEPLAYER SETTINGS
		BLUEA2ADispatcher:SetSquadron("Hornet", "CVN-74 John C. Stennis", {"SQ BLUE F/A-18C"})
		BLUEA2ADispatcher:SetSquadronOverhead("Hornet", 1)
		BLUEA2ADispatcher:SetSquadronGrouping("Hornet", 2)
		BLUEA2ADispatcher:SetSquadronTakeoffFromParkingHot("Hornet")		
		BLUEA2ADispatcher:SetSquadronLandingAtRunway("Hornet")
		
		CAPZoneBlueCarrier = ZONE_GROUP:New("CAP Zone Carrier", GROUP:FindByName( "CVN-74 John C. Stennis" ), 20000)
		BLUEA2ADispatcher:SetSquadronCap( "Hornet", CAPZoneBlueCarrier, 3000, 11000, 743, 867, 800, 1200, "BARO" )
		BLUEA2ADispatcher:SetSquadronCapInterval( "Hornet", 1, 150, 600, 1 )	
	end
	
	trigger.action.outText("Fleet Defence Hornets Are Now Enabled", 15)
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = "Clear Field Options", [2] = "Clear Field CAP Options", [3] = "Enable Fleet Tomcats"})
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = "Clear Field Options", [2] = "Clear Field CAP Options", [3] = "Enable Fleet Hornets"})	
end

--////RED AIR DEFENCE
function SEF_REDDISPATCHERON()
	REDDetectionSetGroup = SET_GROUP:New()	
	REDDetectionSetGroup:FilterPrefixes({"SQ RUS", "RT RED"})	
	REDDetectionSetGroup:FilterActive()
	REDDetectionSetGroup:FilterStart()
	REDDetection = DETECTION_AREAS:New(REDDetectionSetGroup, 30000)
	REDA2ADispatcher = AI_A2A_DISPATCHER:New(REDDetection)
	REDA2ADispatcher:SetTacticalDisplay(false)
	RedBorderZone = ZONE_POLYGON:New("RED Border", GROUP:FindByName("RED Border"))
	REDA2ADispatcher:SetBorderZone(RedBorderZone)

	-- Default Dispatcher Values
	REDA2ADispatcher:SetDefaultFuelThreshold(0.15)
	REDA2ADispatcher:SetDefaultCapLimit(1)
	REDA2ADispatcher:SetDefaultTakeoffInAirAltitude(3000)

	-- Engage Distances
	REDA2ADispatcher:SetEngageRadius(80000)	
	REDA2ADispatcher:SetDisengageRadius(90000)
end

function SEF_REDSQUADRONSMULTIPLAYER()

	-- Setup the squadrons. The number is the amount of planes available

	-- ////CAP Squadrons
	-- Guaduta - Zone 1
	REDA2ADispatcher:SetSquadron("Alpha", AIRBASE.Caucasus.Gudauta, {"SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	-- Nalchik - Zone 2
	REDA2ADispatcher:SetSquadron("Beta", AIRBASE.Caucasus.Nalchik, {"SQ RUS Su-27"})
	-- Beslan - Zone 3
	REDA2ADispatcher:SetSquadron("Gamma", AIRBASE.Caucasus.Beslan, {"SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	-- Sochi - Zone 4
	REDA2ADispatcher:SetSquadron("Delta", AIRBASE.Caucasus.Sochi_Adler, {"SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	--Admiral Kuznetsov
	REDA2ADispatcher:SetSquadron("Theta", "CV 1143.5 Admiral Kuznetsov", {"SQ RUS Su-33 Kuznetsov"})
	-- Mineralnye-Vody - Zone 6
	REDA2ADispatcher:SetSquadron("Omicron", AIRBASE.Caucasus.Mineralnye_Vody, {"SQ RUS MiG-31", "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})

	--////SQUADRON OVERHEAD (1.0-1.5)
	REDA2ADispatcher:SetSquadronOverhead("Alpha", 0.5) 
	REDA2ADispatcher:SetSquadronOverhead("Beta", 0.5)
	REDA2ADispatcher:SetSquadronOverhead("Gamma", 0.5)
	REDA2ADispatcher:SetSquadronOverhead("Delta", 0.5)
	REDA2ADispatcher:SetSquadronOverhead("Theta", 0.5)
	REDA2ADispatcher:SetSquadronOverhead("Omicron", 0.5)
	
	REDA2ADispatcher:SetSquadronTakeoffInAir("Alpha")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Beta")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Gamma")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Delta")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Theta")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Omicron")

	--////LANDING
	REDA2ADispatcher:SetSquadronLandingAtRunway("Alpha")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Beta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Gamma")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Delta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Theta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Omicron")

	CAPZoneRed1 = ZONE:New("CAP Zone RED 1")
	CAPZoneRed2 = ZONE:New("CAP Zone RED 2")
	CAPZoneRed3 = ZONE:New("CAP Zone RED 3")
	CAPZoneRed4 = ZONE:New("CAP Zone RED 4")
	CAPZoneRed5 = ZONE:New("CAP Zone RED Kuznetsov")
	CAPZoneRed6 = ZONE:New("CAP Zone RED 6")	
end

function SEF_REDSQUADRONSSINGLEPLAYER()
	-- ////CAP Squadrons
	-- Guaduta - Zone 1
	REDA2ADispatcher:SetSquadron("Alpha", AIRBASE.Caucasus.Gudauta, {"SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	-- Nalchik - Zone 2
	REDA2ADispatcher:SetSquadron("Beta", AIRBASE.Caucasus.Nalchik, {"SQ RUS Su-27"})
	-- Beslan - Zone 3
	REDA2ADispatcher:SetSquadron("Gamma", AIRBASE.Caucasus.Beslan, {"SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	-- Sochi - Zone 4
	REDA2ADispatcher:SetSquadron("Delta", AIRBASE.Caucasus.Sochi_Adler, {"SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})
	--Admiral Kuznetsov
	REDA2ADispatcher:SetSquadron("Theta", "CV 1143.5 Admiral Kuznetsov", {"SQ RUS Su-33 Kuznetsov"})
	-- Mineralnye-Vody - Zone 6
	REDA2ADispatcher:SetSquadron("Omicron", AIRBASE.Caucasus.Mineralnye_Vody, {"SQ RUS MiG-31", "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD"})

	--////SQUADRON OVERHEAD (1.0-1.5)
	REDA2ADispatcher:SetSquadronOverhead("Alpha", 1.0)
	REDA2ADispatcher:SetSquadronOverhead("Beta", 1.0)
	REDA2ADispatcher:SetSquadronOverhead("Gamma", 1.0)
	REDA2ADispatcher:SetSquadronOverhead("Delta", 1.0)
	REDA2ADispatcher:SetSquadronOverhead("Theta", 1.0)
	REDA2ADispatcher:SetSquadronOverhead("Omicron", 1.0)

	--////SQUADRON GROUPING
	REDA2ADispatcher:SetSquadronGrouping("Alpha", 2)
	REDA2ADispatcher:SetSquadronGrouping("Beta", 2)
	REDA2ADispatcher:SetSquadronGrouping("Gamma", 2)
	REDA2ADispatcher:SetSquadronGrouping("Delta", 2)
	REDA2ADispatcher:SetSquadronGrouping("Theta", 2)
	REDA2ADispatcher:SetSquadronGrouping("Omicron", 2)
	
	REDA2ADispatcher:SetSquadronTakeoffFromRunway("Alpha")
	REDA2ADispatcher:SetSquadronTakeoffFromRunway("Beta")
	REDA2ADispatcher:SetSquadronTakeoffFromRunway("Gamma")
	REDA2ADispatcher:SetSquadronTakeoffFromRunway("Delta")
	REDA2ADispatcher:SetSquadronTakeoffFromRunway("Theta")
	REDA2ADispatcher:SetSquadronTakeoffInAir("Omicron")
		
	--////LANDING
	REDA2ADispatcher:SetSquadronLandingAtRunway("Alpha")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Beta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Gamma")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Delta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Theta")
	REDA2ADispatcher:SetSquadronLandingAtRunway("Omicron")

	CAPZoneRed1 = ZONE:New("CAP Zone RED 1")
	CAPZoneRed2 = ZONE:New("CAP Zone RED 2")
	CAPZoneRed3 = ZONE:New("CAP Zone RED 3")
	CAPZoneRed4 = ZONE:New("CAP Zone RED 4")
	--CAPZoneRed5 = ZONE:New( "CAP Zone RED Kuznetsov" )
	CAPZoneRedCarrier = ZONE_GROUP:New("CAP Zone Black Sea Fleet", GROUP:FindByName("CV 1143.5 Admiral Kuznetsov"), 75000)
	CAPZoneRed6 = ZONE_POLYGON:New("CAP Zone RED 6", GROUP:FindByName("CAP Zone RED 6"))

	-- ZONE 1 Gudauta 			- Alpha
	-- ZONE 2 Nalchik 			- Beta
	-- ZONE 3 Beslan  			- Gamma
	-- ZONE 4 Sochi   			- Delta
	-- ZONE 5 Kuznetsov 		- Theta
	-- ZONE 6 Mineralnye-Vody 	- Omicron

	--ZONE 1 / Alpha / Gudauta
	REDA2ADispatcher:SetSquadronCap("Alpha", CAPZoneRed1, 1000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval("Alpha", 1, 300, 900, 1)
	--ZONE 2 / Beta / Nalchik
	REDA2ADispatcher:SetSquadronCap("Beta", CAPZoneRed2, 4000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval("Beta", 1, 300, 900, 1 )
	--ZONE 3 / Gamma / Beslan
	REDA2ADispatcher:SetSquadronCap("Gamma", CAPZoneRed3, 4000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval("Gamma", 1, 300, 900, 1)  
	--ZONE 4 / Delta / Sochi
	REDA2ADispatcher:SetSquadronCap("Delta", CAPZoneRed4, 1000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval( "Delta", 1, 300, 900, 1)
	--ZONE 5 / Theta / Admiral Kuznetsov
	REDA2ADispatcher:SetSquadronCap("Theta", CAPZoneRedCarrier, 1000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval("Theta", 1, 300, 900, 1)
	--ZONE 6 / Omicron / Mineralnye-Vody
	REDA2ADispatcher:SetSquadronCap("Omicron", CAPZoneRed6, 4000, 11000, 750, 900, 800, 1200, "BARO")
	REDA2ADispatcher:SetSquadronCapInterval("Omicron", 1, 300, 900, 1)
	
end

function SEF_CleanUpAirports()
	CleanUpAirports = CLEANUP_AIRBASE:New({
		AIRBASE.Caucasus.Gudauta, 
		AIRBASE.Caucasus.Nalchik, 
		AIRBASE.Caucasus.Beslan,											  
		AIRBASE.Caucasus.Sochi_Adler,											  
		AIRBASE.Caucasus.Mozdok,
		AIRBASE.Caucasus.Mineralnye_Vody,
		AIRBASE.Caucasus.Kutaisi,
		AIRBASE.Caucasus.Senaki_Kolkhi,
		AIRBASE.Caucasus.Batumi											 
	})
end

function SEF_BLUEDEFENCENETWORK()
	--////ADD TO DEFENCE NETWORK
	BLUEDetectionSetGroup:AddGroupsByName({
		"CVN-74 John C. Stennis",
		"Georgian Fleet"
	})
end

function SEF_REDDEFENCENETWORK()

	-- CREATE MASTER LIST THEN LOOP THROUGH THE ALIVE UNITS AND ADD TO RED DEFENCE NETWORK
	REDDefenceNetworkGroup = SET_GROUP:New()
	REDDefenceNetworkGroup:FilterPrefixes({
		"DF RED EWR",	
		"Sochi - EWR Veseloe",
		"Gudauta - EWR Gudauta 1",
		"Gudauta - EWR Gudauta 2",
		"Sukhumi - EWR Kvemo-Merheuli",
		"Sukhumi - EWR Sukhumi",												
		"Anapskaya - SA-10",
		"Gudauta - SA-10",
		"Novorossiysk - SA-10",
		"Sochi - SA-11",
		"Sukhumi - SA-10",
		"Utash - SA-3",
		"Kambileyevskoye - SA-2",
		"Kirovo - SA-2",
		"Digora - SA-2",
		"Zaragizh - SA-2",
		"Islamey - SA-2",		
		"CV 1143.5 Admiral Kuznetsov",
		"Gudauta - Navy 1",
		"Ochamchira - Navy 1",
		"Sochi - Navy 1",
		"Sukhumi - Navy 1",
		"Kvemo Roka - SAM 1",
		"Gori - SAM 1",
		"Gori - SAM 2",
		"Gudauta - SAM 1",
		"Ochamchira - SAM 1",
		"Sukhumi - SAM 1",
		"Sukhumi - SAM 2",
		"Tkvarcheli - SAM 1",
		"Tskhinvali - SAM 1",
		"Tskhinvali - SAM 2",
		"Zemo Azhara - SAM 1",
		"Zugdidi - SAM 1",
		"Zugdidi - SAM 2" 
	})	
	REDDefenceNetworkGroup:FilterOnce()
	
	REDDefenceNetworkGroup:ForEachGroupAlive(function(RedDefenceGroupCheck)
		RedDefenceGroupName = RedDefenceGroupCheck:GetName()
		REDDetectionSetGroup:AddGroupsByName({RedDefenceGroupName})
	end)
end

----------------------------------------------------------------------------------------------------------------------------------------------

function SEF_AIRFIELDPERIMETERZONES()
	
	-- The airfield perimeters are set to 75km radius around the airfield (~40nm)	
	GudautaPerimeterZone 		= ZONE:New("Gudauta Perimeter")
	SochiPerimeterZone 			= ZONE:New("Sochi Perimeter")
	NalchikPerimeterZone 		= ZONE:New("Nalchik Perimeter")
	BeslanPerimeterZone 		= ZONE:New("Beslan Perimeter")
	ServerWide 					= ZONE:New("Server Perimeter")
end

function SEF_AIRFIELDPERIMETERCLIENTS()
	SET_AIRFIELDPERIMETERCLIENTS = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterStart()
end

function SEF_AIRFIELDPERIMETERZONECLIENTSCANNER(Timeloop, time)	
	local GudautaPerimeterCount	= 0
	local SochiPerimeterCount	= 0
	local NalchikPerimeterCount	= 0
	local BeslanPerimeterCount	= 0
	
	-- Count Clients Inside Airfield Perimeter Zones
	SET_AIRFIELDPERIMETERCLIENTS:ForEachClientInZone(GudautaPerimeterZone, function (GroupObject)
		GudautaPerimeterCount = GudautaPerimeterCount + 1
	end)	
	SET_AIRFIELDPERIMETERCLIENTS:ForEachClientInZone(SochiPerimeterZone, function (GroupObject)
		SochiPerimeterCount = SochiPerimeterCount + 1
	end)	
	SET_AIRFIELDPERIMETERCLIENTS:ForEachClientInZone(NalchikPerimeterZone, function (GroupObject)
		NalchikPerimeterCount = NalchikPerimeterCount + 1
	end)	
	SET_AIRFIELDPERIMETERCLIENTS:ForEachClientInZone(BeslanPerimeterZone, function (GroupObject)
		BeslanPerimeterCount = BeslanPerimeterCount + 1
	end)
	
	-- Gudauta
	if ( GudautaPerimeterCount > 0 ) then		
		GudautaStatus = "Gudauta\nAirspace Is Being Contested By The Allies\n"
		REDA2ADispatcher:SetSquadron( "Alpha", AIRBASE.Caucasus.Maykop_Khanskaya, { "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	else
		GudautaStatus = "Gudauta\nAirspace Is Controlled By Russia\n"
		REDA2ADispatcher:SetSquadron( "Alpha", AIRBASE.Caucasus.Gudauta, { "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	end
	-- Sochi
	if ( SochiPerimeterCount > 0 ) then		
		SochiStatus = "Sochi\nAirspace Is Being Contested By The Allies\n"		
		REDA2ADispatcher:SetSquadron( "Delta", AIRBASE.Caucasus.Maykop_Khanskaya, { "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	else
		SochiStatus = "Sochi\nAirspace Is Controlled By Russia\n"
		REDA2ADispatcher:SetSquadron( "Delta", AIRBASE.Caucasus.Sochi_Adler, { "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	end
	-- Nalchik
	if ( NalchikPerimeterCount > 0 ) then		
		NalchikStatus = "Nalchik\nAirspace Is Being Contested By The Allies\n"	
		REDA2ADispatcher:SetSquadron( "Beta", AIRBASE.Caucasus.Mozdok, { "SQ RUS Su-27" } )	
	else
		NalchikStatus = "Nalchik\nAirspace Is Controlled By Russia\n"
		REDA2ADispatcher:SetSquadron( "Beta", AIRBASE.Caucasus.Nalchik, { "SQ RUS Su-27" } )	
	end
	-- Beslan
	if ( BeslanPerimeterCount > 0 ) then		
		BeslanStatus = "Beslan\nAirspace Is Being Contested By The Allies\n"		
		REDA2ADispatcher:SetSquadron( "Gamma", AIRBASE.Caucasus.Mozdok, { "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	else
		BeslanStatus = "Beslan\nAirspace Is Controlled By Russia\n"
		REDA2ADispatcher:SetSquadron( "Gamma", AIRBASE.Caucasus.Beslan, { "SQ RUS Su-27", "SQ RUS Su-30", "SQ RUS MiG-29A", "SQ RUS MiG-29S", "SQ RUS MiG-23MLD" } )	
	end
	
	return time + 30	
end

-- Strafe Haven Edits
local currentActivity = ""

function GetServerPlayerCount()
	local coalitionClients = coalition.getPlayers(coalition.side.BLUE)
	if(type(coalitionClients) == "table") then
		local numPlayers = #coalitionClients
		if(type(numPlayers) == "number") then
			return numPlayers
		end
	end
	
	-- Failed to get number of players, return false
	return false
end

function UpdateA2ASettings(Timeloop, time)
	local playerCount = GetServerPlayerCount()
	
	if(playerCount ~= false) then
		if(playerCount >= 5) then
			if(currentActivity ~= "High") then
				REDA2ADispatcher:SetSquadronGrouping("Gamma", 2)
				REDA2ADispatcher:SetSquadronGrouping("Delta", 2)
				REDA2ADispatcher:SetSquadronGrouping("Omicron", 2)
				-- ZONE 3 / Gamma / Beslan
				REDA2ADispatcher:SetSquadronCap("Gamma", CAPZoneRed3, 4000, 11000, 750, 900, 800, 1200, "BARO")
				REDA2ADispatcher:SetSquadronCapInterval("Gamma", 1, 1000, 1500, 1)
				-- ZONE 4 / Delta / Sochi
				REDA2ADispatcher:SetSquadronCap("Delta", CAPZoneRed4, 1000, 11000, 750, 900, 800, 1200, "BARO")
				REDA2ADispatcher:SetSquadronCapInterval("Delta", 1, 1000, 1500, 1)
				-- ZONE 6 / Omicron / Mineralnye-Vody
				REDA2ADispatcher:SetSquadronCap("Omicron", CAPZoneRed6, 4000, 11000, 750, 900, 800, 1200, "BARO")
				REDA2ADispatcher:SetSquadronCapInterval("Omicron", 1, 1000, 1500, 1)
				
				currentActivity = "High"
			end
		else
			if(currentActivity ~= "Low") then
				REDA2ADispatcher:SetSquadronGrouping("Alpha", 2)
				REDA2ADispatcher:SetSquadronGrouping("Beta", 2)
				REDA2ADispatcher:SetSquadronGrouping("Gamma", 0)
				REDA2ADispatcher:SetSquadronGrouping("Delta", 0)
				REDA2ADispatcher:SetSquadronGrouping("Theta", 2)
				REDA2ADispatcher:SetSquadronGrouping("Omicron", 0)			
				-- ZONE 1 / Alpha / Gudauta
				REDA2ADispatcher:SetSquadronCap("Alpha", CAPZoneRed1, 1000, 11000, 750, 900, 800, 1200, "BARO")  
				REDA2ADispatcher:SetSquadronCapInterval("Alpha", 1, 1000, 1500, 1)
				-- ZONE 2 / Beta / Nalchik
				REDA2ADispatcher:SetSquadronCap("Beta", CAPZoneRed2, 4000, 11000, 750, 900, 800, 1200, "BARO")
				REDA2ADispatcher:SetSquadronCapInterval("Beta", 1, 1000, 1500, 1)
				-- ZONE 5 / Theta / Admiral Kuznetsov
				REDA2ADispatcher:SetSquadronCap("Theta", CAPZoneRed5, 1000, 11000, 750, 900, 800, 1200, "BARO")
				REDA2ADispatcher:SetSquadronCapInterval("Theta", 1, 1000, 1500, 1)
				
				currentActivity = "Low"
			end
		end
	end
	
	return time + 30
end
----------------------------------------------------------------------------------------------------------------------------------------------	
GameMode = trigger.misc.getUserFlag(10000)	

SEF_REDDISPATCHERON()
if (GameMode == 0) then
	SEF_REDSQUADRONSMULTIPLAYER()
else
	SEF_REDSQUADRONSSINGLEPLAYER()
end
SEF_BLUEDISPATCHERON()
SEF_AIRFIELDPERIMETERZONES()
SEF_AIRFIELDPERIMETERCLIENTS()

--////Schedule These Functions To Run 2 seconds later and adjust defence networks per faction as necessary
timer.scheduleFunction(SEF_BLUEDEFENCENETWORK, 53, timer.getTime() + 2)
timer.scheduleFunction(SEF_REDDEFENCENETWORK, 53, timer.getTime() + 3)
--////Airfield Perimeter scanner	
timer.scheduleFunction(SEF_AIRFIELDPERIMETERZONECLIENTSCANNER, 53, timer.getTime() + 21)
timer.scheduleFunction(UpdateA2ASettings, 1337, timer.getTime() + 30)

--SEF_CleanUpAirports()

----------------------------------------------------------------------------------------------------------------------------------------------
