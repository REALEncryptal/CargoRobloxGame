return {
    KeyCode = Enum.KeyCode.E,
    HoldDuration = 0.2,

    Validate = function(...)
        return true
    end,
    
    Server = {
        Triggered = function(Player, Object)
            print("Server Triggered", Player, Object)
        end,
        TriggerEnded = function(Player, Object)
            print("Server Trigger Ended", Player, Object)
        end,
        HoldBegan = function(Player, Object)
            print("Server Hold Began", Player, Object)
        end,
        HoldEnded = function(Player, Object)
            print("Server Hold Ended", Player, Object)
        end,
    },
    Client = {
        Triggered = function(Object)
            print("Client Triggered", Object)
        end,
        TriggerEnded = function(Object)
            print("Client Trigger Ended", Object)
        end,
        HoldBegan = function(Object)
            print("Client Hold Began", Object)
        end,
        HoldEnded = function(Object)
            print("Client Hold Ended", Object)
        end,
    },
}