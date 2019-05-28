tool
extends Node2D

export (int, "WeakBasic", "StrongBasic", "MagicFlyer", "WeakArmored", "StrongArmored", "InvokerBoss", "Invoked") var NPCtype

export (PackedScene) var NPCs

var color

func change_color(_color):
	color = _color

func _ready():
	$Vortex/AnimationPlayer.play("Vortex")

func _on_SpawnNPC_timeout():
	var newNPC = NPCs.instance()
	newNPC.setup(NPCtype, color, position)
	get_parent().add_child(newNPC)
	$SpawnNPC.start(5)

func _on_Spawn_body_entered(body):
	if body.is_in_group("Bullet"):
		body.queue_free()
		$Vortex/AnimationPlayer.play("Disappear")

func _on_VisibilityEnabler2D_screen_entered():
	$SpawnNPC.start(1)

func _on_VisibilityEnabler2D_screen_exited():
	$SpawnNPC.stop()
