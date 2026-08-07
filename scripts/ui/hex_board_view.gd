class_name HexBoardView
extends TileMapLayer

## Hex coordinate math and on-board labels for a HexGrid.
## The board's hex grid/border art is baked into the background image, not drawn here;
## this node's TileMapLayer hex math backs coordinate conversion for labels and (later)
## selection/movement overlays. debug_atlas_source_id feeds an optional alignment-check overlay.

@export var hex_grid: HexGrid
@export var debug_atlas_source_id: int = 0

# The background art's native pixel size. Integer tile sizes rarely divide this evenly (e.g. a
# 65px tile over 10 rows is 650px, not 645px), so the grid is rescaled to close that residual gap
# and land exactly on the art instead of leaving it to accumulate across rows/columns.
@export var board_pixel_size := Vector2(900, 645)

# hex_border.svg is a 4-color debug atlas (pink/red/green/blue); rotate through them per-cell
# so adjacent hexes are visually distinguishable when checking grid/art alignment.
const DEBUG_COLOR_COUNT := 4

# Hotkey to toggle the debug alignment overlay on/off.
const DEBUG_COLORS_TOGGLE_KEY := KEY_F1

var _debug_colors_enabled := false

# Fractions of the hex atlas's flat-top hexagon (77x65 viewBox) used to place coordinate labels.
const TOP_EDGE_Y_FRACTION := 0.0 # y=0: the flat top edge.
const TOP_RIGHT_X_FRACTION := 0.75 # x=0.75*width: the top-right vertex.
const TOP_LEFT_X_FRACTION := 0.25 # x=0.25*width: the top-left vertex (mirror of TOP_RIGHT_X_FRACTION).
const EDGE_COLUMN_LABEL_INSET_FRACTION := 0.08 # pulls edge-column labels off the vertex so they clear the border art.

func _ready() -> void:
	_apply_board_offset()
	_update_debug_overlay()
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == DEBUG_COLORS_TOGGLE_KEY:
		_debug_colors_enabled = not _debug_colors_enabled
		_update_debug_overlay()

# Printed Squad Leader boards crop column A to its right half (grid shifted left half a hex);
# the grid is also rescaled so its natural (uncropped) extent matches the background exactly.
func _apply_board_offset() -> void:
	if tile_set == null or hex_grid == null:
		return
	var tile_w := float(tile_set.tile_size.x)
	var tile_h := float(tile_set.tile_size.y)
	var natural_width := (hex_grid.width - 1) * 0.75 * tile_w # after the left/right half-hex crops.
	var natural_height := hex_grid.height * tile_h # even columns' full, uncropped extent.
	scale = Vector2(board_pixel_size.x / natural_width, board_pixel_size.y / natural_height)
	position.x = -tile_w * scale.x / 2.0

func _update_debug_overlay() -> void:
	if hex_grid == null:
		return
	clear()
	if not _debug_colors_enabled:
		return
	for coord in hex_grid.get_all_coords():
		var map_coord := _to_map_coord(coord)
		var color_index := posmod(map_coord.x + map_coord.y, DEBUG_COLOR_COUNT)
		set_cell(map_coord, debug_atlas_source_id, Vector2i(color_index, 0))

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
			anchor_x = center.x + tile_set.tile_size.x * (TOP_RIGHT_X_FRACTION - 0.5 - EDGE_COLUMN_LABEL_INSET_FRACTION)
		# The last column is cropped to its left portion (mirrors column A); anchor to the visible top-left corner.
		elif map_coord.x == hex_grid.width - 1:
			anchor_x = center.x - tile_set.tile_size.x * (0.5 - TOP_LEFT_X_FRACTION - EDGE_COLUMN_LABEL_INSET_FRACTION)
		var pos := Vector2(anchor_x - text_size.x / 2.0, top_edge_y + text_size.y)
		draw_string(font, pos, label_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

# Sole place translating sim-core axial coordinates into Godot's TileMapLayer map coordinates.
func _to_map_coord(axial: HexCoord) -> Vector2i:
	return HexUtils.axial_to_offset(axial)
