-- NevaUI configurable element-style test
-- This focused example contains only controls that demonstrate style selection.

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
	Title = "Element Style Test",
	Author = "NevaUI",
	NewElements = false, -- default style; each control below can override it.
})
local Tab = Window:Tab({
	Title = "Style Test",
	Icon = "sliders-horizontal",
})

Tab:Toggle({
	Title = "Modern toggle",
	Desc = 'Style = "Modern" — pill track with a circular thumb.',
	Style = "Modern",
	Value = true,
	Callback = function(value)
		print("Modern toggle:", value)
	end,
})

Tab:Toggle({
	Title = "Legacy toggle",
	Desc = 'Style = "Legacy" — original toggle appearance.',
	Style = "Legacy",
	Value = false,
	Callback = function(value)
		print("Legacy toggle:", value)
	end,
})

Tab:Button({
	Title = "Modern button",
	Style = "Modern",
	Icon = "sparkles",
	Callback = function()
		print("Modern button clicked")
	end,
})

Tab:Button({
	Title = "Legacy button",
	Style = "Legacy",
	Icon = "mouse-pointer-click",
	Callback = function()
		print("Legacy button clicked")
	end,
})

Tab:Slider({
	Title = "Modern slider",
	Style = "Modern",
	Value = { Min = 0, Max = 100, Default = 50 },
	Callback = function(value)
		print("Modern slider:", value)
	end,
})

Tab:Slider({
	Title = "Legacy slider",
	Style = "Legacy",
	Value = { Min = 0, Max = 100, Default = 50 },
	Callback = function(value)
		print("Legacy slider:", value)
	end,
})
