-- ==========================================
-- VANDOLYX: MAINSCRIPT FIXED EDITION 😈
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local mainFrame = script.Parent
local topFrame = mainFrame:WaitForChild("TopFrame")
local sidebar = mainFrame:WaitForChild("Sidebar")
local contentArea = mainFrame:WaitForChild("ContentArea")
local mainPage = contentArea:WaitForChild("MainPage")

local closeBtn = topFrame:WaitForChild("CloseButton")
local minimizeBtn = topFrame:FindFirstChild("MinimizeButton")
local searchBox = mainFrame:FindFirstChild("SearchBox") or topFrame:FindFirstChild("SearchBox")

local mainBorder = mainFrame:FindFirstChild("MainFrameBorder")
local sidebarBorder = mainFrame:FindFirstChild("SidebarBorder")

local originalSize = mainFrame.Size
local originalTransparency = mainFrame.BackgroundTransparency 
local minimizedSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, topFrame.Size.Y.Offset)

local isOpen, busy, isDestroyed, isMinimized = true, false, false, false

-- ==========================================
-- UTILS
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
	local currentPos = mainFrame.Position
	for i = 1, 4 do
		mainFrame.Position = currentPos + UDim2.new(0, math.random(-6,6), 0, math.random(-6,6))
		task.wait(0.03)
	end
	mainFrame.Position = currentPos
end

-- ==========================================
-- DRAGGING
-- ==========================================
local dragging, dragInput, dragStart, startPos
local dragLerpInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

topFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

topFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(mainFrame, dragLerpInfo, {Position = targetPos}):Play()
	end
end)

-- ==========================================
-- SIDEBAR BUTTONS
-- ==========================================
local currentActiveButton
local function setupSidebar()
	for _, button in pairs(sidebar:GetDescendants()) do
		if button:IsA("GuiButton") then
			button.MouseEnter:Connect(function()
				if currentActiveButton ~= button then
					animate(button, {BackgroundTransparency = 0.7, BackgroundColor3 = Color3.fromRGB(50,50,50)}, 0.15)
				end
			end)
			button.MouseLeave:Connect(function()
				if currentActiveButton ~= button then
					animate(button, {BackgroundTransparency = 1}, 0.15)
				end
			end)
			button.MouseButton1Click:Connect(function()
				if currentActiveButton and currentActiveButton ~= button then
					animate(currentActiveButton, {BackgroundTransparency = 1}, 0.15)
				end
				currentActiveButton = button
				animate(button, {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(80,20,20)}, 0.15)
				-- Переключение страниц
				for _, page in pairs(contentArea:GetChildren()) do
					if page:IsA("Frame") then
						page.Visible = page == mainPage and button.Name == "MainButton" -- пример
					end
				end
			end)
		end
	end
	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			local text = string.lower(searchBox.Text)
			for _, button in pairs(sidebar:GetChildren()) do
				if button:IsA("GuiButton") then
					button.Visible = (text == "" or string.find(string.lower(button.Name), text))
				end
			end
		end)
	end
end
setupSidebar()

-- ==========================================
-- DASHBOARD 3D CHARACTER
-- ==========================================
local charClone, cam, animTrack
local function setup3D()
	local charView = mainPage:FindFirstChild("CharView", true)
	if not charView then warn("Где CharView?!") return end
	charView:ClearAllChildren()

	cam = Instance.new("Camera")
	cam.FieldOfView = 50
	cam.Parent = charView
	charView.CurrentCamera = cam

	local char = player.Character or player.CharacterAdded:Wait()
	char.Archivable = true
	task.wait(0.2)

	if charClone then charClone:Destroy() end
	charClone = char:Clone()
	charClone.Parent = charView

	for _, v in pairs(charClone:GetDescendants()) do
		if v:IsA("LocalScript") or v:IsA("Script") or v:IsA("Sound") then v:Destroy() end
	end

	-- Клонируем лицо
	local headC, headO = charClone:FindFirstChild("Head"), char:FindFirstChild("Head")
	if headO and headC then
		local decal = headO:FindFirstChildOfClass("Decal")
		if decal and decal.Name == "face" and not headC:FindFirstChild("face") then
			decal:Clone().Parent = headC
		end
	end

	local hrp, hum = charClone:WaitForChild("HumanoidRootPart"), charClone:WaitForChild("Humanoid")
	cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0,0,9), hrp.Position)

	-- Танец
	local anim = Instance.new("Animation")
	anim.AnimationId = hum.RigType == Enum.HumanoidRigType.R15 and "rbxassetid://507766666" or "rbxassetid://180435571"
	local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
	animTrack = animator:LoadAnimation(anim)
	animTrack.Looped = true
	animTrack:Play()
end
task.spawn(setup3D)
player.CharacterAdded:Connect(setup3D)

-- ==========================================
-- WINDOW TOGGLE
-- ==========================================
local function hideMenu()
	if not isOpen or busy then return end
	busy = true
	glitch()
	animate(mainFrame, {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In).Completed:Wait()
	mainFrame.Visible = false
	isOpen = false
	busy = false
end

local function showMenu()
	if isOpen or busy or isDestroyed then return end
	busy = true
	mainFrame.Visible = true
	mainFrame.BackgroundTransparency = 1
	mainFrame.Size = UDim2.new(0,0,0,0)
	glitch()
	local targetSize = isMinimized and minimizedSize or originalSize
	animate(mainFrame, {Size = targetSize, BackgroundTransparency = originalTransparency}, 0.25, Enum.EasingStyle.Back).Completed:Wait()
	isOpen = true
	if charClone then
		-- Обновляем камеру
		local hrp = charClone:FindFirstChild("HumanoidRootPart")
		if hrp and cam then
			cam.CFrame = CFrame.new(hrp.Position + Vector3.new(0,0,9), hrp.Position)
		end
	end
	busy = false
end

if minimizeBtn then
	minimizeBtn.MouseButton1Click:Connect(function()
		if busy then return end
		busy = true
		isMinimized = not isMinimized
		if isMinimized then
			sidebar.Visible = false contentArea.Visible = false
			if mainBorder then mainBorder.Visible = false end
			if sidebarBorder then sidebarBorder.Visible = false end
			animate(mainFrame, {Size = minimizedSize}, 0.25).Completed:Wait()
		else
			animate(mainFrame, {Size = originalSize}, 0.25).Completed:Wait()
			sidebar.Visible = true contentArea.Visible = true
			if mainBorder then mainBorder.Visible = true end
			if sidebarBorder then sidebarBorder.Visible = true end
		end
		busy = false
	end)
end

closeBtn.MouseButton1Click:Connect(function()
	if busy or isDestroyed then return end
	busy, isDestroyed = true, true
	playSound("rbxassetid://115108779739901",1)
	for _, obj in pairs(mainFrame:GetDescendants()) do if obj:IsA("GuiObject") and obj ~= mainFrame then obj.Visible=false end end
	local flash = Instance.new("Frame")
	flash.Size, flash.BackgroundColor3, flash.BackgroundTransparency, flash.ZIndex, flash.Parent = UDim2.new(1,0,1,0), Color3.fromRGB(120,0,0), 1, 999, mainFrame
	animate(flash,{BackgroundTransparency=0.4},0.05) task.wait(0.05) animate(flash,{BackgroundTransparency=1},0.15)
	glitch()
	animate(mainFrame,{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1},0.25,Enum.EasingStyle.Back,Enum.EasingDirection.In).Completed:Wait()
	mainFrame:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed or isDestroyed then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		if isOpen then hideMenu() else showMenu() end
	end
end)
