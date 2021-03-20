extends Node2D

onready var child1 = get_node("ChildContainer")
onready var child2 = get_node("ChildContainer2")
onready var prota = get_node("Fila/Prota")
onready var dialog1 = get_node("ChildInteraction/DialogControl")
onready var dialog2 = get_node("ChildInteraction2/DialogControl2")

func _on_DialogControl_finished():
	prota.canMove = true
	dialog1.queue_free()
	child1.hide()
	child1.dialogueFinished = true


func _on_ChildContainer_interact():
	prota.canMove = false
	dialog1.show()

func _on_DialogControl2_finished():
	prota.canMove = true
	dialog2.queue_free()
	child2.hide()
	child2.dialogueFinished = true

func _on_ChildContainer2_interact():
	prota.canMove = false
	dialog2.show()
