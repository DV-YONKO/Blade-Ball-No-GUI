local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local heartbeatConnection

local function startAutoParry()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local ballsFolder = workspace:WaitForChild("Balls")

    print("Script successfully ran.")

    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end

    player.CharacterAdded:Connect(onCharacterAdded)

    local focusedBall = nil  

    local function chooseNewFocusedBall()
        local balls = ballsFolder:GetChildren()
        focusedBall = nil
        for _, ball in ipairs(balls) do
            if ball:GetAttribute("realBall") == true then
                focusedBall = ball
                break
            end
        end
    end

    chooseNewFocusedBall()

    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
        
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
        
        local distanceToBeCovered = distanceToPlayer - 40
        return distanceToBeCovered / velocityTowardsPlayer
    end

    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR = 0.002

    local function getDynamicThreshold(ballVelocityMagnitude)
        local adjustedThreshold = BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR)
        return math.max(0.12, adjustedThreshold)
    end

    local function checkBallDistance()
        if not character:FindFirstChild("Highlight") then return end
        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity

        if focusedBall and not focusedBall.Parent then
            chooseNewFocusedBall()
        end

        if not focusedBall then return end

        local ball = focusedBall
        local distanceToPlayer = (ball.Position - charPos).Magnitude

        if distanceToPlayer < 10 then
            parryButtonPress:Fire()
            return
        end

        local timeToImpact = timeUntilImpact(ball.Velocity, distanceToPlayer, charVel)
        local dynamicThreshold = getDynamicThreshold(ball.Velocity.Magnitude)

        if timeToImpact < dynamicThreshold then
            parryButtonPress:Fire()
        end
    end
    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopAutoParry()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

-- Gui to Lua
-- Version: 3.2

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")
local TextButton_2 = Instance.new("TextButton")

--Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.Position = UDim2.new(0.0833889097, 0, 0.562569201, 0)
Frame.Size = UDim2.new(0, 230, 0, 160)

TextLabel.Parent = Frame
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextLabel.Position = UDim2.new(-0.00203830888, 0, -0.00307044992, 0)
TextLabel.Size = UDim2.new(0, 230, 0, 25)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Blade Ball Skidded Auto Parry - nfpw"
TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton.Position = UDim2.new(0.0700469762, 0, 0.358639956, 0)
TextButton.Size = UDim2.new(0.321920365, 0, 0.275855243, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Enable"
TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton.TextScaled = true
TextButton.TextSize = 14.000
TextButton.TextStrokeTransparency = 0.000
TextButton.TextWrapped = true

TextButton_2.Parent = Frame
TextButton_2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
TextButton_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextButton_2.Position = UDim2.new(0.591082573, 0, 0.358639956, 0)
TextButton_2.Size = UDim2.new(0.321920365, 0, 0.275855243, 0)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "Disable"
TextButton_2.TextColor3 = Color3.fromRGB(255, 255, 255)
TextButton_2.TextScaled = true
TextButton_2.TextSize = 14.000
TextButton_2.TextStrokeTransparency = 0.000
TextButton_2.TextWrapped = true

-- Scripts:

local function NHOVBS_fake_script() -- Frame.GuiDrag 
	local script = Instance.new('LocalScript', Frame)

	local 	Frame = script.Parent.Parent.Frame
	
	Frame.Draggable = true
	Frame.Active = true
	
	
	
end
coroutine.wrap(NHOVBS_fake_script)()
local function HTPDFXZ_fake_script() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript', TextButton)

	local startButton = script.Parent
	
	startButton.MouseButton1Click:Connect(function()
		startAutoParry()
	end)
end
coroutine.wrap(HTPDFXZ_fake_script)()
local function ZDNHQM_fake_script() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript', TextButton_2)

	local stopButton = script.Parent
	
	stopButton.MouseButton1Click:Connect(function()
		stopAutoParry()
	end)
end
coroutine.wrap(ZDNHQM_fake_script)()
