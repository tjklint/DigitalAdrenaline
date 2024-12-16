extends State

var previous_state_path: String
@onready var suck: AudioStreamPlayer2D = $"../../Suck"

func enter(previous_state: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
		print("Player passed to state:", self.name, "| Player:", player)
	else:
		push_error("Player not passed to state.")
	
	previous_state_path = previous_state

	if player:
		player.is_retrieving = true
		player.animated_sprite.play_backwards("shoot")

func physics_update(delta: float):
	if player:
		var bullet_found = false
		for bullet in get_tree().get_nodes_in_group("Bullets"):
			print("Checking bullet:", bullet.name, "| Distance:", bullet.global_position.distance_to(player.global_position))
			if bullet.global_position.distance_to(player.global_position) < bullet.return_range and not bullet.returning:
				bullet_found = true
				bullet.returning = true  
				bullet.player = player 
				player.bullets_remaining += 1 
				suck.play()
				bullet.queue_free()  
				print("Bullet retrieved. Remaining bullets:", player.bullets_remaining)
				break  
		
		if not bullet_found:
			print("No bullets in range to retrieve.")

		player.is_retrieving = false
		emit_signal("finished", previous_state_path)
