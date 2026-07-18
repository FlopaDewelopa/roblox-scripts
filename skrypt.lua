local Player = game.Players.LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Silka"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 240, 0, 210)
Frame.Position = UDim2.new(0.8, -250, 0.5, -105)
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

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Mati to gej - silka"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local SelectBtn = Instance.new("TextButton", Frame)
SelectBtn.Size = UDim2.new(0, 200, 0, 35)
SelectBtn.Position = UDim2.new(0, 20, 0, 45)
SelectBtn.Text = "Wybierz part"
SelectBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
SelectBtn.Font = Enum.Font.Gotham
Instance.new("UICorner", SelectBtn).CornerRadius = UDim.new(0, 6)

local StatusLabel = Instance.new("TextLabel", Frame)
StatusLabel.Size = UDim2.new(0, 200, 0, 20)
StatusLabel.Position = UDim2.new(0, 20, 0, 85)
StatusLabel.Text = "Brak parta"
StatusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 13

local IntervalBox = Instance.new("TextBox", Frame)
IntervalBox.Size = UDim2.new(0, 200, 0, 35)
IntervalBox.Position = UDim2.new(0, 20, 0, 110)
IntervalBox.PlaceholderText = "Czas (sek)"
IntervalBox.Text = "12"
IntervalBox.TextColor3 = Color3.fromRGB(255, 255, 255)
IntervalBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
IntervalBox.Font = Enum.Font.Gotham
Instance.new("UICorner", IntervalBox).CornerRadius = UDim.new(0, 6)

local StartBtn = Instance.new("TextButton", Frame)
StartBtn.Size = UDim2.new(0, 95, 0, 35)
StartBtn.Position = UDim2.new(0, 20, 0, 155)
StartBtn.Text = "Włącz"
StartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StartBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
StartBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StartBtn).CornerRadius = UDim.new(0, 6)

local StopBtn = Instance.new("TextButton", Frame)
StopBtn.Size = UDim2.new(0, 95, 0, 35)
StopBtn.Position = UDim2.new(0, 125, 0, 155)
StopBtn.Text = "Wyłącz"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
StopBtn.Font = Enum.Font.GothamBold
Instance.new("UICorner", StopBtn).CornerRadius = UDim.new(0, 6)

-- Efekt podświetlenia
local PartHighlight = Instance.new("Highlight")
PartHighlight.FillColor = Color3.fromRGB(52, 152, 219)
PartHighlight.FillTransparency = 0.5
PartHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
PartHighlight.Parent = game.CoreGui
PartHighlight.Adornee = nil

local selectedPart = nil
local running = false
local isSelecting = false
local hoverConnection = nil
local clickConnection = nil

local lastHoveredPart = nil
local lastHoveredTransparency = 0

-- Zaawansowane szukanie parta (Locked + Niewidzialne)
local function getMouseTargetAdvanced()
    local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {Player.Character, ScreenGui}
    params.IgnoreWater = true
    params.BruteForceAllSlow = true 
    
    local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
    if result and result.Instance and result.Instance:IsA("BasePart") then
        return result.Instance
    end
    return nil
end

local function resetLastHovered()
    if lastHoveredPart then
        pcall(function()
            lastHoveredPart.Transparency = lastHoveredTransparency
        end)
        lastHoveredPart = nil
    end
end

SelectBtn.MouseButton1Click:Connect(function()
    if isSelecting then return end
    isSelecting = true
    SelectBtn.Text = "Wybierz"
    
    resetLastHovered()
    
    hoverConnection = RunService.RenderStepped:Connect(function()
        local target = getMouseTargetAdvanced()
        if target then
            if lastHoveredPart ~= target then
                resetLastHovered()
                lastHoveredPart = target
                lastHoveredTransparency = target.Transparency
                
                -- Jeśli part jest całkiem niewidzialny, robimy go lekko widocznym, żeby Highlight zadziałał
                if target.Transparency >= 0.95 then
                    pcall(function() target.Transparency = 0.6 end)
                end
            end
            PartHighlight.Adornee = target
        else
            resetLastHovered()
            PartHighlight.Adornee = nil
        end
    end)
    
    clickConnection = Mouse.Button1Down:Connect(function()
        local target = getMouseTargetAdvanced()
        if target then
            resetLastHovered()
            selectedPart = target
            StatusLabel.Text = "Wybrano: " .. selectedPart.Name
            SelectBtn.Text = "Zmień part"
            
            -- Zostawiamy lekki widok jeśli był niewidzialny, żeby podświetlenie wybranego działało
            if selectedPart.Transparency >= 0.95 then
                pcall(function() selectedPart.Transparency = 0.6 end)
            end
            PartHighlight.Adornee = selectedPart
            
            isSelecting = false
            if hoverConnection then hoverConnection:Disconnect() end
            if clickConnection then clickConnection:Disconnect() end
        end
    end)
end)

StartBtn.MouseButton1Click:Connect(function()
    if not selectedPart or running then return end
    running = true
    
    task.spawn(function()
        while running do
            if selectedPart then
                local prompt = selectedPart:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    prompt.HoldDuration = 0
                    fireproximityprompt(prompt)
                end
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
    isSelecting = false
    resetLastHovered()
    if hoverConnection then hoverConnection:Disconnect() end
    if clickConnection then clickConnection:Disconnect() end
    if PartHighlight then PartHighlight:Destroy() end
    ScreenGui:Destroy()
end)
