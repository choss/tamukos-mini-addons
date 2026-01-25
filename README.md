# Tamuko's Mini-Addons

> **Disclaimer:** Everything in this repository is vibe / AI coded.

A collection of lightweight WoW addons converting select WeakAuras into standalone addons.

## Overview

This repository contains standalone WoW addons that replicate functionality from custom WeakAura configurations. Each addon is designed to be lightweight, self-contained, and require minimal dependencies.

## Addons

### [LoggerHead Display](LoggerHeadDisplay/)
Display for the LibDataBroker LoggerHead plugin. Shows logger state/text and value with click-through activation.

**Features:**
- Shows LoggerHead LDB text/label/value with icon
- Left-click to activate LoggerHead actions
- Right-click and drag to reposition
- Auto-refresh display (0.5s throttle)

See [LoggerHeadDisplay/README.md](LoggerHeadDisplay/README.md) for full details and slash commands.

---

### [Dungeon Portals Map](DungeonPortalsMap/)
Interactive HUD-style overlay for Timeways showing dungeon portal locations with live player positioning and facing.

**Features:**
- 6 dungeon portal markers with live player-centered HUD
- Facing-based rotation and FOV perspective
- Auto-show/hide when entering/leaving Timeways
- Adjustable scale, icons, and opacity

See [DungeonPortalsMap/README.md](DungeonPortalsMap/README.md) for full details and slash commands.

---

## Installation

1. Clone or download this repository.
2. Copy individual addon folders (e.g., `LoggerHeadDisplay/`, `DungeonPortalsMap/`) to your WoW `Interface/AddOns/` directory.
3. Reload your UI in-game (`/reload`) or restart WoW.
4. Enable addons in the AddOns menu.

## Requirements

- WoW 12.0+ (Midnight)
- No external dependencies (all libraries are embedded)

## License

Public Domain / CC0

## Author

Tamuko
