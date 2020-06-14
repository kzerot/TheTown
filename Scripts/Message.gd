extends Control


func run(w):
	show()
	$Pivot/Label.text = str(w)
	$AnimationPlayer.play("Run")
