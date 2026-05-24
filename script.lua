-- R On Top 🔥 - Kingdom World Script
-- Delta Executor Version
-- Loaded via loadstring from GitHub

local RS=game:GetService("RunService")
local Players=game:GetService("Players")
local Player=Players.LocalPlayer
local Character=Player.Character or Player.CharacterAdded:Wait()

local drift=false
local lift=false
local roll=0
local driftConnection
local liftConnection

print("Script Loading... ⏳")

-- Drift System
_G.ToggleDrift = function()
	drift = not drift
	
	if drift then
		workspace.Gravity = 50
		print("Drift ON 🔥")
		
		if driftConnection then
			driftConnection:Disconnect()
		end
		
		driftConnection = RS.Heartbeat:Connect(function()
			local car = workspace:FindFirstChildWhichIsA("VehicleSeat", true)
			if car and car.Occupant and car.Occupant.Parent == Player.Character then
				local p = car.Parent
				
				for _, x in pairs(p:GetDescendants()) do
					if x:IsA("BasePart") then
						x.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.1, 0.5, 1, 1)
					end
				end
			end
		end)
		
	else
		workspace.Gravity = 196.2
		print("Drift OFF ❌")
		
		if driftConnection then
			driftConnection:Disconnect()
			driftConnection = nil
		end
	end
end

-- Lift System (Wheelie)
_G.ToggleLift = function()
	lift = not lift
	print(lift and "Lift ON ⬆️" or "Lift OFF ⬇️")
end

-- Car Detection
local function GetCar()
	local C = Player.Character
	if not C then return end
	
	local H = C:FindFirstChildOfClass("Humanoid")
	if not H or not H.SeatPart then return end
	
	return H.SeatPart:FindFirstAncestorOfClass("Model"), H.SeatPart
end

-- Setup BodyGyro
local function SetupGyro(root)
	local gyro = root:FindFirstChild("Gyro")
	
	if not gyro then
		gyro = Instance.new("BodyGyro")
		gyro.Name = "Gyro"
		gyro.MaxTorque = Vector3.new(0, 0, 4e8)
		gyro.P = 7000
		gyro.D = 1200
		gyro.Parent = root
	end
	
	return gyro
end

-- Lift and Drift Loop
RS.RenderStepped:Connect(function()
	local car, seat = GetCar()
	if not car or not seat then return end
	
	if not car.PrimaryPart then
		car.PrimaryPart = seat
	end
	
	local root = car.PrimaryPart
	local gyro = SetupGyro(root)
	
	-- Smooth lift
	local target = lift and -55 or 0
	roll = roll + ((target - roll) * 0.05)
	
	-- Natural car rotation
	local yaw = math.rad(root.Orientation.Y)
	
	gyro.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, yaw, math.rad(roll))
end)

print("✅ Script Loaded Successfully!")
print("📌 Commands:")
print("   _G.ToggleDrift()  - تشغيل/إيقاف الدريفت")
print("   _G.ToggleLift()   - تشغيل/إيقاف الترفيع")