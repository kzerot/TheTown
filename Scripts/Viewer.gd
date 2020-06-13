extends TextureRect

signal pressed(house, angle)

export (PackedScene) var house
export (int) var angle
export (NodePath) var building
func _gui_input(event: InputEvent) -> void:
#	event is InputEventScreenTouch or
	if (event is InputEventMouseButton) and event.pressed:
		emit_signal("pressed", house, angle)

func init():
	if building:
		get_node(building).rotate_y(deg2rad(angle+180))
