extends Area2D

var speed = 500
var rotation_speed = 10
var velocity = Vector2.ZERO
var hit_power = 0

func setup(_position, _direction, _type, _up_down, _power):
	position = _position
	$Particles2D.emitting = true
	velocity.x = speed
	hit_power = _power
	if _direction < 0:
		velocity.x = -speed
		rotation_speed = -rotation_speed
	if _type == "Player":
		$Bullet.modulate = Color("#00c5f4")
		$Particles2D.modulate = Color("#00c5f4")
		if _up_down:
			velocity.x /= 2
			velocity.y = -speed
		set_collision_mask_bit(1, true)
		set_collision_mask_bit(3, true)
		set_collision_mask_bit(5, true)
		set_collision_mask_bit(9, true)
	else:
		$Bullet.modulate = Global.color()
		$Particles2D.modulate = Global.color()
		if _up_down:
			velocity.x /= 2
			velocity.y = speed
		set_collision_mask_bit(0, true)

func _process(delta):
	rotation_degrees += rotation_speed
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("Runes") && body.dropped:
		return
	else:
		body._hurt(hit_power)
		queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("Runes") && area.dropped:
		return
	else:
		area._hurt(hit_power)
		queue_free()
