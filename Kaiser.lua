local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "KaiserStyleGui"
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 190)
frame.Position = UDim2.new(0.72, 0, 0.55, 0)
frame.BackgroundTransparency = 0.15
frame.Parent = gui

local function button(txt, y)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 220, 0, 45)
	b.Position = UDim2.new(0, 10, 0, y)
	b.Text = txt
	b.TextScaled = true
	b.Parent = frame
	return b
end

local dashBtn = button("Warp Step", 10)
local impactBtn = button("Kaiser Impact", 65)
local strideBtn = button("Echo Stride", 120)

-- Aura effect
local function createAura()
	local aura = Instance.new("Part")
	aura.Shape = Enum.PartType.Ball
	aura.Size = Vector3.new(4,4,4)
	aura.Material = Enum.Material.Neon
	aura.Transparency = 0.4
	aura.Anchored = true
	aura.CanCollide = false
	aura.Position = root.Position
	aura.Parent = workspace

	local tween = TweenService:Create(
		aura,
		TweenInfo.new(0.4),
		{
			Size = Vector3.new(8,8,8),
			Transparency = 1
		}
	)

	tween:Play()
	Debris:AddItem(aura, 0.5)
end

-- Screen shake
local function shake()
	local original = camera.CFrame
	for i = 1, 6 do
		camera.CFrame = original * CFrame.new(
			math.random(-1,1)/5,
			math.random(-1,1)/5,
			0
		)
		task.wait(0.03)
	end
	camera.CFrame = original
end

-- Warp Step
dashBtn.MouseButton1Click:Connect(function()
	createAura()
	shake()

	local trail = Instance.new("Part")
	trail.Size = Vector3.new(1,4,8)
	trail.Anchored = true
	trail.CanCollide = false
	trail.Material = Enum.Material.Neon
	trail.Transparency = 0.5
	trail.CFrame = root.CFrame
	trail.Parent = workspace
	Debris:AddItem(trail, 0.3)

	root.CFrame = root.CFrame + root.CFrame.LookVector * 30
end)

-- Kaiser Impact
impactBtn.MouseButton1Click:Connect(function()
	createAura()
	shake()

	local shot = Instance.new("Part")
	shot.Shape = Enum.PartType.Ball
	shot.Size = Vector3.new(3,3,3)
	shot.Material = Enum.Material.Neon
	shot.Position = root.Position + root.CFrame.LookVector * 4
	shot.CanCollide = false
	shot.Parent = workspace

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(999999,999999,999999)
	bv.Velocity = root.CFrame.LookVector * 180
	bv.Parent = shot

	Debris:AddItem(shot, 2)
	Debris:AddItem(bv, 0.5)
end)

-- Echo Stride
strideBtn.MouseButton1Click:Connect(function()
	createAura()

	local oldSpeed = humanoid.WalkSpeed
	humanoid.WalkSpeed = 65

	for i = 1, 8 do
		local afterImage = char:Clone()
		for _, v in pairs(afterImage:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Anchored = true
				v.CanCollide = false
				v.Transparency = 0.6
			end
		end
		afterImage.Parent = workspace
		Debris:AddItem(afterImage, 0.3)
		task.wait(0.1)
	end

	task.wait(1.5)
	humanoid.WalkSpeed = oldSpeed
end)
