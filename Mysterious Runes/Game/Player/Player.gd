extends KinematicBody2D

const gravity = 900
const attack_wait = 1

export var health = 100
export var speed = 250
export var hit_power = 25
export var jump_speed = 450

export var shooting = false
export var hurting = false
export var wait = true
export var power_active = false

export (PackedScene) var Bullet

var animation = "Idle"
var velocity = Vector2()
var direction = Vector2()
var currentDirection = 0
var maxLife = 0
var snap = Vector2(0, 32)
var levelKey = false

func _ready():
	$Sprite/AnimationPlayer.animation_set_next("Fly to Up", "Fly Up")
	$Sprite/AnimationPlayer.animation_set_next("Fly to Down", "Fly Down")
	$Sprite.frame = 0
	maxLife = health
	pass

func _physics_process(delta):
	if !power_active:
		_move(delta)
		_animate()
	
	if !wait:
		if $ShootTimer.is_stopped() && Input.is_action_pressed("shoot"):
			shooting = true

func _move(delta):
	snap = Vector2(0, 32)
	
	velocity.y += delta * gravity
	
	if !wait:
		direction.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
		velocity.x = direction.x * speed
		
		if is_on_floor():
			velocity.y = 0
			if Input.is_action_pressed("jump"):
				velocity.y = -jump_speed
				snap = Vector2.ZERO
		
		if shooting && is_on_floor(): velocity.x = 0
		
		if direction.x != 0: change_direction()
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2(0, -1))

func _animate():
	if velocity.x != 0:
		animation = "Walk"
	else: animation = "Idle"
	
	if !is_on_floor(): 
		animation = "Jump"
		if velocity.y > 0:
			animation = "Fall"
	
	if shooting:
		animation = "Shoot"
		if !is_on_floor():
			animation += " Jump"
	
	if hurting:
		animation = "Hurt"
		if check_life():
			animation = "Die"
	
	if animation != $Sprite/AnimationPlayer.current_animation:
		$Sprite/AnimationPlayer.play(animation)

func _shoot():
	var bullet = Bullet.instance()
	bullet.setup(position + $BulletSpawn.position, $Sprite.scale.x, "Player")
	get_parent().add_child(bullet)
	$ShootTimer.start(attack_wait)

func _hurt(hit):
	if $ImmunityTimer.is_stopped():
		health -= hit
		$ImmunityTimer.start(2)
		hurting = true
		print(health)

func rune(power, type):
	power_active = true
	if type == 1:
		levelKey = true
	$Power.call("_" + power.to_lower())
	$PowerMagic.emitting = true
	$PowerMagic.restart()
	if power != "Fly":
		$Sprite/AnimationPlayer.play("Power " + str(type))

func check_life():
	health = clamp(health, 0, maxLife)
	if health == 0:
		wait = true
		return true

func _river(_active, _top = 0, _damage = 0):
	power_active = _active
	$Power._swim(_active, _top, _damage)

func _geyser(_orientation):
	velocity.y = -600 * _orientation
	move_and_slide(velocity, Vector2(0, -1))

func change_direction():
	$Sprite.scale.x = abs($Sprite.scale.x) * direction.x
	$Damage.scale.x = abs($Damage.scale.x) * direction.x
	$BulletSpawn.position.x = abs($BulletSpawn.position.x) * direction.x

func _on_Area2D_body_entered(body):
	pass
