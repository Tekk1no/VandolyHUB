-- VANDOLY X CORE ENGINE
local assetId = 124078092058387

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- Чистим старое
    if game.CoreGui:FindFirstChild("VandolyX") then
        game.CoreGui.VandolyX:Destroy()
    end

    model.Name = "VandolyX"
    model.Parent = game:GetService("CoreGui")
    
    local mainFrame = model:FindFirstChild("ZenithMainFrame")
    local mainScript = mainFrame:FindFirstChild("MainScript") or model:FindFirstChild("MainScript", true)

    if mainScript and mainScript:IsA("LuaSourceContainer") then
        -- СОЗДАЕМ ОКРУЖЕНИЕ (Чтобы твой script.Parent сработал)
        local env = setmetatable({
            script = mainScript
        }, {
            __index = getfenv()
        })
        
        local func, err = loadstring(mainScript.Source)
        if func then
            setfenv(func, env)
            task.spawn(func)
            print("Vandoly X: Твой оригинальный Core Script запущен! 😈")
        else
            warn("Ошибка в синтаксисе твоего скрипта: " .. tostring(err))
        end
    else
        warn("Vandoly X: MainScript не найден в модели!")
    end
else
    warn("Vandoly X: Ошибка загрузки ассета!")
end
