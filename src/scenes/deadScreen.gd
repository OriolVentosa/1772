extends Control

signal respawn

onready var lineEdit = get_node("LineEdit")

func _on_LineEdit_text_entered(new_text):
	if new_text.to_upper() == "RESTART":
		hide()
		emit_signal("respawn")
		lineEdit.clear()
	
	if new_text.to_upper() == "QUIT":
		get_tree().quit()

func _on_LineEdit_text_changed(new_text):
	var color
	if new_text.to_upper() == "RESTART":
		color = Color(0.0, 1.0, 0.0)
	elif new_text.to_upper() == "QUIT":
		color = Color(1.0, 0.0, 0.0)
	else:
		color = Color(1.0,1.0,1.0)
	lineEdit.add_color_override("font_color", color)

func _on_LineEdit_visibility_changed():
	if visible:
		lineEdit.focus_mode = true
		lineEdit.grab_focus()
