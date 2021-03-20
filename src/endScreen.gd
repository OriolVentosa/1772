extends Node2D

var children = 4
var dealed = "Yes"

onready var childrenCount = get_node("Control/ChildrenCount")
onready var dealedWithChildren = get_node("Control/DealedWithChildren")
func _ready():
	childrenCount.text = str(children)
	dealedWithChildren.text = dealed
