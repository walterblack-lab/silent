-- MathUtils.lua | Matrix Hub Core Logic & ESP
local MathUtils = {}
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local ESP_Dots = {}

-- 1. HEAD ESP
function MathUtils.CreateESP(player)
    local dot = Drawing.new("Circle")
    dot.Visible = false
    dot.Color = Color3.fromRGB(255, 0, 0)
    dot.Thickness = 1
    dot.Radius = 3
    dot.Filled = true
    dot.NumSides = 12
    
    ESP_Dots[player] = dot

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Head") and _G.HeadESP and player.Character.Humanoid.Health > 0 then
            local screenPos, onScreen = Camera:WorldToViewportPoint(player.Character.Head.Position)
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
        if player ~= LP then MathUtils.CreateESP(player) end
    end
    game.Players.PlayerAdded:Connect(function(player)
        if player ~= LP then MathUtils.CreateESP(player) end
    end)
end

function MathUtils.ClearESP()
    for _, dot in pairs(ESP_Dots) do dot:Remove() end
    table.clear(ESP_Dots)
end

-- 2. LOGIKA
function MathUtils.IsVisible(targetPart, character)
    if not _G.WallCheck then return true end
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = (destination - origin).Unit * (destination - origin).Magnitude
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LP.Character, character, Camera}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, direction, params)
    return result == nil
end

function MathUtils.GetRandomBodyPart(character)
    local chance = math.random(1, 100)
    if chance <= (_G.HeadChance or 80) then
        return character:FindFirstChild("Head")
    else
        return character:FindFirstChild("UpperTorso") or character:FindFirstChild("HumanoidRootPart")
    end
end

function MathUtils.GetClosestTarget()
    local closestTarget = nil
    local maxDistance = _G.FOVRadius or 150
    local mousePos = Vector2.new(LP:GetMouse().X, LP:GetMouse().Y)

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LP and player.Character and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                local head = player.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                        if distToMouse < maxDistance and MathUtils.IsVisible(head, player.Character) then
                            maxDistance = distToMouse
                            closestTarget = player.Character
                        end
                    end
                end
            end
        end
    end
    if closestTarget then return MathUtils.GetRandomBodyPart(closestTarget) end
    return nil
end

return MathUtils
