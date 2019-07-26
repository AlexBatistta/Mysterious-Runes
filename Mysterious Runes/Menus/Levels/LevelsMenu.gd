extends Control

#Script para el menú de niveles

#Contenedor de los botones del menú para el manejo por teclado
var buttons = [
	"VBoxContainer/HBoxContainer/LevelButton-01",
	"VBoxContainer/HBoxContainer/LevelButton-02",
	"VBoxContainer/HBoxContainer2/LevelButton-03",
	"VBoxContainer/HBoxContainer2/LevelButton-04",
	"VBoxContainer/HBoxContainer2/LevelButton-05"
]
var node_path = ""

#Actualiza el icono del candado según haya desbloqueado los niveles
func _ready():
	for button in buttons:
		get_node(button + "/Padlock").texture.region = Rect2(500, 200, 100, 100)
	
	for unlock in Global.levelsUnlock:
		get_node(buttons[unlock] + "/Padlock").texture.region = Rect2(500, 300, 100, 100)

#Acciones de los botones de cada nivel
func _on_LevelButton01_pressed():
	_play_level(1)

func _on_LevelButton02_pressed():
	_play_level(2)

func _on_LevelButton03_pressed():
	_play_level(3)

func _on_LevelButton04_pressed():
	_play_level(4)

func _on_LevelButton05_pressed():
	_play_level(5)

#Cambia de nivel e inicia el juego si está desbloqueado, sino 
#reproduce animación de bloqueo
func _play_level(_level):
	if Global.levelsUnlock >= _level :
		Global.change_level(_level)
		Global.change_menu("Game")
	else:
		if node_path != "":
			get_node(node_path).modulate = Color.white
		
		node_path = buttons[_level - 1] + "/Padlock"
		
		$AnimationPlayer.stop()
		$AnimationPlayer.get_animation("Blocked").track_set_path(0, node_path + ":modulate")
		$AnimationPlayer.play("Blocked")

#Cambio en la visibilidad del nodo, visibiliza la lista de botones
func _on_LevelsMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
