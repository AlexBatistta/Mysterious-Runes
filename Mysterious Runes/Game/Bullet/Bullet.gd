extends Area2D

export var speed = 500
export var rotation_speed = 10

func setup(_position, _direction, _type):
	position = _position
	if _direction < 0:
		speed = -speed
		rotation_speed = -rotation_speed
	if _type == "Player":
		$Bullet.modulate = Color("#00c5f4")
	else:
		$Bullet.modulate = Color(1,1,1,1)

func set_speed(_speed, _rotation_speed):
	speed = _speed
	rotation_speed = _rotation_speed

func _process(delta):
	rotation_degrees += rotation_speed
	$Bullet.scale += Vector2(0.001, 0.001)
	position.x += speed * delta

