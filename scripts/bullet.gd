extends CharacterBody2D

var bullet_velocity = Vector2(1, 0)
var speed = 300
var has_bounced = false  # Tracks if the bullet has already bounced

func _physics_process(delta: float) -> void:
	# Move the bullet and check for collision
	var collision_info = move_and_collide(bullet_velocity.normalized() * delta * speed)
	
	if collision_info:
		if not has_bounced:
			# Reverse bullet's velocity for a bounce
			bullet_velocity = -bullet_velocity
			has_bounced = true  # Set the bounce flag so it only bounces once
		else:
			# If it has already bounced once, destroy the bullet
			queue_free()
