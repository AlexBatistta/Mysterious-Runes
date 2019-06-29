tool
extends Node

var current_scene = null
var current_level = 0
var current_menu = "MainMenu"
var maxLevels = 5
var sound = true
var music = true
var levelsUnlock = 1

onready var Game = preload("res://Game/Levels/Levels.tscn")
onready var Menu = preload("res://Menus/Menus.tscn")

signal change_color
signal transition

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(_scene):
	call_deferred("new_scene", _scene)

func new_scene(_scene):
	current_scene.free()
	
	if _scene == "Game":
		current_scene = Game.instance()
	else:
		current_scene = Menu.instance()
		current_menu = "MainMenu"
	
	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)
	
	emit_signal("change_color")
	
	Persistence.save_data()

func change_level(_level):
	if _level < maxLevels:
		current_level = _level

func change_menu(_menu):
	current_menu = _menu
	emit_signal("transition")

func pass_level():
	if current_level < 5:
		current_level += 1;
		levelsUnlock += 1;
		change_scene("Game")

func color():
	match current_level:
		0:	return Color.magenta
		1:	return Color.blue
		2:	return Color.red
		3:	return Color.green
		4:	return Color.yellow
		5:	return Color.purple

func set_sound():
	sound = !sound
	print(sound)

func set_music():
	music = !music
	print(music)