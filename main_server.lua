local clanwar = {}

clanwar.core = Core({
    gamemode            = "WFF",
    color               = "#FF8900",
    groups              = {"Admin", "Moderator"},

    states = {
        ["live"]        = "#22B962",
        ["starting"]    = "#0F64C5",
        ["waiting"]     = "#FF8900",
        ["paused"]      = "#FF8900",
        ["ended"]       = "#FF0000"
    },
})

clanwar.home = Clan({
    name                = "Force out Xtreme",
    tag                 = "FoXX",
    color               = "#FF8900",

    playing             = true
})

clanwar.enemy = Clan({
    name                = "Seventh Miracle",
    tag                 = "7m",
    color               = "#AA0022",

    playing             = true
})

clanwar.spectators = Clan({
    name                = "Spectators",
    tag                 = "spec",
    color               = "#FFFFFF",

    kill                = true
})

clanwar.referees = Clan({
    name                = "Referees",
    tag                 = "ref",
    color               = "#FF0000",

    locked              = true,
    kill                = true
})

clanwar.commands        = {}

clanwar.commands["setPlayerClan"] = function(player, command, id)
    local clan = clanwar.core:getClanByID(id) or clanwar.core:getClanBasedOn(id, "tag")

    if not id or not clan then
        return clanwar.core:outputMessage("Wrong syntax! /" .. command .. " [clan tag or id]", player)
    end

    if clan.locked then
        return
    end

    if not player:setClan(clan) then
        return
    end

    clanwar.core:outputMessage(player:getName() .. " #FFFFFFjoined " .. clan:getName())
end

clanwar.commands["setClanName"] = function(player, command, id, ...)
    if not player:hasRights(clanwar.core.groups) then
        return clanwar.core:outputMessage("Access denied", player)
    end

    local clan = clanwar.core:getClanByID(id) or clanwar.core:getClanBasedOn(id, "tag")
    local string = table.concat({...} , " ")

    if not id or not clan or #string == 0 then
        return clanwar.core:outputMessage("Wrong syntax! /" .. command .. " [clan tag or id] [new name]", player)
    end

    local oldName = clan:getName()

    if not clan:setName(string) then
        return
    end

    clanwar.core:outputMessage(player:getName() .. " #FFFFFFchanged " .. oldName .. " #FFFFFFname to " .. clan:getName())
end

clanwar.commands["setClanTag"] = function(player, command, id, ...)
    if not player:hasRights(clanwar.core.groups) then
        return clanwar.core:outputMessage("Access denied", player)
    end

    local clan = clanwar.core:getClanByID(id) or clanwar.core:getClanBasedOn(id, "tag")
    local string = table.concat({...} , " ")

    if not id or not clan or #string == 0 then
        return clanwar.core:outputMessage("Wrong syntax! /" .. command .. " [clan tag or id] [new tag]", player)
    end

    if not clan:setTag(string) then
        return
    end

    clanwar.core:outputMessage(player:getName() .. " #FFFFFFchanged " .. clan:getName() .. " #FFFFFFtag to " .. clan:getColor() .. string)
end

clanwar.commands["setClanColor"] = function(player, command, id, hex)
    if not player:hasRights(clanwar.core.groups) then
        return clanwar.core:outputMessage("Access denied", player)
    end

    local clan = clanwar.core:getClanByID(id) or clanwar.core:getClanBasedOn(id, "tag")

    if not id or not hex or not isHexColor(hex) then
        return clanwar.core:outputMessage("Wrong syntax! /" .. command .. " [clan tag or id] [#hex]", player)
    end

    local oldHex = clan:getColor()

    if not clan:setColor(hex) then
        return
    end

    clanwar.core:outputMessage(player:getName() .. " #FFFFFFchanged " .. oldHex .. clan:getName() .. " #FFFFFFcolor to " .. clan:getName())
end

addEventHandler("onResourceStart", resourceRoot,
    function()        
        for _, player in pairs(Element.getAllByType("player")) do
            local core = clanwar.core
            local referee = player:hasRights(core.groups)

            player:setClan(referee and clanwar.referees or clanwar.spectators)
        end
    end
)

addEventHandler("onPlayerJoin", root,
    function()
        source:setClan(clanwar.spectators)
    end
)

addEventHandler("onPlayerQuit", root,
	function(quitType)
        local clan = source:getClan()
        
		if clan == clanwar.home or clan == clanwar.enemy then
			clanwar.referees:outputMessage(source:getName() .. " #FFFFFFleft the game #FF8900(" .. quitType .. ")")
		end
	end
)

addEventHandler("onPlayerLogin", root,
    function()
        if not source:hasRights(clanwar.core.groups) then
            return false
        end

        local clan = source:getClan()

        if clan == clanwar.home or clan == clanwar.enemy then
            return
        end

        source:setClan(clanwar.referees)
        clanwar.referees:outputMessage(source:getName() .. " #FFFFFFjoined " .. clanwar.referees:getName())
    end
)

addEventHandler("onPlayerLogout", root,
    function()
        if source:getClan() == clanwar.referees then
            source:setClan(clanwar.spectators)
            clanwar.referees:outputMessage(source:getName() .. " #FFFFFFlogged out")
        end
    end
)
