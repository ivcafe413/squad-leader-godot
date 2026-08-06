# Contributing / Conventions

## Folder layout
- `scripts/sim/` — simulation core (rules, state, commands). No `Node`/scene-tree or rendering dependencies.
- `scripts/ui/` — presentation logic (board rendering, input handling). Reads sim state, contains no rules logic.
- `scripts/net/` — transport layer bridging local input / network peers to `Command`s.
- `scenes/` — Godot scenes (board, counters, UI screens).
- `resources/units/`, `resources/terrain/`, `resources/tables/` — data-driven rulebook data (see [DATA_DRIVEN_DESIGN.md](DATA_DRIVEN_DESIGN.md)).

## GDScript style
- Static typing on all function signatures and member variables (`var mf: int`, `func move(unit: Unit) -> void`).
- Simulation core classes are plain `RefCounted`/`Resource` subclasses, never `Node`, so they can be unit-tested without a scene tree.
- One class per file; file name matches `class_name`.

## Rules changes
Any change to game rules behavior should be reflected in the corresponding file under `docs/rules-reference/` in the same change.
