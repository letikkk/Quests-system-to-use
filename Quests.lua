local Players = game:GetService("Players")

local Rewards = {
	
	Pickable = 100;
	Stand = 200;
	Die = 350; --idk why but you can add anything that you want
}


local Quest = {}

local reactionType = {
	Pickable = function(item, actionText)
		for _, v in pairs(item:GetChildren()) do
			if not v:FindFirstChildOfClass("ProximityPrompt") then
				local prompt = Instance.new("ProximityPrompt")
				prompt.MaxActivationDistance = 10
				prompt.RequiresLineOfSight = false
				prompt.Parent = v
				prompt.ActionText = actionText
				prompt.Triggered:Connect(function()
					v:Destroy()
					if #item:GetChildren() == 0  then
						Quest.Finish("Pickable")
					end
				end)
			end
		end
	end,
	Stand = function(item)
		local finished = false
		item.Touched:Connect(function(hit)
			if Players:GetPlayerFromCharacter(hit.Parent) and not finished then
				item:Destroy()
				finished = true
				Quest.Finish("Stand")
			end
		end)
	end,
	Die = function(item, Char)
		Char.Humanoid.Died:Connect(function()
			Quest.Finish("Die")
		end)
	end,

}

Quest.__index = Quest

function Quest.new(questType: string, item: Instance?, additionalInfo: {any})
local self = setmetatable({}, Quest)
	
	self.item = item
	self.Type = questType
	
	reactionType[questType](item, additionalInfo)
end

function Quest.Finish(questType: string)
	print(Rewards[questType])
end


return Quest
