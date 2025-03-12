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
