extends Node2D

onready var face1 = get_node("Face1")
onready var face2 = get_node("Face2")
onready var sount = get_node("sound")
export var delay = 0.5
export var iterations = 1.5
var flicker = false
var timer = 0
var iteration = 0

func turnOn():
	flicker = true

func _physics_process(delta):
	if flicker:
		if !sount.playing:
			sount.play()
		timer -= delta
		if timer<=0:
			if iteration == 0.5:
				print_debug("???")
				face2.show()
			else:
				face1.show()
			iteration += 0.5
			timer = delay
			if(iteration>=iterations):
				hide()
				flicker = false
