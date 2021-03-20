extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	anim_player.play("idle")
