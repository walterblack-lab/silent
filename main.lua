-- main.lua | MATRIX HUB - SILENT AIM FIXED
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 1. MODULOK BETÖLTÉSE (Globális táblákba, hogy lássák egymást)
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

-- Először az Environment, mert ebben vannak a beállítások
getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua"))()
-- Másodjára a MathUtils
getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua"))()
-- Utoljára a Hooks
getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua"))()

-- 2. RENDSZER INDÍTÁSA
if MathUtils and Hooks then
    MathUtils.InitESP() 
    Hooks.Init()
else
    warn("Hiba: Modulok nem tolthetok be!")
end

-- 3. UI LÉTREHOZÁSA
local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | SILENT AIM",
    LoadingTitle = "Modular System Loading...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

MainTab:CreateToggle({
    Name = "Silent Aim Enabled",
    CurrentValue = _G.SilentAimEnabled,
    Callback = function(Value) _G.SilentAimEnabled = Value end,
})

MainTab:CreateSlider({
    Name = "Headshot Chance (%)",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = _G.HeadChance,
    Callback = function(Value) _G.HeadChance = Value end,
})

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
        if Hooks then Hooks.Disable() end
        if Environment then Environment.Cleanup() end
        Rayfield:Destroy()
        print("Matrix Hub Unloaded Successfully.")
    end,
})
