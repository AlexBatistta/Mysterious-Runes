tool
extends Area2D

export (bool) var flip = false setget change_orientation

func setup(_position, _flip):
	position = _position
	position.x += 48
	change_orientation(_flip)

func change_orientation(_flip):
	flip = _flip
	if flip:
		$Particles2D.scale.y = -1
		$Particles2D.position.y = -24
		$CollisionShape2D.position.y = 90
		position.y += 96
	else:
		$Particles2D.scale.y = 1
		$Particles2D.position.y = 24
		$CollisionShape2D.position.y = -90

func _on_Geyser_body_entered(body):
	body._geyser($Particles2D.scale.y)
