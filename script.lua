-- =====================================
-- 🔥 LANGZ HUB ⚪🔴🔵🟢 FINAL GOD - FIXED & CLEAN
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

_G.AutoCook = false
_G.BuyAmount = 10
_G.WalkSpeed = 16

-- ESP CONFIG
_G.ESP = false
_G.ESP_Fill = true

-- ================= UI NEON =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 460)
main.Position = UDim2.new(0.3, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.Active = true
main.Draggable = true

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

-- HEADER
local header = Instance.new("TextButton", main)
header.Size = UDim2.new(1,0,0,35)
header.Text = "Langz Hub ⚪🔴🔵🟢"
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.TextColor3 = Color3.new(1,1,1)
header.TextScaled = true

local minimized = false
header.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0,200,0,35) or UDim2.new(0,400,0,460)
end)

-- ================= TAB SYSTEM =================
local tabs = {}

local function createTab(name, xPos)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Position = UDim2.new(0, xPos, 0, 40)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    btn.TextColor3 = Color3.new(1,1,1)

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1, -20, 1, -90)
    frame.Position = UDim2.new(0, 10, 0, 80)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabs) do 
            v.Visible = false 
        end
        frame.Visible = true
    end)

    table.insert(tabs, frame)
    return frame
end

local tabMain = createTab("Main", 10)
local tabTP   = createTab("Teleport", 140)
local tabESP  = createTab("ESP & Others", 270)
tabMain.Visible = true

-- ================= UI HELPER =================
local function makeBtn(parent, text, y, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, 340, 0, 35)
    b.Position = UDim2.new(0, 20, 0, y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(30,30,30)
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true

    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

local function makeSlider(parent, text, y, min, max, default, callback)
    local val = default

    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0, 340, 0, 20)
    label.Position = UDim2.new(0, 20, 0, y)
    label.Text = text .. ": " .. val
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", parent)
    bar.Size = UDim2.new(0, 340, 0, 12)
    bar.Position = UDim2.new(0, 20, 0, y + 25)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((val-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

    local dragging = false

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging then
            local pos = (i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            pos = math.clamp(pos, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            val = math.floor(min + (max - min) * pos)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- ================= FUNCTION =================
local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.15)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function safeTP(cf)
    for i = 1, 4 do
        if hrp and hrp.Parent then
            hrp.CFrame = cf + Vector3.new(0, 4, 0)
        end
        task.wait(0.25)
    end
end

local function getInv(name)
    local c = 0
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find(name:lower()) then 
            c += 1 
        end
    end
    return c
end

-- ================= AUTO BUY =================
local function autoBuy()
    safeTP(POS_DEALER)
    repeat
        if not _G.AutoCook then break end
        pressE()
        task.wait(0.7)
    until getInv("Water") >= _G.BuyAmount and getInv("Sugar") >= _G.BuyAmount and getInv("Gelatin") >= _G.BuyAmount
end

-- ================= AUTO COOK LOOP =================
task.spawn(function()
    while task.wait(0.4) do
        if _G.AutoCook and hum and hum.Parent then
            hum.WalkSpeed = _G.WalkSpeed

            if getInv("Water") < 5 or getInv("Sugar") < 2 or getInv("Gelatin") < 2 then
                autoBuy()
            end

            local pot = workspace:FindFirstChild("Pot")
            if pot then
                safeTP(pot:GetPivot())

                pressE() -- buka pot
                for i = 1, 20 do 
                    if not _G.AutoCook then break end 
                    task.wait(0.8) 
                end
                
                pressE() -- tutup / proses
                task.wait(1.2)
                pressE()

                for i = 1, 45 do 
                    if not _G.AutoCook then break end 
                    task.wait(1) 
                end

                pressE() -- ambil hasil
                safeTP(POS_SELL)
                task.wait(0.5)
                pressE() -- jual
            end
        end
    end
end)

-- ================= TAB MAIN =================
makeBtn(tabMain, "Auto Cook: OFF", 10, function(btn)
    _G.AutoCook = not _G.AutoCook
    btn.Text = _G.AutoCook and "Auto Cook: ON" or "Auto Cook: OFF"
end)

makeSlider(tabMain, "Buy Amount", 60, 5, 50, 10, function(v)
    _G.BuyAmount = v
end)

makeSlider(tabMain, "WalkSpeed", 120, 16, 120, 16, function(v)
    _G.WalkSpeed = v
end)

-- ================= TAB TELEPORT =================
local tpList = {
    {"Dealer", POS_DEALER},
    {"Sell / Casino", POS_SELL},
    {"Apt Casino", CFrame.new(1190,3,-243)},
    {"Apt Sampah 1", CFrame.new(902,10,72)},
    {"Apt Sampah 2", CFrame.new(931,10,72)},
    {"Apt Tier 1", CFrame.new(1018,10,243)},
    {"Apt Tier 2", CFrame.new(1018,10,214)},
    {"Apt RS 2", CFrame.new(1108,10,427)},
    {"Apt RS 1", CFrame.new(1109,10,456)},
}

local y = 10
for _, v in ipairs(tpList) do
    makeBtn(tabTP, v[1], y, function()
        safeTP(v[2])
    end)
    y += 45
end

-- ================= ESP =================
local drawings = {}

RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not drawings[plr] then
                drawings[plr] = Drawing.new("Square")
                drawings[plr].Thickness = 2
                drawings[plr].Color = Color3.fromRGB(0, 255, 100)
            end

            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

            if _G.ESP and onScreen then
                drawings[plr].Visible = true
                drawings[plr].Size = Vector2.new(45, 70)
                drawings[plr].Position = Vector2.new(pos.X - 22, pos.Y - 35)
                drawings[plr].Filled = _G.ESP_Fill
            else
                drawings[plr].Visible = false
            end
        end
    end
end)

-- ================= TAB ESP =================
makeBtn(tabESP, "ESP Box: OFF", 10, function(btn)
    _G.ESP = not _G.ESP
    btn.Text = _G.ESP and "ESP Box: ON" or "ESP Box: OFF"
end)

makeBtn(tabESP, "ESP Filled: ON", 60, function(btn)
    _G.ESP_Fill = not _G.ESP_Fill
    btn.Text = _G.ESP_Fill and "ESP Filled: ON" or "ESP Filled: OFF"
end)

print("✅ LANGZ HUB FIXED & FITUR DIPISAH SIAP PAKAI 🔥")
