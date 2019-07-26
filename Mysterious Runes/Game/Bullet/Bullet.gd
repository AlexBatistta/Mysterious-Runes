extends Area2D

#Script para la creación de balas del jugador y enemigas

#Variables para el manejo
var speed = 500
var rotation_speed = 10
var velocity = Vector2.ZERO
var hit_power = 0

#Establece las propiedades básicas según el tipo de disparo
func setup(_position, _direction, _type, _up_down, _power):
	position = _position
	
	$Particles2D.emitting = true
	
	velocity.x = speed
	
	#Daño que producirá al impactar
	hit_power = _power
	
	if _direction < 0:
		velocity.x = -speed
		rotation_speed = -rotation_speed
	
	#Dependiendo de quién haya disparado, se cambia el color, se establece
	#la colisión y la velocidad vertical si la tiene
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
		$Bullet.modulate = Color("#e93842")
		$Particles2D.modulate = Color("#e93842")
		if _up_down:
			velocity.x /= 2
			velocity.y = speed
		set_collision_mask_bit(0, true)

func _process(delta):
	#Movimiento de rotación y traslación
	rotation_degrees += rotation_speed
	position += velocity * delta

#Se elimina si sale de la pantalla
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#Colisión con cuerpos
func _on_Bullet_body_entered(body):
	body._hurt(hit_power)
	queue_free()

#Colisión con áreas
func _on_Bullet_area_entered(area):
	if area.is_in_group("Runes") && area.dropped:
		return
	else:
		area._hurt(hit_power)
		queue_free()
