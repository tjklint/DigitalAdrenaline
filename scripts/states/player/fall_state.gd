extends State

func enter(previous_state_path: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
		print("Player passed to state:", self.name, "| Player:", player)
	else:
		push_error("Player not passed to state.")
	
	player.animated_sprite.play("fall")
	print("Entered FallState.")

func physics_update(delta: float):
	print("Just entered falling state")

	# Handle landing
	if player.is_on_floor():
		if Input.get_axis("move_left", "move_right") == 0:
			emit_signal("finished", "IdleState")
		else:
			emit_signal("finished", "RunState")

	# Handle shooting mid-air
	elif Input.is_action_just_pressed("shoot"):
		emit_signal("finished", "ShootState")
		
	# Handle retrieving bullets
	elif Input.is_action_just_pressed("suck_back"):
		emit_signal("finished", "RetrieveState")
