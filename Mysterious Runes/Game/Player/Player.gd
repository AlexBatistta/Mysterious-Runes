extends KinematicBody2D

export var health = 100
export var speed = 250
export var hit_power = 25
export var jump_speed = 450
export var attack_wait = 1
export var shooting = false
export var power_active = false

export (PackedScene) var Bullet

var animation = "Idle"
var velocity = Vector2()
var direction = Vector2()

var gravity = 900
var maxLife = 0
var jumping = false
var dying = false

func _ready():
	$Sprite/AnimationPlayer.animation_set_next("Fly to Up", "Fly Up")
	$Sprite/AnimationPlayer.animation_set_next("Fly to Down", "Fly Down")
	$Sprite.frame = 0
	maxLife = health
	pass

func _physics_process(delta):
	if !power_active:
		_move(delta)
		_animate()
	
	_shoot()

func _move(delta):
	velocity.y += delta * gravity
	
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	velocity.x = (direction.x * (speed * delta)) / delta
	
	if is_on_floor():
		velocity.y = 0
		if !shooting: jumping = false
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_speed
			jumping = true
	elif velocity.y > gravity * delta * 2: jumping = true
	
	if shooting && !jumping: velocity.x = 0
	move_and_slide(velocity, Vector2(0, -1))

func _animate():
	if velocity.x != 0:
		animation = "Walk"
		$Sprite.scale.x = 0.5 if velocity.x > 0 else -0.5
	else: animation = "Idle"
	
	if jumping: 
		animation = "Jump"
		if velocity.y > 0:
			animation += " End"
	
	if shooting:
		animation = "Shoot"
		if jumping:
			animation += " Jump"
	
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

func _shoot():
	if !shooting && $ShootTimer.is_stopped() :
		if Input.is_action_pressed("shoot"):
			shooting = true

func _spawn_bullet():
	var bullet = Bullet.instance()
	bullet.setup(position + Vector2 (150 * $Sprite.scale.x, -50), $Sprite.scale.x, "Player")
	get_parent().add_child(bullet)
	$ShootTimer.start(attack_wait)

func _hurt(hit):
	if $ImmunityTimer.is_stopped():
		health -= hit
		$ImmunityTimer.start(1)

func rune(power, type):
	power_active = true
	get_parent().get_node("Power").call("_" + power.to_lower())
	if power != "Fly":
		$Sprite/AnimationPlayer.play("Power " + str(type))
		$PowerMagic.emitting = true
		$PowerMagic.rotation_degrees = $Sprite.scale.x * 180 
		$PowerMagic.restart()

func check_life():
	health = clamp(health, 0, maxLife)
	if health == 0:
		dying = true

func _on_Area2D_body_entered(body):
	pass # Replace with function body.
