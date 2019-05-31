extends Node2D

export (PackedScene) var Invoked

var Player
var Animation

var flying = false
var swimming = false
var velocity = Vector2()
var direction = Vector2()
var topRiver = 0

func _ready():
	Animation = get_parent().get_node("Sprite/AnimationPlayer")
	Player = get_parent()

func _process(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if flying:
		_flying(delta)
		
	if swimming:
		_swimming(delta)
	
	if flying || swimming:
		_animate()
		Player.move_and_slide(velocity)

func _flying(delta):
	velocity = lerp(velocity, direction * Player.speed, delta * 2)

func _swimming(delta):
	if direction.y == 0:
		direction.y = 1
	
	if direction.y == -1 && Player.position.y < topRiver:
		direction.y = 1
	
	velocity = lerp(velocity, direction * (Player.speed / 2), delta * 2)
	
	if direction.x == 0:
		velocity.x = 0
	
	if Player.is_on_wall() && Player.position.y < topRiver + 5:
		velocity.x = Player.speed * direction.x
		velocity.y = -Player.jump_speed / 2

func _damage():
	Player.hit_power *= 2
	print("Damage")
	pass

func _shield():
	Player.get_node("ImmunityTimer").start(5)
	
	print("Shield")
	pass

func _regeneration():
	Player.health += 50  
	Player.check_life()
	
	print("Regeneration")
	pass

func _slow_down():
	print("Slow Down")
	print(Player.health)
	pass

func _poison():
	print("Poison")
	pass

func _paralyze():
	print("Paralyze")
	pass

func _invoke():
	var invoked_01 = Invoked.instance()
	var _direction = Player.get_node("Sprite").scale.x * 2
	var _position = Player.position + Vector2 (200 * _direction, -150)
	invoked_01.get_node("InvokedBody").setup(_position, _direction)
	call_deferred("add_child",invoked_01)
	print("Invoke")
	pass

func _fly():
	flying = true;
	$FlyTimer.start(10)
	$FlyMagic.emitting = true
	velocity = Vector2(0, -1)
	Animation.play("Fly to Up")

func _on_FlyTimer_timeout():
	if !Player.shooting:
		flying = false
		Player.power_active = false
		$FlyMagic.emitting = false

func fly_out():
	if $FlyTimer.is_stopped():
		_on_FlyTimer_timeout()

func _swim(_active, _top):
	swimming = _active
	topRiver = _top + 75
	$Splash.emitting = true
	velocity = Vector2()

func _animate():
	if !Player.shooting:
		if direction.y == -1 && Animation.current_animation != "Fly Up":
			Animation.play("Fly to Up")
		if direction.y == 1 && Animation.current_animation != "Fly Down":
			Animation.play("Fly to Down")
	elif Animation.current_animation != "Fly Shoot":
		var anim = Animation.current_animation
		Animation.animation_set_next("Fly Shoot", anim)
		Animation.play("Fly Shoot")
	
	if velocity.x != 0:
		Player.get_node("Sprite").scale.x = 0.5 if velocity.x > 0 else -0.5
		Player.get_node("Damage").scale.x = 1 if velocity.x > 0 else -1

func _on_DamageTimer_timeout():
	Player.hit_power /= 2
