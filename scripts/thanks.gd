extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Level Completed! Loading next level...")
		_save_progress()
		get_tree().change_scene_to_file()

func _save_progress():
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", true)
	config.save("user://game_progress.cfg")
	print("Progress Saved!")
