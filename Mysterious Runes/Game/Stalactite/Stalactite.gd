tool
extends Area2D

export (int) var powerDamage = 15
export (bool) var flip = false setget set_flip
var speed = 10
var velocity = Vector2.DOWN
var drop = false

func set_flip(_flip):
	flip = _flip
	rotation_degrees = 180 if flip else 0

func _ready():
	$SpriteColor.modulate = Global.color()

func _process(delta):
	if !flip:
		if $RayCast2D.is_colliding():
			drop = true
		
		if drop:
			velocity += Vector2.DOWN / 2
			position += velocity

func _hurt(_hit):
	$AnimationPlayer.play("Break")
	$Particles2D.emitting = true
	$BreakSound.play()

func _on_Stalactite_body_entered(body):
	if body.name == "Player":
		body._hurt(powerDamage)
		_hurt(0)
