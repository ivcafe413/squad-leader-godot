class_name HexGrid
extends Resource

## Data-driven board shape (see docs/DATA_DRIVEN_DESIGN.md). One .tres per board,
## e.g. resources/boards/scenario_1_board.tres.

@export var width: int = 0
@export var height: int = 0

func is_in_bounds(coord: HexCoord) -> bool:
	var offset := HexUtils.axial_to_offset(coord)
	return offset.x >= 0 and offset.x < width and offset.y >= 0 and offset.y < height

func get_all_coords() -> Array[HexCoord]:
	var coords: Array[HexCoord] = []
	for row in range(height):
		for col in range(width):
			coords.append(HexUtils.offset_to_axial(Vector2i(col, row)))
	return coords

func get_neighbors(coord: HexCoord) -> Array[HexCoord]:
	var result: Array[HexCoord] = []
	for neighbor in HexUtils.neighbors(coord):
		if is_in_bounds(neighbor):
			result.append(neighbor)
	return result
