-- MathUtils.lua | Matrix Hub Core Logic & ESP
local MathUtils = {}
local LP = game:GetService("Players").LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

local ESP_Table = {} -- Ebben tároljuk a pöttyöket

-- 1. HEAD ESP LÉTREHOZÁSA ÉS FRISSÍTÉSE
function MathUtils.CreateESP(player)
    local dot = Drawing.new("Circle")
    dot.Visible = false
    dot.Color = Color3.fromRGB(255, 0, 0) -- Piros
    dot.Thickness = 1
    dot.Radius = 3 -- Pici pötty
    dot.Filled = true
    dot.NumSides = 12 -- Hogy ne egye az FPS-t, kevés oldal elég
    
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("Head") and _G.HeadESP and player.Character.Humanoid.Health > 0 then
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
            if not player.Parent then -- Ha kilép a játékos
                dot:Remove()
                connection:Disconnect()
            end
        end
    end)
end

-- Ezt egyszer kell meghívni a main.lua-ban minden játékosra
function MathUtils.InitESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LP then
            MathUtils.CreateESP(player)
        end
    end
    game.Players.PlayerAdded:Connect(function(player)
        if player ~= LP then
            MathUtils.CreateESP(player)
        end
    end)
end

-- 2. LÁTHATÓSÁG ELLENŐRZÉSE (Raycast)
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

-- 3. TESTRÉSZ RANDOMIZÁLÓ ÉS CÉLPONT KERESŐ
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
    
    if closestTarget then
        return MathUtils.GetRandomBodyPart(closestTarget)
    end
    return nil
end

return MathUtils
