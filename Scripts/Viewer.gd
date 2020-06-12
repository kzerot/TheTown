extends ViewportContainer

signal pressed(house)

export (PackedScene) var house

func _gui_input(event: InputEvent) -> void:
#	event is InputEventScreenTouch or
	if (event is InputEventMouseButton) and event.pressed:
		emit_signal("pressed", house)
