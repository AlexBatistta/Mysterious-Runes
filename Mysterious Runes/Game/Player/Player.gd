extends KinematicBody2D

export var speed = 250
export var gravity = 900
export var jump_speed = 450
export var attack_wait = 1
export var shooting = false
export var jumping = false
export var flying = false

export (PackedScene) var Bullet

var animation = "Idle";
var velocity = Vector2()


func _ready():
	shooting = false
	jumping = false
	flying = false
	pass

func _physics_process(delta):
	if !flying:
		_move(delta)
	else:
		_fly(delta)
	
	_shoot()
	
	_animate()

func _move(delta):
	velocity.y += delta * gravity
	
	var sideX = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	velocity.x = (sideX * (speed * delta)) / delta
	
	if is_on_floor():
		velocity.y = 0
		if !shooting: jumping = false
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_speed
			jumping = true
	elif velocity.y > gravity * delta * 2: jumping = true
	
	if shooting && !jumping: velocity.x = 0
	move_and_slide(velocity, Vector2(0, -1))
	
func _fly(delta):
	$Particles2D.emitting = true
	var sideX = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	var sideY = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	velocity = Vector2(lerp(velocity.x, sideX * speed * delta, delta * 2), lerp(velocity.y, sideY * speed * delta, delta * 2))
	jumping = true
	move_and_collide(velocity)

func _shoot():
	if !shooting && $ShootTimer.is_stopped() :
		if Input.is_action_pressed("shoot"):
			shooting = true

func _spawn_bullet():
	var bullet = Bullet.instance()
	bullet.setup(position + Vector2 (150 * $Sprite.scale.x, -50), $Sprite.scale.x, "Player")
	get_parent().add_child(bullet)
	$ShootTimer.start(attack_wait)
	

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
	

func _on_FlyTimer_timeout():
	flying = false
	$Particles2D.emitting = false
