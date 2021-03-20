extends Node2D

signal terminal1Solved

onready var interactSound = get_node("interactSound")

onready var childSpawn = load("res://src/actors/childNotPickedContainer.tscn")
onready var enemy = get_node("Enemy")
onready var terminalTimer = get_node("TerminalTimer")
onready var fila = get_node("../Fila")
onready var spook = get_node("Scare")

onready var barrera = get_node("BarreraRoja")

var doorSoundPlayed = false

var spawns = []
var children = []

export var numberOfSpawns = 1

var dialogs = []

func getSpawns():
	var i = 0
	while i<numberOfSpawns:
		spawns.append(get_node("Spawn%d" %(i+1)))
		i = i+1


func esterilitzarNivel():
	for spawn in spawns:
		if spawn.wasPicked:
			spawn.levelDone = true

func getDialogs():
	dialogs.append(get_node("Dialog1"))

func _ready():
	getSpawns()
	getDialogs()
	pass

func _process(delta):
	pass

func _on_TerminalCompleta_enter_terminal():
	terminalTimer.start()

func _on_TerminalCompleta_exit_terminal():
	terminalTimer.stop()
	if !enemy.hasKid():
		enemy.returnBase()

func _on_ChildContainer1_interact():
	interactSound.play()
	fila.fila[0].canMove = false
	dialogs[0].show()

func _on_Dialog1_finished():
	children[0].finish(true,true)
	spawns[0].wasPicked = true
	fila.fila[0].canMove = false

func _on_TerminalTimer_timeout():
	enemy.startChase()

func _on_Terminal_solved():
	barrera.levelFinished()
	spook.turnOn()
	emit_signal("terminal1Solved")
	for spawn in spawns:
		spawn.levelDone = true

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
			children.append(get_node("ChildContainer%d" %i))
		else:
			children.append(get_node("ChildContainer%d" %i))
		i=i+1

func resetTerminalPassword():
	get_node("Middle/TerminalCompleta").passwordCorrect = false

func _on_Area2D_area_entered(area):
	if !doorSoundPlayed:
		get_node("Puerta").play()
		doorSoundPlayed = true
