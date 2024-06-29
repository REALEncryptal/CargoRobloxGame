local Controller = {}

local Event, ActionIndex, ObjectIndex

function Controller:PreInit()
    Controller.PendingActions = {}
end

function Controller:Init()
    Event = shared.Import "Event"
    ActionIndex = shared.Import "ActionIndex"
    ObjectIndex = shared.Import "ObjectIndex"

    Event:Listen("ActionCancelled", Controller._ActionCancelled)
    Event:Listen("ActionStart", Controller._StartAction)
end

function Controller:Update(DeltaTime, Connection)
    local CurrentTick = tick()

    for Object, PendingAction in pairs(Controller.PendingActions) do
        if PendingAction.Completed then continue end

        local EndTick = PendingAction.EndTick
        local Complete = CurrentTick >= EndTick
        local Player = PendingAction.Player

        if not Complete then continue end

        Controller.PendingActions[Object].Completed = true
        Controller:_CallActionSignal("Triggered", Player, Object, PendingAction.ActionName)
    end
end

--

function Controller._ActionCancelled(Player, Object, ActionName)
    local PendingAction = Controller.PendingActions[Object]
    if not PendingAction then return end

    if PendingAction.Completed then
        Controller:_CallActionSignal("TriggerEnded", Player, Object, ActionName)
    end

    Controller:_CallActionSignal("HoldEnded", Player, Object, ActionName)

    -- Remove the pending action
    Controller.PendingActions[Object] = nil
end

function Controller._StartAction(Player, Object, ActionName)
    local ActionData = ActionIndex[ActionName]
    if not ActionData then return end

    -- Validate the action
    if not ActionData.Validate(Player, Object) then
        warn("Server action failed")
        Event:FireClient(Player, "ActionFailed", Object)
        return
    end

    local HoldDuration = ActionData.HoldDuration
    local EndTick = tick() + HoldDuration

    local PendingAction = {
        Player = Player,
        EndTick = EndTick,
        Completed = false,
        ActionName = ActionName
    }

    Controller.PendingActions[Object] = PendingAction
    Controller:_CallActionSignal("HoldBegan", Player, Object, ActionName)
end
--

function Controller:_CallActionSignal(SignalName, Player, Object, ActionName)
    local ActionData = ActionIndex[ActionName]

    -- TODO: Errors here should be handled better
    local Callback = ActionData.Server[SignalName]
    if Callback then
        Callback(Player, Object)
    end

    Event:FireClient(Player, "ActionSignal", SignalName, Object, ActionName)
end

--

return Controller