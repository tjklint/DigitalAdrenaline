extends Area2D

@export var next_level_path: String = "res://scenes/thanks.tscn"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var manager: Node = %Manager

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Level 2 Completed! Saving score and loading next scene...")
	manager.current_level = "level_2"
	manager._save_progress()
	get_tree().change_scene_to_file(next_level_path)

func _save_progress(score: int):
	var config = ConfigFile.new()
	config.set_value("progress", "level_2_completed", true)
	config.set_value("scores", "level_2_score", score)
	config.save("user://game_progress.cfg")
	print("Progress Saved! Level 2 Score:", score)
