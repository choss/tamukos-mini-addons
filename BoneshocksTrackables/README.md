# Boneshock's Trackables

A World of Warcraft addon that displays zone-aware currencies and items, bag space, and player money. Converted from the popular WeakAura by Boneshock.

## Features

- **Bag Space Display**: Shows free/total bag slots with warning color when low
- **Player Money**: Displays gold/silver/copper with optional coin icons and abbreviation
- **Zone-Aware Trackables**: Automatically shows relevant currencies and items based on your current zone
  - Supports all expansions from Classic through War Within (11.2.0 Midnight)
  - Custom color support per currency/item
  - Warning colors when reaching thresholds
  - Priority sorting
  - Special handlers for complex items (Anima deposits, Obsidian Keys, Crests, etc.)

## Installation

1. Download the addon
2. Extract to `World of Warcraft\_retail_\Interface\AddOns\`
3. Restart WoW or reload UI (`/reload`)

## Usage

- **Move Frame**: Unlock in options, then drag the frame to reposition
- **Configure**: Type `/bt` or go to ESC > Options > Add-Ons > Boneshock's Trackables
- **LDB Support**: Works with LibDataBroker display addons (Bazooka, ChocolateBar, etc.)

## Configuration

Access settings via:
- Blizzard Interface Options: ESC > Options > Add-Ons > Boneshock's Trackables
- Or right-click the LDB button

### Options

- **Frame Position**: Lock/unlock frame for repositioning
- **Bag Space Module**: Enable/disable, show total slots, warning threshold
- **Money Module**: Enable/disable, toggle gold/silver/copper, coin icons
- **Trackables Module**: Enable/disable, color options, expansion toggles
- **Expansions**: Enable/disable currencies/items per expansion

## Zone Matching

Trackables appear based on sophisticated zone matching:
- **uiMapID**: Direct map ID match
- **parentMapID**: Matches map and all children (prefix `r` for recursive)
- **areaMapID**: Matches specific area IDs
- **zones**: Matches zone text (comma-separated list)
- **excludeMapID**: Excludes specific maps
- **excludeByZoneText**: Excludes by zone name

## Credits

- **Original WeakAura**: Boneshock (https://wago.io/trackables)
- **Addon Conversion**: AI-assisted conversion by Tamuko

## Version

- **Interface**: 110200 (Midnight / 11.2.0)
- **Version**: 1.0
- **Author**: Boneshock (WeakAura) / Tamuko (Addon)

## Dependencies

- **Optional**: LibStub, LibDataBroker-1.1 (for LDB support)

## License

This addon is a conversion of a publicly available WeakAura. All credit for the original trackables data and logic goes to Boneshock.
