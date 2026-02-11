-- main.lua | MATRIX HUB - SILENT AIM EDITION
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- MODULOK BETÖLTÉSE (A te GitHub repódból)
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"

local Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua"))()
local MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua"))()
local Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua"))()

-- RENDSZER INDÍTÁSA
MathUtils.InitESP() -- Elindítja a pici piros pöttyöket
Hooks.Init()        -- Aktiválja a Silent Aim-et

-- UI LÉTREHOZÁSA
local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | SILENT AIM",
    LoadingTitle = "Modular System Loading...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- COMBAT BEÁLLÍTÁSOK
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

-- UNLOAD GOMB (A központi vezérlő)
SettingsTab:CreateButton({
    Name = "Destroy Script (Clean Unload)",
    Callback = function()
        -- 1. Hooks visszaállítása
        Hooks.Disable()
        
        -- 2. Vizuális elemek (FOV, ESP) takarítása
        Environment.Cleanup()
        
        -- 3. UI bezárása
        Rayfield:Destroy()
        
        print("Matrix Hub Unloaded Successfully.")
    end,
})
