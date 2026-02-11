-- main.lua | MATRIX HUB - DEBUG & REMOTE TEST VERSION
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

-- 1. MODULOK BETÖLTÉSE (Kényszerített frissítéssel)
local buster = "?t=" .. tostring(tick())
getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua" .. buster))()
getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua" .. buster))()
getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua" .. buster))()

-- 2. RENDSZER INDÍTÁSA
pcall(function()
    if getgenv().MathUtils then getgenv().MathUtils.InitESP() end
    if getgenv().Hooks then getgenv().Hooks.Init() end
end)

-- 3. UI LÉTREHOZÁSA
local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | STREET LIFE",
    LoadingTitle = "Debug Mode Active...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local DebugTab = Window:CreateTab("Debug", 4483362458) -- ÚJ DEBUG TAB
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- GLOBÁLIS DEBUG VÁLTOZÓ
_G.DebugMode = false

-- COMBAT BEÁLLÍTÁSOK
MainTab:CreateToggle({
    Name = "Silent Aim Enabled",
    CurrentValue = _G.SilentAimEnabled,
    Callback = function(Value) _G.SilentAimEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Wall Check (Safety)",
    CurrentValue = _G.WallCheck,
    Callback = function(Value) _G.WallCheck = Value end,
})

MainTab:CreateSlider({
    Name = "Headshot Chance (%)",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = _G.HeadChance,
    Callback = function(Value) _G.HeadChance = Value end,
})

-- DEBUG TAB (Teszteléshez)
DebugTab:CreateToggle({
    Name = "Log Shooting Remotes",
    CurrentValue = _G.DebugMode,
    Callback = function(Value) 
        _G.DebugMode = Value 
        Rayfield:Notify({
            Title = "Debug Mode",
            Content = Value and "Mostantól látod a lövés naplózását a konzolban (F9)!" or "Debug kikapcsolva.",
            Duration = 3
        })
    end,
})

DebugTab:CreateButton({
    Name = "Test MathUtils Logic",
    Callback = function()
        local target = getgenv().MathUtils.GetClosestTarget()
        if target then
            Rayfield:Notify({
                Title = "Math Test",
                Content = "Célpont megtalálva: " .. target.Parent.Name,
                Duration = 3
            })
        else
            Rayfield:Notify({
                Title = "Math Test",
                Content = "Nincs senki a FOV körön belül!",
                Duration = 3
            })
        end
    end,
})

-- VISUALS ÉS SETTINGS (Marad a régi, de az Unload fixálva)
VisualTab:CreateToggle({
    Name = "Head ESP (Red Dot)",
    CurrentValue = _G.HeadESP,
    Callback = function(Value) _G.HeadESP = Value end,
})

VisualTab:CreateToggle({
    Name = "Show FOV Circle",
    CurrentValue = _G.ShowFOV,
    Callback = function(Value) _G.ShowFOV = Value end,
})

SettingsTab:CreateButton({
    Name = "Destroy Script (Clean Unload)",
    Callback = function()
        pcall(function()
            if getgenv().Hooks then getgenv().Hooks.Disable() end
            if getgenv().Environment then getgenv().Environment.Cleanup() end
            Rayfield:Destroy()
        end)
    end,
})

Rayfield:Notify({
   Title = "Matrix Hub",
   Content = "Debug verzió betöltve!",
   Duration = 5
})
