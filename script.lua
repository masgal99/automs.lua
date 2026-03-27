-- =====================================
-- 🔥 LANGZ HUB ⚪🔴🔵🟢 FINAL GOD
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
local POS_SAFETY   = CFrame.new(1175,20,30)

_G.AutoCook = false
_G.BuyAmount = 10
_G.WalkSpeed = 16

-- ESP CONFIG
_G.ESP = false
_G.ESP_Distance = true
_G.ESP_Health = true
_G.ESP_Skeleton = true
_G.ESP_Fill = true

-- ================= UI NEON =================
local gui = Instance.new("ScreenGui", player.PlayerGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,380,0,440)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(10,10,10)
main.Active = true
main.Draggable = true

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0,170,255)
stroke.Thickness = 2

-- HEADER (MINIMIZE BAR)
local header = Instance.new("TextButton", main)
header.Size = UDim2.new(1,0,0,35)
header.Text = "Langz Hub ⚪🔴🔵🟢"
header.BackgroundColor3 = Color3.fromRGB(20,20,20)
header.TextColor3 = Color3.new(1,1,1)

local minimized = false
header.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0,200,0,35) or UDim2.new(0,380,0,440)
end)

-- ================= TAB =================
local tabs = {}

local function createTab(name,x)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0,110,0,25)
    btn.Position = UDim2.new(0,x,0,40)
    btn.Text = name

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1,0,1,-80)
    frame.Position = UDim2.new(0,0,0,70)
    frame.Visible = false
    frame.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(tabs) do v.Visible=false end
        frame.Visible=true
    end)

    table.insert(tabs, frame)
    return frame
end

local tab1 = createTab("Main",10)
local tab2 = createTab("Teleport",130)
local tab3 = createTab("Feature",250)
tab1.Visible = true

-- ================= UI ELEMENT =================
local function makeBtn(parent,text,y,callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0,320,0,30)
    b.Position = UDim2.new(0,20,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(25,25,25)

    b.MouseButton1Click:Connect(function()
        callback(b)
    end)
end

local function makeSlider(parent,text,y,min,max,default,callback)
    local val = default

    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0,320,0,20)
    label.Position = UDim2.new(0,20,0,y)
    label.Text = text..": "..val
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local bar = Instance.new("Frame", parent)
    bar.Size = UDim2.new(0,320,0,10)
    bar.Position = UDim2.new(0,20,0,y+25)
    bar.BackgroundColor3 = Color3.fromRGB(40,40,40)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((val-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

    local dragging = false

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=true end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging=false end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging then
            local pos = (i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X
            pos = math.clamp(pos,0,1)
            fill.Size = UDim2.new(pos,0,1,0)
            val = math.floor(min+(max-min)*pos)
            label.Text = text..": "..val
            callback(val)
        end
    end)
end

-- ================= FUNCTION =================
local function pressE()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function safeTP(cf)
    for i=1,3 do
        hrp.CFrame = cf + Vector3.new(0,3,0)
        task.wait(0.2)
    end
end

local function getInv(name)
    local c=0
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find(name:lower()) then c+=1 end
    end
    return c
end

-- ================= AUTO BUY =================
local function autoBuy()
    safeTP(POS_DEALER)
    repeat
        if not _G.AutoCook then break end
        pressE()
        task.wait(0.8)
    until getInv("Water")>=_G.BuyAmount 
       and getInv("Sugar")>=_G.BuyAmount 
       and getInv("Gelatin")>=_G.BuyAmount
end

-- ================= AUTO COOK =================
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoCook then

            hum.WalkSpeed = _G.WalkSpeed

            if getInv("Water")<5 or getInv("Sugar")<1 or getInv("Gelatin")<1 then
                autoBuy()
            end

            local pot = workspace:FindFirstChild("Pot")
            if pot then
                safeTP(pot:GetPivot())

                pressE()
                for i=1,20 do if not _G.AutoCook then break end task.wait(1) end
                pressE()
                task.wait(1)
                pressE()
                for i=1,45 do if not _G.AutoCook then break end task.wait(1) end

                pressE()
                safeTP(POS_SAFETY)
                pressE()
            end
        end
    end
end)

-- ================= TAB 1 =================
makeBtn(tab1,"Auto Cook: OFF",10,function(btn)
    _G.AutoCook = not _G.AutoCook
    btn.Text = _G.AutoCook and "Auto Cook: ON" or "Auto Cook: OFF"
end)

makeSlider(tab1,"Buy Amount",60,5,50,10,function(v)
    _G.BuyAmount=v
end)

makeSlider(tab1,"WalkSpeed",120,16,100,16,function(v)
    _G.WalkSpeed=v
end)

-- ================= TAB 2 =================
local tp = {
{"Dealer",POS_DEALER},{"Casino",POS_SAFETY},
{"Apt Casino",CFrame.new(1190,3,-243)},
{"Apt Sampah 1",CFrame.new(902,10,72)},
{"Apt Sampah 2",CFrame.new(931,10,72)},
{"Apt Tier 1",CFrame.new(1018,10,243)},
{"Apt Tier 2",CFrame.new(1018,10,214)},
{"Apt RS 2",CFrame.new(1108,10,427)},
{"Apt RS 1",CFrame.new(1109,10,456)},
}

local y=10
for _,v in pairs(tp) do
    makeBtn(tab2,v[1],y,function()
        safeTP(v[2])
    end)
    y+=35
end

-- ================= ESP =================
local drawings={}

RunService.RenderStepped:Connect(function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr~=player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then

            if not drawings[plr] then
                drawings[plr]=Drawing.new("Square")
            end

            local pos,vis = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)

            if _G.ESP and vis then
                drawings[plr].Visible=true
                drawings[plr].Size=Vector2.new(40,60)
                drawings[plr].Position=Vector2.new(pos.X-20,pos.Y-30)
                drawings[plr].Filled=_G.ESP_Fill
            else
                drawings[plr].Visible=false
            end
        end
    end
end)

-- ================= TAB 3 =================
makeBtn(tab3,"ESP: OFF",10,function(btn)
    _G.ESP = not _G.ESP
    btn.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
end)

print("✅ LANGZ HUB FINAL GOD READY 🔥")
