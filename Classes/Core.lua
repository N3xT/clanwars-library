Core = {}
Core.__index = Core

function Core:constructor(settings)
    if not settings then
        settings = {}
    end

    settings.type = "core"
    settings.state = "waiting"

    settings.round = 0

    settings.rounds = {}
    settings.players = {}

    print("New core element has been created")

    local coreElement = setmetatable(settings, Core)
    return coreElement
end

function Core:outputMessage(message, element)
    outputChatBox(self.color .. "[" .. self.gamemode:upper() .. "] #FFFFFF" .. message, element or root, 255, 255, 255, true)
end

function Core:getClans()
    if Clan and Clan.createdClans then
        return Clan.createdClans
    end

    return false
end

function Core:getClanBasedOn(variable, based)
    if not variable or not based then
        return false
    end

    local clans = self:getClans()

    if clans then
        for clan in pairs(clans) do
            if clan[based]:lower() == variable:lower() then
                return clan
            end
        end
    end

    return false
end

function Core:getClanByID(id)
    if not id then
        return false
    end

    local clans = self:getClans()

    if clans then
        for clan in pairs(clans) do
            if tonumber(clan.id) == tonumber(id) then
                return clan
            end
        end
    end

    return false
end

function Core:setState(state)
    if self:isValidState(state) and self:getState() ~= state then
        self.state = state
        return true
    end

    return false
end

function Core:getState(state)
    return self.state
end

function Core:isValidState(state)
    if self.states[state] then
        return true
    end

    return false
end

setmetatable(Core, {__call = function(self, ...) return self:constructor(...) end})