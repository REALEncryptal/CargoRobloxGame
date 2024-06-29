local Controller = {}

local Event, TestData

function Controller:PreInit()
    print("Server Controller pre-initialized.")
end

function Controller:Init()
    TestData = shared.Import("TestData")
    Event = shared.Import("Event")

    print("Server Controller initialized.", TestData)
end

function Controller:Update(DeltaTime, Connection)
    Event:FireAllClients("init", "Hello from the server!")
    print("Server Controller updated.", DeltaTime, Connection)
end

return Controller