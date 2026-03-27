-- =====================================
-- 🔥 LANGZ HUB ⚪🔴🔵🟢 (MODERN UI)
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
_G.ESP = true
_G.ESP_Distance = true
_G.ESP_Health = true
_G.ESP_Skeleton = true
_G.ESP_Fill = true
_G.BuyAmount = 1
_G.WalkSpeed = 20

-- ================= UI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,360,0,420)
main.Position = UDim2.new(0.3,0,0.3,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true

-- HEADER
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1,0,0,35)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Langz Hub ⚪🔴🔵🟢"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- CLOSE
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0,30,0,25)
closeBtn.Position = UDim2.new(1,-35,0,5)
closeBtn.Text = "X"
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- MINIMIZE
local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0,30,0,25)
minimizeBtn.Position = UDim2.new(1,-70,0,5)
minimizeBtn.Text = "-"

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0,360,0,35) or UDim2.new(0,360,0,420)
end)

-- ================= TAB =================
local tabs = {}
local function createTab(name,x)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0,100,0,25)
    btn.Position = UDim2.new(0,x,0,40)
    btn.Text = name

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1,0,1,-80)
    frame.Position = UDim2.new(0,0,0,70)
    frame.Visible = false
    frame.BackgroundTransparency = 1

    btn.MouseButton1Click:Connect(function()
        for _,v in pairs(tabs) do v.Visible = false end
        frame.Visible = true
    end)

    table.insert(tabs, frame)
    return frame
end

local tab1 = createTab("Main",10)
local tab2 = createTab("Teleport",120)
local tab3 = createTab("Feature",230)
tab1.Visible = true

-- ================== ESP =======================
local drawings = {}

local function createESP(plr)
    drawings[plr] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        dist = Drawing.new("Text"),
        health = Drawing.new("Line"),
        skeleton = {}
    }

    drawings[plr].box.Thickness = 2
    drawings[plr].box.Filled = _G.ESP_Fill

    drawings[plr].name.Size = 13
    drawings[plr].dist.Size = 13

    -- skeleton lines
    for i=1,5 do
        drawings[plr].skeleton[i] = Drawing.new("Line")
    end
end

for _,p in pairs(Players:GetPlayers()) do
    if p ~= player then createESP(p) end
end

Players.PlayerAdded:Connect(createESP)

RunService.RenderStepped:Connect(function()
    for plr,esp in pairs(drawings) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and _G.ESP then

            local hrp2 = plr.Character.HumanoidRootPart
            local hum2 = plr.Character:FindFirstChild("Humanoid")

            local pos,vis = workspace.CurrentCamera:WorldToViewportPoint(hrp2.Position)

            if vis then
                local size = 60

                -- BOX
                esp.box.Visible = true
                esp.box.Size = Vector2.new(40,size)
                esp.box.Position = Vector2.new(pos.X-20,pos.Y-size/2)

                -- NAME
                esp.name.Visible = true
                esp.name.Text = plr.Name
                esp.name.Position = Vector2.new(pos.X,pos.Y-size/2-15)

                -- DISTANCE
                if _G.ESP_Distance then
                    local dist = (hrp.Position - hrp2.Position).Magnitude
                    esp.dist.Visible = true
                    esp.dist.Text = math.floor(dist).."m"
                    esp.dist.Position = Vector2.new(pos.X,pos.Y+size/2)
                else
                    esp.dist.Visible = false
                end

                -- HEALTH BAR
                if hum2 and _G.ESP_Health then
                    local hp = hum2.Health / hum2.MaxHealth
                    esp.health.Visible = true
                    esp.health.From = Vector2.new(pos.X-25,pos.Y+size/2)
                    esp.health.To = Vector2.new(pos.X-25,pos.Y+size/2 - (size*hp))
                else
                    esp.health.Visible = false
                end

                -- SKELETON (simple)
                if _G.ESP_Skeleton then
                    for _,line in pairs(esp.skeleton) do
                        line.Visible = true
                    end
                else
                    for _,line in pairs(esp.skeleton) do
                        line.Visible = false
                    end
                end

            else
                for _,v in pairs(esp) do
                    if typeof(v) == "table" then
                        for _,l in pairs(v) do l.Visible=false end
                    else
                        v.Visible=false
                    end
                end
            end
        end
    end
end)

-- ================= UI ELEMENT =================
local function makeBtn(parent,text,y,callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0,300,0,30)
    btn.Position = UDim2.new(0,20,0,y)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)

    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
end

-- 🎚 SLIDER REAL (DRAG)
local function makeSlider(parent,text,y,min,max,default,callback)
    local value = default

    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0,300,0,20)
    label.Position = UDim2.new(0,20,0,y)
    label.Text = text..": "..value
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local bar = Instance.new("Frame", parent)
    bar.Size = UDim2.new(0,300,0,10)
    bar.Position = UDim2.new(0,20,0,y+25)
    bar.BackgroundColor3 = Color3.fromRGB(50,50,50)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,170,255)

    local dragging = false

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
            pos = math.clamp(pos,0,1)

            fill.Size = UDim2.new(pos,0,1,0)
            value = math.floor(min + (max-min)*pos)

            label.Text = text..": "..value
            callback(value)
        end
    end)
end

-- ================= FUNCTIONS =================
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

-- ================= AUTO COOK =================
task.spawn(function()
    while task.wait(1) do
        if _G.AutoCook then
            hum.WalkSpeed = _G.WalkSpeed

            if getInv("Water") < 5 then
                safeTP(POS_DEALER)
                repeat pressE() task.wait(0.8)
                until getInv("Water") >= _G.BuyAmount
            end

            local pot = workspace:FindFirstChild("Pot")
            if pot then
                safeTP(pot:GetPivot())

                pressE() task.wait(20)
                pressE() task.wait(1)
                pressE()
                task.wait(45)
                pressE()

                safeTP(POS_SELL)
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
    _G.BuyAmount = v
end)

makeSlider(tab1,"WalkSpeed",120,16,100,16,function(v)
    _G.WalkSpeed = v
end)

-- ================= TAB 2 =================
local tpList = {
    {"Dealer",POS_DEALER},
    {"Casino",POS_SELL}
}

local y=10
for _,v in pairs(tpList) do
    makeBtn(tab2,v[1],y,function()
        safeTP(v[2])
    end)
    y+=35
end

-- ================= TAB 3 =================
makeBtn(tab3,"ESP: OFF",10,function(btn)
    _G.ESP = not _G.ESP
    btn.Text = _G.ESP and "ESP: ON" or "ESP: OFF"
end)

makeBtn(tab3,"Cek Inventory Player",50,function()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            print("== "..plr.Name.." ==")
            for _,i in pairs(plr.Backpack:GetChildren()) do
                print(i.Name)
            end
        end
    end
end)

print("✅ LANGZ HUB MODERN READY 🔥")
