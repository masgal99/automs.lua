-- ================================================
-- SCRIPT MT BY LANG - FULL INTERFACE & LOGIC
-- ================================================

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- STATE & SETTINGS
local autoCook = false
local deleteMode = false
local espEnabled = false
local deletedObjects = {}
local espObjects = {}

-- ITEM NAMES (Ganti jika nama di game berbeda)
local ITEM_AIR = "Water"
local ITEM_GULA = "Sugar"
local ITEM_GELATIN = "Gelatin"

-- ================== UTILITY FUNCTIONS ==================

local function getInvCount(plr, itemName)
    local count = 0
    local locations = {plr:FindFirstChild("Backpack"), plr.Character}
    for _, loc in pairs(locations) do
        if loc then
            for _, item in pairs(loc:GetChildren()) do
                if item.Name:lower():find(itemName:lower()) then count += 1 end
            end
        end
    end
    return count
end

local function teleportTo(cf)
    if not hrp then return end
    local target = typeof(cf) == "Vector3" and CFrame.new(cf) or cf
    hrp.CFrame = target + Vector3.new(0, 3, 0)
end

local function cariObjek(nama)
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name:lower():find(nama:lower()) and (v:IsA("BasePart") or v:IsA("Model")) then
            return v
        end
    end
    return nil
end

local function pressE(dur)
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(dur or 0.2)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end

-- ================== CORE FEATURES ==================

-- AUTO COOK LOGIC (TAB 1)
task.spawn(function()
    while true do
        if autoCook then
            if getInvCount(player, ITEM_AIR) > 0 and getInvCount(player, ITEM_GULA) > 0 and getInvCount(player, ITEM_GELATIN) > 0 then
                -- Step 1: Air
                local airObj = cariObjek("Water Machine") or cariObjek("Pot")
                if airObj then
                    teleportTo(airObj:GetPivot())
                    task.wait(0.5); pressE(2)
                    print("Air Masuk. Tunggu 20 Detik...")
                    task.wait(20) -- DELAY 20 DETIK SESUAI PERMINTAAN
                    
                    -- Step 2: Gula
                    local gulaObj = cariObjek("Sugar") or cariObjek("Pot")
                    teleportTo(gulaObj:GetPivot())
                    task.wait(0.5); pressE(0.5)
                    task.wait(1)
                    
                    -- Step 3: Gelatin
                    local gelObj = cariObjek("Gelatin") or cariObjek("Pot")
                    teleportTo(gelObj:GetPivot())
                    task.wait(0.5); pressE(0.5)
                    task.wait(1)
                    
                    -- Step 4: Ambil
                    task.wait(30) -- Tunggu Masak
                    local hasil = cariObjek("Collect") or cariObjek("Finished")
                    if hasil then teleportTo(hasil:GetPivot()); task.wait(0.5); pressE(0.5) end
                end
            else
                -- Auto Buy jika bahan habis
                local shop = cariObjek("Shop") or cariObjek("Dealer")
                if shop then teleportTo(shop:GetPivot()); task.wait(0.5); pressE(3); task.wait(1) end
            end
        end
        task.wait(1)
    end
end)

-- DELETE MODE (TAB 3)
UIS.InputBegan:Connect(function(input)
    if deleteMode and input.UserInputType == Enum.UserInputType.MouseButton1 then
        local target = player:GetMouse().Target
        if target and not target:IsDescendantOf(character) then
            local clone = target:Clone()
            table.insert(deletedObjects, {obj = target, parent = target.Parent, pos = target.CFrame})
            target.Parent = nil -- Pindahkan ke nil (bisa di undo)
        end
    end
end)

-- ESP PLAYER + INVENTORY (TAB 3)
local function updateESP()
    for _, item in pairs(espObjects) do item:Destroy() end
    espObjects = {}
    
    if not espEnabled then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local bill = Instance.new("BillboardGui", plr.Character.Head)
            bill.AlwaysOnTop = true
            bill.Size = UDim2.new(0, 100, 0, 50)
            bill.ExtentsOffset = Vector3.new(0, 3, 0)
            
            local lbl = Instance.new("TextLabel", bill)
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.TextStrokeTransparency = 0
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 12
            
            -- Cek Inven Player Lain
            local s = getInvCount(plr, "Sugar")
            local w = getInvCount(plr, "Water")
            local g = getInvCount(plr, "Gelatin")
            lbl.Text = string.format("%s\n[W:%d S:%d G:%d]", plr.Name, w, s, g)
            
            local hl = Instance.new("Highlight", plr.Character)
            hl.FillColor = Color3.fromRGB(255, 0, 0)
            
            table.insert(espObjects, bill)
            table.insert(espObjects, hl)
        end
    end
end

task.spawn(function()
    while task.wait(2) do if espEnabled then updateESP() end end
end)

-- ================== GUI UI KOTAK ==================
local sg = Instance.new("ScreenGui", player.PlayerGui)
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 300, 0, 400)
main.Position = UDim2.new(0.05, 0, 0.2, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
main.BorderSizePixel = 2
main.BorderColor3 = Color3.fromRGB(0, 255, 255)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "MT SCRIPT BY LANG"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

-- Tab Buttons
local t1 = Instance.new("TextButton", main) t1.Size = UDim2.new(0.33,0,0,30) t1.Position = UDim2.new(0,0,0,40) t1.Text = "MAIN"
local t2 = Instance.new("TextButton", main) t2.Size = UDim2.new(0.33,0,0,30) t2.Position = UDim2.new(0.33,0,0,40) t2.Text = "TP"
local t3 = Instance.new("TextButton", main) t3.Size = UDim2.new(0.34,0,0,30) t3.Position = UDim2.new(0.66,0,0,40) t3.Text = "EXTRA"

local p1 = Instance.new("ScrollingFrame", main) p1.Size = UDim2.new(1,0,1,-70) p1.Position = UDim2.new(0,0,0,70) p1.Visible = true
local p2 = Instance.new("ScrollingFrame", main) p2.Size = p1.Size p2.Position = p1.Position p2.Visible = false
local p3 = Instance.new("ScrollingFrame", main) p3.Size = p1.Size p3.Position = p1.Position p3.Visible = false

t1.MouseButton1Click:Connect(function() p1.Visible = true p2.Visible = false p3.Visible = false end)
t2.MouseButton1Click:Connect(function() p1.Visible = false p2.Visible = true p3.Visible = false end)
t3.MouseButton1Click:Connect(function() p1.Visible = false p2.Visible = false p3.Visible = true end)

-- BUTTONS TAB 1
local btnCook = Instance.new("TextButton", p1)
btnCook.Size = UDim2.new(0.9, 0, 0, 40)
btnCook.Position = UDim2.new(0.05, 0, 0, 10)
btnCook.Text = "AUTO MASAK: OFF"
btnCook.MouseButton1Click:Connect(function()
    autoCook = not autoCook
    btnCook.Text = "AUTO MASAK: " .. (autoCook and "ON" or "OFF")
    btnCook.BackgroundColor3 = autoCook and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
end)

-- BUTTONS TAB 2 (TP MANUAL)
local tpLocs = {{"Dealer", Vector3.new(510, 3, 608)}, {"Casino", Vector3.new(1175, 20, 30)}, {"Shop", Vector3.new(900, 3, 70)}}
for i, v in pairs(tpLocs) do
    local b = Instance.new("TextButton", p2)
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, (i-1)*40 + 10)
    b.Text = "Teleport to " .. v[1]
    b.MouseButton1Click:Connect(function() teleportTo(v[2]) end)
end

-- BUTTONS TAB 3
local btnDel = Instance.new("TextButton", p3)
btnDel.Size = UDim2.new(0.9, 0, 0, 40)
btnDel.Position = UDim2.new(0.05, 0, 0, 10)
btnDel.Text = "DELETE MODE: OFF"
btnDel.MouseButton1Click:Connect(function()
    deleteMode = not deleteMode
    btnDel.Text = "DELETE MODE: " .. (deleteMode and "ON" or "OFF")
end)

local btnUndo = Instance.new("TextButton", p3)
btnUndo.Size = UDim2.new(0.9, 0, 0, 40)
btnUndo.Position = UDim2.new(0.05, 0, 0, 60)
btnUndo.Text = "UNDO DELETE"
btnUndo.MouseButton1Click:Connect(function()
    if #deletedObjects > 0 then
        local last = table.remove(deletedObjects)
        last.obj.Parent = last.parent
    end
end)

local btnESP = Instance.new("TextButton", p3)
btnESP.Size = UDim2.new(0.9, 0, 0, 40)
btnESP.Position = UDim2.new(0.05, 0, 0, 110)
btnESP.Text = "ESP PLAYER: OFF"
btnESP.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    btnESP.Text = "ESP PLAYER: " .. (espEnabled and "ON" or "OFF")
    updateESP()
end)

print("✅ Script Fully Loaded!")
