# Roadmap

Milestones toward a playable Scenario 1, hotseat first. Each milestone should be playable/testable on its own before moving to the next.

- **M1 — Board**: Hex map data structure, Scenario 1 board rendering (terrain, hex grid, coordinates).
- **M2 — Setup**: Unit data (`UnitData`/`TerrainData` resources per [DATA_DRIVEN_DESIGN.md](DATA_DRIVEN_DESIGN.md)), Scenario 1 order-of-battle placement, stacking limits.
- **M3 — Movement**: Command pattern skeleton ([ARCHITECTURE.md](ARCHITECTURE.md)), movement command with MF costs by terrain, path validation.
- **M4 — Fire combat**: LOS calculation, fire declaration, Combat Results Table resolution, TEM application.
- **M5 — Morale**: Morale checks, broken/desperate status, rally phase.
- **M6 — Rout & Advance**: Rout phase movement, advance phase (including into enemy-occupied hexes).
- **M7 — Close combat**: Close combat resolution phase.
- **M8 — Victory conditions**: Scenario 1 win/loss determination, end-of-game UI.
- **M9 — Hotseat polish**: Turn indicator, pass-and-play flow, save/replay via command log.
- **M10 — Networked play**: Transport layer (ENet), host-authoritative command validation, client sync.

Later (post-v1, not scheduled yet): additional scenarios, expansions, armor/AT rules, OBA.
