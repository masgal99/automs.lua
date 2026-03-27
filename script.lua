-- =====================================
-- 🔥 LANGZ HUB ⚪🔴🔵🟢 (FULL SYSTEM)
-- =====================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- ================= CONFIG =================
local POS_DEALER = CFrame.new(510,3,608)
local POS_SELL   = CFrame.new(1175,20,30)
local SAFE_POS   = CFrame.new(1190,3,-243)

_G.AutoCook = false
_G.AntiKill = false
_G.NoClip = false
_G.BuyAmount = 10

-- ================= UI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "LangzHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,320,0,360)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,35)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Langz Hub ⚪🔴🔵🟢"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

-- CLOSE
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,30,0,25)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0,30,0,25)
minimizeBtn.Position = UDim2.new(1,-70,0,5)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _,v in pairs(main:GetChildren()) do
        if v ~= header then
            v.Visible = not minimized
        end
    end
end)

-- ================= BUTTON =================
local function makeBtn(text, y, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0,280,0,30)
    btn.Position = UDim2.new(0,20,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- ================= SLIDER =================
local function makeSlider(text, y, min, max, default, callback)
    local label = Instance.new("TextLabel", main)
    label.Size = UDim2.new(0,280,0,20)
    label.Position = UDim2.new(0,20,0,y)
    label.Text = text..": "..default
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)

    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0,280,0,20)
    btn.Position = UDim2.new(0,20,0,y+20)
    btn.Text = "Random Set"

    btn.MouseButton1Click:Connect(function()
        local val = math.random(min,max)
        label.Text = text..": "..val
        callback(val)
    end)
end

-- ================= FUNCTIONS =================
local function pressE(t)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(t or 0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function safeTP(cf)
    hum.Sit = false
    _G.NoClip = true
    for i=1,3 do
        hrp.CFrame = cf + Vector3.new(0,3,0)
        task.wait(0.2)
    end
    _G.NoClip = false
end

local function getInv(name)
    local count = 0
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find(name:lower()) then
            count += 1
        end
    end
    return count
end

local function equipBag()
    local bag = player.Backpack:FindFirstChild("Empty Bag") or char:FindFirstChild("Empty Bag")
    if bag then
        bag.Parent = char
        task.wait(0.3)
        return true
    end
    return false
end

-- ================= AUTO COOK =================
task.spawn(function()
    while task.wait(1) do
        if _G.AutoCook then

            if getInv("Water") < 5 then
                safeTP(POS_DEALER)
                repeat
                    pressE(0.5)
                    task.wait(0.8)
                until getInv("Water") >= _G.BuyAmount
            end

            local pot = workspace:FindFirstChild("Pot") or workspace:FindFirstChild("Water Machine")

            if pot then
                safeTP(pot:GetPivot())

                pressE(0.5) -- water
                task.wait(20)

                pressE(0.5) -- sugar
                task.wait(1)

                pressE(0.5) -- gelatin
                task.wait(45)

                if equipBag() then
                    pressE(0.5)
                end

                safeTP(POS_SELL)
                pressE(1)
            end
        end
    end
end)

-- ================= ANTI KILL =================
local last = hum.Health
hum.HealthChanged:Connect(function(h)
    if _G.AntiKill and h < last then
        safeTP(SAFE_POS)
    end
    last = h
end)

-- ================= NOCLIP =================
RunService.Stepped:Connect(function()
    if _G.NoClip then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ================= UI BUTTON =================
makeBtn("Auto Cook: OFF", 50, function(btn)
    _G.AutoCook = not _G.AutoCook
    btn.Text = _G.AutoCook and "Auto Cook: ON" or "Auto Cook: OFF"
end)

makeBtn("Anti Kill: OFF", 90, function(btn)
    _G.AntiKill = not _G.AntiKill
    btn.Text = _G.AntiKill and "Anti Kill: ON" or "Anti Kill: OFF"
end)

makeBtn("Noclip: OFF", 130, function(btn)
    _G.NoClip = not _G.NoClip
    btn.Text = _G.NoClip and "Noclip: ON" or "Noclip: OFF"
end)

makeSlider("Buy Amount", 170, 5, 50, 10, function(v)
    _G.BuyAmount = v
end)

print("✅ LANGZ HUB FULL LOADED 🔥")
