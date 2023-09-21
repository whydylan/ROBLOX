local Services = {
	HttpService = game:GetService("HttpService"),
	RunService = game:GetService("RunService")
}

local Socket = {
	Send = function(message)
		writefile("file_socket/" .. Services['HttpService']:GenerateGUID(false) .. ".client_message", message)
	end,
	OnMessage = {
		Connections = {},
		Connect = function(self, connection)
			table.insert(self.Connections, connection)
		end,
		Fire = function(self, ...)
			for index, connection in pairs(self.Connections) do
				connection(...)
			end
		end,
	}
}

Services['RunService'].RenderStepped:Connect(function()
	for index, inbound in pairs(listfiles("file_socket/")) do
		local Name = string.split(inbound, [[\]])[2]
		
		if string.find(Name, ".server_message") then
			Socket.OnMessage:Fire(readfile(inbound))
			
			delfile(inbound)
		end
	end
end)

return Socket
