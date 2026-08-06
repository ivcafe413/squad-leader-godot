class_name HexCoord
extends RefCounted

## Axial hex coordinate (q, r). Interned so any two coords with the same q/r are
## the same instance, giving correct equality/hashing when used as Dictionary keys.

var q: int
var r: int

static var _cache: Dictionary = {}

static func of(q: int, r: int) -> HexCoord:
	var key := Vector2i(q, r)
	var cached := _cache.get(key) as HexCoord
	if cached == null:
		cached = HexCoord.new()
		cached.q = q
		cached.r = r
		_cache[key] = cached
	return cached

func add(other: HexCoord) -> HexCoord:
	return HexCoord.of(q + other.q, r + other.r)

func _to_string() -> String:
	return "(%d, %d)" % [q, r]
