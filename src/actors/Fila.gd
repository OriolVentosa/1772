extends Node2D

signal ded

var hasRose = false
var hasKey = false
var currentChildContainer
var child
var prota
var spawn
var childSpawned = false
var areaI
var lastKidCatched = false
var childTypes = [] 
onready var fila := [get_node("Prota")]

export var followSpeed := 150.0
export var Radius := 100.0

func _ready():
	child = load("res://src/actors/child_picked.tscn")
	prota = load("res://src/actors/Prota.tscn")
	spawn = get_node("../Spawn")

# warning-ignore:unused_argument
func _process(delta):
	if fila.size() == 0:
		emit_signal("ded")
	if currentChildContainer != null:
		if currentChildContainer.dialogueFinished and currentChildContainer.wantsToJoin:
			if childSpawned:
				return
			spawn_child(currentChildContainer.type)
			currentChildContainer.hide()
			childSpawned = true
			currentChildContainer = null
 
func spawn_player(pos: Node2D):
	var prota_instance = prota.instance()
	prota_instance.position = pos.position
	prota_instance.set_name("Prota")
	add_child(prota_instance)
	fila.append(prota_instance)
	fila[0].canMove = true

func spawn_child(i: int):
	var child_instance = child.instance()
	child_instance.position = areaI.get_global_transform().origin - self.get_global_transform().origin
	child_instance.set_name("child")
	child_instance.setTexture(i)
	add_child(child_instance)
	fila.append(child_instance)
	childTypes.append(i)
	fila[0].canMove = true

func spawn_child_after_death(i: int):
	var child_instance = child.instance()
	child_instance.position = spawn.position
	child_instance.set_name("child")
	child_instance.setTexture(i)
	add_child(child_instance)
	fila.append(child_instance)
	childTypes.append(i)
	fila[0].canMove = true

func spawn_dealer_child():
	var child_instance = child.instance()
	child_instance.position = fila[0].position
	child_instance.set_name("child")
	child_instance.setTexture(4)
	add_child(child_instance)
	fila.append(child_instance)
	childTypes.append(4) #canviar per el del dealer
	fila[0].canMove = true

func _on_ChildDetector_area_entered(area):
	areaI = area
	currentChildContainer = area.get_parent()

# warning-ignore:unused_argument
func _on_ChildDetector_area_exited(area):
	currentChildContainer = null
	childSpawned = false

# warning-ignore:unused_argument
func _physics_process(delta):
	updateChildren()

func updateChildren():
	if lastKidCatched == null:
		return
	if(fila.size()>1):
		var j=0
		lastKidCatched = fila[fila.size()-1].isCatched
		if lastKidCatched:
			j=1
		var i = 1
		while i < fila.size()-j:
			moveKid(fila[i],fila[i-1],Radius)
			i=i+1

# warning-ignore:shadowed_variable
func moveKid(child: Node2D, front_child: Node2D, radius: float):
	var child_pos := child.transform.get_origin()
	var front_child_pos := front_child.transform.get_origin()
	if inside_radius(child_pos , front_child_pos , radius) == false:
		child.move_and_slide(followSpeed*desiredDirection(child_pos,front_child_pos), Vector2.UP)
func desiredDirection(start: Vector2, end: Vector2):
	var result := end-start
	return result.normalized()

func inside_radius(point: Vector2, center: Vector2, radius: float):
	var vector := point-center
	var module := sqrt(vector.x*vector.x + vector.y*vector.y)
	if module<radius:
		return true
	else:
		return false

func handleRespawn(numberOfChildren: int, typeOf):
	var childDetector = get_node("Prota/ChildDetector")
	var portalDetector = get_node("Prota/PortalDetector")
	var i = 0
	while i<numberOfChildren:
		print_debug(typeOf)
		spawn_child_after_death(typeOf[i])
		i=i+1
	childDetector.connect("area_entered",self,"_on_ChildDetector_area_entered")
	childDetector.connect("area_exited",self,"_on_ChildDetector_area_exited")
