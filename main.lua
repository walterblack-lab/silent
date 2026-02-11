-- main.lua | MATRIX HUB - FINAL FIXED
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

-- MODULOK BETÖLTÉSE
getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua"))()
getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua"))()
getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua"))()

-- RENDSZER INDÍTÁSA
if getgenv().MathUtils and getgenv().Hooks then
    getgenv().MathUtils.InitESP() 
    getgenv().Hooks.Init()
end

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
        if getgenv().Hooks then getgenv().Hooks.Disable() end
        if getgenv().Environment then getgenv().Environment.Cleanup() end
        Rayfield:Destroy()
    end,
})
