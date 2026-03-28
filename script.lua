-- ============================================================
-- MARSHMELLOW FULL SYSTEM (ALL IN ONE)
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VIM = game:GetService("VirtualInputManager")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

lp.CharacterAdded:Connect(function(c)
    char = c
    hrp = c:WaitForChild("HumanoidRootPart")
end)

-- GLOBAL
_G.AutoCook = false
_G.StopCook = false
_G.AutoSell = false
_G.BuyAmount = 3
_G.ESP = false
_G.Speed = 16

-- ============================================================
-- TELEPORT UNDERGROUND
-- ============================================================
local LOCS = {
    ["Dealer"] = CFrame.new(510,3,600),
    ["Sampah 1"] = CFrame.new(898,10,38),
    ["Sampah 2"] = CFrame.new(923,10,41),
    ["Tier 1"] = CFrame.new(1142,10,425),
    ["Tier 2"] = CFrame.new(1142,10,291),
    ["RS 1"] = CFrame.new(1142,10,450),
    ["RS"] = CFrame.new(1050,3,520)
}

local function tp(cf)
    hrp.CFrame = cf - Vector3.new(0,5,0)
end

local function pressE(t)
    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(t or 0.1)
    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function getText(str)
    for _,v in pairs(lp.PlayerGui:GetDescendants()) do
        if (v:IsA("TextLabel") or v:IsA("TextButton")) and v.Visible then
            if v.Text:lower():find(str:lower()) then
                return v
            end
        end
    end
end

-- ============================================================
-- AUTO BUY
-- ============================================================
function AutoBuy()
    local npc = workspace:FindFirstChild("ShopPart") or workspace:FindFirstChild("NPC")
    if not npc then return end

    tp(npc.CFrame)
    task.wait(0.5)

    pressE(2)

    if getText("you the guy") then
        pressE()
        pressE()

        local items = {"Gelatin","Sugar Block","Water"}
        for _,item in ipairs(items) do
            if getText(item) then
                for i=1,_G.BuyAmount do
                    pressE()
                    task.wait(0.2)
                end
            end
        end
    end
end

-- ============================================================
-- AUTO COOK (FIX SESUAI FLOW GAME)
-- ============================================================
task.spawn(function()
    while task.wait(1) do
        if _G.AutoCook and not _G.StopCook then

            -- CEK ADA INTERACT
            if getText("interact") then
                
                -- =========================
                -- STEP 1: MASUKIN WATER
                -- =========================
                pressE(0.2)
                task.wait(20)

                if _G.StopCook then break end

                -- =========================
                -- STEP 2: MASUKIN SUGAR
                -- =========================
                if getText("Sugar") or getText("Sugar Block") then
                    pressE(0.2)
                    task.wait(1)
                end

                -- =========================
                -- STEP 3: MASUKIN GELATIN (JANGAN BARENG)
                -- =========================
                if getText("Gelatin") then
                    pressE(0.2)
                end

                -- =========================
                -- STEP 4: MASAK (45 DETIK)
                -- =========================
                for i = 1,45 do
                    if _G.StopCook then break end

                    -- EQUIP EMPTY BAG (ANTI BUG)
                    pcall(function()
                        local hum = lp.Character:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:EquipTool(nil)
                        end
                    end)

                    task.wait(1)
                end

                if _G.StopCook then break end

                -- =========================
                -- STEP 5: COLLECT
                -- =========================
                if getText("Collect") or getText("Take") then
                    pressE(0.2)
                end

                -- =========================
                -- STEP 6: VALIDASI INVENTORY
                -- =========================
                if getText("Marshmellow") then
                    -- berarti masuk inventory
                    print("✅ BERHASIL MASUK INVENTORY")
                end

            end
        end
    end
end)

-- ============================================================
-- AUTO SELL
-- ============================================================
task.spawn(function()
    while task.wait(2) do
        if _G.AutoSell then
            local npc = workspace:FindFirstChild("ShopPart") or workspace:FindFirstChild("NPC")
            if npc then
                tp(npc.CFrame)
                pressE(2)

                local items = {
                    "Small Marshmellow",
                    "Medium Marshmellow",
                    "Large Marshmellow"
                }

                for _,v in ipairs(items) do
                    if getText(v) then
                        pressE()
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- ESP FULL (BOX + HP + NAME)
-- ============================================================
local espColor = Color3.fromRGB(255,0,0)

function createESP(plr)
    if plr == lp then return end

    local function setup(char)
        if char:FindFirstChild("ESP") then return end

        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP"
        box.Size = Vector3.new(4,6,2)
        box.Color3 = espColor
        box.AlwaysOnTop = true
        box.Adornee = char
        box.Parent = char

        local bill = Instance.new("BillboardGui", char)
        bill.Size = UDim2.new(0,100,0,40)
        bill.AlwaysOnTop = true

        local txt = Instance.new("TextLabel", bill)
        txt.Size = UDim2.new(1,0,1,0)
        txt.BackgroundTransparency = 1
        txt.TextColor3 = espColor
        txt.TextScaled = true

        local hp = Instance.new("Frame", bill)
        hp.Size = UDim2.new(0.1,0,1,0)
        hp.Position = UDim2.new(-0.15,0,0,0)
        hp.BackgroundColor3 = Color3.fromRGB(0,255,0)

        RunService.RenderStepped:Connect(function()
            if _G.ESP and char:FindFirstChild("HumanoidRootPart") then
                local dist = (hrp.Position - char.HumanoidRootPart.Position).Magnitude
                txt.Text = plr.Name.." ["..math.floor(dist).."]"

                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hp.Size = UDim2.new(0.1,0,hum.Health/hum.MaxHealth,0)
                end
            else
                box.Visible = false
                bill.Enabled = false
            end
        end)
    end

    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end

for _,p in pairs(Players:GetPlayers()) do
    createESP(p)
end
Players.PlayerAdded:Connect(createESP)

-- ============================================================
-- WALKSPEED
-- ============================================================
RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChildOfClass("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = _G.Speed
    end
end)

-- ============================================================
-- GUI (RESIZE + MINIMIZE + SLIDER)
-- ============================================================
local sg = Instance.new("ScreenGui", lp.PlayerGui)

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0,300,0,400)
frame.Position = UDim2.new(0.7,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(20,0,0)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame)

local minimized = false

local function btn(txt, y, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-10,0,30)
    b.Position = UDim2.new(0,5,0,y)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(50,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
end

btn("AUTO BUY", 10, function() AutoBuy() end)

btn("AUTO COOK", 50, function()
    _G.AutoCook = not _G.AutoCook
    _G.StopCook = false
end)

btn("STOP COOK", 90, function()
    _G.StopCook = true
    _G.AutoCook = false
end)

btn("AUTO SELL", 130, function()
    _G.AutoSell = not _G.AutoSell
end)

btn("ESP", 170, function()
    _G.ESP = not _G.ESP
end)

btn("MINIMIZE", 210, function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0,120,0,30) or UDim2.new(0,300,0,400)
end)

-- WALK SPEED SLIDER
local slider = Instance.new("TextButton", frame)
slider.Size = UDim2.new(1,-10,0,30)
slider.Position = UDim2.new(0,5,0,250)
slider.Text = "Speed: 16-22"

slider.MouseButton1Click:Connect(function()
    _G.Speed = _G.Speed + 2
    if _G.Speed > 22 then _G.Speed = 16 end
    slider.Text = "Speed: ".._G.Speed
end)

print("FULL SYSTEM LOADED 🔥")
