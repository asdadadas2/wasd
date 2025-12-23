-- Credits To The Original Devs @xz, @goof
getgenv().Config = {
    Invite = "informant.wtf",
    Version = "0.0",
}

getgenv().luaguardvars = {
    DiscordName = "username#0000",
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Other/main/1"))()
library:init()

local Window = library.NewWindow({
    title = "Informant.Wtf",
    size = UDim2.new(0, 525, 0, 650)
})

local tabs = {
    Tab1 = Window:AddTab("Aimbot"),
    ExploitsTab = Window:AddTab("Exploits"),
    ESPTab = Window:AddTab("ESP"),
    Settings = library:CreateSettingsTab(Window),
}

local sections = {
    Section1 = tabs.Tab1:AddSection("Aimbot", 1),
    Section2 = tabs.Tab1:AddSection("Silent Aim", 2),
    ExploitSection = tabs.ExploitsTab:AddSection("Exploit", 1),
    TeleportSection = tabs.ExploitsTab:AddSection("Teleport", 2),
    ESPAllSection = tabs.ESPTab:AddSection("ESP Settings", 1),
    HealthESPSection = tabs.ESPTab:AddSection("Health ESP", 2)
}

--==================== SERVICES ====================--
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local WS = game:GetService("Workspace")
local Mouse = LocalPlayer:GetMouse()
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--==================== AIMBOT VARIABLES =============--
local Aimbot = {
    Enabled = false,
    Key = Enum.KeyCode.Q,
    Mode = "Hold",
    Toggled = false,
    Type = "CFrame",
    Activation = "LeftClick",
    Smoothing = 0.12,
    FOV = 150,
    FOVColor = Color3.fromRGB(255,255,255),
    TeamCheck = false,
    VisCheck = false,
    BotCheck = true,
    Prediction = 0,
    Bone = "HumanoidRootPart"
}

local Holding = false

--==================== SILENT AIM VARIABLES =========--
local SilentAim = {
    Enabled = false,
    TeamCheck = true,
    HitChance = 100,
    Bone = "Head",
    FOVRadius = 90,
    FOVColor = Color3.fromRGB(255, 0, 0),
    FOVTransparency = 0.5,
    FOVThickness = 1,
    FOVVisible = true,
    SilentAimEvent = nil
}

--==================== FOV CIRCLE ===================--
local FOV_Circle = Drawing.new("Circle")
FOV_Circle.Color = Aimbot.FOVColor
FOV_Circle.Thickness = 1.5
FOV_Circle.Filled = false
FOV_Circle.NumSides = 100
FOV_Circle.Radius = Aimbot.FOV
FOV_Circle.Visible = true

--================ SILENT AIM FOV CIRCLE ============--
local SilentAim_FOV_Circle = Drawing.new("Circle")
SilentAim_FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
SilentAim_FOV_Circle.Radius = SilentAim.FOVRadius
SilentAim_FOV_Circle.Filled = false
SilentAim_FOV_Circle.Color = SilentAim.FOVColor
SilentAim_FOV_Circle.Visible = SilentAim.FOVVisible
SilentAim_FOV_Circle.Transparency = SilentAim.FOVTransparency
SilentAim_FOV_Circle.Thickness = SilentAim.FOVThickness
SilentAim_FOV_Circle.NumSides = 64

--==================== EXPLOIT VARIABLES ============--
local FlyEnabled = false
local FlyMode = "Smooth"
local FlySpeed = 1
local SpinBotEnabled = false
local SpinSpeed = 1
local InfJumpEnabled = false
local SpeedEnabled = false
local JumpEnabled = false
local WalkSpeedValue = 16
local JumpPowerValue = 50

--================ TELEPORT VARIABLES ===============--
local TeleportEnabled = false
local TeleportLoopEnabled = false
local TeleportOffset = "Above"
local TeleportDistance = 5
local TeleportTarget = ""
local TeleportAllEnabled = false
local TeleportAllDistance = 5
local SpinEveryoneEnabled = false
local SpinEveryoneSpeed = 1
local TeamCheckEnabled = true
local AutoSwitchOnDeathEnabled = false
local LastTargetDeathTime = 0
local DeathSwitchCooldown = 3 -- seconds

--================== ESP VARIABLES ==================--
local ESPEnabled = false
local RainbowEverything = false
local RainbowSpeed = 0.15
local ESPTeamCheck = false

-- Box ESP
local BoxESPEnabled = false
local BoxColor = Color3.fromRGB(255, 0, 0)
local BoxThickness = 2
local BoxAutothickness = true

-- Quad ESP (Full Box)
local QuadESPEnabled = false
local QuadColor = Color3.fromRGB(255, 255, 255)
local QuadThickness = 1

-- Skeleton ESP
local SkeletonESPEnabled = false
local SkeletonColor = Color3.fromRGB(255, 0, 0)
local SkeletonThickness = 1

-- Radar ESP
local RadarESPEnabled = false
local RadarPosition = Vector2.new(200, 200)
local RadarRadius = 100
local RadarScale = 1
local RadarBackColor = Color3.fromRGB(10, 10, 10)
local RadarBorderColor = Color3.fromRGB(75, 75, 75)
local LocalPlayerDotColor = Color3.fromRGB(255, 255, 255)
local PlayerDotColor = Color3.fromRGB(60, 170, 255)
local TeamColor = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)
local RadarHealthColor = true

-- Tracers
local TracersEnabled = false
local TracerColor = Color3.fromRGB(255, 203, 138)
local TracerThickness = 1
local TracerTransparency = 1
local TracerAutothickness = true
local TracerLength = 15
local TracerSmoothness = 0.2

-- Arrows (Off-screen indicators)
local ArrowsEnabled = false
local ArrowColor = Color3.fromRGB(255, 255, 255)
local ArrowFilled = true
local ArrowTransparency = 0
local ArrowThickness = 1
local ArrowDistance = 80
local ArrowHeight = 16
local ArrowWidth = 16
local AntiAliasing = false

-- Health ESP
local HealthESPEnabled = false
local HealthESPToggle = false
local HealthTeamCheck = false
local HealthShowTeam = false
local HealthStyle = "Bar"
local HealthBarSide = "Left"
local HealthTextSuffix = "HP"
local HealthTextSize = 14
local HealthTextFont = 2
local HealthMaxDistance = 1000
local HealthRefreshRate = 1/144
local HealthEnemyColor = Color3.fromRGB(255, 25, 25)
local HealthAllyColor = Color3.fromRGB(25, 255, 25)
local HealthNeutralColor = Color3.fromRGB(255, 255, 255)
local HealthBarColor = Color3.fromRGB(0, 255, 0)

-- ESP Storage
local ESPDrawings = {}
local RainbowConnections = {}
local HealthDrawings = {}

-- Silent Aim Variables
local firing = false
local SilentAim_ShootEvent

-- Try to find the shoot event
pcall(function()
    SilentAim_ShootEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("Shoot")
end)

--=================== AIMBOT INPUT ==================--
UIS.InputBegan:Connect(function(input)
    -- Key Activation
    if input.KeyCode == Aimbot.Key then
        if Aimbot.Mode == "Hold" then
            Holding = true
        else
            Aimbot.Toggled = not Aimbot.Toggled
        end
    end
    
    -- Mouse Activation
    if Aimbot.Activation == "LeftClick" and input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = true
    elseif Aimbot.Activation == "RightClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    -- Key Activation
    if input.KeyCode == Aimbot.Key and Aimbot.Mode == "Hold" then
        Holding = false
    end
    
    -- Mouse Activation
    if Aimbot.Activation == "LeftClick" and input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = false
    elseif Aimbot.Activation == "RightClick" and input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

--================ SILENT AIM INPUT =================--
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        firing = false
    end
end)

--=================== SILENT AIM FUNCTIONS ==========--
local function isSilentAimEnemy(player)
    if player == LocalPlayer then return false end
    if SilentAim.TeamCheck then
        if LocalPlayer.Neutral or player.Neutral then return true end
        return player.Team ~= LocalPlayer.Team
    end
    return true
end

local function getSilentAimTargets()
    local targets = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if isSilentAimEnemy(player) and player.Character then
            local character = player.Character
            local humanoid = character:FindFirstChild("Humanoid")
            local targetPart = character:FindFirstChild(SilentAim.Bone)
            
            if humanoid and targetPart and humanoid.Health > 0 then
                local screenPos, visible = Camera:WorldToViewportPoint(targetPart.Position)
                if visible then
                    local distance = (Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if distance <= SilentAim.FOVRadius then
                        table.insert(targets, {
                            humanoid = humanoid,
                            part = targetPart,
                            player = player
                        })
                    end
                end
            end
        end
    end
    return targets
end

local function shouldHit()
    if SilentAim.HitChance >= 100 then return true end
    local randomChance = math.random(1, 100)
    return randomChance <= SilentAim.HitChance
end

-- Silent Aim RenderStepped loop
RS.RenderStepped:Connect(function()
    -- Update Silent Aim FOV Circle
    SilentAim_FOV_Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    SilentAim_FOV_Circle.Radius = SilentAim.FOVRadius
    SilentAim_FOV_Circle.Color = SilentAim.FOVColor
    SilentAim_FOV_Circle.Visible = SilentAim.FOVVisible
    SilentAim_FOV_Circle.Transparency = SilentAim.FOVTransparency
    SilentAim_FOV_Circle.Thickness = SilentAim.FOVThickness
    
    -- Silent Aim functionality
    if SilentAim.Enabled and firing and SilentAim_ShootEvent then
        local character = LocalPlayer.Character
        if not character then return end
        
        local tool = character:FindFirstChildOfClass("Tool")
        if not tool then return end
        
        local targets = getSilentAimTargets()
        if #targets > 0 and shouldHit() then
            for _, target in ipairs(targets) do
                local position = target.part.Position
                local direction = (position - Camera.CFrame.Position).Unit
                local cframe = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + direction)
                
                local args = {
                    os.clock(),
                    tool,
                    cframe,
                    true,
                    {
                        ["1"] = {
                            target.humanoid,
                            false,
                            true,
                            100
                        }
                    }
                }
                
                SilentAim_ShootEvent:FireServer(unpack(args))
            end
        end
    end
end)

--================ CLOSEST PLAYER ===================--
local function isBot(character)
    if not character then return false end
    if character:FindFirstChild("Humanoid") then
        local player = Players:GetPlayerFromCharacter(character)
        return player == nil
    end
    return false
end

local function GetClosest()
    local closest = nil
    local shortest = math.huge
    local mousePos = UIS:GetMouseLocation()
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not plr.Character then continue end
        
        local hrp = plr.Character:FindFirstChild(Aimbot.Bone)
        if not hrp then continue end
        if plr.Character.Humanoid.Health <= 0 then continue end
        if Aimbot.TeamCheck and plr.Team == LocalPlayer.Team then continue end
        if not Aimbot.BotCheck and isBot(plr.Character) then continue end
        
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then continue end
        
        if Aimbot.VisCheck then
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {LocalPlayer.Character}
            params.FilterType = Enum.RaycastFilterType.Blacklist
            local ray = workspace:Raycast(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * 5000, params)
            if ray and ray.Instance and not plr.Character:IsAncestorOf(ray.Instance) then
                continue
            end
        end
        
        local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
        if dist < shortest and dist < Aimbot.FOV then
            shortest = dist
            closest = plr
        end
    end
    
    return closest
end

--=================== AIMBOT LOOP ===================--
RS.RenderStepped:Connect(function()
    FOV_Circle.Position = UIS:GetMouseLocation()
    FOV_Circle.Color = Aimbot.FOVColor
    FOV_Circle.Radius = Aimbot.FOV
    
    local active = Aimbot.Enabled and (Aimbot.Mode == "Hold" and Holding or Aimbot.Mode == "Toggle" and Aimbot.Toggled)
    if not active then return end
    
    local target = GetClosest()
    if not target then return end
    
    local hrp = target.Character and target.Character:FindFirstChild(Aimbot.Bone)
    if not hrp then return end
    
    local predictedPos = hrp.Position + (hrp.Velocity * Aimbot.Prediction)
    
    if Aimbot.Type == "CFrame" then
        Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, predictedPos), Aimbot.Smoothing)
    else
        local screenPos = Camera:WorldToViewportPoint(predictedPos)
        local mousePos = UIS:GetMouseLocation()
        mousemoverel(
            (screenPos.X - mousePos.X) * Aimbot.Smoothing,
            (screenPos.Y - mousePos.Y) * Aimbot.Smoothing
        )
    end
end)

--=================== SPINBOT LOOP ==================--
RS.RenderStepped:Connect(function()
    if SpinBotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinSpeed), 0)
    end
end)

--================ INFINITE JUMP ====================--
UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--========== WALK SPEED & JUMP POWER ================--
RS.Heartbeat:Connect(function()
    if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
    end
    if JumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
    end
end)

--================== FLY SYSTEM =====================--
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
flyVelocity.Velocity = Vector3.new(0,0,0)
flyVelocity.Parent = nil

RS.RenderStepped:Connect(function()
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if FlyMode == "Smooth" then
            local camCF = Camera.CFrame
            local moveVec = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camCF.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + camCF.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec = moveVec + Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec = moveVec - Vector3.new(0,1,0) end
            hrp.CFrame = hrp.CFrame + moveVec.Unit * FlySpeed
        elseif FlyMode == "Velocity" then
            flyVelocity.Velocity = Vector3.new(0,0,0)
            if UIS:IsKeyDown(Enum.KeyCode.W) then flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(0,0,-FlySpeed) end
            if UIS:IsKeyDown(Enum.KeyCode.S) then flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(0,0,FlySpeed) end
            if UIS:IsKeyDown(Enum.KeyCode.A) then flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(-FlySpeed,0,0) end
            if UIS:IsKeyDown(Enum.KeyCode.D) then flyVelocity.Velocity = flyVelocity.Velocity + Vector3.new(FlySpeed,0,0) end
            if flyVelocity.Parent ~= LocalPlayer.Character.HumanoidRootPart then
                flyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
            end
        end
    elseif flyVelocity.Parent then
        flyVelocity.Parent = nil
    end
end)

--================= TEAM CHECK ======================--
local function IsSameTeam(targetPlayer)
    if not TeamCheckEnabled then
        return false
    end
    
    if LocalPlayer.Neutral or targetPlayer.Neutral then
        return false
    end
    
    local localTeam = LocalPlayer.Team
    local targetTeam = targetPlayer.Team
    
    return localTeam == targetTeam
end

-- ESP TEAM CHECK
local function IsESPSameTeam(targetPlayer)
    if not ESPTeamCheck then
        return false
    end
    
    if LocalPlayer.Neutral or targetPlayer.Neutral then
        return false
    end
    
    local localTeam = LocalPlayer.Team
    local targetTeam = targetPlayer.Team
    
    return localTeam == targetTeam
end

-- HEALTH ESP TEAM CHECK
local function IsHealthESPSameTeam(targetPlayer)
    if not HealthTeamCheck then
        return false
    end
    
    if LocalPlayer.Neutral or targetPlayer.Neutral then
        return false
    end
    
    local localTeam = LocalPlayer.Team
    local targetTeam = targetPlayer.Team
    
    return localTeam == targetTeam
end

--============ GET RANDOM TARGET ===================--
local function GetRandomTarget()
    local validPlayers = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not TeamCheckEnabled then
                table.insert(validPlayers, player)
            elseif not IsSameTeam(player) then
                table.insert(validPlayers, player)
            end
        end
    end
    
    if #validPlayers > 0 then
        local randomIndex = math.random(1, #validPlayers)
        return validPlayers[randomIndex]
    end
    
    return nil
end

--============== CHECK IF DEAD ======================--
local function IsPlayerDead(player)
    if not player.Character then
        return true
    end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    if not humanoid then
        return true
    end
    
    return humanoid.Health <= 0
end

--============ TELEPORT TO PLAYER ===================--
local function TeleportToPlayer(targetName)
    if not TeleportEnabled then return end
    
    local target = Players:FindFirstChild(targetName or TeleportTarget)
    
    if AutoSwitchOnDeathEnabled and (not target or IsPlayerDead(target)) and tick() - LastTargetDeathTime > DeathSwitchCooldown then
        target = GetRandomTarget()
        if target then
            TeleportTarget = target.Name
            LastTargetDeathTime = tick()
            sections.TeleportSection:UpdateValue("TP_Target", target.Name)
        end
    end
    
    if not target then return end
    
    if TeamCheckEnabled and IsSameTeam(target) then
        library:SendNotification("Cannot teleport to teammate!", 3, Color3.new(1, 0, 0))
        return
    end
    
    if IsPlayerDead(target) then
        if AutoSwitchOnDeathEnabled then
            library:SendNotification("Target is dead, switching...", 2, Color3.new(1, 0.5, 0))
            TeleportToPlayer()
            return
        else
            library:SendNotification("Target is dead!", 3, Color3.new(1, 0, 0))
            return
        end
    end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local tHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if tHrp then
            local offset = Vector3.new(0,0,0)
            if TeleportOffset == "Above" then 
                offset = Vector3.new(0, TeleportDistance, 0)
            elseif TeleportOffset == "Below" then 
                offset = Vector3.new(0, -TeleportDistance, 0)
            elseif TeleportOffset == "Behind" then 
                offset = -target.Character.HumanoidRootPart.CFrame.LookVector * TeleportDistance
            elseif TeleportOffset == "InFront" then 
                offset = target.Character.HumanoidRootPart.CFrame.LookVector * TeleportDistance
            end
            hrp.CFrame = CFrame.new(tHrp.Position + offset)
        end
    end
end

--============== TELEPORT LOOP ======================--
local TeleportLoopConnection
TeleportLoopConnection = RS.RenderStepped:Connect(function()
    if TeleportLoopEnabled then
        TeleportToPlayer()
    end
end)

--=========== TELEPORT ALL IN FRONT =================--
local function TeleportAllInFront()
    if not TeleportAllEnabled then return end
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = LocalPlayer.Character.HumanoidRootPart
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                if not TeamCheckEnabled or not IsSameTeam(plr) then
                    plr.Character.HumanoidRootPart.CFrame = myHRP.CFrame + myHRP.CFrame.LookVector * TeleportAllDistance
                end
            end
        end
    end
end

--=========== TELEPORT ALL LOOP ====================--
local TeleportAllLoopConnection
TeleportAllLoopConnection = RS.RenderStepped:Connect(function()
    if TeleportAllEnabled then
        TeleportAllInFront()
    end
end)

--================ SPIN EVERYONE ====================--
local function SpinEveryone()
    if not SpinEveryoneEnabled then return end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if not TeamCheckEnabled or not IsSameTeam(plr) then
                plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(SpinEveryoneSpeed), 0)
            end
        end
    end
end

--============== SPIN EVERYONE LOOP =================--
local SpinEveryoneConnection
SpinEveryoneConnection = RS.RenderStepped:Connect(function()
    if SpinEveryoneEnabled then
        SpinEveryone()
    end
end)

--=========== MONITOR TARGET DEATH ==================--
local function MonitorTargetDeath()
    while RS.RenderStepped:Wait() do
        if AutoSwitchOnDeathEnabled and TeleportTarget ~= "" then
            local target = Players:FindFirstChild(TeleportTarget)
            if target and IsPlayerDead(target) and tick() - LastTargetDeathTime > DeathSwitchCooldown then
                library:SendNotification("Target died, switching to new player...", 3, Color3.new(1, 0.5, 0))
                local newTarget = GetRandomTarget()
                if newTarget then
                    TeleportTarget = newTarget.Name
                    LastTargetDeathTime = tick()
                    sections.TeleportSection:UpdateValue("TP_Target", newTarget.Name)
                end
            end
        end
    end
end

-- Start death monitoring
coroutine.wrap(MonitorTargetDeath)()

--==================== ESP FUNCTIONS ================--

-- Rainbow effect function
local function StartRainbowEffect()
    if RainbowConnections["rainbow"] then
        RainbowConnections["rainbow"]:Disconnect()
    end
    
    RainbowConnections["rainbow"] = RS.RenderStepped:Connect(function()
        if not RainbowEverything then
            RainbowConnections["rainbow"]:Disconnect()
            RainbowConnections["rainbow"] = nil
            return
        end
        
        local hue = tick() % RainbowSpeed / RainbowSpeed
        local rainbowColor = Color3.fromHSV(hue, 0.8, 1)
        
        BoxColor = rainbowColor
        QuadColor = rainbowColor
        SkeletonColor = rainbowColor
        TracerColor = rainbowColor
        ArrowColor = rainbowColor
        PlayerDotColor = rainbowColor
        TeamColor = rainbowColor
        EnemyColor = rainbowColor
        LocalPlayerDotColor = rainbowColor
        RadarBackColor = Color3.fromRGB(10, 10, 10)
        RadarBorderColor = Color3.fromRGB(75, 75, 75)
        HealthEnemyColor = rainbowColor
        HealthAllyColor = rainbowColor
        HealthNeutralColor = rainbowColor
        HealthBarColor = rainbowColor
    end)
end

-- Utility functions for ESP
local function NewLine(color, thickness)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function NewQuad(color, thickness)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0, 0)
    quad.PointB = Vector2.new(0, 0)
    quad.PointC = Vector2.new(0, 0)
    quad.PointD = Vector2.new(0, 0)
    quad.Color = color
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewCircle(transparency, color, radius, filled, thickness)
    local c = Drawing.new("Circle")
    c.Transparency = transparency
    c.Color = color
    c.Visible = false
    c.Thickness = thickness
    c.Position = Vector2.new(0, 0)
    c.Radius = radius
    c.NumSides = math.clamp(radius*55/100, 10, 75)
    c.Filled = filled
    return c
end

local function NewTriangle(color)
    local l = Drawing.new("Triangle")
    l.Visible = false
    l.Color = color
    l.Filled = ArrowFilled
    l.Thickness = ArrowThickness
    l.Transparency = 1-ArrowTransparency
    return l
end

local function NewSquare(color, thickness, filled)
    local square = Drawing.new("Square")
    square.Visible = false
    square.Color = color
    square.Thickness = thickness
    square.Filled = filled
    square.Transparency = 1
    return square
end

local function NewText(color, size, font)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Color = color
    text.Size = size
    text.Font = font
    text.Center = true
    text.Transparency = 1
    return text
end

--================ HEALTH ESP FUNCTIONS ==============--
local function GetHealthColor(player)
    if player.Neutral then
        return HealthNeutralColor
    elseif player.Team == LocalPlayer.Team then
        return HealthAllyColor
    else
        return HealthEnemyColor
    end
end

local function CreateHealthESP(player)
    if player == LocalPlayer then return end
    
    local healthBar = {
        Outline = NewSquare(Color3.fromRGB(255, 255, 255), 1, false),
        Fill = NewSquare(HealthBarColor, 0, true),
        Text = NewText(HealthBarColor, HealthTextSize, HealthTextFont)
    }
    
    HealthDrawings[player] = {
        HealthBar = healthBar
    }
end

local function RemoveHealthESP(player)
    local health = HealthDrawings[player]
    if health then
        for _, obj in pairs(health.HealthBar) do 
            obj:Remove()
        end
        HealthDrawings[player] = nil
    end
end

local function UpdateHealthESP(player)
    if not HealthESPEnabled then return end
    
    local health = HealthDrawings[player]
    if not health then return end
    
    local character = player.Character
    if not character then 
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return 
    end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then 
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return 
    end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return
    end
    
    local pos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
    
    if not onScreen or distance > HealthMaxDistance then
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return
    end
    
    if HealthTeamCheck and player.Team == LocalPlayer.Team and not HealthShowTeam then
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return
    end
    
    local size = character:GetExtentsSize()
    local cf = rootPart.CFrame
    
    local top, top_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, size.Y/2, 0).Position)
    local bottom, bottom_onscreen = Camera:WorldToViewportPoint(cf * CFrame.new(0, -size.Y/2, 0).Position)
    
    if not top_onscreen or not bottom_onscreen then
        for _, obj in pairs(health.HealthBar) do 
            obj.Visible = false 
        end
        return
    end
    
    local screenSize = bottom.Y - top.Y
    local boxWidth = screenSize * 0.65
    local boxPosition = Vector2.new(top.X - boxWidth/2, top.Y)
    local boxSize = Vector2.new(boxWidth, screenSize)
    
    if HealthESPToggle then
        local healthValue = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local healthPercent = healthValue/maxHealth
        
        local barHeight = screenSize * 0.8
        local barWidth = 4
        local barPos = Vector2.new(
            boxPosition.X - barWidth - 2,
            boxPosition.Y + (screenSize - barHeight)/2
        )
        
        health.HealthBar.Outline.Size = Vector2.new(barWidth, barHeight)
        health.HealthBar.Outline.Position = barPos
        health.HealthBar.Outline.Visible = true
        
        health.HealthBar.Fill.Size = Vector2.new(barWidth - 2, barHeight * healthPercent)
        health.HealthBar.Fill.Position = Vector2.new(barPos.X + 1, barPos.Y + barHeight * (1-healthPercent))
        health.HealthBar.Fill.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
        health.HealthBar.Fill.Visible = true
        
        if HealthStyle == "Both" or HealthStyle == "Text" then
            health.HealthBar.Text.Text = math.floor(healthValue) .. HealthTextSuffix
            health.HealthBar.Text.Position = Vector2.new(barPos.X + barWidth + 2, barPos.Y + barHeight/2)
            health.HealthBar.Text.Visible = true
        else
            health.HealthBar.Text.Visible = false
        end
    else
        for _, obj in pairs(health.HealthBar) do
            obj.Visible = false
        end
    end
end

local function DisableHealthESP()
    for _, player in ipairs(Players:GetPlayers()) do
        local health = HealthDrawings[player]
        if health then
            for _, obj in pairs(health.HealthBar) do 
                obj.Visible = false 
            end
        end
    end
end

local function CleanupHealthESP()
    for _, player in ipairs(Players:GetPlayers()) do
        RemoveHealthESP(player)
    end
    HealthDrawings = {}
end

local lastHealthUpdate = 0
local function UpdateAllHealthESP()
    if not HealthESPEnabled then 
        DisableHealthESP()
        return 
    end
    
    local currentTime = tick()
    if currentTime - lastHealthUpdate >= HealthRefreshRate then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not HealthDrawings[player] then
                    CreateHealthESP(player)
                end
                UpdateHealthESP(player)
            end
        end
        lastHealthUpdate = currentTime
    end
end

-- Health ESP update loop
RS.RenderStepped:Connect(UpdateAllHealthESP)

-- Quad ESP (Full Box)
local function DrawQuadESP(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    local Box = NewQuad(QuadColor, QuadThickness)
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    ESPDrawings[plr]["quad"] = Box
    
    local function Update()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not QuadESPEnabled then
                Box.Visible = false
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                Box.Visible = false
                return
            end
            
            if plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid") ~= nil and plr.Character.PrimaryPart ~= nil and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(plr.Character.PrimaryPart.Position)
                if vis then 
                    local points = {}
                    local c = 0
                    for _,v in pairs(plr.Character:GetChildren()) do
                        if v:IsA("BasePart") then
                            c = c + 1
                            local p, vis = Camera:WorldToViewportPoint(v.Position)
                            if v == plr.Character.PrimaryPart then
                                p, vis = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, 0, -v.Size.Z)).p)
                            elseif v.Name == "Head" then
                                p, vis = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(0, v.Size.Y/2, v.Size.Z/1.25)).p)
                            elseif string.match(v.Name, "Left") then
                                p, vis = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(-v.Size.X/2, 0, 0)).p)
                            elseif string.match(v.Name, "Right") then
                                p, vis = Camera:WorldToViewportPoint((v.CFrame * CFrame.new(v.Size.X/2, 0, 0)).p)
                            end
                            points[c] = {p, vis}
                        end
                    end

                    local TopY = math.huge
                    local DownY = -math.huge
                    local LeftX = math.huge
                    local RightX = -math.huge

                    local Left
                    local Right
                    local Top
                    local Bottom

                    for _,v in pairs(points) do
                        if v[2] == true then
                            local p = v[1]
                            if p.Y < TopY then
                                Top = p
                                TopY = p.Y
                            end
                            if p.Y > DownY then
                                Bottom = p
                                DownY = p.Y
                            end
                            if p.X > RightX then
                                Right = p
                                RightX = p.X
                            end
                            if p.X < LeftX then
                                Left = p
                                LeftX = p.X
                            end
                        end
                    end

                    if Left ~= nil and Right ~= nil and Top ~= nil and Bottom ~= nil then
                        Box.PointA = Vector2.new(Right.X, Top.Y)
                        Box.PointB = Vector2.new(Left.X, Top.Y)
                        Box.PointC = Vector2.new(Left.X, Bottom.Y)
                        Box.PointD = Vector2.new(Right.X, Bottom.Y)
                        Box.Color = QuadColor
                        Box.Visible = true
                    else 
                        Box.Visible = false
                    end
                else 
                    Box.Visible = false
                end
            else
                Box.Visible = false
                if not Players:FindFirstChild(plr.Name) then
                    Box:Remove()
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Box ESP
local function DrawBoxESP(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    local Library = {
        TL1 = NewLine(BoxColor, BoxThickness),
        TL2 = NewLine(BoxColor, BoxThickness),
        TR1 = NewLine(BoxColor, BoxThickness),
        TR2 = NewLine(BoxColor, BoxThickness),
        BL1 = NewLine(BoxColor, BoxThickness),
        BL2 = NewLine(BoxColor, BoxThickness),
        BR1 = NewLine(BoxColor, BoxThickness),
        BR2 = NewLine(BoxColor, BoxThickness)
    }
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    for name, drawing in pairs(Library) do
        ESPDrawings[plr]["box_"..name] = drawing
    end
    
    local oripart = Instance.new("Part")
    oripart.Parent = WS
    oripart.Transparency = 1
    oripart.CanCollide = false
    oripart.Size = Vector3.new(1, 1, 1)
    oripart.Position = Vector3.new(0, 0, 0)
    
    local function Update()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not BoxESPEnabled then
                for _, v in pairs(Library) do
                    v.Visible = false
                end
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                for _, v in pairs(Library) do
                    v.Visible = false
                end
                return
            end
            
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Hum = plr.Character
                local HumPos, vis = Camera:WorldToViewportPoint(Hum.HumanoidRootPart.Position)
                if vis then
                    oripart.Size = Vector3.new(Hum.HumanoidRootPart.Size.X, Hum.HumanoidRootPart.Size.Y*1.5, Hum.HumanoidRootPart.Size.Z)
                    oripart.CFrame = CFrame.new(Hum.HumanoidRootPart.CFrame.Position, Camera.CFrame.Position)
                    local SizeX = oripart.Size.X
                    local SizeY = oripart.Size.Y
                    local TL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, SizeY, 0)).p)
                    local TR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, SizeY, 0)).p)
                    local BL = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(SizeX, -SizeY, 0)).p)
                    local BR = Camera:WorldToViewportPoint((oripart.CFrame * CFrame.new(-SizeX, -SizeY, 0)).p)

                    for _, v in pairs(Library) do
                        v.Color = BoxColor
                    end

                    local ratio = (Camera.CFrame.p - Hum.HumanoidRootPart.Position).magnitude
                    local offset = math.clamp(1/ratio*750, 2, 300)

                    Library.TL1.From = Vector2.new(TL.X, TL.Y)
                    Library.TL1.To = Vector2.new(TL.X + offset, TL.Y)
                    Library.TL2.From = Vector2.new(TL.X, TL.Y)
                    Library.TL2.To = Vector2.new(TL.X, TL.Y + offset)

                    Library.TR1.From = Vector2.new(TR.X, TR.Y)
                    Library.TR1.To = Vector2.new(TR.X - offset, TR.Y)
                    Library.TR2.From = Vector2.new(TR.X, TR.Y)
                    Library.TR2.To = Vector2.new(TR.X, TR.Y + offset)

                    Library.BL1.From = Vector2.new(BL.X, BL.Y)
                    Library.BL1.To = Vector2.new(BL.X + offset, BL.Y)
                    Library.BL2.From = Vector2.new(BL.X, BL.Y)
                    Library.BL2.To = Vector2.new(BL.X, BL.Y - offset)

                    Library.BR1.From = Vector2.new(BR.X, BR.Y)
                    Library.BR1.To = Vector2.new(BR.X - offset, BR.Y)
                    Library.BR2.From = Vector2.new(BR.X, BR.Y)
                    Library.BR2.To = Vector2.new(BR.X, BR.Y - offset)

                    for _, v in pairs(Library) do
                        v.Visible = true
                    end

                    if BoxAutothickness then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - oripart.Position).magnitude
                        local value = math.clamp(1/distance*100, 1, 4)
                        for _, v in pairs(Library) do
                            v.Thickness = value
                        end
                    else 
                        for _, v in pairs(Library) do
                            v.Thickness = BoxThickness
                        end
                    end
                else 
                    for _, v in pairs(Library) do
                        v.Visible = false
                    end
                end
            else 
                for _, v in pairs(Library) do
                    v.Visible = false
                end
                if not Players:FindFirstChild(plr.Name) then
                    for _, v in pairs(Library) do
                        v:Remove()
                    end
                    oripart:Destroy()
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Skeleton ESP
local function DrawSkeletonESP(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    repeat wait() until plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil
    local limbs = {}
    local R15 = (plr.Character.Humanoid.RigType == Enum.HumanoidRigType.R15) and true or false
    
    if R15 then 
        limbs = {
            Head_UpperTorso = NewLine(SkeletonColor, SkeletonThickness),
            UpperTorso_LowerTorso = NewLine(SkeletonColor, SkeletonThickness),
            UpperTorso_LeftUpperArm = NewLine(SkeletonColor, SkeletonThickness),
            LeftUpperArm_LeftLowerArm = NewLine(SkeletonColor, SkeletonThickness),
            LeftLowerArm_LeftHand = NewLine(SkeletonColor, SkeletonThickness),
            UpperTorso_RightUpperArm = NewLine(SkeletonColor, SkeletonThickness),
            RightUpperArm_RightLowerArm = NewLine(SkeletonColor, SkeletonThickness),
            RightLowerArm_RightHand = NewLine(SkeletonColor, SkeletonThickness),
            LowerTorso_LeftUpperLeg = NewLine(SkeletonColor, SkeletonThickness),
            LeftUpperLeg_LeftLowerLeg = NewLine(SkeletonColor, SkeletonThickness),
            LeftLowerLeg_LeftFoot = NewLine(SkeletonColor, SkeletonThickness),
            LowerTorso_RightUpperLeg = NewLine(SkeletonColor, SkeletonThickness),
            RightUpperLeg_RightLowerLeg = NewLine(SkeletonColor, SkeletonThickness),
            RightLowerLeg_RightFoot = NewLine(SkeletonColor, SkeletonThickness),
        }
    else 
        limbs = {
            Head_Spine = NewLine(SkeletonColor, SkeletonThickness),
            Spine = NewLine(SkeletonColor, SkeletonThickness),
            LeftArm = NewLine(SkeletonColor, SkeletonThickness),
            LeftArm_UpperTorso = NewLine(SkeletonColor, SkeletonThickness),
            RightArm = NewLine(SkeletonColor, SkeletonThickness),
            RightArm_UpperTorso = NewLine(SkeletonColor, SkeletonThickness),
            LeftLeg = NewLine(SkeletonColor, SkeletonThickness),
            LeftLeg_LowerTorso = NewLine(SkeletonColor, SkeletonThickness),
            RightLeg = NewLine(SkeletonColor, SkeletonThickness),
            RightLeg_LowerTorso = NewLine(SkeletonColor, SkeletonThickness)
        }
    end
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    for name, drawing in pairs(limbs) do
        ESPDrawings[plr]["skeleton_"..name] = drawing
    end
    
    local function Visibility(state)
        for _, v in pairs(limbs) do
            v.Visible = state
        end
    end

    local function UpdaterR15()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not SkeletonESPEnabled then
                Visibility(false)
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                Visibility(false)
                return
            end
            
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 then
                local HUM, vis = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if vis then
                    local H = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                    if limbs.Head_UpperTorso.From ~= Vector2.new(H.X, H.Y) then
                        local UT = Camera:WorldToViewportPoint(plr.Character.UpperTorso.Position)
                        local LT = Camera:WorldToViewportPoint(plr.Character.LowerTorso.Position)
                        local LUA = Camera:WorldToViewportPoint(plr.Character.LeftUpperArm.Position)
                        local LLA = Camera:WorldToViewportPoint(plr.Character.LeftLowerArm.Position)
                        local LH = Camera:WorldToViewportPoint(plr.Character.LeftHand.Position)
                        local RUA = Camera:WorldToViewportPoint(plr.Character.RightUpperArm.Position)
                        local RLA = Camera:WorldToViewportPoint(plr.Character.RightLowerArm.Position)
                        local RH = Camera:WorldToViewportPoint(plr.Character.RightHand.Position)
                        local LUL = Camera:WorldToViewportPoint(plr.Character.LeftUpperLeg.Position)
                        local LLL = Camera:WorldToViewportPoint(plr.Character.LeftLowerLeg.Position)
                        local LF = Camera:WorldToViewportPoint(plr.Character.LeftFoot.Position)
                        local RUL = Camera:WorldToViewportPoint(plr.Character.RightUpperLeg.Position)
                        local RLL = Camera:WorldToViewportPoint(plr.Character.RightLowerLeg.Position)
                        local RF = Camera:WorldToViewportPoint(plr.Character.RightFoot.Position)

                        for _, v in pairs(limbs) do
                            v.Color = SkeletonColor
                        end

                        limbs.Head_UpperTorso.From = Vector2.new(H.X, H.Y)
                        limbs.Head_UpperTorso.To = Vector2.new(UT.X, UT.Y)
                        limbs.UpperTorso_LowerTorso.From = Vector2.new(UT.X, UT.Y)
                        limbs.UpperTorso_LowerTorso.To = Vector2.new(LT.X, LT.Y)
                        limbs.UpperTorso_LeftUpperArm.From = Vector2.new(UT.X, UT.Y)
                        limbs.UpperTorso_LeftUpperArm.To = Vector2.new(LUA.X, LUA.Y)
                        limbs.LeftUpperArm_LeftLowerArm.From = Vector2.new(LUA.X, LUA.Y)
                        limbs.LeftUpperArm_LeftLowerArm.To = Vector2.new(LLA.X, LLA.Y)
                        limbs.LeftLowerArm_LeftHand.From = Vector2.new(LLA.X, LLA.Y)
                        limbs.LeftLowerArm_LeftHand.To = Vector2.new(LH.X, LH.Y)
                        limbs.UpperTorso_RightUpperArm.From = Vector2.new(UT.X, UT.Y)
                        limbs.UpperTorso_RightUpperArm.To = Vector2.new(RUA.X, RUA.Y)
                        limbs.RightUpperArm_RightLowerArm.From = Vector2.new(RUA.X, RUA.Y)
                        limbs.RightUpperArm_RightLowerArm.To = Vector2.new(RLA.X, RLA.Y)
                        limbs.RightLowerArm_RightHand.From = Vector2.new(RLA.X, RLA.Y)
                        limbs.RightLowerArm_RightHand.To = Vector2.new(RH.X, RH.Y)
                        limbs.LowerTorso_LeftUpperLeg.From = Vector2.new(LT.X, LT.Y)
                        limbs.LowerTorso_LeftUpperLeg.To = Vector2.new(LUL.X, LUL.Y)
                        limbs.LeftUpperLeg_LeftLowerLeg.From = Vector2.new(LUL.X, LUL.Y)
                        limbs.LeftUpperLeg_LeftLowerLeg.To = Vector2.new(LLL.X, LLL.Y)
                        limbs.LeftLowerLeg_LeftFoot.From = Vector2.new(LLL.X, LLL.Y)
                        limbs.LeftLowerLeg_LeftFoot.To = Vector2.new(LF.X, LF.Y)
                        limbs.LowerTorso_RightUpperLeg.From = Vector2.new(LT.X, LT.Y)
                        limbs.LowerTorso_RightUpperLeg.To = Vector2.new(RUL.X, RUL.Y)
                        limbs.RightUpperLeg_RightLowerLeg.From = Vector2.new(RUL.X, RUL.Y)
                        limbs.RightUpperLeg_RightLowerLeg.To = Vector2.new(RLL.X, RLL.Y)
                        limbs.RightLowerLeg_RightFoot.From = Vector2.new(RLL.X, RLL.Y)
                        limbs.RightLowerLeg_RightFoot.To = Vector2.new(RF.X, RF.Y)
                    end
                    Visibility(true)
                else 
                    Visibility(false)
                end
            else 
                Visibility(false)
                if not Players:FindFirstChild(plr.Name) then 
                    for _, v in pairs(limbs) do
                        v:Remove()
                    end
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end

    if R15 then
        coroutine.wrap(UpdaterR15)()
    else 
        coroutine.wrap(UpdaterR15)()
    end
end

-- Tracers ESP
local function DrawTracersESP(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    local line = NewLine(TracerColor, TracerThickness)
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    ESPDrawings[plr]["tracer"] = line
    
    local function Updater()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not TracersEnabled then
                line.Visible = false
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                line.Visible = false
                return
            end
            
            if plr.Character ~= nil and plr.Character:FindFirstChild("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local headpos, OnScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
                if OnScreen then
                    line.Color = TracerColor
                    local offsetCFrame = CFrame.new(0, 0, -TracerLength)
                    local check = false
                    line.From = Vector2.new(headpos.X, headpos.Y)
                    
                    if TracerAutothickness then
                        local distance = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
                        local value = math.clamp(1/distance*100, 0.1, 3)
                        line.Thickness = value
                    else
                        line.Thickness = TracerThickness
                    end
                    
                    repeat
                        local dir = plr.Character.Head.CFrame:ToWorldSpace(offsetCFrame)
                        offsetCFrame = offsetCFrame * CFrame.new(0, 0, TracerSmoothness)
                        local dirpos, vis = Camera:WorldToViewportPoint(Vector3.new(dir.X, dir.Y, dir.Z))
                        if vis then
                            check = true
                            line.To = Vector2.new(dirpos.X, dirpos.Y)
                            line.Visible = true
                            offsetCFrame = CFrame.new(0, 0, -TracerLength)
                        end
                    until check == true
                else 
                    line.Visible = false
                end
            else 
                line.Visible = false
                if not Players:FindFirstChild(plr.Name) then
                    line:Remove()
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

-- Arrows ESP
local function DrawArrowsESP(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    local Arrow = NewTriangle(ArrowColor)
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    ESPDrawings[plr]["arrow"] = Arrow
    
    local function Update()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not ArrowsEnabled then
                Arrow.Visible = false
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                Arrow.Visible = false
                return
            end
            
            if plr and plr.Character then
                local CHAR = plr.Character
                local HUM = CHAR:FindFirstChildOfClass("Humanoid")
                
                if HUM and CHAR.PrimaryPart ~= nil and HUM.Health > 0 then
                    local _,vis = Camera:WorldToViewportPoint(CHAR.PrimaryPart.Position)
                    if vis == false and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        local rel = (CHAR.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position)
                        local direction = Vector2.new(rel.X, rel.Z).Unit
                        
                        local base  = direction * ArrowDistance
                        local sideLength = ArrowWidth/2
                        local baseL = base + Vector2.new(-direction.Y, direction.X) * sideLength
                        local baseR = base + Vector2.new(direction.Y, -direction.X) * sideLength
                        
                        local tip = direction * (ArrowDistance + ArrowHeight)
                        
                        local screenCenter = Camera.ViewportSize/2
                        
                        Arrow.Color = ArrowColor
                        Arrow.PointA = screenCenter + baseL
                        Arrow.PointB = screenCenter + baseR
                        Arrow.PointC = screenCenter + tip
                        Arrow.Visible = true
                    else 
                        Arrow.Visible = false 
                    end
                else 
                    Arrow.Visible = false
                end
            else 
                Arrow.Visible = false
                if not plr or not plr.Parent then
                    Arrow:Remove()
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Radar ESP
local RadarBackground = NewCircle(0.9, RadarBackColor, RadarRadius, true, 1)
local RadarBorder = NewCircle(0.75, RadarBorderColor, RadarRadius, false, 3)
local LocalPlayerDot = Drawing.new("Triangle")
LocalPlayerDot.Visible = true
LocalPlayerDot.Thickness = 1
LocalPlayerDot.Filled = true
LocalPlayerDot.Color = LocalPlayerDotColor
LocalPlayerDot.PointA = RadarPosition + Vector2.new(0, -6)
LocalPlayerDot.PointB = RadarPosition + Vector2.new(-3, 6)
LocalPlayerDot.PointC = RadarPosition + Vector2.new(3, 6)

local function GetRelative(pos)
    local char = LocalPlayer.Character
    if char ~= nil and char.PrimaryPart ~= nil then
        local pmpart = char.PrimaryPart
        local camerapos = Vector3.new(Camera.CFrame.Position.X, pmpart.Position.Y, Camera.CFrame.Position.Z)
        local newcf = CFrame.new(pmpart.Position, camerapos)
        local r = newcf:PointToObjectSpace(pos)
        return r.X, r.Z
    else
        return 0, 0
    end
end

local function PlaceDot(plr)
    if ESPTeamCheck and IsESPSameTeam(plr) then return end
    
    local PlayerDot = NewCircle(1, PlayerDotColor, 3, true, 1)
    
    if not ESPDrawings[plr] then ESPDrawings[plr] = {} end
    ESPDrawings[plr]["radar_dot"] = PlayerDot
    
    local function Update()
        local connection
        connection = RS.RenderStepped:Connect(function()
            if not RadarESPEnabled then
                PlayerDot.Visible = false
                return
            end
            
            if ESPTeamCheck and IsESPSameTeam(plr) then
                PlayerDot.Visible = false
                return
            end
            
            local char = plr.Character
            if char and char:FindFirstChildOfClass("Humanoid") and char.PrimaryPart ~= nil and char:FindFirstChildOfClass("Humanoid").Health > 0 then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local scale = RadarScale
                local relx, rely = GetRelative(char.PrimaryPart.Position)
                local newpos = RadarPosition - Vector2.new(relx * scale, rely * scale) 
                
                if (newpos - RadarPosition).magnitude < RadarRadius-2 then 
                    PlayerDot.Radius = 3   
                    PlayerDot.Position = newpos
                    PlayerDot.Visible = true
                else 
                    local dist = (RadarPosition - newpos).magnitude
                    local calc = (RadarPosition - newpos).unit * (dist - RadarRadius)
                    local inside = Vector2.new(newpos.X + calc.X, newpos.Y + calc.Y)
                    PlayerDot.Radius = 2
                    PlayerDot.Position = inside
                    PlayerDot.Visible = true
                end

                PlayerDot.Color = PlayerDotColor
                
                if RadarHealthColor then
                    local healthPercent = hum.Health / hum.MaxHealth
                    PlayerDot.Color = Color3.fromRGB(
                        255 * (1 - healthPercent),
                        255 * healthPercent,
                        0
                    )
                end
            else 
                PlayerDot.Visible = false
                if not Players:FindFirstChild(plr.Name) then
                    PlayerDot:Remove()
                    if ESPDrawings[plr] then
                        ESPDrawings[plr] = nil
                    end
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

-- Initialize ESP for all players
local function InitializeESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if QuadESPEnabled then DrawQuadESP(plr) end
            if BoxESPEnabled then DrawBoxESP(plr) end
            if SkeletonESPEnabled then DrawSkeletonESP(plr) end
            if TracersEnabled then DrawTracersESP(plr) end
            if ArrowsEnabled then DrawArrowsESP(plr) end
            if RadarESPEnabled then PlaceDot(plr) end
        end
    end
end

-- Toggle ESP functions
local function ToggleQuadESP(enabled)
    QuadESPEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["quad"]) then
                DrawQuadESP(plr)
            end
        end
    end
end

local function ToggleBoxESP(enabled)
    BoxESPEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["box_TL1"]) then
                DrawBoxESP(plr)
            end
        end
    end
end

local function ToggleSkeletonESP(enabled)
    SkeletonESPEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["skeleton_Head_UpperTorso"]) then
                DrawSkeletonESP(plr)
            end
        end
    end
end

local function ToggleTracersESP(enabled)
    TracersEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["tracer"]) then
                DrawTracersESP(plr)
            end
        end
    end
end

local function ToggleArrowsESP(enabled)
    ArrowsEnabled = enabled
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["arrow"]) then
                DrawArrowsESP(plr)
            end
        end
    end
end

local function ToggleRadarESP(enabled)
    RadarESPEnabled = enabled
    RadarBackground.Visible = enabled
    RadarBorder.Visible = enabled
    LocalPlayerDot.Visible = enabled
    
    if enabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and (not ESPDrawings[plr] or not ESPDrawings[plr]["radar_dot"]) then
                PlaceDot(plr)
            end
        end
    else
        RadarBackground.Visible = false
        RadarBorder.Visible = false
        LocalPlayerDot.Visible = false
    end
end

-- Health ESP functions
local function ToggleHealthESP(enabled)
    HealthESPEnabled = enabled
    if enabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateHealthESP(player)
            end
        end
    else
        DisableHealthESP()
    end
end

-- Update radar position
RS.RenderStepped:Connect(function()
    if RadarESPEnabled then
        LocalPlayerDot.Color = LocalPlayerDotColor
        LocalPlayerDot.PointA = RadarPosition + Vector2.new(0, -6)
        LocalPlayerDot.PointB = RadarPosition + Vector2.new(-3, 6)
        LocalPlayerDot.PointC = RadarPosition + Vector2.new(3, 6)
        
        RadarBackground.Position = RadarPosition
        RadarBackground.Radius = RadarRadius
        RadarBackground.Color = RadarBackColor

        RadarBorder.Position = RadarPosition
        RadarBorder.Radius = RadarRadius
        RadarBorder.Color = RadarBorderColor
    end
end)

-- Draggable radar
local inset = game:GetService("GuiService"):GetGuiInset()
local dragging = false
local offset = Vector2.new(0, 0)

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and RadarESPEnabled and (Vector2.new(Mouse.X, Mouse.Y + inset.Y) - RadarPosition).magnitude < RadarRadius then
        offset = RadarPosition - Vector2.new(Mouse.X, Mouse.Y)
        dragging = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RS.RenderStepped:Connect(function()
    if dragging then
        RadarPosition = Vector2.new(Mouse.X, Mouse.Y) + offset
    end
end)

-- Player added/removed handlers
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        if QuadESPEnabled then DrawQuadESP(player) end
        if BoxESPEnabled then DrawBoxESP(player) end
        if SkeletonESPEnabled then DrawSkeletonESP(player) end
        if TracersEnabled then DrawTracersESP(player) end
        if ArrowsEnabled then DrawArrowsESP(player) end
        if RadarESPEnabled then PlaceDot(player) end
        if HealthESPEnabled then CreateHealthESP(player) end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if ESPDrawings[player] then
        for _, drawing in pairs(ESPDrawings[player]) do
            if drawing and typeof(drawing) == "table" and drawing.Remove then
                drawing:Remove()
            end
        end
        ESPDrawings[player] = nil
    end
    if HealthDrawings[player] then
        RemoveHealthESP(player)
    end
end)

-- Initialize ESP
InitializeESP()

-- Initialize Health ESP
if HealthESPEnabled then
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateHealthESP(player)
        end
    end
end

--================= UI ELEMENTS =====================--

-- AIMBOT SECTION
sections.Section1:AddToggle({
    text = "Aimbot Enabled",
    flag = "AimbotEnabled",
    callback = function(v)
        Aimbot.Enabled = v
    end
})

sections.Section1:AddBind({
    text = "Aimbot Keybind",
    flag = "AimbotKey",
    nomouse = true,
    noindicator = true,
    tooltip = "Key used to activate aimbot",
    mode = "both",
    bind = Aimbot.Key,
    risky = false,
    keycallback = function(key)
        Aimbot.Key = key
    end,
    changed = function(mode)
        Aimbot.Mode = mode
    end
})

sections.Section1:AddSlider({
    text = "Smoothing",
    flag = "Smooth",
    min = 0.01,
    max = 1,
    increment = 0.01,
    value = Aimbot.Smoothing,
    callback = function(v)
        Aimbot.Smoothing = v
    end
})

sections.Section1:AddSlider({
    text = "FOV Size",
    flag = "FOV",
    min = 25,
    max = 300,
    value = Aimbot.FOV,
    callback = function(v)
        Aimbot.FOV = v
    end
})

sections.Section1:AddColor({
    enabled = true,
    text = "FOV Color",
    flag = "FOVColor",
    tooltip = "Circle Color",
    color = Aimbot.FOVColor,
    trans = 0,
    open = false,
    callback = function(c)
        Aimbot.FOVColor = c
    end
})

sections.Section1:AddList({
    enabled = true,
    text = "Aimbot Type",
    flag = "Type",
    multi = false,
    tooltip = "CFrame or Mouse",
    values = {"CFrame","Mouse"},
    value = "CFrame",
    callback = function(v)
        Aimbot.Type = v
    end
})

sections.Section1:AddList({
    enabled = true,
    text = "Mouse Activation",
    flag = "ActivationButton",
    multi = false,
    tooltip = "LeftClick, RightClick or None",
    values = {"LeftClick","RightClick","None"},
    value = "LeftClick",
    callback = function(v)
        Aimbot.Activation = v
    end
})

sections.Section1:AddSlider({
    text = "Prediction",
    flag = "Prediction",
    min = 0,
    max = 2,
    increment = 0.01,
    value = Aimbot.Prediction,
    callback = function(v)
        Aimbot.Prediction = v
    end
})

sections.Section1:AddToggle({
    text = "Team Check",
    flag = "TeamCheck",
    callback = function(v)
        Aimbot.TeamCheck = v
    end
})

sections.Section1:AddToggle({
    text = "Visibility Check",
    flag = "VisCheck",
    callback = function(v)
        Aimbot.VisCheck = v
    end
})

sections.Section1:AddToggle({
    text = "Allow Bot Lock",
    flag = "BotCheck",
    callback = function(v)
        Aimbot.BotCheck = v
    end
})

sections.Section1:AddList({
    enabled = true,
    text = "Aimbot Bone",
    flag = "Bone",
    multi = false,
    tooltip = "Choose a bone",
    values = { "Head", "UpperTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" },
    value = "HumanoidRootPart",
    callback = function(v)
        Aimbot.Bone = v
    end
})

-- SILENT AIM SECTION
sections.Section2:AddToggle({
    text = "Silent Aim Enabled",
    flag = "SilentAimEnabled",
    callback = function(v)
        SilentAim.Enabled = v
        if v and not SilentAim_ShootEvent then
            library:SendNotification("Warning: Could not find Shoot event!", 5, Color3.new(1, 0, 0))
        end
    end
})

sections.Section2:AddToggle({
    text = "Team Check",
    flag = "SilentAimTeamCheck",
    callback = function(v)
        SilentAim.TeamCheck = v
    end
})

sections.Section2:AddSlider({
    text = "Hit Chance",
    flag = "SilentAimHitChance",
    min = 0,
    max = 100,
    increment = 1,
    value = SilentAim.HitChance,
    callback = function(v)
        SilentAim.HitChance = v
    end
})

sections.Section2:AddList({
    enabled = true,
    text = "Aim Bone",
    flag = "SilentAimBone",
    multi = false,
    tooltip = "Choose a bone to aim at",
    values = { "Head", "UpperTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg" },
    value = "Head",
    callback = function(v)
        SilentAim.Bone = v
    end
})

sections.Section2:AddSlider({
    text = "FOV Radius",
    flag = "SilentAimFOVRadius",
    min = 10,
    max = 300,
    increment = 5,
    value = SilentAim.FOVRadius,
    callback = function(v)
        SilentAim.FOVRadius = v
    end
})

sections.Section2:AddColor({
    enabled = true,
    text = "FOV Color",
    flag = "SilentAimFOVColor",
    color = SilentAim.FOVColor,
    trans = 0,
    open = false,
    callback = function(c)
        SilentAim.FOVColor = c
    end
})

sections.Section2:AddSlider({
    text = "FOV Transparency",
    flag = "SilentAimFOVTransparency",
    min = 0,
    max = 1,
    increment = 0.1,
    value = SilentAim.FOVTransparency,
    callback = function(v)
        SilentAim.FOVTransparency = v
    end
})

sections.Section2:AddSlider({
    text = "FOV Thickness",
    flag = "SilentAimFOVThickness",
    min = 1,
    max = 5,
    increment = 0.5,
    value = SilentAim.FOVThickness,
    callback = function(v)
        SilentAim.FOVThickness = v
    end
})

sections.Section2:AddToggle({
    text = "Show FOV",
    flag = "SilentAimFOVVisible",
    callback = function(v)
        SilentAim.FOVVisible = v
    end
})

-- EXPLOITS SECTION
sections.ExploitSection:AddToggle({
    text = "SpinBot",
    flag = "SpinBot",
    callback = function(v)
        SpinBotEnabled = v
    end
})

sections.ExploitSection:AddSlider({
    text = "SpinBot Speed",
    flag = "SpinSpeed",
    suffix = "",
    value = 1,
    min = 1,
    max = 20,
    increment = 0.5,
    tooltip = "Spin Speed",
    callback = function(v)
        SpinSpeed = v
    end
})

sections.ExploitSection:AddToggle({
    text = "Infinite Jump",
    flag = "InfJump",
    callback = function(v)
        InfJumpEnabled = v
    end
})

sections.ExploitSection:AddToggle({
    text = "Fly",
    flag = "FlyEnabled",
    callback = function(v)
        FlyEnabled = v
    end
})

sections.ExploitSection:AddList({
    enabled = true,
    text = "Fly Mode",
    flag = "FlyMode",
    multi = false,
    tooltip = "Smooth or Velocity",
    values = {"Smooth","Velocity"},
    value = "Smooth",
    callback = function(v)
        FlyMode = v
    end
})

sections.ExploitSection:AddSlider({
    text = "Fly Speed",
    flag = "FlySpeed",
    value = 1,
    min = 0.1,
    max = 5,
    increment = 0.1,
    tooltip = "Fly Speed",
    callback = function(v)
        FlySpeed = v
    end
})

sections.ExploitSection:AddToggle({
    text = "Speed Enabled",
    flag = "SpeedEnabled",
    callback = function(v)
        SpeedEnabled = v
    end
})

sections.ExploitSection:AddSlider({
    text = "WalkSpeed",
    flag = "WalkSpeed",
    value = 16,
    min = 16,
    max = 500,
    increment = 1,
    tooltip = "WalkSpeed",
    callback = function(v)
        WalkSpeedValue = v
    end
})

sections.ExploitSection:AddToggle({
    text = "JumpPower Enabled",
    flag = "JumpEnabled",
    callback = function(v)
        JumpEnabled = v
    end
})

sections.ExploitSection:AddSlider({
    text = "JumpPower",
    flag = "JumpPower",
    value = 50,
    min = 50,
    max = 500,
    increment = 1,
    tooltip = "JumpPower",
    callback = function(v)
        JumpPowerValue = v
    end
})

-- TELEPORT SECTION
sections.TeleportSection:AddToggle({
    text = "Team Check",
    flag = "TeamCheckEnabled",
    callback = function(v)
        TeamCheckEnabled = v
        library:SendNotification("Team Check: " .. (v and "ON" or "OFF"), 2, Color3.new(0, 1, 0))
    end
})

sections.TeleportSection:AddToggle({
    text = "Auto Switch on Death",
    flag = "AutoSwitchOnDeathEnabled",
    callback = function(v)
        AutoSwitchOnDeathEnabled = v
        library:SendNotification("Auto Switch: " .. (v and "ON" or "OFF"), 2, Color3.new(0, 1, 0))
    end
})

sections.TeleportSection:AddToggle({
    text = "Teleport Enabled",
    flag = "TeleportEnabled",
    callback = function(v)
        TeleportEnabled = v
    end
})

sections.TeleportSection:AddToggle({
    text = "Teleport Loop",
    flag = "TeleportLoopEnabled",
    callback = function(v)
        TeleportLoopEnabled = v
    end
})

sections.TeleportSection:AddList({
    enabled = true,
    text = "Teleport Offset",
    flag = "TP_Offset",
    multi = false,
    tooltip = "Above / Below / Behind / InFront",
    values = {"Above","Below","Behind","InFront"},
    value = "Above",
    callback = function(v)
        TeleportOffset = v
    end
})

sections.TeleportSection:AddSlider({
    text = "Teleport Distance",
    flag = "TP_Distance",
    value = 5,
    min = 1,
    max = 50,
    increment = 1,
    tooltip = "Distance for teleport",
    callback = function(v)
        TeleportDistance = v
    end
})

sections.TeleportSection:AddList({
    enabled = true,
    text = "Target Player",
    flag = "TP_Target",
    multi = false,
    tooltip = "Select Player",
    values = (function()
        local list = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then 
                table.insert(list, plr.Name)
            end
        end
        return list
    end)(),
    value = "",
    callback = function(v)
        TeleportTarget = v
        if TeleportEnabled then
            TeleportToPlayer(v)
        end
    end
})

sections.TeleportSection:AddToggle({
    text = "Teleport All In Front",
    flag = "TeleportAllEnabled",
    callback = function(v)
        TeleportAllEnabled = v
    end
})

sections.TeleportSection:AddSlider({
    text = "Teleport All Distance",
    flag = "TP_AllDist",
    value = 5,
    min = 1,
    max = 50,
    increment = 1,
    tooltip = "Distance to teleport everyone",
    callback = function(v)
        TeleportAllDistance = v
    end
})

sections.TeleportSection:AddToggle({
    text = "Spin Everyone",
    flag = "SpinEveryoneEnabled",
    callback = function(v)
        SpinEveryoneEnabled = v
    end
})

sections.TeleportSection:AddSlider({
    text = "Spin Everyone Speed",
    flag = "SpinEveryoneSpeed",
    value = 1,
    min = 1,
    max = 20,
    increment = 0.5,
    tooltip = "Spin all players",
    callback = function(v)
        SpinEveryoneSpeed = v
    end
})

sections.TeleportSection:AddButton({
    enabled = true,
    text = "Auto Select Random Target",
    flag = "AutoSelectTarget",
    tooltip = "Automatically select a random target",
    risky = false,
    confirm = false,
    callback = function()
        local newTarget = GetRandomTarget()
        if newTarget then
            TeleportTarget = newTarget.Name
            sections.TeleportSection:UpdateValue("TP_Target", newTarget.Name)
            library:SendNotification("Selected: " .. newTarget.Name, 3, Color3.new(0, 1, 0))
        else
            library:SendNotification("No valid targets found!", 3, Color3.new(1, 0, 0))
        end
    end
})

sections.ExploitSection:AddButton({
    enabled = true,
    text = "Join Bot Lobby",
    flag = "JoinBotLobby",
    tooltip = "Teleport to bot lobby",
    risky = false,
    confirm = true,
    callback = function()
        local placeId = 82097489006022
        local jobId = "3386cc49-1059-4b2f-b7ac-7894705e15fa"
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LocalPlayer)
    end
})

-- ESP ALL SECTION
sections.ESPAllSection:AddToggle({
    text = "Team Check",
    flag = "ESPTeamCheck",
    callback = function(v)
        ESPTeamCheck = v
        if v then
            library:SendNotification("ESP Team Check: ON - Only showing enemies", 3, Color3.new(0, 1, 0))
        else
            library:SendNotification("ESP Team Check: OFF - Showing all players", 3, Color3.new(1, 0.5, 0))
        end
    end
})

sections.ESPAllSection:AddToggle({
    text = "Rainbow Everything",
    flag = "RainbowEverything",
    callback = function(v)
        RainbowEverything = v
        if v then
            StartRainbowEffect()
        end
    end
})

sections.ESPAllSection:AddSlider({
    text = "Rainbow Speed",
    flag = "RainbowSpeed",
    min = 0.05,
    max = 1,
    increment = 0.05,
    value = RainbowSpeed,
    callback = function(v)
        RainbowSpeed = v
    end
})

-- Quad ESP
sections.ESPAllSection:AddToggle({
    text = "Quad ESP (Full Box)",
    flag = "QuadESPEnabled",
    callback = function(v)
        ToggleQuadESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Quad Color",
    flag = "QuadColor",
    color = QuadColor,
    trans = 0,
    open = false,
    callback = function(c)
        QuadColor = c
    end
})

sections.ESPAllSection:AddSlider({
    text = "Quad Thickness",
    flag = "QuadThickness",
    min = 1,
    max = 5,
    increment = 0.5,
    value = QuadThickness,
    callback = function(v)
        QuadThickness = v
    end
})

-- Box ESP
sections.ESPAllSection:AddToggle({
    text = "Box ESP (Corners)",
    flag = "BoxESPEnabled",
    callback = function(v)
        ToggleBoxESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Box Color",
    flag = "BoxColor",
    color = BoxColor,
    trans = 0,
    open = false,
    callback = function(c)
        BoxColor = c
    end
})

sections.ESPAllSection:AddSlider({
    text = "Box Thickness",
    flag = "BoxThickness",
    min = 1,
    max = 10,
    increment = 1,
    value = BoxThickness,
    callback = function(v)
        BoxThickness = v
    end
})

sections.ESPAllSection:AddToggle({
    text = "Box Auto Thickness",
    flag = "BoxAutothickness",
    callback = function(v)
        BoxAutothickness = v
    end
})

-- Skeleton ESP
sections.ESPAllSection:AddToggle({
    text = "Skeleton ESP",
    flag = "SkeletonESPEnabled",
    callback = function(v)
        ToggleSkeletonESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Skeleton Color",
    flag = "SkeletonColor",
    color = SkeletonColor,
    trans = 0,
    open = false,
    callback = function(c)
        SkeletonColor = c
    end
})

sections.ESPAllSection:AddSlider({
    text = "Skeleton Thickness",
    flag = "SkeletonThickness",
    min = 1,
    max = 5,
    increment = 0.5,
    value = SkeletonThickness,
    callback = function(v)
        SkeletonThickness = v
    end
})

-- Tracers
sections.ESPAllSection:AddToggle({
    text = "Tracers",
    flag = "TracersEnabled",
    callback = function(v)
        ToggleTracersESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Tracer Color",
    flag = "TracerColor",
    color = TracerColor,
    trans = 0,
    open = false,
    callback = function(c)
        TracerColor = c
    end
})

sections.ESPAllSection:AddSlider({
    text = "Tracer Thickness",
    flag = "TracerThickness",
    min = 0.5,
    max = 5,
    increment = 0.5,
    value = TracerThickness,
    callback = function(v)
        TracerThickness = v
    end
})

sections.ESPAllSection:AddToggle({
    text = "Tracer Auto Thickness",
    flag = "TracerAutothickness",
    callback = function(v)
        TracerAutothickness = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Tracer Length",
    flag = "TracerLength",
    min = 5,
    max = 50,
    increment = 1,
    value = TracerLength,
    callback = function(v)
        TracerLength = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Tracer Smoothness",
    flag = "TracerSmoothness",
    min = 0.01,
    max = 1,
    increment = 0.01,
    value = TracerSmoothness,
    callback = function(v)
        TracerSmoothness = v
    end
})

-- Arrows
sections.ESPAllSection:AddToggle({
    text = "Arrows (Off-screen)",
    flag = "ArrowsEnabled",
    callback = function(v)
        ToggleArrowsESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Arrow Color",
    flag = "ArrowColor",
    color = ArrowColor,
    trans = 0,
    open = false,
    callback = function(c)
        ArrowColor = c
    end
})

sections.ESPAllSection:AddSlider({
    text = "Arrow Distance",
    flag = "ArrowDistance",
    min = 50,
    max = 200,
    increment = 5,
    value = ArrowDistance,
    callback = function(v)
        ArrowDistance = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Arrow Height",
    flag = "ArrowHeight",
    min = 10,
    max = 50,
    increment = 2,
    value = ArrowHeight,
    callback = function(v)
        ArrowHeight = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Arrow Width",
    flag = "ArrowWidth",
    min = 10,
    max = 50,
    increment = 2,
    value = ArrowWidth,
    callback = function(v)
        ArrowWidth = v
    end
})

sections.ESPAllSection:AddToggle({
    text = "Arrow Filled",
    flag = "ArrowFilled",
    callback = function(v)
        ArrowFilled = v
    end
})

sections.ESPAllSection:AddToggle({
    text = "Anti-Aliasing",
    flag = "AntiAliasing",
    callback = function(v)
        AntiAliasing = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Arrow Thickness",
    flag = "ArrowThickness",
    min = 0.5,
    max = 5,
    increment = 0.5,
    value = ArrowThickness,
    callback = function(v)
        ArrowThickness = v
    end
})

-- Radar
sections.ESPAllSection:AddToggle({
    text = "Radar ESP",
    flag = "RadarESPEnabled",
    callback = function(v)
        ToggleRadarESP(v)
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Radar Background",
    flag = "RadarBackColor",
    color = RadarBackColor,
    trans = 0,
    open = false,
    callback = function(c)
        RadarBackColor = c
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Radar Border",
    flag = "RadarBorderColor",
    color = RadarBorderColor,
    trans = 0,
    open = false,
    callback = function(c)
        RadarBorderColor = c
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Player Dot Color",
    flag = "PlayerDotColor",
    color = PlayerDotColor,
    trans = 0,
    open = false,
    callback = function(c)
        PlayerDotColor = c
    end
})

sections.ESPAllSection:AddColor({
    enabled = true,
    text = "Local Player Dot",
    flag = "LocalPlayerDotColor",
    color = LocalPlayerDotColor,
    trans = 0,
    open = false,
    callback = function(c)
        LocalPlayerDotColor = c
    end
})

sections.ESPAllSection:AddToggle({
    text = "Radar Health Color",
    flag = "RadarHealthColor",
    callback = function(v)
        RadarHealthColor = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Radar Radius",
    flag = "RadarRadius",
    min = 50,
    max = 300,
    increment = 10,
    value = RadarRadius,
    callback = function(v)
        RadarRadius = v
    end
})

sections.ESPAllSection:AddSlider({
    text = "Radar Scale",
    flag = "RadarScale",
    min = 0.1,
    max = 5,
    increment = 0.1,
    value = RadarScale,
    callback = function(v)
        RadarScale = v
    end
})

-- HEALTH ESP SECTION
sections.HealthESPSection:AddToggle({
    text = "Health ESP Enabled",
    flag = "HealthESPEnabled",
    callback = function(v)
        ToggleHealthESP(v)
    end
})

sections.HealthESPSection:AddToggle({
    text = "Show Health",
    flag = "HealthESPToggle",
    callback = function(v)
        HealthESPToggle = v
    end
})

sections.HealthESPSection:AddToggle({
    text = "Team Check",
    flag = "HealthTeamCheck",
    callback = function(v)
        HealthTeamCheck = v
    end
})

sections.HealthESPSection:AddToggle({
    text = "Show Team",
    flag = "HealthShowTeam",
    callback = function(v)
        HealthShowTeam = v
    end
})

sections.HealthESPSection:AddColor({
    enabled = true,
    text = "Enemy Color",
    flag = "HealthEnemyColor",
    color = HealthEnemyColor,
    trans = 0,
    open = false,
    callback = function(c)
        HealthEnemyColor = c
    end
})

sections.HealthESPSection:AddColor({
    enabled = true,
    text = "Ally Color",
    flag = "HealthAllyColor",
    color = HealthAllyColor,
    trans = 0,
    open = false,
    callback = function(c)
        HealthAllyColor = c
    end
})

sections.HealthESPSection:AddColor({
    enabled = true,
    text = "Neutral Color",
    flag = "HealthNeutralColor",
    color = HealthNeutralColor,
    trans = 0,
    open = false,
    callback = function(c)
        HealthNeutralColor = c
    end
})

sections.HealthESPSection:AddColor({
    enabled = true,
    text = "Health Bar Color",
    flag = "HealthBarColor",
    color = HealthBarColor,
    trans = 0,
    open = false,
    callback = function(c)
        HealthBarColor = c
    end
})

sections.HealthESPSection:AddList({
    enabled = true,
    text = "Health Style",
    flag = "HealthStyle",
    multi = false,
    tooltip = "Bar, Text, or Both",
    values = {"Bar", "Text", "Both"},
    value = "Bar",
    callback = function(v)
        HealthStyle = v
    end
})

sections.HealthESPSection:AddList({
    enabled = true,
    text = "Health Bar Side",
    flag = "HealthBarSide",
    multi = false,
    tooltip = "Left or Right",
    values = {"Left", "Right"},
    value = "Left",
    callback = function(v)
        HealthBarSide = v
    end
})

sections.HealthESPSection:AddSlider({
    text = "Text Size",
    flag = "HealthTextSize",
    min = 8,
    max = 24,
    increment = 1,
    value = HealthTextSize,
    callback = function(v)
        HealthTextSize = v
    end
})

sections.HealthESPSection:AddSlider({
    text = "Font",
    flag = "HealthTextFont",
    min = 0,
    max = 3,
    increment = 1,
    value = HealthTextFont,
    callback = function(v)
        HealthTextFont = v
    end
})

sections.HealthESPSection:AddSlider({
    text = "Max Distance",
    flag = "HealthMaxDistance",
    min = 100,
    max = 5000,
    increment = 100,
    value = HealthMaxDistance,
    callback = function(v)
        HealthMaxDistance = v
    end
})

sections.HealthESPSection:AddSlider({
    text = "Refresh Rate",
    flag = "HealthRefreshRate",
    min = 1/60,
    max = 1/10,
    increment = 1/120,
    value = HealthRefreshRate,
    callback = function(v)
        HealthRefreshRate = v
    end
})

sections.HealthESPSection:AddBox({
    text = "Health Text Suffix",
    flag = "HealthTextSuffix",
    placeholder = "HP",
    value = "HP",
    callback = function(v)
        HealthTextSuffix = v
    end
})

library:SendNotification("Aimbot & Exploits & ESP & Silent Aim & Health ESP Loaded!", 5, Color3.new(255, 0, 0))
