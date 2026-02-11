-- Hooks.lua | Metatable Hooking
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer
local oldIndex, oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldIndex = mt.__index
    oldNamecall = mt.__namecall

    mt.__index = newcclosure(function(self, key)
        if _G.SilentAimEnabled and not checkcaller() then
            if self == LP:GetMouse() and (key == "Hit" or key == "Target") then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                if target then
                    return (key == "Hit" and target.CFrame or target)
                end
            end
        end
        return oldIndex(self, key)
    end)

    setreadonly(mt, true)
    print("Matrix Hooks Applied.")
end

function Hooks.Disable()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__index = oldIndex
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
    print("Matrix Hooks Disabled.")
end

return Hooks
