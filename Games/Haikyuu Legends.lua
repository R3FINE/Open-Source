--{ Infinite Money | Uploaded: 11:56 PM }--

getgenv().Settings = {E = true, R = 10}

game:GetService'RunService'.RenderStepped:Connect(function()
    if getgenv().Settings.E then
        for i = 1, getgenv().Settings.R do
            game:GetService'ReplicatedStorage'.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.RewardService.RF.RequestPlayWithDeveloperAward:InvokeServer()
        end
    end
end)
