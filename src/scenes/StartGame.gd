extends Area2D

func _on_StartGame_area_entered(area):
	get_tree().change_scene("res://src/scenes/Mapa entero/EntireMap.tscn")

