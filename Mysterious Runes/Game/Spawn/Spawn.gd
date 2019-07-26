tool
extends Node2D

#Script que controla la generación de NPCs cada cierto tiempo
#Establece hasta que tipo de NPC se puede generar y si pueden
#aparecer enemigos voladores

export (int, "WeakBasic", "StrongBasic", "MagicFlyer", "WeakArmored", "StrongArmored", "InvokerBoss") var NpcType
export (bool) var flyerSpawn = true
export (PackedScene) var NPCs
var timeSpawn = 8
var health = 25

func _ready():
	#A medida que se pasa de nivel, disminuye el tiempo de spawn
	#y aumenta la vida del nodo
	if Global.current_level > 0:
		timeSpawn -= Global.current_level
		health = 25 * Global.current_level
	
	#Reproduce la animación
	$Vortex/AnimationPlayer.play("Vortex")
	
	randomize()

#Acción para cuando finaliza el tiempo
func _on_SpawnNPC_timeout():
	#Otiene el tipo de NPC a generar
	NpcType = randi() % (NpcType + 1)
	if !flyerSpawn:
		if NpcType == 2: NpcType -= 1
	
	#Instancia un nuevo NPC
	var newNPC = NPCs.instance()
	newNPC.setup(NpcType, position + Vector2(0, 50))
	call_deferred("_spawn", newNPC)
	$SpawnNPC.start(timeSpawn)
	
	#Si es un jefe, conecta la señal
	if NpcType == 5:
		newNPC.connect("spawn_invoked", self, "_spawn_invoked")

#Acción de colisión con las balas
func _hurt(_hit):
	#Repreduce el sonido
	$SpawnSound.play()
	
	#Disminuye la vida
	health -= _hit
	#Si llega a 0, reproduce la animación
	if health <= 0:
		$Vortex/AnimationPlayer.play("Disappear")

#Cuando aparece en pantalla se inicia el tiempo para generar
func _on_VisibilityEnabler2D_screen_entered():
	$SpawnNPC.start(1)

#Si sale de pantalla se para el contador
func _on_VisibilityEnabler2D_screen_exited():
	$SpawnNPC.stop()

#Invocación del jefe, crea a otro NPC débil
func _spawn_invoked(_position):
	var newInvoked_01 = NPCs.instance()
	newInvoked_01.setup(randi() % 2, _position - Vector2(150, 200))
	call_deferred("_spawn", newInvoked_01)
	
	#Reproduce sonido
	$SpawnSound.play()

#Agrega a escena al nuevo NPC
func _spawn(_new):
	get_parent().add_child(_new)