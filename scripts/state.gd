class_name State extends Node

signal finished(next_state_path: String, data: Dictionary)

var player: Player = null

func enter(previous_state_path: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
		print("Player passed to state:", self.name, "| Player:", player)
	else:
		push_error("Player not passed to state.")

func exit():
	pass

func handle_input(event: InputEvent):
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	pass
