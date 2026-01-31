# DMF Items Tracker

Lightweight addon that shows which items you need for your Darkmoon Faire profession turn-in quests, with live counts from your bags.

## Features
- Lists Cooking/Fishing plus your learned professions
- Marks quests as Complete when already turned in
- Colors requirements green when you have enough, red when missing
- Updates automatically on bag, quest log, skill, or zone changes
- Draggable frame with optional zone-only display (DMF + capitals), slash commands to lock/unlock/reset

## Slash commands
- /dmfitems lock — lock frame (stop dragging)
- /dmfitems unlock — unlock frame (drag with left button)
- /dmfitems toggle — toggle visibility in current zone
- /dmfitems reset — reset frame position and settings
- /dmfitems zone — toggle zone-only display filter

## Notes
- Default zone filter matches the WeakAura: Darkmoon Island plus major hubs (map IDs 37, 84, 407, 2112). Use `/dmfitems zone` to show everywhere.
- Saved variables: `DMFItemsTrackerDB` stores frame position and lock/zone settings.
