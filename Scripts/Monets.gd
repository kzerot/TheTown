extends Spatial

func fire(c=4):
	$Particles.amount = c
	$Particles.emitting = true
