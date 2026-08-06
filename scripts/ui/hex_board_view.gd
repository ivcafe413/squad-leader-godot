class_name HexBoardView
extends TileMapLayer

## Procedurally stamps a border-overlay tile over every hex in a HexGrid.
## Terrain art is a separate underlaid background image, not rendered here.

@export var hex_grid: HexGrid
@export var border_source_id: int = 0

func _ready() -> void:
	_generate_border_overlay()

func _generate_border_overlay() -> void:
	if hex_grid == null:
		return
	clear()
	for coord in hex_grid.get_all_coords():
		set_cell(_to_map_coord(coord), border_source_id, Vector2i.ZERO)

# Sole place translating sim-core axial coordinates into Godot's TileMapLayer map coordinates.
func _to_map_coord(axial: HexCoord) -> Vector2i:
	return HexUtils.axial_to_offset(axial)
