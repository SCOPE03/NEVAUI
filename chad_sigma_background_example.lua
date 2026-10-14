-- NevaUI background image, large left logo, and floating open button example.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
local BackgroundImage = "rbxassetid://117316815074414"
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
	Background = BackgroundImage,
	BackgroundImageTransparency = 0.15,
	HidePanelBackground = true,
	Size = UDim2.fromOffset(850, 500),
	Folder = "NevaUIAnimeExample",
	Theme = "Dark",
	NewElements = false,
	ThemeColors = {
		PanelBackground = Color3.fromRGB(32, 20, 20),
		PanelBackgroundTransparency = 0.16,
		SidebarBackground = Color3.fromRGB(24, 14, 14),
		SidebarBackgroundTransparency = 0.08,
		TabBackgroundActive = Color3.fromRGB(120, 40, 40),
		TabBackgroundActiveTransparency = 0.12,
		ElementBackground = Color3.fromRGB(42, 28, 28),
		Text = Color3.fromRGB(244, 236, 236),
		Toggle = Color3.fromRGB(220, 60, 60),
		ToggleBar = Color3.fromRGB(92, 70, 70),
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
		DividerThickness = 2,
		DividerTransparency = 0.72,
		DividerColor = Color3.fromRGB(220, 60, 60),
		-- Sliding accent bar that tracks the selected tab.
		Selector = true,
		SelectorWidth = 4,
		SelectorColor = Color3.fromRGB(220, 60, 60),
		-- Sidebar tab sizing and iconography.
		TabHeight = 34,
		TabRadius = 10,
		IconSize = 17,
		-- Sidebar scrollbar (shown when tabs overflow).
		ScrollBarThickness = 4,
		ScrollBarTransparency = 0.6,
		ScrollBarColor = Color3.fromRGB(220, 60, 60),
	},
	OpenButton = {
		Floating = true,
		OnlyMobile = false,
		OnlyIcon = true,
		Icon = LogoAsset,
		Size = 64,
		Position = UDim2.new(1, -48, 1, -86),
		Draggable = true,
		BackgroundColor3 = Color3.fromRGB(30, 18, 18),
		BackgroundTransparency = 0.08,
		Color = Color3.fromRGB(220, 60, 60),
		StrokeTransparency = 0.14,
		StrokeThickness = 2,
	},
})

local WelcomeTab = Window:Tab({
	Title = "Welcome",
	Icon = "house",
	ShowTabTitle = true,
})

local VisualsTab = Window:Tab({
	Title = "Visuals",
	Icon = "eye",
	ShowTabTitle = true,
})

local CombatTab = Window:Tab({
	Title = "Combat",
	Icon = "sword",
	ShowTabTitle = true,
})

local PlayerTab = Window:Tab({
	Title = "Player",
	Icon = "user",
	ShowTabTitle = true,
})

local SettingsTab = Window:Tab({
	Title = "Settings",
	Icon = "settings",
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

-- Extra tabs keep the rail long enough to show the sliding selector and the
-- sidebar scrollbar.
local function AddPlaceholderTab(Tab, Label, Icon)
	local Panel = Tab:Section({
		Title = Label,
		Desc = "Placeholder panel for " .. Label,
		Icon = Icon,
		Box = true,
		BoxBorder = true,
		Opened = true,
	})

	Panel:Button({
		Title = "Action",
		Style = "Legacy",
		Icon = "play",
		Callback = function()
			print(Label .. " action pressed.")
		end,
	})

	return Panel
end

AddPlaceholderTab(VisualsTab, "Visuals", "eye")
AddPlaceholderTab(CombatTab, "Combat", "sword")
AddPlaceholderTab(PlayerTab, "Player", "user")
AddPlaceholderTab(SettingsTab, "Settings", "settings")

Window:SelectTab(1)
