-- Hooks.lua | Metatable Hooking for Silent Aim
local Hooks = {}
local MathUtils = require(script.Parent.MathUtils) -- Beimportáljuk a matekot
local LP = game:GetService("Players").LocalPlayer

-- Eredeti funkciók mentése (hogy vissza tudjuk állítani unloadnál)
local oldIndex
local oldNamecall

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false) -- Írhatóvá tesszük a metatablét
    
    oldIndex = mt.__index
    oldNamecall = mt.__namecall

    -- 1. __INDEX HOOK (Pl. Mouse.Hit lekérésekor)
    mt.__index = newcclosure(function(self, key)
        -- Ellenőrizzük, hogy a játék kéri-e az egeret és aktív-e a script
        if _G.SilentAimEnabled and not checkcaller() then
            if self == LP:GetMouse() and (key == "Hit" or key == "Target") then
                local target = MathUtils.GetClosestTarget()
                if target then
                    return (key == "Hit" and target.CFrame or target)
                end
            end
        end
        return oldIndex(self, key)
    end)

    -- 2. __NAMECALL HOOK (Távolsági lövésekhez és Remote-okhoz)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if _G.SilentAimEnabled and not checkcaller() then
            -- Ha a játék Raycast-ot hív az egér irányába
            if method == "FindPartOnRayWithIgnoreList" or method == "Raycast" then
                local target = MathUtils.GetClosestTarget()
                if target then
                    -- Itt módosíthatnánk a lövés irányát a szerver felé
                end
            end
        end
        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    print("Hooks successfully applied.")
end

-- 3. UNLOAD FUNKCIÓ (Mindent visszaállít eredetire)
function Hooks.Disable()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    mt.__index = oldIndex
    mt.__namecall = oldNamecall
    
    setreadonly(mt, true)
    print("Hooks successfully removed.")
end

return Hooks
