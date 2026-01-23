
ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/slot_options.lua")
ScriptHost:LoadScript("scripts/autotracking/map_swapping.lua")

-- used for hint tracking to quickly map hint status to a value from the Highlight enum
if Highlight then
    HIGHTLIGHT_LEVEL = {
        [0] = Highlight.Unspecified,
        [10] = Highlight.NoPriority,
        [20] = Highlight.Avoid,
        [30] = Highlight.Priority,
        [40] = Highlight.None
    }
end

CUR_INDEX = -1
SLOT_DATA = {}
HINT_ID = {}

function has_value (t, val)
    for i, v in ipairs(t) do
        if v == val then return 1 end
    end
    return 0
end

function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end
    if type(o) == 'table' then
        local tabs = ('	'):rep(depth)
        local tabs2 = ('	'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end
            s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function onClear(slot_data)
    
    print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))

    CUR_INDEX = -1
    
    -- reset locations
    for _, location_array in pairs(LOCATION_MAPPING) do
        for _, location in pairs(location_array) do
            if location then
                local location_obj = Tracker:FindObjectForCode(location)
                if location_obj then
                    if location:sub(1, 1) == "@" then
                        location_obj.AvailableChestCount = location_obj.ChestCount
                        location_obj.Highlight = 0
                    else
                        location_obj.Active = false
                    end
                end
            end
        end
    end
    
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            --    print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    
    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0
    SLOT_DATA = slot_data
    get_slot_options(slot_data)
    
    WORLD_ID = "Slot: " .. PLAYER_ID .. " :CurrentWorld"
	HINT_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
    
    Archipelago:SetNotify({WORLD_ID})
    Archipelago:SetNotify({HINT_ID})
    Archipelago:Get({HINT_ID})
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local item = ITEM_MAPPING[item_id]
    if not item or not item[1] then
        --print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end

    item_code = item[1]
    item_type = item[2]
    
    local item_obj = Tracker:FindObjectForCode(item_code)

    if item_obj then
        if item_obj.Type == "toggle" then
            item_obj.Active = true
        elseif item_obj.Type == "progressive" then
            item_obj.Active = true
        elseif item_obj.Type == "consumable" then
            item_obj.AcquiredCount = item_obj.AcquiredCount + item_obj.Increment
        elseif item_obj.Type == "progressive_toggle" then
            if item_obj.Active then
                item_obj.CurrentStage = item_obj.CurrentStage + 1
            else
                item_obj.Active = true
            end
        end
    else
        print(string.format("onItem: could not find object for code %s", item_code[1]))
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    local location_array = LOCATION_MAPPING[location_id]
    if not location_array or not location_array[1] then
        -- print(string.format("onLocation: could not find location mapping for id %s", location_id))
        return
    end

    for _, location in pairs(location_array) do
        local location_obj = Tracker:FindObjectForCode(location)
        
        if location_obj then
            if location:sub(1, 1) == "@" then
                location_obj.AvailableChestCount = location_obj.AvailableChestCount - 1
            else
                location_obj.Active = true
            end
        else
            print(string.format("onLocation: could not find location_object for code %s", location))
        end
    end
	if regioninfo ~= nil then 
		if string.find(location_name, "%(STT%)") and regioninfo == 2 then
			-- print("STT switch")
			Tracker:UiHint("ActivateTab", "(STT)")
		elseif string.find(location_name, "%(HB%)") and regioninfo == 4 then
			-- print("HB switch")
			Tracker:UiHint("ActivateTab", "(HB)")
		elseif string.find(location_name, "%(HB2%)") and regioninfo == 4 then
			-- print("HB2 switch")
			Tracker:UiHint("ActivateTab", "(HB)")
		elseif string.find(location_name, "%(CoR%)") and regioninfo == 4 then
			-- print("CoR switch")
			Tracker:UiHint("ActivateTab", "(CoR)")
		else
			-- print("Special Case does not apply. Current Region: " .. regioninfo)
		end
	end
end

function onNotify(key, value, old_value)
    if value ~= nil and value ~= 0 then
        if key == WORLD_ID then
            onChangedRegion(value, old_value)
        elseif key == HINT_ID then
            updateHints(value)
        end
    end
end


function onNotifyLaunch(key, value)
    if value ~= nil and value ~= 0 then
        if key == HINT_ID then
            updateHints(value)
        end
    end
end

function onChangedRegion(current_region, old_region)
	regioninfo = current_region
    if (current_region ~= old_region) then
        if TABS_MAPPING[current_region] then
            CURRENT_ROOM = TABS_MAPPING[current_region]
        else
            CURRENT_ROOM = CURRENT_ROOM_ADDRESS
        end
        Tracker:UiHint("ActivateTab", CURRENT_ROOM)
    end
end


function updateHints(value)
    if not Highlight then
        return
    end
    
    for _, hint in ipairs(value) do
        if hint.finding_player == PLAYER_ID then
            local mapped = LOCATION_MAPPING[hint.location]
            local locations = (type(mapped) == "table") and mapped or { mapped }
    
            
            for _, location in ipairs(locations) do
                -- Only sections (items don't support Highlight)
                if type(location) == "string" and location:sub(1, 1) == "@" then
                    Tracker:FindObjectForCode(location).Highlight = HIGHTLIGHT_LEVEL[hint.status]
                end
            end
        end        
    end
end


function scoutable()
	return AccessibilityLevel.Inspect
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("CurrentWorld", onChangedRegion)

Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
