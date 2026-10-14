# NevaUI

NevaUI is a Roblox UI library for script interfaces. This repository contains the source, build files, examples, and generated distribution bundle.

## Quick start

```lua
local NevaUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"
))()

local Window = NevaUI:CreateWindow({
    Title = "NevaUI",
})
```

For a complete working example, see [`sidebar_example.lua`](sidebar_example.lua). It demonstrates the background image, script-hub logo, floating open button, sidebar styling, dividers, and runtime controls. For the opt-in two-column Dashboard layout, see [`dashboard_example.lua`](dashboard_example.lua).

For an animated background, large left-side brand logo, floating open button, and a sidebar with search plus live color/logo controls, see [`anime_background_example.lua`](anime_background_example.lua).

## Complete `CreateWindow` configuration

All window options are supplied to `NevaUI:CreateWindow({ ... })`.

```lua
local Window = NevaUI:CreateWindow({
    -- Identity
    Title = "NevaUI",
    Author = "by Developer",
    Layout = "Standard", -- "Standard" or "Dashboard"
    Logo = "rbxassetid://134899357436301",
    -- Logo appears in the top bar/open button. Icon is its legacy alias.
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
        Brand = {
            Logo = "rbxassetid://134899357436301", -- Roblox image asset ID
            Title = "NevaUI",
            LogoSize = 24,
            Height = 56,
        },
        Divider = true,
        DividerThickness = 2,
        DividerTransparency = 0.72,
        DividerColor = Color3.fromRGB(80, 170, 255),
    },

    -- Floating open/close button
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
| `Logo` | string/number | `nil` | Icon or image in the top bar and floating open button. Use `Sidebar.Brand.Logo` for the navigation rail. |
| `Icon` | string/number | `nil` | Compatibility alias for `Logo`; `Logo` takes priority. `Logo` remains in the top bar/open button. |
| `IconSize` | number | `22` | Logo size in pixels. |
| `IconRadius` | number | `0` | Logo corner radius. |
| `IconThemed` | boolean | `false` | Allows icon colors to follow the active theme. |

### Appearance options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Background` | string/number/table | `nil` | Roblox Image asset, HTTP/custom asset, video source, or gradient configuration. |
| `BackgroundAnimation` | table | `nil` | Plays a sprite sheet on an image background using `FrameSize` (`Vector2`), `FrameCount`, `Columns`, and `FPS`. Raw GIF files do not animate in Roblox `ImageLabel`s. |
| `BackgroundImageTransparency` | number | `0` | Background image transparency from `0` to `1`. |
| `BackgroundTransparency` | number | — | Runtime transparency is controlled with `Window:SetBackgroundTransparency()`. |
| `Theme` | string | `"Dark"` | Built-in or registered theme name. `NewElements` and per-element `Style` choose the control design independently. |
| `ThemeColors` | table | `nil` | Partial theme-token overrides. Unspecified tokens continue using the selected theme. |
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

`121343473918667` is a verified Roblox Image asset. Asset `11696860078` is a Decal asset and may return a thumbnail while still failing to render in an `ImageLabel`.

For a static image background, point `Background` at an Image asset ID:

```lua
Background = "rbxassetid://117316815074414",
BackgroundImageTransparency = 0.15,
```

The example uses asset `117316815074414` with a red-tinted theme (`ThemeColors` override the dark defaults).

### Theme color overrides

Keep the named theme and override only the colors you want. Values can be `Color3` values or `"#RRGGBB"` strings; transparency tokens use numbers from `0` to `1`.

```lua
Theme = "Dark",
ThemeColors = {
    Background = Color3.fromRGB(16, 16, 16),
    PanelBackground = Color3.fromRGB(22, 22, 24), -- main tab/page surface
    PanelBackgroundTransparency = 0.08,
    SidebarBackground = Color3.fromRGB(14, 14, 16),
    SidebarBackgroundTransparency = 0,
    TabBackground = Color3.fromRGB(28, 28, 31),
    TabBackgroundHoverTransparency = 0.25,
    TabBackgroundActive = Color3.fromRGB(42, 40, 48),
    TabBackgroundActiveTransparency = 0.1,
    ElementBackground = Color3.fromRGB(31, 31, 34),
    Toggle = Color3.fromRGB(165, 153, 212),
    ToggleBar = Color3.fromRGB(67, 67, 72),
    Text = Color3.fromRGB(245, 245, 247),
}
```

`ThemeColors` is merged onto a copy of the selected theme, so built-in theme tables are not modified. If `SidebarBackground` is set without `SidebarBackgroundTransparency`, the sidebar becomes opaque; set a transparency explicitly when you want a different value. Theme overrides also stay applied when calling `NevaUI:SetTheme()`.

Common tokens include `Background`, `PanelBackground`, `PanelBackgroundTransparency`, `SidebarBackground`, `SidebarSelector`, `TabBackground`, `TabBackgroundActive`, `TabBackgroundActiveTransparency`, `ElementBackground`, `ElementTitle`, `Text`, `Icon`, `Button`, `Toggle`, `ToggleBar`, `Slider`, and `Checkbox`. Other theme/fallback tokens can also be overridden for outlines, placeholders, hover states, and control descriptions.

### Size and behavior options

| Option | Type | Default | Description |
|---|---|---:|---|
| `Size` | `UDim2` | Standard: `580×460`; Dashboard: `820×460` | Initial window size. |
| `MinSize` | `Vector2` | Standard: `560×350`; Dashboard: `680×360` | Minimum resize dimensions. |
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
| `Layout` | string | `"Standard"` | Use `"Dashboard"` for two-column tab content; existing layout remains the default. |
| `ElementsRadius` | number | automatic | Radius used by content elements. |
| `NewElements` | boolean | layout-dependent | Uses newer element styling where available. Defaults to `true` in Dashboard mode and `false` in Standard mode. An explicit value overrides the default. |
| `IgnoreAlerts` | boolean | `false` | Suppresses close/alert dialogs where supported. |
| `HideSearchBar` | boolean | `true` | Hides the sidebar search bar when `true`. |
| `ScrollBarEnabled` | boolean | `false` | Enables the sidebar scroll indicator. |

## Per-element styles

`NewElements` remains the window-wide default. Elements with style-dependent visuals or layout can override that default with `Style = "Modern"` or `Style = "Legacy"`. If `Style` is omitted, the element follows the window's `NewElements` setting. The Modern Toggle has a flat, square-cornered rectangular track and a rectangular thumb that slides side to side; it has no ON/OFF text. `ToggleColor = Color3.fromRGB(...)` customizes the active track. The same style choice is available on buttons and other elements that support the modern layout.

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

## Dashboard layout

Set `Layout = "Dashboard"` to keep the existing sidebar navigation while distributing top-level tab controls into two auto-height columns. Nested controls stay inside their parent group. The Dashboard layout defaults to modern element styling unless `NewElements` is explicitly set. `Layout = "Standard"` preserves the current single-column layout.

For a full-width row above the columns, set `Placement = "Header"` on a top-level group. This is intended for category controls; see the runnable example for buttons that show and hide the matching settings cards.

The optional `Sidebar.Brand` header works with either layout, placing the brand above the navigation rail. The main Dashboard content uses a full-width header row followed by the two-column area to the right. The focused example uses `NewElements = false`, so its controls retain the original Legacy look.

See [`dashboard_example.lua`](dashboard_example.lua) for a runnable configuration.

## Sidebar configuration

The preferred sidebar configuration is the nested `Sidebar` table:

```lua
Sidebar = {
    Width = 230,
    Padding = 10,
    Gap = 8,
    Brand = {
        Layout = "Stacked", -- "Horizontal" (default) or "Stacked"
        Logo = "rbxassetid://134899357436301", -- Roblox image asset ID
        Title = "NevaUI",
        LogoSize = 54,
        LogoScaleType = "Fit",
        LogoPadding = 0,
        LogoBackground = nil, -- optional Color3 swatch behind the logo
        LogoBackgroundTransparency = 0,
        TitleSize = 24,
        Height = 140,
    },
    Colors = {
        SidebarBackground = Color3.fromRGB(24, 14, 14),
        SidebarBackgroundTransparency = 0.08,
        SidebarSelector = Color3.fromRGB(220, 60, 60),
        TabBackgroundActive = Color3.fromRGB(120, 40, 40),
    },
    Divider = true,
    DividerThickness = 2,
    DividerTransparency = 0.72,
    DividerColor = Color3.fromRGB(80, 170, 255),
    Selector = true,
    SelectorWidth = 4,
    SelectorColor = Color3.fromRGB(80, 170, 255),
    TabHeight = 34,
    TabRadius = 10,
    IconSize = 17,
    ScrollBarThickness = 4,
    ScrollBarTransparency = 0.6,
    ScrollBarColor = Color3.fromRGB(80, 170, 255),
}
```

| Option | Type | Default | Description |
|---|---|---:|---|
| `Width` | number | Standard: `200`; Dashboard: `190` | Sidebar width in pixels. |
| `Colors` | table | `nil` | Sidebar-scoped theme-token overrides (for example `SidebarBackground`, `SidebarSelector`, `TabBackgroundActive`). Merged onto the active theme so `ThemeColors` are preserved. |
| `Padding` | number | automatic | Inner sidebar padding. |
| `Gap` | number | automatic | Vertical gap between sidebar items. |
| `Brand.Layout` | string | `"Horizontal"` | `"Stacked"` centers the logo above the title; `"Horizontal"` keeps them side by side. |
| `Brand.Logo` | string/number | `nil` | Icon or image displayed in the sidebar brand header. |
| `Brand.Title` | string | `nil` | Wordmark displayed beside or below the sidebar logo, depending on `Brand.Layout`. |
| `Brand.LogoSize` | number | Horizontal: `24`; Stacked: `36` | Sidebar brand logo size in pixels. The rendered size is clamped to fit the header and sidebar width. |
| `Brand.LogoScaleType` | string | `"Fit"` | `"Fit"` contains the whole image in its bounds; `"Crop"` fills the bounds and may trim its edges. |
| `Brand.LogoPadding` | number | `0` | Inset between the logo image and its bounds. Also used by `Brand.LogoBackground`. |
| `Brand.LogoBackground` | `Color3` | `nil` | Optional background swatch behind the brand logo. When unset, the logo is drawn with no background. |
| `Brand.LogoBackgroundTransparency` | number | `0` | Transparency of `Brand.LogoBackground`. |
| `Brand.Height` | number | Horizontal: `56`; Stacked: `96` | Height reserved above sidebar search and tabs (clamped to at least `40`). |
| `Brand.LogoRadius` | number | `0` | Corner radius of the brand image. |
| `Brand.LogoThemed` | boolean | `false` | Applies theme coloring to the logo where supported. |
| `Brand.TitleSize` | number | `16` | Brand title font size. |
| `Divider` | boolean | `true` | Shows the vertical divider. |
| `DividerThickness` | number | `1` | Divider width. |
| `DividerTransparency` | number | `0.85` | Divider transparency. |
| `DividerColor` | `Color3` | theme text color | Divider color. |
| `Selector` | boolean | `true` | Shows the sliding accent bar that tracks the selected tab. |
| `SelectorWidth` | number | `3` | Sliding selector width in pixels. |
| `SelectorRadius` | number | `999` | Sliding selector corner radius. `999` makes it fully rounded. |
| `SelectorColor` | `Color3` | theme accent | Sliding selector color. Defaults to the `SidebarSelector` theme token. |
| `TabHeight` | number | automatic | Fixed sidebar tab height in pixels. When omitted, tabs size to their content. |
| `TabRadius` | number | window radius | Corner radius of sidebar tabs. |
| `IconSize` | number | `16` | Sidebar tab icon size in pixels. |
| `ScrollBarThickness` | number | `0` | Sidebar scrollbar width. `0` hides the scrollbar. |
| `ScrollBarTransparency` | number | `0.5` | Sidebar scrollbar transparency. |
| `ScrollBarColor` | `Color3` | theme default | Sidebar scrollbar color. |

The sliding selector can also be recolored or toggled at runtime:

```lua
Window:SetSidebarSelector(false)
Window:SetSidebarSelector(true)
Window:SetSidebarSelectorColor(Color3.fromRGB(80, 170, 255))
```

The brand logo and sidebar colors can also be changed at runtime:

```lua
Window:SetSidebarBrandLogoSize(72)
Window:SetSidebarBrandLogoBackground(Color3.fromRGB(24, 14, 14), 0.1)
Window:SetSidebarBrandLogoBackground(nil) -- remove the background swatch
Window:SetSidebarColor("SidebarBackground", Color3.fromRGB(24, 14, 14))
Window:SetSidebarColor("TabBackgroundActive", Color3.fromRGB(120, 40, 40), 0.12)
```

The sliding selector color follows the `SidebarSelector` theme token, which defaults to the theme accent and can be overridden through `ThemeColors`:

```lua
ThemeColors = {
    SidebarSelector = Color3.fromRGB(80, 170, 255),
}
```

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

Set `OpenButton.Floating = true` to show a circular floating open/close button. It appears after the window is closed and opens the window when clicked.

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

The runnable examples are available here:

- [`sidebar_example.lua`](sidebar_example.lua)
- [`anime_background_example.lua`](anime_background_example.lua)
- [Latest executor example](https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/sidebar_example.lua)

The sidebar example includes:

- Background image: `rbxassetid://121343473918667`
- Script-hub logo: `rbxassetid://134899357436301`
- Floating open/close button
- Per-element Legacy/Modern style overrides, including the modern pill toggle
- Draggable positioning
- Sidebar width, padding, gap, and divider configuration
- Runtime divider control

The animated-background example includes:

- Static background image: `rbxassetid://117316815074414`
- Red theme override (`ThemeColors`)
- Large left sidebar logo: `rbxassetid://76738354597155`
- Floating open button using the same logo
- Legacy control styling by default

## Project

Maintained by **NEVA**. Report issues and follow development in [SCOPE03/NEVAUI](https://github.com/SCOPE03/NEVAUI).

## Third-party acknowledgements

The bundled icon module supports icon sets including [Lucide](https://github.com/lucide-icons/lucide), [Solar](https://icones.js.org/collection/solar), [Craft Icons](https://www.figma.com/community/file/1415718327120418204), [Geist](https://vercel.com/geist/icons), and [SF Symbols](https://sf-symbols-one.vercel.app/). Their respective names and notices remain their own.

## License

See [`LICENSE`](LICENSE). Required upstream copyright and permission notices are retained there.
