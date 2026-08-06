# Game Design Document — Squad Leader Classic

## Overview
Godot implementation of Avalon Hill's *Squad Leader* (1977), a squad-level WWII tactical wargame played on a hex grid. Supports hotseat (two players, one device) and online (two players, networked) play.

## v1 Scope
v1 implements **Scenario 1 only**. No other scenarios, no expansions (Cross of Iron, Crescendo of Doom, GI: Anvil of Victory, etc.) are in scope until a later version.

v1 must deliver, end to end:
- The Scenario 1 map (correct hexes, terrain, board configuration) and order of battle (both sides' units, initial setup restrictions).
- The Scenario 1 victory conditions and turn/time limit.
- All rules subsystems required to legally play that scenario from setup to a determined winner (see Subsystems below).

Out of scope for v1: any rule, unit type, terrain type, or weapon not needed by Scenario 1 (e.g. armor/vehicle rules, OBA, wire/mines, if Scenario 1 doesn't use them — confirm against the scenario card and prune the list below accordingly).

## Turn Sequence (Sequence of Play)
Each game turn is split into a Player 1 and Player 2 half, each following:
1. Rally Phase — broken/routed units attempt rally, leaders may attempt to rally units in same hex.
2. Prep Fire Phase — moving player may fire before moving.
3. Movement Phase — moving player expends movement factors (MF) per unit.
4. Defensive Fire Phase — non-moving player may fire at units that moved.
5. Advancing Fire Phase — moving player may fire after movement (at reduced effect).
6. Rout Phase — broken units not eligible to rally must attempt to rout toward cover/rear.
7. Advance Phase — units may advance one hex (into or out of adjacent enemy-occupied hexes, triggering Close Combat).
8. Close Combat Phase — resolved for hexes containing opposing units at the end of the Advance Phase.

The full turn repeats for the other player's movement phase (Squad Leader uses "Player Turn" halves rather than simultaneous movement — confirm exact structure against rulebook §A3 and record any deviation here).

## Subsystems needed for Scenario 1
- [ ] Hex map rendering with terrain types present on the Scenario 1 board
- [ ] Unit counters: infantry squads/half-squads, leaders (confirm from OB whether SW/support weapons or armor appear in Scenario 1)
- [ ] Stacking limits
- [ ] Movement (MF costs by terrain, road bonus if applicable)
- [ ] Line of sight (LOS) and terrain blocking
- [ ] Fire combat resolution (odds/DR-based Combat Results Table), Terrain Effects Modifier (TEM)
- [ ] Morale checks and status (broken, desperate morale, routing)
- [ ] Rally
- [ ] Close combat
- [ ] Victory condition check (per Scenario 1's specific objective — record exact wording here once confirmed)

Subsystems explicitly deferred (confirm/adjust once Scenario 1 OB is fully reviewed):
- Armor/vehicles and anti-tank rules
- Off-board artillery (OBA)
- Wire, mines, fortifications
- Multi-scenario/campaign play, scenario selection UI

## Open items to fill in from the rulebook/scenario card
- Scenario 1 title, map board(s) and hex range, board configuration/overlays
- Full order of battle for both sides
- Victory conditions and turn limit
- Any scenario-specific special rules (SSR)
