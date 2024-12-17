extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var manager: Node = %Manager

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Level 1 Completed! Saving score and loading next level...")
	_save_progress(manager.total_score) 

func _save_progress(score: int):
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", true)
	config.set_value("scores", "level_1_score", score)
	config.save("user://game_progress.cfg")
	print("Progress Saved! Level 1 Score:", score)
