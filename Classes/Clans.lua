Clan = {}
Clan.__index = Clan

Clan.clansCount = 0
Clan.createdClans = {}

function Clan:constructor(settings)    
    Clan.clansCount = Clan.clansCount + 1

    local r, g, b = hex2rgb(settings.color)

    settings.team = Team(settings.name, r, g, b)
    settings.type = "clan"
    settings.points = 0
    settings.id = Clan.clansCount
    
    if settings.playing then
        settings.team:setData("tag", settings.tag)
        settings.team:setData("points", 0)
    end

    local clanElement = setmetatable(settings, Clan)
    Clan.createdClans[clanElement] = true

    print("New clan has been created", settings.name, settings.tag, settings.color, settings.id)

    return clanElement
end

function Clan:setName(name)
    local team = self.team

    if isElement(team) and name and name ~= self:getName() and #name > 0 then
        return team:setName(name)
    end

    return false
end

function Clan:getName()
    local team = self.team

    if isElement(team) then
        return team:getName(), self:getColor() .. team:getName()
    end

    return false
end

function Clan:setTag(tag)
    local team = self.team

    if isElement(team) then
        if tag and tag ~= self:getTag() and #tag > 0 then
            self.tag = tag
            team:setData("tag", tag)
            return true
        end
    end

    return false
end

function Clan:getTag()
    return self.tag, self:getColor() .. self.tag
end

function Clan:setColor(color)
    local team = self.team

    if isElement(team) and color and color ~= self:getColor() and #color > 0 then
        local r, g, b = hex2rgb(color)
        return team:setColor(r, g, b)
    end

    return false
end

function Clan:getColor()
    local team = self.team

    if isElement(team) then
        local r, g, b = team:getColor()
        return rgb2hex(r, g, b), r, g, b
    end

    return false
end

function Clan:setPoints(points)
    points = tonumber(points)

    if points and type(points) == "number" and points >= 0 and points ~= self:getPoints() then
        local team = self.team

        self.points = points
        team:setData("points", points)
        
        return true
    end

    return false
end

function Clan:addPoint(points)
    local points = points or 1
    return self:setPoints(self:getPoints() + points)
end

function Clan:takePoint()
    local points = points or 1
    return self:setPoints(self:getPoints() - points)
end

function Clan:getPoints()
    return self.points or 0
end

function Clan:getPlayers()
    local team = self.team

    if isElement(team) then
        return team:getPlayers()
    end

    return false
end

function Clan:getAlivePlayers()
    local team = self.team

    if isElement(team) then
        local players = {}

        for _, player in pairs(team:getPlayers()) do
            if player:getData("state") == "alive" then
                table.insert(players, player)
            end
        end
    end

    return players
end

function Clan:outputMessage(text)
    local players = self:getPlayers()

    if not players then
        return false
    end

    for _, player in pairs(players) do
        outputChatBox(text, player, 255, 255, 255, true)
    end

    return true
end

setmetatable(Clan, {__call = function(self, ...) return self:constructor(...) end})