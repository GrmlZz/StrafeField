--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Name: Operation Clear Field - Russo-Georgian War 2008
-- Author: Surrexen    ༼ つ ◕_◕ ༽つ    (づ｡◕‿◕｡)づ 
-- Modified by Adonnay:
--   Allow for 3 simultaneous missions
--   Removed radio calls for smoke and most reinforcements
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

GLOBAL_JTAC_RADIO_ADDED = {} --keeps track of who's had the radio command added

A2G_Mission = {Number = 0, Static = false, Target = "", Briefing = ""}
A2G_Mission.__index = A2G_Mission

A2G_Task = {TaskNumber = 0, A2G_Mission = {}, Pilots = {}}
A2G_Task.__index = A2G_Task

function A2G_Mission:Create(Number)
	local mission = {}
	setmetatable(mission, A2G_Mission)
	mission.Number = Number
	mission.Static = false
	mission.Target = ""
	mission.Briefing = ""
	return mission
end

function A2G_Mission:SetTarget(Target, Static, Briefing)
	self.Target = Target
	self.Static = Static
	self.Briefing = Briefing
	return self
end


-- TASK
function A2G_Task:New(TaskNumber, Mission)
	local task = {}
	setmetatable(task, A2G_Task)
	task.TaskNumber = TaskNumber
	task.A2G_Mission = Mission or {}
	task.Pilots = {}
	return task
end

function A2G_Task:GetMission()
	return self.A2G_Mission
end

function A2G_Task:AddPilot(PilotName) 
	self.Pilots[#self.Pilots+1] = PilotName
end

function A2G_Task:RemovePilot(PilotName)
	local newPilots = {}
	local j = 1
	for i, v in ipairs(self.Pilots) do
		if (v ~= PilotName) then
			newPilots[j] = v
			j = j + 1
		end
	end
	self.Pilots = newPilots
end

function A2G_Task:ClearPilots()
	self.Pilots = {}
end

function A2G_Task:GetPilots()
	return table.concat(self.Pilots, "\n")
end

function SEF_MissionSelector( TaskNumber )	
	if ( NumberOfCompletedMissions >= TotalScenarios ) then			
		OperationComplete = true
		trigger.action.outText("Operation Clear Field Has Been Successful", 15)
		ClearFieldUnitInterment = {}
		SEF_SaveUnitIntermentTableNoArgs()
		ClearFieldStaticInterment = {}
		SEF_SaveStaticIntermentTableNoArgs()			
	else
		Randomiser = math.random(1,TotalScenarios)
		if ( trigger.misc.getUserFlag(Randomiser) > 0 ) then
			SEF_MissionSelector(TaskNumber)
		elseif ( trigger.misc.getUserFlag(Randomiser) == 0 ) then
			trigger.action.setUserFlag(Randomiser,1)
			A2G_Task[TaskNumber] = A2G_Task:New(TaskNumber, A2G_Mission[Randomiser])
			SEF_ValidateMission(TaskNumber)										
		else
			trigger.action.outText("Mission Selection Error", 15)
		end
	end		
end

function SEF_ValidateMission(TaskNumber)
	local Number	= A2G_Task[TaskNumber]:GetMission().Number
	local isStatic	= A2G_Task[TaskNumber]:GetMission().Static
	local Target	= A2G_Task[TaskNumber]:GetMission().Target
	local Briefing	= A2G_Task[TaskNumber]:GetMission().Briefing
	
	if (isStatic == false and Target ~= nil) then
		if (GROUP:FindByName(Target):IsAlive() == true) then
			trigger.action.outText(Briefing,15)
		elseif (GROUP:FindByName(Target):IsAlive() == false or GROUP:FindByName(Target):isAlive() == nil) then
			trigger.action.setUserFlag(Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			SEF_MissionSelector(TaskNumber)
		else
			trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)
		end
	elseif (isStatic == true and Target ~= nil) then
		if ( StaticObject.getByName(Target) ~= nil and StaticObject.getByName(Target):isExist() == true ) then
			trigger.action.outText(Briefing,15)								
		elseif ( StaticObject.getByName(Target) == nil or StaticObject.getByName(Target):isExist() == false ) then
			trigger.action.setUserFlag(Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
			SEF_MissionSelector(TaskNumber)
		else
			trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
		end		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
	else		
		trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
	end
end

function SEF_SkipMission(TaskNumber)	
	local Number = A2G_Task[TaskNumber]:GetMission().Number
	if ( trigger.misc.getUserFlag(Number) >= 1 and trigger.misc.getUserFlag(Number) <= 3 ) then
		trigger.action.setUserFlag(Number,0) 
		SEF_MissionSelector(TaskNumber)
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end

function MissionSuccess()	
	local RandomMissionSuccessSound = math.random(1,5)
	trigger.action.outSound('AG Kill ' .. RandomMissionSuccessSound .. '.ogg')	
end

function SEF_MissionTargetStatus(TaskNumber, time)	
	local Number	= A2G_Task[TaskNumber]:GetMission().Number
	local isStatic	= A2G_Task[TaskNumber]:GetMission().Static
	local Target	= A2G_Task[TaskNumber]:GetMission().Target
	local Briefing	= A2G_Task[TaskNumber]:GetMission().Briefing

	if (isStatic == false and Target ~= nil) then					
		if (GROUP:FindByName(Target):IsAlive() == true) then
			return time + 10
			
		elseif (GROUP:FindByName(Target):IsAlive() == false or GROUP:FindByName(Target):IsAlive() == nil) then
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(TaskNumber)
			timer.scheduleFunction(SEF_MissionSelector, TaskNumber, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (isStatic == true and Target ~= nil) then
		if ( StaticObject.getByName(Target) ~= nil and StaticObject.getByName(Target):isExist() == true ) then
			return time + 10				
		else
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(TaskNumber)
			timer.scheduleFunction(SEF_MissionSelector, TaskNumber, timer.getTime() + 20)
			
			return time + 30				
		end		
	else		
		return time + 10
	end	
end

function SEF_InitializeMissionTable()	
	--KVEMO-ROKA
	A2G_Mission[1]	= A2G_Mission:Create(1):SetTarget("Kvemo Roka - AAA 1",false,"Destroy AAA assets located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21")
	A2G_Mission[2]	= A2G_Mission:Create(2):SetTarget("Kvemo Roka - Armor 1",false,"Destroy the T-90 Tanks located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21")	
	A2G_Mission[3]	= A2G_Mission:Create(3):SetTarget("Kvemo Roka - Armor 2",false,"Destroy APC's and IFV's located at Zemo-Roka\nKvemo-Roka Sector - Grid MN21")				
	A2G_Mission[4]	= A2G_Mission:Create(4):SetTarget("Kvemo Roka - Armor 3",false,"Destroy APC's and IFV's located at Elbakita\nKvemo-Roka Sector - Grid MM19")		
	A2G_Mission[5]	= A2G_Mission:Create(5):SetTarget("Kvemo Roka - SAM 1",false, "Destroy the SA-19 SAM located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21")
	A2G_Mission[6]	= A2G_Mission:Create(6):SetTarget("Kvemo Roka - Supply 1",false,"Destroy the Supply Trucks located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21")
	A2G_Mission[7]	= A2G_Mission:Create(7):SetTarget("Kvemo Roka - Convoy 1",false,"Destroy the Convoy located at Kvemo-Sba\nKvemo-Roka Sector - Grid MN31")

	--GORI
	A2G_Mission[8]	= A2G_Mission:Create(8):SetTarget("Gori - AAA 1",false,"Destroy AAA assets located South of Dzevera\nGori Sector - Grid MM26")
	A2G_Mission[9]	= A2G_Mission:Create(9):SetTarget("Gori - AAA 2",false,"Destroy AAA assets located at Gori\nGori Sector - Grid MM24")
	A2G_Mission[10] = A2G_Mission:Create(10):SetTarget("Gori - AAA 3",false,"Destroy AAA assets located at Ruisi\nGori Sector - Grid MM15")
	A2G_Mission[11] = A2G_Mission:Create(11):SetTarget("Gori - Armor 1",false,"Destroy the T-90 Tanks located South of Dzevera\nGori Sector - Grid MM26")
	A2G_Mission[12] = A2G_Mission:Create(12):SetTarget("Gori - Armor 2",false,"Destroy the T-80 Tanks located at Gori\nGori Sector - Grid MM24")
	A2G_Mission[13] = A2G_Mission:Create(13):SetTarget("Gori - Armor 3",false,"Destroy the T-90 Tanks located at Ruisi\nGori Sector - Grid MM15")
	A2G_Mission[14] = A2G_Mission:Create(14):SetTarget("Gori - Artillery 1",false,"Destroy the Artillery located South of Dzevera\nGori Sector - Grid MM26")
	A2G_Mission[15] = A2G_Mission:Create(15):SetTarget("Gori - Artillery 2",false,"Destroy the Artillery located at Gori\nGori Sector - Grid MM24")
	A2G_Mission[16] = A2G_Mission:Create(16):SetTarget("Gori - Artillery 3",false,"Destroy the Artillery located at Ruisi\nGori Sector - Grid MM15")
	A2G_Mission[17] = A2G_Mission:Create(17):SetTarget("Gori - SAM 1",false,"Destroy the Mobile SA-19 SAM located South of Dzevera\nGori Sector - Grid MM26")
	A2G_Mission[18] = A2G_Mission:Create(18):SetTarget("Gori - SAM 2",false,"Destroy the Mobile SA-15 SAM located at Gori\nGori Sector - Grid MM24")
	A2G_Mission[19] = A2G_Mission:Create(19):SetTarget("Gori - Supply 1",false,"Destroy the Supply Trucks located South of Dzevera\nGori Sector - Grid MM26")
	A2G_Mission[20] = A2G_Mission:Create(20):SetTarget("Gori - Supply 2",false,"Destroy the Supply Trucks located at Gori\nGori Sector - Grid MM24")
	A2G_Mission[21] = A2G_Mission:Create(21):SetTarget("Gori - Command 1",false,"Destroy the Mobile Command Post located at Ruisi\nGori Sector - Grid MM15")
		
	--GUDAUTA
	A2G_Mission[22] = A2G_Mission:Create(22):SetTarget("Gudauta - AAA 1",false,"Destroy AAA assets North of Gudauta Airbase\nGudauta Sector - Grid FH27")
	A2G_Mission[23] = A2G_Mission:Create(23):SetTarget("Gudauta - AAA 2",false,"Destroy AAA assets at Gudauta\nGudauta Sector - Grid FH37")
	A2G_Mission[24] = A2G_Mission:Create(24):SetTarget("Gudauta - Bomber 1",true,"Destroy the Mi-24V Attack Helicopter being refuelled North of Gudauta Airbase\nGudauta Sector - Grid FH27")
	A2G_Mission[25] = A2G_Mission:Create(25):SetTarget("Gudauta - Navy 1",false,"Destroy the Naval Vessels South of Pitsunda\nGudauta Sector - Grid FH16")
	A2G_Mission[26] = A2G_Mission:Create(26):SetTarget("Gudauta - SAM 1",false,"Destroy the Mobile SA-15 SAM North of Gudauta Airbase\nGudauta Sector - Grid FH27")
	A2G_Mission[27] = A2G_Mission:Create(27):SetTarget("Gudauta - Supply 1",false,"Destroy the Supply Trucks at Adzhapsha\nGudauta Sector - Grid FH47")
	A2G_Mission[28] = A2G_Mission:Create(28):SetTarget("Gudauta - Supply 2",false,"Destroy the Supply Trucks North of Gudauta Airbase\nGudauta Sector - Grid FH27")
	A2G_Mission[29] = A2G_Mission:Create(29):SetTarget("Gudauta - Comms",true,"Destroy the Communications Tower located West of Achkatsa\nGudauta Sector - Grid FH37")
	A2G_Mission[30] = A2G_Mission:Create(30):SetTarget("Gudauta - Military HQ",true,"Destroy the Military HQ at Gudauta\nGudauta Sector - Grid FH37")
	
	--////Major SAM Site
	A2G_Mission[31] = A2G_Mission:Create(31):SetTarget("Gudauta - SA-10",false,"Destroy the SA-10 site at Adzhapsha\nGudauta Sector - Grid FH47")
	
	--OCHAMCHIRA
	A2G_Mission[32] = A2G_Mission:Create(32):SetTarget("Ochamchira - AAA 1",false,"Destroy AAA assets located at Ochamchira\nOchamchira Sector - Grid GH03")
	A2G_Mission[33] = A2G_Mission:Create(33):SetTarget("Ochamchira - AAA 2",false,"Destroy AAA assets located at Repo-Etseri\nOchamchira Sector - Grid GH12")
	A2G_Mission[34] = A2G_Mission:Create(34):SetTarget("Ochamchira - Armor 1",false,"Destroy the IFV's located East of Ochamchira\nOchamchira Sector - Grid GH03")
	A2G_Mission[35] = A2G_Mission:Create(35):SetTarget("Ochamchira - Cargo Ships 1",false,"Destroy the Cargo Ships East of Ochamchira\nOchamchira Sector - Grid FH92")
	A2G_Mission[36] = A2G_Mission:Create(36):SetTarget("Ochamchira - Navy 1",false,"Destroy the Naval Vessels South of Ahali-Kindgi\nOchamchira Sector - Grid FH82")
	A2G_Mission[37] = A2G_Mission:Create(37):SetTarget("Ochamchira - SAM 1",false,"Destroy the Mobile SAM located at Ochamchira\nOchamchira Sector - Grid GH03")
	A2G_Mission[38] = A2G_Mission:Create(38):SetTarget("Ochamchira - Train Station",true,"Destroy the Train Station located at Ochamchira\nOchamchira Sector - Grid GH03")
	A2G_Mission[39] = A2G_Mission:Create(39):SetTarget("Ochamchira - Comms",true,"Destroy the Communications Tower located at Ochamchira\nOchamchira Sector - Grid GH03")
	A2G_Mission[40] = A2G_Mission:Create(40):SetTarget("Ochamchira - Military HQ",true,"Destroy the Military HQ at Ochamchira\nOchamchira Sector - Grid GH03")	
	
	--////SOCHI
	A2G_Mission[41] = A2G_Mission:Create(41):SetTarget("Sochi - AAA 1",false,"Destroy AAA assets at the Sochi docks\nSochi Sector - Grid EJ52")
	A2G_Mission[42] = A2G_Mission:Create(42):SetTarget("Sochi - Cargo Ships 1",false,"Destroy the Cargo Ships docked at Sochi docks\nSochi Sector - Grid EJ52")
	A2G_Mission[43] = A2G_Mission:Create(43):SetTarget("Sochi - Cargo Ships 2",false,"Destroy the Cargo Ships South-West of Adler\nSochi Sector - Grid EJ60")
	A2G_Mission[44] = A2G_Mission:Create(44):SetTarget("Sochi - Navy 1",false,"Destroy the Naval Vessels South-West of Sochi docks\nSochi Sector - Grid EJ52")
	A2G_Mission[45] = A2G_Mission:Create(45):SetTarget("Sochi - Navy 2",false,"Destroy the Submarines docked at Sochi docks\nSochi Sector - Grid EJ52")	
	A2G_Mission[46] = A2G_Mission:Create(46):SetTarget("Sochi - Supply 1",false,"Destroy the Supply Trucks at the SA-11 site West of Dagomys\nSochi Sector - Grid EJ53")
	A2G_Mission[47] = A2G_Mission:Create(47):SetTarget("Sochi - Comms",true,"Destroy the Communications Tower North-West of Razdol'noe\nSochi Sector - Grid EJ62")
	
	--////Major SAM Site
	A2G_Mission[48] = A2G_Mission:Create(48):SetTarget("Sochi - SA-11",false,"Destroy the SA-11 site West of Dagomys\nSochi Sector - Grid EJ53")
	
	--SUKHUMI
	A2G_Mission[49] = A2G_Mission:Create(49):SetTarget("Sukhumi - AAA 1",false,"Destroy AAA assets located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[50] = A2G_Mission:Create(50):SetTarget("Sukhumi - Cargo Ships 1",false,"Destroy the Cargo Ships South-West of Sukhumi\nSukhumi Sector - Grid FH55")
	A2G_Mission[51] = A2G_Mission:Create(51):SetTarget("Sukhumi - Cargo Ships 2",false,"Destroy the Cargo Ships at Kvemo-Merheuli Docks\nSukhumi Sector - Grid FH65")	
	A2G_Mission[52] = A2G_Mission:Create(52):SetTarget("Sukhumi - Navy 1",false,"Destroy the Naval Vessels West of Varcha\nSukhumi Sector - Grid FH54")
	A2G_Mission[53] = A2G_Mission:Create(53):SetTarget("Sukhumi - SAM 1",false,"Destroy the Mobile SAM located at Gumista\nSukhumi Sector - Grid FH56")
	A2G_Mission[54] = A2G_Mission:Create(54):SetTarget("Sukhumi - SAM 2",false,"Destroy the Mobile SAM located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[55] = A2G_Mission:Create(55):SetTarget("Sukhumi - Supply 1",false,"Destroy the Supply Trucks at the SA-10 site at Gul'ripsh\nSukhumi Sector - Grid FH75")	
	A2G_Mission[56] = A2G_Mission:Create(56):SetTarget("Sukhumi - Supply 2",false,"Destroy the Supply Trucks located at Sukhumi\nSukhumi Sector - Grid FH66")	
	A2G_Mission[57] = A2G_Mission:Create(57):SetTarget("Sukhumi - Train Station",true,"Destroy the Train Station located at Gumista\nSukhumi Sector - Grid FH56")	
	A2G_Mission[58] = A2G_Mission:Create(58):SetTarget("Sukhumi - Comms",true,"Destroy the Communications Tower North of Tavisupleba\nSukhumi Sector - Grid FH66")	
	
	--////Major SAM Site
	A2G_Mission[59] = A2G_Mission:Create(59):SetTarget("Sukhumi - SA-10",false,"Destroy the SA-10 site at Gul'ripsh\nSukhumi Sector - Grid FH75")	
	
	--TKVARCHELI
	A2G_Mission[60] = A2G_Mission:Create(60):SetTarget("Tkvarcheli - AAA 1",false,"Destroy AAA assets located at Tkvarcheli\nTkvarcheli Sector - Grid GH14")
	A2G_Mission[61] = A2G_Mission:Create(61):SetTarget("Tkvarcheli - AAA 2",false,"Destroy AAA assets located at Agvavera\nTkvarcheli Sector - Grid GH23")	
	A2G_Mission[62] = A2G_Mission:Create(62):SetTarget("Tkvarcheli - AAA 3",false,"Destroy AAA assets located at the Enguri Dam\nTkvarcheli Sector - Grid KN53")	
	A2G_Mission[63] = A2G_Mission:Create(63):SetTarget("Tkvarcheli - Armor 1",false,"Destroy APC's and IFV's located at Tkvarcheli\nTkvarcheli Sector - Grid GH14")
	A2G_Mission[64] = A2G_Mission:Create(64):SetTarget("Tkvarcheli - Armor 2",false,"Destroy the Armored Vehicles located at the Enguri Dam\nTkvarcheli Sector - Grid KN53")
	A2G_Mission[65] = A2G_Mission:Create(65):SetTarget("Tkvarcheli - Military HQ",true,"Destroy the Military HQ at Agvavera\nTkvarcheli Sector - Grid GH23")
	A2G_Mission[66] = A2G_Mission:Create(66):SetTarget("Tkvarcheli - SAM 1",false,"Destroy the Mobile SAM at Agvavera\nTkvarcheli Sector - Grid GH23")
	A2G_Mission[67] = A2G_Mission:Create(67):SetTarget("Tkvarcheli - Supply 1",false,"Destroy the Supply Trucks located at Agvavera\nTkvarcheli Sector - Grid GH23")	
	A2G_Mission[68] = A2G_Mission:Create(68):SetTarget("Tkvarcheli - Comms",true,"Destroy the Communications Tower on the mountain top North of the three rivers\nTkvarcheli Sector - Grid GH34")
	
	--TSKHINVALI
	A2G_Mission[69] = A2G_Mission:Create(69):SetTarget("Tskhinvali - AAA 1",false,"Destroy AAA assets located at Kurta\nTskhinvali Sector - Grid MM18")
	A2G_Mission[70] = A2G_Mission:Create(70):SetTarget("Tskhinvali - AAA 2",false,"Destroy AAA assets South of Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[71] = A2G_Mission:Create(71):SetTarget("Tskhinvali - Armor 1",false,"Destroy the APC's located at Kurta\nTskhinvali Sector - Grid MM18")
	A2G_Mission[72] = A2G_Mission:Create(72):SetTarget("Tskhinvali - Armor 2",false,"Destroy the APC's South of Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[73] = A2G_Mission:Create(73):SetTarget("Tskhinvali - Armor 3",false,"Destroy the APC's located at Ergneti\nTskhinvali Sector - Grid MM17")	
	A2G_Mission[74] = A2G_Mission:Create(74):SetTarget("Tskhinvali - Command 1",false,"Destroy the Mobile Command Vehicle located South of Tskhinvali\nTskhinvali Sector - Grid MM17")	
	A2G_Mission[75] = A2G_Mission:Create(75):SetTarget("Tskhinvali - Infantry 1",false,"Destroy the Infantry at the Road Outpost at Ergneti\nTskhinvali Sector - Grid MM17")
	A2G_Mission[76] = A2G_Mission:Create(76):SetTarget("Tskhinvali - Military Barracks",true,"Destroy the Military Barracks at Kurta\nTskhinvali Sector - Grid MM18")
	A2G_Mission[77] = A2G_Mission:Create(77):SetTarget("Tskhinvali - Outpost",true,"Destroy the Road Outpost at Ergneti\nTskhinvali Sector - Grid MM17")
	A2G_Mission[78] = A2G_Mission:Create(78):SetTarget("Tskhinvali - SAM 1",false,"Destroy the Mobile SAM located South of Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[79] = A2G_Mission:Create(79):SetTarget("Tskhinvali - SAM 2",false,"Destroy the Mobile SAM located at Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[80] = A2G_Mission:Create(80):SetTarget("Tskhinvali - Barracks",true,"Destroy the Military Barracks located at Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[81] = A2G_Mission:Create(81):SetTarget("Tskhinvali - Military HQ",true,"Destroy the Military HQ located at Tskhinvali\nTskhinvali Sector - Grid MM17")
	A2G_Mission[82] = A2G_Mission:Create(82):SetTarget("Tskhinvali - Supply 1",false,"Destroy the Supply Trucks located at Tskhinvali\nTskhinvali Sector - Grid MM17")
	
	--Zemo-Azhara
	A2G_Mission[83] = A2G_Mission:Create(83):SetTarget("Zemo Azhara - AAA 1",false,"Destroy AAA assets located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27")
	A2G_Mission[84] = A2G_Mission:Create(84):SetTarget("Zemo Azhara - AAA 2",false,"Destroy AAA assets located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37")
	A2G_Mission[85] = A2G_Mission:Create(85):SetTarget("Zemo Azhara - Armor 1",false,"Destroy the T-90 Tanks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27")
	A2G_Mission[86] = A2G_Mission:Create(86):SetTarget("Zemo Azhara - Armor 2",false,"Destroy APC's and IFV's located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37")
	A2G_Mission[87] = A2G_Mission:Create(87):SetTarget("Zemo Azhara - Armor 3",false,"Destroy the T-90 Tanks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37")
	A2G_Mission[88] = A2G_Mission:Create(88):SetTarget("Zemo Azhara - Artillery 1",false,"Destroy the Artillery located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27")
	A2G_Mission[89] = A2G_Mission:Create(89):SetTarget("Zemo Azhara - Artillery 2",false,"Destroy the Artillery located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37")
	A2G_Mission[90] = A2G_Mission:Create(90):SetTarget("Zemo Azhara - SAM 1",false,"Destroy the Mobile SAM located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27")
	A2G_Mission[91] = A2G_Mission:Create(91):SetTarget("Zemo Azhara - Supply 1",false,"Destroy the Supply Trucks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27")	
	
	--ZUGDIDI
	A2G_Mission[92] = A2G_Mission:Create(92):SetTarget("Zugdidi - AAA 1",false,"Destroy AAA assets located at Zeni\nZugdidi Sector - Grid GH20-GH21")
	A2G_Mission[93] = A2G_Mission:Create(93):SetTarget("Zugdidi - AAA 2",false,"Destroy AAA assets located East of Chuburhindzhi\nZugdidi Sector - Grid GH31")
	A2G_Mission[94] = A2G_Mission:Create(94):SetTarget("Zugdidi - Armor 1",false,"Destroy the T-80 Tanks located at Zeni\nZugdidi Sector - Grid GH20-GH21")
	A2G_Mission[95] = A2G_Mission:Create(95):SetTarget("Zugdidi - Armor 2",false,"Destroy the T-90 Tanks located East of Chuburhindzhi\nZugdidi Sector - Grid GH31")
	A2G_Mission[96] = A2G_Mission:Create(96):SetTarget("Zugdidi - Armor 3",false,"Destroy the IFV's located North of Pahulani\nZugdidi Sector - Grid GH42")	
	A2G_Mission[97] = A2G_Mission:Create(97):SetTarget("Zugdidi - Artillery 1",false,"Destroy the Artillery located at Zeni\nZugdidi Sector - Grid GH20-GH21")
	A2G_Mission[98] = A2G_Mission:Create(98):SetTarget("Zugdidi - Artillery 2",false,"Destroy the Artillery located East of Chuburhindzhi\nZugdidi Sector - Grid GH31")
	A2G_Mission[99] = A2G_Mission:Create(99):SetTarget("Zugdidi - SAM 1",false,"Destroy the Mobile SAM located East of Chuburhindzhi\nZugdidi Sector - Grid GH31")
	A2G_Mission[100] = A2G_Mission:Create(100):SetTarget("Zugdidi - SAM 2",false,"Destroy the Mobile SAM located North of Pahulani\nZugdidi Sector - Grid GH42")
	
	--////Expanded List 1
	A2G_Mission[101] = A2G_Mission:Create(101):SetTarget("Sochi - EWR Veseloe",false,"Destroy the Early Warning Radar located at Veseloe\nSochi Sector - Grid EJ80")
	A2G_Mission[102] = A2G_Mission:Create(102):SetTarget("Gudauta - EWR Gudauta 1",false,"Destroy the Early Warning Radar located at Algyt\nGudauta Sector - Grid FH27")
	A2G_Mission[103] = A2G_Mission:Create(103):SetTarget("Gudauta - EWR Gudauta 2",false,"Destroy the Early Warning Radar located at Adzhapsha\nGudauta Sector - Grid FH47")
	A2G_Mission[104] = A2G_Mission:Create(104):SetTarget("Sukhumi - EWR Kvemo-Merheuli",false,"Destroy the Early Warning Radar at Kvemo-Merheuli\nSukhumi Sector - Grid FH65")
	A2G_Mission[105] = A2G_Mission:Create(105):SetTarget("Sukhumi - EWR Sukhumi",false,"Destroy the Early Warning Radar at the Sukhumi Airbase\nSukhumi Sector - Grid FH74")
	
	--////Expanded List 2
	A2G_Mission[106] = A2G_Mission:Create(106):SetTarget("Ochamchira - Naval Repair",true,"Destroy the Repair Yard at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93")
	A2G_Mission[107] = A2G_Mission:Create(107):SetTarget("Ochamchira - AAA 3",false,"Destroy the AAA Assets at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93")
	A2G_Mission[108] = A2G_Mission:Create(108):SetTarget("Sukhumi - Military Warehouse",true,"Destroy the Warehouse located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[109] = A2G_Mission:Create(109):SetTarget("Sukhumi - Military HQ",true,"Destroy the Military HQ located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[110] = A2G_Mission:Create(110):SetTarget("Gudauta - Lidzava Military Barracks",true,"Destroy the Military Barracks located at Lidzava\nGudauta Sector - Grid FH18")
	A2G_Mission[111] = A2G_Mission:Create(111):SetTarget("Gudauta - Achandara Military Barracks",true,"Destroy the Achandara Military Barracks located South of Aosyrhva\nGudauta Sector - Grid FH38")
	A2G_Mission[112] = A2G_Mission:Create(112):SetTarget("Gudauta - Infantry 1",false,"Destroy the Infantry at the Achandara Military Barracks located South of Aosyrhva\nGudauta Sector - Grid FH38")
	A2G_Mission[113] = A2G_Mission:Create(113):SetTarget("Sukhumi - Boat Bunker",true,"Destroy the Boat Bunker located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[114] = A2G_Mission:Create(114):SetTarget("Sukhumi - Navy 2",false,"Destroy the Armed Speedboats located at Sukhumi\nSukhumi Sector - Grid FH66")
	A2G_Mission[115] = A2G_Mission:Create(115):SetTarget("Ochamchira - Navy 2",false,"Destroy the Armed Speedboats at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93")
	A2G_Mission[116] = A2G_Mission:Create(116):SetTarget("Gudauta - Armor 1",false,"Destroy the T-72 Tanks located at the Lidzava Military Barracks\nGudauta Sector - Grid FH18")
	A2G_Mission[117] = A2G_Mission:Create(117):SetTarget("Kvemo Roka - Convoy 2",false,"Destroy the Convoy located at Kvemo-Khoshka\nKvemo-Roka Sector - Grid MN20")
	A2G_Mission[118] = A2G_Mission:Create(118):SetTarget("Tkvarcheli - Transport",true,"Destroy the Mi-8MTV2 Helicopter located at Agvavera\nTkvarcheli Sector - Grid GH23")
	A2G_Mission[119] = A2G_Mission:Create(119):SetTarget("Zemo Azhara - Supply 2",false,"Destroy the Supply Trucks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37")
	A2G_Mission[120] = A2G_Mission:Create(120):SetTarget("Zugdidi - Saberio Border Post",true,"Destroy the Road Outpost located South of Saberio\nZugdidi Sector - Grid GH32")
	A2G_Mission[121] = A2G_Mission:Create(121):SetTarget("Zugdidi - Infantry 1",false,"Destroy the Infantry at the Road Outpost located South of Saberio\nZugdidi Sector - Grid GH32")
	A2G_Mission[122] = A2G_Mission:Create(122):SetTarget("Zugdidi - Gali Military Barracks",true,"Destroy the Military Barracks located at Gali\nZugdidi Sector - Grid GH22")
	A2G_Mission[123] = A2G_Mission:Create(123):SetTarget("Zugdidi - Infantry 2",false,"Destroy the Infantry at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22")
	A2G_Mission[124] = A2G_Mission:Create(124):SetTarget("Zugdidi - Supply 1",false,"Destroy the Supply Trucks at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22")
	A2G_Mission[125] = A2G_Mission:Create(125):SetTarget("Zugdidi - Armor 4",false,"Destroy the IFV's at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22")
end

local function CheckObjectiveRequest(PlayerGroup)	
	local grpID = PlayerGroup:getID()
	local PlayerUnit = UNIT:FindByName(PlayerGroup:getUnit(1):getName())
	local PlayerCoord = PlayerUnit:GetCoordinate()	

	local TaskNumber = 1

	
	while A2G_Task[TaskNumber]:GetMission().Briefing ~= nil do

		local isStatic	= A2G_Task[TaskNumber]:GetMission().Static
		local Target	= A2G_Task[TaskNumber]:GetMission().Target
		local Briefing	= A2G_Task[TaskNumber]:GetMission().Briefing
		local Pilots	= A2G_Task[TaskNumber]:GetPilots()
				
		if  (isStatic == false) then
			TargetGroup = GROUP:FindByName(Target)	
		else
			TargetGroup = STATIC:FindByName(Target, false)
		end
		TargetCoord = TargetGroup:GetCoordinate()
		PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
		PlayerBR = PlayerCoord:GetDistanceText(PlayerDistance, SETTINGS:SetImperial())
		trigger.action.outTextForGroup(grpID, (TaskNumber == 1 and "Objective Alpha\n" or TaskNumber == 2 and "Objective Bravo\n" or TaskNumber == 3 and "Objective Charlie\n")..Briefing.." - "..PlayerBR.."\nAssigned Pilots\n", 15)

		TaskNumber = TaskNumber + 1
	end

	if ( OperationComplete == true ) then
		trigger.action.outTextForGroup(grpID, "The Operation Has Been Completed, There Are No Further Objectives", 15)
	end

	if ( (A2G_Task[1]:GetMission().Briefing == nil and A2G_Task[2]:GetMission().Briefing == nil and A2G_Task[3]:GetMission().Briefing == nil ) and OperationComplete == false ) then
		trigger.action.outTextForGroup(grpID, "Check Objective Request Error - No Briefing Available And Operation Is Not Completed", 15)
	end	
end


function TargetReport(PlayerGroup, TaskNumber)
	local Number	= A2G_Task[TaskNumber]:GetMission().Number
	local isStatic	= A2G_Task[TaskNumber]:GetMission().Static
	local Target	= A2G_Task[TaskNumber]:GetMission().Target
	local Briefing	= A2G_Task[TaskNumber]:GetMission().Briefing

	if (Target ~=nil) then
		if  (isStatic == false) then
			TargetGroup = GROUP:FindByName(Target)	
			TargetRemainingUnits = Group.getByName(Target):getSize()	
		else
			TargetGroup = STATIC:FindByName(Target, false)
			TargetRemainingUnits = 1
		end
			
		ClientGroupName = PlayerGroup 			
		ClientGroupID = ClientGroupName:getID()	   
		PlayerDCSUnit = PlayerGroup:getUnit(1)
		PlayerUnit = UNIT:FindByName(PlayerGroup:getUnit(1):getName())
		PlaneType = PlayerDCSUnit:getTypeName()
		
		A2G_Task[1]:RemovePilot(PlayerDCSUnit:getPlayerName())
		A2G_Task[2]:RemovePilot(PlayerDCSUnit:getPlayerName())
		A2G_Task[3]:RemovePilot(PlayerDCSUnit:getPlayerName())
		A2G_Task[TaskNumber]:AddPilot(PlayerDCSUnit:getPlayerName())
			
		PlayerCoord = PlayerUnit:GetCoordinate()
		TargetCoord = TargetGroup:GetCoordinate()
		TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
		TargetHeightFt = math.floor(TargetHeight * 3.28084)
		PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

		TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
		TargetBearing = PlayerCoord:GetAngleRadians(TargetVector)	

		PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
		
		if (TargetRemainingUnits > 1) then
			SZMessage = "There are "..TargetRemainingUnits.." targets remaining" 
		elseif (TargetRemainingUnits == 1) then
			SZMessage = "There is "..TargetRemainingUnits.." target remaining" 
		elseif (TargetRemainingUnits == nil) then					
			SZMessage = "Unable To Determine Group Size"
		else			
			SZMessage = "Nothing to report"		
		end		
			
		BRMessage = ", Bearing: "..PlayerBR
		ELEMessage = "Elevation: "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
		PlayersAssigned = A2G_Task[TaskNumber]:GetPilots()
					
		_SETTINGS:SetLL_Accuracy(0)
		CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
		_SETTINGS:SetLL_Accuracy(3)
		CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
		_SETTINGS:SetLL_Accuracy(2)
		CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())


		trigger.action.outTextForGroup(ClientGroupID, "Target Report for "..(TaskNumber == 1 and "Objective Alpha" or TaskNumber == 2 and "Objective Bravo" or TaskNumber == 3 and "Objective Charlie"), 40)
		if (PlaneType == "F-16C_50") then
			trigger.action.outTextForGroup(ClientGroupID, Briefing.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage..BRMessage.."\n".."\nPilots Assigned:\n"..PlayersAssigned, 40)
		elseif (PlaneType == "F/A-18C_hornet") then
			trigger.action.outTextForGroup(ClientGroupID, Briefing.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage..BRMessage.."\n".."\nPilots Assigned:\n"..PlayersAssigned, 40)
		elseif (PlaneType == "Su-25T") then
			trigger.action.outTextForGroup(ClientGroupID, Briefing.."\n"..SZMessage.."\n".."\n"..ELEMessage..BRMessage.."\n".."\nPilots Assigned:\n"..PlayersAssigned, 40)
		else
			trigger.action.outTextForGroup(ClientGroupID, Briefing.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage..BRMessage.."\n".."\nPilots Assigned:\n"..PlayersAssigned, 40)
		end
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end

function RequestFighterSupport(CAPSector)	
	if ( trigger.misc.getUserFlag(5001) == 1 ) then	
		if ( trigger.misc.getUserFlag(5010) == 0 ) then			
			local RouteNumber = CAPSector			
			BLUECAP1 = SPAWN
				:New( "RT BLUE CAP "..RouteNumber )
				:InitLimit( 2, 2 )
				:InitRandomizeTemplate( { "SQ BLUE CAP F-15C" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUECAPGROUPNAME = SpawnGroup.GroupName
						RTBLUECAPGROUPID = Group.getByName(RTBLUECAPGROUPNAME):getID()												
					end
				)				
				:Spawn()
			trigger.action.outText("Fighter Screen Launched",60)
			trigger.action.setUserFlag(5010,1)
		elseif ( trigger.misc.getUserFlag(5010) == 1) then						
			if ( BLUECAP1:IsAlive() ) then
				trigger.action.outText("Fighter Screen Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5010,0)
				RequestFighterSupport(CAPSector)
			end	
		end
	else
		trigger.action.outText("Fighter Screen Unavailable For This Mission",60)		
	end
end

function AbortCAPMission()
	if (trigger.misc.getUserFlag(5010) == 1 ) then
		if ( GROUP:FindByName(RTBLUECAPGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 8								
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUECAPGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUECAPGROUPNAME):getController():setCommand(RTBTask)			
			trigger.action.outText("Fighter Screen Is Returning To Base",60)
		else
			trigger.action.outText("Fighter Screen Does Not Have Fighters To Recall",60)
		end
	else
		trigger.action.outText("Fighter Screen Has Not Been Deployed",60)
	end
end

function RequestCASSupport(CASSector)
	if ( trigger.misc.getUserFlag(5002) == 1 ) then
		if ( trigger.misc.getUserFlag(5020) == 0 ) then
			local RouteNumber = CASSector			
			BLUECAS1 = SPAWN
				:New( "RT BLUE CAS "..RouteNumber )
				:InitLimit( 2, 2 )
				:InitRandomizeTemplate( { "SQ BLUE CAS A-10C" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUECASGROUPNAME = SpawnGroup.GroupName
						RTBLUECASGROUPID = Group.getByName(RTBLUECASGROUPNAME):getID()												
					end
				)
				:Spawn()			
			trigger.action.outText("Close Air Support Launched",60)
			trigger.action.setUserFlag(5020,1)			
		elseif ( trigger.misc.getUserFlag(5020) == 1) then			
			if ( BLUECAS1:IsAlive() ) then
				trigger.action.outText("Close Air Support Is Currently Active, Further Support Is Unavailable",60)
			else				
				trigger.action.setUserFlag(5020,0)
				RequestCASSupport(CASSector)
			end	
		end
	else
		trigger.action.outText("Close Air Support Unavailable For This Mission",60)
	end	
end

function AbortCASMission()
	if ( trigger.misc.getUserFlag(5020) == 1 ) then
		if ( GROUP:FindByName(RTBLUECASGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 7								
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}			
			Group.getByName(RTBLUECASGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUECASGROUPNAME):getController():setCommand(RTBTask)	
			trigger.action.outText("Close Air Support Is Returning To Base",60)
		else
			trigger.action.outText("Close Air Support Does Not Have Planes To Recall",60)
		end
	else
		trigger.action.outText("Close Air Support Has Not Been Deployed",60)
	end
end

function RequestASSSupport(ASSSector)	
	if ( trigger.misc.getUserFlag(5003) == 1 ) then	
		if ( trigger.misc.getUserFlag(5030) == 0 ) then			
			local RouteNumber = ASSSector			
			BLUEASS1 = SPAWN
				:New( "RT BLUE ASS "..RouteNumber )
				:InitLimit( 2, 2 )
				:InitRandomizeTemplate( { "SQ BLUE ASS AJS37" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUEASSGROUPNAME = SpawnGroup.GroupName
						RTBLUEASSGROUPID = Group.getByName(RTBLUEASSGROUPNAME):getID()												
					end
				)
				:Spawn()
			trigger.action.outText("Anti-Shipping Strike Launched",60)
			trigger.action.setUserFlag(5030,1)			
		elseif ( trigger.misc.getUserFlag(5030) == 1) then			
			if ( BLUEASS1:IsAlive() ) then
				trigger.action.outText("Anti-Shipping Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5030,0)
				RequestASSSupport(ASSSector)
			end
		end
	else
		trigger.action.outText("Anti-Shipping Strike Unavailable For This Mission",60)	
	end	
end

function AbortASSMission()
	if ( trigger.misc.getUserFlag(5030) == 1 ) then
		if ( GROUP:FindByName(RTBLUEASSGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 7								
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUEASSGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUEASSGROUPNAME):getController():setCommand(RTBTask)			
			trigger.action.outText("Anti-Shipping Support Is Returning To Base",60)
		else
			trigger.action.outText("Anti-Shipping Support Does Not Have Planes To Recall",60)
		end
	else
		trigger.action.outText("Anti-Shipping Support Has Not Been Deployed",60)
	end
end

function RequestSEADSupport(SEADSector)	
	if ( trigger.misc.getUserFlag(5004) == 1 ) then
		if ( trigger.misc.getUserFlag(5040) == 0 ) then			
			local RouteNumber = SEADSector			
			BLUESEAD1 = SPAWN
				:New( "RT BLUE SEAD "..RouteNumber )
				:InitLimit( 2, 2 )
				:InitRandomizeTemplate( { "SQ BLUE SEAD F-16C", "SQ BLUE SEAD F/A-18C" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUESEADGROUPNAME = SpawnGroup.GroupName
						RTBLUESEADGROUPID = Group.getByName(RTBLUESEADGROUPNAME):getID()	
												
					end
				)
				:Spawn()			
			trigger.action.outText("SEAD Mission Launched",60)
			trigger.action.setUserFlag(5040,1)
		elseif ( trigger.misc.getUserFlag(5040) == 1) then			
			if ( BLUESEAD1:IsAlive() ) then
				trigger.action.outText("SEAD Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5040,0)
				RequestSEADSupport(SEADSector)
			end
		end
	else
		trigger.action.outText("SEAD Unavailable For This Mission",60)
	end		
end

function AbortSEADMission()
	if ( trigger.misc.getUserFlag(5040) == 1 ) then
		if ( GROUP:FindByName(RTBLUESEADGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 7
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUESEADGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUESEADGROUPNAME):getController():setCommand(RTBTask)			
			trigger.action.outText("SEAD Support Is Returning To Base",60)
		else
			trigger.action.outText("SEAD Support Does Not Have Planes To Recall",60)
		end
	else
		trigger.action.outText("SEAD Support Has Not Been Deployed",60)
	end
end


--////PINPOINT STRIKE
function RequestPINSupport(PinSector)	
	if ( trigger.misc.getUserFlag(5005) == 1 ) then
		if ( trigger.misc.getUserFlag(5050) == 0 ) then			
			PINRouteNumber = PinSector			
			BLUEPIN1 = SPAWN
				:New( "RT BLUE PIN "..PINRouteNumber )
				:InitLimit( 2, 2 )
				:InitRandomizeTemplate( { "SQ BLUE PIN F-117A", "SQ BLUE PIN Tornado GR4", "SQ BLUE PIN F-15E" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUEPINGROUPNAME = SpawnGroup.GroupName
						RTBLUEPINGROUPID = Group.getByName(RTBLUEPINGROUPNAME):getID()												
					end
				)
				:Spawn()			
			trigger.action.outText("Pinpoint Strike Mission Launched",60)
			trigger.action.setUserFlag(5050,1)
		elseif ( trigger.misc.getUserFlag(5050) == 1) then			
			if ( BLUEPIN1:IsAlive() ) then
				trigger.action.outText("Pinpoint Strike Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5050,0)
				RequestPINSupport(PinSector)
			end		
		end
	else
		trigger.action.outText("Pinpoint Strike Unavailable For This Mission",60)
	end	
end

function AbortPINMission()

	if ( trigger.misc.getUserFlag(5050) == 1 ) then
		if ( GROUP:FindByName(RTBLUEPINGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 7								
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUEPINGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUEPINGROUPNAME):getController():setCommand(RTBTask)	
			
			trigger.action.outText("Pinpoint Strike Support Is Returning To Base",60)
		else
			trigger.action.outText("Pinpoint Strike Support Does Not Have Planes To Recall",60)
		end
	else
		trigger.action.outText("Pinpoint Strike Support Has Not Been Deployed",60)
	end
end

function SEF_PinpointStrikeTargetAcquisition()
	if ( AGMissionTarget ~= nil and string.find(AGMissionTarget, PINRouteNumber) ) then		
		if ( AGTargetTypeStatic == true ) then
			if ( StaticObject.getByName(AGMissionTarget):isExist() == true ) then
				TargetGroupPIN = STATIC:FindByName(AGMissionTarget, false)
				TargetCoordForStrike = TargetGroupPIN:GetCoordinate():GetVec2()
					
				local target = {}
				target.point = TargetCoordForStrike
				target.expend = "Two"
				target.weaponType = 14
				target.attackQty = 1
				target.groupAttack = true
				local engage = {id = 'Bombing', params = target}
				Group.getByName(RTBLUEPINGROUPNAME):getController():pushTask(engage)
				trigger.action.outText("The Pinpoint Strike Flight Reports Target Coordinates Are Locked In And They Are Engaging!", 15)	
			else
				trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target, Aborting Mission", 15)
				AbortPINMission()
			end
		elseif ( AGTargetTypeStatic == false ) then
			if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
				TargetGroupPIN = GROUP:FindByName(AGMissionTarget, false)
				TargetCoordForStrike = TargetGroupPIN:GetCoordinate():GetVec2()
					
				local target = {}
				target.point = TargetCoordForStrike
				target.expend = "Two"
				target.weaponType = 14 -- See https://wiki.hoggitworld.com/view/DCS_enum_weapon_flag for other weapon launch codes
				target.attackQty = 1
				target.groupAttack = true
				local engage = {id = 'Bombing', params = target}
				Group.getByName(RTBLUEPINGROUPNAME):getController():pushTask(engage)
				trigger.action.outText("The Pinpoint Strike Flight Reports Target Coordinates Are Locked In And They Are Engaging!", 15)		
			else
				trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target", 15)
				AbortPINMission()
			end
		else
			trigger.action.outText("Pinpoint Strike Mission Unable To Locate Target", 15)
			AbortPINMission()
		end
	else
		trigger.action.outText("The Pinpoint Strike Flight Reports The Mission Target Is Not In Their Designated Sector", 15)
		AbortPINMission()		
	end	
end

--////DRONE JTAC
function RequestDroneSupport(DRONESector)	
	if ( trigger.misc.getUserFlag(5891) == 1 ) then	
		if ( trigger.misc.getUserFlag(5892) == 0 ) then			
			local RouteNumber = DRONESector			
			BLUEDRONE1 = SPAWN
				:New( "RT BLUE Drone "..RouteNumber )
				:InitLimit( 1, 1 )
				:InitRandomizeTemplate( { "SQ BLUE MQ-9 Reaper" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTBLUEDRONEGROUPNAME = SpawnGroup.GroupName
						RTBLUEDRONEGROUPID = Group.getByName(RTBLUEDRONEGROUPNAME):getID()												
					end
				)				
				:Spawn()			
			trigger.action.outText("MQ-9 Reaper Aerial Drone Launched",60)
			trigger.action.setUserFlag(5892,1)			
		elseif ( trigger.misc.getUserFlag(5892) == 1) then						
			if ( BLUEDRONE1:IsAlive() ) then
				trigger.action.outText("MQ-9 Reaper Aerial Drone Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5892,0)
				RequestDroneSupport(DRONESector)
			end
		end
	else
		trigger.action.outText("MQ-9 Reaper Aerial Drone Unavailable For This Mission",60)		
	end
end

function AbortDroneMission()

	if (trigger.misc.getUserFlag(5892) == 1 ) then
		if ( GROUP:FindByName(RTBLUEDRONEGROUPNAME):IsAlive() ) then
			local RTB = {}
			RTB.goToWaypointIndex = 3								
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUEDRONEGROUPNAME):getController():setOption(0, 3)
			Group.getByName(RTBLUEDRONEGROUPNAME):getController():setCommand(RTBTask)	
			
			trigger.action.outText("MQ-9 Reaper Aerial Drone Is Returning To Base",60)
		else
			trigger.action.outText("MQ-9 Reaper Aerial Drone Is Unable To Be Recalled",60)
		end
	else
		trigger.action.outText("MQ-9 Reaper Aerial Drone Has Not Been Deployed",60)
	end
end

function SEF_CAPCommenceAttack()
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Fighter Screen Commence Attack", nil, function() trigger.action.setUserFlag(5011,1) end, nil)
	trigger.action.outText("Fighter Screen Push Command Available",60)
end

function SEF_CASCommenceAttack()
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Close Air Support Commence Attack", nil, function() trigger.action.setUserFlag(5021,1) end, nil)
	trigger.action.outText("Close Air Support Push Command Available",60)
end

function SEF_AntiShipCommenceAttack()
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Anti-Ship Strike Commence Attack", nil, function() trigger.action.setUserFlag(5031,1) end, nil)
	trigger.action.outText("Anti-Ship Strike Push Command Available",60)
end

function SEF_SEADCommenceAttack()
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "SEAD Commence Attack", nil, function() trigger.action.setUserFlag(5041,1) end, nil)
	trigger.action.outText("SEAD Push Command Available",60)
end

function SEF_PinpointStrikeCommenceAttack()
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Pinpoint Strike Commence Attack", nil, function() trigger.action.setUserFlag(5051,1) end, nil)
	trigger.action.outText("Pinpoint Strike Push Command Available",60)
end

function SEF_CAPRemovePush()
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = nil, [2] = "Fighter Screen Commence Attack"})
	trigger.action.setUserFlag(5011,0)
end

function SEF_CASRemovePush()
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = nil, [2] = "Close Air Support Commence Attack"})
	trigger.action.setUserFlag(5021,0)
end

function SEF_ASSRemovePush()
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = nil, [2] = "Anti-Ship Strike Commence Attack"})
	trigger.action.setUserFlag(5031,0)
end

function SEF_SEADRemovePush()
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = nil, [2] = "SEAD Commence Attack"})
	trigger.action.setUserFlag(5041,0)
end

function SEF_PINRemovePush()
	missionCommands.removeItemForCoalition(coalition.side.BLUE, {[1] = nil, [2] = "Pinpoint Strike Commence Attack"})
	trigger.action.setUserFlag(5051,0)
end

function SEF_CheckAIPushFlags( timeloop, time )	
	if ( trigger.misc.getUserFlag(5011) == 1 ) then
		timer.scheduleFunction(SEF_CAPRemovePush, 53, timer.getTime() + 1)
		return time + 2
	elseif ( trigger.misc.getUserFlag(5021) == 1 ) then
		timer.scheduleFunction(SEF_CASRemovePush, 53, timer.getTime() + 1)
		return time + 2
	elseif ( trigger.misc.getUserFlag(5031) == 1 ) then
		timer.scheduleFunction(SEF_ASSRemovePush, 53, timer.getTime() + 1)
		return time + 2
	elseif ( trigger.misc.getUserFlag(5041) == 1 ) then
		timer.scheduleFunction(SEF_SEADRemovePush, 53, timer.getTime() + 1)
		return time + 2
	elseif ( trigger.misc.getUserFlag(5051) == 1 ) then
		timer.scheduleFunction(SEF_PINRemovePush, 53, timer.getTime() + 1)
		return time + 2
	else
		return time + 2
	end
end

function addRadioCommands()

	timer.scheduleFunction(addRadioCommands, nil, timer.getTime() + 10)

	local blueGroups = coalition.getGroups(coalition.side.BLUE)
	local x = 1

	if blueGroups ~= nil then
        for x, tmpGroup in pairs(blueGroups) do
            local index = "GROUP_" .. Group.getID(tmpGroup)
            if GLOBAL_JTAC_RADIO_ADDED[index] == nil then
                missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Current Objectives", nil, function() CheckObjectiveRequest(tmpGroup) end, nil)
                missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Objective Alpha", nil, function() TargetReport(tmpGroup, 1) end, nil)
                missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Objective Bravo", nil, function() TargetReport(tmpGroup, 2) end, nil)
                missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Objective Charlie", nil, function() TargetReport(tmpGroup, 3) end, nil)

				Support = missionCommands.addSubMenuForGroup(Group.getID(tmpGroup), "Mission Support")
				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Abort Objective Alpha", Support, function() SEF_SkipMission(1) end, nil)
				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Abort Objective Bravo", Support, function() SEF_SkipMission(2) end, nil)
				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Abort Objective Charlie", Support, function() SEF_SkipMission(3) end, nil)

				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Flare Objective Alpha", Support, function() SEF_TargetSmoke(1) end, nil)
				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Flare Objective Bravo", Support, function() SEF_TargetSmoke(2) end, nil)
				missionCommands.addCommandForGroup(Group.getID(tmpGroup), "Flare Objective Charlie", Support, function() SEF_TargetSmoke(3) end, nil)
                GLOBAL_JTAC_RADIO_ADDED[index] = true
            end
        end
    end

end

function SEF_ROEWeaponFreeStennis()	
	Group.getByName("CVN-74 John C. Stennis"):getController():setOption(0, 2)
end

function SEF_ROEWeaponFreeTarawa()	
	Group.getByName("LHA-1 Tarawa"):getController():setOption(0, 2)
end

function SEF_ROEHoldStennis()	
	Group.getByName("CVN-74 John C. Stennis"):getController():setOption(0, 4)
end

function SEF_ROEHoldTarawa()	
	Group.getByName("LHA-1 Tarawa"):getController():setOption(0, 4)
end

function SEF_StennisShipTargeting()		
	SEF_ROEWeaponFreeStennis()	
	timer.scheduleFunction(SEF_ROEHoldStennis, {}, timer.getTime() + 5) 	
end

function SEF_TarawaShipTargeting()		
	SEF_ROEWeaponFreeTarawa()	
	timer.scheduleFunction(SEF_ROEHoldTarawa, {}, timer.getTime() + 5) 	
end

function SEF_CarrierStennisDefenceZone()
	CarrierStennisDefenceZone = ZONE_GROUP:New("Carrier Stennis", GROUP:FindByName( "CVN-74 John C. Stennis" ), 40233) --Approx 25nm		
end

function SEF_CarrierTarawaDefenceZone()
	CarrierTarawaDefenceZone = ZONE_GROUP:New("Carrier Tarawa", GROUP:FindByName( "LHA-1 Tarawa" ), 24140)	--Approx 15nm	
end

function SEF_NavalDefenceZoneScanner(Timeloop, time)
	StennisScanResult = CarrierStennisDefenceZone:Scan( { Unit.Category.AIRPLANE, Unit.Category.HELICOPTER } )
	StennisRedPresense = CarrierStennisDefenceZone:IsSomeInZoneOfCoalition(coalition.side.RED)
	StennisDefenceZoneCount = 0			
	if ( StennisRedPresense == true ) then				
		SET_CARRIERSTENNISDEFENCE = SET_UNIT:New():FilterCoalitions( "red" ):FilterCategories({"helicopter","plane"}):FilterOnce()		
		SET_CARRIERSTENNISDEFENCE:ForEachUnitCompletelyInZone( CarrierStennisDefenceZone, function ( GroupObject )
			StennisDefenceZoneCount = StennisDefenceZoneCount + 1
			end
		)		
		if ( StennisDefenceZoneCount > 1 ) then	
			SEF_StennisShipTargeting()						
		elseif ( StennisDefenceZoneCount == 1 ) then
			SEF_StennisShipTargeting()
		end
	end
	TarawaScanResult = CarrierTarawaDefenceZone:Scan( { Unit.Category.AIRPLANE, Unit.Category.HELICOPTER } )
	TarawaRedPresense = CarrierTarawaDefenceZone:IsSomeInZoneOfCoalition(coalition.side.RED)
	TarawaDefenceZoneCount = 0
			
	if ( TarawaRedPresense == true ) then				
		SET_CARRIERTARAWADEFENCE = SET_UNIT:New():FilterCoalitions( "red" ):FilterCategories({"helicopter","plane"}):FilterOnce()		
		SET_CARRIERTARAWADEFENCE:ForEachUnitCompletelyInZone( CarrierTarawaDefenceZone, function ( GroupObject )
			TarawaDefenceZoneCount = TarawaDefenceZoneCount + 1
			end
		)		
		if ( TarawaDefenceZoneCount > 1 ) then	
			SEF_TarawaShipTargeting()						
		elseif ( TarawaDefenceZoneCount == 1 ) then	
			SEF_TarawaShipTargeting()			
		else
		end		
	else
	end	
	
	return time + 20	
end

function SEF_DisableShips()
	Group.getByName("Gudauta - Navy 1"):getController():setOnOff(false)
	Group.getByName("Ochamchira - Navy 1"):getController():setOnOff(false)
	Group.getByName("Sukhumi - Navy 1"):getController():setOnOff(false)
	Group.getByName("Sochi - Navy 1"):getController():setOnOff(false)
		
	trigger.action.outText("Naval Vessel AI is now off", 15)
end

function SEF_ToggleFiringSounds()

	if ( OnShotSoundsEnabled == 0 ) then
		OnShotSoundsEnabled = 1
		trigger.action.outText("Firing Sounds Are Now Enabled", 15)
	elseif ( OnShotSoundsEnabled == 1 ) then
		OnShotSoundsEnabled = 0
		trigger.action.outText("Firing Sounds Are Now Disabled", 15)
	else		
	end
end

function SEF_RedBomberAttack()	
	if ( trigger.misc.getUserFlag(5006) == 1 ) then
		if ( trigger.misc.getUserFlag(5070) == 0 ) then			
			local RouteNumber = math.random(1,2)			
			REDBomberTarget = "RED Bomber Target "..RouteNumber			
			REDPIN1 = SPAWN
				:New( "RT RED PIN "..RouteNumber )
				:InitLimit( 2, 1 )
				:InitRandomizeTemplate( { "SQ RUS Tu-95MS", "SQ RUS Tu-160", "SQ RUS Su-24M", "SQ RUS Tu-22M3", "SQ RUS Su-25" } )
				:OnSpawnGroup(
					function( SpawnGroup )								
						RTREDPINGROUPNAME = SpawnGroup.GroupName
						RTREDPINGROUPID = Group.getByName(RTREDPINGROUPNAME):getID()												
					end
				)
				:Spawn()
			trigger.action.setUserFlag(5070,1)			
		elseif ( trigger.misc.getUserFlag(5070) == 1) then			
			if ( REDPIN1:IsAlive() ) then
			else
				trigger.action.setUserFlag(5070,0)
				SEF_RedBomberAttack()
			end	
		end
	else
		trigger.action.outText("Enemy Bomber Missions Currently Disabled",60)
	end
end

function SEF_RedBomberScheduler(timeloop, time)
	if (trigger.misc.getUserFlag(5006) == 1) then
		SEF_RedBomberAttack()		
		return time + math.random(1800, 2700)
	end
end

function SEF_REDBomberTargetAcquisition()	
	TargetGroupREDPIN = ZONE:FindByName(REDBomberTarget) 
	TargetCoordForREDStrike = TargetGroupREDPIN:GetCoordinate():GetVec2()			
	local target = {}
		target.point = TargetCoordForREDStrike
		target.expend = "Four"
		target.weaponType = 2956984318
		target.attackQty = 1
		target.groupAttack = true
	local engage = {id = 'AttackMapObject', params = target}
	Group.getByName(RTREDPINGROUPNAME):getController():pushTask(engage)
end

function SEF_BLUEAwacsSpawn()			
	BLUEAWACS = SPAWN
		:New( "RT AWACS BLUE" )
		:InitLimit( 1, 1 )
		:InitRandomizeTemplate( { "SQ BLUE E-3A" } )		
		:OnSpawnGroup(
			function( SpawnGroup )								
				RTBLUEAWACSGROUPNAME = SpawnGroup.GroupName
				RTBLUEAWACSGROUPID = Group.getByName(RTBLUEAWACSGROUPNAME):getID()												
			end
		)		
		:Spawn()		
end

function SEF_BLUETexacoSpawn()			
	BLUETEXACO = SPAWN
		:New( "RT TEXACO" )
		:InitLimit( 1, 1 )
		:InitRandomizeTemplate( { "SQ BLUE KC-135MPRS" } )		
		:OnSpawnGroup(
			function( SpawnGroup )								
				RTBLUETEXACOGROUPNAME = SpawnGroup.GroupName
				RTBLUETEXACOGROUPID = Group.getByName(RTBLUETEXACOGROUPNAME):getID()												
			end
		)		
		:Spawn()		
end

function SEF_BLUEShellSpawn()			
	BLUESHELL = SPAWN
		:New( "RT SHELL" )
		:InitLimit( 1, 1 )
		:InitRandomizeTemplate( { "SQ BLUE KC-135" } )		
		:OnSpawnGroup(
			function( SpawnGroup )								
				RTBLUESHELLGROUPNAME = SpawnGroup.GroupName
				RTBLUESHELLGROUPID = Group.getByName(RTBLUESHELLGROUPNAME):getID()												
			end
		)		
		:Spawn()
end

function SEF_BLUEArcoSpawn()			
	BLUEARCO = SPAWN
		:New( "RT ARCO" )
		:InitLimit( 1, 1 )
		:InitRandomizeTemplate( { "SQ BLUE S-3B" } )		
		:OnSpawnGroup(
			function( SpawnGroup )								
				RTBLUEARCOGROUPNAME = SpawnGroup.GroupName
				RTBLUESARCOGROUPID = Group.getByName(RTBLUEARCOGROUPNAME):getID()												
			end
		)		
		:Spawn()
end

function SEF_BLUEAWACSRTBMessage()
	trigger.action.outText("AWACS Is Returning To Base",60)
end

function SEF_BLUETexacoRTBMessage()
	trigger.action.outText("Tanker Texaco Is Returning To Base",60)
end

function SEF_BLUEShellRTBMessage()
	trigger.action.outText("Tanker Shell Is Returning To Base",60)
end

function SEF_BLUEArcoRTBMessage()
	trigger.action.outText("Tanker Arco Is Returning To Base",60)
end

function SEF_TargetSmokeLock(TaskNumber)
	TargetSmokeLockout[TaskNumber] = 1
end

function SEF_TargetSmokeUnlock(TaskNumber)
	TargetSmokeLockout[TaskNumber] = 0
end

function SEF_TargetSmoke(TaskNumber)	
	local Number	= A2G_Task[TaskNumber]:GetMission().Number
	local isStatic	= A2G_Task[TaskNumber]:GetMission().Static
	local Target	= A2G_Task[TaskNumber]:GetMission().Target
	local Briefing	= A2G_Task[TaskNumber]:GetMission().Briefing

	if TaskNumber == 1 then
		objectiveID = "Alpha"
	elseif TaskNumber == 2 then
		objectiveID = "Bravo"
	else
		objectiveID = "Charlie"
	end

	if ( TargetSmokeLockout[TaskNumber] == 0 ) then
		if ( isStatic == false and Target ~= nil ) then
			if ( GROUP:FindByName(Target):IsAlive() == true ) then
				SEFTargetSmokeGroupCoord = GROUP:FindByName(Target):GetCoordinate()
				SEFTargetSmokeGroupCoord:FlareRed()
				trigger.action.outText("Objective "..objectiveID.." Has Been Marked With Red Flare", 15)
				SEF_TargetSmokeLock(TaskNumber)
				timer.scheduleFunction(SEF_TargetSmokeUnlock, TaskNumber, timer.getTime() + 300)				
			else			
				trigger.action.outText("Target Flares Currently Unavailable - Unable To Acquire Target Group", 15)						
			end		
		elseif ( isStatic == true and Target ~= nil ) then
			if ( StaticObject.getByName(Target) ~= nil and StaticObject.getByName(Target):isExist() == true ) then
				SEFTargetSmokeStaticCoord = STATIC:FindByName(Target):GetCoordinate()
				SEFTargetSmokeStaticCoord:FlareRed()
				trigger.action.outText("Objective "..objectiveID.." Has Been Marked With Red Flare", 15)
				SEF_TargetSmokeLock(TaskNumber)
				timer.scheduleFunction(SEF_TargetSmokeUnlock, TaskNumber, timer.getTime() + 300)				
			else
				trigger.action.outText("Target Flare Currently Unavailable - Unable To Acquire Target Building", 15)	
			end			
		else		
			trigger.action.outText("Target Flare Currently Unavailable - No Valid Targets", 15)
		end
	else
		trigger.action.outText("Target Flare Currently Unavailable - Flares Are Being Reloaded", 15)
	end	
end

function SEF_CheckDefenceNetwork()
	trigger.action.outText("Allied Defence Network Consists Of "..BLUEDetectionSetGroup:Count().." Groups\nRussian Defence Network Consists Of "..REDDetectionSetGroup:Count().." Groups", 15)
end

function SEF_CheckAirfieldStatus()
	trigger.action.outText("Airfield Status Report".."\n\n"..GudautaStatus.."\n"..SochiStatus.."\n"..NalchikStatus.."\n"..BeslanStatus.."\n"..KuznetsovStatus, 10)
end

--////GLOBAL VARIABLE INITIALISATION	
NumberOfCompletedMissions = 0
TotalScenarios = 125
OperationComplete = false
OnShotSoundsEnabled = 1
SoundLockout = 0
TargetSmokeLockout = {}
		
--////ENABLE CAP/CAS/ASS/SEAD/PIN/DRONE
trigger.action.setUserFlag(5001,1)
trigger.action.setUserFlag(5002,1)
trigger.action.setUserFlag(5003,1)
trigger.action.setUserFlag(5004,1)
trigger.action.setUserFlag(5005,1)
trigger.action.setUserFlag(5891,1)
--////ENABLE RED BOMBER ATTACKS
trigger.action.setUserFlag(5006,1)

--////FUNCTIONS
SEF_InitializeMissionTable()		
SEF_TargetSmokeUnlock(1)
SEF_TargetSmokeUnlock(2)
SEF_TargetSmokeUnlock(3)
SEF_MissionSelector(1)
SEF_MissionSelector(2)
SEF_MissionSelector(3)
addRadioCommands()
SEF_BLUEAwacsSpawn()
SEF_BLUETexacoSpawn()
SEF_BLUEShellSpawn()

--////SCHEDULERS
--AI FLIGHT PUSH FLAGS		
timer.scheduleFunction(SEF_CheckAIPushFlags, 53, timer.getTime() + 1)
--MISSION TARGET STATUS
timer.scheduleFunction(SEF_MissionTargetStatus, 1, timer.getTime() + 10)
timer.scheduleFunction(SEF_MissionTargetStatus, 2, timer.getTime() + 10)
timer.scheduleFunction(SEF_MissionTargetStatus, 3, timer.getTime() + 10)

--RED BOMBER ATTACKS - WAIT 10-15 MINUTES BEFORE STARTING
timer.scheduleFunction(SEF_RedBomberScheduler, 53, timer.getTime() + math.random(600, 900))