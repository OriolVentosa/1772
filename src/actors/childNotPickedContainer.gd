extends Node2D

onready var interaction = get_node("Control/Interaction")
onready var collisionChild = get_node("Area2D")

var dialogueFinished = false
var wantsToJoin = true
var canInteract = false

export var texturePaths = []
var textures = []
var type = 1
onready var sprite = get_node("Area2D/NiñoAmarillo")

signal interact


func setTexture(i: int):
	for texturePath in texturePaths:
		textures.append(load(texturePath))
	sprite = get_node("Area2D/NiñoAmarillo")
	sprite.texture = textures[i]
	type = i

func finish(likedYou: bool, finishDialogue: bool):
	dialogueFinished = finishDialogue
	canInteract = false
	wantsToJoin = likedYou

# warning-ignore:unused_argument
func _process(delta):
	if !wantsToJoin and !dialogueFinished:
		if move(collisionChild, get_node("Base"), 3):
			queue_free()
	if !canInteract or dialogueFinished:
		return
	if Input.is_action_just_pressed("interaccio"):
		interaction.hide()
		emit_signal("interact")

func move(origin: Node2D, destination: Node2D, radius: float):
	var from := origin.get_global_transform().origin
	var to := destination.get_global_transform().origin
	var dir := direction(from, to)
	if inside_radius(from , to , radius) == false:
		origin.position += get_process_delta_time() * 300 * dir
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
	if module<radius:
		return true
	else:
		return false

func _on_Area2D_area_entered(area):
	if dialogueFinished:
		return
	canInteract = true
	interaction.show()

func _on_Area2D_area_exited(area):
	canInteract = false
	interaction.hide()
	if dialogueFinished:
		queue_free()

