-- main.lua | MATRIX HUB - STREET LIFE EDITION (FINAL STABLE)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

-- 1. MODULOK BETÖLTÉSE (Kényszerített frissítéssel a cache elkerülése érdekében)
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
    LoadingTitle = "Modular System Loading...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- COMBAT BEÁLLÍTÁSOK
MainTab:CreateToggle({
    Name = "Silent Aim Enabled",
    CurrentValue = _G.SilentAimEnabled,
    Callback = function(Value) _G.SilentAimEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Wall Check (Safety)",
    CurrentValue = _G.WallCheck,
    Description = "Ha kikapcsolod, falon keresztül is lő.",
    Callback = function(Value) _G.WallCheck = Value end,
})

MainTab:CreateSlider({
    Name = "Headshot Chance (%)",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = _G.HeadChance,
    Callback = function(Value) _G.HeadChance = Value end,
})

MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 800},
    Increment = 10,
    CurrentValue = _G.FOVRadius,
    Callback = function(Value) _G.FOVRadius = Value end,
})

-- VISUALS BEÁLLÍTÁSOK
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

-- SETTINGS / UNLOAD
SettingsTab:CreateButton({
    Name = "Destroy Script (Clean Unload)",
    Callback = function()
        if getgenv().Hooks then getgenv().Hooks.Disable() end
        if getgenv().Environment then getgenv().Environment.Cleanup() end
        Rayfield:Destroy()
        print("Matrix Hub Unloaded Successfully.")
    end,
})

-- BETÖLTÉSI ÉRTESÍTÉS
Rayfield:Notify({
   Title = "Matrix Hub Loaded",
   Content = "Üdvözöllek! A Silent Aim és az ESP készen áll.",
   Duration = 5,
   Image = 4483362458,
})
