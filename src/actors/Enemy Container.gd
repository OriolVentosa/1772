extends Node2D

export var radius := 40.0
export var followSpeed := 100.0

onready var escena = get_tree().current_scene
onready var fila = get_node("../Fila")
onready var enemy = get_node("Enemy")
onready var animator = get_node("Enemy/AnimationPlayer")
onready var base = get_node("Base")

var chasing = false
var catchedKid = false
var arrivedBase = false
var ultimNen
var mainCharacterDead = false
var exitedTerminal = false
var target = null

func _ready():
	animator.play("idle")

func firstChase():
	var lenght = fila.fila.size()
	ultimNen = fila.fila[lenght-1]
	chasing = true

# warning-ignore:unused_argument
func _physics_process(delta):
	if mainCharacterDead:
		 return
	if target != null:
		move(enemy, target, 10)
		return
	if chasing:
		moveToKid(enemy,ultimNen,radius)
	elif exitedTerminal:
		returnBase()
	elif catchedKid:
		moveBaseWithChild()
		take_child()
	elif arrivedBase:
		dispatchKid()
		getNextKid()
		startChase()

func dispatchKid():
	var copyUltimNen = ultimNen
	copyUltimNen.destroyTheChild()
	var lastIndex = fila.fila.size()-1
	fila.fila.remove(lastIndex)

func getNextKid():
	var lenght = fila.fila.size()
	if lenght > 0:
		ultimNen = fila.fila[lenght-1]
	else:
		mainCharacterDead = true
		arrivedBase = false
		catchedKid = false
		chasing = false
		exitedTerminal = false

func setExitTerminal(tf: bool):
	if tf == true:
		if catchedKid == false:
			exitedTerminal = true
			chasing = false
	else:
		if catchedKid == false:
			exitedTerminal = false
			chasing = true

func startChase():
	target = fila.fila[fila.fila.size()-1]
	return
	arrivedBase = false
	catchedKid = false
	exitedTerminal = false
	chasing = true

func hasKid():
	return catchedKid

# warning-ignore:shadowed_variable
func moveToKid(ene: Node2D, chi: Node2D, radius: float):
	var kidCatched = move(ene,chi,radius)
	if kidCatched:
		chasing = false
		catchedKid = true
		ultimNen.isCatchedSet(true)

func returnBase():
# warning-ignore:unused_variable
	var arrived = move(enemy,base,10)
	chasing = false

func moveBaseWithChild():
	var arrived = move(enemy,base,10)
	if arrived:
		chasing = false
		catchedKid = false
		arrivedBase = true

func take_child():
	move(ultimNen, enemy, 30.0)

# warning-ignore:shadowed_variable
func move(origin: Node2D, destination: Node2D, radius: float):
	print("from: %s, to: %s" % [str(origin.transform.get_origin()), str(destination.transform.get_origin())])
	var origin_pos := origin.transform.get_origin()
	var destination_pos := destination.transform.get_origin()
	if inside_radius(origin_pos , destination_pos , radius) == false:
		origin.position += get_process_delta_time()*followSpeed*desiredDirection(origin_pos,destination_pos)
		return false
	else:
		return true

func desiredDirection(start: Vector2, end: Vector2):
	var result := end-start
	return result.normalized()

# warning-ignore:shadowed_variable
func inside_radius(point: Vector2, center: Vector2, radius: float):
	var vector := point-center
	var module := sqrt(vector.x*vector.x + vector.y*vector.y)
	if module<radius:
		return true
	else:
		return false
