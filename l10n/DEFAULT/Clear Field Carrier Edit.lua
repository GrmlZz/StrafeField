--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Name: Operation Clear Field Carrier
-- Author: Surrexen    ༼ つ ◕_◕ ༽つ    (づ｡◕‿◕｡)づ 
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////CARRIER GROUP PATROL ROUTE
--////Set Carrier Group To Patrol Waypoints Indefinately
GROUP:FindByName("CVN-74 John C. Stennis"):PatrolRoute()
GROUP:FindByName ("LHA-1 Tarawa"):PatrolRoute()
GROUP:FindByName ("CVN-72 Abraham Lincoln"):PatrolRoute()
GROUP:FindByName("CV 1143.5 Admiral Kuznetsov"):PatrolRoute()

--////GET THE GAME MODE SETUP (FLAG 10000 IN MISSION EDITOR TRIGGERS, 0 FOR MULTIPLAYER, 1 FOR SINGLEPLAYER)
GameMode = trigger.misc.getUserFlag(10000)

if (GameMode == 0) then
	trigger.action.outText("Operation Clear Field Will Run In Multiplayer Mode [Aerial Starts For AI CAP and Fleet Defence]", 5)	
else
	trigger.action.outText("Operation Clear Field Will Run In Singleplayer Mode [Ground Starts For AI CAP and Fleet Defence]", 5)
end