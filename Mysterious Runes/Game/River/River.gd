tool
extends Node2D

#Script encargado de la creación de ríos de diferentes tipos, estableciendo
#el daño que produce al jugador y las dimensiones de los sprites

export (int, "Water", "Poison", "Acid") var type = 0
export (Vector2) var dimensions = Vector2(1, 1) setget change_dimensions
export var tileSize = 96
export var damage = 5

var rectSprite = Vector2()
var color
var backWaves : Sprite
var frontWaves : Sprite

#Cambia las dimensiones
func change_dimensions(_dimensions):
	#Limita la altura
	if _dimensions.y > 4: _dimensions.y = 4
	dimensions = _dimensions
	
	#Crea el sprite del fondo y lo agrega a escena
	if backWaves != null:
		backWaves.queue_free()
	backWaves = create_sprite(1)
	add_child(backWaves)
	
	#Crea el sprite del frente y lo agrega a escena
	if frontWaves != null:
		frontWaves.queue_free()
	frontWaves = create_sprite(3)
	#Sprite mas bajo que el del fondo
	frontWaves.region_rect = Rect2(35, 0, rectSprite.x, rectSprite.y - 20)
	frontWaves.position += Vector2(0, 10)
	#Movimiento de las olas
	frontWaves.material.set_shader_param("speed", 0.2)
	add_child(frontWaves)
	
	#Color según el tipo
	set_color()

#Establece los parámetros según las dimensiones
func setup():
	$Area2D.scale = dimensions
	$Area2D.position = rectSprite / 2
	
	$Bubbles.process_material = load("res://Game/River/ParticlesMaterial.tres").duplicate()
	$Bubbles.process_material.emission_box_extents = Vector3(40 * dimensions.x, 40 * dimensions.y, 1)
	$Bubbles.position = rectSprite / 2
	$Bubbles.emitting = true

#Crea el sprite y lo retorna
func create_sprite(zIndex):
	#Ancho y largo según la medida del tile y las dimensiones
	rectSprite = Vector2(tileSize * dimensions.x, tileSize * dimensions.y)
	
	#Crea el sprite con la textura
	var sprite = Sprite.new()
	sprite.texture = load("res://Game/River/River.png")
	sprite.z_index = zIndex
	
	#Establece las medidas
	sprite.region_enabled = true
	sprite.region_rect = Rect2(Vector2(0, 0), rectSprite)
	sprite.set_offset(Vector2(48 * dimensions.x, 48 * dimensions.y))
	
	#Agrega el shader
	var shader = ShaderMaterial.new()
	shader.set_shader(load("res://Game/River/SpriteShader.shader"))
	sprite.set_material(shader)
	
	return sprite

#Establece el color
func set_color():
	if type == 0: color = Color.aqua
	elif type == 1 : color = Color.yellow
	else: color = Color.greenyellow
	
	if backWaves != null:
		backWaves.modulate = color
	
	if frontWaves != null:
		frontWaves.modulate = color
		#Lo transparenta para que se vea el personaje "en el medio de las olas"
		frontWaves.modulate.a = 0.65
	
	#Color de las burbujas (partículas)
	$Bubbles.modulate = color

func _ready():
	setup()

#Acción de colision
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		#Activa el poder de nadar
		body._river(true, position.y, damage * type)
		#Sonido del río
		$LiquidSound.play()
	
	#Mata a los NPCs
	if body.is_in_group("NPC"):
		body._hurt(body.health)
	
	#Si cae desde muy alto reproduce un sonido
	if body.velocity.y > 45:
		$SplashSound.play()

#Acción de salida
func _on_Area2D_body_exited(body):
	if body.name == "Player":
		#Para el poder de nadar
		body._river(false)
		#Para el sonido
		$LiquidSound.stop()
