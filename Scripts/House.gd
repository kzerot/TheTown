extends StaticBody
class_name House

export (int) var level = 1
var rays : Array = []
var can_build = false
var field = {}

func _ready() -> void:
	rays = $Rays.get_children()
	$AnimationPlayer.connect("animation_finished", self, "anim_end")
	translation.y = 1

func anim_end(anim):
	print("Anim end, ", anim)

func get_collisions():
	var result = []
	for r in rays:
#		r.force_raycast_update()
#		if r.is_colliding():
#			result.append(r.get_collision_point())
		var pos = r.global_transform.origin
		pos.y = 0
		result.append(pos)
	return result

func stop():
	$Visual.translation = Vector3(0,0,0)

func start():
	translation.y = 2
	$AnimationPlayer.play("Start")

func build():
	$AnimationPlayer.play("Build")
	collision_layer= 0

func update_markers(markers):
	for i in $Rays.get_child_count():
		markers[i].translation = $Rays.get_child(i).global_transform.origin
		markers[i].translation.y = 0

func markers_count():
	 return $Rays.get_child_count()

func up():
	if not $AnimationPlayer.current_animation == "Up" and not can_build and translation.y <= 1.1:
		$AnimationPlayer.play("Up")

func down():
	if not $AnimationPlayer.current_animation == "Down" and can_build and translation.y>= 1.9:
		$AnimationPlayer.play("Down")
