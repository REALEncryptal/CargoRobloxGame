local EventService = {
    _Connections = {}
}

--[[
    Remote Wrapper

    Encryptal - 2024 Jun 29 
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Shared functions
function EventService:Listen(EventName, Callback)
    self._Connections[EventName] = self._Connections[EventName] or {}

    table.insert(self._Connections[EventName], Callback)
end

-- Scoped functions
if RunService:IsServer() then
    EventService._Remote = Instance.new("RemoteEvent")
    EventService._Remote.Name = "EventService"
    EventService._Remote.Parent = ReplicatedStorage

    function EventService:FireAllClients(...)
        self._Remote:FireAllClients(...)
    end

    function EventService:FireClient(...)
        self._Remote:FireClient(...)
    end

    EventService._Remote.OnServerEvent:Connect(function(Player, EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(Player, ...)
        end
    end)
else
    EventService._Remote = ReplicatedStorage:WaitForChild("EventService")

    function EventService:FireServer(EventName, ...)
        self._Remote:FireServer(EventName, ...)
    end

    EventService._Remote.OnClientEvent:Connect(function(EventName, ...)
        if not EventService._Connections[EventName] then return end

        for _, Callback in ipairs(EventService._Connections[EventName]) do
            Callback(...)
        end
    end)
end

return EventService