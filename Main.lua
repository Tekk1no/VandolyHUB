-- VANDOLY X CORE ENGINE (WORKING VERSION)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local assetId = 124078092058387 -- Твой ассет

-- Загружаем модель
local success, model = pcall(function()
    return game:GetObjects("rbxassetid://" .. assetId)[1]
end)

if not (success and model) then
    warn("Vandoly X: Не удалось загрузить ассет!")
    return
end

-- Удаляем старое, если есть
if player.PlayerGui:FindFirstChild("VandolyX") then
    player.PlayerGui.VandolyX:Destroy()
end

model.Name = "VandolyX"
model.Parent = player.PlayerGui -- вот ключ: PlayerGui

-- Ищем MainScript внутри модели
local mainFrame = model:FindFirstChild("ZenithMainFrame") or model:FindFirstChildWhichIsA("Frame", true)
local mainScript = mainFrame and mainFrame:FindFirstChild("MainScript") or model:FindFirstChild("MainScript", true)

if not (mainScript and mainScript:IsA("LocalScript")) then
    warn("Vandoly X: MainScript не найден или не LocalScript!")
    return
end

-- Всё остальное просто работает, никаких костылей с loadstring
mainScript.Disabled = false -- включаем скрипт
print("Vandoly X: MainScript запущен и функционал активен! 😈")
