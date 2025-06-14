-- Loader.lua
return function()
    -- Load library UI
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxScriptHub/UI-Libraries/main/Venyx.lua"))()
    local Window = Library.new("Grow Garden Ultimate", 5013109572)

    -- Main variables
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local RunService = game:GetService("RunService")
    
    -- Duplication settings
    getgenv().DupeSettings = {
        Enabled = false,
        Amount = 5,
        Distance = Vector3.new(5, 0, 0)
    }

    -- Auto farm settings
    getgenv().FarmSettings = {
        Enabled = false,
        Plant = true,
        Water = true,
        Harvest = true,
        Sell = true,
        Rebirth = false,
        RebirthAmount = 5000
    }

    -- Teleport function
    local function Teleport(position)
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char.HumanoidRootPart.CFrame = CFrame.new(position)
        end
    end

    -- Find and activate prompt
    local function ActivatePrompt(objName)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == objName and obj:FindFirstChild("ProximityPrompt") then
                fireproximityprompt(obj.ProximityPrompt)
                return true
            end
        end
        return false
    end

    -- Plant duplication feature
    local function DuplicatePlants()
        if not getgenv().DupeSettings.Enabled then return end
        
        for _, plant in ipairs(workspace:GetChildren()) do
            if plant.Name:find("Ready") and plant:FindFirstChild("HarvestPrompt") then
                local originalPos = plant.PrimaryPart.Position
                
                for i = 1, getgenv().DupeSettings.Amount do
                    Teleport(originalPos + (getgenv().DupeSettings.Distance * i))
                    task.wait(0.1)
                    fireproximityprompt(plant.HarvestPrompt)
                end
                
                Teleport(originalPos)
            end
        end
    end

    -- Main farming loop
    task.spawn(function()
        while task.wait(0.5) do
            if not getgenv().FarmSettings.Enabled then continue end
            
            -- Planting
            if getgenv().FarmSettings.Plant then
                Teleport(Vector3.new(-30, 3, 0))
                ActivatePrompt("Planter")
                task.wait(0.5)
            end
            
            -- Duplication
            DuplicatePlants()
            
            -- Watering
            if getgenv().FarmSettings.Water then
                Teleport(Vector3.new(-15, 3, 10))
                ActivatePrompt("WateringCan")
                task.wait(0.5)
            end
            
            -- Harvesting
            if getgenv().FarmSettings.Harvest then
                Teleport(Vector3.new(20, 3, -5))
                for i = 1, 5 do
                    ActivatePrompt("Harvest")
                    task.wait(0.2)
                end
            end
            
            -- Selling
            if getgenv().FarmSettings.Sell then
                Teleport(Vector3.new(40, 3, 25))
                ActivatePrompt("SellBox")
                task.wait(1)
            end
            
            -- Rebirth
            if getgenv().FarmSettings.Rebirth and LocalPlayer.leaderstats.Coins.Value > getgenv().FarmSettings.RebirthAmount then
                Teleport(Vector3.new(0, 3, 50))
                ActivatePrompt("RebirthMachine")
                task.wait(2)
            end
        end
    end)

    -- Create UI
    do
        -- Main tab
        local MainTab = Window:AddTab("Main")
        
        -- Farming section
        local FarmingSection = MainTab:AddSection("Auto Farming")
        
        FarmingSection:AddToggle({
            text = "Enable Auto Farm",
            flag = "AutoFarmToggle",
            callback = function(value)
                getgenv().FarmSettings.Enabled = value
            end
        })
        
        FarmingSection:AddToggle({
            text = "Enable Plant Duplication",
            flag = "DuplicationToggle",
            callback = function(value)
                getgenv().DupeSettings.Enabled = value
            end
        })
        
        FarmingSection:AddSlider({
            text = "Dupe Amount",
            flag = "DupeAmountSlider",
            min = 1,
            max = 10,
            value = 5,
            callback = function(value)
                getgenv().DupeSettings.Amount = value
            end
        })
        
        -- Settings section
        local SettingsSection = MainTab:AddSection("Settings")
        
        SettingsSection:AddToggle({
            text = "Auto Planting",
            state = true,
            callback = function(value)
                getgenv().FarmSettings.Plant = value
            end
        })
        
        SettingsSection:AddToggle({
            text = "Auto Watering",
            state = true,
            callback = function(value)
                getgenv().FarmSettings.Water = value
            end
        })
        
        SettingsSection:AddToggle({
            text = "Auto Harvest",
            state = true,
            callback = function(value)
                getgenv().FarmSettings.Harvest = value
            end
        })
        
        SettingsSection:AddToggle({
            text = "Auto Sell",
            state = true,
            callback = function(value)
                getgenv().FarmSettings.Sell = value
            end
        })
        
        SettingsSection:AddToggle({
            text = "Auto Rebirth",
            callback = function(value)
                getgenv().FarmSettings.Rebirth = value
            end
        })
        
        SettingsSection:AddSlider({
            text = "Rebirth Amount",
            min = 1000,
            max = 10000,
            value = 5000,
            callback = function(value)
                getgenv().FarmSettings.RebirthAmount = value
            end
        })
        
        -- Teleport tab
        local TeleportTab = Window:AddTab("Teleports")
        
        local LocationsSection = TeleportTab:AddSection("Locations")
        
        local locations = {
            {Name = "Planting Area", Position = Vector3.new(-30, 3, 0)},
            {Name = "Watering Area", Position = Vector3.new(-15, 3, 10)},
            {Name = "Harvest Area", Position = Vector3.new(20, 3, -5)},
            {Name = "Sell Area", Position = Vector3.new(40, 3, 25)},
            {Name = "Rebirth Machine", Position = Vector3.new(0, 3, 50)}
        }
        
        for _, loc in ipairs(locations) do
            LocationsSection:AddButton({
                text = loc.Name,
                callback = function()
                    Teleport(loc.Position)
                end
            })
        end
        
        -- Player tab
        local PlayerTab = Window:AddTab("Player")
        
        local PlayerSection = PlayerTab:AddSection("Settings")
        
        PlayerSection:AddSlider({
            text = "Walk Speed",
            min = 16,
            max = 200,
            value = 16,
            callback = function(value)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = value
                end
            end
        })
        
        PlayerSection:AddSlider({
            text = "Jump Power",
            min = 50,
            max = 200,
            value = 50,
            callback = function(value)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.JumpPower = value
                end
            end
        })
        
        -- Init
        Window:Notify("Grow Garden Ultimate Loaded!", "Plant duplication and auto farming enabled")
    end
end
