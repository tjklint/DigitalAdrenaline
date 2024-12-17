extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Level Completed! Loading next level...")
	_save_progress()
	get_tree().change_scene_to_file("res://scenes/thanks.tscn")

func _save_progress():
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", true)
	config.save("user://game_progress.cfg")
	print("Progress Saved!")
