-- ================================================
-- 🔥 LANGZ HUB V6 - NEON SMALL UI + MANUAL COOK
-- DEVELOPER: LANG MPRUY | SINCE 2026
-- ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

local POS_DEALER     = CFrame.new(510, 3, 608)
local POS_SELL       = CFrame.new(1175, 20, 30)
local POS_APT_CASINO = CFrame.new(1190, 3, -243)

_G.AutoCook  = false
_G.AutoBuy   = false   -- NEW
_G.AntiKill  = false   -- NEW
_G.BuyAmount = 10
_G.WalkSpeed = 16

-- Harga bahan
local HARGA = {
    ["Water"]       = 20,
    ["Gelatin"]     = 70,
    ["Sugar Block"] = 100,
}

-- ================= SMALL NEON GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "LangzHubV6"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.35, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(9, 9, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 255, 220)
stroke.Thickness = 3
stroke.Transparency = 0.15

-- HEADER + MINIMIZE
local header = Instance.new("TextButton", main)
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(18, 18, 35)
header.Text = "🌌 LANGZ HUB V6"
header.TextColor3 = Color3.fromRGB(0, 255, 220)
header.TextScaled = true
header.Font = Enum.Font.GothamBold

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0, 14)

local headerStroke = Instance.new("UIStroke", header)
headerStroke.Color = Color3.fromRGB(0, 255, 255)
headerStroke.Thickness = 2.5

local minimized = false
local FULL_SIZE = UDim2.new(0, 360, 0, 480)
header.MouseButton1Click:Connect(function()
    minimized = not minimized
    main.Size = minimized and UDim2.new(0, 360, 0, 45) or FULL_SIZE
end)

-- ================= TAB SYSTEM =================
local tabs = {}
local function createTab(name, x)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0, 110, 0, 32)
    btn.Position = UDim2.new(0, x, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 255, 220)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold

    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(1, -30, 1, -95)
    frame.Position = UDim2.new(0, 15, 0, 90)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabs) do f.Visible = false end
        frame.Visible = true
    end)

    table.insert(tabs, frame)
    return frame
end

local tabMain   = createTab("MAIN", 10)
local tabTP     = createTab("TELEPORT", 125)
local tabCredit = createTab("CREDIT", 245)
tabMain.Visible = true

-- ================= HELPER FUNCTIONS =================
local function pressE(holdTime)
    holdTime = holdTime or 0.12
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(holdTime)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function holdE(seconds)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(seconds)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

local function safeTP(cf)
    for i = 1, 4 do
        if hrp and hrp.Parent then
            hrp.CFrame = cf + Vector3.new(0, 5, 0)
        end
        task.wait(0.25)
    end
end

local function getInv(name)
    local count = 0
    for _, v in pairs(player.Backpack:GetChildren()) do
        if v.Name:lower():find(name:lower()) then count += 1 end
    end
    return count
end

local function equipEmptyBag()
    local names = {"Empty Bag", "Bag", "EmptyBag", "Trash Bag"}
    for _, n in ipairs(names) do
        local bag = player.Backpack:FindFirstChild(n)
            or (player.Character and player.Character:FindFirstChild(n))
        if bag then
            if bag.Parent ~= player.Character then
                hum:EquipTool(bag)
                task.wait(0.4)
            end
            return true
        end
    end
    return false
end

-- ================= ANTI KILL (Auto TP saat kena damage) =================
local lastHealth = hum.Health
local antiKillCooldown = false

RunService.Heartbeat:Connect(function()
    if not _G.AntiKill then
        lastHealth = hum.Health
        return
    end

    local currentHealth = hum.Health
    if currentHealth < lastHealth and not antiKillCooldown then
        antiKillCooldown = true
        print("💀 Kena damage! Auto TP ke Apt Casino...")
        safeTP(POS_APT_CASINO)
        task.wait(3) -- cooldown 3 detik biar ga spam TP
        antiKillCooldown = false
    end
    lastHealth = currentHealth
end)

-- Respawn handler
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    hrp = newChar:WaitForChild("HumanoidRootPart")
    hum = newChar:WaitForChild("Humanoid")
    lastHealth = hum.Health
    antiKillCooldown = false
end)

-- ================= AUTO BUY (Deteksi harga di UI dealer) =================
-- Auto Buy loop: kalau stok bahan kurang DAN dekat dealer, hold E buat beli
local buyInProgress = false
task.spawn(function()
    while task.wait(1) do
        if not _G.AutoBuy then continue end
        if buyInProgress then continue end

        local needBuy = getInv("Water") < 5 or getInv("Gelatin") < 2 or getInv("Sugar") < 2
        if not needBuy then continue end

        local distToDealer = (hrp.Position - POS_DEALER.Position).Magnitude
        if distToDealer > 30 then continue end

        buyInProgress = true
        print("🛒 Auto Buy di Dealer...")
        print(string.format("   💧 Water      = %d (Harga: %d ea)", getInv("Water"), HARGA["Water"]))
        print(string.format("   🧪 Gelatin     = %d (Harga: %d ea)", getInv("Gelatin"), HARGA["Gelatin"]))
        print(string.format("   🍬 Sugar Block = %d (Harga: %d ea)", getInv("Sugar"), HARGA["Sugar Block"]))

        -- Interact dealer (hold E 2 detik buka menu)
        holdE(2)
        task.wait(0.8)

        -- Beli sesuai kebutuhan dengan tap E per item
        for i = 1, _G.BuyAmount do
            if not _G.AutoBuy then break end
            pressE(0.1)
            task.wait(0.25)
        end

        task.wait(0.5)
        buyInProgress = false
    end
end)

-- ================= MANUAL AUTO COOK =================
task.spawn(function()
    while task.wait(0.6) do
        if not _G.AutoCook then continue end

        hum.WalkSpeed = _G.WalkSpeed

        local pot = workspace:FindFirstChild("Pot")
        local distToPot = pot and (hrp.Position - pot:GetPivot().Position).Magnitude or 9999

        if pot and distToPot < 35 then
            print("💧 Masukkan Air...")
            pressE()
            task.wait(2)
            task.wait(20)

            print("🍬 Masukkan Sugar Block...")
            pressE()
            task.wait(1.5)
            print("🧪 Masukkan Gelatin...")
            pressE()
            task.wait(1.5)

            print("⏳ Proses 45 detik...")
            for i = 1, 45 do
                if not _G.AutoCook then break end
                task.wait(1)
            end

            equipEmptyBag()
            print("📦 Ambil hasil...")
            pressE()
            task.wait(1.8)

            print("💰 Pergi jual...")
            safeTP(POS_SELL)
            task.wait(0.7)
            equipEmptyBag()
            pressE()
            task.wait(1.2)
        end
    end
end)

-- ================= UI HELPERS =================
local function makeButton(parent, text, y, color)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 310, 0, 44)
    btn.Position = UDim2.new(0, 25, 0, y)
    btn.BackgroundColor3 = color or Color3.fromRGB(25, 25, 45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 255, 220)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(0, 255, 220)
    s.Thickness = 1.5
    return btn
end

local function makeSlider(parent, text, y, minVal, maxVal, default, callback)
    local val = default
    local label = Instance.new("TextLabel", parent)
    label.Size = UDim2.new(0, 310, 0, 22)
    label.Position = UDim2.new(0, 25, 0, y)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. val
    label.TextColor3 = Color3.fromRGB(0, 255, 220)
    label.TextScaled = true
    label.Font = Enum.Font.GothamSemibold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local bar = Instance.new("Frame", parent)
    bar.Size = UDim2.new(0, 310, 0, 12)
    bar.Position = UDim2.new(0, 25, 0, y + 28)
    bar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((val - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 220)

    local dragging = false
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging then
            local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            val = math.floor(minVal + (maxVal - minVal) * pos)
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

local function makeIndicator(parent, text, y)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0, 310, 0, 24)
    lbl.Position = UDim2.new(0, 25, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(180, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    return lbl
end

-- ================= TAB 1 - MAIN =================

-- AUTO COOK Button
local cookBtn = makeButton(tabMain, "AUTO COOK: OFF", 5)
cookBtn.MouseButton1Click:Connect(function()
    _G.AutoCook = not _G.AutoCook
    cookBtn.Text = _G.AutoCook and "AUTO COOK: ON ✅" or "AUTO COOK: OFF"
    cookBtn.BackgroundColor3 = _G.AutoCook
        and Color3.fromRGB(0, 60, 50)
        or Color3.fromRGB(25, 25, 45)
end)

-- AUTO BUY Button (NEW)
local buyBtn = makeButton(tabMain, "AUTO BUY: OFF", 57)
buyBtn.MouseButton1Click:Connect(function()
    _G.AutoBuy = not _G.AutoBuy
    buyBtn.Text = _G.AutoBuy and "AUTO BUY: ON ✅" or "AUTO BUY: OFF"
    buyBtn.BackgroundColor3 = _G.AutoBuy
        and Color3.fromRGB(0, 60, 50)
        or Color3.fromRGB(25, 25, 45)
end)

-- ANTI KILL Button (NEW)
local akBtn = makeButton(tabMain, "ANTI KILL: OFF", 109)
akBtn.MouseButton1Click:Connect(function()
    _G.AntiKill = not _G.AntiKill
    akBtn.Text = _G.AntiKill and "ANTI KILL: ON ✅" or "ANTI KILL: OFF"
    akBtn.BackgroundColor3 = _G.AntiKill
        and Color3.fromRGB(60, 0, 0)
        or Color3.fromRGB(25, 25, 45)
    lastHealth = hum.Health -- reset referensi HP
end)

-- Sliders
makeSlider(tabMain, "Buy Amount", 162, 5, 50, 10, function(v) _G.BuyAmount = v end)
makeSlider(tabMain, "WalkSpeed",  217, 16, 100, 16, function(v) _G.WalkSpeed = v end)

-- Harga Info Label
local hargaLbl = makeIndicator(tabMain, "💰 Water:$20 | Gelatin:$70 | Sugar:$100", 274)
hargaLbl.TextColor3 = Color3.fromRGB(255, 220, 0)

-- Inventory Indicators
local waterLbl   = makeIndicator(tabMain, "Water / Air     : 0", 300)
local sugarLbl   = makeIndicator(tabMain, "Sugar Block     : 0", 322)
local gelatinLbl = makeIndicator(tabMain, "Gelatin         : 0", 344)
local marshLbl   = makeIndicator(tabMain, "Marshmallow     : 0", 366)
local pingLbl    = makeIndicator(tabMain, "Ping            : -- ms", 388)

RunService.RenderStepped:Connect(function()
    if not tabMain.Visible then return end
    waterLbl.Text   = "Water / Air     : " .. getInv("Water")
    sugarLbl.Text   = "Sugar Block     : " .. getInv("Sugar")
    gelatinLbl.Text = "Gelatin         : " .. getInv("Gelatin")
    marshLbl.Text   = "Marshmallow     : " .. getInv("Marshmallow")
    local ping = 0
    pcall(function()
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    pingLbl.Text = "Ping            : " .. math.floor(ping) .. " ms"
end)

-- ================= TAB 2 - TELEPORT =================
local tpList = {
    {"MS Dealer",     POS_DEALER},
    {"Casino / Sell", POS_SELL},
    {"Apt Casino",    CFrame.new(1190, 3, -243)},
    {"Apt Sampah 1",  CFrame.new(902, 10, 72)},
    {"Apt Sampah 2",  CFrame.new(931, 10, 72)},
    {"Apt Tier 1",    CFrame.new(1018, 10, 243)},
    {"Apt Tier 2",    CFrame.new(1018, 10, 214)},
    {"Apt RS 2",      CFrame.new(1108, 10, 427)},
    {"Apt RS 1",      CFrame.new(1109, 10, 456)},
}

local y = 10
for _, loc in ipairs(tpList) do
    local tpBtn = makeButton(tabTP, loc[1], y)
    tpBtn.MouseButton1Click:Connect(function()
        safeTP(loc[2])
    end)
    y += 46
end

-- ================= TAB 3 - CREDIT =================
local cred = Instance.new("TextLabel", tabCredit)
cred.Size = UDim2.new(0, 310, 0, 300)
cred.Position = UDim2.new(0, 25, 0, 30)
cred.BackgroundTransparency = 1
cred.Text = "Developer : LANG MPRUY\nSince 2026\n\nTerima kasih telah pakai\nLangz Hub V6!\n\n✅ Auto Cook Manual Style\n✅ Auto Buy + Deteksi Harga\n✅ Anti Kill (Auto TP)\n✅ Neon Small UI"
cred.TextColor3 = Color3.fromRGB(0, 255, 220)
cred.TextScaled = true
cred.Font = Enum.Font.Gotham
cred.TextXAlignment = Enum.TextXAlignment.Left
cred.TextYAlignment = Enum.TextYAlignment.Top

print("✅ LANGZ HUB V6 LOADED - AutoBuy + AntiKill + Manual Cook Ready!")
