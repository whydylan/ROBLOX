--[[
                 _._     _,-'""`-._
        (,-.`._,'(       |\`-/|
            `-.-' \ )-`( , o o)
                  `-    \`_`"'-

        home made with love by dylan <3

--]]

local Services = {
    ['UserInputService'] = game:GetService("UserInputService"), ['Players'] = game:GetService("Players"), ['ReplicatedStorage'] = game:GetService("ReplicatedStorage")
}

local Information = {
    Mouse = Services['Players'].LocalPlayer:GetMouse()
}

local Settings = {
    Duration = 2,
    Bind = Enum.KeyCode.J
}

Services['UserInputService'].InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Settings['Bind'] then
        local Target, Parent = Information['Mouse'].Target, Information['Mouse'].Target.Parent
        
        Target.Parent = Services['ReplicatedStorage']
        task.wait(Settings.Duration)
        Target.Parent = Parent
    end
end)
