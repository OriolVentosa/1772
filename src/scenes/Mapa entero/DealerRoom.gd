extends Node2D

signal freezePlayer
signal finishDeal
signal toggle

var canPlayerDeal = false
var dealDone = false

onready var dialog = get_node("DealerDialog")
onready var textAfterDeal = get_node("DealerDialog/Panel3")

var canInteract = false

func _on_Area2D_area_entered(area):
	canInteract = true

func _on_Area2D_area_exited(area):
	canInteract = false

func startDeal(canDeal: bool):
	canPlayerDeal = canDeal

func _process(delta):
	if canInteract:
		if Input.is_action_just_pressed("interaccio"):
			emit_signal("freezePlayer")
			dialog.show()
			if !canPlayerDeal:
				dialog.lied()

func _on_DealerDialog_answer(ans):
	if ans == 1 and canPlayerDeal:
		emit_signal("finishDeal", true)
		dealDone = true
		dialog.finished = true
	else:
		emit_signal("finishDeal", false)

func resetDialog():
	dialog.wasLied = false
	dialog.finished = false
