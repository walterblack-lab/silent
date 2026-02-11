-- Hooks.lua | Matrix Hub - Universal & Street Life Remote Hook
local Hooks = {}
local LP = game:GetService("Players").LocalPlayer
local oldNamecall
local oldIndex

function Hooks.Init()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    
    oldNamecall = mt.__namecall
    oldIndex = mt.__index

    -- 1. INDEX HOOK (Egér pozíció eltérítése)
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

    -- 2. NAMECALL HOOK (RemoteEvents & Raycast)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if _G.SilentAimEnabled and not checkcaller() then
            -- REMOTE EVENT HOOK (A fegyverek szerver üzenetei)
            if method == "FireServer" then
                -- Debug: Naplózzuk a remote nevét, ha be van kapcsolva
                if _G.DebugMode then 
                    print("Remote Called: " .. self.Name) 
                end

                -- Ha a Remote neve utal a lövésre (gyakori nevek: Bullet, Shoot, Fire, RemoteEvent)
                if self.Name:lower():find("shoot") or self.Name:lower():find("bullet") or self.Name:lower():
