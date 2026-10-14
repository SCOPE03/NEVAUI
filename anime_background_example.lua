-- NevaUI animated background, large left logo, and floating open button example.
-- HTTP backgrounds require HTTP GET plus isfile, writefile, and getcustomasset support.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
-- Source GIF: https://tenor.com/view/chad-sigma-xtreme-xtremeverse-power-gif-11831658867899348818
-- GitHub GIF copy: https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/examples/assets/neva-tenor-chad-sigma-11831658867899348818-background.gif
-- Roblox ImageLabels use the matching sprite sheet; they do not play raw GIF files.
local BackgroundUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/examples/assets/neva-tenor-chad-sigma-11831658867899348818-background-sprites-v2.png"
local LogoAsset = "rbxassetid://76738354597155"
local LoadString = loadstring or load

local Success, Result = pcall(function()
	return LoadString(game:HttpGet(LibraryUrl))()
end)

if not Success then
	warn("Failed to load NevaUI: " .. tostring(Result))
	return
end

local NevaUI = Result
local Window = NevaUI:CreateWindow({
	Title = "NevaUI",
	Author = "by NEVA",
	Layout = "Dashboard",
	Logo = LogoAsset,
	IconSize = 38,
	Background = BackgroundUrl,
	BackgroundAnimation = {
		FrameSize = Vector2.new(128, 128),
		FrameCount = 29,
		Columns = 8,
		FPS = 8.3,
	},
	HidePanelBackground = true,
	Size = UDim2.fromOffset(850, 500),
	Folder = "NevaUIAnimeExample",
	Theme = "Dark",
	NewElements = false,
	ThemeColors = {
		PanelBackground = Color3.fromRGB(30, 30, 31),
		PanelBackgroundTransparency = 0.16,
		SidebarBackground = Color3.fromRGB(22, 22, 23),
		SidebarBackgroundTransparency = 0.08,
		TabBackgroundActive = Color3.fromRGB(66, 66, 68),
		TabBackgroundActiveTransparency = 0.12,
		ElementBackground = Color3.fromRGB(40, 40, 42),
		Text = Color3.fromRGB(239, 239, 239),
		Toggle = Color3.fromRGB(198, 198, 198),
		ToggleBar = Color3.fromRGB(88, 88, 90),
	},
	Sidebar = {
		Width = 256,
		Padding = 12,
		Gap = 8,
		Brand = {
			Layout = "Horizontal",
			Logo = LogoAsset,
			LogoSize = 68,
			LogoScaleType = "Fit",
			LogoRadius = 0,
			Title = "NevaUI",
			TitleSize = 21,
			Height = 92,
		},
		Divider = true,
	},
	OpenButton = {
		Floating = true,
		OnlyMobile = false,
		OnlyIcon = true,
		Icon = LogoAsset,
		Size = 64,
		Position = UDim2.new(1, -48, 1, -86),
		Draggable = true,
		BackgroundColor3 = Color3.fromRGB(28, 28, 30),
		BackgroundTransparency = 0.08,
		Color = Color3.fromRGB(198, 198, 198),
		StrokeTransparency = 0.14,
		StrokeThickness = 2,
	},
})

local WelcomeTab = Window:Tab({
	Title = "Welcome",
	Icon = "house",
	ShowTabTitle = true,
})

-- Top-level sections are automatically placed into separate Dashboard columns.
local FirstTable = WelcomeTab:Section({
	Title = "General",
	Desc = "First panel on this tab",
	Icon = "settings",
	Box = true,
	BoxBorder = true,
	Opened = true,
})

FirstTable:Toggle({
	Title = "Legacy switch test",
	Style = "Legacy",
	Value = true,
	Callback = function(value)
		print("Legacy switch:", value)
	end,
})

FirstTable:Button({
	Title = "Test notification",
	Style = "Legacy",
	Icon = "bell",
	Callback = function()
		NevaUI:Notify({
			Title = "NevaUI",
			Content = "The example button is working.",
			Duration = 3,
		})
	end,
})

local SecondTable = WelcomeTab:Section({
	Title = "Appearance",
	Desc = "Second panel on the same tab",
	Icon = "palette",
	Box = true,
	BoxBorder = true,
	Opened = true,
})

SecondTable:Toggle({
	Title = "Example appearance toggle",
	Style = "Legacy",
	Value = false,
	Callback = function(value)
		print("Appearance toggle:", value)
	end,
})

SecondTable:Button({
	Title = "Test second panel",
	Style = "Legacy",
	Icon = "check",
	Callback = function()
		print("Second panel button is working.")
	end,
})
