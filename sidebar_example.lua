-- NevaUI Sidebar Configuration Example
-- Demonstrates all configurable sidebar options and runtime controls.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
local LoadString = loadstring or load
local NevaUI

local Success, Result = pcall(function()
	return LoadString(game:HttpGet(LibraryUrl))()
end)

if not Success then
	warn("Failed to load NevaUI: " .. tostring(Result))
	return
end

NevaUI = Result

local Window = NevaUI:CreateWindow({
		Title = "Sidebar Showcase",
		Author = "by NEVA",
		NewElements = false, -- element-level Style values below override this default.
	-- Script-hub logo: the topbar and floating open button use this logo.
	Logo = "rbxassetid://134899357436301",
	-- Use an Image asset, not a Decal asset. HidePanelBackground lets it show through.
	Background = "rbxassetid://121343473918667",
	BackgroundImageTransparency = 0.15,
	HidePanelBackground = true,
	OpenButton = {
		Floating = true,
		OnlyMobile = false,
		OnlyIcon = true,
		Size = 56,
		Position = UDim2.new(1, -44, 1, -82),
		Draggable = true,
		BackgroundColor3 = Color3.fromRGB(18, 18, 22),
		BackgroundTransparency = 0.12,
		Color = ColorSequence.new(Color3.fromRGB(80, 201, 255), Color3.fromRGB(232, 28, 255)),
		StrokeThickness = 2,
		StrokeTransparency = 0.05,
	},
	Folder = "SidebarShowcase",
	HideSearchBar = false,

	-- All new sidebar configuration options.
	Sidebar = {
		Width = 230,
		Padding = 10,
		Gap = 8,
		Divider = true,
		DividerThickness = 2,
		DividerTransparency = 0.72,
		DividerColor = Color3.fromRGB(80, 170, 255),
	},
})

Window:Tag({
	Title = "Sidebar API",
	Icon = "settings-2",
	Color = Color3.fromRGB(80, 170, 255),
	Border = true,
})

local DividerStyle = {
	Color = Color3.fromRGB(80, 170, 255),
	Thickness = 2,
	Transparency = 0.2,
	Padding = 10,
	Height = 14,
}

-- Horizontal separators can be placed between sidebar entries.
Window:Divider(DividerStyle)

local OverviewTab = Window:Tab({
	Title = "Welcome",
	Icon = "sparkles",
	ShowTabTitle = true,
})

OverviewTab:Paragraph({
	Title = "Configurable Sidebar",
	Desc = "This example demonstrates width, padding, gap, divider visibility, divider thickness, divider transparency, divider color, and the runtime divider API.",
	Image = "solar:sidebar-minimalistic-bold",
})

Window:Divider(DividerStyle)

local ControlsTab = Window:Tab({
	Title = "Live Controls",
	Icon = "sliders-horizontal",
	ShowTabTitle = true,
})

ControlsTab:Toggle({
	Title = "Sidebar Divider",
	Desc = "Show or hide the vertical sidebar divider.",
	Default = true,
	Callback = function(value)
		Window:SetSidebarDivider(value)
	end,
})

ControlsTab:Paragraph({
	Title = "Current configuration",
	Desc = "Width: 230 | Padding: 10 | Gap: 8 | Divider thickness: 2 | Transparency: 0.72",
})

local StylesTab = Window:Tab({
	Title = "Element Styles",
	Icon = "paintbrush",
	ShowTabTitle = true,
})

StylesTab:Paragraph({
	Title = "Per-element style overrides",
	Desc = 'The window defaults to Legacy. Set Style = "Modern" or Style = "Legacy" on individual elements to mix the two designs.',
})

StylesTab:Toggle({
	Title = "Modern pill switch",
	Desc = 'Style = "Modern" — compact pill track and circular thumb.',
	Style = "Modern",
	Value = true,
	Callback = function(value)
		print("Modern switch:", value)
	end,
})

StylesTab:Toggle({
	Title = "Legacy switch",
	Desc = 'Style = "Legacy" — keeps the classic control.',
	Style = "Legacy",
	Value = false,
	Callback = function(value)
		print("Legacy switch:", value)
	end,
})

StylesTab:Button({
	Title = "Modern button",
	Style = "Modern",
	Icon = "sparkles",
	Callback = function()
		NevaUI:Notify({ Title = "Modern button", Content = "Modern element style selected.", Duration = 3 })
	end,
})

StylesTab:Button({
	Title = "Legacy button",
	Style = "Legacy",
	Icon = "mouse-pointer-click",
	Callback = function()
		NevaUI:Notify({ Title = "Legacy button", Content = "Legacy element style selected.", Duration = 3 })
	end,
})

StylesTab:Slider({
	Title = "Modern slider",
	Style = "Modern",
	Value = { Min = 0, Max = 100, Default = 50 },
	Callback = function(value)
		print("Modern slider:", value)
	end,
})

local LayoutTab = Window:Tab({
	Title = "Layout",
	Icon = "panel-left",
	ShowTabTitle = true,
})

LayoutTab:Image({
	Image = "rbxassetid://121343473918667",
	AspectRatio = "16:9",
	Radius = 12,
})

LayoutTab:Paragraph({
	Title = "Background image",
	Desc = "This window uses verified Image asset rbxassetid://121343473918667 as its background image.",
	Image = "rbxassetid://121343473918667",
})

Window:Divider(DividerStyle)

local AboutTab = Window:Tab({
	Title = "About",
	Icon = "info",
	ShowTabTitle = true,
})

AboutTab:Paragraph({
	Title = "NevaUI",
	Desc = "Use the Sidebar table in CreateWindow to customize the sidebar without editing the library source.",
})

-- The divider can also be controlled directly from any callback:
-- Window:SetSidebarDivider(false)
-- Window:SetSidebarDivider(true)
