-- VANDOLY X ULTIMATE LOADER
local assetId = 124078092058387 -- Твой зафиксированный ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- 1. Чистим старые копии
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    -- 2. Устанавливаем родителя
    model.Parent = game:GetService("CoreGui")
    
    -- 3. Запуск логики (MainScript)
    -- Мы используем pcall, чтобы если в твоем скрипте есть ошибка, UI все равно появился
    local mainScript = model:FindFirstChild("MainScript", true)
    if mainScript and mainScript:IsA("LuaSourceContainer") then
        local startup, err = loadstring(mainScript.Source)
        if startup then
            task.spawn(startup)
            print("Vandoly X: Логика успешно инициализирована!")
        else
            warn("Vandoly X: Ошибка в синтаксисе MainScript: " .. tostring(err))
        end
    else
        warn("Vandoly X: MainScript не найден внутри модели!")
    end
else
    warn("Vandoly X: Ошибка загрузки ассета. Проверь настройки Distribution на сайте!")
end
