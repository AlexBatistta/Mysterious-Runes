tool
extends Area2D

export (int, "Big", "Small") var treeType = 0 setget change_tree
export (int, "Temporary", "Permanent") var runeType = 0 
export (String, "Slow_Down", "Poison", "Paralyze", "Invoke", "Fly") var permanent = "Slow_Down"
var temporary = ["Damage", "Shield", "Regeneration"]
var power = ""
var dropped = false

signal rune

func change_tree(_type):
	treeType = _type
	$Tree.frame = treeType
	$Rune.position.x = 5 if treeType == 1 else -15

func _ready():
	$Rune/Label.visible = false
	$Rune/Power.visible = false
	$Particles2D.emitting = true
	
	randomize()
	if runeType == 0:
		power = temporary[randi() % 3]
	else:
		power = permanent
	power = "Invoke"
	animation()
	$Rune/Label.text = power

func animation():
	var frame
	match power:
		"Damage": frame = 0
		"Shield": frame = 1
		"Regeneration": frame = 2
		"Slow_Down": frame = 3
		"Poison": frame = 4
		"Paralyze": frame = 5
		"Invoke": frame = 6
		"Fly": frame = 7
	$Rune/Power.frame = frame

func _hurt(_hit):
	dropped = true
	$Rune/AnimationPlayer.play("Drop")

func disabled_collision(_disabled):
	$Rune/CollisionShape2D.disabled = _disabled

func _on_Runes_body_entered(body):
	if body.name == "Player" && dropped:
		self.connect("rune", body, "rune", [power, runeType])
		self.emit_signal("rune")
		call_deferred("disabled_collision", true)
