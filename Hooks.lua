-- Hooks.lua | Matrix Hub - Universal & Wall-Penetration
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer
local oldIndex, oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    oldIndex = mt.__index
    oldNamecall = mt.__namecall

    -- 1. EGÉR HOOK (Minden fegyverhez, ami Mouse.Hit-et használ)
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

    -- 2. RAYCAST HOOK (Minden modern fegyverhez és fali átlövéshez)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if _G.SilentAimEnabled and not checkcaller() then
            if method == "FindPartOnRayWithIgnoreList" or method == "Raycast" or method == "FindPartOnRay" then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                
                if target then
                    local origin = (method == "Raycast" and args[1] or args[1].Origin)
                    local direction = (target.Position - origin).Unit * 1000
                    
                    if method == "Raycast" then
                        args[2] = direction
                    else
                        args[1] = Ray.new(origin, direction)
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    print("Matrix Universal & Wall-Penetration Hooks Applied.")
end

function Hooks.Disable()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__index = oldIndex
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end

return Hooks
