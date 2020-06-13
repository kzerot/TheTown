extends Node

var current_level = 4

const levels = {
	1: {
		"scene": "3x2",
		"figures": ["L:90:0,0,2", "L:270:0,0,2"],
		"lines": {
			2: 2
		}
	},

	2: {
		"scene": "3x3",
		"figures": ["L:0","H_M:90:2,0,2,0", "2:0:0,2"],
		"lines": {
			2: 3
		}
	},

	3: {
		"scene": "3x3",
		"figures": ["1_A:0","H:90:3,0,0,0", "Z_M:0:0,3,0,3"],
		"lines": {
			3: 3
		}
	},

	4: {
		"scene": "3x3",
		"figures": ["1_A:90","H:180:2,0,0,0", "Z_M:90:0,2,0,2"],
		"lines": {
			3: 3
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
