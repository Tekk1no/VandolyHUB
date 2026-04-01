-- ==========================================
-- VANDOLY X CORE ENGINE (PLAYERGUI EDITION 😈)
-- ==========================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

-- Ассет с твоей UI-моделью
local assetId = 124078092058387

-- Загружаем модель
local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if not success or not model then
    warn("Vandoly X: не удалось загрузить UI-модель!")
    return
end

-- Чистим старую версию
local playerGui = player:WaitForChild("PlayerGui")
if playerGui:FindFirstChild("VandolyX") then
    playerGui.VandolyX:Destroy()
end

model.Name = "VandolyX"
model.Parent = playerGui

-- Ссылки на элементы UI
local mainFrame = model:FindFirstChild("ZenithMainFrame") or model:FindFirstChildWhichIsA("Frame")
local topFrame = mainFrame:WaitForChild("TopFrame")
local sidebar = mainFrame:WaitForChild("Sidebar")
local contentArea = mainFrame:WaitForChild("ContentArea")
local mainPage = contentArea:WaitForChild("MainPage")
local closeBtn = topFrame:WaitForChild("CloseButton")
local minimizeBtn = topFrame:FindFirstChild("MinimizeButton")

-- Состояния
local originalSize = mainFrame.Size
local minimizedSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, topFrame.Size.Y.Offset)
local isOpen = true
local isBusy = false
local isMinimized = false

-- ==========================================
-- ФУНКЦИИ: Tween, Sound, Glitch
-- ==========================================
local function animate(obj, props, time, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function playSound(id, volume)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = volume or 0.5
    s.Parent = SoundService
    s:Play()
    Debris:AddItem(s, 3)
end

local function glitch()
    local pos = mainFrame.Position
    for i = 1, 4 do
        mainFrame.Position = pos + UDim2.new(0, math.random(-6,6), 0, math.random(-6,6))
        task.wait(0.03)
    end
    mainFrame.Position = pos
end

-- ==========================================
-- 1. Dragging
-- ==========================================
local dragging, dragInput, dragStart, startPos
local dragLerpInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

topFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

topFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(mainFrame, dragLerpInfo, {Position = target}):Play()
    end
end)

-- ==========================================
-- 2. Sidebar Buttons
-- ==========================================
local currentActive = nil
for _, button in pairs(sidebar:GetDescendants()) do
    if button:IsA("GuiButton") then
        button.MouseEnter:Connect(function()
            if currentActive ~= button then animate(button, {BackgroundTransparency=0.7, BackgroundColor3=Color3.fromRGB(50,50,50)},0.15) end
        end)
        button.MouseLeave:Connect(function()
            if currentActive ~= button then animate(button, {BackgroundTransparency=1},0.15) end
        end)
        button.MouseButton1Click:Connect(function()
            if currentActive and currentActive ~= button then animate(currentActive, {BackgroundTransparency=1},0.15) end
            currentActive = button
            animate(button, {BackgroundTransparency=0.4, BackgroundColor3=Color3.fromRGB(80,20,20)},0.15)
        end)
    end
end

-- ==========================================
-- 3. 3D Character Setup
-- ==========================================
local function setup3D()
    local charView = mainPage:FindFirstChild("CharView", true)
    if not charView then return warn("CharView не найден!") end
    charView:ClearAllChildren()

    local cam = Instance.new("Camera")
    cam.FieldOfView = 50
    cam.Parent = charView
    charView.CurrentCamera = cam

    local char = player.Character or player.CharacterAdded:Wait()
    char.Archivable = true
    task.wait(0.5)
    local clone = char:Clone()
    clone.Parent = charView

    for _, v in pairs(clone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") or v:IsA("Sound") then v:Destroy() end
    end

    local hrp = clone:WaitForChild("HumanoidRootPart")
    local hum = clone:WaitForChild("Humanoid")
    cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0,0,9), hrp.Position)

    local anim = Instance.new("Animation")
    anim.AnimationId = hum.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://507766666" or "rbxassetid://180435571"
    local track = (hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)):LoadAnimation(anim)
    track.Looped = true
    track:Play()
end

task.spawn(setup3D)
player.CharacterAdded:Connect(setup3D)

-- ==========================================
-- 4. Window Control
-- ==========================================
local function hideMenu()
    if not isOpen or isBusy then return end
    isBusy = true
    glitch()
    animate(mainFrame, {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1},0.2,Enum.EasingStyle.Back,Enum.EasingDirection.In).Completed:Wait()
    mainFrame.Visible = false
    isOpen = false
    isBusy = false
end

local function showMenu()
    if isOpen or isBusy then return end
    isBusy = true
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0,0,0,0)
    playSound("rbxassetid://81083988369325",0.4)
    glitch()
    animate(mainFrame, {Size=originalSize, BackgroundTransparency=0},0.25,Enum.EasingStyle.Back).Completed:Wait()
    isOpen = true
    isBusy = false
end

if minimizeBtn then
    minimizeBtn.MouseButton1Click:Connect(function()
        if isBusy then return end
        isBusy = true
        isMinimized = not isMinimized
        if isMinimized then
            sidebar.Visible = false contentArea.Visible = false
            animate(mainFrame, {Size=minimizedSize},0.25).Completed:Wait()
        else
            sidebar.Visible = true contentArea.Visible = true
            animate(mainFrame, {Size=originalSize},0.25).Completed:Wait()
        end
        isBusy = false
    end)
end

closeBtn.MouseButton1Click:Connect(function()
    if isBusy then return end
    isBusy = true
    playSound("rbxassetid://115108779739901",1)
    mainFrame:Destroy()
end)

-- Toggle с RightControl
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        if isOpen then hideMenu() else showMenu() end
    end
end)
