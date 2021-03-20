extends Node2D

export var numberOfLevels = 5

onready var gridSnaper = get_node("GridSnaper")
onready var prota = get_node("Fila/Prota")
onready var deathScreen = get_node("GridSnaper/DeathScreen")
onready var fila = get_node("Fila")
onready var spawnPoint = get_node("Spawn")
onready var PickUps = get_node("PickUps")

onready var levelDoneSound = get_node("LevelDone")
onready var rose = get_node("PickUps/Rose")
onready var key = get_node("PickUps/Key")
onready var roseSpawn = load("res://src/PickUps/Rose.tscn")
onready var keySpawn = load("res://src/PickUps/Llave.tscn")
var playerHasRose = false
var playerHasKey = false

export var interLateral= Vector2(320,395)
export var interMig = Vector2(210,340)

var gridPosition = Vector2.ZERO
var previousGridPosition = Vector2.ZERO

var colMid = null
var colRight = null
var colLeft = null
var level = 1
var levelSaved = 0
var childsAfterTerminal = 0
var typeOfChildsAfterTerminal = []
var protaCaught=false
var protaDead
var levels = []
var childrenDead = 0

func get_cols():
	colMid = get_node("Level %d/ColMid" % level)
	colRight = get_node("Level %d/ColRight" % level)
	colLeft = get_node("Level %d/ColLeft" % level)

func get_levels():
	var i = 1
	while i<numberOfLevels+1:
		levels.append(get_node("Level %d" % i))
		i = i+1

func _ready():
	get_cols()
	get_levels()
	setCollisions(colMid, 1)
	setCollisions(colRight, 0)
	setCollisions(colLeft, 0)
	levels[0].respawnChildren(true)
	levels[1].respawnChildren(true)
	levels[2].respawnChildren(true)
	levels[3].respawnChildren(true)
	levels[4].respawnChildren(true)

func _process(delta):
	if fila.fila.size()==0 and !deathScreen.visible:
		deathScreen.show() 
	if fila.fila.size()!=0:
		gridSnaper.player = fila.fila[0]
	if(protaCaught):
		return
	udpateGridPosition()
	changeScene()
	saveGridPosition()

func udpateGridPosition():
	gridPosition = gridSnaper.getGridPos()

func setCollisions(col, val):
	col.set_collision_layer_bit(0, val)
	col.set_collision_mask_bit(0, val)

func changeScene():
	if gridPosition.x<-1 or gridPosition.x>1:
		return
	if gridPosition == previousGridPosition:
		return
	level = int(abs(gridPosition.y) / 2) + 1
	if int(abs(gridPosition.y)) % 2 == 0:
		get_cols()
	else:
		return false
	if prota.position.x>350 and prota.position.x<670:
		if gridPosition.x == 1:
			setCollisions(colMid, 0)
			setCollisions(colRight, 1)
		elif gridPosition.x == -1:
			setCollisions(colMid, 0)
			setCollisions(colLeft, 1)
		elif gridPosition.x == 0:
			setCollisions(colMid, 1)
			setCollisions(colRight, 0)
			setCollisions(colLeft, 0)
		return false
	var newposition = null
	if gridPosition.x == 1:
		newposition = entrarSalaLateral(prota.position)
		setCollisions(colMid, 0)
		setCollisions(colRight, 1)
	elif gridPosition.x == -1:
		newposition = entrarSalaLateral(prota.position)
		setCollisions(colMid, 0)
		setCollisions(colLeft, 1)
	elif gridPosition.x == 0:
		newposition = entrarSalaMig(prota.position)
		setCollisions(colMid, 1)
		setCollisions(colRight, 0)
		setCollisions(colLeft, 0)
	
	prota.setPosition(newposition)

func entrarSalaLateral(pos: Vector2):
	var r = (interLateral.y-interLateral.x)/(interMig.y-interMig.x)
	var pos_y_prov = pos.y-(gridPosition.y*576)
	pos_y_prov = (pos_y_prov - interMig.x)*r+interLateral.x
	pos.y = pos_y_prov + (gridPosition.y*576)
	return pos
	
func entrarSalaMig(pos: Vector2):
	var r = (interMig.y-interMig.x)/(interLateral.y-interLateral.x)
	var pos_y_prov = pos.y-(gridPosition.y*576)
	pos_y_prov = (pos_y_prov - interLateral.x)*r+interMig.x
	pos.y = pos_y_prov + (gridPosition.y*576)
	return pos

func saveGridPosition():
	previousGridPosition = gridPosition

func _on_Level_1_terminal1Solved():
	prota.canMove = true
	levelSaved = 1
	playerHasRose = fila.hasRose
	playerHasKey = fila.hasKey
	childsAfterTerminal = fila.fila.size()-1
	typeOfChildsAfterTerminal = []
	for child in fila.childTypes:
		typeOfChildsAfterTerminal.append(child)
	print_debug(typeOfChildsAfterTerminal)
	spawnPoint.position = prota.position
	beginChildGenocide()

func _on_Level_2_terminal2Solved():
	prota.canMove = true
	levelSaved = 2
	playerHasRose = fila.hasRose
	playerHasKey = fila.hasKey
	childsAfterTerminal = fila.fila.size()-1
	for child in fila.childTypes:
		typeOfChildsAfterTerminal.append(child)
	spawnPoint.position = prota.position
	beginChildGenocide()

func _on_Level_3_terminal3Solved():
	prota.canMove = true
	print_debug("can move")
	levelSaved = 3
	playerHasRose = fila.hasRose
	playerHasKey = fila.hasKey
	childsAfterTerminal = fila.fila.size()-1
	for child in fila.childTypes:
		typeOfChildsAfterTerminal.append(child)
	spawnPoint.position = prota.position
	beginChildGenocide()

func _on_Level_4_terminal4Solved():
	prota.canMove = true
	levelSaved = 4
	playerHasRose = fila.hasRose
	playerHasKey = fila.hasKey
	childsAfterTerminal = fila.fila.size()-1
	for child in fila.childTypes:
		typeOfChildsAfterTerminal.append(child)
	spawnPoint.position = prota.position
	beginChildGenocide()

func _on_Level_5_terminal5Solved():
	prota.canMove = true
	levelSaved = 5
	playerHasRose = fila.hasRose
	playerHasKey = fila.hasKey
	childsAfterTerminal = fila.fila.size()-1
	for child in fila.childTypes:
		typeOfChildsAfterTerminal.append(child)
	spawnPoint.position = prota.position
	#SomeDaySaveDealer

func beginChildGenocide():
	levels[0].esterilitzarNivel()
	levels[1].esterilitzarNivel()
	levels[2].esterilitzarNivel()
	levels[3].esterilitzarNivel()
	levels[4].esterilitzarNivel()

func _on_Prota_protaCaught():
	protaCaught = true
	gridSnaper.dontUpdate = true

func _on_Fila_ded():
	#open dea
	pass

func enableGrid():
	protaCaught = false
	gridSnaper.dontUpdate = false

func _on_DeathScreen_respawn():
	levels[levelSaved].resetTerminalPassword()
	fila.spawn_player(spawnPoint)
	fila.handleRespawn(childsAfterTerminal,typeOfChildsAfterTerminal)
	if levelSaved != 1:
		fila.fila[0].get_node("pointLight").energy = 1
	prota = fila.fila[0]
	gridSnaper.player = fila.fila[0]
	gridSnaper.restartGame()
	enableGrid()
	var i=0
	while i<5:
		levels[i].get_node("TerminalTimer").start(-1)
		levels[i].get_node("TerminalTimer").stop()
		levels[i].respawnChildren(false)
		i=i+1
	respawnSpecialProps()
	fila.hasRose = playerHasRose
	levels[4].resetDealer()

func respawnSpecialProps():
	if fila.hasRose and (levels[2].spawns[0].canSpawn(false) or is_instance_valid(levels[2].children[0])):
		#dangerous
		fila.hasRose = false
		rose = roseSpawn.instance()
		#jajfsdjfajsdfjasdf
		rose.position = rose.position
		rose.set_name("Rose")
		PickUps.add_child(rose)
		rose.connect("rosePicked",self,"_on_Rose_rosePicked")
	if fila.hasKey and (levels[1].spawns[0].canSpawn(false) or is_instance_valid(levels[1].children[0])):
		#dangerous
		fila.hasKey = false
		key = keySpawn.instance()
		key.set_name("Key")
		PickUps.add_child(key)
		key.connect("keyPicked",self,"_on_Key_keyPicked")

func _on_Rose_rosePicked():
	fila.hasRose = true

func _on_Key_keyPicked():
	fila.hasKey = true

func _on_TurnOffPlayerLight_area_entered(area):
	prota.get_node("pointLight").energy = 0

func _on_TurnOnPlayerLight2_area_entered(area):
	prota.get_node("pointLight").energy = 1

func _on_Enemy_killedChildren():
	childrenDead += 1
