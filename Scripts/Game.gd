extends Spatial

var terrain : Terrain
var selected = null
var camera
var markers = []
var field = {}
export (NodePath) var n_viewer
var viewers : HBoxContainer
var click = 0
var last_pos : Vector3

func _ready() -> void:
	$DirectionalLight.shadow_enabled = !OS.has_feature('JavaScript')
	viewers = get_node(n_viewer)
	# Generate 5 markers
	for i in 5:
		var marker = preload("res://Scenes/Marker.tscn").instance()
		$Markers.add_child(marker)
#		marker.hide()
		markers.append(marker)
	# Пока берем дефолтный, потом будем подгружать
	camera = get_viewport().get_camera()
	terrain = $Terrain
	field = terrain.build_field()
	terrain.connect("tapped", self, "terrain_tapped")
#	if viewers.get_child_count() > 0:
#	for i in viewers.get_child_count():
#		viewers.get_child(i).connect("pressed", self, "viewer_tap", [viewers.get_child(i)])
	house_built()

func _process(delta: float) -> void:
	if selected:
		click += delta
		# Старый код, который позволяет ДЕРЖАТЬ
#		if not selected.state == House.STATE.PREPARE and click >= 0.2 and\
#				selected.can_build and \
#				last_pos == terrain.world_to_map(selected.translation):
#			selected.prepare()
#			print("prepare")

func terrain_tapped(vec : Vector3, real: Vector3):
	print("Terrain coordinates: ", vec)
	print("Global coordinates: ", real)


func viewer_tap(h_inst: PackedScene, view) -> void:
	if selected:
		return
	for c in $Houses.get_children():
		if c.state != House.STATE.BUILT:
			return
	print("Viewer")
	var house : House = h_inst.instance()
	$Houses.add_child(house)
	update_markers(house.markers_count())
	view.queue_free()
	to_grid(house, Vector3(0,0,0))
	check(house)
	house.connect("build", self, "build")
	house.connect("built", self, "house_built")
	house.start()

func pick(mask=1):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 1000
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(from, to, [], mask)

func house_built():
	if viewers.get_child_count() == 0:
		print("Win!")
		return
	var next = viewers.get_child(0)
	var house : House = next.house.instance()
	$Houses.add_child(house)
	update_markers(house.markers_count())
	to_grid(house, Vector3(0,0,0))
	check(house)
	house.connect("build", self, "build")
	house.connect("built", self, "house_built")
	house.start()
	next.queue_free()


func build():
	var position = terrain.world_to_map(selected.translation)
	clamp_pos(position)
	var can_build = can_build()
	if can_build:
		selected.build()
		for c in selected.get_collisions():
			var w = terrain.world_to_map(c)
			field[int(w.x)][int(w.z)] = false
		update_markers(0)
	selected = null

# warning-ignore:unused_argument
func _input(event):
#	event is InputEventScreenTouch or
	if (event is InputEventMouseButton):

		if event.pressed:
			var result = pick(3)
			if result:
				if result.collider == terrain:
					var position = terrain.world_to_map(result.position)
					terrain_tapped(position, result.position)
				elif result.collider is House:
					print(result.collider.name)
					selected = result.collider
					selected.stop()
					selected.update_markers(markers)
					click = 0
		else:
			var result_house = pick(2)
			var result = pick(1)
			if selected:
				selected.stop()
#			if result_house and click <= 0.5 and result_house.collider is House and selected:
#				selected.rotate_y(deg2rad(90))
#				check()
			if result and result.collider == terrain and selected:
				var position = terrain.world_to_map(result.position)
				clamp_pos(position)
				terrain_tapped(position, result.position)
				var can_build = can_build()
				if can_build and selected.state != House.STATE.PREPARE:
					selected.build()
					for c in selected.get_collisions():
						var w = terrain.world_to_map(c)
						field[int(w.x)][int(w.z)] = false
					update_markers(0)
				else:
					check()
			selected = null
#	 or event is InputEventScreenDrag
	elif event is InputEventMouseMotion:
		if selected:
			var result = pick(1)
			if result and result.collider == terrain:
				var current_pos = to_grid(selected, result.position)
				if last_pos != current_pos:
					last_pos =  current_pos
					click = 0
					check()

func check(force=null):
	if not force:
		force = selected
	if force:
		force.can_build = can_build(force)
		force.update_markers(markers)
		force.stop()
		if force.can_build:
			force.down()
		else:
			force.up()

func can_build(force=null):
	if not force:
		force = selected
	assert(force)
	for coor in force.get_collisions():
		var w = terrain.world_to_map(coor)
		var a = int(w.x) in field
		var b = int(w.z) in field[int(w.x)] if a else false

		if not a or not b or not field[int(w.x)][int(w.z)]:
			force.can_build = false
			return false
	force.can_build = true
	return true

func update_markers(count):
	for i in markers.size():
		markers[i].visible = i < count

func to_grid(obj: Spatial, pos: Vector3):
	var coor = terrain.world_to_map(pos)
	coor = clamp_pos(coor)
	var coor_span = terrain.map_to_world(coor.x, coor.y, coor.z)
	obj.translation.x = coor_span.x
	obj.translation.z = coor_span.z

	return coor

func clamp_pos(coor):
	coor.x =  clamp(coor.x, terrain.min_x,  terrain.max_x)
	coor.z =  clamp(coor.z, terrain.min_y,  terrain.max_y)
	return coor
