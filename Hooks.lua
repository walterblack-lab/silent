-- Hooks.lua | Matrix Hub - Debug & Logger
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

        -- Csak akkor figyelünk, ha a játék hív meg valamit (nem a scriptünk)
        if not checkcaller() and method == "FireServer" then
            
            -- Ez a rész "szaglássza" ki a lövéseket
            -- Megnézzük a Remote nevét vagy az adatok típusát
            local isPossibleShot = false
            if self.Name:lower():find("shoot") or self.Name:lower():find("fire") or self.Name:lower():find("bullet") then
                isPossibleShot = true
            end

            -- Ha találtunk valamit, kiírjuk a konzolba (F9)
            if isPossibleShot then
                print("--------------------------------------")
                print("LÖVÉS DETEKTÁLVA!")
                print("Remote neve: " .. self.Name)
                
                -- Végigmegyünk az adatokon, amiket a fegyver küld
                for i, v in pairs(args) do
                    print(string.format("Argumentum [%d] (%s): %s", i, typeof(v), tostring(v)))
                    
                    -- Ha a fegyver egy testrészt küld (pl. "Head" vagy "Torso")
                    if typeof(v) == "Instance" then
                        print("Eltalált objektum neve: " .. v.Name)
                    end
                end
                print("--------------------------------------")
            end

            -- SILENT AIM RÉSZ (Módosítás teszteléshez)
            if _G.SilentAimEnabled and isPossibleShot then
                local Math = getgenv().MathUtils
                local target = Math and Math.GetClosestTarget()
                if target then
                    -- Megpróbáljuk felülírni a Vector3 (pozíció) adatokat
                    for i, v in pairs(args) do
                        if typeof(v) == "Vector3" then
                            args[i] = target.Position
                        end
                    end
                    return oldNamecall(self, unpack(args))
                end
            end
        end

        return oldNamecall(self, ...)
    end)

    setreadonly(mt, true)
    print("Matrix Logger Hooks aktív! Lőj egyet és nézd az F9-et!")
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
