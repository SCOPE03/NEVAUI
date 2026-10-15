# Luna Interface Suite (vendored)

An unmodified copy of the **Luna Interface Suite** by Nebula Softworks, vendored
into NevaUI.

- Upstream: https://github.com/Nebula-Softworks/Luna-Interface-Suite
- File: `Luna.lua` — byte-for-byte identical to upstream `source.lua` (`master`)
- License: BSD 3-Clause, Copyright (c) 2024 Nebula Softworks (see `LICENSE`)

Re-download `source.lua` to refresh; do not edit `Luna.lua` in place.

## Important: this file is only half of Luna

`source.lua` is the *logic* half of Luna, not a self-contained UI library. The
entire visual tree — window, topbar, navigation rail, tabs, elements and the
notification list — is **not** defined in this file. It is loaded from a Roblox
asset:

```lua
-- Luna.lua line 1864
local LunaUI = isStudio and script.Parent:WaitForChild("Luna UI")
    or game:GetObjects("rbxassetid://86467455075715")[1]
```

Everything after that indexes the loaded hierarchy directly:

```lua
local Main = LunaUI.SmartWindow
local Elements = Main.Elements.Interactions
local Tabs = Main.Navigation.Tabs
local Notifications = LunaUI.Notifications
local KeySystem = Main.KeySystem
```

The file contains only six `Instance.new` calls (lines 1660–1784), all of them
decorative loading-screen effects such as a `DepthOfFieldEffect` and particles.
None of them build the interface.

### What this means

Evaluating this file without the asset raises `attempt to index nil` at line
1864. It cannot be made to work by editing the Lua, because the missing part is
not code — it is a Roblox instance tree that only `game:GetObjects` (a
`Studio`/executor-only API) can supply. No amount of adaptation inside NevaUI
can synthesise it.

So this file can be vendored and attributed, but it **cannot** currently be run
from NevaUI, and `NevaUI:LoadVendor("luna")` is deliberately not implemented
rather than shipped broken.

### Ways forward

1. **Obtain the UI tree.** In Studio, `game:GetObjects("rbxassetid://86467455075715")[1]`
   can be saved out as a `.rbxmx`/`.rbxlx` model. Bundling that alongside this
   file would make the pair self-contained and loadable. This is the only route
   that preserves Luna's exact look.
2. **Rebuild the view in NevaUI.** Use `NevaGlass` (see below) plus the elements
   in `src/elements/` to reproduce Luna's layout natively. This is what
   `examples/neva_glass_example.lua` does; it is NevaUI's own rendering, not
   Luna's.
3. **Keep Luna a runtime dependency.** Ship a script that calls
   `game:GetObjects` at run time, which only works under an executor.

## NevaGlass

The `NevaGlass` theme in `src/themes/Init.lua` reproduces Luna's palette — the
Nightlight (Neo) gradient `#75a4ce → #7bc9c9 → #e08aaf`, element backgrounds
`#201e26`/`#1e2128`, button strokes `#8883a3`/`#575468`/`#403d4c`, and the
glassmorphic transparencies. It is a native NevaUI theme and needs none of the
above.

## Upstream credits

- Hunter (Nebula Softworks) — design and programming, main developer
- JustHey (Nebula Softworks) — configurations, bug fixing, co-developer
- Throit and Rayfield — colour picker
- Wally — dragging and certain functions
- Sirius — pcall parsing, notifications, slider, home tab
- Latte Softworks and qweery — Lucide and Material icons
- kirill9655 — loading circle
- Pookie Pepelss — bug tester
- Inori — configuration concept
- Deity/dp4pv/x64x70 — scripting and testing
- iPigTw — typo fixes, key system
- pushByAccident — executor lists
- ImFloriz — method fixes
