tool
extends ParallaxBackground

#Script para el fondo de todo el juego, cambia de color según el nivel o estado del juego.

var _offset = 0

#Establece el color según el nodo Global
func set_color():
	$Background.modulate = Global.color()

func _ready():
	if !Engine.is_editor_hint():
		#Conecta la señal para cambiar de color
		Global.connect("change_color", self, "set_color")

func _process(delta):
	_offset -= 0.5
	
	#Movimiento del parallax
	scroll_offset = Vector2(_offset, 0)
