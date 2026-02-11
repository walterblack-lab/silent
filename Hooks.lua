-- Hooks.lua | Matrix Hub - Universal & Street Life Fix
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
            -- 1. REMOTE HOOK (Street Life fegyverekhez)
            if method == "FireServer" and (self.Name:lower():find("shoot") or self.Name:lower():find("fire")) then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                if target then
                    -- Megkeressük a pozíciót az argumentumok között és felülírjuk
                    for i, v in pairs(args) do
                        if typeof(v) == "Vector3" then
                            args[i] = target.Position
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end

            -- 2. RAYCAST HOOK (Általános védelem)
            if method == "Raycast" or method == "FindPartOnRayWithIgnoreList" then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                if target then
                    local origin = (method == "Raycast" and args[1] or args[1].Origin)
                    local direction = (target.Position - origin).Unit * 1000
                    if method == "Raycast" then args[2] = direction else args[1] = Ray.new(origin, direction) end
                    return oldNamecall(self, unpack(args))
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end

function Hooks.Disable()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    mt.__namecall = oldNamecall
    setreadonly(mt, true)
end

return Hooks
