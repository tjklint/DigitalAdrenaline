extends Node

var total_score = 0
var player_lives = 3
var bullets_remaining = 5

@onready var score_label: Label = $"../CanvasLayer/Control/Score_DY"
@onready var lives_label: Label = $"../CanvasLayer/Control/Lives_DY"
@onready var bullets_label: Label =$"../CanvasLayer/Control/Bullets_DY"

@export var next_level_path: String = "res://scenes/level2.tscn"

func _ready():
	_update_gui()

func add_score(score: int):
	total_score += score
	_update_gui()

func lose_life():
	if player_lives > 0:
		player_lives -= 1
		_update_gui()

func set_bullets(amount: int):
	bullets_remaining = amount
	_update_gui()

func _update_gui():
	score_label.text = str(total_score)
	lives_label.text = str(player_lives)
	bullets_label.text = str(bullets_remaining)

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Level Completed! Loading next level...")
	_save_progress()
	get_tree().change_scene_to_file(next_level_path)

func _save_progress():
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", true)
	config.save("user://game_progress.cfg")
	print("Progress Saved!")

func show_game_over():
	if get_tree():
		print("get_tree() is valid. Changing scene...")
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	else:
		print("Error: get_tree() is null!")
