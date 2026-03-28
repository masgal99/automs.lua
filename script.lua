-- ==================== LH SCRIPT - MOBILE COMPACT v3 ====================

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
    StarterGui:SetCore("SendNotification", {Title = title, Text = text, Duration = 2.5})
end

local function playNotif()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://131057516"
    s.Volume = 0.6
    s.Parent = SoundService
    s:Play()
    task.delay(1.2, function() s:Destroy() end)
end

-- ==================== GUI SUPER COMPACT ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LHScript"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = lp:WaitForChild("PlayerGui")

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0.42, 0, 0.65, 0)        -- Lebar kecil, tinggi sedang
Main.Position = UDim2.new(0.02, 0, 0.18, 0)    -- Mulai dari kiri
Main.BackgroundColor3 = CFG.NAVY
Main.BackgroundTransparency = 0.25
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", Main)
stroke.Color = CFG.CRIMSON
stroke.Thickness = 1.8

-- Header kecil
local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(11, 16, 38)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 8, 0, 0)
Title.Text = "LH SCRIPT"
Title.TextColor3 = CFG.CRIMSON
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Minimize Button (di kiri luar)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
ToggleBtn.Size = UDim2.new(0, 42, 0, 42)
ToggleBtn.Position = UDim2.new(0, 5, 0.5, -21)
ToggleBtn.BackgroundColor3 = CFG.CRIMSON
ToggleBtn.Text = "<"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 24
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0.5, 0)

-- Content
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -12, 1, -42)
Content.Position = UDim2.new(0, 6, 0, 38)
Content.BackgroundTransparency = 1

-- Sidebar Tab (vertikal)
local Sidebar = Instance.new("Frame", Content)
Sidebar.Size = UDim2.new(0.32, 0, 1, 0)
Sidebar.BackgroundTransparency = 1

local FarmTab = Instance.new("TextButton", Sidebar)
FarmTab.Size = UDim2.new(1, 0, 0, 38)
FarmTab.Position = UDim2.new(0, 0, 0, 0)
FarmTab.BackgroundColor3 = CFG.ACTIVE_BLACK
FarmTab.Text = "FARM"
FarmTab.TextColor3 = Color3.new(1,1,1)
FarmTab.Font = Enum.Font.GothamBold
FarmTab.TextSize = 13
Instance.new("UICorner", FarmTab).CornerRadius = UDim.new(0, 6)

local FeaturesTab = Instance.new("TextButton", Sidebar)
FeaturesTab.Size = UDim2.new(1, 0, 0, 38)
FeaturesTab.Position = UDim2.new(0, 0, 0, 45)
FeaturesTab.BackgroundColor3 = CFG.GLASS_LIGHT
FeaturesTab.Text = "FEATURES"
FeaturesTab.TextColor3 = Color3.new(1,1,1)
FeaturesTab.Font = Enum.Font.GothamBold
FeaturesTab.TextSize = 13
Instance.new("UICorner", FeaturesTab).CornerRadius = UDim.new(0, 6)

-- Farm Content
local FarmContent = Instance.new("Frame", Content)
FarmContent.Size = UDim2.new(0.65, 0, 1, 0)
FarmContent.Position = UDim2.new(0.35, 0, 0, 0)
FarmContent.BackgroundTransparency = 1
FarmContent.Visible = true

-- Indicators (compact)
local Indicators = Instance.new("Frame", FarmContent)
Indicators.Size = UDim2.new(1,0,0,52)
Indicators.Position = UDim2.new(0,0,0,0)
Indicators.BackgroundTransparency = 1

local IndLayout = Instance.new("UIListLayout", Indicators)
IndLayout.FillDirection = Enum.FillDirection.Horizontal
IndLayout.Padding = UDim.new(0, 4)
IndLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createIndicator(name, color)
    local f = Instance.new("Frame", Indicators)
    f.Size = UDim2.new(0.24,0,1,0)
    f.BackgroundColor3 = CFG.GLASS
    f.BackgroundTransparency = 0.6
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,6)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,0.4,0)
    lbl.Text = name
    lbl.TextColor3 = CFG.TEXT
    lbl.Font = Enum.Font.GothamSemibold
    lbl.TextSize = 10
    lbl.BackgroundTransparency = 1

    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(1,0,0.6,0)
    val.Position = UDim2.new(0,0,0.4,0)
    val.Text = "0"
    val.TextColor3 = color
    val.Font = Enum.Font.GothamBold
    val.TextSize = 14
    val.BackgroundTransparency = 1
    return val
end

local waterVal   = createIndicator("W", Color3.fromRGB(100,190,255))
local sugarVal   = createIndicator("S", Color3.fromRGB(255,220,80))
local gelatinVal = createIndicator("G", Color3.fromRGB(200,100,255))
local mallowVal  = createIndicator("M", Color3.fromRGB(255,120,120))

-- Auto Cook & Sell (kotak kecil)
local cookBtn = Instance.new("TextButton", FarmContent)
cookBtn.Size = UDim2.new(0.95,0,0,32)
cookBtn.Position = UDim2.new(0.025,0,0,60)
cookBtn.BackgroundColor3 = CFG.GLASS_LIGHT
cookBtn.Text = "COOK OFF"
cookBtn.TextColor3 = CFG.CRIMSON
cookBtn.Font = Enum.Font.GothamBold
cookBtn.TextSize = 12
Instance.new("UICorner", cookBtn).CornerRadius = UDim.new(0,6)

local sellBtn = Instance.new("TextButton", FarmContent)
sellBtn.Size = UDim2.new(0.95,0,0,32)
sellBtn.Position = UDim2.new(0.025,0,0,98)
sellBtn.BackgroundColor3 = CFG.GLASS_LIGHT
sellBtn.Text = "SELL OFF"
sellBtn.TextColor3 = CFG.CRIMSON
sellBtn.Font = Enum.Font.GothamBold
sellBtn.TextSize = 12
Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0,6)

-- Features Content
local FeaturesContent = Instance.new("Frame", Content)
FeaturesContent.Size = UDim2.new(0.65, 0, 1, 0)
FeaturesContent.Position = UDim2.new(0.35, 0, 0, 0)
FeaturesContent.BackgroundTransparency = 1
FeaturesContent.Visible = false

local fpsBtn = Instance.new("TextButton", FeaturesContent)
fpsBtn.Size = UDim2.new(0.95,0,0,32)
fpsBtn.Position = UDim2.new(0.025,0,0,10)
fpsBtn.BackgroundColor3 = CFG.GLASS_LIGHT
fpsBtn.Text = "FPS Boost"
fpsBtn.TextColor3 = CFG.CRIMSON
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.TextSize = 12
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0,6)

local espBtn = Instance.new("TextButton", FeaturesContent)
espBtn.Size = UDim2.new(0.95,0,0,32)
espBtn.Position = UDim2.new(0.025,0,0,50)
espBtn.BackgroundColor3 = CFG.GLASS_LIGHT
espBtn.Text = "ESP OFF"
espBtn.TextColor3 = CFG.CRIMSON
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 12
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,6)

-- ==================== ANIMASI & LOGIC ====================
local function tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.25, Enum.EasingStyle.Quint), props):Play()
end

-- Tab Switch
FarmTab.MouseButton1Click:Connect(function()
    tween(FarmTab, {BackgroundColor3 = CFG.ACTIVE_BLACK})
    tween(FeaturesTab, {BackgroundColor3 = CFG.GLASS_LIGHT})
    FarmContent.Visible = true
    FeaturesContent.Visible = false
end)

FeaturesTab.MouseButton1Click:Connect(function()
    tween(FeaturesTab, {BackgroundColor3 = CFG.ACTIVE_BLACK})
    tween(FarmTab, {BackgroundColor3 = CFG.GLASS_LIGHT})
    FarmContent.Visible = false
    FeaturesContent.Visible = true
end)

-- Minimize dengan slide kiri-kanan
local isMinimized = false
ToggleBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        tween(Main, {Position = UDim2.new(-0.5, 0, Main.Position.Y.Scale, Main.Position.Y.Offset)}, 0.4)
        ToggleBtn.Text = ">"
    else
        tween(Main, {Position = UDim2.new(0.02, 0, Main.Position.Y.Scale, Main.Position.Y.Offset)}, 0.4)
        ToggleBtn.Text = "<"
    end
end)

-- Inventory Update (compact)
local function updateInv()
    local inv = {w=0,s=0,g=0,m=0}
    local items = lp.Backpack:GetChildren()
    if lp.Character then
        for _,v in ipairs(lp.Character:GetChildren()) do
            if v:IsA("Tool") then table.insert(items,v) end
        end
    end
    for _,item in ipairs(items) do
        local n = item.Name:lower()
        if n:find("water") then inv.w +=1
        elseif n:find("sugar") then inv.s +=1
        elseif n:find("gelatin") then inv.g +=1
        elseif n:find("marshmallow") or n:find("mallow") then inv.m +=1 end
    end
    waterVal.Text = inv.w
    sugarVal.Text = inv.s
    gelatinVal.Text = inv.g
    mallowVal.Text = inv.m
end
RunService.Heartbeat:Connect(updateInv)

-- Auto Cook & Sell Logic (sederhana)
local function pressE() 
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) 
    task.wait(0.07)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game) 
end

local cookConn, sellConn

cookBtn.MouseButton1Click:Connect(function()
    State.autoCook = not State.autoCook
    cookBtn.Text = State.autoCook and "COOK ON" or "COOK OFF"
    cookBtn.TextColor3 = State.autoCook and CFG.GREEN or CFG.CRIMSON
    if State.autoCook then
        cookConn = RunService.Heartbeat:Connect(pressE)
        task.wait(1.1)
    else
        if cookConn then cookConn:Disconnect() end
    end
end)

sellBtn.MouseButton1Click:Connect(function()
    State.autoSell = not State.autoSell
    sellBtn.Text = State.autoSell and "SELL ON" or "SELL OFF"
    sellBtn.TextColor3 = State.autoSell and CFG.GREEN or CFG.CRIMSON
    if State.autoSell then
        sellConn = RunService.Heartbeat:Connect(function()
            if State.autoSell then pressE() task.wait(2) end
        end)
    else
        if sellConn then sellConn:Disconnect() end
    end
end)

-- FPS Boost
fpsBtn.MouseButton1Click:Connect(function()
    pcall(function()
        Lighting.Brightness = 1; Lighting.ClockTime = 12; Lighting.FogEnd = 999999; Lighting.GlobalShadows = false
        for _,v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") or v:IsA("BloomEffect") then v:Destroy() end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        sendNotif("FPS Boost", "Aktif!")
    end)
end)

-- Start
sendNotif("LH SCRIPT", "GUI Compact Mobile Loaded!")
playNotif()
