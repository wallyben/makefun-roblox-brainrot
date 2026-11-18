-- Server-authoritative collection loop prototype; requires Roblox Studio playtest.
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local collectibles = Instance.new("Folder")
collectibles.Name = "Collectibles"
collectibles.Parent = Workspace
local function spawnItem(index)
  local part = Instance.new("Part")
  part.Name = "Brainrot_" .. index
  part.Size = Vector3.new(2,2,2)
  part.Position = Vector3.new((index%5)*10,4,math.floor(index/5)*10)
  part.Anchored = true
  part.BrickColor = BrickColor.Random()
  part.Parent = collectibles
  local prompt = Instance.new("ProximityPrompt")
  prompt.ActionText = "Collect"
  prompt.Parent = part
  local claimed = false
  prompt.Triggered:Connect(function(player)
    if claimed then return end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or (root.Position-part.Position).Magnitude>14 then return end
    local stats=player:FindFirstChild("leaderstats")
    local score=stats and stats:FindFirstChild("Brainrot")
    if not score then return end
    claimed=true
    score.Value+=1
    part:Destroy()
  end)
end
Players.PlayerAdded:Connect(function(player)
 local stats=Instance.new("Folder")
 stats.Name="leaderstats";stats.Parent=player
 local score=Instance.new("IntValue")
 score.Name="Brainrot";score.Parent=stats
end)
for i=1,20 do spawnItem(i) end
