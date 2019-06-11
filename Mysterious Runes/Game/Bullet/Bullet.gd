extends KinematicBody2D

var speed = 500
var rotation_speed = 10
var velocity = Vector2.ZERO

func setup(_position, _direction, _type, _up_down):
	position = _position
	$Particles2D.emitting = true
	velocity.x = speed
	if _direction < 0:
		velocity.x = -speed
		rotation_speed = -rotation_speed
	if _type == "Player":
		$Bullet.modulate = Color("#00c5f4")
		$Particles2D.modulate = Color("#00c5f4")
		if _up_down: velocity.y = -speed
	else:
		$Bullet.modulate = Color(1,1,1,1)
		if _up_down: velocity.y = speed

func set_speed(_speed, _rotation_speed):
	speed = _speed
	rotation_speed = _rotation_speed

func _process(delta):
	rotation_degrees += rotation_speed
	$Bullet.scale += Vector2(0.001, 0.001)
	move_and_collide(velocity * delta)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
