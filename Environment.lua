-- Environment.lua | Matrix Hub Configuration Manager
local Environment = {}

-- 1. GLOBÁLIS BEÁLLÍTÁSOK
_G.SilentAimEnabled = true
_G.FOVRadius = 150
_G.ShowFOV = true
_G.WallCheck = true
_G.HeadChance = 80
_G.HeadESP = true

-- 2. FOV KÖR LÉTREHOZÁSA
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = _G.ShowFOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Radius = _G.FOVRadius
end)

-- 3. TISZTA KILÉPÉS
function Environment.Cleanup()
    FOVCircle:Remove()
    _G.SilentAimEnabled = false
    _G.HeadESP = false
    if getgenv().MathUtils then
        getgenv().MathUtils.ClearESP()
    end
end

return Environment
