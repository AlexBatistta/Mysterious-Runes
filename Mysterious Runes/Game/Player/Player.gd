extends KinematicBody2D

signal change_life

const gravity = 900
const attack_wait = 1

export var health = 100
export var speed = 200
export var hit_power = 25
export var jump_speed = 450

export var shooting = false
export var shootUp = false
export var hurting = false
export var wait = true
export var power_active = false

export (PackedScene) var Bullet

var animation = "Idle"
var velocity = Vector2()
var direction = Vector2()
var currentDirection = 0
var maxLife = 0
var snap = Vector2(0, 32)
var portal = false

func _ready():
	$Sprite/AnimationPlayer.animation_set_next("Fly to Up", "Fly Up")
	$Sprite/AnimationPlayer.animation_set_next("Fly to Down", "Fly Down")
	$Sprite.frame = 0
	maxLife = health
	pass

func _spawn():
	$Sprite.modulate = Color(0, 0, 0, 0)
	visible = true
	wait = true
	$Sprite/AnimationPlayer.play("Spawn")

func _physics_process(delta):
	if !power_active:
		_move(delta)
		if !portal:
			_animate()
		else:
			$Sprite/AnimationPlayer.play_backwards("Spawn")
	
	if !wait:
		if $ShootTimer.is_stopped() && Input.is_action_pressed("shoot"):
			shooting = true
			if Input.is_action_pressed("move_up"): shootUp = true
			else: shootUp = false

func _move(delta):
	snap = Vector2(0, 32)
	
	velocity.y += delta * gravity
	
	if !wait:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		velocity.x = direction.x * speed
		
		if is_on_floor():
			velocity.y = 0
			if Input.is_action_pressed("jump"):
				velocity.y = -jump_speed
				snap = Vector2.ZERO
		
		if shooting && is_on_floor(): velocity.x = 0
		
		if direction.x != 0: change_direction()
	else:
		velocity.x = 0
		$Sprite.frame = 0
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1))

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
		elif shootUp:
			animation += " Up"
	
	if hurting:
		animation = "Hurt"
		if check_life():
			animation = "Die"
	
	if wait:
		animation = "Spawn"
	
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

func _shoot():
	if $ShootTimer.is_stopped():
		var bullet = Bullet.instance()
		$BulletSpawn.position.x = abs($BulletSpawn.position.x) * ($Sprite.scale.x * 2)
		bullet.setup(position + $BulletSpawn.position, $Sprite.scale.x, "Player", shootUp, hit_power)
		get_parent().add_child(bullet)
		$ShootTimer.start(attack_wait)

func _hurt(hit):
	if $ImmunityTimer.is_stopped():
		health -= hit
		emit_signal("change_life", health)
		$ImmunityTimer.start(2)
		hurting = true

func rune(power, type):
	power_active = true
	if type == 1:
		Global.levelKey = true
	$Power.call("_" + power.to_lower())
	$PowerMagic.emitting = true
	$PowerMagic.restart()
	if power != "Fly":
		$Sprite/AnimationPlayer.play("Power " + str(type))

func check_life():
	health = ceil(health)
	health = clamp(health, 0, maxLife)
	if health == 0:
		return true

func _river(_active, _top = 0, _damage = 0):
	power_active = _active
	$Power._swim(_active, _top, _damage)

func _geyser(_orientation):
	velocity.y = -600 * _orientation
	move_and_slide(velocity, Vector2(0, -1))

func change_direction():
	$Sprite.scale.x = abs($Sprite.scale.x) * direction.x
	$Power/Shield.scale.x = abs($Power/Shield.scale.x) * direction.x 

func _die():
	Global.change_menu("MenuLose")
	health = maxLife

func _on_Player_visibility_changed():
	set_process_input(visible)
