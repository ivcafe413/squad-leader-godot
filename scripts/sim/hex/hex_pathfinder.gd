class_name HexPathfinder
extends RefCounted

## Uniform-cost hex pathfinding stub over a HexGrid, using AStar2D.
## Terrain-cost weighting (MF costs from TerrainData) is a follow-up task.

var _grid: HexGrid
var _astar: AStar2D = AStar2D.new()
var _id_by_coord: Dictionary = {}
var _coord_by_id: Dictionary = {}

func _init(grid: HexGrid) -> void:
	_grid = grid
	_build_graph()

func _build_graph() -> void:
	var coords := _grid.get_all_coords()
	for coord in coords:
		var id := _encode_id(coord)
		_id_by_coord[coord] = id
		_coord_by_id[id] = coord
		_astar.add_point(id, Vector2(coord.q, coord.r))
	for coord in coords:
		var from_id: int = _id_by_coord[coord]
		for neighbor in _grid.get_neighbors(coord):
			var to_id: int = _id_by_coord[neighbor]
			if not _astar.are_points_connected(from_id, to_id):
				_astar.connect_points(from_id, to_id)

func _encode_id(coord: HexCoord) -> int:
	var offset := HexUtils.axial_to_offset(coord)
	return offset.y * _grid.width + offset.x

func get_path(from_coord: HexCoord, to_coord: HexCoord) -> Array[HexCoord]:
	if not _id_by_coord.has(from_coord) or not _id_by_coord.has(to_coord):
		return []
	var id_path := _astar.get_id_path(_id_by_coord[from_coord], _id_by_coord[to_coord])
	var result: Array[HexCoord] = []
	for id in id_path:
		result.append(_coord_by_id[id])
	return result
