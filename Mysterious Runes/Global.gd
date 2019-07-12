tool
extends Node

const maxLevels = 5
const timePower = 20

var current_scene = null
var current_level = 0
var current_menu = "MainMenu"
var current_state = "Menus"

var levelKey = false
var rune_active = false
var power_rune = ""
var levelsUnlock = 1

var sound = true
var music = false

onready var Game = preload("res://Game/Game.tscn")
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
		levelKey = false
		current_scene = Game.instance()
		current_state = "Game"
		get_tree().paused = false
	else:
		current_scene = Menu.instance()
		current_state = "Menus"
	
	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)
	
	emit_signal("change_color")
	
	Data.save_data()

func change_level(_level):
	if _level < maxLevels:
		current_level = _level

func change_menu(_menu):
	current_menu = _menu
	emit_signal("transition")

func try_again():
	change_scene("Game")

func pass_level():
	if current_level < 5:
		current_level += 1;
		levelsUnlock = current_level;
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
	var sfx = get_tree().get_nodes_in_group("Sound")
	for fx in sfx:
		if !sound:
			fx.volume_db = -80
			fx.stop()
		else:
			print(fx.name)
			fx.volume_db = 0

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