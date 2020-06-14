extends Control

export (NodePath) var viewport
export (NodePath) var viewers

signal swipe(s)
var game = null
var money = 0
var current_back = "Back0"
func _ready() -> void:
	load_level()

	for c in get_tree().get_nodes_in_group("shop_env"):
		c.connect("pressed", self, "shop", [c])

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
	game.change_back(current_back)
	game.connect("win", self, "next_level")
	game.connect("restart", self, "reload")
	game.connect("add_money", self, "add_money")
	game.connect("sound", self, "sound")

func sound(s):
	get_node(s).stop()
	get_node(s).play()

func add_money(c):
	money += c
	update_money()

func update_money():
	$Panel/Money/Panel/Count.text = str(int(money))



func next_level():
	Levels.current_level += 1
	if Levels.current_level > Levels.levels.size():
		print("End of game, level 1")
		Levels.current_level = 1
	load_level()

func reload() -> void:
	game.is_dragging = false
	load_level()


func settings() -> void:
	game.is_dragging = false
	pass # Replace with function body.


func toggle_sound(b) -> void:
	print("Audio")
	game.is_dragging = false
	AudioServer.set_bus_mute(0, !b)

# Swipe realization and shop
var shop_opened = false
func show_show():
	shop_opened = not shop_opened
	if shop_opened:
		print(			$Shop.rect_position.y)
		print(			$Shop.rect_size.y)
		$ShopTween.interpolate_property(
			$Shop, "rect_position:y",
			$Shop.rect_position.y,
			$Shop.rect_position.y - $Shop.rect_size.y,
			0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		game.stop(true)
		$CloseController.show()
	else:

		$ShopTween.interpolate_property(
			$Shop, "rect_position:y",
			$Shop.rect_position.y,
			$Shop.rect_position.y + $Shop.rect_size.y,
			0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)

	$ShopTween.start()

func shop_change() -> void:
	if not shop_opened:
		game.stop(false)
		$CloseController.hide()

func shop(c):
	if c.pursuased:
		current_back = c.asset
		game.change_back(current_back)
	elif c.gold <= money:
		money -= c.gold
		update_money()
		c.pursuased = true


var touched = false
var points = []
var last_pos = Vector2()
var swipe_handled = true



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		touched = event.pressed
		points = []
		if not touched:
			swipe_handled = true
			check_swipe()

	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if touched and swipe_handled:
			var m = get_global_mouse_position()
			if points.size() == 0 or m.distance_to(points.back()) >= 10:
				points.append(m)
				check_swipe()

func swipe(s):
	match s:
		"left":
			pass
		"right":
			pass

func check_swipe():
	var angles = []
	var prev = null
	var length = 0
	if points.size() < 2:
		return
	for p in points:
		if prev:
			length += p.distance_to(prev)
			var t_angle = rad2deg((p-prev).angle())
			var angle = int(round(t_angle/45)*45)
			if angle == -0:
				angle = 0
			elif angle == -180:
				angle = 180
			if angles.size() == 0:
				angles = [angle]
			elif angles.back() != angle:
				angles.append(angle)
		else:
			prev = p
	var s = get_viewport().size
	if length >= s.x / (2 if s.y > s.x else 6):
		points = []
		swipe_handled = false
		match(angles):
			[0]:
				emit_signal("swipe", "right")
				swipe("right")
			[180]:
				emit_signal("swipe", "left")
				swipe("left")


func resized() -> void:
	$Shop.rect_position.y = get_viewport().size.y


func should_close(event: InputEvent) -> void:
	if event is InputEventMouseButton:

		if shop_opened:
			show_show()
