-- สร้าง ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "ControlGui"
gui.Parent = game.Players.LocalPlayer.PlayerGui

-- สร้างปุ่ม
local button = Instance.new("TextButton")
button.Name = "ControlButton"
button.Text = "M"
button.Size = UDim2.new(0, 50, 0, 50)
button.Position = UDim2.new(0.5, -25, 0.5, -25)
button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24
button.Parent = gui

-- ตัวแปรสำหรับการลาก
local isDragging = false
local lastMousePos = Vector2.new(0, 0)
local offset = Vector2.new(0, 0)

-- ฟังก์ชันสำหรับตรวจสอบขอบเขตจอ
local function getBounds()
    local guiService = game:GetService("GuiService")
    local playerGui = player.PlayerGui
    local screenGui = playerGui:FindFirstChild("ControlGui")
    if screenGui then
        local screenSize = guiService:GetScreenResolution()
        local buttonPos = button.Position
        local buttonSize = button.Size
        
        return {
            minX = 0,
            maxX = screenSize.X - (buttonSize.X.Offset + (buttonSize.X.Scale * screenSize.X)),
            minY = 36, -- พื้นที่สำหรับแถบด้านบน
            maxY = screenSize.Y - buttonSize.Y.Offset - (buttonSize.Y.Scale * screenSize.Y)
        }
    end
    return { minX = 0, maxX = 0, minY = 0, maxY = 0 }
end

-- ฟังก์ชันสำหรับอัพเดทตำแหน่งปุ่ม
local function updateButtonPosition(input)
    if isDragging then
        local delta = input.Position - lastMousePos
        local newPos = Vector2.new(
            button.Position.X.Offset + delta.X,
            button.Position.Y.Offset + delta.Y
        )
        
        local bounds = getBounds()
        newPos = Vector2.new(
            math.clamp(newPos.X, bounds.minX, bounds.maxX),
            math.clamp(newPos.Y, bounds.minY, bounds.maxY)
        )
        
        button.Position = UDim2.new(
            0, newPos.X,
            0, newPos.Y
        )
        
        lastMousePos = input.Position
    end
end

-- ฟังก์ชันสำหรับจำลองกดปุ่ม Ctrl
local function simulateCtrlKeyPress()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    wait()
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
end

-- สร้าง LocalScript สำหรับการรักษาการแสดงผล
local localScript = Instance.new("LocalScript")
localScript.Name = "PersistentButton"
localScript.Parent = gui

-- รหัสใน LocalScript
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ฟังก์ชันสำหรับรีเซ็ตตำแหน่งปุ่ม
local function resetButtonPosition()
    button.Position = UDim2.new(0.5, -25, 0.5, -25)
end

-- ฟังก์ชันสำหรับจัดการการตาย
local function onCharacterDeath()
    -- รอจนกว่าจะเกิดใหม่
    character = player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    
    -- รีเซ็ตตำแหน่งปุ่ม
    resetButtonPosition()
    
    -- เชื่อมต่อเหตุการณ์ใหม่
    humanoid.Died:Connect(onCharacterDeath)
end

-- เชื่อมต่อเหตุการณ์การตาย
humanoid.Died:Connect(onCharacterDeath)

-- รีเซ็ตตำแหน่งเริ่มต้น
resetButtonPosition()

-- การจัดการอินพุต
local UserInputService = game:GetService("UserInputService")
local function onInputBegan(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        if mouse.Target == button then
            isDragging = true
            lastMousePos = input.Position
            offset = Vector2.new(
                input.Position.X - button.Position.X.Offset,
                input.Position.Y - button.Position.Y.Offset
            )
        end
    end
end

local function onInputChanged(input)
    if input.UserInputType == Enum.UserInputType.Mouse or 
       input.UserInputType == Enum.UserInputType.Touch then
        updateButtonPosition(input)
    end
end

local function onInputEnded(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end

-- เชื่อมต่ออีเวนต์
UserInputService.InputBegan:Connect(onInputBegan)
UserInputService.InputChanged:Connect(onInputChanged)
UserInputService.InputEnded:Connect(onInputEnded)
button.MouseButton1Click:Connect(simulateCtrlKeyPress)


-- โหลด Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- สร้าง Window
local Window = Fluent:CreateWindow({
    Title = "Muscle Legend Auto Farm",
    SubTitle = "by WARON XIN",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Rose",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local MainTab = Window:AddTab({ Title = "Main", Icon = "" })

local Options = Fluent.Options

local function autoFarm()
    local a = game:GetService("ReplicatedStorage")
    local b = game:GetService("Players")
    local c = b.LocalPlayer
    
    local d = function(e)
        local f = c.petsFolder
        for g, h in pairs(f:GetChildren()) do
            if h:IsA("Folder") then
                for i, j in pairs(h:GetChildren()) do
                    a.rEvents.equipPetEvent:FireServer("unequipPet", j)
                end
            end
        end
        task.wait(.1)
    end
    
    local k = function(l)
        d()
        task.wait(.01)
        for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
            if n.Name == l then
                a.rEvents.equipPetEvent:FireServer("equipPet", n)
            end
        end
    end
    
    local o = function(p)
        local q = workspace.machinesFolder:FindFirstChild(p)
        if not q then
            for r, s in pairs(workspace:GetChildren()) do
                if s:IsA("Folder") and s.Name:find("machines") then
                    q = s:FindFirstChild(p)
                    if q then break end
                end
            end
        end
        return q
    end
    
    local t = function()
        local u = game:GetService("VirtualInputManager")
        u:SendKeyEvent(true, "E", false, game)
        task.wait(.1)
        u:SendKeyEvent(false, "E", false, game)
    end
    
    local running = true
    
    task.spawn(function()
        while running do
            local v = c.leaderstats.Rebirths.Value
            local w = 10000 + (5000 * v)
            if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local x = c.ultimatesFolder["Golden Rebirth"].Value
                w = math.floor(w * (1 - (x * 0.1)))
            end
            d()
            task.wait(.1)
            k("Swift Samurai")
            while c.leaderstats.Strength.Value < w and running do
                for y = 1, 10 do c.muscleEvent:FireServer("rep") end
                task.wait()
            end
            
            if not running then break end
            
            d()
            task.wait(.1)
            k("Tribal Overlord")
            local z = o("Jungle Bar Lift")
            if z and z:FindFirstChild("interactSeat") then
                c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                repeat
                    task.wait(.1)
                    t()
                until c.Character.Humanoid.Sit or not running
            end
            
            if not running then break end
            
            local A = c.leaderstats.Rebirths.Value
            repeat
                a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(.1)
            until c.leaderstats.Rebirths.Value > A or not running
            
            task.wait()
        end
    end)
    
    return function()
        running = false
    end
end

local stopFunction = nil

local statsSection = MainTab:AddSection({
    Title = "📊 สถิติผู้เล่น"
})

-- ส่วนของ Strength และ Durability ยังใช้จาก GUI เดิม
local strengthParagraph = statsSection:AddParagraph({
    Title = "กำลังโหลด...",
    Content = "Strength"
})

local durabilityParagraph = statsSection:AddParagraph({
    Title = "กำลังโหลด...",
    Content = "Durability"
})

-- ส่วนของ Rebirths ใหม่ ดึงจาก Leaderstats
local rebirthsParagraph = statsSection:AddParagraph({
    Title = "กำลังโหลด...", 
    Content = "Rebirths"
})

local function formatNumber(val)
    return tostring(val):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function updateStats()
    while task.wait(1) do
        local player = game:GetService("Players").LocalPlayer
        
        -- Strength (จาก GUI)
        local strengthFrame = player.PlayerGui.gameGui.statsMenu.statsList.strengthFrame
        strengthParagraph:SetTitle("💪 Strength: "..strengthFrame.amountLabel.Text)

        -- Durability (จาก GUI)
        local durabilityFrame = player.PlayerGui.gameGui.statsMenu.statsList.durabilityFrame
        durabilityParagraph:SetTitle("🛡️ Durability: "..durabilityFrame.amountLabel.Text)

        -- Rebirths (จาก Leaderstats)
        local success, reb = pcall(function()
            return player.leaderstats.Rebirths.Value
        end)
        
        if success then
            rebirthsParagraph:SetTitle("🔄 Rebirths: "..formatNumber(reb))
        else
            rebirthsParagraph:SetTitle("🔄 Rebirths: N/A")
        end
    end
end

task.spawn(updateStats)

local AutoFarmToggle = MainTab:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Description = "เปิดระบบฟาร์มอัตโนมัติสำหรับ Muscle Legends",
    Default = false,
    Callback = function(Value)
        if Value then
            stopFunction = autoFarm()
            Fluent:Notify({
                Title = "Auto Farm",
                Content = "เริ่มการฟาร์มอัตโนมัติแล้ว",
                Duration = 3
            })
        else
            if stopFunction then
                stopFunction()
                stopFunction = nil
                Fluent:Notify({
                    Title = "Auto Farm",
                    Content = "หยุดการฟาร์มอัตโนมัติแล้ว",
                    Duration = 3
                })
            end
        end
    end
})

MainTab:AddParagraph({
    Title = "Muscle Legends Auto Farm",
    Content = "สคริปต์นี้จะช่วยฟาร์ม Strength และ Rebirth อัตโนมัติ โดยจะ:\n- ใช้ Swift Samurai Pet เพื่อฟาร์ม Strength\n- ใช้ Tribal Overlord Pet เพื่อ Rebirth\n- ทำการ Rebirth เมื่อถึงค่า Strength ที่กำหนด"
})

MainTab:AddButton({
    Title = "วิธีใช้งาน",
    Description = "แสดงคำแนะนำการใช้งาน",
    Callback = function()
        Window:Dialog({
            Title = "วิธีใช้งาน",
            Content = "1. เปิด Toggle 'Auto Farm' เพื่อเริ่มการฟาร์มอัตโนมัติ\n2. ตรวจสอบให้แน่ใจว่ามี Pet 'Swift Samurai' และ 'Tribal Overlord'\n3. ระบบจะทำงานอัตโนมัติฟาร์ม Strength และ Rebirth\n4. ปิด Toggle เมื่อต้องการหยุดการทำงาน",
            Buttons = {
                {
                    Title = "เข้าใจแล้ว",
                    Callback = function()
                        print("ผู้ใช้เข้าใจวิธีใช้งานแล้ว")
                    end
                }
            }
        })
    end
})

Window:SelectTab(1)

local HideEffectsToggle = MainTab:AddToggle("HideEffectsToggle", {
    Title = "ซ่อน Stat Effects",
    Description = "ซ่อนหน้าต่างแสดงผล Stat Effects",
    Default = false,
    Callback = function(Value)
        local statEffectsGui = game:GetService("Players").LocalPlayer.PlayerGui.statEffectsGui
        if statEffectsGui then
            statEffectsGui.Enabled = not Value
            
            Fluent:Notify({
                Title = "Stat Effects GUI",
                Content = Value and "ซ่อนหน้าต่าง Stat Effects แล้ว" or "แสดงหน้าต่าง Stat Effects แล้ว",
                Duration = 2
            })
        else
            Fluent:Notify({
                Title = "Error",
                Content = "ไม่พบ Stat Effects GUI",
                Duration = 2
            })
        end
    end
})

local targetRebirths = 0
local stopTargetRebirthsFunction = nil

local RebirthInput = MainTab:AddInput("RebirthInput", {
    Title = "เป้าหมาย Rebirths",
    Description = "ระบุจำนวน Rebirths ที่ต้องการให้ฟาร์มถึง",
    Default = "100",
    Placeholder = "ใส่จำนวนตัวเลข",
    Numeric = true, 
    Callback = function(Value)
        local num = tonumber(Value)
        if num then
            targetRebirths = num
            Fluent:Notify({
                Title = "เป้าหมาย Rebirths",
                Content = "ตั้งค่าเป้าหมายเป็น " .. num .. " Rebirths",
                Duration = 2
            })
        end
    end
})

local function autoFarmToTarget()
    local a = game:GetService("ReplicatedStorage")
    local b = game:GetService("Players")
    local c = b.LocalPlayer
    
    local d = function(e)
        local f = c.petsFolder
        for g, h in pairs(f:GetChildren()) do
            if h:IsA("Folder") then
                for i, j in pairs(h:GetChildren()) do
                    a.rEvents.equipPetEvent:FireServer("unequipPet", j)
                end
            end
        end
        task.wait(.1)
    end
    
    local k = function(l)
        d()
        task.wait(.01)
        for m, n in pairs(c.petsFolder.Unique:GetChildren()) do
            if n.Name == l then
                a.rEvents.equipPetEvent:FireServer("equipPet", n)
            end
        end
    end
    
    local o = function(p)
        local q = workspace.machinesFolder:FindFirstChild(p)
        if not q then
            for r, s in pairs(workspace:GetChildren()) do
                if s:IsA("Folder") and s.Name:find("machines") then
                    q = s:FindFirstChild(p)
                    if q then break end
                end
            end
        end
        return q
    end
    
    local t = function()
        local u = game:GetService("VirtualInputManager")
        u:SendKeyEvent(true, "E", false, game)
        task.wait(.1)
        u:SendKeyEvent(false, "E", false, game)
    end
    
    local running = true
    
    task.spawn(function()
        while running do
            if c.leaderstats.Rebirths.Value >= targetRebirths then
                running = false
                Fluent:Notify({
                    Title = "เป้าหมายสำเร็จ",
                    Content = "ถึงเป้าหมาย " .. targetRebirths .. " Rebirths แล้ว!",
                    Duration = 5
                })
                TargetRebirthsToggle:SetValue(false)
                break
            end
            
            local v = c.leaderstats.Rebirths.Value
            local w = 10000 + (5000 * v)
            if c.ultimatesFolder:FindFirstChild("Golden Rebirth") then
                local x = c.ultimatesFolder["Golden Rebirth"].Value
                w = math.floor(w * (1 - (x * 0.1)))
            end
            d()
            task.wait(.1)
            k("Swift Samurai")
            while c.leaderstats.Strength.Value < w and running do
                for y = 1, 10 do c.muscleEvent:FireServer("rep") end
                task.wait()
            end
            
            if not running then break end
            
            d()
            task.wait(.1)
            k("Tribal Overlord")
            local z = o("Jungle Bar Lift")
            if z and z:FindFirstChild("interactSeat") then
                c.Character.HumanoidRootPart.CFrame = z.interactSeat.CFrame * CFrame.new(0, 3, 0)
                repeat
                    task.wait(.1)
                    t()
                until c.Character.Humanoid.Sit or not running
            end
            
            if not running then break end
            
            local A = c.leaderstats.Rebirths.Value
            repeat
                a.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
                task.wait(.1)
            until c.leaderstats.Rebirths.Value > A or not running
            
            task.wait()
        end
    end)
    
    return function()
        running = false
    end
end

local TargetRebirthsToggle = MainTab:AddToggle("TargetRebirthsToggle", {
    Title = "Auto Farm ถึงเป้าหมาย",
    Description = "ฟาร์มอัตโนมัติจนกว่าจะถึงจำนวน Rebirths ที่กำหนด",
    Default = false,
    Callback = function(Value)
        if Value then
            if targetRebirths <= 0 then
                Fluent:Notify({
                    Title = "เกิดข้อผิดพลาด",
                    Content = "กรุณาระบุเป้าหมาย Rebirths ก่อน",
                    Duration = 3
                })
                TargetRebirthsToggle:SetValue(false)
                return
            end
            
            local currentRebirths = game:GetService("Players").LocalPlayer.leaderstats.Rebirths.Value
            if currentRebirths >= targetRebirths then
                Fluent:Notify({
                    Title = "เป้าหมายสำเร็จแล้ว",
                    Content = "คุณมี Rebirths (" .. currentRebirths .. ") ถึงหรือเกินเป้าหมาย (" .. targetRebirths .. ") แล้ว",
                    Duration = 3
                })
                TargetRebirthsToggle:SetValue(false)
                return
            end
            
            stopTargetRebirthsFunction = autoFarmToTarget()
            Fluent:Notify({
                Title = "Auto Farm ถึงเป้าหมาย",
                Content = "เริ่มการฟาร์มอัตโนมัติจนถึง " .. targetRebirths .. " Rebirths",
                Duration = 3
            })
        else
            if stopTargetRebirthsFunction then
                stopTargetRebirthsFunction()
                stopTargetRebirthsFunction = nil
                Fluent:Notify({
                    Title = "Auto Farm ถึงเป้าหมาย",
                    Content = "หยุดการฟาร์มอัตโนมัติแล้ว",
                    Duration = 3
                })
            end
        end
    end
})
