--[[
	// Name: OBFramework
	// By: pos0
	// GitHub: https://github.com/p0s0/ob-framework
	// Created: 9/7/21
	// Updated: 9/7/21
	// Version: 1.0
--]]

local framework = {}

-- maybe remove eml and timePeriod variables?
local timePeriods = script:WaitForChild("Periods")
local eml = script:WaitForChild("EML")
local timePeriod = script:WaitForChild("TimePeriod")

local gameObjects = { -- will be updated as time goes on
	game.Workspace,
	game.Players,
	game.Lighting,
	game.ReplicatedFirst,
	game.ReplicatedStorage,
	game.ServerScriptService,
	game.ServerStorage,
	game.StarterGui,
	game.StarterPack,
	game.StarterPlayer,
	game.StarterPlayer.StarterPlayerScripts,
	game.StarterPlayer.StarterCharacterScripts,
	game.SoundService,
	game.Chat,
	game.LocalizationService,
	game.TestService
}

function getGameChildren() -- thanks for the security check roblox
	return gameObjects
end

function unpackFolder(folder, newParent)
	for v,i in pairs(folder:GetChildren()) do
		i.Parent = newParent
		
		if i:IsA("Script") or i:IsA("LocalScript") then
			if i.Disabled and not i:FindFirstChild("OBDoNotEnable") then
				i.Disabled = false
			end
		end
	end
	
	folder:Destroy()
	
	return newParent
end

function packFolder(objects, parent, name)
	local folder = Instance.new("Folder")
	for v,i in pairs(objects) do
		i.Parent = folder
	end
	folder.Name = tostring(name) -- just-in-case
	folder.Parent = parent
	
	return folder
end

function framework:Load(period) -- period String
	if not period then warn("OBFramework: framework::Load(period) called, but period is nil. Defaulting to 2015E") period = "2015E" end -- come on roblox, if i could bump this i would https://devforum.roblox.com/t/function-default-argument-declaration/531450
	if timePeriods:FindFirstChild(period) then
		for v,i in pairs(timePeriods[period]:GetChildren()) do
			if game:FindFirstChild(i.Name) then
				unpackFolder(i, game[i.Name])
			else
				for b,o in pairs(getGameChildren()) do
					if o.Name == i.Name then
						unpackFolder(i, o)
					end
				end
			end
		end
	else
		warn("OBFramework: framework::Load(period) called, but period is not found. Make sure the time period is inside of OBFramework.Periods. The naming format is '(year)(EML)'. For example: 2014L")
		return false
	end
	
	return true
end

return framework
