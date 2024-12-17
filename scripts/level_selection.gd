extends Control

@export var scroll_speed = Vector2(20, 0)
@onready var parallax_background = $ParallaxBackground

@onready var level1_button: Button = $Camera2D/Control/Level1
@onready var level2_button: Button = $Camera2D/Control/Level2

const SAVE_FILE = "user://game_progress.cfg"

var progress = {"level_1_completed": false}

func _ready():
	_load_progress()
	_update_level_buttons()

func _process(delta: float) -> void:
	parallax_background.scroll_offset += scroll_speed * delta

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
	 

func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level2.tscn")

func _load_progress():
	var config = ConfigFile.new()
	if config.load(SAVE_FILE) == OK:
		progress["level_1_completed"] = config.get_value("progress", "level_1_completed", false)
		print("Progress Loaded:", progress)
	else:
		print("No save file found. Default progress:", progress)

func _save_progress():
	var config = ConfigFile.new()
	config.set_value("progress", "level_1_completed", progress["level_1_completed"])
	config.save(SAVE_FILE)
	print("Progress Saved:", progress)

func _update_level_buttons():
	if level1_button:
		level1_button.disabled = false  
	else:
		print("Level1 button not found.")
	
	if level2_button:
		level2_button.disabled = not progress["level_1_completed"]
		print("Level2 Disabled:", level2_button.disabled)
	else:
		print("Level2 button not found.")

func on_level_1_completed():
	progress["level_1_completed"] = true
	_save_progress()
	_update_level_buttons()
