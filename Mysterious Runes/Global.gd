tool
extends Node

var current_scene = null
var current_level = 1
var maxLevels = 5

onready var Game = preload("res://Game/Levels/Levels.tscn")
onready var Menu = preload("res://Menus/Menus.tscn")

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
	
	get_tree().get_root().add_child(current_scene)
	
	get_tree().set_current_scene(current_scene)

func change_level(_level):
	if _level < maxLevels:
		current_level = _level

func pass_level():
	if current_level < 5:
		current_level += 1;
		change_scene("Game")
