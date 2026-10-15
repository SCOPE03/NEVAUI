--[[
        NevaUI — NevaGlass style example

        A glassmorphic, gradient-accented interface built entirely with NevaUI.
        It uses the built-in "NevaGlass" theme, a right-side icon rail and every
        standard element: buttons, toggles, sections, dividers, sliders, colour
        pickers, inputs, dropdowns, keybinds, labels and paragraphs. The Theme
        and Config tabs are fully working, so this doubles as a usable base.

        Press the toggle key to show or hide the interface.
]]

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

-- The gradient accent used across the interface.
local Accent = NevaUI:Gradient({
        ["0"] = { Color = Color3.fromRGB(117, 164, 206), Transparency = 0 },
        ["50"] = { Color = Color3.fromRGB(123, 201, 201), Transparency = 0 },
        ["100"] = { Color = Color3.fromRGB(224, 138, 175), Transparency = 0 },
}, { Rotation = 45 })

local Window = NevaUI:CreateWindow({
        Title = "NevaUI Example Window",
        Author = "A Gray Subtitle",
        Theme = "NevaGlass",
        Logo = "rbxassetid://82795327169782",
        IconSize = 24,
        Folder = "NevaGlassStyle",

        Size = UDim2.fromOffset(660, 480),
        MinSize = Vector2.new(560, 360),

        -- A key system, exactly like the original window offered.
        KeySystem = {
                Title = "NevaUI Example Key",
                Note = "Use a HWID key service in a real script. The demo key is 1234.",
                SaveKey = true,
                Key = { "1234" },
                -- URL = "https://example.com/key", -- set this to show a "Get key" button
        },

        -- Left rail with a brand block, matching the reference layout.
        Sidebar = {
                Position = "Left",
                Type = "Default",
                Width = 210,
                Padding = 10,
                Gap = 8,
                Divider = true,
                DividerColor = Color3.fromRGB(117, 164, 206),
                Brand = {
                        Layout = "Horizontal",
                        Title = "NevaUI",
                        TitleSize = 19,
                        Height = 56,
                },
                TabHeight = 34,
                TabRadius = 10,
                IconSize = 20,
        },

        Topbar = {
                Height = 50,
                ButtonsType = "Mac",
        },

        ThemeColors = {
                SidebarBackground = Color3.fromRGB(22, 21, 26),
                SidebarBackgroundTransparency = 0.25,
                SidebarSelector = Accent,
        },
})

Window:Tag({
        Title = "NevaGlass Style",
        Icon = "solar:star-bold",
        Color = Color3.fromRGB(117, 164, 206),
        Border = true,
})

NevaUI:Notify({
        Title = "NevaUI Example Window",
        Content = "A sleek glassmorphic interface with dynamic elements and a gradient accent.",
        Icon = "solar:bell-bold",
        Duration = 6,
})

-- */  Main tab  /* --
local Tab = Window:Tab({
        Title = "Tab Example",
        Icon = "solar:widget-bold",
        ShowTabTitle = true,
})

Tab:Button({
        Title = "Button Example!",
        Icon = "solar:cursor-bold",
        Justify = "Center",
        IconAlign = "Left",
        Callback = function()
                NevaUI:Notify({
                        Title = "Button Example",
                        Content = "Button Example Pressed!",
                        Icon = "solar:cursor-bold",
                        Duration = 4,
                })
        end,
})

Tab:Toggle({
        Title = "Toggle Example",
        Value = false,
        Callback = function(Value)
                print("Toggle state is:", Value)
        end,
})

Tab:Section({
        Title = "This Is a section, below is a divider",
})

Tab:Divider()

Tab:Slider({
        Title = "Slider Example",
        Value = { Min = 0, Max = 200, Default = 100 },
        Step = 5,
        Callback = function(Value)
                print("Slider value is:", Value)
        end,
})

Tab:Colorpicker({
        Title = "Color Picker Example",
        Default = Color3.fromRGB(86, 171, 128),
        Flag = "ColorPicker1",
        Callback = function(Value)
                print("Selected Color RGB:", Value.R * 255, Value.G * 255, Value.B * 255)
        end,
})

Tab:Input({
        Title = "Dynamic Input Example",
        Placeholder = "Input Placeholder",
        Value = "",
        Callback = function(Text)
                print("Input box text:", Text)
        end,
})

Tab:Dropdown({
        Title = "Dropdown Example",
        Values = {
                "Option 1", "Option 2", "Option 3", "Option 4", "Option 5",
                "Option 6", "Option 7", "Option 8", "Option 9", "Option 10",
                "Option 11", "Option 12", "Option 13", "Option 14", "Option 15",
                "Option 16", "Option 17", "Option 18", "Option 19", "Option 20",
                "Option 21", "Option 22", "Option 23", "Option 24", "Option 25",
        },
        Value = "Option 1",
        SearchBarEnabled = true,
        Callback = function(Value)
                print("Dropdown selected:", Value)
        end,
})

Tab:Keybind({
        Title = "Bind Example",
        Value = "Q",
        Callback = function(BindState)
                print("Keybind activated. State:", BindState)
        end,
})

Tab:Space()

Tab:Paragraph({
        Title = "This is a Default Label",
})

Tab:Paragraph({
        Title = "This is an Information Label",
        Desc = "Informational notes sit on the element background, like the original label style.",
})

Tab:Paragraph({
        Title = "This is a Warning Label",
        Desc = "Warnings use the same surface with a stronger description colour.",
})

Tab:Paragraph({
        Title = "Paragraph Example",
        Desc = "This Is A Paragraph. You Can Type Very Long Strings Here And They'll Automatically Fit! "
                .. "This Counts As A Description Right? Right? Right? Right? Right? Right? Right? Right? "
                .. "Right? Right? Right? Right? Right? Right? Also Did I Mention This Has Rich Text? "
                .. "Also Did I Mention This Has Rich Text? Also Did I Mention This Has Rich Text?",
})

-- */  Theme tab  /* --
local ThemeTab = Window:Tab({
        Title = "Theme Tab",
        Icon = "solar:palette-bold",
        ShowTabTitle = true,
})

local ThemeNames = {}
for Name in next, NevaUI:GetThemes() do
        table.insert(ThemeNames, Name)
end
table.sort(ThemeNames)

ThemeTab:Paragraph({
        Title = "Interface Theme",
        Desc = "Every theme restyles the window, rail, elements and notifications instantly.",
})

ThemeTab:Dropdown({
        Title = "Select Theme",
        Values = ThemeNames,
        Value = NevaUI:GetCurrentTheme(),
        SearchBarEnabled = true,
        Callback = function(Value)
                NevaUI:SetTheme(Value)
                NevaUI:Notify({
                        Title = "Theme Changed",
                        Content = "The interface is now using the " .. Value .. " theme.",
                        Icon = "solar:palette-bold",
                        Duration = 3,
                })
        end,
})

ThemeTab:Space()

ThemeTab:Dropdown({
        Title = "Rail Position",
        Values = { "Left", "Right", "Top" },
        Value = "Right",
        Callback = function(Value)
                Window:SetSidebarPosition(Value)
        end,
})

ThemeTab:Dropdown({
        Title = "Rail Type",
        Values = { "Default", "Icon", "Compact", "Segmented" },
        Value = "Default",
        Callback = function(Value)
                Window:SetSidebarType(Value)
        end,
})

ThemeTab:Space()

ThemeTab:Button({
        Title = "Toggle Rail Divider",
        Icon = "solar:align-vertical-center-bold",
        Justify = "Center",
        IconAlign = "Left",
        Callback = function()
                Window:SetSidebarDivider(not Window.SidebarDivider)
        end,
})

-- */  Config tab  /* --
local ConfigTab = Window:Tab({
        Title = "Config Tab",
        Icon = "solar:settings-bold",
        ShowTabTitle = true,
})

local ConfigManager = Window.ConfigManager

if ConfigManager then
        local ConfigName = "default"

        local ConfigNameInput = ConfigTab:Input({
                Title = "Config Name",
                Placeholder = "default",
                Value = ConfigName,
                Callback = function(Value)
                        ConfigName = Value
                end,
        })

        ConfigTab:Space()

        local AllConfigsDropdown
        AllConfigsDropdown = ConfigTab:Dropdown({
                Title = "Saved Configs",
                Values = ConfigManager:AllConfigs(),
                Callback = function(Value)
                        ConfigName = Value
                        ConfigNameInput:Set(Value)
                end,
        })

        ConfigTab:Space()

        ConfigTab:Button({
                Title = "Save Config",
                Icon = "solar:diskette-bold",
                Justify = "Center",
                IconAlign = "Left",
                Callback = function()
                        Window.CurrentConfig = ConfigManager:Config(ConfigName)
                        if Window.CurrentConfig:Save() then
                                NevaUI:Notify({
                                        Title = "Config Saved",
                                        Content = "Config '" .. ConfigName .. "' saved.",
                                        Icon = "solar:diskette-bold",
                                        Duration = 3,
                                })
                        end
                        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
                end,
        })

        ConfigTab:Space()

        ConfigTab:Button({
                Title = "Load Config",
                Icon = "solar:refresh-bold",
                Justify = "Center",
                IconAlign = "Left",
                Callback = function()
                        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                        if Window.CurrentConfig:Load() then
                                NevaUI:Notify({
                                        Title = "Config Loaded",
                                        Content = "Config '" .. ConfigName .. "' loaded.",
                                        Icon = "solar:refresh-bold",
                                        Duration = 3,
                                })
                        end
                end,
        })

        ConfigTab:Space()

        ConfigTab:Button({
                Title = "Delete Config",
                Color = Color3.fromRGB(255, 72, 48),
                Icon = "solar:trash-bin-trash-bold",
                Justify = "Center",
                IconAlign = "Left",
                Callback = function()
                        Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
                        Window.CurrentConfig:Delete()
                        AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
                        NevaUI:Notify({
                                Title = "Config Deleted",
                                Content = "Config '" .. ConfigName .. "' deleted.",
                                Icon = "solar:trash-bin-trash-bold",
                                Duration = 3,
                        })
                end,
        })
else
        ConfigTab:Paragraph({
                Title = "Configs Unavailable",
                Desc = "The config system needs an executor folder. Set Folder on the window and run outside Studio.",
        })
end
