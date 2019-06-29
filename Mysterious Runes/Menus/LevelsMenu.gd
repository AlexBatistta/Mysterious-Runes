tool
extends Control

func _ready():
	var padlocks = get_tree().get_nodes_in_group("Padlock")
	for padlock in padlocks:
		padlock.texture.region = Rect2(500, 200, 100, 100)
	
	for lock in Global.levelsUnlock:
		var padlock = "LevelButton-0" + str(lock + 1) + "/Padlock"
		if lock < 2:
			$VBoxContainer/HBoxContainer.get_node(padlock).texture.region = Rect2(500, 300, 100, 100)
		else:
			$VBoxContainer/HBoxContainer2.get_node(padlock).texture.region = Rect2(500, 300, 100, 100)

func _on_LevelButton01_pressed():
	Global.change_level(1)
	Global.change_menu("Game")

func _on_LevelButton02_pressed():
	Global.change_level(2)
	Global.change_menu("Game")

func _on_LevelButton03_pressed():
	Global.change_level(3)
	Global.change_menu("Game")

func _on_LevelButton04_pressed():
	Global.change_level(4)
	Global.change_menu("Game")

func _on_LevelButton05_pressed():
	Global.change_level(5)
	Global.change_menu("Game")
