extends KinematicBody2D

#export var health = 100
export var speed = 275
#export var shooting = false
#export var hit_power = 25

var animation = "Spawn"
var velocity = Vector2()
var direction = 1
var spawning = true
var gravity = 900

signal attack_reposition

func _ready():
	var attack_node = get_parent().get_node("AttackArea")
	connect("attack_reposition", attack_node, "_reposition")
	speed /= 2
	pass

func setup(_position, _direction):
	position = _position
	$Sprite.scale.x *= _direction
	if _direction != direction:
		_change_direction()

func _physics_process(delta):
	
	_move(delta)
	
	_animate()
	
	_attack()
	
	get_parent().get_node("AttackArea").position = position

func _move(delta):
	
	velocity.y += delta * gravity
	
	velocity.x = (direction * (speed * delta)) / delta
	
	move_and_slide(velocity, Vector2(0, -1))
	
	if !spawning:
		if is_on_wall() || !$RayCast2D.is_colliding():
			_change_direction()

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
			speed *= 2
	else:
		if velocity.x != 0:
			animation = "Run"
			$Sprite.scale.x = 0.5 if velocity.x > 0 else -0.5
		else: animation = "Idle"
	
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

func _change_direction():
	direction *= -1
	$RayCast2D.position.x *= -1
	emit_signal("attack_reposition", direction)

func _die():
	pass