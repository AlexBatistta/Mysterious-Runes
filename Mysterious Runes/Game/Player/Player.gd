extends KinematicBody2D

var animation = "Walk";

var velocity = Vector2()

const GRAVITY = Vector2(0, 900)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	velocity += delta * GRAVITY
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	animate()
	
func animate():
	if (animation != $Sprite/AnimationPlayer.current_animation):
		$Sprite/AnimationPlayer.play(animation)
