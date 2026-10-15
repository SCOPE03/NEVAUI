-- NevaUI anime background example.
-- Large left brand logo, floating open button, sidebar search bar, and a fully
-- configurable sidebar (colors, logo size, selector, divider, scrollbar).

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
local BackgroundImage = "rbxassetid://117316815074414"
local LogoAsset = "rbxassetid://85413415772370"
local LoadString = loadstring or load

local Success, Result = pcall(function()
        return LoadString(game:HttpGet(LibraryUrl))()
end)

if not Success then
        warn("Failed to load NevaUI: " .. tostring(Result))
        return
end

local NevaUI = Result
local Accent = Color3.fromRGB(220, 60, 60)

local Window = NevaUI:CreateWindow({
        Title = "NevaUI",
        Author = "by NEVA",
        Layout = "Dashboard",
        Logo = LogoAsset,
        IconSize = 38,
        Background = BackgroundImage,
        -- See-through window: the background image is mostly transparent and
        -- the window surface is dimmed further below so the game shows through.
        BackgroundImageTransparency = 0.55,
        Transparent = true,
        HidePanelBackground = true,
        Size = UDim2.fromOffset(850, 500),
        Folder = "NevaUIAnimeExample",
        Theme = "Dark",
        NewElements = false,
        -- The sidebar search bar is shown by default; click it to filter tabs
        -- and elements by title or description.
        HideSearchBar = false,
        ThemeColors = {
                PanelBackground = Color3.fromRGB(32, 20, 20),
                PanelBackgroundTransparency = 0.16,
                ElementBackground = Color3.fromRGB(42, 28, 28),
                Text = Color3.fromRGB(244, 236, 236),
                Toggle = Color3.fromRGB(220, 60, 60),
                ToggleBar = Color3.fromRGB(92, 70, 70),
        },
        Sidebar = {
                Width = 256,
                Padding = 12,
                Gap = 8,
                -- Sidebar-only color overrides. Any theme token can be set here and
                -- it stays scoped to this window's sidebar instead of the global theme.
                Colors = {
                        SidebarBackground = Color3.fromRGB(24, 14, 14),
                        SidebarBackgroundTransparency = 0.08,
                        SidebarSelector = Accent,
                        -- Tab states are separate tokens: idle, hover, active and the
                        -- active+hover combination. Low transparencies read as a soft pill.
                        TabBackground = Color3.fromRGB(58, 34, 34),
                        TabBackgroundTransparency = 0.78,
                        TabBackgroundHover = Color3.fromRGB(104, 58, 58),
                        TabBackgroundHoverTransparency = 0.45,
                        TabBackgroundActive = Color3.fromRGB(120, 40, 40),
                        TabBackgroundActiveTransparency = 0.2,
                        TabBackgroundActiveHover = Color3.fromRGB(150, 56, 56),
                        TabBackgroundActiveHoverTransparency = 0.1,
                        TabIcon = Color3.fromRGB(244, 236, 236),
                        TabIconTransparency = 0.45,
                        TabIconTransparencyHover = 0.2,
                        TabIconTransparencyActive = 0.05,
                        TabText = Color3.fromRGB(244, 236, 236),
                        TabTextTransparency = 0.4,
                        TabTextTransparencyHover = 0.12,
                        TabTextTransparencyActive = 0.02,
                },
                Brand = {
                        Layout = "Horizontal",
                        Logo = LogoAsset,
                        -- Explicit logo sizing: the image is drawn background-free and
                        -- only gets a background when LogoBackground is set.
                        LogoSize = 88,
                        LogoScaleType = "Fit",
                        LogoRadius = 12,
                        LogoPadding = 0,
                        Title = "NevaUI",
                        TitleSize = 21,
                        Height = 112,
                },
                Divider = true,
                DividerThickness = 2,
                DividerTransparency = 0.72,
                DividerColor = Accent,
                -- Sliding accent bar that tracks the selected tab.
                Selector = true,
                SelectorWidth = 4,
                SelectorColor = Accent,
                -- Sidebar tab sizing and iconography.
                TabHeight = 34,
                TabRadius = 10,
                IconSize = 20,
                -- Sidebar scrollbar (shown when tabs overflow).
                ScrollBarThickness = 4,
                ScrollBarTransparency = 0.6,
                ScrollBarColor = Accent,
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
                Color = Accent,
                StrokeTransparency = 0.14,
                StrokeThickness = 2,
        },
})

-- */  Tabs  /* --
local WelcomeTab = Window:Tab({ Title = "Welcome", Icon = "house", ShowTabTitle = true })
local CustomizeTab = Window:Tab({ Title = "Customize", Icon = "sliders-horizontal", ShowTabTitle = true })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye", ShowTabTitle = true })
local CombatTab = Window:Tab({ Title = "Combat", Icon = "sword", ShowTabTitle = true })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user", ShowTabTitle = true })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings", ShowTabTitle = true })

-- */  Welcome  /* --
local IntroPanel = WelcomeTab:Section({
        Title = "Anime Background",
        Desc = "Full image background with a large left brand logo.",
        Icon = "sparkles",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

IntroPanel:Image({
        Image = BackgroundImage,
        AspectRatio = "16:9",
        Radius = 12,
})

IntroPanel:Paragraph({
        Title = "Everything is configurable",
        Desc = "Use the Customize tab to recolor the sidebar and resize the brand logo at runtime.",
})

local InfoPanel = WelcomeTab:Section({
        Title = "Sidebar Search",
        Desc = "Click the search box above the tabs to filter tabs and elements.",
        Icon = "search",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

InfoPanel:Button({
        Title = "Try a notification",
        Icon = "bell",
        Callback = function()
                NevaUI:Notify({
                        Title = "NevaUI",
                        Content = "The example button is working.",
                        Duration = 3,
                })
        end,
})

-- */  Customize (live sidebar controls)  /* --
local ColorPanel = CustomizeTab:Section({
        Title = "Sidebar Colors",
        Desc = "Recolor the sidebar without touching the library source.",
        Icon = "palette",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

ColorPanel:Colorpicker({
        Title = "Sidebar background",
        Default = Color3.fromRGB(24, 14, 14),
        Callback = function(color)
                Window:SetSidebarColor("SidebarBackground", color)
        end,
})

ColorPanel:Colorpicker({
        Title = "Accent and selector",
        Default = Accent,
        Callback = function(color)
                Window:SetSidebarColor("SidebarSelector", color)
                Window:SetSidebarSelectorColor(color)
        end,
})

local BrandPanel = CustomizeTab:Section({
        Title = "Brand Logo",
        Desc = "Size, padding, and optional background for the left logo.",
        Icon = "image",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

BrandPanel:Slider({
        Title = "Logo size",
        Step = 1,
        Value = { Min = 32, Max = 112, Default = 88 },
        Callback = function(value)
                Window:SetSidebarBrandLogoSize(value)
        end,
})

BrandPanel:Toggle({
        Title = "Logo background",
        Desc = "Wrap the logo in a rounded background swatch.",
        Value = false,
        Callback = function(value)
                if value then
                        Window:SetSidebarBrandLogoBackground(Color3.fromRGB(48, 26, 26), 0.1)
                else
                        Window:SetSidebarBrandLogoBackground(nil)
                end
        end,
})

local RailPanel = CustomizeTab:Section({
        Title = "Navigation Rail",
        Desc = "Toggle the divider and the sliding selector.",
        Icon = "panel-left",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

RailPanel:Toggle({
        Title = "Sidebar divider",
        Value = true,
        Callback = function(value)
                Window:SetSidebarDivider(value)
        end,
})

RailPanel:Toggle({
        Title = "Sliding selector",
        Value = true,
        Callback = function(value)
                Window:SetSidebarSelector(value)
        end,
})

-- GetThemes() returns the whole registry (key -> theme table), so collect the
-- keys into a list. Passing the dictionary itself fed tables into the dropdown.
local ThemeNames = {}
for Name in next, NevaUI:GetThemes() do
        table.insert(ThemeNames, Name)
end
table.sort(ThemeNames)

RailPanel:Dropdown({
        Title = "Theme",
        Values = ThemeNames,
        Value = NevaUI:GetCurrentTheme(),
        Callback = function(value)
                NevaUI:SetTheme(value)
        end,
})

-- */  Visuals  /* --
local VisualsPanel = VisualsTab:Section({
        Title = "Visuals",
        Desc = "Rendering and lighting controls.",
        Icon = "eye",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

VisualsPanel:Toggle({
        Title = "Full bright",
        Value = true,
        Callback = function(value)
                print("Full bright:", value)
        end,
})

VisualsPanel:Slider({
        Title = "Field of view",
        Step = 1,
        Value = { Min = 70, Max = 120, Default = 70 },
        Callback = function(value)
                print("Field of view:", value)
        end,
})

-- */  Combat  /* --
local CombatPanel = CombatTab:Section({
        Title = "Combat",
        Desc = "Combat helpers.",
        Icon = "sword",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

CombatPanel:Toggle({
        Title = "Auto parry",
        Value = false,
        Callback = function(value)
                print("Auto parry:", value)
        end,
})

CombatPanel:Button({
        Title = "Reset character",
        Icon = "rotate-ccw",
        Callback = function()
                print("Reset character pressed.")
        end,
})

-- */  Player  /* --
local PlayerPanel = PlayerTab:Section({
        Title = "Player",
        Desc = "Movement and character tweaks.",
        Icon = "user",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

PlayerPanel:Slider({
        Title = "Walk speed",
        Step = 1,
        Value = { Min = 16, Max = 200, Default = 16 },
        Callback = function(value)
                print("Walk speed:", value)
        end,
})

PlayerPanel:Slider({
        Title = "Jump power",
        Step = 1,
        Value = { Min = 50, Max = 300, Default = 50 },
        Callback = function(value)
                print("Jump power:", value)
        end,
})

-- */  Settings  /* --
local SettingsPanel = SettingsTab:Section({
        Title = "Settings",
        Desc = "Persist the example configuration.",
        Icon = "settings",
        Box = true,
        BoxBorder = true,
        Opened = true,
})

SettingsPanel:Input({
        Title = "Config name",
        Desc = "Name used when saving this example's settings.",
})

SettingsPanel:Button({
        Title = "Save configuration",
        Icon = "save",
        Callback = function()
                print("Save configuration pressed.")
        end,
})

-- Make the window surface itself see-through (the config value only
-- reaches 0.15, so push it higher for this example).
Window:SetBackgroundTransparency(0.5)

Window:SelectTab(1)
