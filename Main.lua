local assetId = 124078092058387 -- Твой ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Parent = game:GetService("CoreGui")
    local main = model:FindFirstChild("ZenithMainFrame")
    local sidebar = main:FindFirstChild("Sidebar")
    local content = main:FindFirstChild("ContentArea")

    -- [ФУНКЦИЯ ПЕРЕТАСКИВАНИЯ] (Из твоего кода)
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

    -- [ЛОГИКА ВКЛАДОК] (Авто-поиск страниц)
    for _, btn in pairs(sidebar:GetDescendants()) do
        if btn:IsA("TextButton") or btn:IsA("ImageButton") then
            btn.MouseButton1Click:Connect(function()
                for _, page in pairs(content:GetDescendants()) do
                    if page:IsA("ScrollingFrame") or page:IsA("Frame") then
                        -- Если имя кнопки совпадает с именем страницы (например PlayerBtn -> PlayerPage)
                        if string.find(page.Name, btn.Name:gsub("Button", "")) then
                            page.Visible = true
                        else
                            if page.Parent == content then page.Visible = false end
                        end
                    end
                end
            end)
        end
    end

    print("Vandoly X: UI и логика успешно восстановлены!")
else
    warn("Vandoly X: Ошибка загрузки!")
end
