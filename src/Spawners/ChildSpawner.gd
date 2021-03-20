extends Node2D

var wasPicked = false
var levelDone = false
export var type = 0

func canSpawn(first_spawn: bool):
	if first_spawn:
		return true
	if wasPicked and levelDone:
		return false
	elif !wasPicked:
		return false
	else:
		return true
