extends Control

export(String) var solution

onready var textEdit = get_node("Body/TextEdit")
onready var textEditRef = get_node("Body/TextEditRef")
onready var labelClock = get_node("Header/HSplitContainer/LabelHead2")
var count = 1
signal solved

func fix():
	textEditRef.text = solution
	
func update_clock():
	labelClock.text = "12/11/10 05:22:%02d" % count
	count += 1
	count = count % 60

func _ready():
	fix()
	focus()
	update_clock()

func is_ok(text: String):
	var cmplen = min(text.length(), textEditRef.text.length())
	var ref = textEditRef.text.substr(0, cmplen)
	var cmp = text.substr(0, cmplen)
	return cmp == ref

func _on_TextEdit_text_changed():
	var color
	if is_ok(textEdit.text):
		color = Color(0.0, 0.0, 0.0)
	else:
		color = Color(1.0, 0.0, 0.0)
	textEdit.add_color_override("font_color", color)
	if textEdit.text == solution:
		print("solved!")
		emit_signal("solved")

func clear():
	textEdit.text = ""

func focus():
	textEdit.grab_focus()

func _on_Timer_timeout():
	update_clock()
