extends Area2D

func _ready():
	pass # Replace with function body.

func _reposition(_direction):
	$AttackDetector.position.x *= _direction
	print(_direction)
	$AttackRayCast.position.x *= _direction
	#$AttackRayCast.cast_to(100 * _direction, 0)

func _on_AttackArea_body_entered(body):
	if body.get_group("Enemy"):
		print("Golpear")
