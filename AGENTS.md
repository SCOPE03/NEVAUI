# NEVAUI — agent notes

Roblox UI library in Lua/Luau. Source lives in `src/`, the minified release is
built into `dist/main.lua` by `bash build/build.sh` (darklua).

## Headless testing

There is no Roblox runtime here, so examples are executed against a mocked
executor environment in `.harness/`.

```
python3 .harness/run_harness.py <script.lua>            # run the built dist bundle
python3 .harness/run_harness.py <script.lua> --source   # run the real src/ tree
bash .harness/run_all.sh                                # every example, source mode
```

* `--source` is the useful mode while developing: `.harness/run_harness.py`
  injects a relative-path `require` over `src/` and `build/`, so scripts that do
  `require("../src/Init")` run unmodified.
* Without `--source` the script must obtain the library itself; the harness
  serves `dist/main.lua` from `game:HttpGet`.
* `.harness/roblox_stub.luau` fakes the Roblox API and executor globals. It
  includes a cooperative `task` scheduler (`task.wait` yields, `task.spawn`
  drains a queue under a resume budget) so endless clock/render loops terminate
  instead of hanging.
* Always rebuild after editing `src/`: the bundle-mode tests read `dist/main.lua`.

### Stub fidelity gotchas

These were real sources of false failures; keep them accurate:

* `UIGradient.Color` / `.Transparency` are sequences, not scalars.
* `ColorSequence.new` / `NumberSequence.new` accept an array of keypoints.
* `Color3` needs `Lerp` and `ToHex`.
* `HttpService:JSONDecode` must actually parse JSON. Returning `{}` made
  `NevaUI.Version` silently nil.

## Theme system

Registry keys in `NevaUI.Themes` are compact (`CottonCandy`, `MonokaiPro`) while
each theme's `Name` is a display name (`"Cotton Candy"`, `"Monokai Pro"`).
`ResolveThemeKey` in `src/Init.lua` accepts either form; `SetTheme` raises on an
unknown value rather than failing silently. `.harness/theme_test.luau` covers
this (run in both modes; 85 checks).

## Vendored code (`vendor/`)

`vendor/luna/` holds the Luna Interface Suite, BSD-3-Clause, kept byte-for-byte
identical to upstream. Keep vendored files unmodified so they can be refreshed
by re-downloading; record provenance, license text and upstream credits
alongside them.

Luna's `source.lua` is only the logic half of that library. The visual tree is
loaded from a Roblox asset (`game:GetObjects("rbxassetid://86467455075715")`,
line 1864) and then indexed as `LunaUI.SmartWindow`, `Main.Elements.Interactions`,
`Main.Navigation.Tabs`. Only six `Instance.new` calls exist in the whole file and
none build UI. So it cannot be evaluated without that asset, and no Lua-side
adaptation can supply it — do not promise `LoadVendor`-style loading for it
without first obtaining the UI tree. See `vendor/luna/README.md`.

## Conventions

* Tabs in Lua source are tabs, not spaces.
* Never name a theme or example "Luna". The user asked for Neva-branded naming;
  the Luna-derived theme is `NevaGlass`.
* Keep the public API additive; examples and the theme dropdown enumerate
  `GetThemes()` directly.
