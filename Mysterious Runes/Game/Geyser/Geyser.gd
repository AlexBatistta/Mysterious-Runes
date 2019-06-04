tool
extends Area2D

export (bool) var flip = false setget change_orientation

func change_orientation(_flip):
	flip = _flip
	if flip:
		$Particles2D.scale.y = -1
		$Particles2D.position.y = -24
		$CollisionShape2D.position.y = 90
	else:
		$Particles2D.scale.y = 1
		$Particles2D.position.y = 24
		$CollisionShape2D.position.y = -90

func _process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		body._geyser($Particles2D.scale.y)
