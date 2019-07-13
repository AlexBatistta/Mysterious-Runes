extends KinematicBody2D

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
	pass

func _spawn():
	$Sprite.modulate = Color(0, 0, 0, 0)
	visible = true
	$Sprite/AnimationPlayer.play("Spawn")
	set_physics_process(false)

func _physics_process(delta):
	if shooting && Input.is_action_pressed("move_up"): shootUp = true
	
	_move(delta)
	_animate()
	_camera()

func _input(event):
	if $ShootTimer.is_stopped() && event.is_action_pressed("shoot"):
		shooting = true

func _move(delta):
	snap = Vector2(0, 32)
	
	velocity.y += delta * GRAVITY
	
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	velocity.x = direction.x * SPEED
	
	if is_on_floor():
		velocity.y = 0
		if Input.is_action_pressed("jump"):
			velocity.y = -JUMP_SPEED
			snap = Vector2.ZERO
			$PlayerSounds.stream = load("res://Sound/Jump.ogg")
			$PlayerSounds.play()
	
	if shooting && is_on_floor(): velocity.x = 0
	
	if direction.x != 0: change_direction()
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1))
	
	if direction.x == 0: prev_pos_x = position.x

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
	
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

func _shoot():
	if $ShootTimer.is_stopped():
		var bullet = Bullet.instance()
		$BulletSpawn.position.x = abs($BulletSpawn.position.x) * ($Sprite.scale.x * 2)
		
		bullet.setup(position + $BulletSpawn.position, $Sprite.scale.x, "Player", shootUp, hit_power)
		get_parent().add_child(bullet)
		
		$ShootTimer.start(ATTACK_WAIT)
		
		$PlayerSounds.stream = load("res://Sound/Shoot.ogg")
		$PlayerSounds.play()

func _camera():
	if prev_pos_x != position.x:
		emit_signal("fix_camera", false)
	else:
		emit_signal("fix_camera", true)

func _hurt(hit, _river = false):
	if $ImmunityTimer.is_stopped():
		health -= hit
		emit_signal("change_life", health)
		hurting = true
		
		if !_river: $ImmunityTimer.start(IMMUNITY)
		else: $ImmunityTimer.start(IMMUNITY * 5)
		
		$PlayerSounds.stream = load("res://Sound/Hurt.ogg")
		$PlayerSounds.play()

func rune(power, _type = 0):
	rune_type = _type
	power_rune = true
	
	Global.rune_active = true
	
	if rune_type == 1:
		Global.levelKey = true
		
	$Power.call("_" + power.to_lower())
	$PowerMagic.emitting = true
	$PowerMagic.restart()
	
	if power == "Fly":
		set_physics_process(false)
		emit_signal("fix_camera", false)

func check_life():
	health = ceil(health)
	health = clamp(health, 0, maxLife)
	if health == 0:
		return true

func _river(_active, _top = 0, _damage = 0):
	$Power._swim(_active, _top, _damage)
	set_physics_process(!_active)

func _geyser(_orientation):
	velocity.y = -JUMP_SPEED * 2 * _orientation
	move_and_slide(velocity, Vector2(0, -1))
	
	$PlayerSounds.stream = load("res://Sound/Geyser.ogg")
	$PlayerSounds.play()

func change_direction():
	$Sprite.scale.x = abs($Sprite.scale.x) * direction.x
	$Power/Shield.scale.x = abs($Power/Shield.scale.x) * direction.x 

func _die():
	Global.change_menu("MenuLose")
	health = maxLife

func _portal():
	Global.rune_active = false
	$Power/RuneActive._on_RuneTimer_timeout()
	set_process_input(false)
	$Sprite/AnimationPlayer.play_backwards("Spawn")
	set_physics_process(false)

func _on_Player_visibility_changed():
	set_process_input(visible)

func _on_VisibilityNotifier2D_screen_exited():
	if Global.current_menu == "Game": _die()
