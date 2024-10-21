
function A(result)
    if result then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.None
    end
end

function all(...)
    local args = { ... }
    local min = AccessibilityLevel.Normal
    for i, v in ipairs(args) do
        if type(v) == "boolean" then
            v = A(v)
        end
        if v < min then
            if v == AccessibilityLevel.None then
                return AccessibilityLevel.None
            else
                min = v
            end
        end
    end
    return min
end

function has_any(...)
    local args = { ... }
    local max = AccessibilityLevel.None
    for i, v in ipairs(args) do
        if type(v) == "boolean" then
            v = A(v)
        end
        if tonumber(v) > tonumber(max) then
            if tonumber(v) == AccessibilityLevel.Normal then
                return AccessibilityLevel.Normal
            else
                max = tonumber(v)
            end
        end
    end
    return max
end

function has(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	local amount = tonumber(amount)
	if not amount then
        if count > 0 then
            return AccessibilityLevel.Normal
        end
	elseif count >= amount then
        return AccessibilityLevel.Normal
	end
    return AccessibilityLevel.None
end

function any(...)
    local args = { ... }
    local wrapped_args = {}

    for i, v in ipairs(args) do
        table.insert(wrapped_args, has(v))
    end

    return has_any(table.unpack(wrapped_args))
end

function multiple(neededcount, ...)
    local args = { ... }
    neededcount = tonumber(neededcount)  -- Ensure neededcount is a number
    
    local totalItems = 0
	local maybeItems = 0

    for i, item in ipairs(args) do
            if item ~= "final" then
				local trackerItem = Tracker:FindObjectForCode(item)
					if trackerItem ~= nil then
						local count = trackerItem.AcquiredCount
						if trackerItem.Active == true then
							totalItems = totalItems + 1
							if trackerItem.AcquiredCount >= 2 then
								totalItems = totalItems + count - 1
							end
						end
					end
			elseif item == "final" then
				local func = _G[item]  -- Get the function from the global environment
				if type(func) == "function" then
					local result = func()  -- Execute the function
					-- print("Result of function call:", result)
					if result == 6 then
						totalItems = totalItems + 1
					elseif result == 5 then
						maybeItems = maybeItems + 1
					elseif result == 0 then
					end
				else
					print("Error: Function", item, "not found")
				end
			end
    end    
	
	if totalItems >= neededcount then
		return AccessibilityLevel.Normal
	elseif totalItems + maybeItems >= neededcount then
		return AccessibilityLevel.SequenceBreak
	else
		return AccessibilityLevel.None
	end
end
