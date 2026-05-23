local OrionLib=loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local P=game.Players.LocalPlayer
local R=game:GetService("RunService")

OrionLib:MakeNotification({
	Name="R On Top 🔥",
	Content="ارحبو🔥",
	Time=4
})

local W=OrionLib:MakeWindow({
	Name="R On Top 🔥",
	HidePremium=false,
	SaveConfig=false
})

local T=W:MakeTab({
	Name="Car",
	Icon="rbxassetid://4483345998"
})

local lift=false
local roll=0

local function Car()

	local C=P.Character
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

		-- فقط ميلان بدون لمس اللفة
		gyro.MaxTorque=Vector3.new(0,0,4e8)
		gyro.P=7000
		gyro.D=1200
		gyro.Parent=root
	end

	return gyro
end

T:AddToggle({
	Name="الترفيع 🔥",
	Default=false,
	Callback=function(v)
		lift=v
	end
})

R.RenderStepped:Connect(function()

	local car,seat=Car()
	if not car or not seat then return end

	if not car.PrimaryPart then
		car.PrimaryPart=seat
	end

	local root=car.PrimaryPart
	local gyro=Setup(root)

	-- ترفيع ناعم
	local target=lift and -55 or 0
	roll=roll+((target-roll)*0.05)

	-- السيارة تلف طبيعي 100%
	local yaw=math.rad(root.Orientation.Y)

	gyro.CFrame=
		CFrame.new(root.Position)*
		CFrame.Angles(
			0,
			yaw,
			math.rad(roll)
		)

end)

OrionLib:Init()