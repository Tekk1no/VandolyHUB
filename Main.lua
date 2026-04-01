-- ИСПРАВЛЕННЫЙ VANDOLY X LOADER
local assetId = 124078092058387 -- ВСТАВЬ СВОЙ ID ЗДЕСЬ

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- Удаляем старую версию, если она есть
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Parent = game:GetService("CoreGui")
    
    -- Проверка пути до главного фрейма (как в твоем .rbxm)
    local main = model:FindFirstChild("ZenithMainFrame")
    if main then
        print("Vandoly X: Успешно загружено!")
        -- Здесь пошла логика кнопок (Sidebar, Pages и т.д.)
    else
        warn("Vandoly X: Не найден ZenithMainFrame внутри модели!")
    end
else
    warn("Vandoly X: Не удалось скачать модель. Проверь Asset ID и доступ!")
end
