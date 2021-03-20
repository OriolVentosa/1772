extends Control

export(String) var solution

onready var labelClock = get_node("Header/HSplitContainer/LabelHead2")
onready var lineEdit = get_node("Body/LineEdit")

var count = 1
signal correctPassword
signal incorrectPassword

func update_clock():
	labelClock.text = "12/11/10 05:22:%02d" % count
	count += 1
	count = count % 60

func _ready():
	clear()
	focus()
	update_clock()

func is_ok(text: String):
	var cmplen = min(text.length(), lineEdit.text.length())
	var ref = lineEdit.text.substr(0, cmplen)
	var cmp = text.substr(0, cmplen)
	return cmp == ref


func _on_LineEdit_text_entered(new_text):
	var color
	if is_ok(new_text):
		color = Color(0.0, 1.0, 0.0)
	else:
		color = Color(1.0, 0.0, 0.0)
	lineEdit.add_color_override("font_color", color)
	if new_text == solution:
		emit_signal("correctPassword")
	else:
		emit_signal("incorrectPassword")
	clear()
	color = Color(1.0,1.0,1.0)
	lineEdit.add_color_override("font_color", color)

func clear():
	lineEdit.text = ""

func focus():
	lineEdit.grab_focus()

func _on_Timer_timeout():
	update_clock()


