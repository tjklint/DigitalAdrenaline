extends State

func enter(previous_state_path: String, data: Dictionary = {}):
	if player:
		player.animated_sprite.play("idle")
		player.velocity.x = 0.0
		print("Entered IdleState")

func physics_update(delta: float):
	var direction = Input.get_axis("move_left", "move_right")
	# Handle movement
	if direction != 0:
		emit_signal("finished", "RunState")

	# Handle jumping
	elif Input.is_action_just_pressed("jump"):
		emit_signal("finished", "JumpState")

	# Handle shooting
	elif Input.is_action_just_pressed("shoot"):
		emit_signal("finished", "ShootState")

	# Handle retrieving bullets
	elif Input.is_action_just_pressed("suck_back"):
		emit_signal("finished", "RetrieveState")
