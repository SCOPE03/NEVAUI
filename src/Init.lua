local NevaUI = {
	Window = nil,
	Theme = nil,
	Creator = require("./modules/Creator"),
	LocalizationModule = require("./modules/Localization"),
	NotificationModule = require("./components/Notification"),
	Themes = nil,
	Transparent = false,

	TransparencyValue = 0.15,

	UIScale = 1,

	ConfigManager = nil,
	Version = "0.0.0",

	Services = require("./utils/services/Init"),

	OnThemeChangeFunction = nil,

	cloneref = nil,
	UIScaleObj = nil,

	CreateWindow = nil,

	CurrentInput = nil,
}

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

NevaUI.cloneref = cloneref

local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))

function NevaUI.GenerateGUID()
	return HttpService:GenerateGUID(false)
end

local CurInput = NevaUI.GenerateGUID()

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	--[[if GameProcessed then
		return
	end]]

	task.defer(function()
		if
			Input.UserInputType == Enum.UserInputType.MouseButton1
			or Input.UserInputType == Enum.UserInputType.Touch
		then
			if NevaUI.CurrentInput and NevaUI.CurrentInput ~= CurInput then
				return
			end

			NevaUI.CurrentInput = CurInput
			--print(CurInput)
			--NevaUI.InputStartedOnUI = false
		end
	end)
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessed)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
		if NevaUI.CurrentInput and NevaUI.CurrentInput ~= CurInput then
			return
		end

		NevaUI.CurrentInput = nil
	end
end)

local LocalPlayer = Players.LocalPlayer or nil

local Package = HttpService:JSONDecode(require("../build/package"))
if Package then
	NevaUI.Version = Package.version
end

local KeySystem = require("./components/KeySystem")

local Creator = NevaUI.Creator

local New = Creator.New

--local Tween = Creator.Tween
--local ServicesModule = NevaUI.Services

local Acrylic = require("./utils/Acrylic/Init")

local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

local GUIParent = gethui and gethui() or (CoreGui or LocalPlayer:WaitForChild("PlayerGui"))

local UIScaleObj = New("UIScale", {
	Scale = NevaUI.UIScale,
})

NevaUI.UIScaleObj = UIScaleObj

NevaUI.ScreenGui = New("ScreenGui", {
	Name = "NevaUI",
	Parent = GUIParent,
	IgnoreGuiInset = true,
	ScreenInsets = "None",
	DisplayOrder = -99999,
}, {

	New("Folder", {
		Name = "Window",
	}),
	-- New("Folder", {
	--     Name = "Notifications"
	-- }),
	-- New("Folder", {
	--     Name = "Dropdowns"
	-- }),
	New("Folder", {
		Name = "KeySystem",
	}),
	New("Folder", {
		Name = "Popups",
	}),
	New("Folder", {
		Name = "ToolTips",
	}),
})

NevaUI.NotificationGui = New("ScreenGui", {
	Name = "NevaUI/Notifications",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
NevaUI.DropdownGui = New("ScreenGui", {
	Name = "NevaUI/Dropdowns",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
NevaUI.TooltipGui = New("ScreenGui", {
	Name = "NevaUI/Tooltips",
	Parent = GUIParent,
	IgnoreGuiInset = true,
})
ProtectGui(NevaUI.ScreenGui)
ProtectGui(NevaUI.NotificationGui)
ProtectGui(NevaUI.DropdownGui)
ProtectGui(NevaUI.TooltipGui)

Creator.Init(NevaUI)

function NevaUI:SetParent(parent)
	if NevaUI.ScreenGui then
		NevaUI.ScreenGui.Parent = parent
	end
	if NevaUI.NotificationGui then
		NevaUI.NotificationGui.Parent = parent
	end
	if NevaUI.DropdownGui then
		NevaUI.DropdownGui.Parent = parent
	end
	if NevaUI.TooltipGui then
		NevaUI.TooltipGui.Parent = parent
	end
end
math.clamp(NevaUI.TransparencyValue, 0, 1)

local Holder = NevaUI.NotificationModule.Init(NevaUI.NotificationGui)

function NevaUI:Notify(Config)
	Config.Holder = Holder.Frame
	Config.Window = NevaUI.Window
	--Config.NevaUI = NevaUI
	return NevaUI.NotificationModule.New(Config)
end

function NevaUI:SetNotificationLower(Val)
	Holder.SetLower(Val)
end

function NevaUI:SetFont(FontId)
	Creator.UpdateFont(FontId)
end

function NevaUI:OnThemeChange(func)
	NevaUI.OnThemeChangeFunction = func
end

function NevaUI:AddTheme(LTheme)
	NevaUI.Themes[LTheme.Name] = LTheme
	return LTheme
end

function NevaUI:SetTheme(Value)
	if NevaUI.Themes[Value] then
		NevaUI.Theme = NevaUI.Themes[Value]
		Creator.SetTheme(NevaUI.Themes[Value])

		if NevaUI.OnThemeChangeFunction then
			NevaUI.OnThemeChangeFunction(Value)
		end

		return NevaUI.Themes[Value]
	end
	return nil
end

function NevaUI:GetThemes()
	return NevaUI.Themes
end
function NevaUI:GetCurrentTheme()
	return NevaUI.Theme.Name
end
function NevaUI:GetTransparency()
	return NevaUI.Transparent or false
end
function NevaUI:GetWindowSize()
	return NevaUI.Window.UIElements.Main.Size
end
function NevaUI:Localization(LocalizationConfig)
	return NevaUI.LocalizationModule:New(LocalizationConfig, Creator)
end

function NevaUI:SetLanguage(Value)
	if Creator.Localization then
		return Creator.SetLanguage(Value)
	end
	return false
end

function NevaUI:ToggleAcrylic(Value)
	if NevaUI.Window and NevaUI.Window.AcrylicPaint and NevaUI.Window.AcrylicPaint.Model then
		NevaUI.Window.Acrylic = Value
		NevaUI.Window.AcrylicPaint.Model.Transparency = Value and 0.98 or 1
		if Value then
			Acrylic.Enable()
		else
			Acrylic.Disable()
		end
	end
end

function NevaUI:Gradient(stops, props)
	local colorSequence = {}
	local transparencySequence = {}

	for posStr, stop in next, stops do
		local position = tonumber(posStr)
		if position then
			position = math.clamp(position / 100, 0, 1)

			local color = stop.Color
			if typeof(color) == "string" and string.sub(color, 1, 1) == "#" then
				color = Color3.fromHex(color)
			end

			local transparency = stop.Transparency or 0

			table.insert(colorSequence, ColorSequenceKeypoint.new(position, color))
			table.insert(transparencySequence, NumberSequenceKeypoint.new(position, transparency))
		end
	end

	table.sort(colorSequence, function(a, b)
		return a.Time < b.Time
	end)
	table.sort(transparencySequence, function(a, b)
		return a.Time < b.Time
	end)

	if #colorSequence < 2 then
		table.insert(colorSequence, ColorSequenceKeypoint.new(1, colorSequence[1].Value))
		table.insert(transparencySequence, NumberSequenceKeypoint.new(1, transparencySequence[1].Value))
	end

	local gradientData = {
		Color = ColorSequence.new(colorSequence),
		Transparency = NumberSequence.new(transparencySequence),
	}

	if props then
		for k, v in pairs(props) do
			gradientData[k] = v
		end
	end

	return gradientData
end

function NevaUI:Popup(PopupConfig)
	PopupConfig.NevaUI = NevaUI
	return require("./components/popup/Init").new(PopupConfig, NevaUI.ScreenGui.Popups)
end

NevaUI.Themes = require("./themes/Init")(NevaUI, Creator)

Creator.Themes = NevaUI.Themes

NevaUI:SetTheme("Dark")
NevaUI:SetLanguage(Creator.Language)

function NevaUI:CreateWindow(Config)
	local CreateWindow = require("./components/window/Init")

	if not RunService:IsStudio() and writefile then
		if not isfolder("NevaUI") then
			makefolder("NevaUI")
		end
		if Config.Folder then
			makefolder(Config.Folder)
		else
			makefolder(Config.Title)
		end
	end

	Config.NevaUI = NevaUI
	Config.Window = NevaUI.Window
	Config.Parent = NevaUI.ScreenGui.Window

	if NevaUI.Window then
		warn("You cannot create more than one window")
		return
	end

	local CanLoadWindow = true

	local Theme = NevaUI.Themes[Config.Theme or "Dark"]

	--NevaUI.Theme = Theme
	Creator.SetTheme(Theme)

	local hwid = gethwid or function()
		return Players.LocalPlayer.UserId
	end

	local Filename = hwid()

	if Config.KeySystem then
		CanLoadWindow = false

		local function loadKeysystem()
			KeySystem.new(Config, Filename, function(c)
				CanLoadWindow = c
			end)
		end

		local keyPath = (Config.Folder or "Temp") .. "/" .. Filename .. ".key"

		if Config.KeySystem.KeyValidator then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isValid = Config.KeySystem.KeyValidator(savedKey)

				if isValid then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		elseif not Config.KeySystem.API then
			if Config.KeySystem.SaveKey and isfile(keyPath) then
				local savedKey = readfile(keyPath)
				local isKey = (type(Config.KeySystem.Key) == "table") and table.find(Config.KeySystem.Key, savedKey)
					or tostring(Config.KeySystem.Key) == tostring(savedKey)

				if isKey then
					CanLoadWindow = true
				else
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		else
			if isfile(keyPath) then
				local fileKey = readfile(keyPath)
				local isSuccess = false

				for _, i in next, Config.KeySystem.API do
					local serviceData = NevaUI.Services[i.Type]
					if serviceData then
						local args = {}
						for _, argName in next, serviceData.Args do
							table.insert(args, i[argName])
						end

						local service = serviceData.New(table.unpack(args))
						local success = service.Verify(fileKey)
						if success then
							isSuccess = true
							break
						end
					end
				end

				CanLoadWindow = isSuccess
				if not isSuccess then
					loadKeysystem()
				end
			else
				loadKeysystem()
			end
		end

		repeat
			task.wait()
		until CanLoadWindow
	end

	local Window = CreateWindow(Config)

	NevaUI.Transparent = Config.Transparent
	NevaUI.Window = Window

	if Config.Acrylic then
		Acrylic.init()
	end

	-- function Window:ToggleTransparency(Value)
	--     NevaUI.Transparent = Value
	--     NevaUI.Window.Transparent = Value

	--     Window.UIElements.Main.Background.BackgroundTransparency = Value and NevaUI.TransparencyValue or 0
	--     Window.UIElements.Main.Background.ImageLabel.ImageTransparency = Value and NevaUI.TransparencyValue or 0
	--     Window.UIElements.Main.Gradient.UIGradient.Transparency = NumberSequence.new{
	--         NumberSequenceKeypoint.new(0, 1),
	--         NumberSequenceKeypoint.new(1, Value and 0.85 or 0.7),
	--     }
	-- end

	return Window
end

return NevaUI
