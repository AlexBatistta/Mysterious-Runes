extends Node2D

export (PackedScene) var Invoked

var Player
var Animation

var flying = false
var velocity = Vector2()
var direction = Vector2()

func _ready():
	Player = get_parent().get_node("Player")
	Animation = Player.get_node("Sprite/AnimationPlayer")

func _process(delta):
	if flying:
		_flying(delta)
		$FlyMagic.position = Player.position

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

func _flying(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if !Player.shooting:
		if direction.y == -1 && Animation.current_animation != "Fly Up":
			Animation.play("Fly to Up")
		if direction.y == 1 && Animation.current_animation != "Fly Down":
			Animation.play("Fly to Down")
	elif Animation.current_animation != "Fly Shoot":
		var anim = Animation.current_animation
		Animation.animation_set_next("Fly Shoot", anim)
		Animation.play("Fly Shoot")
	
	velocity = lerp(velocity, direction * Player.speed * delta, delta * 2)
	
	Player.move_and_collide(velocity)
	
	if velocity.x != 0:
		Player.get_node("Sprite").scale.x = 0.5 if velocity.x > 0 else -0.5

func _on_FlyTimer_timeout():
	if !Player.shooting:
		flying = false
		Player.power_active = false
		$FlyMagic.emitting = false

func fly_out():
	if $FlyTimer.is_stopped():
		_on_FlyTimer_timeout()

func _on_DamageTimer_timeout():
	Player.hit_power /= 2
