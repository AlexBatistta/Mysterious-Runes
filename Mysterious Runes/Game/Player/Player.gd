extends KinematicBody2D

export var speed = 250;

var animation = "Idle";

var velocity = Vector2()

const GRAVITY = Vector2(0, 900)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	velocity += delta * GRAVITY
	
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * speed;
	
	if Input.is_action_pressed("move_right"):
		velocity.x = 1 * speed;
	
	velocity.x = lerp(velocity.x, 0.0, 0.3)
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	animate()
	
func animate():
	if (animation != $Sprite/AnimationPlayer.current_animation):
		$Sprite/AnimationPlayer.play(animation)
	
	if velocity.x == 0:
		animation = "Idle"
	else:
		animation = "Walk"
	
	if velocity.x > 0:
		$Sprite.scale.x = 0.5;
	elif velocity.x < 0: 
		$Sprite.scale.x = -0.5;
