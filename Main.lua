-- VANDOLY X CORE LOADER
local assetId = 124078092058387 -- Твой ID

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- 1. Очистка старой версии
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Parent = game:GetService("CoreGui")
    local mainFrame = model:FindFirstChild("ZenithMainFrame") [cite: 2]
    
    -- 2. Активация встроенной логики (MainScript)
    local mainScript = model:FindFirstChild("MainScript") or mainFrame:FindFirstChild("MainScript") [cite: 7]
    if mainScript and mainScript:IsA("LuaSourceContainer") then
        -- Создаем копию скрипта как LocalScript, чтобы он заработал при инжекте
        local runScript = Instance.new("LocalScript")
        runScript.Name = "VandolyRun"
        runScript.Source = mainScript.Source
        runScript.Parent = mainFrame
        print("Vandoly X: Логика запущена!")
    else
        warn("Vandoly X: Встроенный MainScript не найден!")
    end
else
    warn("Vandoly X: Ошибка загрузки модели!")
end
