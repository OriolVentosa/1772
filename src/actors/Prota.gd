extends KinematicBody2D

signal protaCaught

export var speed:= Vector2(10,10)
var velocity:=Vector2.ZERO
var im:= bool(false)
var fd:=Vector2.ZERO
var player_input:= Vector2.ZERO
var _numberOfChilds := 0

var canInteract = false
var canMove = true
var isCatched = false

var enemySoundEnabled = false

var songs = []
var songNumber = 0

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")
onready var sound_player = get_node("Passos")
onready var sound_enemy = get_node("Enemy")

func process_animation(face_direction: Vector2,is_moving:bool):
	if face_direction == Vector2.ZERO:
		anim_player.play("idle_right")
	elif face_direction.y == -1:
		if is_moving == true:
			anim_player.play("walk_up")
		else:
			anim_player.play("idle_up")
	elif face_direction.y == 1:
		if is_moving == true:
			anim_player.play("walk_down")
		else:
			anim_player.play("idle_down")
	elif face_direction.y == 0 and face_direction.x == 1:
		if is_moving == true:
			anim_player.play("walk_right")
		else:
			anim_player.play("idle_right")
	else:
		if is_moving == true:
			anim_player.play("walk_left")
		else:
			anim_player.play("idle_left")
	if is_moving:
		if !sound_player.playing:
			sound_player.play()
	else:
		sound_player.stop()

func _ready():
	songs.append(get_node("Level1"))
	songs.append(get_node("Level2"))
	songs.append(get_node("MusicaChunga"))
	songs.append(get_node("Grillos"))
	songs.append(get_node("NivellBlanc"))
	songs.append(get_node("Circ"))

func stopSongs(i: int):
	var j=0
	while j<songs.size():
		if j != i:
			songs[j].stop()
		j+=1

func stopAllSongs():
	for s in songs:
		s.stop()

# warning-ignore:unused_argument
func _process(delta):
	if enemySoundEnabled:
		if !sound_enemy.playing:
			sound_enemy.play()
		stopAllSongs()
	else:
		stopSongs(songNumber)
		if !songs[songNumber].playing:
			songs[songNumber].play()
	if (isCatched):
		emit_signal("protaCaught")
	if canInteract:
		if Input.is_action_just_pressed("interaccio"):
			canMove = false
			velocity = Vector2.ZERO
		if Input.is_action_just_pressed("exit_terminal"):
			canMove = true

# warning-ignore:unused_argument
func _physics_process(delta) -> void:
	if !canMove:
		 return
	player_input = get_player_direction()
	if player_input != Vector2.ZERO:
		fd = player_input
		im = true
	else:
		im = false
	velocity = move_and_slide(speed*player_input, Vector2.UP)
	process_animation(fd,im)

func get_player_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right")-Input.get_action_strength("left"),
		Input.get_action_strength("down")-Input.get_action_strength("up"))

# warning-ignore:unused_argument
func _on_TerminalDetector_area_entered(area):
	canInteract = true

# warning-ignore:unused_argument
func _on_TerminalDetector_area_exited(area):
	canInteract = false

# warning-ignore:unused_argument
func isCatchedSet(iC: bool):
	isCatched = true
	canMove = false

func destroyTheChild():
	queue_free()

func setPosition(pos: Vector2):
	position = pos

func playEnemySound():
	enemySoundEnabled = true

func stopEnemySound():
	enemySoundEnabled = false
