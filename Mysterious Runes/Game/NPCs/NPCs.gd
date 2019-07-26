extends KinematicBody2D

#Script que controla todos los diferentes tipos de NPCs instanciados

const GRAVITY = 900
const IMMUNITY = 0.5
const JUMP_SPEED = 600
const SPEED = 150
const DESPAWN = 5

export (Array, int) var SetHealth = [50, 75, 75, 100, 150, 200]
export (Array, int) var SetHitPower = [5, 10, 15, 20, 25, 30]
export (PackedScene) var Bullet
export var shooting = false
export var hurting = false

signal spawn_invoked

var animation = "Spawn"
var velocity = Vector2()
var direction = 1
var spawning = true
var health = 0
var hit_power = 0
var type
var paralyze = false
var custom_speed = 0
var rune = false

#Establece el tipo de NPC a crear y la posición
func setup(_type, _position):
	type = _type
	position = _position
	
	#NPCs enemigos
	if type >= 0:
		#Textura y color
		$SpriteBody.texture = load("res://Game/NPCs/SpriteBody/NPC-0" + str(type + 1) + ".png")
		$SpriteColor.texture = load("res://Game/NPCs/SpriteColor/NPC-0" + str(type + 1) + ".png")
		$SpriteColor.modulate = Global.color()
		
		#Establece la vida y la fuerza de ataque según su tipo
		health = SetHealth[type]
		hit_power = SetHitPower[type]
		
		#Conecta la señal para los poderes del jugador
		$RuneActive.connect("power_out", self, "_power_out")
		
		#Acciona el poder activo si lo está
		if Global.rune_active: _rune_active()
	
	#NPCs invocados por el jugador
	else:
		#Textura
		$SpriteBody.texture = load ("res://Game/NPCs/Invoked.png")
		$SpriteColor.texture = null
		
		#Vida y fuerza de ataque
		health = 100
		hit_power = 10

func _ready():
	#Velocidad especial
	custom_speed = 0.5
	
	#Colisión de los NPCs invocados
	if type == -1:
		set_collision_layer_bit(0, true)
		$AttackArea.set_collision_mask_bit(1, true)
		$AttackArea/AttackRayCast.set_collision_mask_bit(1, true)
	
	#Colisión de los NPCs enemigos
	else:
		set_collision_layer_bit(1, true)
		$AttackArea.set_collision_mask_bit(0, true)
		$AttackArea/AttackRayCast.set_collision_mask_bit(0, true)
	
	#Personalización del rango de ataque
	if type >= 3:
		$AttackArea/AttackRayCast.position = Vector2(140, -50)
	else:
		$AttackArea/AttackRayCast.position = Vector2(40, -50)
	
	#Personalización del NPC volador, utiliza el RayCast de ataque
	#para medir su altura según el suelo
	if type == 2:
		$AttackArea/AttackRayCast.cast_to = Vector2(0, 350)
		$AttackArea/AttackRayCast.position = Vector2.ZERO
		$AttackArea/AttackRayCast.set_collision_mask_bit(0, false)
		$AttackArea/AttackRayCast.set_collision_mask_bit(2, true)
		$RayCast2D.cast_to = Vector2(20, 0)
		$RayCast2D.position = Vector2(40, -25)
	
	#Inicia el contador para invocar si es un NPC jefe
	if type == 5:
		$InvokerTimer.start(7)
	
	#Valores de la barra de vida
	$LifeBar.max_value = health
	$LifeBar.value = health

func _physics_process(delta):
	#Cambia de dirección si colisiona
	if !spawning && type != 2:
		if is_on_wall() || !$RayCast2D.is_colliding():
			_change_direction()
	
	if health > 0 && !paralyze:
		#Ataca si el jugador se encuentra en el area
		if !spawning && type != 2:
			if $AttackArea/AttackRayCast.is_colliding() && $AttackTimer.is_stopped():
				$AttackTimer.start(4)
				shooting = true
		
		#Movimiento
		_move(delta)
		
		#Acciones personalizadas por tipo de NPC
		if type == 2: _magic_flyer()
		if type == 5: _invoker_boss()
	else:
		#warning-ignore:integer_division
		velocity = Vector2(0, GRAVITY / 3)
	
	move_and_slide(velocity, Vector2(0, -1))
	
	#Herida por poder activo
	if Global.power_rune == "Poison": _hurt(5)
	
	#Animación
	_animate()

#Movimiento básico
func _move(delta):
	
	velocity.y += delta * GRAVITY
	
	velocity.x = direction * (SPEED * custom_speed)
	
	if shooting || hurting: velocity.x = 0

#Ataque según el tipo
func _shoot():
	if type >= 3:
		#Instancia la bala y la agrega a la escena
		var bullet = Bullet.instance()
		var _position = position + $AttackArea/AttackDetector.position 
		bullet.setup(_position, $SpriteBody.scale.x, "NPC", false, hit_power)
		get_parent().add_child(bullet)
		
		#Sonido de disparo
		$NPCSound.stream = load("res://Sound/Shoot.ogg")
	else:
		#Habilita el área de ataque cuerpo a cuerpo
		$AttackArea/AttackDetector.disabled = false
		
		#Sonido de ataque cuerpo a cuerpo
		$NPCSound.stream = load("res://Sound/Attack.ogg")
	
	if type == 2:
		var _position = position - Vector2(0, 50)
		
		#Instancia dos balas y las agrega a la escena
		var bullet_01 = Bullet.instance()
		bullet_01.setup(_position, $SpriteBody.scale.x, "NPC", true, hit_power)
		get_parent().add_child(bullet_01)
		
		var bullet_02 = Bullet.instance()
		bullet_02.setup(_position, -$SpriteBody.scale.x, "NPC", true, hit_power)
		get_parent().add_child(bullet_02)
		
		#Sonido de disparo
		$NPCSound.stream = load("res://Sound/Shoot.ogg")
	
	#Reproduce el sonido
	$NPCSound.play()

#Acción personalizada del tipo volador
func _magic_flyer():
	if type == 2:
		if spawning:
			#Distancia con el suelo
			if $AttackArea/AttackRayCast.is_colliding():
				velocity.y = -(SPEED * custom_speed)
			else:
				spawning = false
		else: velocity.y = 0
	
	#Ataque
	if $AttackTimer.is_stopped():
		$AttackTimer.start(4)
		shooting = true
	
	#Cambio de dirección
	if $RayCast2D.is_colliding():
		_change_direction()

#Acción personalizada del tipo jefe
func _invoker_boss():
	#Emite señal para crear dos NPCs enemigos
	if $InvokerTimer.is_stopped():
		shooting = true
		$InvokerTimer.start(Global.TIME_POWER)
		emit_signal("spawn_invoked", position)

#Animación
func _animate():
	if spawning:
		animation = "Spawn"
		if is_on_floor():
			spawning = false
			if !rune:
				custom_speed = 1
	else:
		if velocity.x != 0:
			animation = "Run"
			$SpriteBody.scale.x = 0.5 if velocity.x > 0 else -0.5
			$SpriteColor.scale.x = 0.5 if velocity.x > 0 else -0.5
		else: animation = "Idle"
		
		if shooting:
			animation = "Attack"
		else:
			$AttackArea/AttackDetector.disabled = true
	
	if hurting:
		animation = "Hurt"
		if health <= 0:
			animation = "Die"
	
	#Comprueba si la animación a reproducir es diferente a la actual
	if animation != $AnimationPlayer.current_animation:
		$AnimationPlayer.play(animation)

#Cambia de dirección
func _change_direction():
	direction *= -1
	$RayCast2D.position.x *= -1
	$AttackArea/AttackDetector.position.x *= -1
	$AttackArea/AttackRayCast.position.x *= -1
	$AttackArea/AttackRayCast.cast_to.x *= -1

#Disminuye la vida según el poder del golpe
func _hurt(hit):
	if $ImmunityTimer.is_stopped():
		health -= hit
		$LifeBar.value -= hit
		
		hurting = true
		
		#Inmunidad
		$ImmunityTimer.start(IMMUNITY)
		if Global.power_rune == "Poison":
			$ImmunityTimer.start(IMMUNITY * 4)
		
		#Demora el ataque
		$AttackTimer.start($AttackTimer.time_left + 1)
		
		#Sonido de herida
		$NPCSound.stream = load("res://Sound/Hurt.ogg")
		$NPCSound.play()

#Acción del geiser hacia el NPC
func _geyser(_orientation):
	if health > 0:
		#Impulsa hacia arriba
		velocity.y = -JUMP_SPEED * 2 * _orientation
		velocity.x = 0
		
		shooting = false
		spawning = true
		#Demora el ataque
		$AttackTimer.start($AttackTimer.time_left + 1)
		
		#Sonido del geiser
		$NPCSound.stream = load("res://Sound/Geyser.ogg")
		$NPCSound.play()

#Acción del poder del jugador
func _rune_active():
	if Global.power_rune == "Poison":
		_hurt(5)
		rune = true
	
	if Global.power_rune == "Paralyze":
		paralyze = true
		rune = true
	
	if Global.power_rune == "Slow":
		$AnimationPlayer.playback_speed = 0.75
		custom_speed = 0.5
		if type == 2: custom_speed = 0.25
		rune = true
	
	if rune: $RuneActive._set_power()

#Normaliza cuando termina el tiempo del poder
func _power_out():
	match Global.power_rune:
		"Paralyze":
			paralyze = false
		"Slow":
			$AnimationPlayer.playback_speed = 1
			custom_speed = 1
			if type == 2: custom_speed = 0.5
	Global.power_rune = ""

#Elimina al NPC si pasa un tiempo fuera de pantalla
func _on_VisibilityNotifier2D_screen_exited():
	$DespawnTimer.start(DESPAWN)

func _on_DespawnTimer_timeout():
	if !$VisibilityNotifier2D.is_on_screen():
		queue_free()

#Hiere al jugador cuando ataca cuerpo a cuerpo
func _on_AttackArea_body_entered(body):
	body._hurt(hit_power)
