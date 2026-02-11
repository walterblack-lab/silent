-- Hooks.lua | Matrix Hub
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer
local oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if _G.SilentAimEnabled and not checkcaller() then
            if method == "FireServer" or method == "Raycast" then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                if target then
                    if method == "FireServer" then
                        for i, v in pairs(args) do
                            if typeof(v) == "Vector3" then args[i] = target.Position end
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

function Hooks.Disable()
    if oldNamecall then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        mt.__namecall = oldNamecall
        setreadonly(mt, true)
    end
end

return Hooks
