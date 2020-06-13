extends Node

var current_level = 1

const levels = {
	1: {
		"scene": "3x2",
		"figures": ["L:180", "L:0"]
	},

	2: {
		"scene": "3x3",
		"figures": ["L:-90","H:0", "2:0"]
	},

	3: {
		"scene": "3x3",
		"figures": ["1:0","H_M:0", "Z_M:0"]
	},

	4: {
		"scene": "4x4",
		"figures": ["L:180","L:180","2:90", "H_M:0", "T:-90"]
	},

	5: {
		"scene": "4x4",
		"figures": ["1:0", "H:90", "T:180", "L:180", "2:0", "2:0"]
	}
}

func get_scene(lvl=1):
	var scene = load("res://Scenes/Levels/Game%s.tscn" % levels[lvl].scene).instance()
	var figures = levels[lvl].figures
	var buildings = []
	for f in figures:
		var s = f.split(":")
		var bld = load("res://Scenes/Viewers/House%s.tscn" % s[0]).instance()
		bld.angle = int(s[1])
		buildings.append(bld)
	return {"scene" : scene, "buildings": buildings}
