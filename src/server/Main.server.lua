local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local C=require(ReplicatedStorage.Shared.Config)
local states={}
local world=Instance.new("Folder");world.Name="MemeMeteorMayhem";world.Parent=workspace
local function make(name,pos,size,color)
 local p=Instance.new("Part");p.Name=name;p.Anchored=true;p.Position=pos;p.Size=size;p.Color=color;p.Parent=world
 return p
end
make("Island",Vector3.new(0,-1,0),Vector3.new(240,2,240),Color3.fromRGB(29,46,68))
make("Neon Plaza",Vector3.new(0,.1,0),Vector3.new(80,1,80),Color3.fromRGB(51,76,105))
local event=Instance.new("RemoteEvent");event.Name="MayhemUpdate";event.Parent=ReplicatedStorage
local bases={}
for i=1,8 do
 local a=(i-1)*math.pi/4
 local pos=Vector3.new(math.cos(a)*85,1,math.sin(a)*85)
 local floor=make("Base "..i,pos,Vector3.new(30,1,26),Color3.fromRGB(38,130,148))
 bases[i]={pos=pos,owner=nil}
end
local function sync(player,msg)
 local s=states[player];if not s then return end
 event:FireClient(player,{coins=s.coins,income=s.income,slots=#s.items,max=C.MaxSlots,rebirth=s.rebirth,storm=s.storm,message=msg})
end
for id,creature in ipairs(C.Creatures) do
 local p=make(creature.name,Vector3.new((id-3.5)*12,3,0),Vector3.new(6,6,6),creature.color)
 p.Shape=Enum.PartType.Ball;p.Material=Enum.Material.Neon
 local prompt=Instance.new("ProximityPrompt");prompt.ActionText="Buy $"..creature.cost;prompt.ObjectText=creature.name;prompt.Parent=p
 prompt.Triggered:Connect(function(player)
  local s=states[player]
  if not s then return end
  if #s.items>=C.MaxSlots then sync(player,"Base full! Rebirth to reset.");return end
  if s.coins<creature.cost then sync(player,"Not enough coins");return end
  s.coins-=creature.cost;table.insert(s.items,id)
  s.income+=math.floor(creature.income*(1+s.rebirth*.5))
  local n=#s.items;local pos=bases[s.base].pos+Vector3.new(((n-1)%4)*6-9,4,math.floor((n-1)/4)*7-3)
  local display=make(creature.name.." Collection",pos,Vector3.new(4,4,4),creature.color)
  display.Shape=Enum.PartType.Ball;display.Material=Enum.Material.Neon;display.Parent=s.folder
  sync(player,"Collected "..creature.name.."!")
 end)
end
local altar=make("Rebirth Altar",Vector3.new(0,2,29),Vector3.new(12,4,12),Color3.fromRGB(255,203,70))
local rp=Instance.new("ProximityPrompt");rp.ActionText="Rebirth";rp.ObjectText="Reset for +50% income";rp.Parent=altar
rp.Triggered:Connect(function(player)
 local s=states[player];if not s then return end
 local cost=math.floor(10000*1.7^s.rebirth)
 if s.coins<cost then sync(player,"Rebirth costs $"..cost);return end
 s.coins=C.StartingCoins;s.income=0;s.items={};s.rebirth+=1;s.folder:ClearAllChildren()
 sync(player,"REBIRTH! +50% future income")
end)
local function joined(player)
 local slot
 for i,b in ipairs(bases) do if not b.owner then slot=i;b.owner=player;break end end
 if not slot then player:Kick("Server full");return end
 local folder=Instance.new("Folder");folder.Name="Collection_"..player.UserId;folder.Parent=world
 local s={coins=C.StartingCoins,income=0,items={},rebirth=0,base=slot,folder=folder,storm=false}
 states[player]=s
 local stats=Instance.new("Folder");stats.Name="leaderstats";stats.Parent=player
 local score=Instance.new("IntValue");score.Name="Coins";score.Parent=stats
 player.CharacterAdded:Connect(function(character)
  local root=character:WaitForChild("HumanoidRootPart",10)
  if root then root.CFrame=CFrame.new(bases[slot].pos+Vector3.new(0,5,0)) end
 end)
 task.spawn(function()
  while player.Parent and states[player]==s do
   task.wait(1);s.coins+=s.income;score.Value=s.coins;sync(player)
  end
 end)
 sync(player,"Collect creatures, earn coins, survive the storm!")
end
Players.PlayerAdded:Connect(joined)
Players.PlayerRemoving:Connect(function(player)
 local s=states[player];if not s then return end
 bases[s.base].owner=nil;s.folder:Destroy();states[player]=nil
end)
for _,player in ipairs(Players:GetPlayers()) do task.spawn(joined,player) end
task.spawn(function()
 while true do
  task.wait(C.StormInterval)
  for player,s in pairs(states) do s.storm=true;sync(player,"METEOR STORM! Get home!") end
  local started=os.clock()
  while os.clock()-started<C.StormDuration do
   local x=math.random(-95,95);local z=math.random(-95,95)
   local meteor=make("Meteor",Vector3.new(x,70,z),Vector3.new(7,7,7),Color3.fromRGB(255,105,32))
   meteor.Shape=Enum.PartType.Ball;meteor.Material=Enum.Material.Neon
   task.spawn(function()
    for j=1,25 do
     meteor.Position=Vector3.new(x,70-j*2.8,z);task.wait(.04)
    end
    for player,s in pairs(states) do
     local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
     if root and (root.Position-meteor.Position).Magnitude<15 and (root.Position-bases[s.base].pos).Magnitude>20 then
      local loss=math.floor(s.coins*.1);s.coins-=loss;sync(player,"Meteor hit! Lost $"..loss)
     end
    end
    meteor:Destroy()
   end)
   task.wait(.6)
  end
  for player,s in pairs(states) do s.storm=false;sync(player,"Storm over!") end
 end
end)