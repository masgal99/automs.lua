-- ==================== LH SCRIPT - MOBILE OPTIMIZED v2 ====================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
task.wait(1)

local CFG = {
    CRIMSON = Color3.fromRGB(255, 45, 45),
    NAVY = Color3.fromRGB(14, 20, 45),
    GLASS = Color3.fromRGB(18, 23, 52),
    GLASS_LIGHT = Color3.fromRGB(28, 38, 75),
    TEXT = Color3.fromRGB(220, 220, 240),
    ACTIVE_BLACK = Color3.fromRGB(25, 25, 35),
    GREEN = Color3.fromRGB(80, 200, 80)
}

local State = { autoCook = false, autoSell = false, espEnabled = false }

local function sendNotif(title, text)
    StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 3})
end

local function playNotif()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://131057516"
    s.Volume = 0.6
    s.Parent = SoundService
    s:Play()
    task.delay(1.5, function() s:Destroy() end)
end

-- ==================== GUI LEBIH KECIL & RESPONSIVE ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LHScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.88, 0, 0.58, 0)      -- Lebih kecil
Main.Position = UDim2.new(0.06, 0, 0.21, 0)
Main.BackgroundColor3 = CFG.NAVY
Main.BackgroundTransparency = 0.25
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = CFG.CRIMSON
stroke.Thickness = 2

-- Header
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(11, 16, 38)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.Text = "LH SCRIPT"
Title.TextColor3 = CFG.CRIMSON
Title.Font = Enum.Font.GothamBold
Title.TextSize = 19
Title.BackgroundTransparency = 1

-- Toggle Minimize
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 12, 0.5, -24)
ToggleBtn.BackgroundColor3 = CFG.CRIMSON
ToggleBtn.Text = "<"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 26
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0.5, 0)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -16, 1, -50)
Content.Position = UDim2.new(0, 8, 0, 46)
Content.BackgroundTransparency = 1

-- Tabs
local FarmTab = Instance.new("TextButton", Content)
FarmTab.Size = UDim2.new(0.48, 0, 0, 34)
FarmTab.Position = UDim2.new(0, 0, 0, 0)
FarmTab.BackgroundColor3 = CFG.ACTIVE_BLACK
FarmTab.Text = "FARM"
FarmTab.TextColor3 = Color3.new(1,1,1)
FarmTab.Font = Enum.Font.GothamBold
FarmTab.TextSize = 14
Instance.new("UICorner", FarmTab).CornerRadius = UDim.new(0, 8)

local FeaturesTab = Instance.new("TextButton", Content)
FeaturesTab.Size = UDim2.new(0.48, 0, 0, 34)
FeaturesTab.Position = UDim2.new(0.52, 0, 0, 0)
FeaturesTab.BackgroundColor3 = CFG.GLASS_LIGHT
FeaturesTab.Text = "FEATURES"
FeaturesTab.TextColor3 = Color3.new(1,1,1)
FeaturesTab.Font = Enum.Font.GothamBold
FeaturesTab.TextSize = 14
Instance.new("UICorner", FeaturesTab).CornerRadius = UDim.new(0, 8)

-- ==================== FARM TAB ====================
local FarmContent = Instance.new("Frame", Content)
FarmContent.Size = UDim2.new(1,0,1,0)
FarmContent.BackgroundTransparency = 1
FarmContent.Visible = true

-- Digital Indicators
local Indicators = Instance.new("Frame", FarmContent)
Indicators.Size = UDim2.new(1,0,0,68)
Indicators.Position = UDim2.new(0,0,0,5)
Indicators.BackgroundTransparency = 1

local IndLayout = Instance.new("UIListLayout", Indicators)
IndLayout.FillDirection = Enum.FillDirection.Horizontal
IndLayout.Padding = UDim.new(0,8)
IndLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createIndicator(name, color)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0.24,0,1,0)
    f.BackgroundColor3 = CFG.GLASS
    f.BackgroundTransparency = 0.5
    f.Parent = Indicators
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,0.45,0)
    lbl.Text = name
    lbl.TextColor3 = CFG.TEXT
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 12
    lbl.BackgroundTransparency = 1

    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(1,0,0.55,0)
    val.Position = UDim2.new(0,0,0.45,0)
    val.Text = "0"
    val.TextColor3 = color
    val.Font = Enum.Font.GothamBold
    val.TextSize = 17
    val.BackgroundTransparency = 1
    return val
end

local waterVal   = createIndicator("Water", Color3.fromRGB(100,190,255))
local sugarVal   = createIndicator("Sugar", Color3.fromRGB(255,220,80))
local gelatinVal = createIndicator("Gelatin", Color3.fromRGB(200,100,255))
local mallowVal  = createIndicator("Mallow", Color3.fromRGB(255,120,120))

-- Buttons
local cookBtn = Instance.new("TextButton", FarmContent)
cookBtn.Size = UDim2.new(0.96,0,0,46)
cookBtn.Position = UDim2.new(0.02,0,0,85)
cookBtn.BackgroundColor3 = CFG.GLASS_LIGHT
cookBtn.Text = "AUTO COOK : OFF"
cookBtn.TextColor3 = CFG.CRIMSON
cookBtn.Font = Enum.Font.GothamBold
cookBtn.TextSize = 15
Instance.new("UICorner", cookBtn).CornerRadius = UDim.new(0,10)

local sellBtn = Instance.new("TextButton", FarmContent)
sellBtn.Size = UDim2.new(0.96,0,0,46)
sellBtn.Position = UDim2.new(0.02,0,0,140)
sellBtn.BackgroundColor3 = CFG.GLASS_LIGHT
sellBtn.Text = "AUTO SELL : OFF"
sellBtn.TextColor3 = CFG.CRIMSON
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 15
Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0,10)

-- ==================== FEATURES TAB ====================
local FeaturesContent = Instance.new("Frame", Content)
FeaturesContent.Size = UDim2.new(1,0,1,0)
FeaturesContent.BackgroundTransparency = 1
FeaturesContent.Visible = false

local fpsBtn = Instance.new("TextButton", FeaturesContent)
fpsBtn.Size = UDim2.new(0.96,0,0,46)
fpsBtn.Position = UDim2.new(0.02,0,0,20)
fpsBtn.BackgroundColor3 = CFG.GLASS_LIGHT
fpsBtn.Text = "FPS Boost"
fpsBtn.TextColor3 = CFG.CRIMSON
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.TextSize = 15
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0,10)

local espBtn = Instance.new("TextButton", FeaturesContent)
espBtn.Size = UDim2.new(0.96,0,0,46)
espBtn.Position = UDim2.new(0.02,0,0,80)
espBtn.BackgroundColor3 = CFG.GLASS_LIGHT
espBtn.Text = "ESP : OFF"
espBtn.TextColor3 = CFG.CRIMSON
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 15
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,10)

-- ==================== ANIMASI & TAB SWITCH ====================
local function tween(obj, prop, val, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint), prop):Play()
end

local function switchTab(toFarm)
    if toFarm then
        tween(FarmTab, {BackgroundColor3 = CFG.ACTIVE_BLACK}, nil, 0.2)
        tween(FeaturesTab, {BackgroundColor3 = CFG.GLASS_LIGHT}, nil, 0.2)
        FarmContent.Visible = true
        FeaturesContent.Visible = false
    else
        tween(FeaturesTab, {BackgroundColor3 = CFG.ACTIVE_BLACK}, nil, 0.2)
        tween(FarmTab, {BackgroundColor3 = CFG.GLASS_LIGHT}, nil, 0.2)
        FarmContent.Visible = false
        FeaturesContent.Visible = true
    end
end

FarmTab.MouseButton1Click:Connect(function() switchTab(true) end)
FeaturesTab.MouseButton1Click:Connect(function() switchTab(false) end)

-- Minimize dengan animasi
local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tween(Main, {Size = UDim2.new(0.88,0,0.12,0)}, nil, 0.35)
        ToggleBtn.Text = ">"
        task.wait(0.25)
        FarmContent.Visible = false
        FeaturesContent.Visible = false
    else
        tween(Main, {Size = UDim2.new(0.88,0,0.58,0)}, nil, 0.35)
        ToggleBtn.Text = "<"
        task.wait(0.2)
        FarmContent.Visible = true
    end
end)

-- ==================== INDICATOR UPDATE ====================
local function updateInventory()
    local inv = {water = 0, sugar = 0, gelatin = 0, marshmallow = 0}
    local items = lp.Backpack:GetChildren()
    if lp.Character then
        for _,v in ipairs(lp.Character:GetChildren()) do
            if v:IsA("Tool") then table.insert(items, v) end
        end
    end

    for _,item in ipairs(items) do
        local n = item.Name:lower()
        if n:find("water") then inv.water += 1
        elseif n:find("sugar") then inv.sugar += 1
        elseif n:find("gelatin") then inv.gelatin += 1
        elseif n:find("marshmallow") or n:find("mallow") or n:find("bag") then 
            inv.marshmallow += 1 
        end
    end

    waterVal.Text = inv.water
    sugarVal.Text = inv.sugar
    gelatinVal.Text = inv.gelatin
    mallowVal.Text = inv.marshmallow
end

RunService.Heartbeat:Connect(updateInventory)

-- ==================== LOGIC AUTO COOK & AUTO SELL ====================
local function pressE()
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.08)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function holdE(sec)
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(sec or 2.8)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- Auto Cook Loop
local cookConn
cookBtn.MouseButton1Click:Connect(function()
    State.autoCook = not State.autoCook
    cookBtn.Text = State.autoCook and "AUTO COOK : ON" or "AUTO COOK : OFF"
    cookBtn.TextColor3 = State.autoCook and CFG.GREEN or CFG.CRIMSON

    if State.autoCook then
        sendNotif("Auto Cook", "Aktif - Dekati Oven & Tekan E")
        cookConn = RunService.Heartbeat:Connect(function()
            if State.autoCook then
                pcall(pressE)
                task.wait(1.2)   -- sesuaikan delay sesuai game
            end
        end)
    else
        if cookConn then cookConn:Disconnect() end
    end
end)

-- Auto Sell Loop
local sellConn
sellBtn.MouseButton1Click:Connect(function()
    State.autoSell = not State.autoSell
    sellBtn.Text = State.autoSell and "AUTO SELL : ON" or "AUTO SELL : OFF"
    sellBtn.TextColor3 = State.autoSell and CFG.GREEN or CFG.CRIMSON

    if State.autoSell then
        sendNotif("Auto Sell", "Aktif - Dekati NPC Sell")
        sellConn = RunService.Heartbeat:Connect(function()
            if State.autoSell then
                pcall(holdE, 1.5)
                task.wait(2.5)
            end
        end)
    else
        if sellConn then sellConn:Disconnect() end
    end
end)

-- FPS Boost
fpsBtn.MouseButton1Click:Connect(function()
    pcall(function()
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 999999
        Lighting.GlobalShadows = false

        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") then
                v:Destroy()
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        sendNotif("FPS Boost", "Low Graphic + No Atmosphere ON!")
    end)
end)

-- ESP (placeholder)
espBtn.MouseButton1Click:Connect(function()
    State.espEnabled = not State.espEnabled
    espBtn.Text = State.espEnabled and "ESP : ON" or "ESP : OFF"
    sendNotif("ESP", State.espEnabled and "Diaktifkan" or "Dimatikan")
end)

-- Start
sendNotif("LH SCRIPT", "Mobile Optimized + Animasi + Logic Loaded!")
playNotif()
