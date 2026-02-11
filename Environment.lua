-- Environment.lua | Matrix Hub Configuration Manager
local Environment = {}

-- 1. GLOBÁLIS BEÁLLÍTÁSOK (Alapértelmezett értékek)
-- Ezeket fogja a UI módosítani, és a MathUtils/Hooks használni
_G.SilentAimEnabled = true  -- Silent Aim főkapcsoló
_G.FOVRadius = 150         -- A célzási kör sugara
_G.ShowFOV = true          -- Látszódjon-e a kör a képernyőn
_G.WallCheck = true        -- Ne lőjön falon át (biztonságos mód)
_G.HeadChance = 80         -- 80% eséllyel fejre, 20% testre céloz
_G.HeadESP = true          -- A pici piros pötty a fejeken

-- 2. FOV KÖR LÉTREHOZÁSA (Vizuális visszajelzés)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = _G.ShowFOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255) -- Fehér
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64 -- Szép kerek legyen
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

-- 3. FOLYAMATOS FRISSÍTÉS (Képkockánként)
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer

RunService.RenderStepped:Connect(function()
    -- Kör pozíciójának frissítése az egérhez
    FOVCircle.Position = Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)
    
    -- Vizuális szinkronizáció a beállításokkal
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOVRadius
end)

-- 4. TISZTA KILÉPÉS (Ha leállítod a scriptet)
function Environment.Cleanup()
    FOVCircle:Remove()
    _G.SilentAimEnabled = false
    _G.HeadESP = false
end

return Environment
