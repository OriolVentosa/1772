extends Node2D

onready var rect1 = get_node("button1/ColorRect")
onready var rect2 = get_node("button2/ColorRect")
onready var rect3 = get_node("button3/ColorRect")

onready var sound = get_node("Interacted")

onready var solucio = get_node("Panel/Solution")

export var solucionText = "yeet"

var canInteract1 = false
var canInteract2 = false
var canInteract3 = false

var buttonColors = [1,1,1]

func _on_button1_area_entered(area):
	canInteract1 = true

func _on_button1_area_exited(area):
	canInteract1 = false

func _on_button2_area_entered(area):
	canInteract2 = true

func _on_button2_area_exited(area):
	canInteract2 = false

func _on_button3_area_entered(area):
	canInteract3 = true

func _on_button3_area_exited(area):
	canInteract3 = false

func _process(delta):
	if buttonColors == [1,2,2]:
		solucio.text = solucionText
	
	if Input.is_action_just_pressed("interaccio"):
		if canInteract1:
			sound.play()
			toggleColor(rect1,0)
		if canInteract2:
			sound.play()
			toggleColor(rect2,1)
		if canInteract3:
			sound.play()
			toggleColor(rect3,2)

func toggleColor(rectangle: ColorRect, i: int):
	if buttonColors[i] == 1:
		rectangle.color = "#14ff00"
		buttonColors[i]=2
	else:
		rectangle.color = "#ff0000"
		buttonColors[i]=1
