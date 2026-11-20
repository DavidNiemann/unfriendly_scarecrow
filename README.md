# Raven Scythe

A Don't Starve Together mod that adds the **Raven Scythe**, a weapon that summons hostile ravens to fight for you.

## Features

### Raven Scythe
- **Recipe:** 2 Twigs, 8 Flint, 2 Rocks (War tab, requires Alchemy Engine)
- **Damage:** 39
- **Durability:** 120 uses
- **On hit:** summons a raven next to the target that attacks it

### Raven
- 200 health, 50 damage, attacks every 0.3 seconds
- Chases and attacks the target you hit
- When its target dies, it attacks the next enemy near you (hostile creatures, monsters or anything attacking you)
- Flies away if there is no enemy left nearby
- Fights back if you attack it, and nearby ravens join in
- Drops a Blue Gem or a Crow Feather on death

## Installation

1. Copy (or link) this folder into
   `Steam/steamapps/common/Don't Starve Together/mods/`
2. Start the game, go to **Host Game → Mods** and enable **Raven Scythe**.

## Console commands

Open the console with `~` (switch to *Remote* with `Ctrl`):

```lua
c_give("scythe")   -- put the scythe into your inventory
c_spawn("raven")   -- spawn a raven at the mouse cursor
```

## Authors

Sanoggel & Bambusbjörn
