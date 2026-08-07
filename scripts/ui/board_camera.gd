class_name BoardCamera
extends Camera2D

## Mouse wheel zooms toward the cursor; middle-mouse drag pans.

@export var zoom_step: float = 1.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 4.0

var _panning := false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_at(zoom_step)
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_at(1.0 / zoom_step)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			_panning = event.pressed
	elif event is InputEventMouseMotion and _panning:
		position -= event.relative / zoom

# Rescales around the cursor so the point under it stays fixed on screen.
func _zoom_at(factor: float) -> void:
	var new_zoom: Vector2 = (zoom * factor).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	if new_zoom.is_equal_approx(zoom):
		return
	var before := get_global_mouse_position()
	zoom = new_zoom
	var after := get_global_mouse_position()
	position += before - after
