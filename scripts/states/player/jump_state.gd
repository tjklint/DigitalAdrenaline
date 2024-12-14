extends State

func enter(previous_state_path: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
		print("Player passed to state:", self.name, "| Player:", player)
	else:
		push_error("Player not passed to state.")
		
	if player:
		player.velocity.y = player.JUMP_VELOCITY
		player.animated_sprite.play("jump")

func physics_update(delta: float):
	print("Just entered jumping state")
	if player.velocity.y > 0:
		emit_signal("finished", "FallState")

	# Handle shooting mid-air
	elif Input.is_action_just_pressed("shoot"):
		emit_signal("finished", "ShootState")
		
	# Handle retrieving bullets
	elif Input.is_action_just_pressed("suck_back"):
		emit_signal("finished", "RetrieveState")
