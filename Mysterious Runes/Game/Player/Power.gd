extends Node2D

#Script que controla la acción de los poderes de las runas
#Cada runa afecta de una forma temporal controlada por el script "RunesActive"
#y setea en la variable Global el poder activo

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
	#Conecta la señal
	$RuneActive.connect("power_out", self, "_power_out")
	
	Animation = get_parent().get_node("Sprite/AnimationPlayer")
	Player = get_parent()
	
	#Deshabilita el input
	set_process_input(false)

func _process(delta):
	direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	direction.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	#Acción de regeneración, si está activa se aumenta la vida al máximo
	#y se emite la señal para cambiar el valor de la barra de vida
	if Global.power_rune == "Regeneration":
		Player.health = lerp(Player.health, Player.maxLife, delta)
		Player.emit_signal("change_life", Player.health)
	
	#Acción de volar, se activa el movimiento especial
	if Global.power_rune == "Fly":
		_flying(delta)
	
	#Acción de nadar, se activa el movimiento especial
	if swimming:
		_swimming(delta)
	
	#Si vuela o nada, mueve al personaje y lo anima
	if Global.power_rune == "Fly" || swimming:
		_animate()
		Player.move_and_slide(velocity)
		Player.shootUp = false

#Velocidad de vuelo
func _flying(delta):
	velocity = lerp(velocity, direction * Player.SPEED, delta * 2)

#Movimiento de nado
func _swimming(delta):
	#Por defecto hunde al personaje
	if direction.y == 0:
		direction.y = 1
	
	#Impulsa hacia abajo si esta cerca de la superficie
	if direction.y == -1 && Player.position.y < topRiver:
		direction.y = 1
	
	velocity = lerp(velocity, direction * (Player.SPEED / 2), delta * 2)
	
	if direction.x == 0:
		velocity.x = 0
	
	#Salida del río, si choca contra una pared y esta cerca de la 
	#superficie, se lo impulsa a salir
	if Player.is_on_wall() && Player.position.y < topRiver + 5:
		velocity.x = Player.SPEED * direction.x
		velocity.y = -Player.JUMP_SPEED / 2
	
	#Hiere al personaje según el daño que produzca
	if damageRiver > 0:
		Player._hurt(damageRiver, true)

#Poder de daño, duplica la fuerza de daño del personaje
func _damage():
	Global.power_rune = "Damage"
	Player.hit_power *= 2
	$RuneActive._set_power()

#Poder de escudo, inmuniza al personaje
func _shield():
	Global.power_rune = "Shield"
	Player.get_node("ImmunityTimer").start(Global.TIME_POWER)
	$RuneActive._set_power()
	$AnimationPower.play("Shield")

#Poder de regeneración, aumenta la vida del personaje al máximo
func _regeneration():
	Global.power_rune = "Regeneration"
	Player.get_node("ImmunityTimer").start(Global.TIME_POWER)
	$RuneActive._set_power()

#Poder de ralentizar, disminuye la velocidad de los enemigos
func _slow():
	Global.power_rune = "Slow"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

#Poder de envenenar, daña a los enemigos
func _poison():
	Global.power_rune = "Poison"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

#Poder de paralizar, para el movimiento y el ataque de los enemigos
func _paralyze():
	Global.power_rune = "Paralyze"
	var NPCs = get_tree().get_nodes_in_group("NPC")
	for NPC in NPCs: NPC._rune_active()

#Poder de invocar, crea dos NPCs aliados que atacan a los enemigos
func _invoke():
	var newInvoked_01 = Invoked.instance()
	newInvoked_01.setup(-1, Player.position - Vector2(150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_01)
	
	var newInvoked_02 = Invoked.instance()
	newInvoked_02.setup(-1, Player.position - Vector2(-150, 200))
	Player.get_parent().call_deferred("add_child", newInvoked_02)

#Poder de volar, se habilitan movimientos especiales para que el jugador vuele
func _fly():
	Global.power_rune = "Fly"
	$FlyMagic.emitting = true
	velocity = Vector2(0, -1)
	Animation.play("Fly to Up")
	$RuneActive._set_power()
	set_process_input(true)

#Poder de nadar, se habilitan movimientos especiales para que el jugador nade
func _swim(_active, _top, _damage):
	swimming = _active
	topRiver = _top + 75
	velocity = Vector2()
	damageRiver = _damage
	set_process_input(_active)

#Animación personalizada
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

#Normaliza cuando termina el tiempo del poder
func _power_out():
	Global.rune_active = false
	match Global.power_rune:
		"Regeneration":
			Player.check_life()
		"Damage":
			Player.hit_power /= 2
		"Fly":
			$FlyMagic.emitting = false
			set_process_input(false)
			Player.set_physics_process(true)
		"Shield":
			$Shield.visible = false
			$AnimationPower.stop()
	Global.power_rune = ""
