-- MathUtils.lua
local MathUtils = {}
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local ESP_Dots = {}

function MathUtils.CreateESP(player)
    if player == LP then return end
    local dot = Drawing.new("Circle")
    dot.Visible = false
    dot.Color = Color3.fromRGB(255, 0, 0)
    dot.Radius = 4
    dot.Filled = true
    
    ESP_Dots[player] = dot

    game:GetService("RunService").RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Head") and (_G.HeadESP or true) then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
            dot.Visible = onScreen
            dot.Position = Vector2.new(screenPos.X, screenPos.Y)
        else
            dot.Visible = false
        end
    end)
end

function MathUtils.InitESP()
    for _, p in pairs(game.Players:GetPlayers()) do MathUtils.CreateESP(p) end
    game.Players.PlayerAdded:Connect(MathUtils.CreateESP)
end

function MathUtils.ClearESP()
    for _, d in pairs(ESP_Dots) do d:Remove() end
    table.clear(ESP_Dots)
end

function MathUtils.GetClosestTarget()
    local target = nil
    local dist = _G.FOVRadius or 150
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)).Magnitude
            if vis and mag < dist then
                dist = mag
                target = p.Character.Head
            end
        end
    end
    return target
end

return MathUtils
