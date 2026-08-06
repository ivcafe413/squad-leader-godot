class_name TerrainData
extends Resource

## One terrain type's printed effects (see docs/rules-reference/los-and-terrain.md).

@export var display_name: String = ""
@export var code: String = "" ## single-character code used in HexTerrain.rows
@export var movement_cost: float = 1.0
@export var tem_moving: int = 0
@export var tem_stationary: int = 0
@export var blocks_los: bool = false
