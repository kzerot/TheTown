extends Spatial
class_name Marker
const color_blue = Color("a84672f5")
const color_red = Color("a8f81111")
enum COLOR {
	RED, BLUE
}
var colors = {
	COLOR.BLUE : color_blue,
	COLOR.RED : color_red
}

func _ready() -> void:
	set_color(COLOR.BLUE)

func set_color(c):
	$Mesh.material_override.albedo_color = colors[c]
