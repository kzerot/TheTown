extends TextureButton

tool
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
export (bool) var pursuased = false setget set_pursuased
export (int) var gold = false setget set_gold
export (String) var asset = ""

func set_pursuased(b):
	pursuased = b
	$Money.visible = !b
	$Build.visible = b

func set_gold(b):
	gold = b
	$Money/Count.text = str(b)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resized()

func resized() -> void:
	print("resized")
	if rect_size.y < 150:
		$Money/Count.add_font_override("font", preload("res://Fonts/Big.tres"))
