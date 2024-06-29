local Controller = {}

local Event, TestData

function Controller:PreInit()
    print("Controller pre-initialized.")
end

function Controller:Init()
    TestData = shared.Import("TestData")
    Event = shared.Import("Event")

    Event:Listen("init", function(...)
        print(...)
    end)

    print("Controller initialized.", TestData)
end

function Controller:Update(DeltaTime, Connection)
    print("Controller updated.", DeltaTime, Connection)
end

return Controller