-- Environment.lua
local Environment = {}

_G.SilentAimEnabled = false
_G.FOVRadius = 150
_G.ShowFOV = true
_G.WallCheck = false -- Alapból lőjön falon át teszt miatt
_G.HeadChance = 100
_G.HeadESP = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.Radius = _G.FOVRadius

local conn = game:GetService("RunService").RenderStepped:Connect(function()
    if FOVCircle then
        FOVCircle.Position = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, game:GetService("Players").LocalPlayer:GetMouse().Y)
        FOVCircle.Visible = _G.ShowFOV
        FOVCircle.Radius = _G.FOVRadius
    end
end)

function Environment.Cleanup()
    pcall(function()
        conn:Disconnect()
        FOVCircle:Remove()
    end)
    if getgenv().MathUtils then getgenv().MathUtils.ClearESP() end
end

return Environment
