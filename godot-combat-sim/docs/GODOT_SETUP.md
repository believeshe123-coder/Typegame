# Godot 4 setup

## 1. Configure input actions

Open **Project > Project Settings > Input Map** and add:

| Action | Suggested input |
| --- | --- |
| `move_left` | A |
| `move_right` | D |
| `move_forward` | W |
| `move_backward` | S |
| `fire` | Left Mouse Button |

The built-in `ui_accept` action is used for jumping and defaults to Space. The
built-in `ui_cancel` action toggles the pause menu and defaults to Escape.

## 2. Create the fireball scene

1. Create an `Area3D` root and attach `scripts/fireball.gd`.
2. Add `MeshInstance3D` and `CollisionShape3D` children.
3. Put the fireball on a projectile collision layer and configure its collision
   mask to detect the world and damageable physics bodies.
4. Save the scene as `res://fireball.tscn`, which is the player's default preload
   path.

The projectile travels along its local negative Z axis, matching the orientation
produced by `Node3D.look_at()`.

## 3. Create the player

Use this node hierarchy so the paths expected by `scripts/player.gd` resolve:

```text
Player (CharacterBody3D)
├── CollisionShape3D
└── CameraPivot (Node3D)
    └── Camera3D
```

Attach `scripts/player.gd` to `Player`. The script captures the mouse, rotates the
player horizontally, clamps the camera pivot vertically, and fires through the
HUD crosshair. Its exported spawn offsets can be tuned in the Inspector.

## 4. Create the HUD

Add this hierarchy as a sibling of `Player` in the arena:

```text
HUD (CanvasLayer)
└── Crosshair (Control)
```

Center the `Crosshair` control with anchors or a container. The player projects a
3D ray through the control's center, excludes its own collision RID, and aims at
the first collision point. When the ray misses, it aims toward a distant point.

## 5. Create a test dummy

1. Create a `StaticBody3D` root and attach `scripts/test_dummy.gd`.
2. Add `MeshInstance3D` and `CollisionShape3D` children.
3. Ensure its collision layer is included in the fireball's collision mask.

The dummy hides and stops colliding when defeated, then resets after its exported
**Reset Delay**.

## 6. Create the pause menu

1. Add a `CanvasLayer` to the arena and attach `scripts/pause_menu.gd` to it.
2. Add a `Control` below the `CanvasLayer` to contain the menu UI.
3. Add Resume and Quit buttons below the `Control`.
4. Connect their `pressed` signals to `_on_resume_pressed` and
   `_on_quit_pressed`, respectively.

Because the `CanvasLayer` uses `PROCESS_MODE_ALWAYS`, it receives `ui_cancel`
input while the scene tree is paused. It releases the mouse while open and
captures it again when gameplay resumes.

## 7. Assemble and run

Add the player, HUD, dummy, and pause menu to a `Node3D` arena scene, set it as
the project's main scene, and run the project.
