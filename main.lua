-- main.lua
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"
local buster = "?t=" .. tostring(tick())

getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua" .. buster))()
getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua" .. buster))()
getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua" .. buster))()

pcall(function()
    if getgenv().MathUtils then getgenv().MathUtils.InitESP() end
    if getgenv().Hooks then getgenv().Hooks.Init() end
end)

local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | STREET LIFE",
    LoadingTitle = "Modular System Loading...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Combat")
local VisualTab = Window:CreateTab("Visuals")
local DebugTab = Window:CreateTab("Debug")
local SettingsTab = Window:CreateTab("Settings")

MainTab:CreateToggle({
    Name = "Silent Aim Enabled",
    CurrentValue = _G.SilentAimEnabled,
    Callback = function(Value) _G.SilentAimEnabled = Value end,
})

MainTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = _G.WallCheck,
    Callback = function(Value) _G.WallCheck = Value end,
})

MainTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 800},
    Increment = 10,
    CurrentValue = _G.FOVRadius,
    Callback = function(Value) _G.FOVRadius = Value end,
})

DebugTab:CreateToggle({
    Name = "Log Remotes",
    CurrentValue = false,
    Callback = function(Value) _getgenv().DebugMode = Value end,
})

VisualTab:CreateToggle({
    Name = "Head ESP",
    CurrentValue = _G.HeadESP,
    Callback = function(Value) _G.HeadESP = Value end,
})

SettingsTab:CreateButton({
    Name = "Unload",
    Callback = function()
        pcall(function()
            if getgenv().Hooks then getgenv().Hooks.Disable() end
            if getgenv().Environment then getgenv().Environment.Cleanup() end
            Rayfield:Destroy()
        end)
    end,
})
