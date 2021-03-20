extends Control

func _ready():
	get_node("LineEdit").grab_focus()

func _on_LineEdit_text_entered(new_text):
	if new_text.to_upper() == "START":
		get_tree().change_scene("res://src/intro/introScene.tscn")
