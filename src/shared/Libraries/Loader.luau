local Loader = {}

--[[
    Simple Module loader and initializer

    Encryptal - 2024 Jun 29
]]

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Librarian = require(script.Parent.Librarian)

function Loader:Start(Paths)
    local PathModules = {}

    -- Get all modules from all paths
    for i, Path in ipairs(Paths) do
        PathModules[i] = self:_GetModules(Path)
    end

    -- Initialize the Librarian
    Librarian:Init({
        ReplicatedStorage.Shared,
        unpack(Paths)
    })

    -- If available, run the PreInit function of each module
    Loader:_RunFunctions(PathModules, "PreInit")

    -- If available, run the Init function of each module
    Loader:_RunFunctions(PathModules, "Init")

    -- If the module has a update function, bind it to the render step
    for _, Modules in ipairs(PathModules) do
        for _, Module in pairs(Modules) do
            if not Module.Update then return end
            
            -- Pass the connection to the update function so it can be disconnected
            if RunService:IsClient() then
                local Connection Connection = RunService.RenderStepped:Connect(function(DeltaTime)
                    Module:Update(DeltaTime, Connection)
                end)
            else
                local Connection Connection = RunService.Heartbeat:Connect(function(DeltaTime)
                    Module:Update(DeltaTime, Connection)
                end)
            end
        end
    end

    print("Loader has finished loading modules.")
end

function Loader:_GetModules(Path)
    local Modules = {}

    for _, Module in ipairs(Path:GetChildren()) do
        if Module:IsA("ModuleScript") then
            Modules[Module.Name] = require(Module)
        end
    end

    return Modules
end

function Loader:_RunFunctions(PathModules, Function)
    for _, Modules in ipairs(PathModules) do
        for _, Module in pairs(Modules) do
            if not Module[Function] then return end

            task.spawn(Module[Function])

            print("Ran function:", Function, "for module:", Module.Name)
        end
    end
end

return Loader