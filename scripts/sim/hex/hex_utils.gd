class_name HexUtils
extends RefCounted

## Axial hex math shared by sim core and presentation. Board is flat-top hexes
## with columns offset vertically (matches Squad Leader's physical hex numbering).

const DIRECTIONS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1),
	Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, 1),
]

static func neighbors(coord: HexCoord) -> Array[HexCoord]:
	var result: Array[HexCoord] = []
	for dir in DIRECTIONS:
		result.append(HexCoord.of(coord.q + dir.x, coord.r + dir.y))
	return result

static func distance(a: HexCoord, b: HexCoord) -> int:
	return int((absi(a.q - b.q) + absi(a.q + a.r - b.q - b.r) + absi(a.r - b.r)) / 2)

# "Odd-q" column offset: odd columns shifted down half a hex.
static func axial_to_offset(axial: HexCoord) -> Vector2i:
	var col := axial.q
	var row := axial.r + int((axial.q - (axial.q & 1)) / 2)
	return Vector2i(col, row)

static func offset_to_axial(offset: Vector2i) -> HexCoord:
	var q := offset.x
	var r := offset.y - int((offset.x - (offset.x & 1)) / 2)
	return HexCoord.of(q, r)

## Board-label helpers (e.g. "X10" = column X, row 10).
## Assumes column-letter + row-number convention; confirm against a real scenario card.
static func to_label(axial: HexCoord) -> String:
	var offset := axial_to_offset(axial)
	return _column_letters(offset.x) + str(offset.y + 1)

static func from_label(label: String) -> HexCoord:
	var i := 0
	while i < label.length() and not label[i].is_valid_int():
		i += 1
	var col := _letters_to_column(label.substr(0, i))
	var row_number := int(label.substr(i))
	return offset_to_axial(Vector2i(col, row_number - 1))

static func _column_letters(col: int) -> String:
	var n := col
	var letters := ""
	while true:
		letters = char(65 + (n % 26)) + letters
		n = n / 26 - 1
		if n < 0:
			break
	return letters

static func _letters_to_column(letters: String) -> int:
	var n := 0
	for c in letters:
		n = n * 26 + (c.unicode_at(0) - 65 + 1)
	return n - 1
