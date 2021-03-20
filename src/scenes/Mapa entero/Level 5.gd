extends Node2D

signal terminal5Solved

func _on_Terminal_solved():
	emit_signal("terminal5Solved")
	enemy.hide()
	barrera.levelFinished()
	fila.fila[0].stopEnemySound()

onready var barrera = get_node("BarreraRoja")
func esterilitzarNivel():
	for spawn in spawns:
		if spawn.wasPicked:
			spawn.levelDone = true

onready var interactSound = get_node("interactSound")

onready var childSpawn = load("res://src/actors/childNotPickedContainer.tscn")
onready var enemy = get_node("Enemy")
onready var terminalTimer = get_node("TerminalTimer")
onready var spawns = []
onready var children = []
onready var fila = get_node("../Fila")
onready var dealer = get_node("DealerRoom")

var dialogs = []

export var numberOfSpawns = 0
export var simpleDialogs = 0
export var multipleDialogs = 0

func getSpawns():
	var i = 1
	while i<numberOfSpawns+1:
		spawns.append(get_node("Spawn%d" % i))
		i = i+1

func getDialogs():
	var i = 0
	while i < simpleDialogs:
		dialogs.append(get_node("Dialog%d" %(i+1)))
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
	if !enemy.hasKid():
		enemy.returnBase()
	fila.fila[0].stopEnemySound()

func _on_ChildContainer1_interact():
	interactSound.play()
	fila.fila[0].canMove = false
	dialogs[0].show()

func _on_Dialog1_answer(ans):
	print_debug(ans)
	if ans == 1 and fila.hasKey:
		children[0].finish(true,true)
		spawns[0].wasPicked = true
	elif ans == 1 and !fila.hasKey:
		children[0].finish(true,false)
		spawns[0].wasPicked = false
	else:
		children[0].finish(true,false)
		spawns[0].wasPicked = false
	fila.fila[0].canMove = true

func _on_ChildContainer2_interact():
	fila.fila[0].canMove = false
	dialogs[1].show()

func _on_Dialog2_finished():
	children[1].finish(true,true)
	spawns[1].wasPicked = true
	fila.fila[0].canMove = false

func _on_TerminalTimer_timeout():
	enemy.startChase()

func respawnChildren(first_spawn: bool):
	children = []
	var i = 1
	for spawn in spawns:
		print_debug(spawn.canSpawn(first_spawn))
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
	get_node("Middle/TerminalCompleta").passwordCorrect = false

func _on_Portal1_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position

func _on_Portal2_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position

func _on_Portal3_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position

func _on_Portal4_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position

func _on_Portal5_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position
	fila.fila[0].songNumber = 4

func _on_Portal6_teleportPlayer(pos: Node2D):
	fila.fila[0].position = pos.global_position
	fila.fila[0].songNumber = 5

func _on_DealerRoom_finishDeal(ans: bool):
	if ans == true:
		dealChildren()
	fila.fila[0].canMove = true

func _on_DealerRoom_freezePlayer():
	interactSound.play()
	fila.fila[0].canMove = false
	if fila.fila.size() > 3:
		dealer.startDeal(true)
	else:
		dealer.startDeal(false)

func dealChildren():
	var size = fila.fila.size()
	var i = size-1
	fila.fila.remove(i)
	fila.childTypes.remove(i)
	i = 0
	while i<3:
		fila.spawn_dealer_child()
		i+=1

func resetDealer():
	dealer.dealDone = false
	dealer.resetDialog()


func _on_Dialog1_finished():
	children[0].finish(true,false)
	spawns[0].wasPicked = false
	fila.fila[0].canMove = true

func _on_LevelMusicPlay_area_entered(area):
	fila.fila[0].songNumber = 4
