-- VANDOLY X OFFICIAL LOADER
local assetId = 124078092058387 -- Твой фиксированный ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- 1. Очистка старой версии перед запуском
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    -- 2. Установка родителя (CoreGui для защиты от Reset)
    model.Parent = game:GetService("CoreGui")
    
    local mainFrame = model:FindFirstChild("ZenithMainFrame")
    if mainFrame then
        print("Vandoly X: UI успешно загружен!")
        
        -- 3. Поиск и запуск встроенной логики (MainScript)
        local mainScript = model:FindFirstChild("MainScript", true)
        
        if mainScript and mainScript:IsA("LuaSourceContainer") then
            -- Используем loadstring для запуска кода из твоего MainScript
            local startup, err = loadstring(mainScript.Source)
            if startup then
                task.spawn(startup)
                print("Vandoly X: Логика (кнопки, вкладки, драг) запущена!")
            else
                warn("Vandoly X: Ошибка в коде MainScript: " .. tostring(err))
            end
        else
            warn("Vandoly X: Встроенный MainScript не найден!")
        end
    else
        warn("Vandoly X: ZenithMainFrame не найден внутри модели!")
    end
else
    warn("Vandoly X: Не удалось загрузить ассет. Проверь ID и 'Allow Copying'!")
end
