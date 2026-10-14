-- NevaUI Dashboard reference example.
-- Uses a full-width category row, two-column setting cards, and only Legacy controls.

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
local SampleLogo = "rbxassetid://134899357436301" -- Existing NevaUI example asset; replace with your own image asset ID.
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
	Title = "NEVA UI",
	Author = "by NEVA",
	Layout = "Dashboard",
	NewElements = false, -- Keep the original toggle and control designs in this example.
	Logo = SampleLogo, -- Shows in the top bar and open button.
	IconSize = 30,
	Size = UDim2.fromOffset(820, 460),
	Sidebar = {
		Width = 230,
		Brand = {
			Logo = SampleLogo,
			Title = "NEVA UI",
			LogoSize = 36,
			TitleSize = 28,
			Height = 72,
		},
	},
})

local Tab = Window:Tab({
	Title = "Players",
	Icon = "users",
})

local Categories = { "Enemies", "Teammates", "Self" }
local CardsByCategory = {
	Enemies = {},
	Teammates = {},
	Self = {},
}

local function SelectCategory(category)
	for name, cards in pairs(CardsByCategory) do
		for _, card in ipairs(cards) do
			card.ElementFrame.Visible = name == category
		end
	end
end

local CategoryBar = Tab:Group({ Placement = "Header" })
for _, category in ipairs(Categories) do
	CategoryBar:Button({
		Title = category,
		Icon = "",
		Style = "Legacy",
		Callback = function()
			SelectCategory(category)
		end,
	})
end

local function AddSettingsCard(category, controlTitles)
	local Card = Tab:Section({
		Title = "General",
		Icon = "user",
		Box = true,
		BoxBorder = true,
		Opened = true,
	})
	table.insert(CardsByCategory[category], Card)

	for _, title in ipairs(controlTitles) do
		Card:Toggle({
			Title = title,
			Style = "Legacy",
			Value = title == "Enable ESP",
			Callback = function(value)
				print(category .. " / " .. title .. ":", value)
			end,
		})
	end

	Card.ElementFrame.Visible = false
end

-- Each category has two compact cards, matching the reference's two-column settings area.
AddSettingsCard("Enemies", { "Enable ESP", "Through walls", "Shared ESP", "Name" })
AddSettingsCard("Enemies", { "Weapon", "Through walls", "Name" })
AddSettingsCard("Teammates", { "Enable ESP", "Shared ESP", "Name" })
AddSettingsCard("Teammates", { "Weapon", "Through walls" })
AddSettingsCard("Self", { "Enable ESP", "Name" })
AddSettingsCard("Self", { "Weapon", "Shared ESP" })

SelectCategory("Enemies")
