extends Sprite

var played = false
var finished = false

onready var audio = get_node("AudioStreamPlayer")

func levelFinished():
	audio.play()
	print_debug("please does it workd???")
	played = true

func _process(delta):
	if played and finished:
		queue_free()

func _on_AudioStreamPlayer_finished():
	finished = true
