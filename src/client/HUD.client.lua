local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local gui=Instance.new("ScreenGui");gui.Name="MayhemHUD";gui.ResetOnSpawn=false
gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
local function label(y,h,size)
 local t=Instance.new("TextLabel");t.Size=UDim2.fromOffset(440,h);t.Position=UDim2.fromOffset(18,y)
 t.BackgroundColor3=Color3.fromRGB(15,27,48);t.BackgroundTransparency=.1
 t.TextColor3=Color3.new(1,1,1);t.Font=Enum.Font.GothamBold;t.TextSize=size
 t.TextXAlignment=Enum.TextXAlignment.Left;t.Parent=gui;return t
end
local title=label(16,48,26);title.Text="  MEME METEOR MAYHEM"
local coins=label(70,42,21);local income=label(116,40,19)
local slots=label(160,40,19);local msg=label(206,45,18)
local storm=label(258,50,24);storm.Visible=false
ReplicatedStorage:WaitForChild("MayhemUpdate").OnClientEvent:Connect(function(s)
 coins.Text="  COINS $"..s.coins.."  |  REBIRTH "..s.rebirth
 income.Text="  INCOME +"..s.income.."/sec"
 slots.Text="  COLLECTION "..s.slots.."/"..s.max
 if s.message then msg.Text="  "..s.message end
 storm.Visible=s.storm;storm.Text="  METEOR STORM — RUN HOME!"
end)