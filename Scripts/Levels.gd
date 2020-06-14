extends Node

var current_level = 1

const levels = {
	1: {
		"scene": "3x2",
		"figures": ["L:90:0,0,2", "L:270:0,0,2"],
		"lines": {
			2: 1
		}
	},

	2: {
		"scene": "3x3",
		"figures": ["L:0","H_M:90:4,0,4,0", "2:0:0,4"],
		"lines": {
			4: 1
		}
	},

	3: {
		"scene": "3x3",
		"figures": ["1_A:0","H:90:3,0,0,0", "Z_M:0:0,3,0,3"],
		"lines": {
			3: 1
		}
	},


	4: {
		"scene": "3x4lvl7",
		"figures": ["H:270:1,0,1,1","H:90:0,0,0,0", "3:90:1,0,0,0"],
		"lines": {
			1: 1
		}
	},
}

func get_scene(lvl=1):
	var scene = load("res://Scenes/Levels/Game%s.tscn" % levels[lvl].scene).instance()
	var figures = levels[lvl].figures
	var buildings = []

	for f in figures:
		var colors = [0,0,0,0]
		var s = f.split(":")
		var bld = load("res://Scenes/Viewers/House%s.tscn" % s[0]).instance()
		bld.angle = int(s[1])
		buildings.append(bld)
		if s.size() > 2:
			var i = 0
			for c in s[2].split(","):
				colors[i] = int(c)
				i += 1
		bld.colors = colors
	if not "lines" in levels[lvl]:
		return {"scene" : scene, "buildings": buildings}
	return {"scene" : scene, "buildings": buildings, "lines": levels[lvl].lines}
