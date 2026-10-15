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
* Most examples load the library from a hardcoded GitHub URL
  (`raw.githubusercontent.com/SCOPE03/NEVAUI/main/dist/main.lua`), NOT the
  local tree. In the harness `game:HttpGet` is intercepted and served
  `dist/main.lua`, so a local build is what runs. In a real executor those
  examples still fetch the *published* bundle, so a fix is invisible until
  `dist/main.lua` is committed and pushed. When a user reports a bug that
  looks fixed locally, check whether they are running the published bundle.
* `run_all.sh` picks the mode per file: examples that call `game:HttpGet` load the
  library themselves, so they run in bundle mode; everything else runs source mode.
* The harness fails on any error recorded in the stub. Earlier it printed
  "EXAMPLE RAN OK" unconditionally, which masked 8 of 13 broken examples.

### Stub fidelity gotchas

These were real sources of false failures; keep them accurate:

* `UIGradient.Color` / `.Transparency` are sequences, not scalars.
* `ColorSequence.new` / `NumberSequence.new` accept an array of keypoints.
* `Color3` needs `Lerp` and `ToHex`.
* `HttpService:JSONDecode` must actually parse JSON. Returning `{}` made
  `NevaUI.Version` silently nil.
* The signal list must cover every signal NevaUI connects to (`TouchPinch` was
  missing, which broke `main2.client.lua`).
* Executor globals scripts probe for (`printidentity`, `getidentity`) must exist.
* `Vector3` needs arithmetic metamethods (`__add`/`__sub`/`__mul`/`__div`) and
  `Magnitude`; camera framing in `src/elements/Viewport.lua` depends on them.
* `Instance:IsA` walks the real class ancestry, so `Part:IsA("BasePart")` is true.
* `Part`/`Model` carry Vector3 `Size`/`Position`/`CFrame` and implement
  `GetBoundingBox`/`GetPivot`, since they are 3D instances, not GUI objects.

`tests/SidebarLayout.lua` pins the rail geometry for Left/Right/Top: a
right-anchored rail must use `Position.X.Scale = 1` with no horizontal offset.
It fails if the old floating-rail offset is reintroduced.

## Theme system

Registry keys in `NevaUI.Themes` are compact (`CottonCandy`, `MonokaiPro`) while
each theme's `Name` is a display name (`"Cotton Candy"`, `"Monokai Pro"`).
`ResolveThemeKey` in `src/Init.lua` accepts either form; `SetTheme` raises on an
unknown value rather than failing silently. `.harness/theme_test.luau` covers
this (run in both modes; 85 checks).

## NevaGlass style

`NevaGlass` (in `src/themes/Init.lua`) is NevaUI's glassmorphic dark-violet
style: a `#75a4ce → #7bc9c9 → #e08aaf` gradient accent, `#201e26`/`#1e2128`
element surfaces, and pill-shaped rail tabs. It is a native NevaUI theme built
on the same token set as every other theme, so it is configurable through the
normal paths: `Theme = "NevaGlass"` on the window, `NevaUI:SetTheme`, and
`ThemeColors` overrides. `examples/neva_glass_example.lua` shows a full
interface built on it, including runtime theme and rail switching.

## Conventions

* Tabs in Lua source are tabs, not spaces.
* Keep naming Neva-branded. Do not reference third-party library names in the
  public surface, examples, or docs.
* Keep the public API additive.
* `GetThemes()` returns the whole registry (key -> theme table), not a list. To
  populate a dropdown, collect the keys into an array first; passing the
  dictionary directly feeds tables into the element.
