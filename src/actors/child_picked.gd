extends KinematicBody2D

class_name ChildPicked

export var texturePaths = []
var textures = []

onready var sprite = get_node("NiñoAmarillo")
var isCatched = false
var type = 0

# Called when the node enters the scene tree for the first time.

func isCatchedSet(iC: bool):
	isCatched = iC

func destroyTheChild():
	queue_free()

func setTexture(i: int):
	for texturePath in texturePaths:
		textures.append(load(texturePath))
	print_debug(textures.size())
	print_debug(i)
	var anim_player := get_node("AnimationPlayer")
	anim_player.play("idle")
	var sprite = get_node("NiñoAmarillo")
	sprite.texture = textures[i]
	type = i
