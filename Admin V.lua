-- Delta Executor Script with Custom GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "DeltaAdvancedMenu"
ScreenGui.Parent = game.CoreGui

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -200)
MainFrame.Size = UDim2.new(0, 250, 0, 410)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Size = UDim2.new(0, 250, 0, 40)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "Delta Advanced Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Helper function para sa button
local function createButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

-- Helper function para sa textbox (adjustable values)
local function createTextBox(placeholder, yPos)
    local box = Instance.new("TextBox")
    box.Parent = MainFrame
    box.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    box.Position = UDim2.new(0, 15, 0, yPos)
    box.Size = UDim2.new(0, 220, 0, 25)
    box.Font = Enum.Font.SourceSans
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 14
    return box
end

-- 1. Speed Control
local speedBox = createTextBox("Ilagay ang bilis (e.g. 50)", 50)
createButton("Set Speed", 80, function()
    local val = tonumber(speedBox.Text)
    if val then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = val
        end
    end
end)

-- 2. Jump Power Control
local jumpBox = createTextBox("Ilagay ang talon (e.g. 100)", 115)
createButton("Set Jump Power", 145, function()
    local val = tonumber(jumpBox.Text)
    if val then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = val
        end
    end
end)

-- 3. Fullbright
createButton("Toggle Fullbright", 180, function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.GlobalShadows = false
    game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
end)

-- 4. ESP (Basic Highlight)
createButton("Toggle ESP", 215, function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer and p.Character then
            if not p.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight")
                hl.Parent = p.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
            end
        end
    end
end)

-- 5. Noclip
local noclipEnabled = false
createButton("Toggle Noclip", 250, function()
    noclipEnabled = not noclipEnabled
    game:GetService("RunService").Stepped:Connect(function()
        if noclipEnabled then
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
end)

-- 6. Fly Jump / Fly
local flying = false
createButton("Toggle Fly", 285, function()
    flying = not flying
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local bv = root:FindFirstChild("FlyBodyVelocity")
    local bg = root:FindFirstChild("FlyBodyGyro")
    
    if flying then
        bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBodyVelocity"
        bv.Parent = root
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        
        bg = Instance.new("BodyGyro")
        bg.Name = "FlyBodyGyro"
        bg.Parent = root
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = root.CFrame
        
        task.spawn(function()
            while flying do
                task.wait()
                if workspace.CurrentCamera then
                    bv.Velocity = workspace.CurrentCamera.CoordinateFrame.LookVector * 50
                    bg.CFrame = workspace.CurrentCamera.CoordinateFrame
                end
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)
