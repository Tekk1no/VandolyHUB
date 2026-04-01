-- VANDOLY X ULTIMATE LOADER (FIXED)
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
    local function switchPage(btnName)
        if not content then return end
        
        -- Очищаем имя кнопки от мусора (Tab_, Button, _Btn)
        local target = btnName:lower():gsub("tab_", ""):gsub("button", ""):gsub("_btn", ""):gsub("btn", "")
        
        for _, page in pairs(content:GetChildren()) do
            local pageName = page.Name:lower():gsub("page", ""):gsub("frame", "")
            
            if page:IsA("GuiObject") then
                if pageName == target then
                    page.Visible = true
                else
                    page.Visible = false
                end
            end
        end
    end

    -- Назначаем клик всем кнопкам в Sidebar
    if sidebar then
        for _, item in pairs(sidebar:GetDescendants()) do
            if item:IsA("TextButton") or item:IsA("ImageButton") then
                item.MouseButton1Click:Connect(function()
                    print("Vandoly X: Переключение на " .. item.Name)
                    switchPage(item.Name)
                end)
            end
        end
    end

    -- 4. [КНОПКА ЗАКРЫТИЯ]
    local closeBtn = main:FindFirstChild("Close", true) or main:FindFirstChild("Exit", true)
    if closeBtn then
        closeBtn.MouseButton1Click:Connect(function()
            model:Destroy()
            print("Vandoly X: Скрипт выключен")
        end)
    end

    print("Vandoly X v0.1: Полная инициализация завершена! 🚀")
else
    warn("Vandoly X: Ошибка загрузки модели! Проверь Asset ID.")
end
