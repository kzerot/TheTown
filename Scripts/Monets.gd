extends Spatial

func fire(c=4):
	if  c == 0:
		queue_free()
	else:
		$Particles.amount = c
		$Particles.emitting = true
