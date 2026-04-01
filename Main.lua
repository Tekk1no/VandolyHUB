local assetId = 124078092058387
local player = game:GetService("Players").LocalPlayer

local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if success and model then
    -- удаляем старое
    if player:FindFirstChild("PlayerGui"):FindFirstChild("VandolyX") then
        player.PlayerGui.VandolyX:Destroy()
    end

    model.Name = "VandolyX"
    model.Parent = player.PlayerGui  -- вот тут ключ: PlayerGui, а не CoreGui

    print("Vandoly X: загружен и MainScript теперь реально работает 😈")
else
    warn("Vandoly X: ошибка загрузки ассета")
end
