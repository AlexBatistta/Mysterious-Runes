extends KinematicBody2D

export var speed = 250
export var gravity = 900
export var jump_speed = 450
export var attack_wait = 1
export var shooting = false
export var jumping = false
export var flying = false
export var animation = "Idle";

export (PackedScene) var Bullet


var velocity = Vector2()
var direction = Vector2()

func _ready():
	$Sprite/AnimationPlayer.animation_set_next("Fly to Up", "Fly Up")
	$Sprite/AnimationPlayer.animation_set_next("Fly to Down", "Fly Down")
	pass

func _physics_process(delta):
	if !flying:
		_move(delta)
		_shoot()
		_animate()
	else:
		_fly(delta)
	
	if Input.is_key_pressed(KEY_B) && !flying:
		_active_fly()

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

func _active_fly():
	flying = true;
	$FlyTimer.start(10)
	$Particles2D.emitting = true

func _fly(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if direction.y == -1 && $Sprite/AnimationPlayer.current_animation != "Fly Up":
		$Sprite/AnimationPlayer.play("Fly to Up")
	if direction.y == 1 && $Sprite/AnimationPlayer.current_animation != "Fly Down":
		$Sprite/AnimationPlayer.play("Fly to Down")
	
	velocity = lerp(velocity, direction * speed * delta, delta * 2)
	move_and_collide(velocity)
	
	if velocity.x != 0:
		$Sprite.scale.x = 0.5 if velocity.x > 0 else -0.5

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
