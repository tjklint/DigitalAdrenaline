extends AnimatableBody2D

@export var move_distance := Vector2(330, 0)  
@export var move_duration := 2.0  
@export var loop := true 

func _ready():
	_start_moving_platform()

func _start_moving_platform():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	var start_position = position
	var target_position = position + move_distance
	
	tween.tween_property(self, "position", target_position, move_duration)
	
	if loop:
		tween.tween_property(self, "position", start_position, move_duration)
		tween.finished.connect(_start_moving_platform) 
