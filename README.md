# GridNav

```

░░      ░░░       ░░░        ░░       ░░░   ░░░  ░░░      ░░░  ░░░░  ░
▒  ▒▒▒▒▒▒▒▒  ▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒▒  ▒▒▒▒  ▒▒    ▒▒  ▒▒  ▒▒▒▒  ▒▒  ▒▒▒▒  ▒
▓  ▓▓▓   ▓▓       ▓▓▓▓▓▓  ▓▓▓▓▓  ▓▓▓▓  ▓▓  ▓  ▓  ▓▓  ▓▓▓▓  ▓▓▓  ▓▓  ▓▓
█  ████  ██  ███  ██████  █████  ████  ██  ██    ██        ████    ███
██      ███  ████  ██        ██       ███  ███   ██  ████  █████  ████

```

![Status](https://img.shields.io/badge/status-alpha-red)
![Maintenance](https://img.shields.io/badge/maintained%3F-no%20promises-orange)
![GitHub last commit](https://img.shields.io/github/last-commit/jrhalchak/GridNav.spoon)
![GitHub issues](https://img.shields.io/github/issues/jrhalchak/GridNav.spoon)
![GitHub pull requests](https://img.shields.io/github/issues-pr/jrhalchak/GridNav.spoon)
![GitHub license](https://img.shields.io/github/license/jrhalchak/GridNav.spoon)

A keyboard-driven mouse grid navigation system for Hammerspoon, inspired by [keynav](https://github.com/jordansissel/keynav), a classic Linux keyboard-driven mouse grid utility.

![Demo GIF](assets/gridnav.gif)

## Features
- Keyboard-driven mouse grid navigation system
- Divide screen into navigable quadrants with keyboard shortcuts
- Precisely control cursor position without touching the mouse
- Perform mouse actions (clicks, scrolling) entirely from keyboard

<details>
<summary><strong>Grid Navigation & Manipulation</strong></summary>

- Split the grid into smaller sections using directional keys (h/j/k/l)
- Move the grid around the screen (shift + h/j/k/l)
- Resize grid to match the current active window (t)
- Center grid around current cursor position (c)
- Adjust grid placement with pixel-level precision

</details>

<details>
<summary><strong>Mouse Actions</strong></summary>

- Warp cursor to grid center without clicking (w)
- Left-click at grid center (space or return)
- Double-click at grid center (ctrl+space or d)
- Right-click at grid center (shift+space or shift+return)
- Right-click while keeping grid active for menu selection

</details>

<details>
<summary><strong>Visual Customization</strong></summary>

- Customizable grid line color, thickness, and opacity
- Border styling options for grid appearance
- Midpoint indicator with configurable shape ("square" or "circle")
- Midpoint size and color options
- Background dimming with adjustable opacity

</details>

<details>
<summary><strong>Keyboard Configuration</strong></summary>

- Fully customizable key bindings for all actions
- Remap directional controls (WASD support, etc.)
- Custom shortcuts for special functions
- Alternative key bindings for common actions

</details>

<details>
<summary><strong>Additional Features</strong></summary>

- Scrolling in all directions at current cursor position
- Optional visual hints showing available commands
- Configure right-click exit behavior
- Easy installation as a Hammerspoon Spoon
- Minimal resource usage
- Comprehensive configuration options

</details>

## Project Status

> **Alpha Software:**
> GridNav is under active development by a single maintainer, primarily for personal use.
> Features, APIs, and configuration options may change at any time (_or not at all_).

> Bug reports and contributions are welcome, but please expect limited support and rapid iteration.

> _Side note_: I may abandon this and rewrite it in C or Python to make it cross-platform, since I've grown to like the features and quirks over my current keynav config.

## Installation
1. Download or clone this repository
2. Move GridNav.spoon to ~/.hammerspoon/Spoons/
3. Add to your init.lua: `hs.loadSpoon("GridNav")`

Assuming you have the default `~/.hammerspoon/Spoons` directory, you can just run the following, add your initialization/configuration to the `~/.hammerspoon/init.lua` and restart Hammerspoon.

```sh
git clone https://github.com/jrhalchak/GridNav.spoon.git ~/.hammerspoon/Spoon/GridNav.spoon
```

## Basic Usage
```lua
local gridNav = hs.loadSpoon("GridNav")
gridNav:start()  -- Use default configuration
```

### Focus-Follows-Mouse

If you want windows to focus automatically when warping the cursor, you have several options:

1. For Aerospace or other WM users: Set `focus_follows_mouse = true` or it's equivalent in you configuration.
2. For all users: Install a separate focus-follows-mouse utility like "Focusing" from the Mac App Store.
3. For advanced users: Create a script that enables focus-follows-mouse system-wide.

## Configuration
GridNav can be extensively customized. Below are all of the possible configuration values, and their default values.

### Visual Appearance
```lua
local gridNav = hs.loadSpoon("GridNav")

gridNav:configure({
     -- Grid appearance
     gridLineColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
     gridBorderColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
     gridLineWidth = 1,
     gridBorderWidth = 3,
     radius = 10,

     -- Corner decorations
     -- size of decorations is radius * 2, or 28
     -- when the grid is < (radius * 2) or 28, it's (radius or 28) / 2
     decorateCorners = false,

     -- Midpoint configuration
     midpointSize = 10, -- midpointSize + 2 is the min-width of the grid
     midpointShape = "square", -- "square" or "circle"
     midpointFillColor = {red = 1, green = 1, blue = 1, alpha = 0.2},
     midpointStrokeColor = {red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7},
     midpointStrokeWidth = 0,
     showMidpoint = true,

     -- Background appearance
     dimBackground = true,
     dimColor = {red = 0, green = 0, blue = 0, alpha = 0.3},

     -- Movement / Cutting
     moveDistance = 1,
    cutAmount = 0.5,

     -- UI behavior
     showModalAlert = false,
     rightClickExitsGrid = false,  -- When false, right-click keeps grid active

     -- Initialization key-combo
     mainModifiers = {"cmd"}, -- a list of modifiers
     mainKey = ";", -- the trigger key
})

gridNav:start()
```

### Custom Keybindings
You can use the `gridNav:bindHotkeys()` method to set keybindings, or pass this object as the `keys = {}` property in the `gridNav:configure()` method.

```lua
local gridNav = hs.loadSpoon("GridNav")

gridNav:bindHotkeys({
  -- Main activation key
  activate = {{"cmd"}, ";"},

  -- Grid division keys
  cutLeft = "h",
  cutRight = "l",
  cutUp = "k",
  cutDown = "j",

  -- Grid movement
  moveLeft = {{"shift"}, "h"},
  moveRight = {{"shift"}, "l"},
  moveUp = {{"shift"}, "k"},
  moveDown = {{"shift"}, "j"},

  -- Mouse actions
  warpCursor = "w",
  leftClick = "space",
  doubleClick = {{"ctrl"}, "space"},
  rightClick = {{"shift"}, "space"},

  -- Special functions
  resizeToWindow = "t",
  centerAroundCursor = "c",

  -- Scroll settings
  scrollDown = {{"cmd", "shift"}, "j"},
  scrollUp = {{"cmd", "shift"}, "k"},
  scrollLeft = {{"cmd", "shift"}, "h"},
  scrollRight = {{"cmd", "shift"}, "l"}
})

gridNav:start()
```

## API Reference

### Methods


| Method | Parameters | Description |
|--------|------------|-------------|
| `init([userConfig])` | `userConfig` - Optional table with configuration settings | Initialize GridNav's state and configuration |
| `configure(userConfig)` | `userConfig` - Table containing configuration options | Update GridNav settings after initialization |
| `getConfig()` | None | Returns a copy of the current configuration table |
| `bindHotkeys(mapping)` | `mapping` - Table with key mapping definitions | Customize keyboard shortcuts |
| `start()` | None | Start GridNav and activate hotkeys |
| `stop()` | None | Stop GridNav and deactivate hotkeys |

### Configuration Options


| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `gridLineColor` | Table | `{red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7}` | Color for grid lines |
| `gridBorderColor` | Table | `{red = 0.9, green = 0.9, blue = 0.9, alpha = 0.7}` | Color for grid border |
| `gridLineWidth` | Number | `1` | Width of grid lines in pixels |
| `gridBorderWidth` | Number | `1` | Width of grid border in pixels |
| `midpointSize` | Number | `10` | Size of midpoint indicator in pixels |
| `midpointShape` | String | `"square"` | Shape of midpoint ("square" or "circle") |
| `showMidpoint` | Boolean | `true` | Whether to show midpoint indicator |
| `dimBackground` | Boolean | `true` | Whether to dim background behind grid |
| `dimColor` | Table | `{red = 0, green = 0, blue = 0, alpha = 0.3}` | Color for background dim |
| `showModalAlert` | Boolean | `false` | Show alerts for keyboard commands |
| `rightClickExitsGrid` | Boolean | `false` | Exit grid after right-clicking |


## Todos
- [ ] Double-click
- [ ] U/D extra-scroll
- [ ] Test multi-monitor support

### Nice to Haves
- [ ] Macros?

## License & Copyright

&copy; 2025 Jonathan Halchak

MIT License


