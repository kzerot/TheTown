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
	if "lines" in res:
		game.lines = res.lines
	game.init()
	game.connect("win", self, "next_level")
	game.connect("restart", self, "reload")
	game.connect("add_money", self, "add_money")

func add_money(c):
	$MainContainer/Panel/Money/Panel/Count.text = \
		str (int($MainContainer/Panel/Money/Panel/Count.text) + c)



func next_level():
	Levels.current_level += 1
	if Levels.current_level > Levels.levels.size():
		print("End of game, level 1")
		Levels.current_level = 1
	load_level()

func reload() -> void:
	load_level()


func settings() -> void:
	pass # Replace with function body.
