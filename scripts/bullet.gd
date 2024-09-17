extends CharacterBody2D

var bullet_velocity = Vector2(1, 0)
var speed = 300

func _physics_process(delta: float) -> void:
	# Move the bullet
	var collision_info = move_and_collide(bullet_velocity.normalized() * speed * delta)
	
	# If there's a collision, handle it
	if collision_info:
		# Handle collision here (e.g., destroy the bullet, apply damage, etc.)
		queue_free()  # Destroy the bullet on collision
