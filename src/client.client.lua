-- Client-side instructions; game logic and rewards remain server-authoritative.
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local gui=Instance.new("ScreenGui")
gui.Name="BrainrotHUD";gui.ResetOnSpawn=false;gui.Parent=player:WaitForChild("PlayerGui")
local label=Instance.new("TextLabel")
label.Size=UDim2.fromOffset(320,54);label.Position=UDim2.fromOffset(16,16)
label.BackgroundTransparency=0.25;label.TextScaled=true
label.Text="Collect the Brainrot!";label.Parent=gui
