tool
extends Node

#Script principal, administra variables globales y carga las escenas

const MAX_LEVELS = 5
const TIME_POWER = 20

#Variables de control de escena
var current_scene = null
var current_level = 0
var current_menu = "MainMenu"
var current_state = "Menus"

var levelKey = false
var rune_active = false
var power_rune = ""
var levelsUnlock = 1

var sound = true
var music = true

onready var Game = preload("res://Game/Game.tscn")
onready var Menu = preload("res://Menus/Menus.tscn")

signal change_color
signal transition

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

#Cambia la escena 
func change_scene(_scene):
	call_deferred("new_scene", _scene)

#Carga la nueva escena
func new_scene(_scene):
	#Elimina la escena actual
	current_scene.free()
	
	#Instancia la escena
	if _scene == "Game":
		levelKey = false
		current_scene = Game.instance()
		current_state = "Game"
		get_tree().paused = false
	else:
		current_scene = Menu.instance()
		current_state = "Menus"
	
	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)
	
	#Emite señal para cambiar de color
	emit_signal("change_color")
	
	#Guarda los datos
	Data.save_data()

#Cambia el nivel actual
func change_level(_level):
	if _level <= MAX_LEVELS:
		current_level = _level

#Cambia el menú actual y emite señal para la transición
func change_menu(_menu):
	current_menu = _menu
	emit_signal("transition")

#Recarga la escena
func try_again():
	change_scene("Game")

#Carga el nivel siguiente
func pass_level():
	if current_level < MAX_LEVELS:
		current_level += 1;
		levelsUnlock = current_level;
		change_scene("Game")

#Retorna el color del nivel
func color():
	match current_level:
		0:	return Color.magenta
		1:	return Color.blue
		2:	return Color.red
		3:	return Color.green
		4:	return Color.yellow
		5:	return Color.purple
		6:	return Color.magenta

#Cambia el estado del sonido
func set_sound():
	sound = !sound
	if sound:
		AudioServer.set_bus_volume_db(1, 0)
	else:
		AudioServer.set_bus_volume_db(1, -80)

#Cambia el estado de la música
func set_music():
	music = !music
	var current = "Music" + current_state
	var songs = get_tree().get_nodes_in_group("Music")
	for song in songs:
		if !music:
			song.stop()
		else:
			if song.name == current:
				song.play(song.get_playback_position())