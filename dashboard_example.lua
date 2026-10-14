-- NevaUI Dashboard layout demonstration
-- Dashboard mode arranges top-level tab controls into two columns.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
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
	Title = "Lumina Dashboard",
	Layout = "Dashboard", -- two columns; NewElements defaults to true unless set explicitly
	Size = UDim2.fromOffset(820, 460),
	Sidebar = {
		Width = 190,
		Brand = {
			Logo = "sparkles", -- replace with your icon name or Roblox image asset ID
			Title = "Lumina",
			LogoSize = 24,
			Height = 56,
		},
	},
})

local Tab = Window:Tab({
	Title = "Players",
	Icon = "users",
})

Tab:Toggle({
	Title = "Enable ESP",
	Desc = "Show player outlines.",
	Value = true,
	Callback = function(value)
		print("Enable ESP:", value)
	end,
})

Tab:Toggle({
	Title = "Through walls",
	Value = false,
	Callback = function(value)
		print("Through walls:", value)
	end,
})

Tab:Slider({
	Title = "Maximum distance",
	Value = { Min = 0, Max = 1000, Default = 250 },
	Callback = function(value)
		print("Maximum distance:", value)
	end,
})

Tab:Button({
	Title = "Reset filters",
	Icon = "rotate-ccw",
	Callback = function()
		print("Filters reset")
	end,
})

Tab:Toggle({
	Title = "Team check",
	Value = true,
	Callback = function(value)
		print("Team check:", value)
	end,
})

Tab:Slider({
	Title = "Outline thickness",
	Value = { Min = 1, Max = 10, Default = 3 },
	Callback = function(value)
		print("Outline thickness:", value)
	end,
})
