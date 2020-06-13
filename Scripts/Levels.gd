extends Node

var current_level = 1

const levels = {
	1: {
		"scene": "4x4",
		"figures": ["1:0", "H:90", "Z:-90", "1:0", "H:0", "Z:180"]
	},

	2: {
		"scene": "4x4",
		"figures": ["H:90", "Z:180", "Z:-90", "1:0", "1:0", "H:0"]
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
