-- Hooks.lua | Matrix Hub - Debug Spy
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer
local oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    if not mt then warn("Metatable nem elérhető!") return end
    
    setreadonly(mt, false)
    oldNamecall = mt.__namecall

    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if not checkcaller() and method == "FireServer" then
            -- Megnézzük, lövés-e
            local n = self.Name:lower()
            if n:find("shoot") or n:find("fire") or n:find("bullet") or n:find("hit") then
                print(">>> LÖVÉS DETEKTÁLVA: " .. self.Name)
                for i, v in pairs(args) do
                    print(string.format("Arg[%d]: %s (%s)", i, tostring(v), typeof(v)))
                end

                if _G.SilentAimEnabled then
                    local Math = getgenv().MathUtils
                    local target = Math and Math.GetClosestTarget()
                    if target then
                        -- Koordináta hamisítás
                        for i, v in pairs(args) do
                            if typeof(v) == "Vector3" then args[i] = target.Position end
                        end
                        return oldNamecall(self, unpack(args))
                    end
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
