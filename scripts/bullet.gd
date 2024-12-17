extends CharacterBody2D
class_name bullet

var bullet_velocity = Vector2(1, 0)
var speed = 200
var has_bounced = false  
var returning = false

@export var return_range = 75.0
var player: CharacterBody2D = null

func _physics_process(delta: float) -> void:
	if returning:
		# Move toward player
		if player:
			var direction = (player.global_position - global_position).normalized()
			position += direction * speed * delta
			# Check if bullet has reached the player
			if global_position.distance_to(player.global_position) < 10.0:
				queue_free()  # Consume bullet
		return

	var collision = move_and_collide(bullet_velocity.normalized() * speed * delta)
	if collision:
		var body = collision.get_collider()
		if body is Enemy:
			body.die()
			queue_free()
		elif body is Player:
			queue_free()
	
		if has_bounced:
			queue_free()
		else: 
			bullet_velocity = -bullet_velocity
			has_bounced = true
	else:
		position += bullet_velocity.normalized() * speed * delta
