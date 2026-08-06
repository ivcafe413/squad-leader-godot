class_name HexBoardView
extends TileMapLayer

## Procedurally stamps a border-overlay tile over every hex in a HexGrid.
## Terrain art is a separate underlaid background image, not rendered here.

@export var hex_grid: HexGrid
@export var border_source_id: int = 0

# Fractions of hex_border.svg's flat-top hexagon (64x64 viewBox) used to place coordinate labels.
const TOP_EDGE_Y_FRACTION := 0.0 # y=0 of 64: the flat top edge.
const TOP_RIGHT_X_FRACTION := 0.75 # x=48 of 64: the top-right vertex.
const LEFT_COLUMN_LABEL_INSET_FRACTION := 0.08 # pulls the column-A label off the vertex so it clears the border.

func _ready() -> void:
	_apply_board_offset()
	_generate_border_overlay()
	queue_redraw()

# Printed Squad Leader boards crop column A to its right half (grid shifted left half a hex).
func _apply_board_offset() -> void:
	if tile_set != null:
		position.x = -tile_set.tile_size.x / 2.0

func _generate_border_overlay() -> void:
	if hex_grid == null:
		return
	clear()
	for coord in hex_grid.get_all_coords():
		set_cell(_to_map_coord(coord), border_source_id, Vector2i.ZERO)

func _draw() -> void:
	if hex_grid == null or tile_set == null:
		return
	var font := ThemeDB.fallback_font
	var font_size := ThemeDB.fallback_font_size
	for coord in hex_grid.get_all_coords():
		var map_coord := _to_map_coord(coord)
		var center := map_to_local(map_coord)
		var label_text := HexUtils.to_label(coord)
		var text_size := font.get_string_size(label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
		var top_edge_y := center.y - tile_set.tile_size.y * (0.5 - TOP_EDGE_Y_FRACTION)
		var anchor_x := center.x
		# Column A hexes are cropped to their right half; anchor the label to the visible top-right corner instead.
		if map_coord.x == 0:
			anchor_x = center.x + tile_set.tile_size.x * (TOP_RIGHT_X_FRACTION - 0.5 - LEFT_COLUMN_LABEL_INSET_FRACTION)
		var pos := Vector2(anchor_x - text_size.x / 2.0, top_edge_y + text_size.y)
		draw_string(font, pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

# Sole place translating sim-core axial coordinates into Godot's TileMapLayer map coordinates.
func _to_map_coord(axial: HexCoord) -> Vector2i:
	return HexUtils.axial_to_offset(axial)
