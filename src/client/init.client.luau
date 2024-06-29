local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Shared.Libraries.Loader)

Loader:Start({
    script.Controllers
})