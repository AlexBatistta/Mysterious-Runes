extends KinematicBody2D

#export var shooting = false

var animation = "Spawn"
var velocity = Vector2()
var direction = 1
var gravity = 900
var spawning = true

signal attack_reposition

func _ready():
	connect("attack_reposition", $AttackArea, "_reposition")
	get_parent().speed /= 2

func setup(_position, _direction):
	position = _position
	$Sprite.scale.x *= _direction
	if _direction != direction:
		_change_direction()

func _physics_process(delta):
	if get_parent().type != 2:
		_move(delta)
	else:
		_fly()
	
	_animate()
	
	_attack()
	
	$AttackArea.position = position

func _move(delta):
	
	velocity.y += delta * gravity
	
	velocity.x = (direction * (get_parent().speed * delta)) / delta
	
	move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_wall() || !$RayCast2D.is_colliding():
		_change_direction()

func _fly():
	pass

func _attack():
	#if !shooting && $AttackTimer.is_stopped() :
	#	if Input.is_action_pressed("shoot"):
	#		shooting = true
	pass

func _animate():
	if spawning:
		animation = "Spawn"
		if is_on_floor():
			spawning = false
			get_parent().speed *= 2
	elif velocity.x != 0:
		animation = "Run"
		$Sprite.scale.x = 0.5 if velocity.x > 0 else -0.5
	else: animation = "Idle"
	
	if animation != $AnimationPlayer.current_animation:
		$AnimationPlayer.play(animation)

func _change_direction():
	direction *= -1
	$RayCast2D.position.x *= -1
	emit_signal("attack_reposition", direction)

func _die():
	pass