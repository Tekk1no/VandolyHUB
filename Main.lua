local assetId = 124078092058387 -- Твой ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Parent = game:GetService("CoreGui")
    
    -- Вместо создания нового скрипта, мы просто находим старый и включаем его
    local mainScript = model:FindFirstChild("MainScript", true)
    if mainScript then
        mainScript.Disabled = false
        -- Если это обычный Script с RunContext = Client, он заработает сам
        -- Если нет, используем spawn() для запуска кода из строки
        local func, err = loadstring(mainScript.Source)
        if func then
            spawn(func)
            print("Vandoly X: Логика запущена через spawn")
        else
            warn("Ошибка в коде MainScript: " .. tostring(err))
        end
    end
else
    warn("Vandoly X: Не удалось загрузить UI. Проверь ID.")
end
