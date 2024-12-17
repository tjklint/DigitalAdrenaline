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
		# Connect signal safely with CONNECT_ONE_SHOT to avoid duplicates
		if not player.animated_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
			player.animated_sprite.connect("animation_finished", Callable(self, "_on_animation_finished"), CONNECT_ONE_SHOT)

func physics_update(delta: float):
	if player:
		for bullet in get_tree().get_nodes_in_group("Bullets"):
			print("Checking bullet:", bullet.name, "| Distance:", bullet.global_position.distance_to(player.global_position))
			if bullet.global_position.distance_to(player.global_position) < bullet.return_range and not bullet.returning:
				bullet.returning = true  
				bullet.player = player 
				player.bullets_remaining += 1 
				suck.play()
				bullet.queue_free()  
				print("Bullet retrieved. Remaining bullets:", player.bullets_remaining)
				return  

func _on_animation_finished():
	if player:
		player.is_retrieving = false
		emit_signal("finished", previous_state_path)
		print("Retrieving animation finished. Returning to:", previous_state_path)

func exit():
	# Disconnect the animation_finished signal to avoid conflicts
	if player and player.animated_sprite.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animated_sprite.disconnect("animation_finished", Callable(self, "_on_animation_finished"))
