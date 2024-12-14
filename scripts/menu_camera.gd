extends Camera2D

var scroll_speed = Vector2(50, 0)  

func _process(delta: float) -> void:
	position += scroll_speed * delta
