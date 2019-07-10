extends KinematicBody2D

export (Array, int) var SetHealth = [50, 75, 75, 100, 150, 200]
export (Array, int) var SetHitPower = [5, 10, 15, 20, 25, 30]
export (PackedScene) var Bullet
export var shooting = false
export var hurting = false

signal spawn_invoked

var animation = "Spawn"
var velocity = Vector2()
var direction = 1
var gravity = 900
var spawning = true
var health = 0
var hit_power = 0
var type
var rune_power = ""
var paralyze = false
var custom_speed = 0

const speed = 150

func setup(_type, _position):
	type = _type
	position = _position
	
	if type >= 0:
		$SpriteBody.texture = load("res://Game/NPCs/SpriteBody/NPC-0" + str(type + 1) + ".png")
		$SpriteColor.texture = load("res://Game/NPCs/SpriteColor/NPC-0" + str(type + 1) + ".png")
		$SpriteColor.modulate = Global.color()
		$AttackArea.set_collision_mask_bit(0, true)
		set_collision_layer_bit(1, true)
		health = SetHealth[type]
		hit_power = SetHitPower[type]
		$RuneActive.connect("power_out", self, "_power_out")
	else:
		$SpriteBody.texture = load ("res://Game/NPCs/Invoked.png")
		$SpriteColor.texture = null
		$AttackArea.set_collision_mask_bit(1, true)
		set_collision_layer_bit(0, true)
		health = 100
		hit_power = 10

func _ready():
	custom_speed = 0.5
	
	if type >= 3:
		$AttackArea/AttackRayCast.position = Vector2(140, -50)
	else:
		$AttackArea/AttackRayCast.position = Vector2(40, -50)
	
	if type == 2:
		$AttackArea/AttackRayCast.cast_to = Vector2(0, 350)
		$AttackArea/AttackRayCast.position = Vector2.ZERO
		$AttackArea/AttackRayCast.set_collision_mask_bit(0, false)
		$AttackArea/AttackRayCast.set_collision_mask_bit(2, true)
		$RayCast2D.cast_to = Vector2(20, 0)
		$RayCast2D.position = Vector2(40, -25)
	
	if type == 5:
		$InvokerTimer.start(7)
	
	$LifeBar.max_value = health
	$LifeBar.value = health

func _physics_process(delta):
	if health > 0 && !paralyze:
		if !spawning && type != 2:
			if $AttackArea/AttackRayCast.is_colliding() && $AttackTimer.is_stopped():
				$AttackTimer.start(4)
				shooting = true
		
		_move(delta)
		
		if type == 2: _magic_flyer()
		if type == 5: _invoker_boss()
	else:
		velocity = Vector2(0, gravity / 3)
	
	var collisions = move_and_slide(velocity, Vector2(0, -1))
	
	if rune_power == "Poison": _hurt(5)
	
	_animate()

func _move(delta):
	
	velocity.y += delta * gravity
	
	velocity.x = direction * (speed * custom_speed)
	
	if shooting || hurting: velocity.x = 0
	
	if !spawning && type != 2:
		if is_on_wall() || !$RayCast2D.is_colliding():
			_change_direction()

func _shoot():
	if type >= 3:
		var bullet = Bullet.instance()
		var _position = position + $AttackArea/AttackDetector.position 
		bullet.setup(_position, $SpriteBody.scale.x, "NPC", false, hit_power)
		get_parent().add_child(bullet)
	else:
		$AttackArea/AttackDetector.disabled = false
	
	if type == 2:
		var _position = position - Vector2(0, 50)
		
		var bullet_01 = Bullet.instance()
		bullet_01.setup(_position, $SpriteBody.scale.x, "NPC", true, hit_power)
		get_parent().add_child(bullet_01)
		
		var bullet_02 = Bullet.instance()
		bullet_02.setup(_position, -$SpriteBody.scale.x, "NPC", true, hit_power)
		get_parent().add_child(bullet_02)
	
	$NPCSound.stream = load("res://Sound/Shoot.ogg")
	$NPCSound.play()

func _magic_flyer():
	if type == 2:
		if spawning:
			if $AttackArea/AttackRayCast.is_colliding():
				velocity.y = -(speed * custom_speed)
			else:
				spawning = false
		else: velocity.y = 0
	
	if $AttackTimer.is_stopped():
		$AttackTimer.start(4)
		shooting = true
	
	if $RayCast2D.is_colliding():
		_change_direction()

func _invoker_boss():
	if $InvokerTimer.is_stopped():
		shooting = true
		$InvokerTimer.start(7)
		emit_signal("spawn_invoked", position)
	pass

func _animate():
	if spawning:
		animation = "Spawn"
		if is_on_floor():
			spawning = false
			custom_speed = 1
	else:
		if velocity.x != 0:
			animation = "Run"
			$SpriteBody.scale.x = 0.5 if velocity.x > 0 else -0.5
			$SpriteColor.scale.x = 0.5 if velocity.x > 0 else -0.5
		else: animation = "Idle"
		
		if shooting:
			animation = "Attack"
		else:
			$AttackArea/AttackDetector.disabled = true
		
		if hurting:
			animation = "Hurt"
			if health <= 0:
				animation = "Die"
	
	if animation != $AnimationPlayer.current_animation:
		$AnimationPlayer.play(animation)

func _change_direction():
	direction *= -1
	$RayCast2D.position.x *= -1

func _hurt(hit):
	if $ImmunityTimer.is_stopped():
		health -= hit
		hurting = true
		$LifeBar.value -= hit
		$ImmunityTimer.start(2)
		$NPCSound.stream = load("res://Sound/Hurt.ogg")
		$NPCSound.play()

func _geyser(_orientation):
	if health > 0:
		velocity.y = -600 * _orientation
		velocity.x = 0
		spawning = true
		$AttackTimer.start(2)
		shooting = false
		$NPCSound.stream = load("res://Sound/Geyser.ogg")
		$NPCSound.play()

func _rune_active(_power):
	rune_power = _power
	if _power == "Poison":
		_hurt(5)
	if _power == "Paralyze":
		paralyze = true
	if _power == "Slow Down":
		$AnimationPlayer.playback_speed = 0.5
		custom_speed = 0.5
		if type == 2: custom_speed = 0.25
	
	$RuneActive._set_power(rune_power)

func _on_VisibilityNotifier2D_screen_exited():
	if type == 2:
		_change_direction()
	else:
		$DespawnTimer.start(2)

func _on_DespawnTimer_timeout():
	if !$VisibilityNotifier2D.is_on_screen():
		queue_free()

func _power_out():
	match rune_power:
		"Paralyze":
			paralyze = false
		"Slow Down":
			$AnimationPlayer.playback_speed = 1
			custom_speed = 1
			if type == 2: custom_speed = 0.5
	rune_power = ""

func _on_AttackArea_body_entered(body):
	body._hurt(hit_power)
