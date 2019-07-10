extends Node2D

signal power_out

func _ready():
	visible = false

func _set_power(_power):
	var frame
	match _power:
		"Damage": frame = 0
		"Shield": frame = 1
		"Regeneration": frame = 2
		"Slow_Down": frame = 3
		"Poison": frame = 4
		"Paralyze": frame = 5
		"Invoke": frame = 6
		"Fly": frame = 7
	
	$SpriteRune.frame = frame
	$AnimationPlayer.play("Power")
	if _power != "Invoke":
		$RuneTimer.start(Global.timePower)

func _on_RuneTimer_timeout():
	$AnimationPlayer.stop()
	visible = false
	emit_signal("power_out")
	Global.rune_active = false
