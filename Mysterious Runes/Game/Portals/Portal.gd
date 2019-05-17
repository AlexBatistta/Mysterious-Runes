extends Area2D

export var teleport = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if teleport:
		if !$"Portal-01/AnimationPlayer".is_playing():
			$"Portal-01/AnimationPlayer".play("Teleport")

func _on_Portals_body_entered(body):
	if body.name == "Player":
		$"Portal-01/AnimationPlayer".play("Activate")
		if body.specialPower:
			teleport = true
		

func _on_Portals_body_exited(body):
	if body.name == "Player":
		if !teleport:
			$"Portal-01/AnimationPlayer".play_backwards("Activate")

func _next_level():
	$"Portal-01/AnimationPlayer".play_backwards("Activate")
