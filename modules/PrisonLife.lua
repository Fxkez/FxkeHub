local ctx = getgenv().FxkeCtx
local Window = ctx.Window
local NebulaIcons = ctx.NebulaIcons
local notify = ctx.notify
local Starlight = ctx.Starlight
-- header ^
local PrisonLife = Window:CreateTabSection("Prison Life")
local Main = PrisonLife:CreateTab({
	Name = "Main",
	Icon = NebulaIcons:GetIcon('stars', 'Material'),
	Columns = 2,
}, "INDEX")
local jumpCooldownConnections = {}
local HumanoidBox = Main:CreateGroupbox({
	Name = "Humanoid",
	Column = 1
}, "INDEX")
HumanoidBox:CreateToggle({
	Name = "Disable Jump Cooldown",
	CurrentValue = false,
	Style = 2,
	Callback = function(v)
		if v then
			local connections = getconnections(game.Players.LocalPlayer.Character.Humanoid:GetPropertyChangedSignal("Jump"))
			for _, connection in ipairs(connections) do
				connection:Disable()
				table.insert(jumpCooldownConnections, connection)
			end
		else
			for _, connection in ipairs(jumpCooldownConnections) do
				connection:Enable()
			end
			table.clear(jumpCooldownConnections)
		end
	end,
}, "INDEX")
local fasterSprintLoop
HumanoidBox:CreateToggle({
	Name = "Faster Sprint",
	CurrentValue = false,
	Style = 2,
	Callback = function(v)
		if v then
			fasterSprintLoop = task.spawn(function()
				while v do
					if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
						game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 35
					end
					task.wait()
				end
			end)
		else
			if fasterSprintLoop then
				task.cancel(fasterSprintLoop)
				fasterSprintLoop = nil
			end
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
		end
	end,
}, "INDEX")
HumanoidBox:CreateSlider({
	Name = "WalkSpeed",
	Icon = NebulaIcons:GetIcon('chart-no-axes-column-increasing', 'Lucide'),
	Range = {
		16,
		50
	},
	Increment = 1,
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end,
}, "INDEX")
local PrisonBox = Main:CreateGroupbox({
	Name = "Prison",
	Column = 1
}, "INDEX")
PrisonBox:CreateButton({
	Name = "Break all Toilets (local)",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "Toilet" then
				obj:Destroy()
			end
		end
	end,
}, "INDEX")
function prisonlife_changeteam(team)
	local args = {
		game:GetService("Teams"):WaitForChild("Neutral"),
		1
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestTeamChange"):InvokeServer(unpack(args))
	wait(0.5)
	local args2 = {
		game:GetService("Teams"):WaitForChild(team),
		1
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestTeamChange"):InvokeServer(unpack(args2))
end
local TP_Debounce = false
function prisonlife_teleport(cframe, skipDebounce)
	print(skipDebounce)
	if TP_Debounce == true and skipDebounce == false or nil then
		wait(3.5)
		TP_Debounce = false
	end
	TP_Debounce = true
	local character = game.Players.LocalPlayer.Character
	local humanoid = character.Humanoid
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	humanoid.Jump = true
	local hrp = character.HumanoidRootPart
	local args = {
		game:GetService("Teams"):WaitForChild(game.Players.LocalPlayer.Team.Name),
		1
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RequestTeamChange"):InvokeServer(unpack(args))
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	humanoid.Jump = true
	hrp.CFrame = cframe
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	humanoid.Jump = true
end
local toolTable = {}
for _, obj in ipairs(workspace:GetDescendants()) do
	local toolName = obj:GetAttribute("ToolName")
	if toolName and obj:FindFirstChild("TouchGiver") then
		toolTable[toolName] = obj:FindFirstChild("TouchGiver")
	end
end
function prisonlife_givegun(gunName)
	local gunModel = toolTable[gunName]
	prisonlife_teleport(CFrame.new(gunModel.Position))
	firetouchinterest(game.Players.LocalPlayer.Character:FindFirstChild("Left Leg"), gunModel, true)
	wait(0.1)
	firetouchinterest(game.Players.LocalPlayer.Character:FindFirstChild("Left Leg"), gunModel, false)
end
local TeamsBox = Main:CreateGroupbox({
	Name = "Teams",
	Column = 1
}, "INDEX")
TeamsBox:CreateButton({
	Name = "Guards",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_changeteam("Guards")
	end,
}, "INDEX")
TeamsBox:CreateButton({
	Name = "Inmates",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_changeteam("Inmates")
	end,
}, "INDEX")
TeamsBox:CreateButton({
	Name = "Criminals",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		local targetCFrame = CFrame.new(750.580505, 91.3567657, 2020.70642, 0.920396268, - 1.53651059e-09, - 0.39098686, - 1.81331572e-08, 1, - 4.66158916e-08, 0.39098686, 4.99949167e-08, 0.920396268)
		prisonlife_teleport(targetCFrame)
		wait(1)
		prisonlife_teleport(startCFrame, true)
	end,
}, "INDEX")
local GunsBox = Main:CreateGroupbox({
	Name = "Weapons",
	Column = 1
}, "INDEX")
GunsBox:CreateButton({
	Name = "MP5",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("MP5")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "Remington 870",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("Remington 870")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "AK-47",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("AK-47")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "Revolver (Gamepass)",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("Revolver")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "M700 (Gamepass)",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("M700")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "M4A1 (Gamepass)",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("M4A1")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
GunsBox:CreateButton({
	Name = "FAL (Gamepass)",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		local character = game.Players.LocalPlayer.Character
		local hrp = character.HumanoidRootPart
		local startCFrame = hrp.CFrame
		prisonlife_givegun("FAL")
		wait(0.5)
		prisonlife_teleport(startCFrame)
	end,
}, "INDEX")
local TeleportsBox = Main:CreateGroupbox({
	Name = "Teleports",
	Column = 2
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Guard Room",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(830.558228, 99.9899979, 2298.45972, - 0.964762151, 1.44117287e-08, - 0.263123453, 3.58369761e-08, 1, - 7.66272592e-08, 0.263123453, - 8.33566318e-08, - 0.964762151))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Guard Room Guns",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(829.864807, 99.9766693, 2238.63574, 0.999932289, - 2.70365899e-08, 0.0116352532, 2.58688235e-08, 1, 1.00515059e-07, - 0.0116352532, - 1.00207266e-07, 0.999932289))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Yard",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(819.583435, 98.1899338, 2395.90039, - 0.999553025, - 3.35173134e-08, 0.0298956018, - 3.06672163e-08, 1, 9.57934674e-08, - 0.0298956018, 9.48338368e-08, - 0.999553025))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Cafeteria",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(920.080322, 102.839958, 2295.49902, 0.999212921, 9.56542792e-08, - 0.0396675989, - 9.40006188e-08, 1, 4.35531184e-08, 0.0396675989, - 3.97900628e-08, 0.999212921))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Prison Roof",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(824.404053, 118.989998, 2332.54761, - 0.999987841, 7.11093122e-08, 0.00493240496, 7.12991408e-08, 1, 3.83108016e-08, - 0.00493240496, 3.86620123e-08, - 0.999987841))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Cellblock",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(916.922913, 99.9899826, 2431.41016, - 0.999902546, 2.81320123e-08, 0.0139620844, 2.7529321e-08, 1, - 4.33584759e-08, - 0.0139620844, - 4.29698801e-08, - 0.999902546))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Hammer",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(806.688843, 98.1899338, 2524.82837, - 0.94445771, 4.40150671e-08, 0.328632981, 4.61888057e-08, 1, - 1.19188992e-09, - 0.328632981, 1.40534748e-08, - 0.94445771))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Crude Knife",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(704.346924, 97.999939, 2436.48755, - 0.876711607, 5.54071349e-08, 0.481016368, 6.60840769e-08, 1, 5.25875388e-09, - 0.481016368, 3.63979353e-08, - 0.876711607))
	end,
}, "INDEX")
TeleportsBox:CreateButton({
	Name = "Criminal Base",
	Icon = NebulaIcons:GetIcon('check', 'Material'),
	Callback = function()
		prisonlife_teleport(CFrame.new(- 974.25592, 108.323685, 2055.19824, - 0.952894628, 7.31238359e-08, - 0.303301573, 4.02546334e-08, 1, 1.14623248e-07, 0.303301573, 9.70145777e-08, - 0.952894628))
	end,
}, "INDEX")

-- Silent Aim
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local Teams = game:GetService("Teams")
local guardsTeam = Teams:FindFirstChild("Guards")
local inmatesTeam = Teams:FindFirstChild("Inmates")
local criminalsTeam = Teams:FindFirstChild("Criminals")
local cfg = {
	enabled = false, -- toggle the whole script on/off
	teamcheck = true, -- dont shoot people on your team
	wallcheck = true, -- dont shoot through walls
	deathcheck = true, -- skip dead players
	ffcheck = true, -- skip players with forcefield
	hostilecheck = true, -- only shoot hostile inmates 💢 (guards only)
	trespasscheck = true, -- only shoot trespassing inmates 🔗 (guards only)
	vehiclecheck = true, -- dont shoot people sitting in cars
	criminalsnoinnmates = true, -- criminals wont shoot inmates
	inmatesnocriminals = true, -- inmates wont shoot criminals
	shieldbreaker = true, -- target shields to break them instead of being blocked
	shieldfrontangle = 0.3, -- (DONT CHANGE) how wide the shield covers (-1 to 1, lower = wider, 0.3 = ~70 degrees)
	shieldrandomhead = true, -- randomly hit head instead of shield sometimes (more legit)
	shieldheadchance = 30, -- percent chance to hit head instead of shield (0-100)
	taserbypasshostile = false, -- taser ignores hostile check
	taserbypasstrespass = false, -- taser ignores trespass check
	taseralwayshit = true, -- taser never misses
	ifplayerstill = true, -- always hit if player isnt moving
	stillthreshold = 0.5, -- how slow they gotta be to count as still
	hitchance = 100, -- percent chance to actually hit (0-100)
	hitchanceAutoOnly = true, -- only apply hitchance to automatic weapons (shotguns always hit)
	distancebasedhitchance = false, -- use distance breakpoints to change hitchance
	distancehitchance1dist = 200, -- at/after this distance, use hitchance 1
	distancehitchance1value = 30,
	distancehitchance2dist = 350, -- at/after this distance, use hitchance 2
	distancehitchance2value = 20,
	distancehitchance3dist = 500, -- at/after this distance, use hitchance 3
	distancehitchance3value = 10,
	distancehitchance4dist = 650, -- at/after this distance, use hitchance 4
	distancehitchance4value = 5,
	distancehitchance5dist = 800, -- at/after this distance, use hitchance 5
	distancehitchance5value = 1,
	autoshoot = true, -- automatically shoot when target is found
	autoshootweapon = "Any", -- valid values: "Any", "Taser", "M9", "AK-47", "M4A1", "Remington 870", "Revolver", "Shotgun", "Sniper", "Automatic"
	autoshootdelay = 0.12, -- delay between auto shots
	autoshootstartdelay = 0.2, -- delay before first shot when target acquired (reaction time)
	aimmaxdist = 100, -- max studs a target can be from you (set to 0 for any distance)
	missspread = 5, -- how far off to shoot when missing (makes it look legit)
	shotgunnaturalspread = true, -- let shotgun bullets spread naturally instead of all hitting
	shotgungamehandled = false, -- aim at player but let game handle hitchance/spread
	prioritizeclosest = true, -- shoot whoever is closest to your cursor (false = random from fov)
	prioritizecriminals = true, -- if an inmate and criminal are both in fov, prefer the criminal
	targetstickiness = false, -- enable/disable target stickiness
	targetstickinessduration = 0.6, -- how long to keep target (seconds)
	targetstickinessrandom = false, -- use random range instead of fixed value
	targetstickinessmin = 0.3, -- min time if random is on
	targetstickinessmax = 0.7, -- max time if random is on
	fov = 150, -- how big the aim circle is
	showfov = true, -- show the fov circle on screen
	staticfov = false, -- keep the fov centered instead of following touch/mouse
	showtargetline = false, -- draw a line to your target
	togglekey = Enum.KeyCode.RightShift, -- key to toggle silent aim
	aimpart = "Head", -- what body part to aim at
	randomparts = true, -- randomly pick body parts instead
	partslist = {
		"Head",
		"Torso",
		"Left Arm",
		"Right Arm",
		"Left Leg",
		"Right Leg",
		"HumanoidRootPart"
	}, -- parts to pick from if random is on (can add more if wanted)
	autograb = true, -- auto grab keycards / m9 when they sit near you
	autograbdistance = 12, -- max pickup distance (12 studs max)
	autograbdelay = 1, -- how long the item must stay nearby before grabbing
	autograbkeycard = true,
	autograbm9 = true,
}
local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Exclude
wallParams.IgnoreWater = true
wallParams.RespectCanCollide = false
wallParams.CollisionGroup = "ClientBullet"
local projectileParams = RaycastParams.new()
projectileParams.FilterType = Enum.RaycastFilterType.Exclude
projectileParams.IgnoreWater = true
projectileParams.RespectCanCollide = false
projectileParams.CollisionGroup = "ClientBullet"
local currentGun = nil
local rng = Random.new()
local lastShotTime = 0
local lastShotResult = false
local shotCooldown = 1 / 30
local currentTarget = nil
local targetSwitchTime = 0
local currentStickiness = 0
local randomPartCache = {}
local lastTouchAimPos = nil
local storedAimMaxDistanceBeforeDistanceHitchance = tonumber(cfg.aimmaxdist) or 0
local distanceHitchanceForcesAimMaxDistance = false
local activeTouch = nil
local lastAutoShoot = 0
local cachedBulletsLabel = nil
local targetAcquiredTime = 0
local lastAutoTarget = nil
local playerSettings = ReplicatedStorage:FindFirstChild("PlayerSettings")
local mobileCursorOffset = 0
local isInsideDynThumbFrame = nil
local giverPressedRemote = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("GiverPressed")
local trackedGrabbables = {}
local firstSeenGrabbables = {}
local lastAutoGrab = 0
do
	local sharedModules = ReplicatedStorage:FindFirstChild("SharedModules")
	local dynThumbModule = sharedModules and sharedModules:FindFirstChild("isInsideDynThumbFrame")
	if dynThumbModule then
		local ok, result = pcall(require, dynThumbModule)
		if ok and typeof(result) == "function" then
			isInsideDynThumbFrame = result
		end
	end
end
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Radius = cfg.fov
fovCircle.Transparency = 0.8
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Thickness = 1
fovCircle.Visible = cfg.showfov and cfg.enabled
local targetLine = Drawing.new("Line")
targetLine.Color = Color3.fromRGB(0, 255, 0)
targetLine.Thickness = 1
targetLine.Transparency = 0.5
targetLine.Visible = false
local visuals = {
	container = nil
}
local function resetAimState()
	lastShotTime = 0
	lastShotResult = false
	currentTarget = nil
	targetSwitchTime = 0
	currentStickiness = 0
	lastAutoShoot = 0
	lastAutoTarget = nil
	targetAcquiredTime = 0
	cachedBulletsLabel = nil
end
local function getHud()
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local home = playerGui and playerGui:FindFirstChild("Home")
	return home and home:FindFirstChild("hud") or nil
end
local function getMobileGunFrame()
	local hud = getHud()
	return hud and hud:FindFirstChild("MobileGunFrame") or nil
end
local function getMobileCursor()
	local mobileGunFrame = getMobileGunFrame()
	return mobileGunFrame and mobileGunFrame:FindFirstChild("MobileCursor") or nil
end
local function updateMobileCursorOffset()
	if not playerSettings then
		mobileCursorOffset = 0
		return
	end
	local offset = playerSettings:GetAttribute("MobileCursorOffset")
	if typeof(offset) == "number" then
		mobileCursorOffset = offset * 15
	else
		mobileCursorOffset = 0
	end
end
if playerSettings then
	updateMobileCursorOffset()
	playerSettings:GetAttributeChangedSignal("MobileCursorOffset"):Connect(updateMobileCursorOffset)
end
local function isIgnoredTouchPosition(position)
	if isInsideDynThumbFrame and isInsideDynThumbFrame(position.X, position.Y) then
		return true
	end
	local mobileGunFrame = getMobileGunFrame()
	local ignoreTouchArea = mobileGunFrame and mobileGunFrame:FindFirstChild("IgnoreTouchArea")
	if not ignoreTouchArea then
		return false
	end
	local x = position.X
	local y = position.Y
	local left = ignoreTouchArea.AbsolutePosition.X
	local right = left + ignoreTouchArea.AbsoluteSize.X
	local top = ignoreTouchArea.AbsolutePosition.Y
	local bottom = top + ignoreTouchArea.AbsoluteSize.Y
	return left <= x and x <= right and top <= y and y <= bottom
end
local function getAimScreenPosition(camera)
	camera = camera or workspace.CurrentCamera
	if not camera then
		return UserInputService:GetMouseLocation()
	end
	local lastInput = UserInputService:GetLastInputType()
	if UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		local viewportSize = camera.ViewportSize
		return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	end
	if lastInput == Enum.UserInputType.Touch then
		local mobileCursor = getMobileCursor()
		if mobileCursor and mobileCursor.Visible then
			local pos = mobileCursor.AbsolutePosition
			local size = mobileCursor.AbsoluteSize
			return Vector2.new(pos.X + size.X / 2, pos.Y + size.Y / 2)
		end
		local viewportSize = camera.ViewportSize
		return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
	end
	return UserInputService:GetMouseLocation()
end
local function getScreenCenter(camera)
	camera = camera or workspace.CurrentCamera
	if not camera then
		return Vector2.zero
	end
	local viewportSize = camera.ViewportSize
	return Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
end
local function getFovScreenPosition(camera)
	if cfg.staticfov then
		return getScreenCenter(camera)
	end
	return getAimScreenPosition(camera)
end
local function isSniper(gun)
	return gun and gun:GetAttribute("Behavior") == "Sniper"
end
local function isTaserGun(gun)
	return gun and (gun:GetAttribute("Behavior") == "Taser" or gun:GetAttribute("Projectile") == "Taser")
end
local function isShotgun(gun)
	return gun and (gun:GetAttribute("IsShotgun") or gun:GetAttribute("Behavior") == "Shotgun")
end
local function isAutomaticWeapon(gun)
	return gun and gun:GetAttribute("AutoFire") == true
end
local function normalizeWeaponSelector(value)
	return tostring(value or ""):lower():gsub("%s+", "")
end
local function gunMatchesAutoShootWeapon(gun)
	if not gun then
		return false
	end
	local selector = normalizeWeaponSelector(cfg.autoshootweapon)
	if selector == "" or selector == "any" or selector == "all" then
		return true
	end
	local gunName = normalizeWeaponSelector(gun.Name)
	local behavior = normalizeWeaponSelector(gun:GetAttribute("Behavior"))
	local projectile = normalizeWeaponSelector(gun:GetAttribute("Projectile"))
	if selector == "taser" then
		return isTaserGun(gun) or gunName:find("taser", 1, true) ~= nil
	elseif selector == "shotgun" then
		return isShotgun(gun)
	elseif selector == "sniper" then
		return isSniper(gun)
	elseif selector == "auto" or selector == "automatic" then
		return isAutomaticWeapon(gun)
	end
	return selector == gunName or selector == behavior or selector == projectile
end
local function getLocalAimOriginPart()
	local character = LocalPlayer.Character
	if not character then
		return nil
	end
	return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
end
local function isWithinAimDistance(targetPos)
	local maxDistance = tonumber(cfg.aimmaxdist) or 0
	if maxDistance <= 0 or not targetPos then
		return true
	end
	local originPart = getLocalAimOriginPart()
	if not originPart then
		return true
	end
	return (targetPos - originPart.Position).Magnitude <= maxDistance
end
local function syncDistanceHitchanceAimMaxDistance()
	local currentAimMaxDistance = tonumber(cfg.aimmaxdist) or 0
	if cfg.distancebasedhitchance then
		if currentAimMaxDistance > 0 then
			storedAimMaxDistanceBeforeDistanceHitchance = currentAimMaxDistance
		elseif storedAimMaxDistanceBeforeDistanceHitchance <= 0 then
			storedAimMaxDistanceBeforeDistanceHitchance = 100
		end
		cfg.aimmaxdist = 0
		distanceHitchanceForcesAimMaxDistance = true
	elseif distanceHitchanceForcesAimMaxDistance then
		cfg.aimmaxdist = tonumber(storedAimMaxDistanceBeforeDistanceHitchance) or 0
		distanceHitchanceForcesAimMaxDistance = false
	else
		storedAimMaxDistanceBeforeDistanceHitchance = currentAimMaxDistance
	end
end
local function shouldBypassHitchance(gun)
	return gun ~= nil and cfg.hitchanceAutoOnly and not isAutomaticWeapon(gun)
end
local function getLocalHumanoid()
	local character = LocalPlayer.Character
	return character and character:FindFirstChildOfClass("Humanoid") or nil
end
local function isSniperStable(gun)
	if not isSniper(gun) then
		return true
	end
	if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
		return false
	end
	local humanoid = getLocalHumanoid()
	return not humanoid or humanoid:GetState() ~= Enum.HumanoidStateType.Freefall
end
local function getFireOriginPosition()
	local myChar = LocalPlayer.Character
	local myHead = myChar and myChar:FindFirstChild("Head")
	if not myHead then
		return nil
	end
	local muzzle = currentGun and currentGun:FindFirstChild("Muzzle")
	return muzzle and muzzle.Position or myHead.Position
end
local function isInCurrentGunRange(targetPos, originPos)
	if not currentGun or not targetPos then
		return true
	end
	local range = currentGun:GetAttribute("Range")
	if typeof(range) ~= "number" or range <= 0 then
		return true
	end
	originPos = originPos or getFireOriginPosition()
	if not originPos then
		return true
	end
	return (targetPos - originPos).Magnitude <= range + 5
end
local function isSupportedGrabbable(obj)
	if not obj or not obj:IsA("Model") then
		return false
	end
	local name = obj.Name:lower()
	return name:find("keycard", 1, true) ~= nil or name == "m9"
end
local function shouldAutoGrabItem(obj)
	if not cfg.autograb or not obj or not obj:IsA("Model") then
		return false
	end
	local name = obj.Name:lower()
	if name:find("keycard", 1, true) ~= nil then
		return cfg.autograbkeycard
	end
	if name == "m9" then
		return cfg.autograbm9
	end
	return false
end
local function isOwnedGrabbable(obj)
	local ancestor = obj and obj.Parent
	while ancestor and ancestor ~= workspace do
		if ancestor:FindFirstChildOfClass("Humanoid") then
			return true
		end
		if ancestor.Name == "Backpack" then
			return true
		end
		ancestor = ancestor.Parent
	end
	return false
end
local function getGrabbablePart(model)
	if not model then
		return nil
	end
	return model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
end
local function distSq(a, b)
	local delta = a - b
	return delta.X * delta.X + delta.Y * delta.Y + delta.Z * delta.Z
end
local function trackGrabbable(obj)
	if isSupportedGrabbable(obj) then
		trackedGrabbables[obj] = true
	end
end
local function untrackGrabbable(obj)
	trackedGrabbables[obj] = nil
	firstSeenGrabbables[obj] = nil
end
local function updateAutoGrab(now)
	if not cfg.autograb or not giverPressedRemote then
		return
	end
	if now - lastAutoGrab < 0.05 then
		return
	end
	local root = getLocalAimOriginPart()
	if not root then
		return
	end
	local grabDistance = math.clamp(tonumber(cfg.autograbdistance) or 0, 0, 12)
	if grabDistance <= 0 then
		return
	end
	local requiredDelay = math.max(tonumber(cfg.autograbdelay) or 0, 0)
	local grabDistanceSq = grabDistance * grabDistance
	for item in pairs(trackedGrabbables) do
		if not item or not item.Parent then
			untrackGrabbable(item)
		elseif not shouldAutoGrabItem(item) then
			firstSeenGrabbables[item] = nil
		elseif isOwnedGrabbable(item) then
			firstSeenGrabbables[item] = nil
		else
			local part = getGrabbablePart(item)
			if part and distSq(root.Position, part.Position) <= grabDistanceSq then
				if not firstSeenGrabbables[item] then
					firstSeenGrabbables[item] = now
				elseif now - firstSeenGrabbables[item] >= requiredDelay then
					lastAutoGrab = now
					firstSeenGrabbables[item] = nil
					pcall(giverPressedRemote.FireServer, giverPressedRemote, item)
					return
				end
			else
				firstSeenGrabbables[item] = nil
			end
		end
	end
end
local function shouldUseInstantAcquireDelay(gun)
	if not gun then
		return false
	end
	local lastInput = UserInputService:GetLastInputType()
	return lastInput == Enum.UserInputType.Touch or lastInput == Enum.UserInputType.Gamepad1 or isShotgun(gun)
end
local function simulateProjectileImpact(startPos, aimPos, gun)
	if not gun or not startPos or not aimPos then
		return nil, aimPos
	end
	local behavior = gun:GetAttribute("Behavior")
	local spread = gun:GetAttribute("SpreadRadius") or 0
	local range = gun:GetAttribute("Range") or 1500
	local randomScale = rng:NextNumber()
	if behavior == "Sniper" or behavior == "Shotgun" then
		randomScale = math.sqrt(randomScale)
	end
	local baseCFrame = CFrame.new(startPos, aimPos)
	local rollAngle = math.rad(360 - 720 * rng:NextNumber())
	local direction = (baseCFrame * CFrame.Angles(0, 0, rollAngle) * CFrame.Angles(0, randomScale * spread, 0)).LookVector * range
	projectileParams.FilterDescendantsInstances = {
		LocalPlayer.Character
	}
	local result = workspace:Raycast(startPos, direction, projectileParams)
	if result then
		return result.Instance, result.Position
	end
	return nil, startPos + direction
end
local partMap = {
	["Torso"] = {
		"Torso"
	},
	["LeftArm"] = {
		"Left Arm"
	},
	["RightArm"] = {
		"Right Arm"
	},
	["LeftLeg"] = {
		"Left Leg"
	},
	["RightLeg"] = {
		"Right Leg"
	}
}
local function normalizePartName(name)
	return tostring(name or ""):gsub("%s+", "")
end
local function getPart(char, name)
	if not char then
		return nil
	end
	local p = char:FindFirstChild(name)
	if p then
		return p
	end
	local maps = partMap[normalizePartName(name)]
	if maps then
		for _, n in ipairs(maps) do
			local part = char:FindFirstChild(n)
			if part then
				return part
			end
		end
	end
	return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end
local function getTaserTargetPart(char)
	if not char then
		return nil
	end
	return char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end
local function getTargetPart(char)
	if not char then
		return nil
	end
	if isTaserGun(currentGun) then
		return getTaserTargetPart(char)
	end
	if cfg.shieldbreaker then
		local shield = char:FindFirstChild("RiotShieldPart")
		if shield and shield:IsA("BasePart") then
			local hp = shield:GetAttribute("Health")
			if hp and hp > 0 then
				local myChar = LocalPlayer.Character
				local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
				local theirHrp = char:FindFirstChild("HumanoidRootPart")
				if myHrp and theirHrp then
					local toMe = (myHrp.Position - theirHrp.Position).Unit
					local theirLook = theirHrp.CFrame.LookVector
					local dot = toMe:Dot(theirLook)
					if dot > cfg.shieldfrontangle then
						if cfg.shieldrandomhead and rng:NextInteger(1, 100) <= cfg.shieldheadchance then
							return getPart(char, "Head")
						end
						return shield
					end
				end
			end
		end
	end
	local partName
	if cfg.randomparts then
		local cached = randomPartCache[char]
		if cached and cached.part and cached.part.Parent == char and cached.expiresAt > os.clock() then
			return cached.part
		end
		local list = cfg.partslist
		partName = (list and # list > 0) and list[rng:NextInteger(1, # list)] or "Head"
	else
		partName = cfg.aimpart
	end
	local part = getPart(char, partName)
	if cfg.randomparts and part then
		randomPartCache[char] = {
			part = part,
			partName = partName,
			expiresAt = os.clock() + 0.15
		}
	end
	return part
end
local function isDead(player)
	if not player or not player.Character then
		return true
	end
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	return not humanoid or humanoid.Health <= 0
end
local function isStanding(player)
	if not player or not player.Character then
		return false
	end
	local hrp = player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return false
	end
	local vel = hrp.AssemblyLinearVelocity
	return Vector2.new(vel.X, vel.Z).Magnitude <= cfg.stillthreshold
end
local function hasForceField(player)
	if not player or not player.Character then
		return false
	end
	return player.Character:FindFirstChildOfClass("ForceField") ~= nil
end
local function isInVehicle(player)
	if not player or not player.Character then
		return false
	end
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return false
	end
	return humanoid.SeatPart ~= nil
end
local function wallBetween(startPos, endPos, targetChar)
	local myChar = LocalPlayer.Character
	if not myChar then
		return true
	end
	local filter = {
		myChar
	}
	if targetChar then
		table.insert(filter, targetChar)
	end
	wallParams.FilterDescendantsInstances = filter
	local direction = endPos - startPos
	local distance = direction.Magnitude
	if distance <= 0.001 then
		return false
	end
	local unit = direction.Unit
	local currentStart = startPos
	local remaining = distance
	for _ = 1, 10 do
		local result = workspace:Raycast(currentStart, unit * remaining, wallParams)
		if not result then
			return false
		end
		local hit = result.Instance
		if hit.Transparency < 0.8 and hit.CanCollide then
			return true
		end
		local hitDist = (result.Position - currentStart).Magnitude
		remaining = remaining - hitDist - 0.01
		if remaining <= 0 then
			return false
		end
		currentStart = result.Position + unit * 0.01
	end
	return false
end
local function quickCheck(player)
	if not player or player == LocalPlayer or not player.Character then
		return false
	end
	local targetPart = getTargetPart(player.Character)
	if not targetPart then
		return false
	end
	if not isWithinAimDistance(targetPart.Position) then
		return false
	end
	if not isInCurrentGunRange(targetPart.Position) then
		return false
	end
	if cfg.deathcheck and isDead(player) then
		return false
	end
	if cfg.ffcheck and hasForceField(player) then
		return false
	end
	if cfg.vehiclecheck and isInVehicle(player) then
		return false
	end
	if cfg.teamcheck and player.Team == LocalPlayer.Team then
		return false
	end
	if cfg.criminalsnoinnmates then
		if LocalPlayer.Team == criminalsTeam and player.Team == inmatesTeam then
			return false
		end
	end
	if cfg.inmatesnocriminals then
		if LocalPlayer.Team == inmatesTeam and player.Team == criminalsTeam then
			return false
		end
	end
	if cfg.hostilecheck or cfg.trespasscheck then
		local isTaser = isTaserGun(currentGun)
		local bypassHostile = cfg.taserbypasshostile and isTaser
		local bypassTrespass = cfg.taserbypasstrespass and isTaser
		local targetChar = player.Character
		if LocalPlayer.Team == guardsTeam and player.Team == inmatesTeam then
			local hostile = targetChar:GetAttribute("Hostile")
			local trespass = targetChar:GetAttribute("Trespassing")
			if cfg.hostilecheck and cfg.trespasscheck then
				if not bypassHostile and not bypassTrespass then
					if not hostile and not trespass then
						return false
					end
				end
			elseif cfg.hostilecheck and not bypassHostile then
				if not hostile then
					return false
				end
			elseif cfg.trespasscheck and not bypassTrespass then
				if not trespass then
					return false
				end
			end
		end
	end
	return true
end
local function fullCheck(player)
	if not quickCheck(player) then
		return false
	end
	if cfg.wallcheck then
		local myChar = LocalPlayer.Character
		local myHead = myChar and myChar:FindFirstChild("Head")
		local targetPart = getTargetPart(player.Character)
		if myHead and targetPart then
			if wallBetween(myHead.Position, targetPart.Position, player.Character) then
				return false
			end
		end
	end
	return true
end
local function rollHit(chanceOverride)
	lastShotTime = os.clock()
	local chance = math.clamp(tonumber(chanceOverride) or tonumber(cfg.hitchance) or 0, 0, 100)
	if chance >= 100 then
		lastShotResult = true
	elseif chance <= 0 then
		lastShotResult = false
	else
		lastShotResult = rng:NextInteger(1, 100) <= chance
	end
	return lastShotResult
end
local function getDistanceBasedHitChance(targetPart, originPos)
	local baseChance = math.clamp(tonumber(cfg.hitchance) or 0, 0, 100)
	if not cfg.distancebasedhitchance then
		return baseChance
	end
	if not targetPart then
		return baseChance
	end
	local origin = originPos or getFireOriginPosition()
	if not origin then
		local originPart = getLocalAimOriginPart()
		origin = originPart and originPart.Position or nil
	end
	if not origin then
		return baseChance
	end
	local distance = (targetPart.Position - origin).Magnitude
	local selectedChance = baseChance
	local points = {
		{
			distance = math.max(tonumber(cfg.distancehitchance1dist) or 0, 0),
			chance = math.clamp(tonumber(cfg.distancehitchance1value) or baseChance, 0, 100)
		},
		{
			distance = math.max(tonumber(cfg.distancehitchance2dist) or 0, 0),
			chance = math.clamp(tonumber(cfg.distancehitchance2value) or baseChance, 0, 100)
		},
		{
			distance = math.max(tonumber(cfg.distancehitchance3dist) or 0, 0),
			chance = math.clamp(tonumber(cfg.distancehitchance3value) or baseChance, 0, 100)
		},
		{
			distance = math.max(tonumber(cfg.distancehitchance4dist) or 0, 0),
			chance = math.clamp(tonumber(cfg.distancehitchance4value) or baseChance, 0, 100)
		},
		{
			distance = math.max(tonumber(cfg.distancehitchance5dist) or 0, 0),
			chance = math.clamp(tonumber(cfg.distancehitchance5value) or baseChance, 0, 100)
		}
	}
	table.sort(points, function(a, b)
		return a.distance < b.distance
	end)
	for _, point in ipairs(points) do
		if point.distance > 0 and distance >= point.distance then
			selectedChance = point.chance
		end
	end
	return selectedChance
end
local function getMissPos(startPos, targetPartOrPos)
	local targetPart = typeof(targetPartOrPos) == "Instance" and targetPartOrPos:IsA("BasePart") and targetPartOrPos or nil
	local targetPos = targetPart and targetPart.Position or targetPartOrPos
	if not targetPos then
		return startPos
	end
	local toTarget = targetPos - startPos
	if toTarget.Magnitude <= 0.001 then
		return targetPos + Vector3.new(cfg.missspread + 6, 0, 0)
	end
	local direction = toTarget.Unit
	local reference = math.abs(direction.Y) > 0.98 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0)
	local right = direction:Cross(reference)
	if right.Magnitude <= 0.001 then
		right = Vector3.new(0, 0, 1)
	else
		right = right.Unit
	end
	local up = right:Cross(direction)
	if up.Magnitude <= 0.001 then
		up = Vector3.new(0, 1, 0)
	else
		up = up.Unit
	end
	local partRadius = targetPart and math.max(targetPart.Size.X, targetPart.Size.Y, targetPart.Size.Z) * 0.75 or 2
	local missRadius = math.max(cfg.missspread, partRadius + 3)
	local angle = rng:NextNumber(0, math.pi * 2)
	local offset = right * math.cos(angle) * missRadius + up * math.sin(angle) * missRadius
	return targetPos + offset
end
local function getFovTargetPriority(player)
	if not cfg.prioritizecriminals then
		return 0
	end
	if player.Team == criminalsTeam then
		return 0
	end
	if player.Team == inmatesTeam then
		return 1
	end
	return 0
end
local function getClosest(fovRadius)
	fovRadius = fovRadius or cfg.fov
	local camera = workspace.CurrentCamera
	if not camera then
		return nil, nil
	end
	local aimPos = getFovScreenPosition(camera)
	local now = os.clock()
	if cfg.targetstickiness and currentTarget and (now - targetSwitchTime) < currentStickiness then
		if fullCheck(currentTarget) then
			local part = getTargetPart(currentTarget.Character)
			if part then
				local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
				if onScreen and screenPos.Z > 0 then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - aimPos).Magnitude
					if dist < fovRadius then
						return currentTarget, part.Position
					end
				end
			end
		end
	end
	local candidates = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if quickCheck(player) then
			local part = getTargetPart(player.Character)
			if part then
				local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
				if onScreen and screenPos.Z > 0 then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - aimPos).Magnitude
					if dist < fovRadius then
						candidates[# candidates + 1] = {
							player = player,
							dist = dist,
							part = part,
							priority = getFovTargetPriority(player)
						}
					end
				end
			end
		end
	end
	if cfg.prioritizeclosest then
		table.sort(candidates, function(a, b)
			if a.priority ~= b.priority then
				return a.priority < b.priority
			end
			return a.dist < b.dist
		end)
	else
		local bestPriority = math.huge
		for _, candidate in ipairs(candidates) do
			if candidate.priority < bestPriority then
				bestPriority = candidate.priority
			end
		end
		if bestPriority < math.huge then
			local prioritizedCandidates = {}
			for _, candidate in ipairs(candidates) do
				if candidate.priority == bestPriority then
					prioritizedCandidates[# prioritizedCandidates + 1] = candidate
				end
			end
			candidates = prioritizedCandidates
		end
		for i = # candidates, 2, - 1 do
			local j = rng:NextInteger(1, i)
			candidates[i], candidates[j] = candidates[j], candidates[i]
		end
	end
	for _, candidate in ipairs(candidates) do
		if fullCheck(candidate.player) then
			local part = getTargetPart(candidate.player.Character)
			if not part then
				continue
			end
			if candidate.player ~= currentTarget then
				currentTarget = candidate.player
				targetSwitchTime = now
				if cfg.targetstickinessrandom then
					currentStickiness = rng:NextNumber(cfg.targetstickinessmin, cfg.targetstickinessmax)
				else
					currentStickiness = cfg.targetstickinessduration
				end
			end
			return candidate.player, part.Position
		end
	end
	currentTarget = nil
	return nil, nil
end
local ShootEvent = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("ShootEvent")
local ReloadRemote = ReplicatedStorage:WaitForChild("GunRemotes"):WaitForChild("FuncReload")
local Debris = game:GetService("Debris")
local lastReloadRequest = 0
local function createBulletTrail(startPos, endPos, isTaser)
	local distance = (endPos - startPos).Magnitude
	local trail = Instance.new("Part")
	trail.Name = "BulletTrail"
	trail.Anchored = true
	trail.CanCollide = false
	trail.CanQuery = false
	trail.CanTouch = false
	trail.Material = Enum.Material.Neon
	trail.Size = Vector3.new(0.1, 0.1, distance)
	trail.CFrame = CFrame.new(startPos, endPos) * CFrame.new(0, 0, - distance / 2)
	trail.Transparency = 0.5
	if isTaser then
		trail.BrickColor = BrickColor.new("Cyan")
		trail.Size = Vector3.new(0.2, 0.2, distance)
		local light = Instance.new("SurfaceLight")
		light.Color = Color3.fromRGB(0, 234, 255)
		light.Range = 7
		light.Brightness = 5
		light.Face = Enum.NormalId.Bottom
		light.Parent = trail
	else
		trail.BrickColor = BrickColor.Yellow()
	end
	trail.Parent = workspace
	Debris:AddItem(trail, isTaser and 0.8 or 0.1)
end
local function getBulletsLabel()
	if cachedBulletsLabel and cachedBulletsLabel.Parent then
		return cachedBulletsLabel
	end
	cachedBulletsLabel = nil
	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local home = playerGui and playerGui:FindFirstChild("Home")
	local hud = home and home:FindFirstChild("hud")
	local bottomRight = hud and hud:FindFirstChild("BottomRightFrame")
	local gunFrame = bottomRight and bottomRight:FindFirstChild("GunFrame")
	cachedBulletsLabel = gunFrame and gunFrame:FindFirstChild("BulletsLabel") or nil
	return cachedBulletsLabel
end
local function requestReload(gun)
	local now = os.clock()
	if now - lastReloadRequest < 0.5 then
		return
	end
	if not gun or gun:GetAttribute("Local_ReloadSession") ~= 0 then
		return
	end
	local storedAmmo = gun:GetAttribute("StoredAmmo")
	if typeof(storedAmmo) == "number" and storedAmmo <= 0 then
		return
	end
	lastReloadRequest = now
	task.spawn(function()
		pcall(function()
			ReloadRemote:InvokeServer()
		end)
	end)
end
local function autoShoot()
	local gun = currentGun
	if not cfg.autoshoot or not cfg.enabled or not gun then
		return
	end
	if gun.Parent ~= LocalPlayer.Character then
		return
	end
	if not gunMatchesAutoShootWeapon(gun) then
		lastAutoTarget = nil
		return
	end
	local now = os.clock()
	local reloadSession = gun:GetAttribute("Local_ReloadSession") or 0
	if reloadSession ~= 0 or gun:GetAttribute("Local_IsShooting") then
		return
	end
	if not isSniperStable(gun) then
		return
	end
	local fireRate = math.max(gun:GetAttribute("FireRate") or 0, cfg.autoshootdelay)
	if now - lastAutoShoot < fireRate then
		return
	end
	local myChar = LocalPlayer.Character
	if not myChar then
		return
	end
	local myHead = myChar:FindFirstChild("Head")
	if not myHead then
		return
	end
	local muzzle = gun:FindFirstChild("Muzzle")
	local startPos = muzzle and muzzle.Position or myHead.Position
	local target, targetPos = getClosest(cfg.fov)
	if not target or not fullCheck(target) then
		lastAutoTarget = nil
		return
	end
	if target ~= lastAutoTarget then
		targetAcquiredTime = now
		lastAutoTarget = target
	end
	local acquireDelay = shouldUseInstantAcquireDelay(gun) and 0 or cfg.autoshootstartdelay
	local requiredDelay = math.max(acquireDelay, gun:GetAttribute("ChargeTime") or 0)
	if now - targetAcquiredTime < requiredDelay then
		return
	end
	local targetPart = getTargetPart(target.Character)
	if not targetPart then
		return
	end
	local weaponRange = gun:GetAttribute("Range")
	if weaponRange and (targetPart.Position - startPos).Magnitude > weaponRange + 5 then
		return
	end
	local ammo = gun:GetAttribute("Local_CurrentAmmo") or gun:GetAttribute("CurrentAmmo") or 0
	if ammo <= 0 then
		requestReload(gun)
		return
	end
	lastAutoShoot = now
	local isTaser = isTaserGun(gun)
	local sniper = isSniper(gun)
	local shotgun = isShotgun(gun)
	local shouldHit = false
	if cfg.taseralwayshit and isTaser then
		shouldHit = true
	elseif cfg.ifplayerstill and isStanding(target) then
		shouldHit = true
	elseif shouldBypassHitchance(gun) then
		shouldHit = true
	else
		shouldHit = rollHit(getDistanceBasedHitChance(targetPart, startPos))
	end
	local projectileCount = gun:GetAttribute("ProjectileCount") or 1
	local shots = {}
	for i = 1, projectileCount do
		local aimPoint
		if shouldHit then
			aimPoint = targetPart.Position
		else
			if cfg.missspread > 0 then
				aimPoint = getMissPos(startPos, targetPart)
			else
				return
			end
		end
		local hitPart = shouldHit and targetPart or nil
		local finalPos = aimPoint
		if shouldHit then
			if isTaser then
				local simulatedHit, simulatedPos = simulateProjectileImpact(startPos, aimPoint, gun)
				finalPos = simulatedPos
				hitPart = simulatedHit or targetPart
			elseif shotgun and cfg.shotgunnaturalspread then
				local simulatedHit, simulatedPos = simulateProjectileImpact(startPos, aimPoint, gun)
				finalPos = simulatedPos
				hitPart = simulatedHit or targetPart
			end
		end
		shots[i] = {
			myHead.Position,
			finalPos,
			hitPart
		}
		createBulletTrail(startPos, finalPos, isTaser)
	end
	ShootEvent:FireServer(shots)
	if gun ~= currentGun or gun.Parent ~= LocalPlayer.Character then
		return
	end
	local newAmmo = ammo - 1
	gun:SetAttribute("Local_CurrentAmmo", newAmmo)
	local bulletsLabel = getBulletsLabel()
	if bulletsLabel then
		if sniper then
			bulletsLabel.Text = newAmmo .. " | " .. (gun:GetAttribute("StoredAmmo") or 0)
		else
			bulletsLabel.Text = newAmmo .. "/" .. (gun:GetAttribute("MaxAmmo") or 30)
		end
	end
	local handle = gun:FindFirstChild("Handle")
	if handle then
		local shootSound = handle:FindFirstChild("ShootSound")
		if shootSound then
			local sound = shootSound:Clone()
			sound.Parent = handle
			sound:Play()
			Debris:AddItem(sound, 2)
		end
	end
end
local function getGun()
	local char = LocalPlayer.Character
	if not char then
		return nil
	end
	local children = char:GetChildren()
	for index = # children, 1, - 1 do
		local tool = children[index]
		if tool:IsA("Tool") and tool:GetAttribute("ToolType") == "Gun" then
			return tool
		end
	end
	return nil
end
local lastGun = nil
syncDistanceHitchanceAimMaxDistance()
RunService.Heartbeat:Connect(function()
	local now = os.clock()
	syncDistanceHitchanceAimMaxDistance()
	currentGun = getGun()
	if currentGun ~= lastGun then
		resetAimState()
		lastGun = currentGun
	end
	updateAutoGrab(now)
	autoShoot()
end)
RunService.PreRender:Connect(function()
	local camera = workspace.CurrentCamera
	local fovPos = getFovScreenPosition(camera)
	fovCircle.Position = fovPos
	fovCircle.Radius = cfg.fov
	fovCircle.Visible = cfg.showfov and cfg.enabled
	if cfg.showtargetline and cfg.enabled then
		local target, targetPos = getClosest()
		if target and targetPos and camera then
			local screenPos, onScreen = camera:WorldToViewportPoint(targetPos)
			if onScreen then
				targetLine.From = fovPos
				targetLine.To = Vector2.new(screenPos.X, screenPos.Y)
				targetLine.Visible = true
			else
				targetLine.Visible = false
			end
		else
			targetLine.Visible = false
		end
	else
		targetLine.Visible = false
	end
end)
local function bindPlayer(player)
	player.CharacterRemoving:Connect(function(char)
		randomPartCache[char] = nil
		if currentTarget and currentTarget == player then
			currentTarget = nil
		end
		if lastAutoTarget and lastAutoTarget == player then
			lastAutoTarget = nil
		end
	end)
end
for _, player in ipairs(Players:GetPlayers()) do
	bindPlayer(player)
end
Players.PlayerAdded:Connect(bindPlayer)
LocalPlayer:GetPropertyChangedSignal("Team"):Connect(function()
	resetAimState()
end)
local function noUpvals(fn)
	return function(...)
		return fn(...)
	end
end
local origCastRay
local hooked = false
local function setupHook()
	local castRayFunc = filtergc("function", {
		Name = "castRay"
	}, true)
	if not castRayFunc then
		return false
	end
	origCastRay = hookfunction(castRayFunc, noUpvals(function(startPos, targetPos, ...)
		if not cfg.enabled then
			return origCastRay(startPos, targetPos, ...)
		end
		local closest = getClosest(cfg.fov)
		if closest and closest.Character then
			local gun = currentGun
			if not gun then
				return origCastRay(startPos, targetPos, ...)
			end
			local isTaser = isTaserGun(gun)
			local shotgun = isShotgun(gun)
			local sniperStable = isSniperStable(gun)
			local shouldHit = false
			local bypassHitchance = shouldBypassHitchance(gun)
			local targetPart = getTargetPart(closest.Character)
			if not targetPart then
				return origCastRay(startPos, targetPos, ...)
			end
			if not isInCurrentGunRange(targetPart.Position, startPos) then
				return origCastRay(startPos, targetPos, ...)
			end
			if cfg.shotgungamehandled and shotgun then
				return origCastRay(startPos, targetPart.Position, ...)
			end
			if cfg.taseralwayshit and isTaser then
				shouldHit = true
			elseif cfg.ifplayerstill and isStanding(closest) then
				shouldHit = true
			elseif bypassHitchance then
				shouldHit = true
			else
				shouldHit = rollHit(getDistanceBasedHitChance(targetPart, startPos))
			end
			if shouldHit then
				if isSniper(gun) and not sniperStable then
					return origCastRay(startPos, targetPart.Position, ...)
				end
				if isTaser then
					return origCastRay(startPos, targetPart.Position, ...)
				end
				if cfg.shotgunnaturalspread and shotgun then
					return origCastRay(startPos, targetPart.Position, ...)
				end
				return targetPart, targetPart.Position
			else
				if cfg.missspread > 0 then
					local missPos = getMissPos(startPos, targetPart)
					return origCastRay(startPos, missPos, ...)
				end
				return origCastRay(startPos, targetPos, ...)
			end
		end
		return origCastRay(startPos, targetPos, ...)
	end))
	return true
end
if not setupHook() then
	task.spawn(function()
		while not hooked do
			task.wait(0.5)
			if setupHook() then
				hooked = true
			end
		end
	end)
else
	hooked = true
end
local SilentAimTab = PrisonLife:CreateTab({
	Name = "Silent Aim",
	Icon = NebulaIcons:GetIcon('crosshair', 'Phosphor'),
	Columns = 2,
}, "INDEX")
local SilentAimBox = SilentAimTab:CreateGroupbox({
	Name = "Silent Aim",
	Column = 1
}, "INDEX")
SilentAimBox:CreateToggle({
	Name = "Enabled",
	CurrentValue = false,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.enabled = true
		else
			cfg.enabled = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateDivider()
SilentAimBox:CreateToggle({
	Name = "Team Check",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.teamcheck = true
		else
			cfg.teamcheck = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateToggle({
	Name = "Wall Check (only shoot visible players)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.wallcheck = true
		else
			cfg.wallcheck = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateToggle({
	Name = "Death Check (only shoot alive players)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.deathcheck = true
		else
			cfg.deathcheck = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateToggle({
	Name = "Forcefield Check (dont shoot players with a forcefield)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.ffcheck = true
		else
			cfg.ffcheck = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateDivider()
SilentAimBox:CreateToggle({
	Name = "Show FOV Circle",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.showfov = true
		else
			cfg.showfov = false
		end
	end,
}, "INDEX")
SilentAimBox:CreateSlider({
	Name = "FOV Size",
	Icon = NebulaIcons:GetIcon('chart-no-axes-column-increasing', 'Lucide'),
	Range = {
		50,
		200
	},
	Increment = 1,
	Value = 150,
	Callback = function(Value)
		cfg.fov = Value
	end,
}, "INDEX")
local SilentAimBox2 = SilentAimTab:CreateGroupbox({
	Name = "",
	Column = 2
}, "INDEX")
SilentAimBox2:CreateToggle({
	Name = "Vehicle Check (dont shoot people sitting in cars)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.vehiclecheck = true
		else
			cfg.vehiclecheck = false
		end
	end,
}, "INDEX")
SilentAimBox2:CreateToggle({
	Name = "Hostile Check (Only shoot hostile inmates)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.hostilecheck = true
		else
			cfg.hostilecheck = false
		end
	end,
}, "INDEX")
SilentAimBox2:CreateToggle({
	Name = "Trespass Check (Only shoot trespassing inmates)",
	CurrentValue = true,
	Style = 2,
	Callback = function(v)
		if v then
			cfg.trespasscheck = true
		else
			cfg.trespasscheck = false
		end
	end,
}, "INDEX")
