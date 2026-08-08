# Milestone Breakouts

Detailed specs for roadmap milestones, expanded as each one is planned in depth.
See [ROADMAP.md](ROADMAP.md) for the high-level list. Only milestones with a
section below have been broken out so far; others remain as their one-line
ROADMAP.md summary until planned.

## M2 — Setup

Roadmap summary: Unit data (`UnitData`/`TerrainData` resources per
[DATA_DRIVEN_DESIGN.md](DATA_DRIVEN_DESIGN.md)), Scenario 1 order-of-battle
placement, stacking limits.

### Deliverables

**Data layer (`scripts/sim/`, no Node/scene-tree dependency)**
- `UnitData` Resource script (new, under `scripts/sim/unit/`) as a base class
  holding only fields common to every counter: id/display name, side, and
  display fields sufficient to render a placeholder (side color, short text
  code) — see Open Questions for why these live on the base rather than
  needing real art.
- Per-class subclasses of `UnitData` carrying the fields specific to that
  class of counter, e.g. `SquadData` (firepower, range, movement allowance,
  morale level, size), `LeaderData` (movement allowance, morale level,
  leadership bonus), `SupportWeaponData` (firepower, range, portage cost,
  breakdown number) — with further per-weapon-type subclasses (e.g.
  `LMGData extends SupportWeaponData`) added as Scenario 1's actual support
  weapons are confirmed, not speculatively upfront. See Open Questions #1.
- `resources/units/*.tres` — one `.tres` per Scenario 1 counter type, each
  referencing the appropriate subclass script, transcribed from the physical
  counters per DATA_DRIVEN_DESIGN.md's authoring workflow.
- `TerrainData`/terrain rendering — already delivered in M1; no new work
  needed here beyond `Counter` reading terrain under it if relevant (e.g.
  stacking display).
- A Scenario 1 OOB/setup representation: per-side list of initial
  (`UnitData`, `HexCoord`) placements plus each side's deployment-area
  restriction. New concept — no precedent yet in `scripts/sim/`.
- A `BoardState`-style occupancy structure (new, `scripts/sim/`) mapping
  `HexCoord -> Array[UnitData placement]`, mutated directly by UI placement
  calls (not a `Command` — see Open Questions #3 for why this is fine at
  Setup time specifically).
- Stacking-limit validation as an isolated, testable rule in `scripts/sim/`,
  built against `BoardState` (not tied to UI): max 4 infantry units per hex
  (of which at most 3 may be squads), plus up to 10 portage points of
  support weapons ([rules-reference/movement.md](rules-reference/movement.md)
  §6). Reused later by M3's `MoveCommand` validation — not reimplemented.

**Presentation layer (`scripts/ui/`)**
- Generic `Counter` node/scene (new, `scripts/ui/counter.gd` or similar): a
  view-sided game piece (Squad Leader nomenclature retained — "Counter", not
  "token"/"piece") that:
  - Accepts an *optional* `UnitData` Resource export. Unset = a blank white
    counter with no side/class styling; set = styled from that `UnitData`
    (sub)class's fields. This makes `Counter` usable as a generic board
    piece with zero data dependency, not only as a `UnitData` renderer.
  - Encapsulates its own rendering (placeholder shape + code text when data
    is present; swappable for real art later without changing its public
    interface).
  - Reports/handles stackability visually: knows how to offset itself when
    sharing a hex with other counters (fanned/cascaded visual, topmost =
    last placed). This is purely a visual layout concern and works whether
    or not a `BoardState` is wired in (see below).
- Input & interaction on `Counter` — all pure presentation, no simulation
  dependency, so fully buildable/testable before `BoardState`, `Command`, or
  game flow exist:
  - Mouse hover detection + highlight (e.g. outline/tint) while hovered.
  - Drag-and-drop: press to pick up, follow cursor, release to attempt drop.
  - Hex-grid snapping: convert cursor position to the nearest `HexCoord` via
    `HexBoardView`/`HexUtils` (existing M1 conversion utilities — no new
    coordinate math needed).
  - On drop: if a stacking-limit validator is wired in (i.e. a `BoardState`
    is available), validate before committing and snap back on rejection;
    if none is wired in, the drop always succeeds. This makes rule
    enforcement an optional layer on top of generic manipulation rather than
    a hard dependency — see Open Questions #3.
- Hex hover/selection highlight in `HexBoardView` (extends M1's script):
  highlight the hex currently under the cursor and/or a selected hex,
  independent of whether a `Counter` occupies it.
- A standalone test/dev scene exercising `Counter` drag-and-drop, hover
  highlight, hex snapping, and visual stacking with a handful of counters
  (mixing blank and `UnitData`-backed) directly on the M1 board — no
  `BoardState`, `Command`, or game-flow wiring required. Doubles as manual QA
  now and scaffold for automated tests later.

### Definition of Done
- [ ] `UnitData` resource type defined with all fields needed by Scenario 1's counters, including placeholder display fields
- [ ] All Scenario 1 unit `.tres` files created (blocked, see Blockers)
- [ ] Scenario 1 setup/deployment areas represented in data (blocked, see Blockers)
- [ ] `BoardState` occupancy structure implemented and queryable by hex
- [ ] Stacking limit rule implemented against `BoardState` and testable in isolation (no UI required)
- [ ] `Counter` node renders blank/white with no `UnitData` assigned, and styled (side/class) when one is
- [ ] Counters can be hovered (highlight), dragged, and dropped with hex-grid snapping, independent of `BoardState`/`Command`/game-flow wiring
- [ ] Hovering/selecting a hex highlights it in `HexBoardView`, independent of counter occupancy
- [ ] Dropping a counter onto an over-stacked hex is rejected and the counter snaps back, when a stacking validator is wired in

### Dependencies
- M1's `HexCoord`/`HexGrid` (`scripts/sim/hex/`) — done, sufficient for placement
  and stacking lookups.
- M1's `HexBoardView`/`HexUtils` coordinate conversion — done, reused for
  cursor-to-hex snapping, no new math needed.
- DATA_DRIVEN_DESIGN.md's `Resource`-based conventions — done, no changes needed.

### Blockers
From GDD.md's "Open items to fill in from the scenario card" — still needed
from the physical Scenario 1 card:
- Full order of battle for both sides (unit types, counts, leaders, any
  support weapons).
- Exact setup/deployment restrictions per side.
- Confirmation of whether support weapons/armor appear in Scenario 1 at all
  (affects whether `UnitData` needs a support-weapon/portage subtype now).

### Open questions
1. ~~Single `UnitData` type with a `unit_class` enum, vs. separate Resource
   subclasses per class?~~ Resolved: subclass per class (`SquadData`,
   `LeaderData`, `SupportWeaponData`, further per-weapon-type subclasses like
   `LMGData`), matching the genuine variety of physical counter types better
   than one flat type + enum. Base `UnitData` stays minimal (id, side,
   placeholder display fields) so `Counter` doesn't need to know which
   subclass it's holding to render a fallback.
2. ~~Is interactive/UI-driven placement in scope for M2?~~ Resolved:
   drag-and-drop `Counter` placement with hover/highlight and hex snapping is
   explicitly in scope for M2.
3. How to let `Counter` manipulation (drag/hover/highlight/stacking) be
   built and tested before `BoardState`/Setup data/game flow exist, without
   violating ARCHITECTURE.md's "never mutated directly by UI code"?
   Resolved: split generic manipulation from rule enforcement. Hover,
   highlight, drag-and-drop, hex snapping, and visual stacking are pure
   presentation with no simulation dependency at all — they don't mutate any
   sim state and are fully testable standalone (see the dev/test scene
   deliverable above), independent of `Command`/game flow entirely. Only
   *committing* a placement as game-relevant occupancy touches sim state,
   and that still only happens through `BoardState` directly at Setup time
   (not a `Command`), per ARCHITECTURE.md's Save/Replay section treating
   "initial setup" as distinct from the command log. Stacking-limit
   rejection-on-drop is wired in as an optional validator so it can be
   layered on after generic manipulation is already proven out, and the same
   check is reused by M3's `MoveCommand` rather than duplicated.
4. No counter art assets exist yet (only board images in `assets/boards/`).
   Recommend: `Counter` renders a placeholder (side color + short class code
   text) sourced from `UnitData` fields when present, or plain white when no
   `UnitData` is assigned; real counter art can replace the placeholder
   later without changing `Counter`'s interface.
