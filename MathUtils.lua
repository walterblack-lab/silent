-- MathUtils.lua
local MathUtils = {}
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local ESP_Dots = {}

function MathUtils.CreateESP(player)
    if player == LP then return end
    
    local dot = Drawing.new("Circle")
    dot.Visible = false
    dot.Color = Color3.fromRGB(255, 0, 0)
    dot.Thickness = 1
    dot.Radius = 4
    dot.Filled = true
    dot.NumSides = 12
    
    ESP_Dots[player] = dot

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Head") and _G.HeadESP then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                dot.Position = Vector2.new(screenPos.X, screenPos.Y)
                dot.Visible = true
            else
                dot.Visible = false
            end
        else
            dot.Visible = false
            if not player.Parent then
                dot:Remove()
                ESP_Dots[player] = nil
                connection:Disconnect()
            end
        end
    end)
end

function MathUtils.InitESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        MathUtils.CreateESP(player)
    end
    game.Players.PlayerAdded:Connect(function(player)
        MathUtils.CreateESP(player)
    end)
end

function MathUtils.ClearESP()
    for player, dot in pairs(ESP_Dots) do
        pcall(function() dot:Remove() end)
    end
    table.clear(ESP_Dots)
end

function MathUtils.IsVisible(targetPart, character)
    if not _G.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character, character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position).Unit * 1000, params)
    return result == nil
end

function MathUtils.GetClosestTarget()
    local closestTarget = nil
    local maxDistance = _G.FOVRadius or 150
    local mousePos = Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if distToMouse < maxDistance and MathUtils.IsVisible(head, player.Character) then
                    maxDistance = distToMouse
                    closestTarget = head
                end
            end
        end
    end
    return closestTarget
end

return MathUtils
