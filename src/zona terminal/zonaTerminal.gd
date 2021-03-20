extends Node2D

onready var popup = get_node("PopUpText")
onready var terminal = get_node("Terminal")
onready var password = get_node("Password")
onready var porta = get_node("Porta")
onready var correctSound = get_node("Porta/CollisionShape2D/CorrectSound")
onready var incorrectSound = get_node("Porta/CollisionShape2D/IncorrectSound")

export var soundPaths = []

var canInteract = false
var solved = false
var passwordCorrect = false

signal enter_terminal
signal exit_terminal

func _ready():
	popup.hide()
	canInteract = false

func _process(delta):
	if !canInteract:
		return
	if passwordCorrect:
		if !password.visible and !terminal.visible and Input.is_action_just_pressed("interaccio"):
			terminal.show()
			terminal.focus()
			emit_signal("enter_terminal")
		if terminal.visible and Input.is_action_just_pressed("exit_terminal"):
			terminal.hide()
			terminal.clear()
			emit_signal("exit_terminal")
	else:
		if !password.visible and Input.is_action_just_pressed("interaccio"):
			password.show()
			password.focus()
		if password.visible and Input.is_action_just_pressed("exit_terminal"):
			password.hide()
			password.clear()

func _on_Terminal_solved():
	emit_signal("exit_terminal")
	terminal.hide()
	popup.hide()
	canInteract = false
	terminal.queue_free()
	popup.queue_free()
	porta.queue_free()
	
	solved = true


func _on_Password_correctPassword():
	correctSound.play()
	passwordCorrect = true
	password.hide()
	terminal.show()
	terminal.focus()
	emit_signal("enter_terminal")


func _on_Password_incorrectPassword():
	incorrectSound.play()


func _on_Zona_interaccio_area_entered(area):
	popup.show()
	canInteract = true

func _on_Zona_interaccio_area_exited(area):
	if solved:
		queue_free()
		return
	popup.hide()
	terminal.hide()
	terminal.clear()
	canInteract = false
