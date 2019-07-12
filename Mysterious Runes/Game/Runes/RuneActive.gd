extends Node2D

signal power_out

func _ready():
	visible = false

func _set_power():
	var frame
	match Global.power_rune:
		"Damage": frame = 0
		"Shield": frame = 1
		"Regeneration": frame = 2
		"Slow": frame = 3
		"Poison": frame = 4
		"Paralyze": frame = 5
		"Invoke": frame = 6
		"Fly": frame = 7
	
	$SpriteRune.frame = frame
	$AnimationPlayer.play("Power")
	if Global.power_rune != "Invoke":
		$RuneTimer.start(Global.timePower / 2)

func _on_RuneTimer_timeout():
	$AnimationPlayer.stop()
	visible = false
	emit_signal("power_out")
