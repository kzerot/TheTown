extends GridMap
class_name Terrain

signal tapped(vec)

var min_x = 10000
var min_y = 10000
var max_x = -10000
var max_y = -10000
var cells_left = 0
func _ready() -> void:
	pass # Replace with function body.

func get_all():
	var res = []
	for el in get_used_cells():
		res.append(map_to_world(el.x, el.y, el.z))
	return res

func build_field():
	var result = {}
	for el in get_used_cells():
		cells_left += 1
		if el.x > max_x:
			max_x = el.x
		elif el.x < min_x:
			min_x = el.x
		if el.z > max_y:
			max_y = el.z
		elif el.z < min_y:
			min_y = el.z

	for x in range(min_x, max_x+1):
		result[int(x)] = {}
		for y in range(min_y, max_y+1):
			result[int(x)][int(y)] = true

	return result
