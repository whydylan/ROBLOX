--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()

local setObjectProperties = function(instance, properties)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	
	return instance
end

local addToolToBackpackObject = function()
	local Teleport = setObjectProperties(Instance.new("Tool"), {
		Name = "Click To Teleport",
		Parent = Players.LocalPlayer.Backpack,
		RequiresHandle = false
	})
	
	Teleport.Activated:Connect(function()
		Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Mouse.Hit
	end)
end

if (Players.LocalPlayer.Character) then
    addToolToBackpackObject()
end

Players.LocalPlayer.CharacterAdded:Connect(addToolToBackpackObject)
