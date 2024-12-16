extends Node

var total_score = 0
@onready var score_dy: Label = $"../CharacterBody2D/Camera2D/Score_DY"

func add_score(score: int):
	total_score += score
	score_dy.text = str(total_score)
