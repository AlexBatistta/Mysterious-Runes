extends Node2D

export (PackedScene) var Invoked

var Player
var Animation
var velocity = Vector2()
var direction = Vector2()
var topRiver = 0
var damageRiver = 0
var hits = 0
var swimming = false

func _ready():
	$RuneActive.connect("power_out", self, "_power_out")
	Animation = get_parent().get_node("Sprite/AnimationPlayer")
	Player = get_parent()
	set_process_input(false)

func _process(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	if Global.power_rune == "Regeneration":
		Player.health = lerp(Player.health, Player.maxLife, delta)
		Player.emit_signal("change_life", Player.health)
	
	if Global.power_rune == "Fly":
		_flying(delta)
		
	if swimming:
		_swimming(delta)
	
	if Global.power_rune == "Fly" || swimming:
		_animate()
		Player.move_and_slide(velocity)
		Player.shootUp = false

func _flying(delta):
	velocity = lerp(velocity, direction * Player.SPEED, delta * 2)

func _swimming(delta):
	if direction.y == 0:
		direction.y = 1
	
	if direction.y == -1 && Player.position.y < topRiver:
		direction.y = 1
	
	velocity = lerp(velocity, direction * (Player.SPEED / 2), delta * 2)
	
	if direction.x == 0:
		velocity.x = 0
	
	if Player.is_on_wall() && Player.position.y < topRiver + 5:
		velocity.x = Player.SPEED * direction.x
		velocity.y = -Player.JUMP_SPEED / 2
	
	if damageRiver > 0:
		Player._hurt(damageRiver)

func _damage():
	Global.power_rune = "Damage"
	Player.hit_power *= 2
	$RuneActive._set_power()

func _shield():
	Global.power_rune = "Shield"
	Player.get_node("ImmunityTimer").start(Global.timePower)
	$RuneActive._set_power()
	$AnimationPower.play("Shield")

func _regeneration():
	Global.power_rune = "Regeneration"
	Player.get_node("ImmunityTimer").start(Global.timePower)
	$RuneActive._set_power()

func _slow():
	Global.power_rune = "Slow"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

func _poison():
	Global.power_rune = "Poison"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

func _paralyze():
	Global.power_rune = "Paralyze"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

func _invoke():
	var newInvoked_01 = Invoked.instance()
	newInvoked_01.setup(-1, Player.position - Vector2(150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_01)
	
	var newInvoked_02 = Invoked.instance()
	newInvoked_02.setup(-1, Player.position - Vector2(-150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_02)
	
	$RuneActive._set_power()

func _fly():
	Global.power_rune = "Fly"
	$FlyMagic.emitting = true
	velocity = Vector2(0, -1)
	Animation.play("Fly to Up")
	$RuneActive._set_power()
	set_process_input(true)

func _swim(_active, _top, _damage):
	swimming = _active
	topRiver = _top + 75
	velocity = Vector2()
	damageRiver = _damage
	set_process_input(_active)

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
	match Global.power_rune:
		"Regeneration":
			Player.check_life()
		"Damage":
			Player.hit_power /= 2
		"Fly":
			$FlyMagic.emitting = false
			Player.set_physics_process(true)
		"Shield":
			$Shield.visible = false
			$AnimationPower.stop()
	Global.power_rune = ""
