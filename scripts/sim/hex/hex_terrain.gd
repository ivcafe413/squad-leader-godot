class_name HexTerrain
extends Resource

## Per-scenario terrain layout: one row string per board row, one TerrainData
## `code` character per hex/column, matching HexUtils offset (col, row) order.

@export var rows: Array[String] = []
@export var legend: Dictionary[String, TerrainData] = {}

func get_terrain(coord: HexCoord) -> TerrainData:
	var offset := HexUtils.axial_to_offset(coord)
	if offset.y < 0 or offset.y >= rows.size():
		return null
	var row := rows[offset.y]
	if offset.x < 0 or offset.x >= row.length():
		return null
	return legend.get(row[offset.x])
