extends CharacterBody2D
class_name Enemy

@onready var manager: Node = %Manager

var start_position: Vector2
var direction: int = -1

func _ready():
	start_position = global_position
	
func die():
	manager.add_score(200)
	queue_free()
