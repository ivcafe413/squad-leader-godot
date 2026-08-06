# Rules Reference — Line of Sight & Terrain

Scope: LOS and terrain rules needed for the Scenario 1 board only.

## Summary (rulebook §3, 7, 11.5)
Scenario 1 uses only **mapboard 1** (Game Set I's city board, §3.1) — a single, flat board with **no hills** and **no walls/hedges** (§11.5). This significantly narrows what v1 needs: the "Basic LOS" rules of §7 apply (not the elevation-aware "Advanced LOS" of §43, which is only needed starting Game Set II).

### Basic LOS (§7 — applies to board 1)
- LOS is a straight line from the center of the firing hex to the center of the target hex (§7.1).
- LOS is unobstructed unless it passes directly through a woods or building *symbol* (not just a woods/building hex) between the firing and target hex — infantry in a hex does not block LOS through it (§7.2–7.3, exception §17.6 for MG penetration).
- LOS extends *into* a woods/building hex but not *through* it to hexes beyond (§7.3).
- Buildings covering 3+ hexes are multi-story; the hex directly behind such a building (or one blocked by any building/woods) is a "blind hex" and cannot be fired upon from the blocking side, though units at ground level can fire *over* buildings of 2 hexes or smaller and woods (§7.4–7.7).
- Units in the same building may not see or fire at each other unless adjacent, or the LOS between them doesn't cross an intervening building symbol (§7.7).
- Units may always fire into any adjacent hex regardless of terrain (§7.8).

### Terrain Effects Chart — types relevant to board 1 (full chart, rulebook p.43)

| Terrain | Movement | Combat (TEM) |
|---|---|---|
| Open Ground | 1 MF | −2 moving / 0 non-moving (§11.1) |
| Shellhole | 1 MF | +1 (§11.1) |
| Wheatfield | 1 MF | 0 (§11.1); blocks LOS but not fire *into* the hex; blind to sight but not fire (§44.2) |
| Road | 1 MF (1/2 via road hexside) | uses the *other* terrain in the road hex (§5.53) |
| Woods | 2 MF | +1 (in target hex), blocks LOS beyond first woods hex (§7.2–7.3) |
| Wooden Building | 2 MF | +2 |
| Stone Building | 2 MF | +3 |
| Walls / Hedges | N/A — do not appear on board 1 (§11.5) | N/A |

See [movement.md](movement.md) for the full MF cost table and [fire-combat.md](fire-combat.md) for how TEM is applied during Fire Combat resolution.

## Open items to fill in from the scenario card
- [ ] Confirm the exact terrain mix present on Scenario 1's setup area of board 1 (open ground / woods / buildings / wheatfield, per the scenario's board configuration)
- [ ] Any Scenario 1 SSR affecting terrain or LOS (not included in this rulebook; check the scenario card)
