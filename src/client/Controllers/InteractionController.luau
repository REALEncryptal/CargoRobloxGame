local Controller = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UserInputService = game:GetService("UserInputService")
local Event, Constants, ObjectIndex

function Controller:PreInit()
    Controller.Highlight = ReplicatedStorage.Shared.Assets.Highlight:Clone()
    Controller.Billboard = ReplicatedStorage.Shared.Assets.Billboard:Clone()
end

function Controller:Init()
    Event = shared.Import("Event")
    Constants = shared.Import("Constants")
    ObjectIndex = shared.Import("ObjectIndex")

    Controller.Highlight.Parent = ReplicatedStorage
    Controller.Billboard.Parent = ReplicatedStorage
end

function Controller:Update(DeltaTime, _)
    
end

--

function Controller:GetHoveredModel(): Model?
    local MaxObjectHoverDistance = Constants.MAX_OBJECT_HOVER_DISTANCE

    local Mouse = UserInputService:GetMouse()
    local Camera = workspace.CurrentCamera
    local Ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)

    local Params = RaycastParams.new()
    Params.FilterType = Enum.RaycastFilterType.Blacklist
    Params.FilterDescendantsInstances = {Camera, game.Players.LocalPlayer.Character}
    Params.IgnoreWater = true

    local Hit, Position = workspace:Raycast(Ray.Origin, Ray.Direction * MaxObjectHoverDistance, Params)
    if not Hit then return end

    -- Find if hit part is a descendant of a model
    local Model = Hit.Instance:FindFirstAncestorWhichIsA("Model")
    if not Model then return end

    return Model, Position
end

function Controller:VisualizeHoveredModel(Model)
    if not Model then Model = ReplicatedStorage end

    -- Keep like this to support updating stats in the future?
    if Controller.LastHoveredModel ~= Model then
        Controller.LastHoveredModel = Model

        Controller.Highlight.Parent = Model
        Controller.Billboard.Parent = Model
        Controller.Billboard.Adornee = Model

        if Controller == ReplicatedStorage then return end
        Controller.Billboard.ObjectName.Text = ObjectIndex[Model.Name]
    end
end

--

return Controller