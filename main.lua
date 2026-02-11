-- main.lua
local success, Rayfield = pcall(function() 
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))() 
end)

if not success then warn("Rayfield failed to load") return end

local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"
local buster = "?t=" .. tostring(tick())

-- Biztonságos betöltés
pcall(function() getgenv().Environment = loadstring(game:HttpGet(BaseURL .. "Environment.lua" .. buster))() end)
pcall(function() getgenv().MathUtils = loadstring(game:HttpGet(BaseURL .. "MathUtils.lua" .. buster))() end)
pcall(function() getgenv().Hooks = loadstring(game:HttpGet(BaseURL .. "Hooks.lua" .. buster))() end)

-- Inicializálás
if getgenv().MathUtils then getgenv().MathUtils.InitESP() end
if getgenv().Hooks then getgenv().Hooks.Init() end

local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | STREET LIFE",
    LoadingTitle = "Modular System",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Main")

Tab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = true,
    Callback = function(v) _G.SilentAimEnabled = v end
})

Tab:CreateToggle({
    Name = "Show ESP",
    CurrentValue = true,
    Callback = function(v) _G.HeadESP = v end
})

Tab:CreateButton({
    Name = "Unload",
    Callback = function()
        if getgenv().Environment then getgenv().Environment.Cleanup() end
        Rayfield:Destroy()
    end
})
