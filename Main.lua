-- VANDOLY X MAIN LOADER
local assetId = 124078092058387 -- ЗАМЕНИ НА СВОЙ ID ИЗ ШАГА 1

-- Загрузка UI из облака Roblox
local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if not success or not model then
    warn("Vandoly X: Ошибка загрузки UI!")
    return
end

-- Размещение в CoreGui (чтобы не удалили обычным Reset)
model.Parent = game:GetService("CoreGui")
local mainFrame = model.ZenithMainFrame -- Твой главный фрейм [cite: 2]

-- ЛОГИКА ВКЛАДОК (Пример для твоих кнопок)
local sidebar = mainFrame.Sidebar -- Твой сайдбар [cite: 13]
local pages = mainFrame.ContentArea.ScrollingFrame -- Твои страницы [cite: 13, 2]

local function showPage(name)
    for _, page in pairs(pages:GetChildren()) do
        if page:IsA("Frame") then
            page.Visible = (page.Name == name)
        end
    end
end

-- Привязка кнопок из твоего файла [cite: 19]
sidebar.PlayerButton.MouseButton1Click:Connect(function()
    showPage("PlayerPage")
end)

sidebar.VisualButton.MouseButton1Click:Connect(function()
    showPage("VisualPage")
end)

-- Сюда добавляешь остальной функционал (Speed, Stamina, ESP)
