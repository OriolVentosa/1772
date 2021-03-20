extends Node2D

signal killedChildren

onready var parent = get_parent().get_parent()
onready var fila = parent.get_node("Fila")
onready var animator = get_node("AnimationPlayer")
onready var base = get_node("../Base")
onready var childScream = get_node("childScream")

export var radius := 40.0
export var followSpeed := 100.0

var target = null
var grabbed = null

func _ready():
	animator.play("idle")

# warning-ignore:unused_argument
func _physics_process(delta):
	if target == null:
		return
	# if arrived to non-base target
	if move(self, target, radius) and target != base:
		# grab it, return to base
		childScream.play()
		target.isCatched = true
		grabbed = target
		target = base
	# if going back to base with a grabbed kid/player
	if target == base and grabbed != null:
		# move the grabbed entity towards the base
		if move(grabbed, base, radius):
			# if got to dest, destroy entity
			if fila.fila.size()>1:
				fila.childTypes.remove(fila.childTypes.size()-1)
			fila.fila.erase(grabbed)
			grabbed.destroyTheChild()
			emit_signal("killedChildren")
			target = null
			grabbed = null

func startChase():
	if fila.fila.size() >0:
		target = fila.fila[fila.fila.size()-1]
	else:
		target = null

func returnBase():
	target = base

func hasKid():
	return grabbed != null

func move(origin: Node2D, destination: Node2D, radius: float):
	var from := origin.get_global_transform().origin
	var to := destination.get_global_transform().origin
	var dir := direction(from, to)
	if inside_radius(from , to , radius) == false:
		origin.position += get_process_delta_time() * followSpeed * dir
		return false
	else:
		return true

func direction(start: Vector2, end: Vector2) -> Vector2:
	var result := end-start
	return result.normalized()

# warning-ignore:shadowed_variable
func inside_radius(point: Vector2, center: Vector2, radius: float):
	var vector := point-center
	var module := sqrt(vector.x*vector.x + vector.y*vector.y)
	return module < radius
