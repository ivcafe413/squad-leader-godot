# Data-Driven Design Conventions

Rulebook data belongs in data files, not scripts, so tuning/fixing values never requires touching simulation code.

## Representation
Use Godot `Resource` (`.tres`) files for all rulebook-defined data, under `res://resources/`:
- `resources/units/` — one `.tres` per unit counter type appearing in Scenario 1 (squad/half-squad/leader), each a custom `UnitData` `Resource` with fields matching the physical counter: firepower, range, movement allowance, morale level, size/class, side.
- `resources/terrain/` — one `.tres` per terrain type present on the Scenario 1 board, each a `TerrainData` `Resource` with movement cost, TEM (terrain effects modifier, moving/stationary), LOS-blocking behavior, and any other printed effect.
- `resources/tables/` — the Combat Results Table (CRT) and any other lookup tables, as a `Resource` mapping (odds column / DR) → result, rather than hardcoded branches in code.
- `resources/boards/` — one `HexGrid` `.tres` per board (shape only: width/height) and one `HexTerrain` `.tres` per scenario's terrain layout. `HexTerrain.rows` is a per-row text grid (one `TerrainData.code` character per hex/column), with a `legend` dictionary mapping each code to its `TerrainData` resource — a text grid diffs and reviews far better than editing hundreds of individual hex entries.

## Rationale
- Adding/adjusting a unit or terrain type is a data change, reviewable without reading simulation code.
- Keeps the simulation core (see [ARCHITECTURE.md](ARCHITECTURE.md)) generic: it operates on `UnitData`/`TerrainData`/table lookups, it doesn't know about specific counters.
- Scoped to Scenario 1 for v1 — only add data entries for units/terrain/table rows actually used by that scenario.

## Authoring workflow
1. Transcribe the physical counter/board/table values into the corresponding `.tres` via the Godot editor inspector (or a small import script if transcribing many counters at once).
2. Reference data resources by `UnitData`/`TerrainData` instance, never by duplicating printed values inline in scripts or scenes.
