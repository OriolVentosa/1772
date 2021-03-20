extends Node2D

signal terminal4Solved

func _on_Terminal_solved():
	emit_signal("terminal4Solved")
	enemy.hide()
	fila.fila[0].stopEnemySound()
	barrera.levelFinished()

onready var barrera = get_node("BarreraRoja")
onready var interactSound = get_node("interactSound")

onready var childSpawn = load("res://src/actors/childNotPickedContainer.tscn")
onready var enemy = get_node("Enemy")
onready var terminalTimer = get_node("TerminalTimer")
onready var spawns = []
onready var children = []
onready var fila = get_node("../Fila")

var dialogs = []

export var numberOfSpawns = 2
export var simpleDialogs = 2
export var multipleDialogs = 0

func getSpawns():
	var i = 1
	while i<numberOfSpawns+1:
		spawns.append(get_node("Spawn%d" % i))
		i = i+1

func esterilitzarNivel():
	for spawn in spawns:
		if spawn.wasPicked:
			spawn.levelDone = true

func getDialogs():
	var i = 0
	while i < simpleDialogs:
		dialogs.append(get_node("Dialogs/Dialog%d" %(i+1)))
		i=i+1

func _ready():
	getSpawns()
	getDialogs()
	pass

func _process(delta):
	pass

func _on_TerminalCompleta_enter_terminal():
	terminalTimer.start()
	enemy.show()
	fila.fila[0].playEnemySound()

func _on_TerminalCompleta_exit_terminal():
	terminalTimer.stop()
	enemy.hide()
	fila.fila[0].stopEnemySound()
	if !enemy.hasKid():
		enemy.returnBase()

func _on_ChildContainer1_interact():
	interactSound.play()
	fila.fila[0].canMove = false
	dialogs[0].show()

func _on_Dialog1_answer(ans):
	print_debug(ans)
	if ans == 1:
		children[0].finish(false,false)
	else:
		children[0].finish(true,true)
	spawns[0].wasPicked = true
	fila.fila[0].canMove = true

func _on_TerminalTimer_timeout():
	enemy.startChase()

func respawnChildren(first_spawn: bool):
	children = []
	var i = 1
	for spawn in spawns:
		if spawn.canSpawn(first_spawn):
			var child_instance = childSpawn.instance()
			child_instance.position = spawn.position
			child_instance.set_name("ChildContainer%d" %i)
			child_instance.setTexture(spawn.type)
			add_child(child_instance)
			child_instance.connect("interact",self,"_on_ChildContainer%d_interact" %i)
#			child_instance.connect("interact",self,"_on_ChildContainer%d_interact")
			children.append(get_node("ChildContainer%d" %i))
		else:
			children.append(get_node("ChildContainer%d" %i))
		i=i+1

func resetTerminalPassword():
	get_node("Node2D/TerminalCompleta").passwordCorrect = false

func _on_Portal1_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position

func _on_Portal2_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position
