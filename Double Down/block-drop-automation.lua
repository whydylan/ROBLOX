--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Services = {
	RunService = game:GetService("RunService"), Players = game:GetService("Players")
}

local Connections = {}

local clickTextButton = function(button)
	for index, connection in pairs(getconnections(button.Activated)) do
		connection:Fire()
	end

	for index, connection in pairs(getconnections(button.MouseButton1Click)) do
		connection:Fire()
	end

	for index, connection in pairs(getconnections(button.MouseButton1Down)) do
		connection:Fire()
	end

	return true
end

local getPlayerArenaAndSide = function(player)
	for index, model in pairs(workspace.ArenasREAL:GetChildren()) do
		if model:FindFirstChild("ArenaTemplate") and model.ArenaTemplate:FindFirstChild("Blue") and model.ArenaTemplate.Blue:FindFirstChild("Character") and model.ArenaTemplate.Red:FindFirstChild("Character") then
			if model.ArenaTemplate.Blue.Character.Nametag.Frame.Username.Text == "@" .. player.Name then
				return {Arena = model, Side = "Blue"}
			end

			if model.ArenaTemplate.Red.Character.Nametag.Frame.Username.Text == "@" .. player.Name then
				return {Arena = model, Side = "Red"}
			end
		end
	end

	return nil
end

Connections['Block Drop Automation'] = Services['RunService'].RenderStepped:Connect(function()
	local Arena = getPlayerArenaAndSide(Services['Players'].LocalPlayer)
	
	if Arena["Arena"] ~= nil and Arena["Arena"].ArenaTemplate[Arena['Side']]:FindFirstChild("Board") then
		local Level = Arena['Arena'].ArenaTemplate.Blue.CurrentScore.SurfaceGui.TextLabel.Text
		
		if Arena['Arena'].ArenaTemplate[Arena['Side']].Board[Level]["3"].Material == Enum.Material.Neon then
			clickTextButton(Services['Players'].LocalPlayer.PlayerGui.BlockDrop["Bottom Middle"].Buttons.Drop_On)
		end
	end
end)

