extends Control

var node_path = ""
var buttons = []

func _ready():
	_get_buttons()
	
	for button in buttons:
		get_node(button + "/Padlock").texture.region = Rect2(500, 200, 100, 100)
	
	for unlock in Global.levelsUnlock:
		get_node(buttons[unlock] + "/Padlock").texture.region = Rect2(500, 300, 100, 100)

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

func _get_buttons():
	for i in range(1, 6):
		var button = "VBoxContainer/HBoxContainer"
		if i > 2: button += "2"
		button += "/LevelButton-0" + str(i)
		buttons.push_back(button)

func _on_LevelsMenu_visibility_changed():
	for button in buttons:
		get_node(button).visible = visible
