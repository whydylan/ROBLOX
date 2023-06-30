--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Services = {
	Players = game:GetService("Players"),
	HttpService = game:GetService("HttpService"),
	RunService = game:GetService("RunService")
}

local Cache = {
	Items = {}
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

local getItemAverage = function(item_name)
	if Cache['Items'] ~= {} then
		for index, item in pairs(Cache['Items']) do
			if item['Name'] == item_name then
				return item['Average']
			end
		end
	end

	return nil
end

local getCachedItems = function()
	local Cache, Items = {}, nil
	
	if isfile("cached_items.json") == false then
		Cache, Items = {}, Services['HttpService']:JSONDecode(game:HttpGet("https://www.rolimons.com/itemapi/itemdetails"))

		if Items['success'] == true then
			for index, item in Items['items'] do			
				table.insert(Cache, {Name = item[1], Average = item[3]})
			end
		end
	else
		Cache = Services['HttpService']:JSONDecode(readfile("cached_items.json"))
	end
	
	return Cache
end

local findPlayerArena = function(player)
	for index, model in pairs(workspace.ArenasREAL:GetChildren()) do
		if model:FindFirstChild("ArenaTemplate") then
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

local convertStringToNumber = function(_string)
	local number_only = ""

	for i = 1, #_string do
		if tonumber(string.sub(_string,i,i)) ~= nil then
			number_only = number_only .. string.sub(_string,i,i)
		end
	end

	return tonumber(number_only)
end

local getItemGuessPrice = function(arena)
	return convertStringToNumber(arena.ArenaTemplate.Important.GuessPrice.SurfaceGui.TextLabel.Text)
end

-- Adding all item(s) to the cache so we don't have to send continous API requests every time we want to get an Item Price

Cache['Items'] = getCachedItems()

-- Writing a file with the cached item(s), due to Rolimons rate limiting very often; a solution could be to use the direct ROBLOX api, but this works for now.

if isfile("cached_items.json") == false then
	writefile("cached_items.json", Services['HttpService']:JSONEncode(Cache['Items']))
end

Connections['RenderStepped'] = Services['RunService'].RenderStepped:Connect(function()
	if Services['Players'].LocalPlayer.PlayerGui.PriceIsRight:FindFirstChild("Bottom Middle") and Services['Players'].LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Buttons.Higher.BackgroundTransparency == 0 and Services['Players'].LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Visible == true then
		if Services['Players'].LocalPlayer.PlayerGui.PriceIsRight:FindFirstChild("Bottom Middle") and Services['Players'].LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Buttons.Higher.BackgroundTransparency == 0 and Services['Players'].LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Visible == true and findPlayerArena(Services['Players'].LocalPlayer) ~= nil then
			local Arena = findPlayerArena(Services['Players'].LocalPlayer)

			if Arena ~= nil then
				local Result = getItemGuessPrice(Arena) > getItemAverage(Arena.ArenaTemplate.Important.ItemName.SurfaceGui.TextLabel.Text) and "Lower" or "Higher"

				clickTextButton(Services['Players'].LocalPlayer.PlayerGui.PriceIsRight["Bottom Middle"].Buttons[Result])
			end
		end
	end
end)
