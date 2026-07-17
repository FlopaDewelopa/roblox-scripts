local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolarAutoClicker"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 180, 0, 140)
Frame.Position = UDim2.new(1, -190, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local IntervalBox = Instance.new("TextBox", Frame)
IntervalBox.Size = UDim2.new(0, 140, 0, 30)
IntervalBox.Position = UDim2.new(0, 20, 0, 15)
IntervalBox.PlaceholderText = "Czas (sek)"
IntervalBox.Text = "15"
IntervalBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IntervalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", IntervalBox).CornerRadius = UDim.new(0, 4)

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(0, 140, 0, 30)
StartBtn.Position = UDim2.new(0, 20, 0, 55)
StartBtn.Text = "Włącz"
StartBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 4)

local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(0, 140, 0, 30)
StopBtn.Position = UDim2.new(0, 20, 0, 95)
StopBtn.Text = "Wyłącz"
StopBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 4)

local running = false

StartBtn.MouseButton1Click:Connect(function()
    if running then return end
    running = true
    task.spawn(function()
        while running do
            local success, prompt = pcall(function()
                return workspace.Pakiernia:GetChildren()[6].ProximityPrompt
            end)
            if success and prompt then
                fireproximityprompt(prompt)
            end
            task.wait(tonumber(IntervalBox.Text) or 15)
        end
    end)
end)

StopBtn.MouseButton1Click:Connect(function()
    running = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)
