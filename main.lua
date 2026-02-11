-- main.lua | MATRIX HUB - STREET LIFE (ULTRA STABLE)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local BaseURL = "https://raw.githubusercontent.com/walterblack-lab/silent/main/"
local buster = "?t=" .. tostring(tick())

-- 1. WINDOW LÉTREHOZÁSA ELŐRE
local Window = Rayfield:CreateWindow({
    Name = "MATRIX HUB | STREET LIFE",
    LoadingTitle = "Rendszer ellenőrzése...",
    ConfigurationSaving = { Enabled = false }
})

local Tab = Window:CreateTab("Beállítások")

-- 2. MODULOK BETÖLTÉSE (Hibakezeléssel)
local function SafeLoad(name)
    local success, mod = pcall(function()
        return loadstring(game:HttpGet(BaseURL .. name .. ".lua" .. buster))()
    end)
    if success then return mod else warn("Hiba betöltéskor: " .. name) return nil end
end

getgenv().Environment = SafeLoad("Environment")
getgenv().MathUtils = SafeLoad("MathUtils")
getgenv().Hooks = SafeLoad("Hooks")

-- 3. INDÍTÁS
pcall(function()
    if getgenv().MathUtils then getgenv().MathUtils.InitESP() end
    if getgenv().Hooks then getgenv().Hooks.Init() end
end)

-- 4. UI ELEMEK
Tab:CreateToggle({
    Name = "Silent Aim (F9 Log aktív)",
    CurrentValue = true,
    Callback = function(v) _G.SilentAimEnabled = v end
})

Tab:CreateToggle({
    Name = "ESP Megjelenítése",
    CurrentValue = true,
    Callback = function(v) _G.HeadESP = v end
})

Tab:CreateSlider({
    Name = "FOV Méret",
    Range = {50, 600},
    Increment = 10,
    CurrentValue = 150,
    Callback = function(v) _G.FOVRadius = v end
})

Tab:CreateButton({
    Name = "Szkript Leállítása",
    Callback = function()
        pcall(function()
            if getgenv().Hooks then getgenv().Hooks.Disable() end
            if getgenv().Environment then getgenv().Environment.Cleanup() end
            if getgenv().MathUtils then getgenv().MathUtils.ClearESP() end
            Rayfield:Destroy()
        end)
    end
})

Rayfield:Notify({Title = "Matrix Hub", Content = "Minden kész! Ha nincs menü, nézd az F9-et!", Duration = 5})
