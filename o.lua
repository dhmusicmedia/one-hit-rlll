--[[
    DERELICT HUB - GOD MODE & ONE HIT
    Hướng dẫn: Dán vào GitHub, lấy link RAW và chạy bằng Executor.
--]]

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa Menu cũ nếu có để tránh trùng lặp
if PlayerGui:FindFirstChild("DerelictMenu") then
    PlayerGui.DerelictMenu:Destroy()
end

-- TẠO GIAO DIỆN MENU
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "DerelictMenu"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 130)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Có thể kéo menu đi chỗ khác

local corner = Instance.new("UICorner", frame)
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "DERELICT CHEAT"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- BIẾN TRẠNG THÁI
_G.GodMode = false
_G.OneHit = false

-- HÀM TẠO NÚT
local function createToggle(name, pos, varName)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", btn)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        if _G[varName] then
            btn.Text = name .. ": ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            btn.Text = name .. ": OFF"
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
    end)
end

createToggle("BẤT TỬ", UDim2.new(0, 10, 0, 40), "GodMode")
createToggle("ONE HIT", UDim2.new(0, 10, 0, 85), "OneHit")

-- LOGIC BẤT TỬ (Hồi máu liên tục)
RunService.Heartbeat:Connect(function()
    if _G.GodMode and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        if hum.Health < hum.MaxHealth then
            hum.Health = hum.MaxHealth
        end
    end
end)

-- LOGIC ONE HIT (Cho tất cả vũ khí và bộ phận cơ thể)
local function applyHitbox(obj)
    if obj:IsA("BasePart") then
        obj.Touched:Connect(function(hit)
            if _G.OneHit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                local target = hit.Parent:FindFirstChild("Humanoid")
                -- Kiểm tra để không tự giết chính mình
                if hit.Parent.Name ~= Player.Name then
                    target.Health = 0 -- Kết liễu ngay
                end
            end
        end)
    end
end

-- Quét nhân vật và các món đồ cầm trên tay
local function setup(char)
    for _, v in pairs(char:GetDescendants()) do applyHitbox(v) end
    char.ChildAdded:Connect(function(newObj)
        for _, v in pairs(newObj:GetDescendants()) do applyHitbox(v) end
    end)
end

Player.CharacterAdded:Connect(setup)
if Player.Character then setup(Player.Character) end

print("Derelict Script Loaded Successfully!")
