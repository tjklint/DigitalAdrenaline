extends Control

@export var scroll_speed = Vector2(20, 0)
@onready var parallax_background = $ParallaxBackground

func _process(delta: float) -> void:
	parallax_background.scroll_offset += scroll_speed * delta

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
