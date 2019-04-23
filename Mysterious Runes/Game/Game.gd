extends Node2D

func _process(delta):
	$Player/Camera2D.position = get_node("Player/Player").position 
	pass
