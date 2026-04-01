-- VANDOLY X ULTIMATE LOADER (FIXED V2)
local assetId = 124078092058387 -- Твой ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- 1. Удаление старой копии
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Parent = game:GetService("CoreGui")
    local main = model:FindFirstChild("ZenithMainFrame")
    if not main then warn("Vandoly X: ZenithMainFrame не найден!") return end
    
    local sidebar = main:FindFirstChild("Sidebar")
    local content = main:FindFirstChild("ContentArea")

    -- 2. [СИСТЕМА ПЕРЕТАСКИВАНИЯ (DRAG)]
    local UserInputService = game:GetService("UserInputService")
    local dragging, dragInput, dragStart, startPos

    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- 3. [ЛОГИКА ПЕРЕКЛЮЧЕНИЯ ВКЛАДОК]
    local function switchPage(rawName)
        if not content then return end
        local target = rawName:lower():gsub("tab_", ""):gsub("button", ""):gsub("_btn", ""):gsub("btn", "")
        
        for _, page in pairs(content:GetChildren()) do
            if page:IsA("GuiObject") then
                local pageName = page.Name:lower():gsub("page", ""):gsub("frame", "")
                if pageName == target then
                    page.Visible = true
                else
                    page.Visible = false
                end
            end
        end
    end

    if sidebar then
        for _, item in pairs(sidebar:GetDescendants()) do
            if item:IsA("GuiButton") then -- Ищем TextButton или ImageButton
                item.MouseButton1Click:Connect(function()
                    -- Если имя стандартное, берем имя папки (например, "Player")
                    local nameToUse = item.Name
                    if nameToUse == "TextButton" or nameToUse == "ImageButton" or nameToUse == "Button" then
                        nameToUse = item.Parent.Name
                    end
                    
                    print("Vandoly X: Вкладка -> " .. nameToUse)
                    switchPage(nameToUse)
                end)
            end
        end
    end

    -- 4. [КНОПКИ ЗАКРЫТИЯ И СВОРАЧИВАНИЯ]
    -- Умный поиск кнопок управления окном
    local function setupWindowAction(keywords, actionFunc)
        for _, obj in pairs(main:GetDescendants()) do
            local objName = obj.Name:lower()
            for _, word in pairs(keywords) do
                if string.find(objName, word) then
                    -- Если это не сама кнопка, ищем кнопку внутри нее
                    local btn = obj
                    if not btn:IsA("GuiButton") then
                        btn = obj:FindFirstChildOfClass("TextButton") or obj:FindFirstChildOfClass("ImageButton")
                    end
                    
                    if btn and btn:IsA("GuiButton") then
                        btn.MouseButton1Click:Connect(actionFunc)
                        return
                    end
                end
            end
        end
    end

    -- Крестик (Закрыть)
    setupWindowAction({"close", "exit"}, function()
        model:Destroy()
        print("Vandoly X: Закрыто")
    end)

    -- Минус (Свернуть)
    setupWindowAction({"minimize", "min"}, function()
        if content and sidebar then
            content.Visible = not content.Visible
            sidebar.Visible = not sidebar.Visible
            -- Опционально: можно тут еще менять размер ZenithMainFrame
        end
    end)

    print("Vandoly X v0.1: Все системы онлайн! 🚀")
else
    warn("Vandoly X: Ошибка загрузки модели!")
end
