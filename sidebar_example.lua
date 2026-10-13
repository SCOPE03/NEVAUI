-- NevaUI Sidebar Configuration Example
-- Demonstrates all configurable sidebar options and runtime controls.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/935e7b2/dist/main.lua"
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
	-- Developers can set Logo to a Roblox Image asset for their script hub.
	Logo = "rbxassetid://134899357436301",
	-- Use an Image asset, not a Decal asset. This ID is a verified anime image.
	Background = "rbxassetid://121343473918667",
	BackgroundImageTransparency = 0.15,
	HidePanelBackground = true,
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
