
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
        if v == "final" then
            local result = final()
            if result == 6 and tonumber(AccessibilityLevel.Normal) > tonumber(max) then
                return AccessibilityLevel.Normal
            elseif result == 5 and tonumber(AccessibilityLevel.SequenceBreak) > tonumber(max) then
                max = AccessibilityLevel.SequenceBreak
            elseif result == 0 and tonumber(AccessibilityLevel.None) > tonumber(max) then
                max = AccessibilityLevel.None
            end
        else
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

function has_req(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	local amount = tonumber(amount)
	if not amount then
        return count
	elseif count >= amount then
        return 1
	end
    return 0
end

function any(...)
    local args = { ... }
    local wrapped_args = {}

    for i, v in ipairs(args) do
        if v == "final" then
            table.insert(wrapped_args, v)  -- Pass "final" directly to has_any
        else
            table.insert(wrapped_args, has(v))
        end
    end

    return has_any(table.unpack(wrapped_args))
end


function multiple(neededcount, ...)
    local args = { ... }
    neededcount = tonumber(neededcount)
    
    local totalItems = 0
	local maybeItems = 0

    for i, item in ipairs(args) do
            if item ~= "final" then
				if string.find(item, ":") then
					local A, B = item:match("([^:]+):([^:]+)")
					totalItems = totalItems + has_req(A, B)
				else
					totalItems = totalItems + has_req(item)
				end
			elseif item == "final" then
				local func = _G[item]
				if type(func) == "function" then
					local result = func()
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
