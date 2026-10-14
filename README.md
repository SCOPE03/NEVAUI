# NevaUI

NevaUI is a Roblox UI library for script interfaces. This repository contains the source, build files, examples, and generated distribution bundle.

## Quick start

```lua
local NevaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
))()

local Window = NevaUI:CreateWindow({
    Title = "My Script Hub",
})
```

For a complete working example, see [`sidebar_example.lua`](sidebar_example.lua). It demonstrates the background image, script-hub logo, floating open button, sidebar styling, dividers, and runtime controls.

## Complete `CreateWindow` configuration

All window options are supplied to `NevaUI:CreateWindow({ ... })`.

```lua
local Window = NevaUI:CreateWindow({
    -- Identity
    Title = "My Script Hub",
    Author = "by Developer",
    Logo = "rbxassetid://134899357436301",
    -- Icon is the legacy compatibility alias; use Logo instead.
    IconSize = 22,
    IconRadius = 0,
    IconThemed = false,

    -- Window appearance
    Background = "rbxassetid://121343473918667",
    BackgroundImageTransparency = 0.15,
    ShadowTransparency = 0.6,
    Radius = 16,
    Transparent = false,
    Acrylic = false,
    HidePanelBackground = true,

    -- Window size and behavior
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Resizable = true,
    AutoScale = true,
    ToggleKey = Enum.KeyCode.RightControl,

    -- Topbar and content
    Topbar = {
        Height = 52,
        ButtonsType = "Default", -- "Default" or "Mac"
    },
    TopBarButtonIconSize = 16,
    ElementsRadius = 16,
    NewElements = false,
    IgnoreAlerts = false,

    -- Search and scrolling
    HideSearchBar = false,
    ScrollBarEnabled = false,

    -- Optional executor storage folder
    Folder = "MyScriptHub",

    -- Sidebar
    Sidebar = {
        Width = 230,
        Padding = 10,
        Gap = 8,
        Divider = true,
        DividerThickness = 2,
        DividerTransparency = 0.72,
        DividerColor = Color3.fromRGB(80, 170, 255),
    },

    -- Fluent-style floating open/close button
    OpenButton = {
        Floating = true,
        OnlyMobile = false,
        OnlyIcon = true,
        Icon = "rbxassetid://134899357436301",
        Size = 56,
        Position = UDim2.new(1, -44, 1, -82),
        Draggable = true,
        ShowDragHandle = false,
        Scale = 1,
        CornerRadius = UDim.new(1, 0),
        BackgroundColor3 = Color3.fromRGB(18, 18, 22),
        BackgroundTransparency = 0.12,
        Color = ColorSequence.new(
            Color3.fromRGB(80, 201, 255),
            Color3.fromRGB(232, 28, 255)
        ),
        StrokeThickness = 2,
        StrokeColor = Color3.fromRGB(255, 255, 255),
        StrokeTransparency = 0.05,
    },
})
```

### Identity options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Title` | string | `"UI Library"` | Window title. |
| `Author` | string | `nil` | Small author text beside the title. |
| `Logo` | string/number | `nil` | Window logo. Accepts an icon name or Roblox Image asset. |
| `Icon` | string/number | `nil` | Compatibility alias for `Logo`; `Logo` takes priority. |
| `IconSize` | number | `22` | Logo size in pixels. |
| `IconRadius` | number | `0` | Logo corner radius. |
| `IconThemed` | boolean | `false` | Allows icon colors to follow the active theme. |

### Appearance options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Background` | string/number/table | `nil` | Roblox Image asset, HTTP/custom asset, video source, or gradient configuration. |
| `BackgroundImageTransparency` | number | `0` | Background image transparency from `0` to `1`. |
| `BackgroundTransparency` | number | — | Runtime transparency is controlled with `Window:SetBackgroundTransparency()`. |
| `ShadowTransparency` | number | `0.6` | Window shadow transparency. |
| `Radius` | number | `16` | Window corner radius. |
| `Transparent` | boolean | `false` | Uses the library transparency value for the main window surface. |
| `Acrylic` | boolean | `false` | Enables the acrylic effect when supported by the executor. |
| `HidePanelBackground` | boolean | `false` | Hides the opaque content panel so the image can show through. |

Use a Roblox **Image/texture asset ID**, not a Decal-only ID:

```lua
Background = "rbxassetid://121343473918667"
BackgroundImageTransparency = 0.15
HidePanelBackground = true
```

`121343473918667` is a verified anime Image asset used by the example. Asset `11696860078` is a Decal asset and may return a thumbnail while still failing to render in an `ImageLabel`.

### Size and behavior options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Size` | `UDim2` | `UDim2.fromOffset(580, 460)` | Initial window size. |
| `MinSize` | `Vector2` | `Vector2.new(560, 350)` | Minimum resize dimensions. |
| `MaxSize` | `Vector2` | `Vector2.new(850, 560)` | Maximum resize dimensions. |
| `Resizable` | boolean | `true` | Enables window resizing. |
| `AutoScale` | boolean | `true` | Enables automatic UI scaling. |
| `ToggleKey` | `Enum.KeyCode` | library default | Keyboard key used to toggle the window. |
| `Folder` | string | title/temporary folder | Executor storage folder for downloaded assets and configs. |

### Topbar and element options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Topbar.Height` | number | `52` | Topbar height. |
| `Topbar.ButtonsType` | string | `"Default"` | Use `"Default"` or `"Mac"` topbar buttons. |
| `TopBarButtonIconSize` | number | automatic | Size of topbar button icons. |
| `ElementsRadius` | number | automatic | Radius used by content elements. |
| `NewElements` | boolean | `false` | Uses the newer element styling where available. |
| `IgnoreAlerts` | boolean | `false` | Suppresses close/alert dialogs where supported. |
| `HideSearchBar` | boolean | `true` | Hides the sidebar search bar when `true`. |
| `ScrollBarEnabled` | boolean | `false` | Enables the sidebar scroll indicator. |

## Per-element styles

`NewElements` remains the window-wide default. Elements with style-dependent visuals or layout can override that default with `Style = "Modern"` or `Style = "Legacy"`. If `Style` is omitted, the element follows the window's `NewElements` setting. The Modern Toggle is a flat switch with a lavender active track, charcoal inactive track, and round thumb, matching the reference design; use `ToggleColor = Color3.fromRGB(...)` to override its active color. The same style choice is available on buttons and other elements that support the modern layout.

For a runnable test with only the styled controls, see [`style_example.lua`](style_example.lua).

```lua
local Window = NevaUI:CreateWindow({
    Title = "Mixed styles",
    NewElements = false, -- default style for elements without an override
})
local Tab = Window:Tab({ Title = "Controls" })

Tab:Toggle({
    Title = "Modern switch",
    Style = "Modern", -- overrides the window default
    Callback = function(enabled)
        print("Enabled:", enabled)
    end,
})

Tab:Button({
    Title = "Keep this button legacy",
    Style = "Legacy",
    Callback = function() end,
})

Tab:Slider({
    Title = "Modern slider",
    Style = "Modern",
    Value = { Min = 0, Max = 100, Default = 50 },
})
```

`Style` accepts exactly `"Legacy"` or `"Modern"`; any other value raises an error when the element is created. Existing projects keep their current appearance unless they already enable `NewElements` or add an element-level override.

## Sidebar configuration

The preferred sidebar configuration is the nested `Sidebar` table:

```lua
Sidebar = {
    Width = 230,
    Padding = 10,
    Gap = 8,
    Divider = true,
    DividerThickness = 2,
    DividerTransparency = 0.72,
    DividerColor = Color3.fromRGB(80, 170, 255),
}
```

| Option | Type | Default | Description |
|---|---|---:|---|
| `Width` | number | `200` | Sidebar width in pixels. |
| `Padding` | number | automatic | Inner sidebar padding. |
| `Gap` | number | automatic | Vertical gap between sidebar items. |
| `Divider` | boolean | `true` | Shows the vertical divider. |
| `DividerThickness` | number | `1` | Divider width. |
| `DividerTransparency` | number | `0.85` | Divider transparency. |
| `DividerColor` | `Color3` | theme text color | Divider color. |

`SideBarWidth` is retained as a legacy top-level alias for `Sidebar.Width`.

Horizontal separators between entries can be added with:

```lua
Window:Divider({
    Color = Color3.fromRGB(80, 170, 255),
    Thickness = 2,
    Transparency = 0.2,
    Padding = 10,
    Height = 14,
})
```

The vertical divider can be changed at runtime:

```lua
Window:SetSidebarDivider(false)
Window:SetSidebarDivider(true)
```

## Floating open/close button

Set `OpenButton.Floating = true` to use a Fluent-style floating toggle button. It appears after the window is closed and opens the window when clicked.

| Option | Type | Default | Description |
|---|---|---:|---|
| `Floating` | boolean | `false` | Uses a circular floating layout. |
| `Enabled` | boolean | `true` | Enables or disables the open button. |
| `OnlyMobile` | boolean | `true` | Restricts the button to mobile-style input unless set to `false`. |
| `OnlyIcon` | boolean | floating-dependent | Hides the title and shows only the logo/icon. |
| `Icon` | string/number | window logo | Button-specific icon or Roblox Image asset. |
| `Title` | string | window title | Text shown in non-icon-only mode. |
| `Size` | number/`Vector2`/`UDim2` | `54` in floating mode | Button size. A number creates a square button. |
| `Position` | `UDim2` | bottom-right in floating mode | Screen-space position. |
| `Draggable` | boolean | `true` | Allows the user to drag the button. |
| `ShowDragHandle` | boolean | `false` | Shows the drag glyph in floating mode. |
| `Scale` | number | `1` | Button scale. |
| `CornerRadius` | `UDim` | `UDim.new(1, 0)` | Button corner radius. |
| `BackgroundColor3` | `Color3` | black | Button background color. |
| `BackgroundTransparency` | number | `0.25` | Button background transparency. |
| `Color` | `ColorSequence`/`Color3` | cyan-magenta gradient | Border gradient color. |
| `StrokeThickness` | number | `2` | Border thickness. |
| `StrokeColor` | `Color3` | white | Border color when supplied. |
| `StrokeTransparency` | number | `0` | Border transparency. |

Example:

```lua
OpenButton = {
    Floating = true,
    OnlyMobile = false,
    OnlyIcon = true,
    Icon = "rbxassetid://134899357436301",
    Size = 56,
    Position = UDim2.new(1, -44, 1, -82),
    Draggable = true,
}
```

If `OpenButton.Icon` is omitted, the button inherits the window `Logo`.

## Runtime window API

Common runtime methods include:

```lua
Window:Open()
Window:Close()
Window:Toggle()
Window:Destroy()
Window:SetTitle("New title")
Window:SetAuthor("New author")
Window:SetSize(UDim2.fromOffset(640, 480))
Window:SetIconSize(28)
Window:SetBackgroundImage("rbxassetid://121343473918667")
Window:SetBackgroundImageTransparency(0.2)
Window:SetBackgroundTransparency(0.15)
Window:SetPanelBackground(false)
Window:SetSidebarDivider(true)
Window:EditOpenButton({ Floating = true, OnlyMobile = false, Size = 56 })
Window:SetToggleKey(Enum.KeyCode.RightControl)
Window:ToggleFullscreen()
Window:SetUIScale(1)
Window:SetToTheCenter()
```

Window callbacks are available with:

```lua
Window:OnOpen(function() end)
Window:OnClose(function() end)
Window:OnDestroy(function() end)
```

## Example

The complete example is available here:

- [`sidebar_example.lua`](sidebar_example.lua)
- [Latest executor example](https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/sidebar_example.lua)

It includes:

- Background image: `rbxassetid://121343473918667`
- Script-hub logo: `rbxassetid://134899357436301`
- Floating open/close button
- Per-element Legacy/Modern style overrides, including the modern pill toggle
- Draggable positioning
- Sidebar width, padding, gap, and divider configuration
- Runtime divider control

## Project

Maintained by **NEVA**. Report issues and follow development in [SCOPE03/NEVAUI](https://github.com/SCOPE03/NEVAUI).

## Third-party acknowledgements

The bundled icon module supports icon sets including [Lucide](https://github.com/lucide-icons/lucide), [Solar](https://icones.js.org/collection/solar), [Craft Icons](https://www.figma.com/community/file/1415718327120418204), [Geist](https://vercel.com/geist/icons), and [SF Symbols](https://sf-symbols-one.vercel.app/). Their respective names and notices remain their own.

## License

See [`LICENSE`](LICENSE). Required upstream copyright and permission notices are retained there.
