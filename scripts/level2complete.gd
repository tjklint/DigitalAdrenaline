extends Area2D

@export var next_level_path: String = "res://scenes/thanks.tscn"
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var manager: Node = %Manager
@onready var music: AudioStreamPlayer2D = $"../Music"
@onready var taunt: AudioStreamPlayer2D = $Taunt

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)
	taunt.connect("finished", _on_taunt_finished)  


func _on_body_entered(body):
	print("Level 2 Completed! Saving score and loading next scene...")
	manager.current_level = "level_2"
	manager._save_progress()
	music.stop()
	taunt.play()
	_save_progress(manager.total_score) 

func _save_progress(score: int):
	var config = ConfigFile.new()
	if config.load("user://game_progress.cfg") != OK:
		print("No existing save file. Creating a new one.")

	config.set_value("progress", "level_2_completed", true)
	var existing_score = config.get_value("scores", "level_2_score", 0)
	config.set_value("scores", "level_2_score", max(score, existing_score))  # Keep the best score

	config.save("user://game_progress.cfg")
	print("Progress Saved! Level 2 Score:", score)


func _on_taunt_finished() -> void:
	print("Taunt finished. Loading next level...")
	get_tree().change_scene_to_file("res://scenes/thanks.tscn")
