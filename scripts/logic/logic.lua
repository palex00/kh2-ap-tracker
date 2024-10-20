function mcguffin()
    local emblemcount = Tracker:FindObjectForCode('LuckyEmblem').AcquiredCount
    local bountycount = Tracker:FindObjectForCode('Bounty').AcquiredCount

    local req_emblem = Tracker:FindObjectForCode('opt_emblem').AcquiredCount
	local req_bounty = Tracker:FindObjectForCode('opt_bounty').AcquiredCount
	
    return (
	emblemcount >= req_emblem and
	bountycount >= req_bounty
	)
end

function final()
    local none = AccessibilityLevel.None
    local ool = AccessibilityLevel.SequenceBreak
    local normal = AccessibilityLevel.Normal
    local stage = Tracker:FindObjectForCode('opt_finalform').CurrentStage

    if stage == 2 then
		-- print("Final: Forced")
        return normal
    elseif stage == 1 then
		if Tracker:FindObjectForCode('LightandDarkness').Active then
			-- print("Final: LAD & You have it")
			return normal
		else
			-- print("Final: LAD & but you don't have it")
			return ool
		end
    elseif stage == 0 then
        if Tracker:FindObjectForCode('FinalForm').Active then
			-- print("Final: You have FinalForm")
            return normal
        elseif Tracker:FindObjectForCode('LightandDarkness').Active then
			-- print("Final: You have LAD so it's OOL")
            return ool
        end
    end
    return none  -- Return None if no conditions are met
end


function dif(level)
	local difficulty = Tracker:FindObjectForCode('opt_fightlogic')
    if difficulty.CurrentStage == 2 then
        return true
    elseif difficulty.CurrentStage == 1 then
		if level == "normal" or level == "easy" then
			return AccessibilityLevel.Normal
		elseif level == "hard" then
			return AccessibilityLevel.SequenceBreak
		end
	elseif difficulty.CurrentStage == 0 then
		if level == "easy" then
			return AccessibilityLevel.Normal
		elseif level == "normal" or level == "hard" then
			return AccessibilityLevel.SequenceBreak
		end
	end
end