# HandyNotes: Dungeons

A HandyNotes plugin for WoW dungeons, showing important locations and markers.

## Features

- Queen's Eyes locations in City of Threads dungeon
- Custom icons for each zone
- Configurable icon scale and transparency
- Works with both World Map and Battlefield Map

## Installation

1. Ensure HandyNotes is installed
2. Copy the `HandyNotes_Dungeons` folder to your `World of Warcraft\_retail_\Interface\AddOns\` directory
3. Restart WoW or reload UI

## Usage

Open your map while in City of Threads dungeon to see the Queen's Eyes markers.

### Routing Order

1. Start at "1st Eye" while fighting Xeph'itik
2. Clear eyes in order: Blue Zone (2nd) → Green Zone (3rd) → Red Zone (4th)
3. Finish at "Last Eye" before Executor Nizrek

### Battlefield Map

- Press `Shift + M` to open Battlefield Map
- To scale: `/run BattlefieldMapFrame:SetScale(2)` (adjust the `2` value as needed)

## Configuration

Access settings through HandyNotes options:
- Icon Scale: Adjust marker size
- Icon Alpha: Adjust marker transparency

## Notes

Coordinates were converted from WeakAura pixel offsets and may need adjustment based on in-game testing.

## Credits

Based on WeakAura by [City of Threads Queen's Eyes markers](https://wago.io/nXWJEYTEv/2)

## Version

- **Version**: 0.1
- **Interface**: 110200 (Midnight)
