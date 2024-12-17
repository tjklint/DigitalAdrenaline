extends AnimatableBody2D

@export var move_distance := Vector2(330, 0)  # Distance to move (e.g., 200 pixels horizontally)
@export var move_duration := 2.0  # Time in seconds for one full move
@export var loop := true  # If the platform should loop back and forth

func _ready():
	_start_moving_platform()

func _start_moving_platform():
	# Create the tween
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	# Move to the target position
	var start_position = position
	var target_position = position + move_distance
	
	tween.tween_property(self, "position", target_position, move_duration)
	
	# Return to the start position if looping
	if loop:
		tween.tween_property(self, "position", start_position, move_duration)
		tween.finished.connect(_start_moving_platform)  # Restart the movement loop
