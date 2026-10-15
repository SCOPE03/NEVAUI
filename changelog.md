# 1.6.67

## Changelog

- reworked sidebar tab rendering into a single state machine (idle, hover, pressed, active) so the background, label and icon stay in sync and hovering away no longer leaves a tab stuck lit
- added per-state sidebar tab theme tokens: `TabBackgroundTransparency`, `TabBackgroundHover`, `TabBackgroundHoverTransparency`, `TabBackgroundPressed`, `TabBackgroundPressedTransparency`, `TabBackgroundActiveHover`, `TabBackgroundActiveHoverTransparency`, `TabBackgroundActivePressed`, `TabBackgroundActivePressedTransparency`, `TabTextTransparencyHover`, `TabIconTransparencyHover` and `TabBorderTransparencyHover`
- updated the anime/chad-sigma examples with a soft Fluent-style pill rail
- fixed the right-hand sidebar rail floating mid-window instead of sitting flush against the right edge
- fixed dropdowns treating a table value's `Icon` field as an image path, which errored for theme entries
- hardened `Creator.SanitizeFilename` against non-string input

# 1.6.66

## Changelog

- added `CodeSize: number`, `CodeTheme: table`, `CanCopied: boolean` and `Height: UDim` to [Code](https://github.com/SCOPE03/NEVAUIcode) element (#91)
- changed PandaDev API url in [Key System](https://github.com/SCOPE03/NEVAUIkeysystem) (#92)
- fixed [Section](https://github.com/SCOPE03/NEVAUIsections) bg (in custom themes)
- fixed [Colorpicker](https://github.com/SCOPE03/NEVAUIcolorpicker) issue
- fixed `Viewport` bug when u can pinch it outside
- fixed [Window](https://github.com/SCOPE03/NEVAUIwindow) Drag with multiple fingers (#79)
- added `ProgressBar` element (#95 by [BitRevenant](https://github.com/BitRevenant)) [Github PR](https://github.com/SCOPE03/NEVAUI/pull/95)
- fixed `Dropdown.Locked` (#94 by [BitRevenant](https://github.com/BitRevenant)) [Github PR](https://github.com/SCOPE03/NEVAUI/pull/94)
