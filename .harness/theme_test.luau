-- Exercises the theme system and runtime APIs against the built bundle.
-- Run with: python3 .harness/run_harness.py .harness/theme_test.luau

local LibraryUrl = "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"

-- Works in both harness modes: source mode resolves src/Init, bundle mode
-- falls back to fetching the built bundle.
local NevaUI
local loadedFromSource = pcall(function()
        NevaUI = require("../src/Init")
end)
if not loadedFromSource then
        NevaUI = loadstring(game:HttpGet(LibraryUrl))()
end
print("library source: " .. (loadedFromSource and "src/Init" or "dist bundle"))

local failures = {}
local checks = 0

local function check(condition, message)
        checks += 1
        if not condition then
                table.insert(failures, message)
                print("FAIL: " .. message)
        end
end

-- 1. Every registered theme can be applied without error.
local themes = NevaUI:GetThemes()
local themeCount = 0
for key, theme in next, themes do
        themeCount += 1
        local ok, err = pcall(function()
                NevaUI:SetTheme(key)
        end)
        check(ok, "SetTheme(" .. tostring(key) .. ") errored: " .. tostring(err))
        check(NevaUI:GetCurrentTheme() == key, "GetCurrentTheme() did not return " .. tostring(key))
end
print("themes exercised: " .. themeCount)
check(themeCount >= 17, "expected at least 17 themes, found " .. themeCount)
check(themes["Luna"] ~= nil, "Luna theme is not registered")

-- Display names with spaces must resolve to the same theme as the registry key.
for key, theme in next, themes do
        if theme.Name ~= key then
                check(
                        pcall(function() NevaUI:SetTheme(theme.Name) end),
                        "SetTheme by display name failed for " .. tostring(theme.Name)
                )
                check(
                        NevaUI:GetCurrentTheme() == key,
                        "GetCurrentTheme() after display name set returned "
                                .. tostring(NevaUI:GetCurrentTheme())
                                .. ", expected "
                                .. tostring(key)
                )
        end
end

-- An unknown theme must fail loudly rather than silently doing nothing.
check(
        not pcall(function() NevaUI:SetTheme("NoSuchTheme") end),
        "SetTheme accepted an unknown theme name"
)
check(
        NevaUI:GetThemes()[NevaUI:GetCurrentTheme()] ~= nil,
        "GetThemes()[GetCurrentTheme()] must resolve to a theme"
)

-- Mirrors the theme dropdown in examples/luna_example.lua: values come from
-- GetThemes() and GetCurrentTheme() must be one of them.
do
        local names = {}
        for name in next, NevaUI:GetThemes() do
                table.insert(names, name)
        end
        check(
                table.find(names, NevaUI:GetCurrentTheme()) ~= nil,
                "GetCurrentTheme() is not one of the GetThemes() keys"
        )
        for _, name in ipairs(names) do
                check(pcall(function() NevaUI:SetTheme(name) end), "dropdown value failed: " .. name)
        end
end

-- OnThemeChange must report the applied theme and it must be a GetThemes() key.
do
        local seen
        NevaUI:OnThemeChange(function(name) seen = name end)
        NevaUI:SetTheme("Midnight")
        check(seen ~= nil, "OnThemeChange callback did not fire")
        check(
                NevaUI:GetThemes()[seen] ~= nil,
                "OnThemeChange received " .. tostring(seen) .. " which is not a GetThemes() key"
        )
        NevaUI:OnThemeChange(nil)
end

-- 2. Theme switching must actually repaint a live window.
NevaUI:SetTheme("Luna")
local Window = NevaUI:CreateWindow({
        Title = "Theme Test",
        Author = "test",
        Size = UDim2.fromOffset(600, 440),
        Theme = "Luna",
        Folder = "NevaUIThemeTest",
        Resizable = true,
})

local function colorKey(c)
        return string.format("%.6f/%.6f/%.6f", c.R, c.G, c.B)
end

local Surface = Window.UIElements.Main.Background
check(Surface ~= nil, "window background surface not found")
local beforeColor = Surface.ImageColor3
NevaUI:SetTheme("Midnight")
local afterColor = Surface.ImageColor3
check(
        colorKey(beforeColor) ~= colorKey(afterColor),
        "window background did not change when the theme changed"
)
NevaUI:SetTheme("Luna")

-- 3. Every element type the example uses must construct.
local Tab = Window:Tab({ Title = "Elements", Icon = "lucide:box" })
local built = {}
local elementSpecs = {
        { "Button", { Title = "Button", Callback = function() end } },
        { "Toggle", { Title = "Toggle", Value = true, Callback = function() end } },
        { "Slider", { Title = "Slider", Value = { Min = 0, Max = 100, Default = 25 }, Callback = function() end } },
        { "Input", { Title = "Input", Value = "text", Callback = function() end } },
        { "Dropdown", { Title = "Dropdown", Values = { "A", "B" }, Value = "A", Callback = function() end } },
        { "Keybind", { Title = "Keybind", Value = "Q", Callback = function() end } },
        { "Paragraph", { Title = "Paragraph", Desc = "Body" } },
        { "Section", { Title = "Section" } },
        { "Divider", {} },
        { "Space", {} },
        { "ProgressBar", { Title = "Bar", Value = { Min = 0, Max = 100, Default = 10 } } },
        { "Colorpicker", { Title = "Color" } },
}
for _, spec in ipairs(elementSpecs) do
        local ok, err = pcall(function()
                built[spec[1]] = Tab[spec[1]](Tab, spec[2])
        end)
        check(ok, "element " .. spec[1] .. " failed: " .. tostring(err))
end

-- 4. Runtime sidebar and tag APIs.
check(pcall(function() Window:SetSidebarPosition("Top") end), "SetSidebarPosition(Top) failed")
check(pcall(function() Window:SetSidebarPosition("Right") end), "SetSidebarPosition(Right) failed")
check(pcall(function() Window:SetSidebarType("Icon") end), "SetSidebarType(Icon) failed")
check(pcall(function() Window:SetSidebarType("Default") end), "SetSidebarType(Default) failed")
check(pcall(function() Window:SetSidebarDivider(false) end), "SetSidebarDivider failed")
check(pcall(function() Window:Tag({ Title = "Tag", Icon = "lucide:star" }) end), "Window:Tag failed")
check(pcall(function()
        NevaUI:Notify({ Title = "N", Content = "C", Icon = "lucide:bell", Duration = 1 })
end), "Notify failed")

-- 5. Gradient used by the example must build a real instance.
check(pcall(function()
        local gradient = NevaUI:Gradient({
                ["0"] = { Color = Color3.fromHex("#75a4ce"), Transparency = 0 },
                ["50"] = { Color = Color3.fromHex("#7bc9c9"), Transparency = 0 },
                ["100"] = { Color = Color3.fromHex("#e08aaf"), Transparency = 0 },
        }, { Rotation = 45 })
        check(gradient ~= nil, "Gradient returned nil")
end), "Gradient failed")

-- 6. Config manager exists and can round-trip a value.
local config = Window.ConfigManager:Config("ThemeTest", false)
check(config ~= nil, "ConfigManager:Config returned nil")
check(pcall(function()
        config:Register("ThemeTestFlag", { Value = 1 })
        config:Set("ThemeTestFlag", 42)
        config:Save()
        config:Load()
end), "config save/load failed")

print("")
print("checks: " .. checks .. ", failures: " .. #failures)
if #failures > 0 then
        error("theme_test failed with " .. #failures .. " failure(s)")
end
print("THEME TEST PASSED")
