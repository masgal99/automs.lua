-- ================================================
-- LANG SC 🔴🔵🟢 - ULTIMATE MODERN EDITION
-- ================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- CONFIG POSISI (Sesuaikan jika koordinat game berubah)
local POS_DEALER = CFrame.new(510, 3, 608)
local POS_SELL = CFrame.new(1175, 20, 30)

-- STATE VARIABLES
_G.AutoCook = false
_G.AutoBuy = false
_G.DeleteMode = false
_G.CookTarget = 10
_G.MinStok = 5

-- ================== UTILITY ==================

local function getInv(itemName)
    local count = 0
    local containers = {player.Backpack, player.Character}
    for _, container in pairs(containers) do
        if container then
            for _, item in pairs(container:GetChildren()) do
                if item.Name:lower():find(itemName:lower()) then count += 1 end
            end
        end
    end
    return count
end

local function tp(cf)
    if hrp then hrp.CFrame = cf + Vector3.new(0, 3, 0) end
    task.wait(0.5)
end

local function interactE(dur)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(dur or 0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- ================== CORE LOGIC ==================

-- Logika Masak Otomatis
task.spawn(function()
    local suksesMasak = 0
    while true do
        if _G.AutoCook then
            if suksesMasak < _G.CookTarget then
                -- Cek apakah butuh beli bahan dulu?
                if getInv("Water") == 0 or getInv("Sugar") == 0 or getInv("Gelatin") == 0 then
                    print("Bahan Kosong! Restock ke Dealer...")
                    tp(POS_DEALER)
                    interactE(3)
                    task.wait(1)
                end

                -- Mulai Masak
                local pot = workspace:FindFirstChild("Pot") or workspace:FindFirstChild("Water Machine")
                if pot then
                    tp(pot:GetPivot())
                    -- Step 1: Air
                    print("Step 1: Air...")
                    interactE(2)
                    task.wait(20) -- DELAY 20 DETIK SESUAI PERMINTAAN
                    
                    -- Step 2: Gula & Gelatin
                    print("Step 2: Gula & Gelatin...")
                    interactE(0.5) task.wait(0.8)
                    interactE(0.5) task.wait(0.8)
                    
                    -- Step 3: Tunggu Matang & Ambil
                    print("Menunggu Matang...")
                    task.wait(30)
                    interactE(0.5)
                    suksesMasak = suksesMasak + 1
                    
                    -- Step 4: Auto Sell
                    print("Auto Selling...")
                    tp(POS_SELL)
                    interactE(1)
                    task.wait(1)
                end
            else
                print("Target Masak Tercapai!")
                _G.AutoCook = false
                suksesMasak = 0
            end
        end
        task.wait(1)
    end
end)

-- Delete Object Mode
UIS.InputBegan:Connect(function(input, processed)
    if not processed and _G.DeleteMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = player:GetMouse().Target
        if target and target.Parent and not target:IsDescendantOf(player.Character) then
            target.Parent = nil
        end
    end
end)

-- ================== MODERN UI ==================

local sg = Instance.new("ScreenGui", player.PlayerGui)
sg.Name = "LangSC_V3"
sg.ResetOnSpawn = false

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 450)
main.Position = UDim2.new(0.5, -150, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)
local stroke = Instance.new("UIStroke", main); stroke.Color = Color3.fromRGB(0, 255, 150); stroke.Thickness = 2

-- Tab Container (Scrolling)
local container = Instance.new("ScrollingFrame", main)
container.Size = UDim2.new(1, -20, 1, -60)
container.Position = UDim2.new(0, 10, 0, 50)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 2
local layout = Instance.new("UIListLayout", container); layout.Padding = UDim.new(0, 12); layout.HorizontalAlignment = "Center"

-- Title & Close
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40); title.Text = "LANG SC 🔴🔵🟢"; title.TextColor3 = Color3.new(1,1,1); title.Font = "GothamBold"; title.BackgroundTransparency = 1
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0, 30, 0, 30); close.Position = UDim2.new(1, -35, 0, 5); close.Text = "X"; close.BackgroundColor3 = Color3.fromRGB(200, 50, 50); close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() sg:Destroy() end)

-- UI Helper Functions
local function createToggle(name, varName)
    local btn = Instance.new("TextButton", container)
    btn.Size = UDim2.new(0.9, 0, 0, 40); btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40); btn.Text = name .. ": OFF"; btn.TextColor3 = Color3.new(1,1,1); btn.Font = "GothamMedium"
    Instance.new("UICorner", btn)
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = name .. ": " .. (_G[varName] and "ON" or "OFF")
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 150, 80) or Color3.fromRGB(30, 30, 40)
    end)
end

local function createSlider(name, min, max, varName)
    local frame = Instance.new("Frame", container)
    frame.Size = UDim2.new(0.9, 0, 0, 55); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, 0, 0, 20); label.Text = name .. ": " .. _G[varName]; label.TextColor3 = Color3.new(1,1,1); label.BackgroundTransparency = 1
    local bar = Instance.new("Frame", frame); bar.Size = UDim2.new(1, 0, 0, 8); bar.Position = UDim2.new(0,0,0,30); bar.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    local fill = Instance.new("Frame", bar); fill.Size = UDim2.new(_G[varName]/max, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    local trigger = Instance.new("TextButton", bar); trigger.Size = UDim2.new(1,0,1,0); trigger.BackgroundTransparency = 1; trigger.Text = ""
    
    trigger.MouseButton1Down:Connect(function()
        local moveConn
        moveConn = RunService.RenderStepped:Connect(function()
            local mousePos = UIS:GetMouseLocation().X
            local rel = math.clamp((mousePos - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            _G[varName] = math.floor(min + (rel * (max - min)))
            label.Text = name .. ": " .. _G[varName]
            fill.Size = UDim2.new(rel, 0, 1, 0)
        end)
        UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then moveConn:Disconnect() end end)
    end)
end

-- BUILDING THE MENU
createToggle("AUTO COOK FULLY", "AutoCook")
createSlider("Target Masak", 1, 100, "CookTarget")
createSlider("Beli Jika Stok <", 1, 50, "MinStok")
createToggle("DELETE OBJECT MODE", "DeleteMode")

print("✅ LANG SC RELOADED SUCCESSFULLY!")
