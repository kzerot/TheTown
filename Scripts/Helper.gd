extends Node

enum COLOR{
	WHITE, BLUE, RED, YELLOW, GREEN
}

var mats = {
	COLOR.WHITE: preload("res://Models/white_texture.material"),
	COLOR.BLUE: preload("res://Models/blue_texture.material"),
	COLOR.RED: preload("res://Models/red_texture.material"),
	COLOR.YELLOW: preload("res://Models/yellow_texture.material"),
	COLOR.GREEN: preload("res://Models/green_texture.material")

}

func set_mats(bld: Spatial, arr):
	for b in bld.get_children():
		if b is MeshInstance:
			for i in b.get_surface_material_count():
				if i >= arr.size():
					return
				b.set_surface_material(i, mats[arr[i]])
