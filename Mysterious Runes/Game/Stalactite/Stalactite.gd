tool
extends RigidBody2D

export (int) var powerDamage = 15
export (bool) var flip = false setget set_flip

func set_flip(_flip):
	flip = _flip
	rotation_degrees = 180 if flip else 0
	

func change_color(_color):
	$SpriteColor.modulate = _color
	
func _ready():
	mode = RigidBody2D.MODE_STATIC

func _physics_process(delta):
	if !flip:
		if $RayCast2D.is_colliding():
			mode = RigidBody2D.MODE_RIGID
			sleeping = false

func _on_Area2D_body_entered(body):
	var destroy = false
	
	if body.name == "Player":
		body._hurt(powerDamage)
		destroy = true
	
	if body.is_in_group("Bullet"): destroy = true
	
	if destroy:
		$AnimationPlayer.play("Break")
		$Particles2D.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
