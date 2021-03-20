extends Control

export(String) var pregunta
export(String) var ans1
export(String) var ans2
export(String) var childResponse1
export(String) var childResponse2
export(String) var childResponseLied

onready var preguntaLabel = get_node("Panel/VBox/LabelPregunta")
onready var caret1 = get_node("Panel/VBox/HBox1/Caret1")
onready var caret2 = get_node("Panel/VBox/HBox2/Caret2")
onready var label1 = get_node("Panel/VBox/HBox1/Label1")
onready var label2 = get_node("Panel/VBox/HBox2/Label2")
onready var response = get_node("Panel2/ChildResponse")
onready var panel1 = get_node("Panel")
onready var panel2 = get_node("Panel2")
onready var panel3 = get_node("Panel3")

#onready var timer = get_node("Timer")
signal answer(ans)
var ans = 1
var wasLied = false
var finished = false

var delay = 0

func _ready():
	preguntaLabel.text = "\"" + pregunta + "\""
	label1.text = ans1
	label2.text = ans2
	caret1.show()
	caret2.hide()
	ans = 1

func _process(delta):
	if !visible:
		return
	if finished:
		panel1.hide()
		panel2.hide()
		panel3.show()
		if Input.is_action_just_released("interaccio"):
			if delay > 0.5:
				delay = 0
				emit_signal("answer", -1)
				hide()
		delay+=delta
		return
	
	if Input.is_action_just_pressed("up"):
		caret1.show()
		caret2.hide()
		ans = 1
	if Input.is_action_just_pressed("down"):
		caret1.hide()
		caret2.show()
		ans = 2
	if delay > 0.5:
		if panel2.visible:
			if Input.is_action_just_released("interaccio"):
				emit_signal("answer", ans)
				hide()
				panel2.hide()
				panel1.show()
				delay = 0
				wasLied = false
				caret1.show()
				caret2.hide()
				ans = 1
	if delay > 0.5:
		if panel1.visible:
			if Input.is_action_just_released("interaccio"):
				panel1.hide()
				if ans == 1 and !wasLied:
					response.text = childResponse1
				elif ans == 1 and wasLied:
					response.text = childResponseLied
				else:
					response.text = childResponse2
				panel2.show()
				delay = 0
	delay+=delta

func lied():
	wasLied = true
