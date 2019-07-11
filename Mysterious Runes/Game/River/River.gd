tool
extends Node2D

export (int, "Water", "Poison", "Acid") var type = 0
export (Vector2) var dimensions = Vector2(1, 1) setget change_dimensions
export var tileSize = 96
export var damage = 5

var rectSprite = Vector2()
var color
var backWaves : Sprite
var frontWaves : Sprite

func change_dimensions(_dimensions):
	if _dimensions.y > 4: _dimensions.y = 4
	dimensions = _dimensions
	
	if backWaves != null:
		backWaves.queue_free()
	backWaves = create_sprite(1)
	add_child(backWaves)
	
	if frontWaves != null:
		frontWaves.queue_free()
	frontWaves = create_sprite(3)
	frontWaves.region_rect = Rect2(35, 0, rectSprite.x, rectSprite.y - 20)
	frontWaves.position += Vector2(0, 10)
	frontWaves.material.set_shader_param("speed", 0.2)
	add_child(frontWaves)
	set_color()

func setup():
	$Area2D.scale = dimensions
	$Area2D.position = rectSprite / 2
	
	$Bubbles.process_material = load("res://Game/River/ParticlesMaterial.tres").duplicate()
	$Bubbles.process_material.emission_box_extents = Vector3(40 * dimensions.x, 40 * dimensions.y, 1)
	$Bubbles.position = rectSprite / 2
	$Bubbles.emitting = true

func create_sprite(zIndex):
	rectSprite = Vector2(tileSize * dimensions.x, tileSize * dimensions.y)
	
	var sprite = Sprite.new()
	sprite.texture = load("res://Game/River/River.png")
	sprite.z_index = zIndex
	
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(0, 0), rectSprite)
	sprite.set_offset(Vector2(48 * dimensions.x, 48 * dimensions.y))
	
	var shader = ShaderMaterial.new()
	shader.set_shader(load("res://Game/River/SpriteShader.shader"))
	sprite.set_material(shader)
	
	return sprite

func set_color():
	if type == 0: color = Color.aqua
	elif type == 1 : color = Color.yellow
	else: color = Color.greenyellow
	
	if backWaves != null:
		backWaves.modulate = color
	
	if frontWaves != null:
		frontWaves.modulate = color
		frontWaves.modulate.a = 0.65
	
	$Bubbles.modulate = color

func _ready():
	setup()

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body._river(true, position.y, damage * type)
		if body.velocity.y > 45:
			$SplashSound.play()
		$LiquidSound.play()
	
	if body.is_in_group("NPC"):
		body._hurt(body.health)
	
	if body.velocity.y > 45:
		$SplashSound.play()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body._river(false)
		$LiquidSound.stop()
