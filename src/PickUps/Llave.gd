extends Node2D

signal keyPicked

var canInteract = false
	
func _process(delta):
	if !is_instance_valid(self):
		return
	if Input.is_action_just_pressed("interaccio"):
		if canInteract:
			emit_signal("keyPicked")
			queue_free()


func _on_Area2D_area_entered(area):
	canInteract = true

func _on_Area2D_area_exited(area):
	if !is_instance_valid(self):
		return
	canInteract = false

