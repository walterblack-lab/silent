-- Environment.lua | Matrix Hub - Fixed Cleanup
local Environment = {}

_G.SilentAimEnabled = true
_G.FOVRadius = 150
_G.ShowFOV = true
_G.WallCheck = true
_G.HeadChance = 80
_G.HeadESP = true

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = _G.ShowFOV
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = _G.FOVRadius
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

game:GetService("RunService").RenderStepped:Connect(function()
    if FOVCircle and pcall(function() return FOVCircle.Visible end) then
        FOVCircle.Position = Vector2.new(game:GetService("Players").LocalPlayer:GetMouse().X, game:GetService("Players").LocalPlayer:GetMouse().Y)
        FOVCircle.Visible = _G.ShowFOV
        FOVCircle.Radius = _G.FOVRadius
    end
end)

function Environment.Cleanup()
    _G.SilentAimEnabled = false
    _G.HeadESP = false
    _G.ShowFOV = false
    
    -- Biztonságos törlés
    pcall(function()
        if FOVCircle then
            FOVCircle.Visible = false
            FOVCircle:Remove()
        end
    end)
    
    if getgenv().MathUtils then
        getgenv().MathUtils.ClearESP()
    end
end

return Environment
