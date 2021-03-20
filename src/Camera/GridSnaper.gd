extends Position2D

var grid_size = Vector2(1024,576)
var grid_position = Vector2()

onready var parent = get_parent()
onready var player = parent.get_node("Fila/Prota")

var dontUpdate = false

func _ready():
	set_as_toplevel(true)
	udpate_grid_position()

func _physics_process(delta):
	udpate_grid_position()

func restartGame():
	var x = round((player.position.x-512)/grid_size.x)
	var y = round((player.position.y-288)/grid_size.y)
	var new_grid_position = Vector2(x,y)
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	position = grid_position * grid_size

func udpate_grid_position():
	if dontUpdate:
		return
	if !is_instance_valid(player):
		return
	var x = round((player.position.x-512)/grid_size.x)
	var y = round((player.position.y-288)/grid_size.y)
	var new_grid_position = Vector2(x,y)
	if grid_position == new_grid_position:
		return
	grid_position = new_grid_position
	position = grid_position * grid_size

func getGridPos():
	if grid_position == null:
		return Vector2.ZERO
	else:
		return grid_position
