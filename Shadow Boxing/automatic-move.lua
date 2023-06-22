--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Connections = {}

local Services = {
    ['ReplicatedStorage'] = game:GetService("ReplicatedStorage"),
    ['Players'] = game:GetService("Players")
}

local Settings = {
    Enabled = true
}

local GUI = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("BattleGui")

local findCurrentGame = function(player)
    for index, match in pairs(Services['ReplicatedStorage'].MatchData:GetChildren()) do
        if (match:FindFirstChild('Team1') and match['Team1']:FindFirstChild(player.Name)) or (match:FindFirstChild('Team2') and match['Team2']:FindFirstChild(player.Name)) then
            return match
        end
    end
    
    return nil
end

Connections['Playing'] = game:GetService("RunService").RenderStepped:Connect(function()
    local Match = findCurrentGame(Services['Players'].LocalPlayer)
    
    if Match ~= nil and GUI ~= nil and GUI.Menu.Moves.Visible and Settings.Enabled then
        local Possible = {}
        
        for index, item in pairs(GUI.Menu.Moves:GetChildren()) do
            if item:IsA("ImageButton") and item.ImageColor3 == Color3.fromRGB(197, 197, 197) then
                table.insert(Possible, item)
            end
        end
        
        Match['MoveSelected']:FireServer(Possible[math.random(1, #Possible)].Name)
        rconsoleprint(Possible[math.random(1, #Possible)].Name .. "\n")
        
        GUI.Menu.Moves.Visible = false
    end
end)
