# M+ Timer

Replacement timer for Challenge Mode (Mythic+) showing elapsed time, chest achievement timers, and pass/fail status.

## Features
- Displays elapsed time during M+ runs
- Shows time remaining for each chest tier (3 chest / 2 chest / 1 chest)
- Displays "IN TIME" or "FAILED" status with time remaining/over
- Shows number of chests earned after completion
- Draggable frame with position memory
- Auto-hides when exiting dungeon
- Configurable update interval

## Slash commands
- /mptimer reset — reset frame position to default
- /mptimer show — show timer frame
- /mptimer hide — hide timer frame

## Notes
- Timer only displays during active Challenge Mode runs
- Chest time calculations: 2-chest at 80% of time limit, 3-chest at 60%
- Saved variables: `MPTimerDB` stores position and settings
