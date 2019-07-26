tool
extends Area2D

#Script para el control de las runas, cambia el tipo de árbol,
#el tipo de runa y el tipo de poder

export (int, "Big", "Small") var treeType = 0 setget change_tree
export (int, "Temporary", "Permanent") var runeType = 0 
export (String, "Damage", "Shield", "Regeneration") var temporary = "Damage"
var permanent = ["Slow", "Poison", "Paralyze", "Invoke", "Fly"]
var power = ""
var dropped = false

signal rune

#Cambio de tamaño del árbol y reposicionamiento
func change_tree(_type):
	treeType = _type
	$Tree.frame = treeType
	$Rune.position.x = 5 if treeType == 1 else -15
	$CollisionShape2D.position = $Rune.position

func _ready():
	#Seteo de propiedades
	$Rune.frame = 0
	$Rune.scale = Vector2(0.5, 0.5)
	$Rune/Name.visible = false
	$Rune/Power.visible = false
	$Rune/Particles2D.emitting = true
	
	animation()

#Animación
func animation():
	var frame
	
	#Se elige el poder
	if runeType == 0: power = temporary
	else: power = permanent[Global.current_level - 1]
	
	match power:
		"Damage": frame = 0
		"Shield": frame = 1
		"Regeneration": frame = 2
		"Slow": frame = 3
		"Poison": frame = 4
		"Paralyze": frame = 5
		"Invoke": frame = 6
		"Fly": frame = 7
	
	#Frame y texto del poder
	$Rune/Power.frame = frame
	$Rune/Name.text = power

#Colisión con bala
func _hurt(_hit):
	dropped = true
	
	#Posicionamiento de la etiqueta
	var _width = $Rune/Name.get_total_character_count() * 5
	$Rune/Name.rect_size = Vector2(_width, 55)
	$Rune/AnimationPlayer.get_animation("Drop").track_set_key_value(4, 0, $Rune.position - Vector2(_width * 2, 0))
	$Rune/AnimationPlayer.get_animation("Drop").track_set_key_value(4, 1, $Rune.position - Vector2(_width * 2, 50))
	
	#Animación de drop
	$Rune/AnimationPlayer.play("Drop")
	
	#Reproduce el sonido
	$RuneAudio.play()

#Deshabilita la colisión
func disabled_collision(_disabled):
	$CollisionShape2D.disabled = _disabled

#Acción de colisión
func _on_Runes_body_entered(body):
	if !Global.rune_active:
		if body.name == "Player" && dropped:
			#Si ya se descubrió la runa, se activa el poder y se deshabilita la colisión
			Global.rune_active = true
			self.connect("rune", body, "rune", [power, runeType])
			self.emit_signal("rune")
			call_deferred("disabled_collision", true)
