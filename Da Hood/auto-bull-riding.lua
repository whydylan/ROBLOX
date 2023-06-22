--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Connections, Held = {}, {['Up'] = false, ['Down'] = false, ['Left'] = false, ['Right'] = false}

local Services = {
    Players = game:GetService("Players")
}

local Information = {
    Mounted = false,
    Mapping = {
        ['Up'] = 0x57, ['Down'] = 0x53, ['Left'] = 0x41, ['Right'] = 0x44
    }
}

local Settings = {
    Enabled = true
}

local GUI = Services['Players'].LocalPlayer.PlayerGui:WaitForChild('MainScreenGui').BullControls

while task.wait() do
    Information.Mounted = (Settings.Enabled and GUI.Visible)
    
    if Information.Mounted then
        for index, item in pairs(GUI:GetChildren()) do
            task.spawn(function()
                if item.ImageColor3 == Color3.fromRGB(255, 0, 0) and Held[item.Name] == false then
                    rconsoleprint('Pressing: ' .. item.Name .. "\n")
                    
                    Held[item.Name] = true
                    keypress(Information.Mapping[item.Name])

                    repeat task.wait() until item.ImageColor3 ~= Color3.fromRGB(255, 0, 0)

                    keyrelease(Information.Mapping[item.Name])
                    Held[item.Name] = false
                end
            end)
        end
    end
end
