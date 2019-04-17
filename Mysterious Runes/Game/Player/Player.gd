extends KinematicBody2D

export var speed = 250;
export var gravity = 900;
export var jump_speed = 450;
export var shooting = false
export var jumping = false

var animation = "Idle";
var velocity = Vector2()

func _ready():
	shooting = false
	jumping = false
	
	pass

func _physics_process(delta):
	_move(delta)
	
	_shoot()
	
	_animate()

func _move(delta):
	velocity.y += delta * gravity
	
	var sideX = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	velocity.x = (sideX * (speed * delta)) / delta
	
	if is_on_floor():
		velocity.y = 0
		jumping = false
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_speed
			jumping = true
	
	if shooting && !jumping: velocity.x = 0
	move_and_slide(velocity, Vector2(0, -1))
	
func _shoot():
	if !shooting:
		if Input.is_action_pressed("shoot"):
			shooting = true
	

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
	
	print(animation)
