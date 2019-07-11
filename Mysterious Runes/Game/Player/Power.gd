extends Node2D

export (PackedScene) var Invoked

var Player
var Animation
var power = ""
var velocity = Vector2()
var direction = Vector2()
var topRiver = 0
var damageRiver = 0
var hits = 0

func _ready():
	$RuneActive.connect("power_out", self, "_power_out")
	Animation = get_parent().get_node("Sprite/AnimationPlayer")
	Player = get_parent()
	set_process_input(false)

func _process(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if power == "Regeneration":
		Player.health = lerp(Player.health, Player.maxLife, delta)
		Player.emit_signal("change_life", Player.health)
	
	if power == "Fly":
		_flying(delta)
		
	if power == "Swim":
		_swimming(delta)
	
	if power == "Fly" || power == "Swim":
		_animate()
		Player.move_and_slide(velocity)
		Player.shootUp = false

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
	
	if damageRiver > 0:
		Player._hurt(damageRiver)

func _damage():
	power = "Damage"
	Player.hit_power *= 2
	$RuneActive._set_power("Damage")

func _shield():
	power = "Shield"
	Player.get_node("ImmunityTimer").start(Global.timePower)
	$RuneActive._set_power("Shield")
	$AnimationPower.play("Shield")

func _regeneration():
	power = "Regeneration"
	Player.get_node("ImmunityTimer").start(Global.timePower)
	$RuneActive._set_power("Regeneration")

func _slow_down():
	power = "Slow Down"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active("Slow_Down")

func _poison():
	power = "Poison"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active("Poison")

func _paralyze():
	power = "Paralyze"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active("Paralyze")

func _invoke():
	var newInvoked_01 = Invoked.instance()
	newInvoked_01.setup(-1, Player.position - Vector2(150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_01)
	
	var newInvoked_02 = Invoked.instance()
	newInvoked_02.setup(-1, Player.position - Vector2(-150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_02)
	
	$RuneActive._set_power("Invoke")

func _fly():
	power = "Fly"
	$FlyMagic.emitting = true
	velocity = Vector2(0, -1)
	Animation.play("Fly to Up")
	$RuneActive._set_power("Fly")
	set_process_input(true)

func _swim(_active, _top, _damage):
	power = "Swim"
	topRiver = _top + 75
	velocity = Vector2()
	damageRiver = _damage
	set_process_input(_active)
	if !_active: power = ""

func _animate():
	var animation = Animation.current_animation
	
	if !Player.shooting:
		if Player.position.y > topRiver:
			if direction.y == -1 && Animation.current_animation != "Fly Up":
				animation = "Fly to Up"
			if direction.y == 1 && Animation.current_animation != "Fly Down":
				animation = "Fly to Down"
	elif Animation.current_animation != "Fly Shoot":
		var anim = Animation.current_animation
		Animation.animation_set_next("Fly Shoot", anim)
		animation = "Fly Shoot"
	
	if Player.hurting:
		animation = "Fly Hurt"
		if Player.check_life():
			animation = "Die"
	
	if animation != Animation.current_animation:
		Animation.play(animation)
	
	if velocity.x != 0:
		Player.get_node("Sprite").scale.x = 0.5 if velocity.x > 0 else -0.5

func _power_out():
	Global.rune_active = false
	match power:
		"Regeneration":
			Player.check_life()
		"Damage":
			Player.hit_power /= 2
		"Fly":
			$FlyMagic.emitting = false
		"Shield":
			$Shield.visible = false
			$AnimationPower.stop()
	power = ""
	Player.set_physics_process(true)
