local O=loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local W=O:MakeWindow({Name="R On Top 🔥",HidePremium=false,SaveConfig=false})
local T=W:MakeTab({Name="Car"})
local RS=game:GetService("RunService")
local P=game.Players.LocalPlayer
local lift,drift=false,false
local roll=0
local driftConnection
local currentSpeed=0
local function GetCar()
	local C=P.Character
	if not C then return end
	local H=C:FindFirstChildOfClass("Humanoid")
	if not H or not H.SeatPart then return end
	return H.SeatPart:FindFirstAncestorOfClass("Model"),H.SeatPart
end
local function SetupGyro(root)
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
T:AddSlider({Name="سرعة المشي 🚗",Min=0,Max=500,Default=0,Increment=10,Callback=function(v)currentSpeed=v end})
T:AddToggle({Name="تفحيط 🔥",Default=false,Callback=function(v)
	drift=v
	if drift then
		workspace.Gravity=50
		if driftConnection then driftConnection:Disconnect() end
		driftConnection=RS.Heartbeat:Connect(function()
			local car=workspace:FindFirstChildWhichIsA("VehicleSeat",true)
			if car and car.Occupant and car.Occupant.Parent==P.Character then
				for _,x in pairs(car.Parent:GetDescendants()) do
					if x:IsA("BasePart") then x.CustomPhysicalProperties=PhysicalProperties.new(0.7,0.1,0.5,1,1) end
				end
			end
		end)
	else
		workspace.Gravity=196.2
		if driftConnection then driftConnection:Disconnect() end
	end
end})
T:AddToggle({Name="ترفيع 🔥",Default=false,Callback=function(v)lift=v end})
RS.RenderStepped:Connect(function()
	local car,seat=GetCar()
	if not car or not seat then return end
	if not car.PrimaryPart then car.PrimaryPart=seat end
	local root=car.PrimaryPart
	local gyro=SetupGyro(root)
	local target=lift and -55 or 0
	roll=roll+((target-roll)*0.05)
	gyro.CFrame=CFrame.new(root.Position)*CFrame.Angles(0,math.rad(root.Orientation.Y),math.rad(roll))
	seat.AssemblyLinearVelocity=seat.CFrame.LookVector*currentSpeed
end)
O:Init()
