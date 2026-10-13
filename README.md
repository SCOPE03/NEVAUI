# NevaUI

NevaUI is a Roblox UI library for script interfaces. This repository contains its source, build files, examples, and distribution bundle.

## Quick start

```lua
local NevaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua"))()
local Window = NevaUI:CreateWindow({ Title = "NevaUI" })
```

See [`main_example.lua`](main_example.lua) for a fuller example.
See [`sidebar_example.lua`](sidebar_example.lua) for a complete sidebar configuration showcase using Roblox background asset `11696860078`.

## Sidebar configuration

Developers can customize the sidebar directly in `CreateWindow`:

```lua
local Window = NevaUI:CreateWindow({
    Title = "NevaUI",
    Sidebar = {
        Width = 220,
        Padding = 10,
        Gap = 6,
        Divider = true,
        DividerThickness = 1,
        DividerTransparency = 0.8,
    DividerColor = Color3.fromRGB(80, 80, 90), -- optional; follows the theme when omitted
    },
})
```

The divider can also be toggled after creation with `Window:SetSidebarDivider(false)`.
The existing `Window:Divider()` method adds horizontal separators between sidebar items.
It accepts optional styling such as `Color`, `Thickness`, `Transparency`, `Padding`, and `Height`:

```lua
Window:Divider({
    Color = Color3.fromRGB(80, 170, 255),
    Thickness = 2,
    Transparency = 0.2,
    Padding = 10,
    Height = 14,
})
```

Backgrounds use Roblox **Image** asset IDs, for example:

```lua
Background = "rbxassetid://121343473918667"
BackgroundImageTransparency = 0.15
```

Use the Image/texture ID rather than a Decal-only asset ID. The sidebar showcase uses `121343473918667`, a verified anime Image asset. Asset `11696860078` is a Decal asset and may return a thumbnail while still failing to render in an `ImageLabel`.

Developers can set a custom script-hub logo with `Logo`. It accepts an icon name or a Roblox Image asset ID. `Icon` remains supported as a compatibility alias, and `Logo` takes priority when both are supplied:

```lua
local Window = NevaUI:CreateWindow({
    Title = "My Script Hub",
    Logo = "rbxassetid://134899357436301",
})
```

## Project

Maintained by **NEVA**. Report issues and follow development in [SCOPE03/NEVAUI](https://github.com/SCOPE03/NEVAUI).

## Third-party acknowledgements

The bundled icon module supports icon sets including [Lucide](https://github.com/lucide-icons/lucide), [Solar](https://icones.js.org/collection/solar), [Craft Icons](https://www.figma.com/community/file/1415718327120418204), [Geist](https://vercel.com/geist/icons), and [SF Symbols](https://sf-symbols-one.vercel.app/). Their respective names and notices remain their own.

## License

See [`LICENSE`](LICENSE). Required upstream copyright and permission notices are retained there.
