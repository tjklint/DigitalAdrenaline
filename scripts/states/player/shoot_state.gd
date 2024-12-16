extends State

var previous_state_path: String
@onready var shoot: AudioStreamPlayer2D = $"../../Shoot"

func enter(previous_state: String, data: Dictionary = {}):
	if data.has("player"):
		player = data["player"]
		print("Player passed to state:", self.name, "| Player:", player)
	else:
		push_error("Player not passed to state.")
	
	previous_state_path = previous_state
	
	if player and player.bullets_remaining > 0:
		player.is_shooting = true
		player.animated_sprite.play("shoot")
		shoot.play()
		
		var bullet = player.PROTAG_BULLET.instantiate()
		get_tree().get_root().add_child(bullet)
		bullet.add_to_group("Bullets")
		bullet.position = player.gun_marker.global_position
		bullet.bullet_velocity = Vector2(1 if not player.animated_sprite.flip_h else -1, 0)
		player.bullets_remaining -= 1
		print("Bullet fired. Remaining bullets:", player.bullets_remaining)
	else:
		print("No bullets remaining. Returning to:", previous_state_path)
		emit_signal("finished", previous_state_path)

func physics_update(delta: float):
	if player and not player.is_shooting:
		print("Shooting finished. Returning to:", previous_state_path)
		emit_signal("finished", previous_state_path)
