# Godot Combat Simulator

A small collection of Godot 4 scripts for prototyping a first-person 3D combat
arena. It includes player movement and mouse look, crosshair-directed fireballs, a
damageable test dummy, and a pause menu.

## Included scripts

- `scripts/player.gd` — first-person movement, camera control, and aimed attacks.
- `scripts/fireball.gd` — projectile movement, collision damage, and cleanup.
- `scripts/test_dummy.gd` — a reusable health target that resets after defeat.
- `scripts/pause_menu.gd` — a CanvasLayer pause/resume and quit controller.

## Getting started

1. Create or open a Godot 4 project.
2. Copy `scripts/` into the project.
3. Follow [`docs/GODOT_SETUP.md`](docs/GODOT_SETUP.md) to assemble the scenes and
   configure input actions.
4. Run the arena scene and use **WASD** to move, **Space** to jump, the **left
   mouse button** to fire, and **Escape** to pause.

The scripts use exported properties and signals so they can be adapted without
changing their source.
