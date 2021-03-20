extends Area2D

signal teleportPlayer
onready var exit = get_node("finalTp")

func teleport():
	emit_signal("teleportPlayer",exit)

func _on_Area2D_area_entered(area):
	teleport()
