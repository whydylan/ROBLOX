--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Connections = {}

local Services = {
	RunService = game:GetService("RunService"), Players = game:GetService("Players"), CoreGui = game:GetService("CoreGui")
}

local findPlayerArena = function(player)
	for index, model in pairs(workspace.ArenasREAL:GetChildren()) do
		if model:FindFirstChild("ArenaTemplate") and model.ArenaTemplate:FindFirstChild("Blue") and model.ArenaTemplate.Blue:FindFirstChild("Character") and model.ArenaTemplate.Red:FindFirstChild("Character") then
			if model.ArenaTemplate.Blue.Character.Nametag.Frame.Username.Text == "@" .. player.Name then
				return model
			end

			if model.ArenaTemplate.Red.Character.Nametag.Frame.Username.Text == "@" .. player.Name then
				return model
			end
		end
	end

	return nil
end

local getCupsPath = function(arena)
	local Blacklist = {'Diamonds', 'CupPositions'}

	for index, folder in pairs(arena.ArenaTemplate.Important:GetDescendants()) do
		if table.find(Blacklist, folder.Name) == nil then
			return folder
		end
	end

	return nil
end

local getAssociatedCupToDiamond = function(arena, diamond)
	local Path, Target, Distance = getCupsPath(arena), nil, math.huge
	
	if Path ~= nil then
		for index, model in pairs(Path:GetChildren()) do
			local Magnitude = (diamond.Position - model.Primary.Position).Magnitude
			
			if Magnitude < Distance then
				Target = model
				Distance = Magnitude
			end
		end
	end
	
	return Target
end

local getCupNumbersWithDiamonds = function(arena)	
	if arena.ArenaTemplate:FindFirstChild("Important") and arena.ArenaTemplate.Important:FindFirstChild("Diamonds") then
		local Diamonds = {}

		for index, diamond in pairs(arena.ArenaTemplate.Important.Diamonds:GetChildren()) do
			if diamond.Transparency == 0 then
				table.insert(Diamonds, getAssociatedCupToDiamond(arena, diamond).Name)
			end
		end

		return Diamonds
	end
end

local updateInstanceProperties = function(instance, properties)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	
	return instance
end

local Correct, Status, Highlights = {}, false, {}

for i=1, 2 do
	Highlights[i] = updateInstanceProperties(Instance.new("Highlight"), {
		Parent = Services['CoreGui'],
		Enabled = true,
		FillTransparency = 1,
		OutlineTransparency = 0,
		OutlineColor = Color3.fromRGB(0, 0, 0)
	})
end

Connections['Highlight'] = Services['RunService'].RenderStepped:Connect(function()
	local Arena = findPlayerArena(Services['Players'].LocalPlayer)

	if Status == false and #Correct ~= 0 then
		Correct = {}
	end

	Status = Arena ~= nil

	if Arena ~= nil and Arena.ArenaTemplate:FindFirstChild("Important") and Arena.ArenaTemplate.Important:FindFirstChild("Diamonds") then
		if #Correct == 0 or #Correct == 1 then
			Correct = getCupNumbersWithDiamonds(Arena)
		end

		if #Correct == 2 then
			for index, highlight in pairs(Highlights) do 
				highlight.Enabled = true
				highlight.Adornee = getCupsPath(Arena)[Correct[index]].Primary
			end
		end
	else
		for i, highlight in pairs(Highlights) do 
			highlight.Enabled = false
		end
	end
end)
