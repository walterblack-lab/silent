-- Hooks.lua | Metatable Hooking
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer

local oldIndex
local oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    oldIndex = mt.__index
    oldNamecall = mt.__namecall

    mt.__index = newcclosure(function(self, key)
        if _G.SilentAimEnabled and not checkcaller() then
            if self == LP:GetMouse() and (key == "Hit" or key == "Target") then
                -- Dinamikus lekérés, hogy ne legyen nil hiba
                local Math = getgenv().MathUtils
                if Math and Math.GetClosestTarget then
                    local target = Math.GetClosestTarget()
                    if target then
                        return (key == "Hit" and target.CFrame or target)
                    end
                end
            end
        end
        return oldIndex(self, key)
    end)

    setreadonly(mt, true)
    print("Matrix Hooks Initialized Successfully.")
end

function Hooks.Disable()
    if not oldIndex then return end
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__index = oldIndex
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end

return Hooks
