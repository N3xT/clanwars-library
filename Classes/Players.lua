PlayersData = {}

function Player:setClan(element)
    if isElement(element) and element.type == "team" then
        self.clan = element
        self:assignData()

        local vehicle = self:getOccupiedVehicle()
        
        if isElement(vehicle) then
            local r, g, b = element:getColor()
            vehicle:setColor(r, g, b, r, g, b)
        end  

        return self:setTeam(element)
    elseif type(element) == "table" and isElement(element.team) and element.team.type == "team" then
        self.clan = element
        self:assignData()

        if element.kill and self:getData("state") == "alive" then
            self:setHealth(0)
        end

        local vehicle = self:getOccupiedVehicle()

        if isElement(vehicle) then
            local r, g, b = element.team:getColor()
            vehicle:setColor(r, g, b, r, g, b)
        end  

        return self:setTeam(element.team)        
    end   

    return false
end

function Player:getClan()
    local clan = self.clan

    if not clan then
        return false
    end

    local team = clan.team

    if isElement(team) then
        return clan
    end

    return false
end

function Player:removeClan()
    self.clan = nil
    return self:setTeam(nil)
end

function Player:setPoints(points)
    points = tonumber(points)

    if points and type(points) == "number" and points >= 0 then        
        self:setData("points", points)

        local serial = self:getSerial()

        if PlayersData[serial] then
            PlayersData[serial].points = points
        end

        return true
    end

    return false
end

function Player:addPoint(points)
    local serial = self:getSerial()
    local clan = self:getClan()
    local points = points or 1

    if clan then
        clan:addPoint(points)
    end

    return self:setPoints(self:getPoints() + points)
end

function Player:takePoint(points)
    local serial = self:getSerial()
    local clan = self:getClan()
    local points = points or 1

    if clan then
        clan:takePoint(points)
    end

    return self:setPoints(self:getPoints() - points)
end

function Player:getPoints()
    local serial = self:getSerial()
    return (PlayersData[serial] and tonumber(PlayersData[serial].points)) or 0
end

function Player:hasRights(groups)
    local account = self:getAccount()
    
    if account then
        accountName = account:getName()
        for _, group in ipairs(groups) do
            local group = ACLGroup.get(group)
            if group then
                if group:doesContainObject("user." .. accountName) then
                    return true
                end
            end
        end
    end

    return false
end

function Player:getName()
	return getPlayerName(self)
end

function Player:assignData()
    local clan = self:getClan()

    if not clan or not clan.playing then
        return false
    end

    local serial = self:getSerial()

    if PlayersData[serial] then
        return true
    end

    PlayersData[serial] = {
        points      = 0,
        nickname    = self:getName()
    }
end

-- Events

addEventHandler("onPlayerJoin", root, 
    function()
        local points = source:getPoints()
        source:setPoints(points)
    end
)

addEventHandler("onResourceStart", resourceRoot,
    function()
        for _, player in pairs(Element.getAllByType("player")) do
            player:assignData()
            player:setPoints(0)
        end
    end
)

addEventHandler("onPlayerChangeNick", root,
    function(_, nickname)
        local serial = source:getSerial()

        if PlayersData[serial] then
            PlayersData[serial].nickname = nickname
        end
    end
)