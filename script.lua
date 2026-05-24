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

O:Init()