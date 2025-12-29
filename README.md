# MouseSensitivityFix

An Ascension WoW addon that extends mouse sensitivity range beyond the default limits, allowing you to match your desktop mouse speed.

## The Problem

WoW's default mouse sensitivity slider only goes from 0.5 to 1.5, which means even at the lowest setting (0.5), your in-game mouse is still significantly faster than your desktop mouse speed. Combine this with a DPI selector on the bottom of your mouse and we have a serious UX issue.

## The Solution

MouseSensitivityFix allows you to set mouse sensitivity as low as **0.01** (or as high as 3.0 for whatever crazy reason - thanks Claude), giving you full control to match your preferred desktop mouse speed.

## Installation

1. Download the latest release (Select "Code" at the top of the page > download zip)
2. Extract to your `Interface/AddOns` folder
3. Remove -main from filename | "MouseSensitivityFix" should be filename.
4. Restart Ascension

## Usage

### Quick Start

Type `/ms 0.2` - this is our recommended starting point (closest to developer settings)

### Commands

- `/ms <value>` or `/mouse <value>` - Set mouse sensitivity (0.01 to 3.0)
- `/ms` - Show current sensitivity and help
- `/mouselook <value>` or `/ml <value>` - Adjust mouse look speed (appears to have negligible effect)

### Examples

```
/ms 0.2    - Recommended starting point
/ms 0.15   - Even slower
/ms 0.5    - WoW's default minimum
/ms 1.0    - WoW's default center
```

### Settings Panel

Access via: ESC → Interface → AddOns → "Mouse Sensitivity Fix"

## Features

- Extended sensitivity range (0.01 to 3.0)
- Easy-to-use slash commands
- Settings panel with slider
- Persistent settings across sessions
- Simple and lightweight

## Compatibility

- Tested on Ascension WoW (3.3.5a)
- Should work on any WotLK (3.3.5) private server
- May work on other WoW versions (untested)

## Contributing

Found a bug or have a suggestion? Open an issue or submit a pull request!

## License

MIT License - feel free to use, modify, and distribute.

## Credits

Created to solve the long-standing mouse sensitivity issue in WoW. Special thanks to the Ascension WoW community for feedback and testing.
