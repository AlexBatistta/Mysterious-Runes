tool
extends RigidBody2D

export (int) var powerDamage = 15

func change_color(_color):
	$SpriteColor.modulate = _color
	
func _ready():
	mode = RigidBody2D.MODE_STATIC

func _physics_process(delta):
	if $RayCast2D.is_colliding():
		mode = RigidBody2D.MODE_RIGID
		sleeping = false

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body._hurt(powerDamage)
		$AnimationPlayer.play("Break")
		$Particles2D.emitting = true

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
