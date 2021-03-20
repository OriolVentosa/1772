extends Node2D

export var texturePaths = []
var pantalles = []
var pantallaActual = 0
onready var line = get_node("Panel/LineEdit")
onready var panel = get_node("Panel")
onready var musica = get_node("MusicaIntro")

func _ready():
	pantalles.append(get_node("FirstFrame"))
	pantalles.append(get_node("SecondFrame"))
	pantalles.append(get_node("Interaccion"))
	pantalles.append(get_node("ThirdFrame"))
	pantalles.append(get_node("FourthFrame"))
	pantalles.append(get_node("FifthFrame"))
	pantalles.append(get_node("SixthFrame"))
	
	pantalles[0].show()
	pantalles[0].play()

func _process(delta):
	if !musica.playing:
		musica.play()
	if pantallaActual == 1:
		pantalles[1].show()
		pantalles[1].play()
	elif pantallaActual == 2:
		pantalles[2].show()
		panel.show()
		line.grab_focus()
	elif pantallaActual == 3:
		pantalles[3].show()
		pantalles[3].play()
	elif pantallaActual == 4:
		pantalles[4].show()
		pantalles[4].play()
	elif pantallaActual == 5:
		pantalles[5].show()
		pantalles[5].play()
	elif pantallaActual == 6:
		pantalles[6].show()
		pantalles[6].play()
	elif pantallaActual == 7:
		get_tree().change_scene("res://src/scenes/Intro.tscn")

func _on_FirstFrame_animation_finished():
	pantallaActual = 1

func _input(ev):
	if ev is InputEventKey:
		if pantallaActual == 1:
			pantallaActual = 2
		if pantallaActual == 4:
			pantallaActual = 5
		if pantallaActual == 6:
			pantallaActual = 7


func _on_LineEdit_text_entered(new_text):
	if new_text.to_upper() == "OPEN":
		pantallaActual = 3
	elif new_text.to_upper() == "CLOSE":
		get_tree().quit()
	else:
		line.clear()

func _on_ThirdFrame_animation_finished():
	pantallaActual = 4

func _on_FifthFrame_animation_finished():
	pantallaActual = 6
