# Architecture

## Goal
Hotseat and online play must run on the exact same simulation code path. The only difference between modes is where player input commands originate (local input twice vs. local input + network).

## Layers
1. **Simulation core** (`res://scripts/sim/` — plain GDScript classes / `Resource`s, no `Node` or scene-tree dependency, no direct rendering or input).
   - Owns all game state: map, units, phase, active player, morale/rout status.
   - Exposes state mutation only through a fixed set of **commands** (see below). Never mutated directly by UI code.
   - Deterministic: given the same starting state and the same ordered command list (plus dice results), it always produces the same resulting state. This makes replay, hotseat, and network sync all the same mechanism.
2. **Presentation** (`res://scenes/`, `res://scripts/ui/`) — board rendering, counter sprites, input handling. Reads simulation state to draw; never contains rules logic.
3. **Transport** (`res://scripts/net/`) — turns a local player's intent into a `Command`, sends/receives commands.
   - Hotseat: commands applied directly to the local simulation instance for whichever side is active.
   - Online: host-authoritative. Client sends intended `Command` to host; host validates against simulation rules, applies it, then broadcasts the resulting command (or resulting state delta) to all peers via Godot's high-level multiplayer API (ENet). Non-host peers apply the same command locally rather than trusting client-provided results, since dice/CRT resolution must be authoritative on the host.

## Command pattern
Every player action (move unit along path, declare fire, allocate fire, rally attempt, advance, etc.) is represented as a serializable `Command` object (e.g. `MoveCommand`, `FireCommand`, `RallyCommand`). Commands are:
- Validated against current sim state before being applied (illegal commands are rejected, not silently ignored).
- Applied through a single `GameState.apply(command) -> CommandResult` entry point.
- Logged in order, giving a full replay/undo log for free and a natural sync unit for network play.

## Hex coordinates
Use **axial coordinates** (`q`, `r`) for all hex math (neighbors, distance, LOS, range). Convert to pixel/screen position only in the presentation layer. Document any offset-coordinate mapping needed to match the physical board's hex numbering (e.g. board hex labels like "A1") in a single conversion utility, not scattered through the code.

## Dice / randomness
All die-roll resolution (CRT, morale checks, rally) happens inside the simulation core via a single seedable RNG service, so a command log can be replayed deterministically for hotseat replay, network reconciliation, and automated testing.

## Save / replay
Persisting a game = serializing initial setup + the ordered command log (not full state snapshots), so saves stay small and double as a replay/debug tool. Full-state snapshots may be added later purely as a performance optimization (e.g. periodic checkpoints), not as the primary save format.

## Godot version
Targets Godot 4.6 (GL Compatibility renderer, per [project.godot](../project.godot)).
