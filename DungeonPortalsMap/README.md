# Dungeon Portals Map

Interactive HUD-style overlay for Timeways (zone 2266) showing dungeon portal locations with live player positioning and facing.

## Features
- Shows 6 Timeways dungeon portal markers with custom atlases
- Live player-centered HUD with facing-based rotation and FOV tilt
- Adjustable HUD scale, icon scale, opacity, and font size
- Auto-show/hide when entering/leaving Timeways
- Optional player marker (compass icon), off by default

## Slash Commands
- `/dpm toggle` — Toggle display on/off
- `/dpm show` / `/dpm hide` — Show or hide the map
- `/dpm scale <50-300>` — Set HUD size
- `/dpm icon <50-300>` — Set icon size
- `/dpm alpha <0-100>` — Set opacity (0 invisible, 100 opaque)
- `/dpm player` — Toggle player position marker on/off

## Notes
- Designed for the Timeways zone (map ID 2266). The map auto-hides elsewhere.
- Updates are throttled (~100x per second) for smooth positioning without heavy CPU use.
