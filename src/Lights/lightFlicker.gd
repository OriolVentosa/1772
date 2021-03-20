extends Node2D
var darkness
export var delay = 0.25
export var iterations = 4
var startEnergy = 0
var flicker = false
var timer = 0
var iteration = 0

func _ready():
	darkness = get_node("darkness")
	darkness.energy = 0.0

func turnOn():
	flicker = true

func _physics_process(delta):
	if flicker:
		timer -= delta
		if timer<=0:
			if darkness.energy > 0.0:
				print_debug("flick1")
				darkness.energy = 0.0
			else:
				print_debug("flick2")
				darkness.energy = 1.0
			iteration += 0.5
			timer = delay
			if(iteration>=iterations):
				darkness.energy = 1.0
				flicker = false
