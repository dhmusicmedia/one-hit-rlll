local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Xóa Menu cũ nếu có
if PlayerGui:FindFirstChild("DerelictHub") then
    PlayerGui.DerelictHub:Destroy()
end

-- TẠO GIAO DIỆN MENU
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "DerelictHub"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.02, 0, 0.4, 0) -- Nằm bên trái màn hình
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true -- Có thể kéo đi

local corner = Instance.new("UICorner", frame)

-- Hàm tạo nút bấm nhanh
local function createButton(name, pos, color)
    local btn = Instance.new("TextButton", frame)
    btn.Name = name
    btn.Size = UDim2.new(0, 180, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn)
    return btn
end

local godBtn = createButton("GOD MODE", UDim2.new(0, 10, 0, 10), Color3.fromRGB(60, 60, 60))
local hitBtn = createButton("ONE HIT", UDim2.new(0, 10, 0, 60), Color3.fromRGB(60, 60, 60))

-- BIẾN TRẠNG THÁI
local godEnabled = false
local hitEnabled = false

-- LOGIC GOD MODE (BẤT TỬ)
-- Lưu ý: God mode đơn giản nhất là liên tục hồi máu hoặc chặn sát thương
game:GetService("RunService").RenderStepped:Connect(function()
    if godEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        local hum = Player.Character.Humanoid
        hum.Health = hum.MaxHealth -- Liên tục hồi đầy máu
    end
end)

-- LOGIC ONE HIT
local function applyOneHit(obj)
    if obj:IsA("BasePart") then
        obj.Touched:Connect(function(hit)
            if hitEnabled and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
                if hit.Parent.Name ~= Player.Name then
                    hit.Parent.Humanoid.Health = 0
                end
            end
        end)
    end
end

-- Quét nhân vật và vũ khí
local function setup(char)
    for _, v in pairs(char:GetDescendants()) do applyOneHit(v) end
    char.ChildAdded:Connect(function(child)
        for _, v in pairs(child:GetDescendants()) do applyOneHit(v) end
    end)
end

Player.CharacterAdded:Connect(setup)
if Player.Character then setup(Player.Character) end

-- SỰ KIỆN BẤM NÚT
godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = godEnabled and "GOD MODE: ON" or "GOD MODE: OFF"
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 120, 255) or Color3.fromRGB(60, 60, 60)
end)

hitBtn.MouseButton1Click:Connect(function()
    hitEnabled = not hitEnabled
    hitBtn.Text = hitEnabled and "ONE HIT: ON" or "ONE HIT: OFF"
    hitBtn.BackgroundColor3 = hitEnabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(60, 60, 60)
end)
