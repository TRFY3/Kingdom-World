-- R On Top 🔥 - Kingdom World Script
-- Loaded via loadstring from GitHub

local O=loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local W=O:MakeWindow({
	Name="R On Top 🔥",
	HidePremium=false,
	SaveConfig=false
})

local T=W:MakeTab({
	Name="Car"
})

local RS=game:GetService("RunService")
local drift=false
local lift=false
local roll=0
local con

T:AddToggle({
	Name="Drift + Gravity 🔥",
	Default=false,
	Callback=function(v)
		drift=v

		if v then
			workspace.Gravity=50

			con=RS.Heartbeat:Connect(function()
				local car=workspace:FindFirstChildWhichIsA("VehicleSeat",true)
				if car and car.Occupant and car.Occupant.Parent==game.Players.LocalPlayer.Character then
					local p=car.Parent

					for _,x in pairs(p:GetDescendants()) do
						if x:IsA("BasePart") then
							x.CustomPhysicalProperties=PhysicalProperties.new(0.7,0.1,0.5,1,1)
						end
					end
				end
			end)

			O:MakeNotification({
				Name="R On Top 🔥",
				Content="Drift ON 🔥",
				Time=3
			})

		else
			workspace.Gravity=196.2

			if con then
				con:Disconnect()
			end

			O:MakeNotification({
				Name="R On Top 🔥",
				Content="Drift OFF ❌",
				Time=3
			})
		end
	end
})

T:AddToggle({
	Name="الترفيع 🔥",
	Default=false,
	Callback=function(v)
		lift=v
	end
})

local function Car()
	local C=game.Players.LocalPlayer.Character
	if not C then return end

	local H=C:FindFirstChildOfClass("Humanoid")
	if not H or not H.SeatPart then return end

	return H.SeatPart:FindFirstAncestorOfClass("Model"),H.SeatPart
end

local function Setup(root)
	local gyro=root:FindFirstChild("Gyro")

	if not gyro then
		gyro=Instance.new("BodyGyro")
		gyro.Name="Gyro"
		gyro.MaxTorque=Vector3.new(0,0,4e8)
		gyro.P=7000
		gyro.D=1200
		gyro.Parent=root
	end

	return gyro
end

RS.RenderStepped:Connect(function()
	local car,seat=Car()
	if not car or not seat then return end

	if not car.PrimaryPart then
		car.PrimaryPart=seat
	end

	local root=car.PrimaryPart
	local gyro=Setup(root)

	-- ترفيع ناعم الكفرات اليمنى
	local target=lift and -55 or 0
	roll=roll+((target-roll)*0.05)

	local yaw=math.rad(root.Orientation.Y)

	gyro.CFrame=
		CFrame.new(root.Position)*
		CFrame.Angles(
			0,
			yaw,
			math.rad(roll)
		)
end)

O:Init()