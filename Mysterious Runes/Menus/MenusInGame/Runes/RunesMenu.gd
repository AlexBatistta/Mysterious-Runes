extends Control

#Script para el control del menú especial de runas,
#contiene todos los poderes permanentes que se desbloquean con los niveles

signal rune

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"CenterContainer/VBoxContainer/CenterContainer/Power-01",
	"CenterContainer/VBoxContainer/HBoxContainer/Power-02",
	"CenterContainer/VBoxContainer/HBoxContainer/Power-03",
	"CenterContainer/VBoxContainer/HBoxContainer2/Power-04",
	"CenterContainer/VBoxContainer/HBoxContainer2/Power-05",
]
var rune_name = ""

func _ready():
	#Color de fondo
	var _color = Global.color()
	_color.a = 0.25
	get_stylebox("panel", "").bg_color = _color
	
	#Deshabilita todos los botones
	for button in buttons:
		get_node(button).disabled = true
	
	#Habilita los desbloquedos y quita de la lista los restantes
	for i in buttons.size():
		if i < Global.levelsUnlock:
			get_node(buttons[i]).disabled = false
		else:
			buttons.pop_back()
	
	#Obtiene los botones de la escena
	$KeyboardController._get_buttons()

func _process(delta):
	#Obtiene el botón seleccionado y nombra a la etiqueta
	var rune = -1
	for button in buttons:
		if get_node(button).is_hovered():
			rune = buttons.find(button)
	
	match rune:
		0:	rune_name = "Slow"
		1:	rune_name = "Poison"
		2:	rune_name = "Paralyze"
		3:	rune_name = "Invoke"
		4:	rune_name = "Fly"
	
	if rune >= 0:
		$CenterContainer/RuneName.text = rune_name
	else:
		$CenterContainer/RuneName.text = "Runes"

func _input(event):
	#Oculta el menú
	if event.is_action_pressed("runes"):
		hide()

#Cambio en la visibilidad del nodo, modifica el input y la escala de tiempo
func _on_PowerMenu_visibility_changed():
	if visible:
		set_process_input(true)
		Engine.time_scale = 0.25
	else:
		set_process_input(false)
		Engine.time_scale = 1

#Acciones de los botones, emiten la señal con el nombre y oculta el nodo

func _on_Power01_pressed():
	emit_signal("rune", rune_name)
	hide()

func _on_Power02_pressed():
	emit_signal("rune", rune_name)
	hide()

func _on_Power03_pressed():
	emit_signal("rune", rune_name)
	hide()

func _on_Power04_pressed():
	emit_signal("rune", rune_name)
	hide()

func _on_Power05_pressed():
	emit_signal("rune", rune_name)
	hide()


