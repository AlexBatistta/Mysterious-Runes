tool
extends Node2D

export (int, "WeakBasic", "StrongBasic", "MagicFlyer", "WeakArmored", "StrongArmored", "InvokerBoss", "Invoked") var type setget change_type

export (Array, int) var health = [50, 75, 75, 100, 150, 200]
export (Array, int) var hit_power = [5, 10, 15, 20, 25, 30]

func change_type(_type):
	type = _type
	$Enemies/SpriteBody.texture = load("res://Game/NPCs/SpriteBody/NPC-0" + str(type + 1) + ".png")
	$Enemies/SpriteColor.texture = load("res://Game/NPCs/SpriteColor/NPC-0" + str(type + 1) + ".png")

func change_color(_color):
	$Enemies/SpriteColor.modulate = _color

func _ready():
	$Vortex/AnimationVortex.play("Vortex")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
