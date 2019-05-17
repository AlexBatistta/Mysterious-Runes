extends Control

var transition = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$ColorRect/AnimationPlayer.play("Fade")
		self.can_process()
