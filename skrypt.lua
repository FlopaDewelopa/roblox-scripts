local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 200)
Frame.Position = UDim2.new(0.8, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Auto Prompt Selector"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold

local SelectBtn = Instance.new("TextButton", Frame)
SelectBtn.Size = UDim2.new(0, 200, 0, 40)
SelectBtn.Position = UDim2.new(0, 20, 0, 50)
SelectBtn.Text = "Kliknij, aby wybrać Part"
SelectBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 6)

local StatusLabel = Instance.new("TextLabel", Frame)
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 95)
StatusLabel.Text = "Part: Nie wybrano"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(0, 200, 0, 40)
StartBtn.Position = UDim2.new(0, 20, 0, 130)
StartBtn.Text = "Włącz"
StartBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton", Frame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 4)

local selectedPart = nil
local running = false

SelectBtn.MouseButton1Click:Connect(function()
    SelectBtn.Text = "Kliknij w Part..."
    local connection
    connection = Mouse.Button1Down:Connect(function()
        if Mouse.Target then
            selectedPart = Mouse.Target
            StatusLabel.Text = "Wybrano: " .. selectedPart.Name
            SelectBtn.Text = "Part zapisany!"
            connection:Disconnect()
            task.wait(1)
            SelectBtn.Text = "Zmień Part"
        end
    end)
end)

StartBtn.MouseButton1Click:Connect(function()
    if not selectedPart then return end
    running = true
    StartBtn.Text = "Działa..."
    
    task.spawn(function()
        while running do
            local prompt = selectedPart:FindFirstChildOfClass("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
            end
            task.wait(15)
        end
    end)
end)

CloseBtn.MouseButton1Click:Connect(function()
    running = false
    ScreenGui:Destroy()
end)
