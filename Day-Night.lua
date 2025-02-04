local tweenservice, lighting, runservice = game:GetService'TweenService', game:GetService'Lighting', game:GetService'RunService'
getgenv().Config = { Period = "Night", Smoothness = 5 }

local function Transition()
    tweenservice:Create(lighting, TweenInfo.new(getgenv().Config.Smoothness, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    ClockTime = getgenv().Config.Period == "Night" and 0 or 14
    }):Play()
end

runservice.Stepped:Connect(Transition)
