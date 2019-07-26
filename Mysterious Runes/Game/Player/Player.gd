extends KinematicBody2D

#Script que controla al personaje del jugador

signal change_life
signal fix_camera

const GRAVITY = 900
const ATTACK_WAIT = 0.5
const IMMUNITY = 0.5
const SPEED = 200
const JUMP_SPEED = 600

export var health = 100
export var hit_power = 25

export var shooting = false
export var shootUp = false
export var hurting = false
export var power_rune = false

export (PackedScene) var Bullet

var animation = "Idle"
var velocity = Vector2()
var direction = Vector2()
var currentDirection = 0
var maxLife = 0
var snap = Vector2(0, 32)
var rune_type = 0
var prev_pos_x

func _ready():
	$Sprite/AnimationPlayer.animation_set_next("Fly to Up", "Fly Up")
	$Sprite/AnimationPlayer.animation_set_next("Fly to Down", "Fly Down")
	$Sprite.frame = 0
	maxLife = health

#Aparición del personaje en escena
func _spawn():
	#Se transparenta
	$Sprite.modulate = Color(0, 0, 0, 0)
	
	visible = true
	
	#Animación de aparición
	$Sprite/AnimationPlayer.play("Spawn")
	
	set_physics_process(false)

func _physics_process(delta):
	#Controla si dispara hacia arriba
	if shooting && Input.is_action_pressed("move_up"): shootUp = true
	
	#Movimiento
	_move(delta)
	
	#Animación
	_animate()
	
	#Control de cámara
	_camera()

func _input(event):
	#Ataque
	if $ShootTimer.is_stopped() && event.is_action_pressed("shoot"):
		shooting = true

#Movimiento
func _move(delta):
	#Se "pega" al suelo
	snap = Vector2(0, 32)
	
	velocity.y += delta * GRAVITY
	
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = direction.x * SPEED
	
	#Si está en el suelo se habilita el salto
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			#Impulso hacia arriba
			velocity.y = -JUMP_SPEED
			
			#Se "despega" del suelo
			snap = Vector2.ZERO
			
			#Sonido de salto
			$PlayerSounds.stream = load("res://Sound/Jump.ogg")
			$PlayerSounds.play()
	
	if shooting && is_on_floor(): velocity.x = 0
	
	#Comprueba el cambio de dirección
	if direction.x != 0: change_direction()
	
	#Aplica la velocidad
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1))
	
	#Variable auxiliar para el movimiento de la cámara
	if direction.x == 0: prev_pos_x = position.x

#Animación
func _animate():
	if velocity.x != 0:
		animation = "Walk"
	else: animation = "Idle"
	
	if !is_on_floor(): 
		animation = "Jump"
		if velocity.y > 0:
			animation = "Fall"
	
	if shooting:
		animation = "Shoot"
		if !is_on_floor():
			animation += " Jump"
			shootUp = false
		if shootUp:
			animation += " Up"
	
	if power_rune:
		animation = "Power"
		if rune_type > 0:
			animation += " Key"
	
	if hurting:
		animation = "Hurt"
		if check_life():
			animation = "Die"
	
	#Comprueba si la animación a reproducir es diferente a la actual
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

#Ataque si se cumplió el tiempo de cooldown
func _shoot():
	if $ShootTimer.is_stopped():
		#Instancia la bala
		var bullet = Bullet.instance()
		$BulletSpawn.position.x = abs($BulletSpawn.position.x) * ($Sprite.scale.x * 2)
		
		#Establece las propiedades y la agrega a escena
		bullet.setup(position + $BulletSpawn.position, $Sprite.scale.x, "Player", shootUp, hit_power)
		get_parent().add_child(bullet)
		
		#Inicia el tiempo de espera
		$ShootTimer.start(ATTACK_WAIT)
		
		#Sonido de disparo
		$PlayerSounds.stream = load("res://Sound/Shoot.ogg")
		$PlayerSounds.play()

#Funcionamiento de la cámara, emite una señal para fijarla o no
#dependiendo de si el personaje se mueve por acción del jugador o no
func _camera():
	if prev_pos_x != position.x:
		emit_signal("fix_camera", false)
	else:
		emit_signal("fix_camera", true)

#Disminuye la vida según el poder del golpe
func _hurt(hit, _river = false):
	if $ImmunityTimer.is_stopped():
		health -= hit
		hurting = true
		
		#Señal para el cambio en la barra de vida
		emit_signal("change_life", health)
		
		#Inmunidad
		if !_river: $ImmunityTimer.start(IMMUNITY)
		else: $ImmunityTimer.start(IMMUNITY * 5)
		
		#Sonido de herida
		$PlayerSounds.stream = load("res://Sound/Hurt.ogg")
		$PlayerSounds.play()

#Acción de la runa
func rune(power, _type = 0):
	rune_type = _type
	power_rune = true
	velocity.x = 0
	
	#Activa la runa a nivel global
	Global.rune_active = true
	
	#Si es del tipo permanente, se desbloque el portal de salida
	if rune_type == 1:
		Global.levelKey = true
	
	#Acción del poder
	$Power.call("_" + power.to_lower())
	$PowerMagic.emitting = true
	$PowerMagic.restart()
	
	#Desactiva el proceso de fisica y la fijación de la cámara
	if power == "Fly":
		set_physics_process(false)
		emit_signal("fix_camera", false)

#Comprueba la vida restante
func check_life():
	health = ceil(health)
	health = clamp(health, 0, maxLife)
	if health == 0:
		return true

#Acción del río, se obtiene si entra o sale, la altura y el daño que produce
func _river(_active, _top = 0, _damage = 0):
	$Power._swim(_active, _top, _damage)
	set_physics_process(!_active)

#Acción del geiser
func _geyser(_orientation):
	#Impulsa hacia arriba
	velocity.y = -JUMP_SPEED * 2 * _orientation
	move_and_slide(velocity, Vector2(0, -1))
	
	#Sonido del geiser
	$PlayerSounds.stream = load("res://Sound/Geyser.ogg")
	$PlayerSounds.play()

#Cambio de dirección
func change_direction():
	$Sprite.scale.x = abs($Sprite.scale.x) * direction.x
	$Power/Shield.scale.x = abs($Power/Shield.scale.x) * direction.x 

#Muerte
func _die():
	#Cambia al menú de juego perdido
	Global.change_menu("MenuLose")
	
	#Reestablece la vida
	health = maxLife

#Acción del portal
func _portal():
	#Reestablece parámetros
	Global.rune_active = false
	$Power/RuneActive._on_RuneTimer_timeout()
	
	#Reproduce en reversa la animación de aparición
	$Sprite/AnimationPlayer.play_backwards("Spawn")
	
	#Deshabilita el input y el proceso de fisica
	set_process_input(false)
	set_physics_process(false)

#Habilita el ataque dependiendo su visibilidad
func _on_Player_visibility_changed():
	set_process_input(visible)

#Si sale de pantalla en modo de juego, se elimina
func _on_VisibilityNotifier2D_screen_exited():
	if Global.current_menu == "Game": _die()
