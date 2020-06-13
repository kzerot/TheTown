extends Control

export (NodePath) var viewport
export (NodePath) var viewers

var game = null

func _ready() -> void:
	load_level()

func load_level(i=-1):
	if i < 1:
		i = Levels.current_level

	# Clean up
	if game and is_instance_valid(game):
		game.queue_free()
	for v in get_node(viewers).get_children():
		if is_instance_valid(v):
			v.get_parent().remove_child(v)
			v.queue_free()

	var res = Levels.get_scene(i)
	for v in res.buildings:
		get_node(viewers).add_child(v)
		v.init()
	game = res.scene
	get_node(viewport).add_child(game)
	game.viewers = get_node(viewers)
	game.init()


func reload() -> void:
	load_level()


func settings() -> void:
	pass # Replace with function body.
