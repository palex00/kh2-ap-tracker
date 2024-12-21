function get_slot_options(slot_data)

    if slot_data["FinalXemnas"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_xemnas")
		local stage = slot_data["FinalXemnas"]
		if stage >= 1 then
			stage = 1
		end
		if obj then
			obj.CurrentStage = stage
		end
	end
	
    if slot_data["Goal"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_goal")
		local stage = slot_data["Goal"]
		if stage >= 3 then
			stage = 3
		end
		if obj then
			obj.CurrentStage = stage
		end
	end
	
	goalmode = Tracker:FindObjectForCode('opt_goal').CurrentStage
	
    if slot_data["BountyRequired"] ~= nil and (goalmode == 2 or goalmode == 3) then
		Tracker:FindObjectForCode('opt_bounty').AcquiredCount = slot_data["BountyRequired"]
	else
		Tracker:FindObjectForCode('opt_bounty').AcquiredCount = 0
	end
	
    if slot_data["LuckyEmblemsRequired"] ~= nil and (goalmode == 1 or goalmode == 3) then
		Tracker:FindObjectForCode('opt_emblem').AcquiredCount = slot_data["LuckyEmblemsRequired"]
	else
		Tracker:FindObjectForCode('opt_emblem').AcquiredCount = 0
	end
	
	if slot_data["FightLogic"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_fightlogic")
		local stage = slot_data["FightLogic"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_FightLogic").Active = true
	end
	
	if slot_data["FinalFormLogic"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_finalform")
		local stage = slot_data["FinalFormLogic"]
		if stage >= 2 then
			stage = 2
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_FinalFormLogic").Active = true

	end
	
	if slot_data["AutoFormLogic"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_autoform")
		local stage = slot_data["AutoFormLogic"]
		if stage >= 1 then
			stage = 1
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_AutoFormLogic").Active = true
	end
	
	if slot_data["LevelDepth"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_leveldepth")
		local stage = slot_data["LevelDepth"]
		if stage >= 4 then
			stage = 4
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_LevelDepth").Active = true
	end
	
	if slot_data["DonaldGoofyStatsanity"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_dgstats")
		local stage = slot_data["DonaldGoofyStatsanity"]
		if stage >= 1 then
			stage = 1
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_DonaldGoofyStatsanity").Active = true
	end
	
	if slot_data["CorSkipToggle"] ~= nil then
		local obj = Tracker:FindObjectForCode("opt_corskip")
		local stage = slot_data["CorSkipToggle"]
		if stage >= 1 then
			stage = 1
		end
		if obj then
			obj.CurrentStage = stage
		end
	else
		print("The apworld this was generated with did not include slot data neccessary to fill certain options. Double check options please. You can find an updated apworld at PR #4031 on Github.")
		Tracker:FindObjectForCode("missing_CorSkipToggle").Active = true
	end
end
