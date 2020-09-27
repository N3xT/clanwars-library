function isHexColor(hex)
    return nil ~= hex:find("^#%x%x%x%x%x%x$")
end

function hex2rgb(hex)
    hex = hex:gsub("#", "") 
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function rgb2hex(r, g, b) 
    return string.format("#%02X%02X%02X", r, g, b) 
end 

function ordinal_numbers(n)
    local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
    if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= 11 and string.sub(n,-2) ~= 12 and string.sub(n,-2) ~= 13 then
        return n .. ordinal[tonumber(digit)]
    else
        return n .. "th"
    end
end

function getPlayerFromPartialName(name)
    if not name then
        return false
    end
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
    return false
end

_getPlayerName = getPlayerName
function getPlayerName(player)
    if not isElement(player) then
        return false
    end

	local name = _getPlayerName(player)
    local team = getPlayerTeam(player)
    
	if team then
		local r, g, b = getTeamColor(team)
		name = rgb2hex(r, g, b) .. name
    end
    
	return name
end