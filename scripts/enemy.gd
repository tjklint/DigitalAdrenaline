extends CharacterBody2D
class_name Enemy

var start_position: Vector2
var direction: int = -1

func _ready():
	start_position = global_position
	
func die():
	queue_free()
