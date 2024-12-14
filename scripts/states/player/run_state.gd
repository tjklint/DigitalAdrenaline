extends State

func enter(previous_state_path: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
	else:
		push_error("RunState: 'player' not found in data dictionary.")
		return

	player.animated_sprite.play("run")
	print("Entered RunState.")
	
func physics_update(delta: float):
	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = direction * player.SPEED

	# Handle stopping
	if direction == 0:
		emit_signal("finished", "IdleState")

	# Handle jumping
	elif Input.is_action_just_pressed("jump"):
		emit_signal("finished", "JumpState")

	# Handle falling
	elif not player.is_on_floor():
		emit_signal("finished", "FallState")

	# Handle shooting
	elif Input.is_action_just_pressed("shoot"):
		emit_signal("finished", "ShootState")

	# Handle retrieving bullets
	elif Input.is_action_just_pressed("suck_back"):
		emit_signal("finished", "RetrieveState")
