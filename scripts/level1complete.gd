extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var manager: Node = %Manager
@onready var taunt: AudioStreamPlayer2D = $Taunt
@onready var music: AudioStreamPlayer2D = $"../Music"

func _ready():
	if collision_shape:
		collision_shape.disabled = false  
	connect("body_entered", _on_body_entered)
	taunt.connect("finished", _on_taunt_finished)  

func _on_body_entered(body):
	print("Level 1 Completed! Saving score and playing taunt...")
	music.stop()
	taunt.play()
	_save_progress(manager.total_score) 

func _save_progress(score: int):
	var config = ConfigFile.new()
	if config.load("user://game_progress.cfg") != OK:
		print("No existing save file. Creating a new one.")

	config.set_value("progress", "level_1_completed", true)
	var existing_score = config.get_value("scores", "level_1_score", 0)
	config.set_value("scores", "level_1_score", max(score, existing_score))  # Keep the best score

	config.save("user://game_progress.cfg")
	print("Progress Saved! Level 1 Score:", score)


func _on_taunt_finished():
	print("Taunt finished. Loading next level...")
	get_tree().change_scene_to_file("res://scenes/level2.tscn")
