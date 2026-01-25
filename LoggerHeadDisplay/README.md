# LoggerHead Display

A lightweight LibDataBroker display for LoggerHead. Shows the logger state/text and value, with click-through to toggle LoggerHead and optional tooltip support.

## Features
- Displays LoggerHead LDB text/label/value with icon
- Click to activate LoggerHead actions (left-click)
- Right-click and drag to reposition; saved between sessions
- Optional tooltip passthrough from LoggerHead data object
- Throttled auto-refresh (0.5s) to reflect logger state changes

## Slash Commands
- `/lhd toggle` *(not implemented; use show/hide)*
- `/lhd lock` — Lock frame position
- `/lhd unlock` — Unlock and allow drag (right-click)
- `/lhd reset` — Reset position to defaults
- `/lhd show` — Show the display
- `/lhd hide` — Hide the display

## Notes
- Requires LibDataBroker-1.1 (embedded) and LoggerHead providing the LDB object `LoggerHead`.
- Dragging uses **right-click** to avoid interfering with left-click actions.
