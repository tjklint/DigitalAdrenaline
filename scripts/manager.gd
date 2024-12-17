extends Node

var total_score = 0
var player_lives = 3
var bullets_remaining = 5
var current_level: String = "level_1"

@onready var score_label: Label = $"../CanvasLayer/Control/Score_DY"
@onready var lives_label: Label = $"../CanvasLayer/Control/Lives_DY"
@onready var bullets_label: Label =$"../CanvasLayer/Control/Bullets_DY"

@export var next_level_path: String = "res://scenes/level2.tscn"

const SAVE_FILE = "user://game_progress.cfg"

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
	_save_progress()
	get_tree().change_scene_to_file(next_level_path)

func _save_progress():
	var config = ConfigFile.new()

	config.load(SAVE_FILE)

	config.set_value("progress", current_level + "_completed", true)
	config.set_value("scores", current_level + "_score", total_score)

	config.save(SAVE_FILE)
	print("Progress Saved! Level:", current_level, "| Score:", total_score)


func show_game_over():
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0) 
	add_child(overlay)
	var tween = create_tween()
	tween.tween_property(overlay, "color", Color(0, 0, 0, 1), 1.5)  
	tween.finished.connect(_on_fade_out_finished)

func _on_fade_out_finished():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
