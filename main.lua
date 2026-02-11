-- main.lua | MATRIX HUB - FINAL STABLE
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

-- 1. MODULOK BETÖLTÉSE
getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua"))()
getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua"))()
getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua"))()

-- 2. RENDSZER INDÍTÁSA (Hibakezeléssel)
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

Rayfield:Notify({
   Title = "Matrix Hub",
   Content = "Script loaded successfully!",
   Duration = 5,
   Image = 4483362458,
})
