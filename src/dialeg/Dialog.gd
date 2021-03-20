extends Control

export(Array) var text
onready var label = get_node("Panel/Label")
onready var caret = get_node("Panel/Label2")
onready var timer = get_node("Timer")
signal finished
var idx = 0

func put():
	label.text = "\"" + text[idx] + "\""

func _ready():
	put()

func _process(delta):
	if !visible:
		return
	if Input.is_action_just_pressed("interaccio"):
		idx += 1
		if idx == text.size():
			print("finished!")
			emit_signal("finished")
			hide()
			idx = 0
			label.text = "\"" + text[0] + "\""
			return
		if idx == text.size()-1:
			caret.visible = false
			timer.stop()
		put()


func _on_Timer_timeout():
	caret.visible = !caret.visible
