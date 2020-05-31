--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Name: Operation Clear Field - Russo-Georgian War 2008
-- Author: Surrexen    ༼ つ ◕_◕ ༽つ    (づ｡◕‿◕｡)づ 
-- Modified by Adonnay:
--   Allow for 3 simultaneous missions
--   Removed radio calls for smoke and most reinforcements
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MISSION LOGIC FUNCTIONS

function SEF_MissionSelector(TaskNumber)	
	if (NumberOfCompletedMissions >= TotalScenarios) then			
		OperationComplete = true
		trigger.action.outText("Operation Clear Field Has Been Successful", 15)
		ClearFieldUnitInterment = {}
		SEF_SaveUnitIntermentTableNoArgs()
		ClearFieldStaticInterment = {}
		SEF_SaveStaticIntermentTableNoArgs()			
	else
		Randomiser = math.random(1,TotalScenarios)
		if (trigger.misc.getUserFlag(Randomiser) > 0) then
			SEF_MissionSelector(TaskNumber)
		elseif (trigger.misc.getUserFlag(Randomiser) == 0) then
			trigger.action.setUserFlag(Randomiser,1)
			SEF_RetrieveMissionInformation(Randomiser, TaskNumber)
			SEF_ValidateMission(TaskNumber)										
		else
			trigger.action.outText("Mission Selection Error", 15)
		end
	end		
end

function SEF_RetrieveMissionInformation (MissionNumber, TaskNumber)
	if (TaskNumber == 1) then
		ScenarioNumber = MissionNumber
		AGMissionTarget = OperationClearField_AG[MissionNumber].TargetName
		AGTargetTypeStatic = OperationClearField_AG[MissionNumber].TargetStatic
		AGMissionBriefingText = OperationClearField_AG[MissionNumber].TargetBriefing
    elseif (TaskNumber == 2) then
		Scenario2Number = MissionNumber
		AGMission2Target = OperationClearField_AG[MissionNumber].TargetName
		AGTarget2TypeStatic = OperationClearField_AG[MissionNumber].TargetStatic
		AGMission2BriefingText = OperationClearField_AG[MissionNumber].TargetBriefing
    elseif (TaskNumber == 3) then
		Scenario3Number = MissionNumber
		AGMission3Target = OperationClearField_AG[MissionNumber].TargetName
		AGTarget3TypeStatic = OperationClearField_AG[MissionNumber].TargetStatic
		AGMission3BriefingText = OperationClearField_AG[MissionNumber].TargetBriefing
	end
end

function SEF_ValidateMission(TaskNumber)	
	if (TaskNumber == 1) then
		if (AGTargetTypeStatic == false and AGMissionTarget ~= nil) then
			if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMissionBriefingText, 15)			
			elseif (GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil) then
				trigger.action.setUserFlag(ScenarioNumber, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1
				AGMissionTarget = nil
				AGMissionBriefingText = nil
				SEF_MissionSelector(TaskNumber)						
			else			
				trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)
			end		
		elseif (AGTargetTypeStatic == true and AGMissionTarget ~= nil) then
			if (StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMissionBriefingText, 15)								
			elseif ( StaticObject.getByName(AGMissionTarget) == nil or StaticObject.getByName(AGMissionTarget):isExist() == false ) then
				trigger.action.setUserFlag(ScenarioNumber, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
				AGMissionTarget = nil
				AGMissionBriefingText = nil
				SEF_MissionSelector(TaskNumber)
			else
				trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
			end		
		elseif (OperationComplete == true) then
			trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
		else		
			trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
		end
	
	elseif (TaskNumber == 2) then
		if (AGTarget2TypeStatic == false and AGMission2Target ~= nil ) then
			if (GROUP:FindByName(AGMission2Target):IsAlive() == true ) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMission2BriefingText, 15)			
			elseif (GROUP:FindByName(AGMission2Target):IsAlive() == false or GROUP:FindByName(AGMission2Target):IsAlive() == nil) then
				trigger.action.setUserFlag(Scenario2Number, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1
				AGMission2Target = nil
				AGMission2BriefingText = nil
				SEF_MissionSelector(TaskNumber)						
			else			
				trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)						
			end		
		elseif (AGTarget2TypeStatic == true and AGMission2Target ~= nil) then
			if (StaticObject.getByName(AGMission2Target) ~= nil and StaticObject.getByName(AGMission2Target):isExist() == true) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMission2BriefingText, 15)								
			elseif (StaticObject.getByName(AGMission2Target) == nil or StaticObject.getByName(AGMission2Target):isExist() == false) then
				trigger.action.setUserFlag(Scenario2Number, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
				AGMission2Target = nil
				AGMission2BriefingText = nil
				SEF_MissionSelector(TaskNumber)
			else
				trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
			end		
		elseif (OperationComplete == true) then
			trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
		else		
			trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
		end
	elseif (TaskNumber == 3) then
		if (AGTarget3TypeStatic == false and AGMission3Target ~= nil) then
			if (GROUP:FindByName(AGMission3Target):IsAlive() == true) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMission3BriefingText, 15)			
			elseif (GROUP:FindByName(AGMission3Target):IsAlive() == false or GROUP:FindByName(AGMission3Target):IsAlive() == nil) then
				--GROUP NOT VALID
				trigger.action.setUserFlag(Scenario3Number, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1
				AGMission3Target = nil
				AGMission3BriefingText = nil
				SEF_MissionSelector(TaskNumber)						
			else			
				trigger.action.outText("Mission Validation Error - Unexpected Result In Group Size", 15)						
			end		
		elseif (AGTarget3TypeStatic == true and AGMission3Target ~= nil) then
			if (StaticObject.getByName(AGMission3Target) ~= nil and StaticObject.getByName(AGMission3Target):isExist() == true) then
				trigger.action.outSound('That Is Our Target.ogg')
				trigger.action.outText(AGMission3BriefingText, 15)								
			elseif (StaticObject.getByName(AGMission3Target) == nil or StaticObject.getByName(AGMission3Target):isExist() == false) then
				trigger.action.setUserFlag(Scenario3Number, 4)
				NumberOfCompletedMissions = NumberOfCompletedMissions + 1	
				AGMission3Target = nil
				AGMission3BriefingText = nil
				SEF_MissionSelector(TaskNumber)
			else
				trigger.action.outText("Mission Validation Error - Unexpected Result In Static Test", 15)	
			end		
		elseif (OperationComplete == true) then
			trigger.action.outText("The Operation Is Complete - No Further Targets To Validate For Mission Assignment", 15)
		else		
			trigger.action.outText("Mission Validation Error - Mission Validation Unavailable, No Valid Targets", 15)
		end
	end
end

function SEF_SkipMission1()
	if ( trigger.misc.getUserFlag(ScenarioNumber) >= 1 and trigger.misc.getUserFlag(ScenarioNumber) <= 3 ) then
		trigger.action.setUserFlag(ScenarioNumber, 0) 
		AGMissionTarget = nil
		AGMissionBriefingText = nil
		SEF_MissionSelector(1)
	elseif (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end

function SEF_SkipMission2()
	if (trigger.misc.getUserFlag(Scenario2Number) >= 1 and trigger.misc.getUserFlag(Scenario2Number) <= 3) then
		trigger.action.setUserFlag(Scenario2Number, 0) 
		AGMission2Target = nil
		AGMission2BriefingText = nil
		SEF_MissionSelector(2)
	elseif (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end

function SEF_SkipMission3()	
	if (trigger.misc.getUserFlag(Scenario3Number) >= 1 and trigger.misc.getUserFlag(Scenario3Number) <= 3) then
		trigger.action.setUserFlag(Scenario3Number, 0) 
		AGMission3Target = nil
		AGMission3BriefingText = nil
		SEF_MissionSelector(3)
	elseif (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, All Objectives Have Been Met", 15)
	else		
		trigger.action.outText("Unable To Skip As Current Mission Is In A Completion State", 15)
	end
end


function MissionSuccess(TaskNumber)	
	if (TaskNumber == 1) then
		AGMissionTarget = nil
		AGMissionBriefingText = nil
	elseif (TaskNumber == 2) then
		AGMission2Target = nil
		AGMission2BriefingText = nil
	elseif (TaskNumber == 3) then
		AGMission3Target = nil
		AGMission3BriefingText = nil
	end
	
	local RandomMissionSuccessSound = math.random(1, 5)
end

function SEF_Mission1TargetStatus(TimeLoop, time)
	if (AGTargetTypeStatic == false and AGMissionTarget ~= nil) then					
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
			return time + 10
		elseif (GROUP:FindByName(AGMissionTarget):IsAlive() == false or GROUP:FindByName(AGMissionTarget):IsAlive() == nil) then
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber, 4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(1)
			timer.scheduleFunction(SEF_MissionSelector, 1, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~= nil) then
		if (StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true) then
			return time + 10				
		else
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(ScenarioNumber, 4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(1)
			timer.scheduleFunction(SEF_MissionSelector, 1, timer.getTime() + 20)
			
			return time + 30				
		end		
	else		
		return time + 10
	end	
end


function SEF_Mission2TargetStatus(TimeLoop, time)	
	if (AGTarget2TypeStatic == false and AGMission2Target ~= nil) then
		if (GROUP:FindByName(AGMission2Target):IsAlive() == true) then
			return time + 10
		elseif (GROUP:FindByName(AGMission2Target):IsAlive() == false or GROUP:FindByName(AGMission2Target):IsAlive() == nil) then
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Scenario2Number, 4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(2)
			timer.scheduleFunction(SEF_MissionSelector, 2, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (AGTarget2TypeStatic == true and AGMission2Target ~= nil) then
		if (StaticObject.getByName(AGMission2Target) ~= nil and StaticObject.getByName(AGMission2Target):isExist() == true) then
			return time + 10				
		else
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Scenario2Number, 4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(2)
			timer.scheduleFunction(SEF_MissionSelector, 2, timer.getTime() + 20)
			
			return time + 30				
		end		
	else
		return time + 10
	end	
end


function SEF_Mission3TargetStatus(TimeLoop, time)
	if (AGTarget3TypeStatic == false and AGMission3Target ~= nil) then
		if (GROUP:FindByName(AGMission3Target):IsAlive() == true) then
			return time + 10
		elseif (GROUP:FindByName(AGMission3Target):IsAlive() == false or GROUP:FindByName(AGMission3Target):IsAlive() == nil) then 
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Scenario3Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(3)
			timer.scheduleFunction(SEF_MissionSelector, 3, timer.getTime() + 20)
			
			return time + 30			
		else			
			trigger.action.outText("Mission Target Status - Unexpected Result, Monitor Has Stopped", 15)						
		end		
	elseif (AGTarget3TypeStatic == true and AGMission2Target ~= nil) then
		if (StaticObject.getByName(AGMission3Target) ~= nil and StaticObject.getByName(AGMission3Target):isExist() == true) then
			return time + 10				
		else
			trigger.action.outText("Mission Update - Mission Successful", 15)
			trigger.action.setUserFlag(Scenario3Number,4)
			NumberOfCompletedMissions = NumberOfCompletedMissions + 1
			MissionSuccess(3)
			timer.scheduleFunction(SEF_MissionSelector, 3, timer.getTime() + 20)
			
			return time + 30				
		end		
	else		
		return time + 10
	end	
end

--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MISSION TARGET TABLE

function SEF_InitializeMissionTable()	
	OperationClearField_AG = {}
	
	OperationClearField_AG[1] = {
		TargetName = "Kvemo Roka - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21",
	}			
	OperationClearField_AG[2] = {	
		TargetName = "Kvemo Roka - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21",				
	}			
	OperationClearField_AG[3] = {
		TargetName = "Kvemo Roka - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy APC's and IFV's located at Zemo-Roka\nKvemo-Roka Sector - Grid MN21",
	}					
	OperationClearField_AG[4] = {
		TargetName = "Kvemo Roka - Armor 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy APC's and IFV's located at Elbakita\nKvemo-Roka Sector - Grid MM19",
	}					
	OperationClearField_AG[5] = {
		TargetName = "Kvemo Roka - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the SA-19 SAM located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21",
	}			
	OperationClearField_AG[6] = {
		TargetName = "Kvemo Roka - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located at Kvemo-Roka\nKvemo-Roka Sector - Grid MN21",
	}			
	OperationClearField_AG[7] = {
		TargetName = "Kvemo Roka - Convoy 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Convoy located at Kvemo-Sba\nKvemo-Roka Sector - Grid MN31",
	}					
	--GORI
	OperationClearField_AG[8] = {
		TargetName = "Gori - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located South of Dzevera\nGori Sector - Grid MM26",
	}					
	OperationClearField_AG[9] = {
		TargetName = "Gori - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Gori\nGori Sector - Grid MM24",
	}					
	OperationClearField_AG[10] = {
		TargetName = "Gori - AAA 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Ruisi\nGori Sector - Grid MM15",
	}					
	OperationClearField_AG[11] = {
		TargetName = "Gori - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located South of Dzevera\nGori Sector - Grid MM26",		
	}			
	OperationClearField_AG[12] = {
		TargetName = "Gori - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-80 Tanks located at Gori\nGori Sector - Grid MM24",
	}			
	OperationClearField_AG[13] = {
		TargetName = "Gori - Armor 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located at Ruisi\nGori Sector - Grid MM15",
	}			
	OperationClearField_AG[14] = {
		TargetName = "Gori - Artillery 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located South of Dzevera\nGori Sector - Grid MM26",
	}			
	OperationClearField_AG[15] = {
		TargetName = "Gori - Artillery 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located at Gori\nGori Sector - Grid MM24",
	}
	OperationClearField_AG[16] = {
		TargetName = "Gori - Artillery 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located at Ruisi\nGori Sector - Grid MM15",
	}
	OperationClearField_AG[17] = {
		TargetName = "Gori - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SA-19 SAM located South of Dzevera\nGori Sector - Grid MM26",	
	}
	OperationClearField_AG[18] = {
		TargetName = "Gori - SAM 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SA-15 SAM located at Gori\nGori Sector - Grid MM24",
	}
	OperationClearField_AG[19] = {
		TargetName = "Gori - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located South of Dzevera\nGori Sector - Grid MM26",
	}
	OperationClearField_AG[20] = {
		TargetName = "Gori - Supply 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located at Gori\nGori Sector - Grid MM24",
	}	
	OperationClearField_AG[21] = {
		TargetName = "Gori - Command 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile Command Post located at Ruisi\nGori Sector - Grid MM15",
	}
	--GUDAUTA
	OperationClearField_AG[22] = {
		TargetName = "Gudauta - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets North of Gudauta Airbase\nGudauta Sector - Grid FH27",
	}
	OperationClearField_AG[23] = {
		TargetName = "Gudauta - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets at Gudauta\nGudauta Sector - Grid FH37",
	}
	OperationClearField_AG[24] = {
		TargetName = "Gudauta - Bomber 1",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Mi-24V Attack Helicopter being refuelled North of Gudauta Airbase\nGudauta Sector - Grid FH27",
	}
	OperationClearField_AG[25] = {
		TargetName = "Gudauta - Navy 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Naval Vessels South of Pitsunda\nGudauta Sector - Grid FH16",
	}
	OperationClearField_AG[26] = {
		TargetName = "Gudauta - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SA-15 SAM North of Gudauta Airbase\nGudauta Sector - Grid FH27",
	}
	OperationClearField_AG[27] = {
		TargetName = "Gudauta - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks at Adzhapsha\nGudauta Sector - Grid FH47",
	}
	OperationClearField_AG[28] = {
		TargetName = "Gudauta - Supply 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks North of Gudauta Airbase\nGudauta Sector - Grid FH27",
	}
	OperationClearField_AG[29] = {
		TargetName = "Gudauta - Comms",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Communications Tower located West of Achkatsa\nGudauta Sector - Grid FH37",
	}
	OperationClearField_AG[30] = {
		TargetName = "Gudauta - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military HQ at Gudauta\nGudauta Sector - Grid FH37",
	}
	--////Major SAM Site
	OperationClearField_AG[31] = {
		TargetName = "Gudauta - SA-10",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the SA-10 site at Adzhapsha\nGudauta Sector - Grid FH47",
	}
	--OCHAMCHIRA
	OperationClearField_AG[32] = {
		TargetName = "Ochamchira - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Ochamchira\nOchamchira Sector - Grid GH03",
	}
	OperationClearField_AG[33] = {
		TargetName = "Ochamchira - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Repo-Etseri\nOchamchira Sector - Grid GH12",
	}
	OperationClearField_AG[34] = {
		TargetName = "Ochamchira - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the IFV's located East of Ochamchira\nOchamchira Sector - Grid GH03",
	}
	OperationClearField_AG[35] = {
		TargetName = "Ochamchira - Cargo Ships 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Cargo Ships East of Ochamchira\nOchamchira Sector - Grid FH92",
	}
	OperationClearField_AG[36] = {
		TargetName = "Ochamchira - Navy 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Naval Vessels South of Ahali-Kindgi\nOchamchira Sector - Grid FH82",
	}
	OperationClearField_AG[37] = {
		TargetName = "Ochamchira - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located at Ochamchira\nOchamchira Sector - Grid GH03",
	}
	OperationClearField_AG[38] = {
		TargetName = "Ochamchira - Train Station",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Train Station located at Ochamchira\nOchamchira Sector - Grid GH03",
	}
	OperationClearField_AG[39] = {
		TargetName = "Ochamchira - Comms",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Communications Tower located at Ochamchira\nOchamchira Sector - Grid GH03",
	}
	OperationClearField_AG[40] = {
		TargetName = "Ochamchira - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military HQ at Ochamchira\nOchamchira Sector - Grid GH03",
	}	
	--////SOCHI
	OperationClearField_AG[41] = {
		TargetName = "Sochi - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets at the Sochi docks\nSochi Sector - Grid EJ52",
	}
	OperationClearField_AG[42] = {
		TargetName = "Sochi - Cargo Ships 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Cargo Ships docked at Sochi docks\nSochi Sector - Grid EJ52",
	}
	OperationClearField_AG[43] = {
		TargetName = "Sochi - Cargo Ships 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Cargo Ships South-West of Adler\nSochi Sector - Grid EJ60",
	}
	OperationClearField_AG[44] = {
		TargetName = "Sochi - Navy 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Naval Vessels South-West of Sochi docks\nSochi Sector - Grid EJ52",
	}
	OperationClearField_AG[45] = {
		TargetName = "Sochi - Navy 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Submarines docked at Sochi docks\nSochi Sector - Grid EJ52",
	}	
	OperationClearField_AG[46] = {
		TargetName = "Sochi - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks at the SA-11 site West of Dagomys\nSochi Sector - Grid EJ53",
	}
	OperationClearField_AG[47] = {
		TargetName = "Sochi - Comms",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Communications Tower North-West of Razdol'noe\nSochi Sector - Grid EJ62",	
	}
	--////Major SAM Site
	OperationClearField_AG[48] = {
		TargetName = "Sochi - SA-11",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the SA-11 site West of Dagomys\nSochi Sector - Grid EJ53",
	}
	--SUKHUMI
	OperationClearField_AG[49] = {
		TargetName = "Sukhumi - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[50] = {
		TargetName = "Sukhumi - Cargo Ships 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Cargo Ships South-West of Sukhumi\nSukhumi Sector - Grid FH55",
	}
	OperationClearField_AG[51] = {
		TargetName = "Sukhumi - Cargo Ships 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Cargo Ships at Kvemo-Merheuli Docks\nSukhumi Sector - Grid FH65",
	}	
	OperationClearField_AG[52] = {
		TargetName = "Sukhumi - Navy 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Naval Vessels West of Varcha\nSukhumi Sector - Grid FH54",
	}
	OperationClearField_AG[53] = {
		TargetName = "Sukhumi - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located at Gumista\nSukhumi Sector - Grid FH56",
	}
	OperationClearField_AG[54] = {
		TargetName = "Sukhumi - SAM 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[55] = {
		TargetName = "Sukhumi - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks at the SA-10 site at Gul'ripsh\nSukhumi Sector - Grid FH75",
	}	
	OperationClearField_AG[56] = {
		TargetName = "Sukhumi - Supply 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located at Sukhumi\nSukhumi Sector - Grid FH66",
	}	
	OperationClearField_AG[57] = {
		TargetName = "Sukhumi - Train Station",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Train Station located at Gumista\nSukhumi Sector - Grid FH56",	
	}	
	OperationClearField_AG[58] = {
		TargetName = "Sukhumi - Comms",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Communications Tower North of Tavisupleba\nSukhumi Sector - Grid FH66",	
	}	
	--////Major SAM Site
	OperationClearField_AG[59] = {
		TargetName = "Sukhumi - SA-10",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the SA-10 site at Gul'ripsh\nSukhumi Sector - Grid FH75",	
	}	
	--TKVARCHELI
	OperationClearField_AG[60] = {
		TargetName = "Tkvarcheli - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Tkvarcheli\nTkvarcheli Sector - Grid GH14",
	}
	OperationClearField_AG[61] = {
		TargetName = "Tkvarcheli - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Agvavera\nTkvarcheli Sector - Grid GH23",
	}	
	OperationClearField_AG[62] = {
		TargetName = "Tkvarcheli - AAA 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at the Enguri Dam\nTkvarcheli Sector - Grid KN53",
	}	
	OperationClearField_AG[63] = {
		TargetName = "Tkvarcheli - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy APC's and IFV's located at Tkvarcheli\nTkvarcheli Sector - Grid GH14",
	}
	OperationClearField_AG[64] = {
		TargetName = "Tkvarcheli - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Armored Vehicles located at the Enguri Dam\nTkvarcheli Sector - Grid KN53",
	}
	OperationClearField_AG[65] = {
		TargetName = "Tkvarcheli - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military HQ at Agvavera\nTkvarcheli Sector - Grid GH23",
	}
	OperationClearField_AG[66] = {
		TargetName = "Tkvarcheli - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM at Agvavera\nTkvarcheli Sector - Grid GH23",
	}
	OperationClearField_AG[67] = {
		TargetName = "Tkvarcheli - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located at Agvavera\nTkvarcheli Sector - Grid GH23",
	}	
	OperationClearField_AG[68] = {
		TargetName = "Tkvarcheli - Comms",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Communications Tower on the mountain top North of the three rivers\nTkvarcheli Sector - Grid GH34",	
	}
	--TSKHINVALI
	OperationClearField_AG[69] = {
		TargetName = "Tskhinvali - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Kurta\nTskhinvali Sector - Grid MM18",
	}
	OperationClearField_AG[70] = {
		TargetName = "Tskhinvali - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets South of Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[71] = {
		TargetName = "Tskhinvali - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the APC's located at Kurta\nTskhinvali Sector - Grid MM18",
	}
	OperationClearField_AG[72] = {
		TargetName = "Tskhinvali - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the APC's South of Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[73] = {
		TargetName = "Tskhinvali - Armor 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the APC's located at Ergneti\nTskhinvali Sector - Grid MM17",
	}	
	OperationClearField_AG[74] = {
		TargetName = "Tskhinvali - Command 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile Command Vehicle located South of Tskhinvali\nTskhinvali Sector - Grid MM17",
	}	
	OperationClearField_AG[75] = {
		TargetName = "Tskhinvali - Infantry 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Infantry at the Road Outpost at Ergneti\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[76] = {
		TargetName = "Tskhinvali - Military Barracks",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military Barracks at Kurta\nTskhinvali Sector - Grid MM18",
	}
	OperationClearField_AG[77] = {
		TargetName = "Tskhinvali - Outpost",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Road Outpost at Ergneti\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[78] = {
		TargetName = "Tskhinvali - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located South of Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[79] = {
		TargetName = "Tskhinvali - SAM 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located at Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[80] = {
		TargetName = "Tskhinvali - Barracks",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military Barracks located at Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[81] = {
		TargetName = "Tskhinvali - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military HQ located at Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	OperationClearField_AG[82] = {
		TargetName = "Tskhinvali - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located at Tskhinvali\nTskhinvali Sector - Grid MM17",
	}
	--Zemo-Azhara
	OperationClearField_AG[83] = {
		TargetName = "Zemo Azhara - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27",
	}
	OperationClearField_AG[84] = {
		TargetName = "Zemo Azhara - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37",
	}
	OperationClearField_AG[85] = {
		TargetName = "Zemo Azhara - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27",
	}
	OperationClearField_AG[86] = {
		TargetName = "Zemo Azhara - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy APC's and IFV's located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37",
	}
	OperationClearField_AG[87] = {
		TargetName = "Zemo Azhara - Armor 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37",
	}
	OperationClearField_AG[88] = {
		TargetName = "Zemo Azhara - Artillery 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27",
	}
	OperationClearField_AG[89] = {
		TargetName = "Zemo Azhara - Artillery 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37",
	}
	OperationClearField_AG[90] = {
		TargetName = "Zemo Azhara - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27",
	}
	OperationClearField_AG[91] = {
		TargetName = "Zemo Azhara - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH27",
	}	
	--ZUGDIDI
	OperationClearField_AG[92] = {
		TargetName = "Zugdidi - AAA 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located at Zeni\nZugdidi Sector - Grid GH20-GH21",	
	}
	OperationClearField_AG[93] = {
		TargetName = "Zugdidi - AAA 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy AAA assets located East of Chuburhindzhi\nZugdidi Sector - Grid GH31",
	}
	OperationClearField_AG[94] = {
		TargetName = "Zugdidi - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-80 Tanks located at Zeni\nZugdidi Sector - Grid GH20-GH21",
	}
	OperationClearField_AG[95] = {
		TargetName = "Zugdidi - Armor 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-90 Tanks located East of Chuburhindzhi\nZugdidi Sector - Grid GH31",
	}
	OperationClearField_AG[96] = {
		TargetName = "Zugdidi - Armor 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the IFV's located North of Pahulani\nZugdidi Sector - Grid GH42",
	}	
	OperationClearField_AG[97] = {
		TargetName = "Zugdidi - Artillery 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located at Zeni\nZugdidi Sector - Grid GH20-GH21",
	}
	OperationClearField_AG[98] = {
		TargetName = "Zugdidi - Artillery 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Artillery located East of Chuburhindzhi\nZugdidi Sector - Grid GH31",
	}
	OperationClearField_AG[99] = {
		TargetName = "Zugdidi - SAM 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located East of Chuburhindzhi\nZugdidi Sector - Grid GH31",
	}
	OperationClearField_AG[100] = {
		TargetName = "Zugdidi - SAM 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Mobile SAM located North of Pahulani\nZugdidi Sector - Grid GH42",
	}
	--////Expanded List 1
	OperationClearField_AG[101] = {
		TargetName = "Sochi - EWR Veseloe",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Early Warning Radar located at Veseloe\nSochi Sector - Grid EJ80",
	}
	OperationClearField_AG[102] = {
		TargetName = "Gudauta - EWR Gudauta 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Early Warning Radar located at Algyt\nGudauta Sector - Grid FH27",
	}
	OperationClearField_AG[103] = {
		TargetName = "Gudauta - EWR Gudauta 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Early Warning Radar located at Adzhapsha\nGudauta Sector - Grid FH47",
	}
	OperationClearField_AG[104] = {
		TargetName = "Sukhumi - EWR Kvemo-Merheuli",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Early Warning Radar at Kvemo-Merheuli\nSukhumi Sector - Grid FH65",
	}
	OperationClearField_AG[105] = {
		TargetName = "Sukhumi - EWR Sukhumi",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Early Warning Radar at the Sukhumi Airbase\nSukhumi Sector - Grid FH74",
	}
	--////Expanded List 2
	OperationClearField_AG[106] = {
		TargetName = "Ochamchira - Naval Repair",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Repair Yard at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93",
	}
	OperationClearField_AG[107] = {
		TargetName = "Ochamchira - AAA 3",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the AAA Assets at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93",
	}
	OperationClearField_AG[108] = {
		TargetName = "Sukhumi - Military Warehouse",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Warehouse located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[109] = {
		TargetName = "Sukhumi - Military HQ",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military HQ located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[110] = {
		TargetName = "Gudauta - Lidzava Military Barracks",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military Barracks located at Lidzava\nGudauta Sector - Grid FH18",
	}
	OperationClearField_AG[111] = {
		TargetName = "Gudauta - Achandara Military Barracks",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Achandara Military Barracks located South of Aosyrhva\nGudauta Sector - Grid FH38",
	}
	OperationClearField_AG[112] = {
		TargetName = "Gudauta - Infantry 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Infantry at the Achandara Military Barracks located South of Aosyrhva\nGudauta Sector - Grid FH38",
	}
	OperationClearField_AG[113] = {
		TargetName = "Sukhumi - Boat Bunker",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Boat Bunker located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[114] = {
		TargetName = "Sukhumi - Navy 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Armed Speedboats located at Sukhumi\nSukhumi Sector - Grid FH66",
	}
	OperationClearField_AG[115] = {
		TargetName = "Ochamchira - Navy 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Armed Speedboats at the Ochamchira Naval Base located West of Dzhukmur\nOchamchira Sector - Grid FH93",
	}
	OperationClearField_AG[116] = {
		TargetName = "Gudauta - Armor 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the T-72 Tanks located at the Lidzava Military Barracks\nGudauta Sector - Grid FH18",
	}
	OperationClearField_AG[117] = {
		TargetName = "Kvemo Roka - Convoy 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Convoy located at Kvemo-Khoshka\nKvemo-Roka Sector - Grid MN20",
	}
	OperationClearField_AG[118] = {
		TargetName = "Tkvarcheli - Transport",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Mi-8MTV2 Helicopter located at Agvavera\nTkvarcheli Sector - Grid GH23",
	}
	OperationClearField_AG[119] = {
		TargetName = "Zemo Azhara - Supply 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks located East of Zemo-Azhara\nZemo-Azhara Sector - Grid GH37",
	}
	OperationClearField_AG[120] = {
		TargetName = "Zugdidi - Saberio Border Post",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Road Outpost located South of Saberio\nZugdidi Sector - Grid GH32",
	}
	OperationClearField_AG[121] = {
		TargetName = "Zugdidi - Infantry 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Infantry at the Road Outpost located South of Saberio\nZugdidi Sector - Grid GH32",
	}
	OperationClearField_AG[122] = {
		TargetName = "Zugdidi - Gali Military Barracks",
		TargetStatic = true,
		TargetBriefing = "Primary Objective - Destroy the Military Barracks located at Gali\nZugdidi Sector - Grid GH22",
	}
	OperationClearField_AG[123] = {
		TargetName = "Zugdidi - Infantry 2",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Infantry at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22",
	}
	OperationClearField_AG[124] = {
		TargetName = "Zugdidi - Supply 1",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the Supply Trucks at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22",
	}
	OperationClearField_AG[125] = {
		TargetName = "Zugdidi - Armor 4",
		TargetStatic = false,
		TargetBriefing = "Primary Objective - Destroy the IFV's at the Military Barracks located at Gali\nZugdidi Sector - Grid GH22",
	}
end

--////End Mission Target Table
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////ON DEMAND MISSION INFORMATION

local function CheckObjectiveRequest()
	
	if (AGMissionBriefingText ~= nil) then
		trigger.action.outText(AGMissionBriefingText, 15)
	end

	if (AGMission2BriefingText ~= nil) then
		trigger.action.outText(AGMission2BriefingText, 15)
	end

	if (AGMission3BriefingText ~= nil) then
		trigger.action.outText(AGMission3BriefingText, 15)
	end


	if (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Objectives", 15)
	end


	if ((AGMissionBriefingText == nil and AGMission2BriefingText == nil and AGMission3BriefingText == nil) and OperationComplete == false) then
		trigger.action.outText("Check Objective Request Error - No Briefing Available And Operation Is Not Completed", 15)
	end	
end

function Target1Report()			
	if (AGTargetTypeStatic == false and AGMissionTarget ~= nil) then
		TargetGroup = GROUP:FindByName(AGMissionTarget)
		if (GROUP:FindByName(AGMissionTarget):IsAlive() == true) then
			TargetRemainingUnits = Group.getByName(AGMissionTarget):getSize()
			MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
			MissionPlayersBlue:ForEachClient(
				function(Client)
					if Client:IsAlive() == true then
						ClientPlayerName = Client:GetPlayerName()	  
						ClientUnitName = Client:GetName()			  
						ClientGroupName = Client:GetClientGroupName() 			
						ClientGroupID = Client:GetClientGroupID()	   	
						ClientPlane = Client:GetDCSObject():getTypeName(self)
				
						PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
						PlayerCoord = PlayerUnit:GetCoordinate()
						TargetCoord = TargetGroup:GetCoordinate()
						TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
						TargetHeightFt = math.floor(TargetHeight * 3.28084)
						PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

						TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
						TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
					
						PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
						
						if (TargetRemainingUnits > 1) then
							SZMessage = "There are "..TargetRemainingUnits.." targets remaining for this mission" 
						elseif (TargetRemainingUnits == 1) then
							SZMessage = "There is "..TargetRemainingUnits.." target remaining for this mission" 
						elseif (TargetRemainingUnits == nil) then					
							SZMessage = "Unable To Determine Group Size"
						else			
							SZMessage = "Nothing to report"		
						end		
					
						BRMessage = ", bearing "..PlayerBR
						ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
						_SETTINGS:SetLL_Accuracy(0)
						CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(3)
						CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(2)
						CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())

					    if (ClientPlane == "F-16C_50") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
						elseif (ClientPlane == "FA-18C_hornet") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
						else
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
						end
					else						
					end				
				end
			)
		else
			trigger.action.outText("Target Report Unavailable", 15)
		end
		
	elseif (AGTargetTypeStatic == true and AGMissionTarget ~= nil) then
		TargetGroup = STATIC:FindByName(AGMissionTarget, false)		
		MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
		MissionPlayersBlue:ForEachClient(
			function(Client)
				if Client:IsAlive() == true then
					ClientPlayerName = Client:GetPlayerName()	
					ClientUnitName = Client:GetName()			
					ClientGroupName = Client:GetClientGroupName()				
					ClientGroupID = Client:GetClientGroupID()
					ClientPlane = Client:GetDCSObject():getTypeName(self)
				
					PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
					PlayerCoord = PlayerUnit:GetCoordinate()
					TargetCoord = TargetGroup:GetCoordinate()
					TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
					TargetHeightFt = math.floor(TargetHeight * 3.28084)
					PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
					
					TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
					TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
										
					PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())

					BRMessage = "Target bearing "..PlayerBR
					ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
					_SETTINGS:SetLL_Accuracy(0)
					CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(3)
					CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(2)
					CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
					
					if (ClientPlane == "F-16C_50") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
					elseif (ClientPlane == "FA-18C_hornet") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
					else
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
					end
				else
				end				
			end
		)		
	elseif ( OperationComplete == true ) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end


function Target2Report()
			
	if (AGTarget2TypeStatic == false and AGMission2Target ~= nil) then
		TargetGroup = GROUP:FindByName(AGMission2Target)	
		
		if (GROUP:FindByName(AGMission2Target):IsAlive() == true) then
		
			TargetRemainingUnits = Group.getByName(AGMission2Target):getSize()	
			
			MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
			
			MissionPlayersBlue:ForEachClient(
				function(Client)
					if Client:IsAlive() == true then
						ClientPlayerName = Client:GetPlayerName()	  
						ClientUnitName = Client:GetName()			  
						ClientGroupName = Client:GetClientGroupName() 			
						ClientGroupID = Client:GetClientGroupID()	   	
						ClientPlane = Client:GetDCSObject():getTypeName(self)
				
						PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
						PlayerCoord = PlayerUnit:GetCoordinate()
						TargetCoord = TargetGroup:GetCoordinate()
						TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
						TargetHeightFt = math.floor(TargetHeight * 3.28084)
						PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

						TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
						TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
					
						PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
						
						if (TargetRemainingUnits > 1) then
							SZMessage = "There are "..TargetRemainingUnits.." targets remaining for this mission" 
						elseif (TargetRemainingUnits == 1) then
							SZMessage = "There is "..TargetRemainingUnits.." target remaining for this mission" 
						elseif (TargetRemainingUnits == nil) then					
							SZMessage = "Unable To Determine Group Size"
						else			
							SZMessage = "Nothing to report"		
						end		
					
						BRMessage = ", bearing "..PlayerBR
						ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
						_SETTINGS:SetLL_Accuracy(0)
						CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(3)
						CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(2)
						CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())

					    if (ClientPlane == "F-16C_50") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission2BriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
						elseif (ClientPlane == "FA-18C_hornet") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission2BriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
						else
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission2BriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
						end
					else						
					end				
				end
			)
		else
			trigger.action.outText("Target Report Unavailable", 15)
		end
		
	elseif (AGTarget2TypeStatic == true and AGMission2Target ~= nil) then
		TargetGroup = STATIC:FindByName(AGMission2Target, false)		
		MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
		MissionPlayersBlue:ForEachClient(
			function(Client)
				if Client:IsAlive() == true then
					ClientPlayerName = Client:GetPlayerName()	
					ClientUnitName = Client:GetName()			
					ClientGroupName = Client:GetClientGroupName()				
					ClientGroupID = Client:GetClientGroupID()
					ClientPlane = Client:GetDCSObject():getTypeName(self)
				
					PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
					PlayerCoord = PlayerUnit:GetCoordinate()
					TargetCoord = TargetGroup:GetCoordinate()
					TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
					TargetHeightFt = math.floor(TargetHeight * 3.28084)
					PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
					
					TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
					TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
										
					PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())

					BRMessage = "Target bearing "..PlayerBR
					ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
					_SETTINGS:SetLL_Accuracy(0)
					CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(3)
					CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(2)
					CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
					
					if (ClientPlane == "F-16C_50") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
					elseif (ClientPlane == "FA-18C_hornet") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
					else
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
					end					
				else
				end				
			end
		)		
	elseif (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end


function Target3Report()			
	if (AGTarget3TypeStatic == false and AGMission3Target ~= nil) then
		TargetGroup = GROUP:FindByName(AGMission3Target)		
		if (GROUP:FindByName(AGMission3Target):IsAlive() == true) then		
			TargetRemainingUnits = Group.getByName(AGMission3Target):getSize()			
			MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()			
			MissionPlayersBlue:ForEachClient(
				function(Client)
					if Client:IsAlive() == true then
						ClientPlayerName = Client:GetPlayerName()	  
						ClientUnitName = Client:GetName()			  
						ClientGroupName = Client:GetClientGroupName() 			
						ClientGroupID = Client:GetClientGroupID()	   	
						ClientPlane = Client:GetDCSObject():getTypeName(self)
				
						PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
						PlayerCoord = PlayerUnit:GetCoordinate()
						TargetCoord = TargetGroup:GetCoordinate()
						TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
						TargetHeightFt = math.floor(TargetHeight * 3.28084)
						PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)

						TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
						TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
					
						PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())
						
						if (TargetRemainingUnits > 1) then
							SZMessage = "There are "..TargetRemainingUnits.." targets remaining for this mission" 
						elseif (TargetRemainingUnits == 1) then
							SZMessage = "There is "..TargetRemainingUnits.." target remaining for this mission" 
						elseif (TargetRemainingUnits == nil) then					
							SZMessage = "Unable To Determine Group Size"
						else			
							SZMessage = "Nothing to report"		
						end		
					
						BRMessage = ", bearing "..PlayerBR
						ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
						_SETTINGS:SetLL_Accuracy(0)
						CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(3)
						CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
						_SETTINGS:SetLL_Accuracy(2)
						CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())

					    if (ClientPlane == "F-16C_50") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission3BriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
						elseif (ClientPlane == "FA-18C_hornet") then
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission3BriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
						else
							trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMission3BriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
						end
					else						
					end				
				end
			)
		else
			trigger.action.outText("Target Report Unavailable", 15)
		end
		
	elseif (AGTarget3TypeStatic == true and AGMission3Target ~= nil) then
		TargetGroup = STATIC:FindByName(AGMission3Target, false)		
		MissionPlayersBlue = SET_CLIENT:New():FilterCoalitions("blue"):FilterActive():FilterOnce()
		MissionPlayersBlue:ForEachClient(
			function(Client)
				if Client:IsAlive() == true then
					ClientPlayerName = Client:GetPlayerName()	
					ClientUnitName = Client:GetName()			
					ClientGroupName = Client:GetClientGroupName()				
					ClientGroupID = Client:GetClientGroupID()
					ClientPlane = Client:GetDCSObject():getTypeName(self)
				
					PlayerUnit = UNIT:FindByName(ClientUnitName)		
					
					PlayerCoord = PlayerUnit:GetCoordinate()
					TargetCoord = TargetGroup:GetCoordinate()
					TargetHeight = math.floor(TargetGroup:GetCoordinate():GetLandHeight() * 100)/100
					TargetHeightFt = math.floor(TargetHeight * 3.28084)
					PlayerDistance = PlayerCoord:Get2DDistance(TargetCoord)
					
					TargetVector = PlayerCoord:GetDirectionVec3(TargetCoord)
					TargetBearing = PlayerCoord:GetAngleRadians (TargetVector)	
										
					PlayerBR = PlayerCoord:GetBRText(TargetBearing, PlayerDistance, SETTINGS:SetImperial())

					BRMessage = "Target bearing "..PlayerBR
					ELEMessage = "Elevation "..TargetHeight.."m".." / "..TargetHeightFt.."ft"
					
					_SETTINGS:SetLL_Accuracy(0)
					CoordStringLLDMS = TargetCoord:ToStringLLDMS(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(3)
					CoordStringLLDDM = TargetCoord:ToStringLLDDM(SETTINGS:SetImperial())
					_SETTINGS:SetLL_Accuracy(2)
					CoordStringLLDMSDS = TargetCoord:ToStringLLDMSDS(SETTINGS:SetImperial())
					
					if (ClientPlane == "F-16C_50") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDDM.."\n".."\n"..ELEMessage, 30)							
					elseif (ClientPlane == "FA-18C_hornet") then
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n".."\n"..CoordStringLLDMSDS.."\n".."\n"..ELEMessage, 30)							
					else
						trigger.action.outTextForGroup(ClientGroupID, "Target Report For "..ClientPlayerName.."\n".."\n"..AGMissionBriefingText..BRMessage.."\n"..SZMessage.."\n"..CoordStringLLDMS.."\n"..CoordStringLLDDM.."\n"..CoordStringLLDMSDS.."\n"..ELEMessage.."\n"..ClientPlane, 30)							
					end
				else
				end				
			end
		)		
	elseif (OperationComplete == true) then
		trigger.action.outText("The Operation Has Been Completed, There Are No Further Targets", 15)	
	else
		trigger.action.outText("No Target Information Available", 15)
	end
end

--////End On Demand Mission Information
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////AI SUPPORT FLIGHT FUNCTIONS

--[[

SQ BLUE SEAD F-16C
SQ BLUE CAS A-10C
SQ BLUE ASS AJS37
SQ BLUE CAP F-15C

Flags

5001 = Fighter Screen Enabled
5002 = Close Air Support Enabled
5003 = Anti-Ship Strike Enabled
5004 = SEAD Enabled
5005 = Pinpoint Strike Enabled
5891 = Drone JTAC Enabled

5010 = true if Fighter Screen active
5020 = true if Close Air Support is active
5030 = true if Anti Ship Strike is active
5040 = true if SEAD Mission is active
5050 = true if Pinpoint Strike Mission is active
5892 = true if Drone is active

5011 = Fighter Screen Push Command
5021 = Close Air Support Push Command
5031 = Anti Ship Push Command
5041 = SEAD Mission Push Command
5051 = Pinpoint Strike Push Command

]]--

--////COMBAT AIR PATROL FIGHTER SCREEN
function RequestFighterSupport(CAPSector)	
	if (trigger.misc.getUserFlag(5001) == 1) then	
		if (trigger.misc.getUserFlag(5010) == 0) then			
			local RouteNumber = CAPSector			
			BLUECAP1 = SPAWN
				:New("RT BLUE CAP "..RouteNumber)
				:InitLimit(2, 2)
				:InitRandomizeTemplate({"SQ BLUE CAP F-15C"})
				:OnSpawnGroup(
					function(SpawnGroup)								
						RTBLUECAPGROUPNAME = SpawnGroup.GroupName
						RTBLUECAPGROUPID = Group.getByName(RTBLUECAPGROUPNAME):getID()												
					end
				)				
				:Spawn()
			
			trigger.action.outText("Fighter Screen Launched", 60)
			trigger.action.setUserFlag(5010, 1)			
		elseif (trigger.misc.getUserFlag(5010) == 1) then						
			if (BLUECAP1:IsAlive()) then
				trigger.action.outText("Fighter Screen Is Currently Active, Further Support Is Unavailable", 60)
			else
				trigger.action.setUserFlag(5010, 0)
				RequestFighterSupport(CAPSector)
			end			
		else			
		end
	else
		trigger.action.outText("Fighter Screen Unavailable For This Mission",60)		
	end
end

function AbortCAPMission()
	if (trigger.misc.getUserFlag(5010) == 1 ) then
		if (GROUP:FindByName(RTBLUECAPGROUPNAME):IsAlive()) then
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

--////CLOSE AIR SUPPORT
function RequestCASSupport(CASSector)
	if (trigger.misc.getUserFlag(5002) == 1) then
		if (trigger.misc.getUserFlag(5020) == 0) then
			local RouteNumber = CASSector			
			BLUECAS1 = SPAWN
				:New("RT BLUE CAS "..RouteNumber)
				:InitLimit(2, 2)
				:InitRandomizeTemplate({"SQ BLUE CAS A-10C"})
				:OnSpawnGroup(
					function(SpawnGroup)								
						RTBLUECASGROUPNAME = SpawnGroup.GroupName
						RTBLUECASGROUPID = Group.getByName(RTBLUECASGROUPNAME):getID()												
					end
				)
				:Spawn()			
			trigger.action.outText("Close Air Support Launched", 60)
			trigger.action.setUserFlag(5020, 1)	
			
		elseif (trigger.misc.getUserFlag(5020) == 1) then			
			if (BLUECAS1:IsAlive()) then
				trigger.action.outText("Close Air Support Is Currently Active, Further Support Is Unavailable", 60)
			else				
				trigger.action.setUserFlag(5020, 0)
				RequestCASSupport(CASSector)
			end		
		else			
		end
	else
		trigger.action.outText("Close Air Support Unavailable For This Mission",60)
	end	
end

function AbortCASMission()
	if (trigger.misc.getUserFlag(5020) == 1) then
		if (GROUP:FindByName(RTBLUECASGROUPNAME):IsAlive()) then
			local RTB = {}
			RTB.goToWaypointIndex = 7
			local RTBTask = {id = 'SwitchWaypoint', params = RTB}
			Group.getByName(RTBLUECASGROUPNAME):getController():setOption(0, 3) -- (0, 4) is weapons hold, (0, 3) is return fire
			Group.getByName(RTBLUECASGROUPNAME):getController():setCommand(RTBTask)			
			trigger.action.outText("Close Air Support Is Returning To Base", 60)
		else
			trigger.action.outText("Close Air Support Does Not Have Planes To Recall", 60)
		end
	else
		trigger.action.outText("Close Air Support Has Not Been Deployed", 60)
	end
end

--////ANTI-SHIPPING
function RequestASSSupport(ASSSector)	
	if (trigger.misc.getUserFlag(5003) == 1) then	
		if (trigger.misc.getUserFlag(5030) == 0) then			
			local RouteNumber = ASSSector			
			BLUEASS1 = SPAWN
				:New("RT BLUE ASS "..RouteNumber)
				:InitLimit(2, 2)
				:InitRandomizeTemplate({"SQ BLUE ASS AJS37"}) --"SQ BLUE ASS AJS37", "SQ BLUE ASS F/A-18C"
				:OnSpawnGroup(
					function(SpawnGroup)								
						RTBLUEASSGROUPNAME = SpawnGroup.GroupName
						RTBLUEASSGROUPID = Group.getByName(RTBLUEASSGROUPNAME):getID()												
					end
				)
				:Spawn()
			trigger.action.outText("Anti-Shipping Strike Launched", 60)
			trigger.action.setUserFlag(5030, 1)		
			
		elseif (trigger.misc.getUserFlag(5030) == 1) then			
			if (BLUEASS1:IsAlive()) then
				trigger.action.outText("Anti-Shipping Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5030, 0)
				RequestASSSupport(ASSSector)
			end		
		else			
		end
	else
		trigger.action.outText("Anti-Shipping Strike Unavailable For This Mission",60)	
	end	
end

function AbortASSMission()

	if ( trigger.misc.getUserFlag(5030) == 1 ) then
		if ( GROUP:FindByName(RTBLUEASSGROUPNAME):IsAlive() ) then
			--If Alive, Perform RTB command
			local RTB = {}
			--RTB.fromWaypointIndex = 2
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

--////SEAD
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
			--Set flag 5040 to 1
			trigger.action.setUserFlag(5040,1)	
			
		elseif ( trigger.misc.getUserFlag(5040) == 1) then
			--Check if the spawned SEAD group is still alive or not
			
			if ( BLUESEAD1:IsAlive() ) then
				trigger.action.outText("SEAD Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5040,0)
				RequestSEADSupport(SEADSector)
			end		
		else			
		end
	else
		trigger.action.outText("SEAD Unavailable For This Mission",60)
	end		
end

function AbortSEADMission()

	if ( trigger.misc.getUserFlag(5040) == 1 ) then
		if ( GROUP:FindByName(RTBLUESEADGROUPNAME):IsAlive() ) then
			--If Alive, Perform RTB command
			local RTB = {}
			--RTB.fromWaypointIndex = 2
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
			--Set flag 5050 to 1
			trigger.action.setUserFlag(5050,1)	
			
		elseif ( trigger.misc.getUserFlag(5050) == 1) then
			--Check if the spawned Pinpoint Strike group is still alive or not
			
			if ( BLUEPIN1:IsAlive() ) then
				trigger.action.outText("Pinpoint Strike Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5050,0)
				RequestPINSupport(PinSector)
			end		
		else			
		end
	else
		trigger.action.outText("Pinpoint Strike Unavailable For This Mission",60)
	end	
end

function AbortPINMission()

	if ( trigger.misc.getUserFlag(5050) == 1 ) then
		if ( GROUP:FindByName(RTBLUEPINGROUPNAME):IsAlive() ) then
			--If Alive, Perform RTB command
			local RTB = {}
			--RTB.fromWaypointIndex = 2
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
	
	--See https://wiki.hoggitworld.com/view/DCS_task_bombing for further details
	--CHECK TARGET IS IN THE SAME SECTOR THE FLIGHT WAS CALLED TO, GET DETAILS IF IT IS AND ABORT IF NOT
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
			--Set flag 5892 to 1
			trigger.action.setUserFlag(5892,1)	
			
		elseif ( trigger.misc.getUserFlag(5892) == 1) then
			--Check if the spawned drone is still alive or not
						
			if ( BLUEDRONE1:IsAlive() ) then
				trigger.action.outText("MQ-9 Reaper Aerial Drone Is Currently Active, Further Support Is Unavailable",60)
			else
				trigger.action.setUserFlag(5892,0)
				RequestDroneSupport(DRONESector)
			end			
		else			
		end
	else
		trigger.action.outText("MQ-9 Reaper Aerial Drone Unavailable For This Mission",60)		
	end
end

function AbortDroneMission()

	if (trigger.misc.getUserFlag(5892) == 1 ) then
		if ( GROUP:FindByName(RTBLUEDRONEGROUPNAME):IsAlive() ) then
			--If Alive, Perform RTB command
			local RTB = {}
			--RTB.fromWaypointIndex = 2
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

--////AI FLAG SWITCHES ETC
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

--////End Support Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////Radio Menu 

--[[
	Gori
	Gudauta
	Kvemo-Roka
	Ochamchira
	Sochi
	Sukhumi
	Tkvarcheli
	Tskhinvali
	Zemo-Azhara
	Zugdidi
]]--

function SEF_RadioMenuSetup()
	--////Set Up Menu
	-- table missionCommands.addSubMenuForCoalition(enum coalition.side, string name , table path)
	-- table missionCommands.addCommand(string name, table/nil path, function functionToRun , any anyArguement)
	-- table missionCommands.addCommandForCoalition(enum coalition.side, string name, table/nil path, function functionToRun , any anyArguement)

	--////Setup Submenu For Support Requests
	SupportMenuMain = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Support", nil)
	--SupportMenuCAP  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Fighter Support", SupportMenuMain)
	--SupportMenuCAS  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Close Air Support", SupportMenuMain)
	--SupportMenuASS  = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Anti-Shipping Support", SupportMenuMain)
	--SupportMenuSEAD = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request SEAD Support", SupportMenuMain)
	--SupportMenuPIN = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request Pinpoint Strike", SupportMenuMain)
	SupportMenuDrone = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Request MQ-9 Reaper Drone", SupportMenuMain)

		--////AI Support Flights Mission Abort Codes
	SupportMenuAbort = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Call Back Support", nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Fighter Screen", SupportMenuAbort, function() AbortCAPMission() end, nil)	
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Close Air Support", SupportMenuAbort, function() AbortCASMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Anti-Shipping", SupportMenuAbort, function() AbortASSMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission SEAD", SupportMenuAbort, function() AbortSEADMission() end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission Pinpoint Strike", SupportMenuAbort, function() AbortPINMission() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission MQ-9 Reaper Drone", SupportMenuAbort, function() AbortDroneMission() end, nil)
	
	--////Setup Menu Option To Get The Current Objective
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Current Objectives", nil, function() CheckObjectiveRequest() end, nil)
	--////Target Report to get target numbers and coordinates 
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target 1 Report", nil, function() Target1Report() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target 2 Report", nil, function() Target2Report() end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Target 3 Report", nil, function() Target3Report() end, nil)
	--////Drop Smoke On The Target
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Flare Current Objective", nil, function() SEF_TargetSmoke() end, nil)
	
	
	--////Clear Field Mission Options
	ClearFieldOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Clear Field Options", nil)
	--ClearFieldCAPOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Clear Field CAP Options", ClearFieldOptions)
	--ClearFieldSNDOptions = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "Clear Field Sound Options", ClearFieldOptions)
	--ClearFieldCAPKutaisi = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Kutaisi Vipers", ClearFieldCAPOptions, function() SEF_KutaisiCAP() end, nil)
	--ClearFieldFleetCats = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Fleet Tomcats", ClearFieldCAPOptions, function() SEF_FleetTomcats() end, nil)
	--ClearFieldFleetBugs = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Enable Fleet Hornets", ClearFieldCAPOptions, function() SEF_FleetHornets() end, nil)
	--ClearFieldToggleFiringSounds = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Toggle Firing Sounds", ClearFieldSNDOptions, function() SEF_ToggleFiringSounds() end, nil)
	--local ClearFieldDisableShips  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Naval Ships AI Off", ClearFieldOptions, function() SEF_DisableShips() end, nil)
	ClearFieldDefenceCheck  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Defence Networks", ClearFieldOptions, function() SEF_CheckDefenceNetwork() end, nil)
	ClearFieldAirfieldCheck  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Check Airfield Status", ClearFieldOptions, function() SEF_CheckAirfieldStatus() end, nil)
	ClearFieldSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission 1", ClearFieldOptions, function() SEF_SkipMission1() end, nil)
	ClearFieldSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission 2", ClearFieldOptions, function() SEF_SkipMission2() end, nil)
	ClearFieldSkipScenario  = missionCommands.addCommandForCoalition(coalition.side.BLUE, "Abort Mission 3", ClearFieldOptions, function() SEF_SkipMission3() end, nil)
		
	--////CAP Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuCAP, function() RequestFighterSupport('Gori') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuCAP, function() RequestFighterSupport('Gudauta') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuCAP, function() RequestFighterSupport('Kvemo Roka') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuCAP, function() RequestFighterSupport('Ochamchira') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuCAP, function() RequestFighterSupport('Sochi') end, nil)
    --missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuCAP, function() RequestFighterSupport('Sukhumi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuCAP, function() RequestFighterSupport('Tkvarcheli') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuCAP, function() RequestFighterSupport('Tskhinvali') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuCAP, function() RequestFighterSupport('Zemo Azhara') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuCAP, function() RequestFighterSupport('Zugdidi') end, nil)
		
	--////CAS Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuCAS, function() RequestCASSupport('Gori') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuCAS, function() RequestCASSupport('Gudauta') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuCAS, function() RequestCASSupport('Kvemo Roka') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuCAS, function() RequestCASSupport('Ochamchira') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuCAS, function() RequestCASSupport('Sochi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuCAS, function() RequestCASSupport('Sukhumi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuCAS, function() RequestCASSupport('Tkvarcheli') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuCAS, function() RequestCASSupport('Tskhinvali') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuCAS, function() RequestCASSupport('Zemo Azhara') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuCAS, function() RequestCASSupport('Zugdidi') end, nil)
	
	--////ANTI-SHIPPING Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuASS, function() RequestASSSupport('Gori') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuASS, function() RequestASSSupport('Gudauta') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuASS, function() RequestASSSupport('Kvemo Roka') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuASS, function() RequestASSSupport('Ochamchira') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuASS, function() RequestASSSupport('Sochi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuASS, function() RequestASSSupport('Sukhumi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuASS, function() RequestASSSupport('Tkvarcheli') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuASS, function() RequestASSSupport('Tskhinvali') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuASS, function() RequestASSSupport('Zemo Azhara') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuASS, function() RequestASSSupport('Zugdidi') end, nil)
		
	--////SEAD Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuSEAD, function() RequestSEADSupport('Gori') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuSEAD, function() RequestSEADSupport('Gudauta') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuSEAD, function() RequestSEADSupport('Kvemo Roka') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuSEAD, function() RequestSEADSupport('Ochamchira') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuSEAD, function() RequestSEADSupport('Sochi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuSEAD, function() RequestSEADSupport('Sukhumi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuSEAD, function() RequestSEADSupport('Tkvarcheli') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuSEAD, function() RequestSEADSupport('Tskhinvali') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuSEAD, function() RequestSEADSupport('Zemo Azhara') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuSEAD, function() RequestSEADSupport('Zugdidi') end, nil)
	
	--////PIN Support Sector List
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuPIN, function() RequestPINSupport('Gori') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuPIN, function() RequestPINSupport('Gudauta') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuPIN, function() RequestPINSupport('Kvemo Roka') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuPIN, function() RequestPINSupport('Ochamchira') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuPIN, function() RequestPINSupport('Sochi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuPIN, function() RequestPINSupport('Sukhumi') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuPIN, function() RequestPINSupport('Tkvarcheli') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuPIN, function() RequestPINSupport('Tskhinvali') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuPIN, function() RequestPINSupport('Zemo Azhara') end, nil)
	--missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuPIN, function() RequestPINSupport('Zugdidi') end, nil)

	--////DRONE Support Sector List
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gori", SupportMenuDrone, function() RequestDroneSupport('Gori') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Gudauta", SupportMenuDrone, function() RequestDroneSupport('Gudauta') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Kvemo-Roka", SupportMenuDrone, function() RequestDroneSupport('Kvemo Roka') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Ochamchira", SupportMenuDrone, function() RequestDroneSupport('Ochamchira') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sochi", SupportMenuDrone, function() RequestDroneSupport('Sochi') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Sukhumi", SupportMenuDrone, function() RequestDroneSupport('Sukhumi') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tkvarcheli", SupportMenuDrone, function() RequestDroneSupport('Tkvarcheli') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Tskhinvali", SupportMenuDrone, function() RequestDroneSupport('Tskhinvali') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zemo-Azhara", SupportMenuDrone, function() RequestDroneSupport('Zemo Azhara') end, nil)
	missionCommands.addCommandForCoalition(coalition.side.BLUE, "Sector Zugdidi", SupportMenuDrone, function() RequestDroneSupport('Zugdidi') end, nil)	
end

--////End Radio Menu Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////NAVAL FUNCTIONS

function SEF_ROEWeaponFreeStennis()	
	Group.getByName("CVN-74 John C. Stennis"):getController():setOption(0, 2)
	--trigger.action.outText("Stennis ROE Set To Weapons Free", 15)
end

function SEF_ROEWeaponFreeTarawa()	
	Group.getByName("LHA-1 Tarawa"):getController():setOption(0, 2)
	--trigger.action.outText("Tarawa ROE Set To Weapons Free", 15)
end

function SEF_ROEHoldStennis()	
	Group.getByName("CVN-74 John C. Stennis"):getController():setOption(0, 4)
	--trigger.action.outText("Stennis ROE Set Back To Weapons Hold", 15)
end

function SEF_ROEHoldTarawa()	
	Group.getByName("LHA-1 Tarawa"):getController():setOption(0, 4)
	--trigger.action.outText("Tarawa ROE Set Back To Weapons Hold", 15)
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
	--trigger.action.outText("Carrier Stennis Is Scanning For Targets", 15)
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
			--trigger.action.outText("Carrier Stennis Has Detected "..StennisDefenceZoneCount.." Targets In Their Airspace", 15)			
			SEF_StennisShipTargeting()						
		elseif ( StennisDefenceZoneCount == 1 ) then
			--trigger.action.outText("Carrier Stennis Has Detected "..StennisDefenceZoneCount.." Target In Their Airspace", 15)			
			SEF_StennisShipTargeting()			
		else			
		end		
	else	
	end
	
	--trigger.action.outText("Carrier Tarawa Is Scanning For Targets", 15)
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
			--trigger.action.outText("Carrier Tarawa Has Detected "..TarawaDefenceZoneCount.." Targets In Their Airspace", 15)			
			SEF_TarawaShipTargeting()						
		elseif ( TarawaDefenceZoneCount == 1 ) then
			--trigger.action.outText("Carrier Tarawa Has Detected "..TarawaDefenceZoneCount.." Target In Their Airspace", 15)			
			SEF_TarawaShipTargeting()			
		else
		end		
	else
	end	
	
	return time + 20	
end

--////End Naval Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OVERRIDE FUNCTIONS

function SEF_DisableShips()
	
	--////Naval Vessel AI Off
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

--////End Override Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////RED BOMBER ATTACK FUNCTIONS

--[[

--TEMPLATES
SQ RUS Tu-95MS
SQ RUS Tu-160				
SQ RUS Su-24				
SQ RUS Tu-22M3				
SQ IRN Su-25
	
--ROUTES	
RT RED PIN 1
RT RED PIN 2

]]--

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
			
			--trigger.action.outText("Enemy Bombers Approaching",60)
			--Set flag 5070 to 1
			trigger.action.setUserFlag(5070,1)	
			
		elseif ( trigger.misc.getUserFlag(5070) == 1) then
			--Check if the spawned Pinpoint Strike group is still alive or not
			
			if ( REDPIN1:IsAlive() ) then
				--Do nothing as bombers are still active
			else
				trigger.action.setUserFlag(5070,0)
				SEF_RedBomberAttack()
			end		
		else			
		end
	else
		trigger.action.outText("Enemy Bomber Missions Currently Disabled",60)
	end
end

function SEF_RedBomberScheduler(timeloop, time)

	if (trigger.misc.getUserFlag(5006) == 1) then
		SEF_RedBomberAttack()		
		
		return time + math.random(1800, 2700) --Initiate between 30 minutes and 45 minutes	
	else		
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
	Group.getByName(RTREDPINGROUPNAME):getController():pushTask(engage) -- :setTask(engage)
					
	--////Launch Codes
	--Any ASM = 4161536
	--Any AG Weapon = 2956984318
	
	--[[
		Bombing = { 
			id = 'AttackMapObject', 
			params = { 
				point = Vec2,
				weaponType = number, 
				expend = enum AI.Task.WeaponExpend,
				attackQty = number, 
				direction = Azimuth, 
				groupAttack = boolean, 
			} 
		}
	]]--
end

--////End Red Bomber Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////BLUE AWACS/TANKER SPAWN

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

--////End Blue Awacs/Tankers Spawn
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////TARGET SMOKE FUNCTIONS

function SEF_TargetSmokeLock()
	TargetSmokeLockout = 1
end

function SEF_TargetSmokeUnlock()
	TargetSmokeLockout = 0
end

function SEF_TargetSmoke()
	
	if ( TargetSmokeLockout == 0 ) then
		if ( AGTargetTypeStatic == false and AGMissionTarget ~= nil ) then
			--TARGET IS NOT STATIC					
			if ( GROUP:FindByName(AGMissionTarget):IsAlive() == true ) then
				--GROUP VALID
				SEFTargetSmokeGroupCoord = GROUP:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeGroupCoord:SmokeRed()
				--SEFTargetSmokeGroupCoord:SmokeBlue()
				--SEFTargetSmokeGroupCoord:SmokeGreen()
				--SEFTargetSmokeGroupCoord:SmokeOrange()
				--SEFTargetSmokeGroupCoord:SmokeWhite()
				trigger.action.outSound('Target Smoke.ogg')
				trigger.action.outText("Target Has Been Marked With Red Flare", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
			else			
				trigger.action.outText("Target Flare Currently Unavailable - Unable To Acquire Target Group", 15)						
			end		
		elseif ( AGTargetTypeStatic == true and AGMissionTarget ~= nil ) then		
			--TARGET IS STATIC		
			if ( StaticObject.getByName(AGMissionTarget) ~= nil and StaticObject.getByName(AGMissionTarget):isExist() == true ) then
				--STATIC IS VALID
				SEFTargetSmokeStaticCoord = STATIC:FindByName(AGMissionTarget):GetCoordinate()
				SEFTargetSmokeStaticCoord:FlareRed()
				--SEFTargetSmokeStaticCoord:SmokeRed()
				--SEFTargetSmokeStaticCoord:SmokeBlue()
				--SEFTargetSmokeStaticCoord:SmokeGreen()
				--SEFTargetSmokeStaticCoord:SmokeOrange()
				--SEFTargetSmokeStaticCoord:SmokeWhite()				
				trigger.action.outSound('Target Smoke.ogg')
				trigger.action.outText("Target Has Been Marked With Red Flare", 15)
				SEF_TargetSmokeLock()
				timer.scheduleFunction(SEF_TargetSmokeUnlock, 53, timer.getTime() + 300)				
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


--////End Target Smoke Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////OTHER FUNCTIONS

function SEF_CheckDefenceNetwork()
	trigger.action.outText("Allied Defence Network Consists Of "..BLUEDetectionSetGroup:Count().." Groups\nRussian Defence Network Consists Of "..REDDetectionSetGroup:Count().." Groups", 15)

	--BLUEDetectionSetGroup:ForEachGroup(
	--	function(BlueDefenceGroupCheck)
	--		BlueDefenceGroupName = BlueDefenceGroupCheck:GetName()			
	--		trigger.action.outText(BlueDefenceGroupName, 60)			
	--	end
	--)	
end

function SEF_CheckAirfieldStatus()
	trigger.action.outText("Airfield Status Report".."\n\n"..GudautaStatus.."\n"..SochiStatus.."\n"..NalchikStatus.."\n"..BeslanStatus.."\n"..KuznetsovStatus, 10)
end

--////End Other Functions
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--////MAIN

		--////GLOBAL VARIABLE INITIALISATION	
		NumberOfCompletedMissions = 0
		TotalScenarios = 125
		OperationComplete = false
		OnShotSoundsEnabled = 1
		SoundLockout = 0
		TargetSmokeLockout = 0
				
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
		SEF_MissionSelector(1)
		SEF_MissionSelector(2)
		SEF_MissionSelector(3)
		SEF_RadioMenuSetup()
		SEF_BLUEAwacsSpawn()
		SEF_BLUETexacoSpawn()
		SEF_BLUEShellSpawn()
		SEF_BLUEArcoSpawn()
		--SEF_CarrierStennisDefenceZone()
		--SEF_CarrierTarawaDefenceZone()
		
		--////SCHEDULERS
		--AI FLIGHT PUSH FLAGS		
		timer.scheduleFunction(SEF_CheckAIPushFlags, 53, timer.getTime() + 1)
		--MISSION TARGET STATUS
		timer.scheduleFunction(SEF_Mission1TargetStatus, 53, timer.getTime() + 10)
		timer.scheduleFunction(SEF_Mission2TargetStatus, 53, timer.getTime() + 10)
		timer.scheduleFunction(SEF_Mission3TargetStatus, 53, timer.getTime() + 10)


		--RED BOMBER ATTACKS - WAIT 10-15 MINUTES BEFORE STARTING
		timer.scheduleFunction(SEF_RedBomberScheduler, 53, timer.getTime() + math.random(600, 900))
		--CARRIER DEFENCE ZONE SCANNER - WAIT 5 MINUTES BEFORE STARTING
		--timer.scheduleFunction(SEF_CarrierDefenceZoneScanner, 53, timer.getTime() + 300)	
	
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

--////Stuff
--[[

Kvemo Roka - AAA 1													MN21 At Kvemo-Roka							
Kvemo Roka - Armor 1												MN21 At Kvemo-Roka			
Kvemo Roka - Armor 2												MN21 At Zemo-Roka						
Kvemo Roka - Armor 3												MM19 At Elbakita						
Kvemo Roka - SAM 1													MN21 At Kvemo-Roka																		
Kvemo Roka - Supply 1												MN21 At Kvemo-Roka						
Kvemo Roka - Convoy 1												MN31 At Kvemo-Sba
Kvemo Roka - Convoy 2					8							MN20 At Kvemo-Khoshka

Gori - AAA 1														MM26 South of Dzevera
Gori - AAA 2														MM24 At Gori
Gori - AAA 3														MM15 At Ruisi
Gori - Armor 1														MM26 South of Dzevera
Gori - Armor 2														MM24 At Gori
Gori - Armor 3														MM15 At Ruisi	
Gori - Artillery 1													MM26 South of Dzevera
Gori - Artillery 2													MM24 At Gori
Gori - Artillery 3													MM15 At Ruisi
Gori - SAM 1														MM26 South of Dzevera			
Gori - SAM 2														MM24 At Gori	
Gori - Supply 1														MM26 South of Dzevera	
Gori - Supply 2														MM24 At Gori	
Gori - Command 1					14								MM15 At Ruisi

Gudauta - AAA 1														FH27 At Gudauta Airfield	
Gudauta - AAA 2														FH37 At Gudauta
Gudauta - Bomber 1 							Static					FH27 North of Gudauta Airfield
Gudauta - Navy 1													FH16
Gudauta - SAM 1														FH27 At Gudauta Airfield		
Gudauta - Supply 1													FH47 Feeding the SA-10 site at Adzhapsha
Gudauta - Supply 2													FH27 At Gudauta Airfield
Gudauta - Comms								Static					FH37 West of Achkatsa
Gudauta - Military HQ						Static					FH37 At Gudauta
Gudauta - Armor 1 													FH18 Lidzava
Gudauta - Infantry 1 												FH38 South of Aosyrhva
Gudauta - Lidzava Military Barracks 		Static					FH18
Gudauta - Achandara Military Barracks 		Static					FH38 South of Aosyrhva
RED SAM Gudauta SA-10				14								FH47 At Adzhapsha


Ochamchira - AAA 1													GH03 At Ochamchira
Ochamchira - AAA 2													GH12 At Repo-Etseri		
Ochamchira - Armor 1												GH03 East of Ochamchira
Ochamchira - Cargo Ships 1											FH92
Ochamchira - Navy 1													FH82
Ochamchira - SAM 1													GH03 At Ochamchira
Ochamchira - Train Station					Static					GH03 At Ochamchira	
Ochamchira - Comms							Static					GH03 At Ochamchira
Ochamchira - Military HQ					Static					GH03 At Ochamchira
Ochamchira - Naval Repair 					Static					FH93 West of Dzhukmur
Ochamchira - AAA 3 													FH93 West of Dzhukmur
Ochamchira - Navy 2 				12								FH93 

Sochi - AAA 1														EJ52 At Sochi Docks
Sochi - Cargo Ships 1												EJ52 At Sochi Docks
Sochi - Cargo Ships 2												EJ60
Sochi - Navy 1														EJ52
Sochi - Navy 2														EJ52 Submarines At Sochi Docks	
Sochi - Supply 1													EJ53 Feeding SA-11 site West of Dagomys
Sochi - Comms								Static					EJ62 North-West of Razdol'noe
RED SAM Sochi SA-11					8								EJ53 SA-11 site West of Dagomys

Sukhumi - AAA 1														FH66 At Sukhumi
Sukhumi - Cargo Ships 1												FH55		
Sukhumi - Cargo Ships 2												FH65 At Kvemo-Merheuli Docks		
Sukhumi - Navy 1													FH54
Sukhumi - SAM 1														FH56 At Gumista
Sukhumi - SAM 2														FH66 At Sukhumi
Sukhumi - Supply 1													FH75 At Gul'ripsh feeding SA-10 site
Sukhumi - Supply 2													FH66 At Sukhumi	
Sukhumi - Train														FH56 At Gumista
Sukhumi - Comms								Static					FH66 North of Tavisupleba
Sukhumi - Military Warehouse 				Static					FH66
Sukhumi - Military HQ 						Static					FH66
Sukhumi - Boat Bunker 						Static					FH66
Sukhumi - Navy 2 													FH66 
RED SAM Sukhumi SA-10				15								FH75 At Gul'ripsh

Tkvarcheli - AAA 1													GH14 At Tkvarcheli		
Tkvarcheli - AAA 2													GH23 At Agvavera
Tkvarcheli - AAA 3													KN53 At Enguri Dam	
Tkvarcheli - Armor 1												GH14 At Tkvarcheli
Tkvarcheli - Armor 2												KN53 At Enguri Dam
Tkvarcheli - Military HQ					Static					GH23 At Agvavera
Tkvarcheli - SAM 1													GH23 At Agvavera
Tkvarcheli - Supply 1												GH23 At Agvavera
Tkvarcheli - Comms							Static					GH34 On top of mountain	north of the three rivers
Tkvarcheli - Transport				10		Static					GH23 At Agvavera

Tskhinvali - AAA 1													MM18 At Kurta
Tskhinvali - AAA 2													MM17 South of Tskhinvali	
Tskhinvali - Armor 1												MM18 At Kurta
Tskhinvali - Armor 2												MM17 South of Tskhinvali
Tskhinvali - Armor 3												MM17 At Ergneti
Tskhinvali - Command 1												MM17 South of Tskhinvali
Tskhinvali - Infantry 1												MM17 At Ergneti
Tskhinvali - Military Barracks 				Static					MM18 At Kurta
Tskhinvali - Outpost												MM17 At Ergneti
Tskhinvali - SAM 1													MM17 South of Tskhinvali
Tskhinvali - SAM 2													MM17 At Tskhinvali
Tskhinvali - Barracks						Static					MM17 At Tskhinvali
Tskhinvali - Command HQ						Static					MM17 At Tskhinvali
Tskhinvali - Supply 1				14								MM17 At Tskhinvali

Zemo Azhara - AAA 1													GH27 East Of Zemo-Azhara
Zemo Azhara - AAA 2													GH37 East of Zemo-Azhara	
Zemo Azhara - Armor 1												GH27 East Of Zemo-Azhara
Zemo Azhara - Armor 2												GH37 East of Zemo-Azhara	
Zemo Azhara - Armor 3												GH37 East of Zemo-Azhara
Zemo Azhara - Artillery 1											GH27 East Of Zemo-Azhara
Zemo Azhara - Artillery 2											GH37 East of Zemo-Azhara
Zemo Azhara - SAM 1													GH27 East Of Zemo-Azhara
Zemo Azhara - Supply 1												GH27 East Of Zemo-Azhara
Zemo Azhara - Supply 2				10								GH37 East of Zemo-Azhara		

Zugdidi - AAA 1														GH20/21 At Zeni
Zugdidi - AAA 2														GH31 East of Chuburhindzhi
Zugdidi - Armor 1													GH20/21 At Zeni
Zugdidi - Armor 2													GH31 East of Chuburhindzhi
Zugdidi - Armor 3													GH42 North of Pahulani
Zugdidi - Artillery 1												GH20/21 At Zeni		
Zugdidi - Artillery 2												GH31 East of Chuburhindzhi
Zugdidi - SAM 1														GH31 East of Chuburhindzhi
Zugdidi - SAM 2														GH42 North of Pahulani
Zugdidi - Saberio Border Post				Static					GH32 South of Saberio
Zugdidi - Infantry 1												GH32 South of Saberio
Zugdidi - Gali Military Barracks			Static					GH22 At Gali
Zugdidi - Infantry 2												GH22 At Gali
Zugdidi - Supply 1													GH22 At Gali
Zugdidi - Armor 4					15								GH22 At Gali	

----------------------------------------------------------------

Not included

RED SAM Anapskaya SA-10				Do not include
RED SAM Krymsk SA-2					Do not include
RED SAM Novorossiysk SA-10			Do not include
RED SAM Utash SA-3					Do not include	
Anapskaya - Supply 1				Do not include
Krymsk - Supply 1					Do not include
Novorossiysk - Supply 1				Do not include
Utash - Supply 1					Do not include

]]--

--[[

RED Bomber Target 1 - Zugdidi
RED Bomber Target 2	- Gori

]]--

--[[
Anti Ship Strikes

Gudauta - Navy 1
Ochamchira - Navy 1
Ochamchira - Cargo Ships 1
Sukhumi - Navy 1
Sukhumi - Cargo Ships 1
Sukhumi - Cargo Ships 2
Sochi - Navy 1
Sochi - Navy 2 (subs)
Sochi - Cargo Ships 1
Sochi - Cargo Ships 2

]]--	