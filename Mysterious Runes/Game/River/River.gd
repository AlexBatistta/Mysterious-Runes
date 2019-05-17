tool
extends Node2D

export (int, "Water", "Acid", "Poison") var type = 0 setget change_type
export (Vector2) var dimensions = Vector2(1, 1) setget change_dimensions
export var tileSize = 96

var rectSprite = Vector2()
var color = Color.aqua
var sprite : Sprite

func change_type(_type):
	type = _type
	if type == 0: color = Color.aqua
	elif type == 1 : color = Color.greenyellow
	else: color = Color.yellow
	if Engine.is_editor_hint():
		set_color()

func change_dimensions(_dimensions):
	if _dimensions.y > 4: _dimensions.y = 4
	dimensions = _dimensions
	if Engine.is_editor_hint():
		setup()

func setup():
	
	create_sprite()
	
	$Area2D.scale = dimensions
	$Area2D.position = rectSprite / 2
	
	$Particles2D.process_material = load("res://Game/River/ParticlesMaterial.tres").duplicate()
	$Particles2D.process_material.emission_box_extents = Vector3(40 * dimensions.x, 40 * dimensions.y, 1)
	$Particles2D.position = rectSprite / 2
	$Particles2D.emitting = true
	
	set_color()

func create_sprite():
	rectSprite = Vector2(tileSize * dimensions.x, tileSize * dimensions.y)
	
	if sprite != null:
		sprite.queue_free()
	
	sprite = Sprite.new()
	sprite.texture = load("res://Game/River/River.png")
	add_child(sprite)
	
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(0, 0), rectSprite)
	sprite.set_offset(Vector2(48 * dimensions.x, 48 * dimensions.y))
	
	var shader = ShaderMaterial.new()
	shader.set_shader(load("res://Game/River/SpriteShader.shader"))
	sprite.set_material(shader)

func set_color():
	sprite.modulate = color
	$Particles2D.modulate = color

func _ready():
	setup()

func _on_Area2D_body_entered(body):
	pass # Replace with function body.

